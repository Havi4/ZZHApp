//
//  AppDelegate.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/3.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "AppDelegate.h"
#import "LeftSideViewController.h"
#import "BaseNaviViewController.h"
#import "ZWIntroductionViewController.h"
#import "LoginViewController.h"
#import "LaunchStartView.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import "Reachability.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "ThirdLoginCallBackManager.h"
#import "JPushNotiManager.h"
#import "PinLockSetting.h"
#import "ZZHRootViewController.h"
#import "CCLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "GetWeatherAPI.h"
#import "LoginBackViewController.h"

@interface AppDelegate ()<CLLocationManagerDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) ZWIntroductionViewController *introductionView;
@property (nonatomic, strong) ZZHRootViewController *rootView;
@property (nonatomic, assign) BOOL isIn;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self setWifiNotification];
    [self setAppSetting];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{kAppIntroduceViewKey:@NO}];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self setThirdAppSettingWith:launchOptions];
    self.isIn = YES;
    
    if ([UserManager GetUserObj]) {
//        [self getUserAccessTockenWith:launchOptions];//获取tocken时候开启，下面四行关闭
        [self setRootViewController];
        [self getUserLocationWith:launchOptions];
        [self getSuggestionList];
        [self uploadRegisterID];
//        LoginBackViewController *back = [[LoginBackViewController alloc]init];
//        self.window.rootViewController = back;
    }else{
        LoginViewController *login = [[LoginViewController alloc]init];
        
        @weakify(self);
        login.loginButtonClicked = ^(NSUInteger index){
            @strongify(self);
            [self setRootViewController];
            [self getUserLocationWith:launchOptions];
            [self getSuggestionList];
            [self uploadRegisterID];
        };
        self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:login];
    }
    //状态栏
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    //
    [self.window makeKeyAndVisible];
//    [self setNetworkNoti];
    [self setIntroduceView];
    [PinLockSetting sharedInstance];
    
    
    //启动基本SDK
//    [[PgyManager sharedPgyManager] startManagerWithAppId:@"7eb7c775936eef758a5314cd4349f236"];
    //启动更新检查SDK
//    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:@"PGY_APP_ID"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.9*60*60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshAccessTocken];
    });
    //自定义消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                      selector:@selector(networkDidReceiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
    return YES;
}

- (void)refreshAccessTocken
{
    ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
    [client requestServerTimeWithBlock:^(ServerTimeModel *serVerTime, NSError *error) {
        if (!error) {
            DeBugLog(@"服务器时间是%@",serVerTime.serverTime);
            if (serVerTime.serverTime.length==0) {
                return;
            }
            NSDateFormatter *date = [[NSDateFormatter alloc]init];
            [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *n = [date dateFromString:serVerTime.serverTime];
            NSInteger time = [n timeIntervalSince1970];
            NSString *atTime = [NSString stringWithFormat:@"%@%@%@%@%@%@",[serVerTime.serverTime substringWithRange:NSMakeRange(0, 4)],[serVerTime.serverTime substringWithRange:NSMakeRange(5, 2)],[serVerTime.serverTime substringWithRange:NSMakeRange(8, 2)],[serVerTime.serverTime substringWithRange:NSMakeRange(11, 2)],[serVerTime.serverTime substringWithRange:NSMakeRange(14, 2)],[serVerTime.serverTime substringWithRange:NSMakeRange(17, 2)]];
            NSString *md5OriginalString = [NSString stringWithFormat:@"ZZHAPI:%@:%@",thirdPartyLoginUserId,atTime];
            NSString *md5String = [md5OriginalString md5String];
            NSDictionary *dic = @{
                                  @"UserId": thirdPartyLoginUserId,
                                  @"Atime": [NSNumber numberWithInteger:(time)],
                                  @"MD5":[md5String uppercaseString],
                                  };
            [client requestAccessTockenWithParams:dic withBlock:^(AccessTockenModel *serVerTime, NSError *error) {
                if (!error) {
                    accessTocken = serVerTime.accessTockenString;
                    [[[HaviNetWorkAPIClient sharedJSONClient] requestSerializer]setValue:accessTocken forHTTPHeaderField:@"AccessToken"];
                }else{
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"错误" message:@"验证用户失败,请重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    alertView.tag = 102;
                    [alertView show];
                }
            }];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"错误" message:@"验证用户失败,请重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            alertView.tag = 102;
            [alertView show];
        }
    }];

}

- (void)getUserAccessTockenWith:(NSDictionary *)launchOptions
{
    ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
    [client requestServerTimeWithBlock:^(ServerTimeModel *serVerTime, NSError *error) {
        if (!error) {
            DeBugLog(@"服务器时间是%@",serVerTime.serverTime);
            if (serVerTime.serverTime.length==0) {
                return;
            }
            NSDateFormatter *date = [[NSDateFormatter alloc]init];
            [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *n = [date dateFromString:serVerTime.serverTime];
            NSInteger time = [n timeIntervalSince1970];
            NSString *atTime = [NSString stringWithFormat:@"%@%@%@%@%@%@",[serVerTime.serverTime substringWithRange:NSMakeRange(0, 4)],[serVerTime.serverTime substringWithRange:NSMakeRange(5, 2)],[serVerTime.serverTime substringWithRange:NSMakeRange(8, 2)],[serVerTime.serverTime substringWithRange:NSMakeRange(11, 2)],[serVerTime.serverTime substringWithRange:NSMakeRange(14, 2)],[serVerTime.serverTime substringWithRange:NSMakeRange(17, 2)]];
            NSString *md5OriginalString = [NSString stringWithFormat:@"ZZHAPI:%@:%@",thirdPartyLoginUserId,atTime];
            NSString *md5String = [md5OriginalString md5String];
            NSDictionary *dic = @{
                                  @"UserId": thirdPartyLoginUserId,
                                  @"Atime": [NSNumber numberWithInteger:(time)],
                                  @"MD5":[md5String uppercaseString],
                                  };
            [client requestAccessTockenWithParams:dic withBlock:^(AccessTockenModel *serVerTime, NSError *error) {
                if ([serVerTime.returnCode intValue]==200) {
                    accessTocken = serVerTime.accessTockenString;
                    [[[HaviNetWorkAPIClient sharedJSONClient] requestSerializer]setValue:accessTocken forHTTPHeaderField:@"AccessToken"];
                    dispatch_async_on_main_queue(^{
                        [self setRootViewController];
                        [self getUserLocationWith:launchOptions];
                        [self getSuggestionList];
                        [self uploadRegisterID];
                    });
                }else{
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"错误" message:@"验证用户失败,请重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    alertView.tag = 101;
                    [alertView show];
                }
            }];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"错误" message:@"验证用户失败,请重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            alertView.tag = 101;
            [alertView show];
        }
    }];
}

- (void)setRootWithOptions:(NSDictionary *)launchOptions
{
    [self setRootViewController];
    [self getUserLocationWith:launchOptions];
}
#pragma mark settings
- (void)getUserLocationWith:(NSDictionary *)launchOptions
{
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    if ([[UIDevice currentDevice] systemVersion].doubleValue > 8.0) {//如果iOS是8.0以上版本
        if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {//位置管理对象中有requestAlwaysAuthorization这个方法
            [_locationManager requestWhenInUseAuthorization];
        }
    }
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];

}
//获取城市
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    if (newLocation) {
        [manager stopUpdatingLocation];
    }
    @weakify(self);
    
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            //将获得的所有信息显示到label上
            //            self.location.text = placemark.name;
            //获取城市
            NSString *city = placemark.locality;
            NSString *province = placemark.administrativeArea;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            
            if (city && self.isIn) {
                @strongify(self);
                self.isIn = NO;
                [self sendLocationWith:city andProvie:province];
            }
        }
        else if (error == nil && [array count] == 0)
        {
            DeBugLog(@"No results were returned.");
        }
        else if (error != nil)
        {
            DeBugLog(@"An error occurred = %@", error);
        }
    }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}

- (void)sendLocationWith:(NSString *)city andProvie:(NSString *)province
{
    [[NSNotificationCenter defaultCenter]postNotificationName:kGetCurrentCity object:nil userInfo:@{@"city":[city substringToIndex:city.length-1]}];
    [[NSUserDefaults standardUserDefaults]registerDefaults:@{@"city":@""}];
    [[NSUserDefaults standardUserDefaults]setObject:[city substringToIndex:city.length-1] forKey:@"city"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSDictionary *dic19 = @{
                            @"city" : [city substringToIndex:city.length-1],
                            @"province": [province substringToIndex:city.length-1]
                            };
    [GetWeatherAPI getWeatherInfoWith:dic19 finished:^(NSURLResponse *response, NSData *data) {
        NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        DeBugLog(@"天气是%@",weatherDic);
        [[NSNotificationCenter defaultCenter]postNotificationName:kGetWeatherData object:nil userInfo:@{@"data":data}];
    } failed:^(NSURLResponse *response, NSError *error) {
        
    }];

}
- (void)setRootViewController
{
    
    /*
    self.centerView = [[CenterViewController alloc]init];
    self.sideMenuController = [[JASidePanelController alloc] init];
    self.sideMenuController.shouldDelegateAutorotateToVisiblePanel = NO;
    self.sideMenuController.recognizesPanGesture = NO;
    
    self.sideMenuController.leftPanel = [[LeftSideViewController alloc] init];
    self.sideMenuController.centerPanel = [[BaseNaviViewController alloc] initWithRootViewController:self.centerView];
    self.window.rootViewController = self.sideMenuController;
     */
    self.rootView = [[ZZHRootViewController alloc] init];
    self.window.rootViewController = self.rootView;
    

}

- (void)setLoginViewController
{
    LoginViewController *login = [[LoginViewController alloc]init];
    @weakify(self);
    login.loginButtonClicked = ^(NSUInteger index){
        @strongify(self);
        [self setRootViewController];
    };
    self.window.rootViewController = nil;
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:login];
}

- (void)setThirdAppSettingWith:(NSDictionary *)launchOptions
{
    
    [[ThirdLoginCallBackManager sharedInstance]initTencentCallBackHandle];
    //微博注册
    [WeiboSDK registerApp:kWBAPPKey];
    [WeiboSDK enableDebugMode:YES];
    //向微信注册
    [WXApi registerApp:kWXAPPKey];
    //因为有闹钟的印象，清楚闹钟。
    [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
    [JPUSHService setupWithOption:launchOptions appKey:@"ea0d704f24539eb667b81002" channel:@"Publish channel" apsForProduction:YES];
    [JPUSHService crashLogON];

}

#pragma mark 网络监听
-(void) setWifiNotification {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CTTelephonyNetworkInfo *telephonyInfo = [CTTelephonyNetworkInfo new];
        NSLog(@"Current Radio Access Technology: %@", telephonyInfo.currentRadioAccessTechnology);
        [NSNotificationCenter.defaultCenter addObserverForName:CTRadioAccessTechnologyDidChangeNotification
                                                        object:nil
                                                         queue:nil
                                                    usingBlock:^(NSNotification *note)
         {
             NSLog(@"New Radio Access Technology: %@", telephonyInfo.currentRadioAccessTechnology);
         }];
        @try {
            
            Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(reachabilityChanged:)
                                                         name:kReachabilityChangedNotification
                                                       object:nil];
            reach.reachableBlock = ^(Reachability * reachability)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"Block Says Reachable");
                });
            };
            
            reach.unreachableBlock = ^(Reachability * reachability)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"Block Says Unreachable");
                });
            };
            [reach startNotifier];
        }@catch (NSException *e) {
            ;
        }
    });
}

-(void)reachabilityChanged:(NSNotification*)note
{
    @try {
        Reachability * reach = [note object];
        netReachability = reach;
        if ([reach isReachable]) {
//            if ([reach isReachableViaWiFi]) {
//                [[UIApplication sharedApplication].keyWindow makeToast:@"您已切换至Wifi网络" duration:1.5 position:@"center"];
//            }else if ([reach isReachableViaWWAN]){
//                if ([[reach currentReachabilityFrom234G]isEqualToString:@"2G"]) {
//                    
//                    [[UIApplication sharedApplication].keyWindow makeToast:@"您已切换至2G网络" duration:1.5 position:@"center"];
//                }else if ([[reach currentReachabilityFrom234G]isEqualToString:@"3G"]) {
//                    [[UIApplication sharedApplication].keyWindow makeToast:@"您已切换至3G网络" duration:1.5 position:@"center"];
//                }else if ([[reach currentReachabilityFrom234G]isEqualToString:@"4G"]){
//                    [[UIApplication sharedApplication].keyWindow makeToast:@"您已切换至4G网络" duration:1.5 position:@"center"];
//                    
//                }
//            }
        }else {
            
            [[UIApplication sharedApplication].keyWindow makeToast:@"没有网络,请检查您的网络！" duration:1.5 position:@"center"];
        }
    } @catch (NSException *e) {
        ;
    }
}

- (void)setNetworkNoti
{
    YYReachability *reachablity = [YYReachability reachabilityWithHostname:@"www.baidu.com"];
    reachablity.notifyBlock = ^(YYReachability *reachability){
        if (reachablity.status == YYReachabilityStatusNone) {
            [NSObject showHudTipStr:@"您的手机没有网络,请检查您的网络"];
        }else if (reachablity.status == YYReachabilityStatusWWAN){
            if (reachablity.wwanStatus == YYReachabilityWWANStatus2G) {
                [NSObject showHudTipStr:@"您正在使用手机2G网络"];
            }else if (reachablity.wwanStatus == YYReachabilityWWANStatus3G){
                [NSObject showHudTipStr:@"您正在使用手机3G网络"];
            }else if (reachablity.wwanStatus == YYReachabilityWWANStatus4G){
                [NSObject showHudTipStr:@"您正在使用手机4G网络"];
            }
            
        }
    };
}


- (void)registerLocalNotification
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_

        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound |UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
    }else {
        //ios7注册推送通知
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
}

- (void)setAppSetting
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *dataPath = [[NSBundle mainBundle]pathForResource:@"ReturnCode" ofType:@"plist"];
        returnErrorMessage = [NSDictionary dictionaryWithContentsOfFile:dataPath];
    });
    int picIndex = [ThemeSelectConfigureObj defaultConfigure].nThemeIndex;
    selectedThemeIndex = picIndex;
    if (selectedThemeIndex == 0) {
        [DKNightVersionManager dawnComing];
    } else {
        [DKNightVersionManager nightFalling];
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[NSUserDefaults standardUserDefaults]registerDefaults:@{kAppPassWordKeyNoti : @"NO"}];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark 设置引导画面

- (void)setIntroduceView
{
    BOOL hasSet = [[NSUserDefaults standardUserDefaults]boolForKey:kAppIntroduceViewKey];
    if (hasSet) {
        return;
    }
    
    NSArray *coverImageNames = @[@"IntroduceView1", @"IntroduceView2", @"IntroduceView3"];
    NSArray *backgroundImageNames = @[@"back.png", @"back.png", @"back.png"];
    
    self.introductionView = [[ZWIntroductionViewController alloc] initWithCoverImageNames:coverImageNames backgroundImageNames:backgroundImageNames];
    [self.window addSubview:self.introductionView.view];
    
    __weak AppDelegate *weakSelf = self;
    self.introductionView.didSelectedEnter = ^() {
        weakSelf.introductionView = nil;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kAppIntroduceViewKey];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    };

}

#pragma mark 获取专家建议表
- (void)getSuggestionList
{
    ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
    [client requestAssessmentListWithBlock:^(AssessmentListModel *assessList, NSError *error) {        
    }];
    

}

- (void)uploadRegisterID
{
    NSString *registerID = [JPUSHService registrationID];
    for (int i=0; i<3; i++) {
        if (registerID.length > 0) {
            if (thirdPartyLoginUserId.length == 0) {
                return;
            }
            NSDictionary *dic = @{
                                  @"UserId": thirdPartyLoginUserId, //关键字，必须传递
                                  @"PushRegistrationId": registerID, //密码
                                  @"AppVersion" : [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                                  @"OSName" : @"iOS",
                                  @"OSVersion" : [UIDevice currentDevice].systemVersion,
                                  @"CellPhoneModal" : [UIDevice currentDevice].machineModelName,
                                  @"OffLine": @"0"
                                  };
            ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
            [client requestRegisterUserIdForPush:dic andBlock:^(BaseModel *baseModel, NSError *error) {
            }];
        }
    }
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [application setApplicationIconBadgeNumber:0];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification*)notification

{
}

#pragma mark 第三方回调函数
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    //wb2199355574://response?id=C332B448-99AA-48CB-9588-D18D3F122F9D&sdkversion=2.5
    //
    NSRange range = [[NSString stringWithFormat:@"%@",url]rangeOfString:@"://"];
    if ([[[NSString stringWithFormat:@"%@",url] substringToIndex:range.location]isEqualToString:@"wb2199355574"]) {
        return [[ThirdLoginCallBackManager sharedInstance]weiboCallBackHandleOpenURL:url];
    }else if([[[NSString stringWithFormat:@"%@",url] substringToIndex:range.location]isEqualToString:@"wx7be2e0c9ebd9e161"]){
        return  [[ThirdLoginCallBackManager sharedInstance] weixinCallBackHandleOpenURL:url];
    }else{
        return YES;
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //从第三方回来
    if ([sourceApplication isEqualToString:@"com.tencent.xin"]) {
        return  [[ThirdLoginCallBackManager sharedInstance] weixinCallBackHandleOpenURL:url];;
    }else if ([sourceApplication isEqualToString:@"com.sina.weibo"]){
        return [[ThirdLoginCallBackManager sharedInstance]weiboCallBackHandleOpenURL:url];
    }else if ([sourceApplication isEqualToString:@"com.tencent.mqq"]){
        return [[ThirdLoginCallBackManager sharedInstance]tencentCallBackHandleOpenURL:url];
    }
    return YES;
}

#pragma mark 推送
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
    registeredID = [JPUSHService registrationID];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    JPushNotiManager *manager = [JPushNotiManager sharedInstance];
    [manager handPushApplication:application receiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler
{
    JPushNotiManager *manager = [JPushNotiManager sharedInstance];
    [manager handPushApplication:application receiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101) {
        
        [self getUserAccessTockenWith:nil];
    }else{
        [self refreshAccessTocken];
    }
}

- (void)networkDidReceiveMessage:(NSNotification *)notification
{
    JPushNotiManager *manager = [JPushNotiManager sharedInstance];
    [manager handJPushMessage:notification];
}

@end
