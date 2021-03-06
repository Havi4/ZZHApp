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

@interface AppDelegate ()

@property (nonatomic, strong) ZWIntroductionViewController *introductionView;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self setAppSetting];
//    [self registerLocalNotification];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{kAppIntroduceViewKey:@NO}];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self setThirdAppSettingWith:launchOptions];
    [self getSuggestionList];
    
    if ([UserManager GetUserObj]) {
        [self setRootViewController];
    }else{
        LoginViewController *login = [[LoginViewController alloc]init];
        @weakify(self);
        login.loginButtonClicked = ^(NSUInteger index){
            @strongify(self);
            [self setRootViewController];
        };
        self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:login];
    }
    //状态栏
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    //
    [self.window makeKeyAndVisible];
//    [self setNetworkNoti];
    [self setWifiNotification];
    [self setIntroduceView];
    [PinLockSetting sharedInstance];
    [self uploadRegisterID];
    
    //启动基本SDK
//    [[PgyManager sharedPgyManager] startManagerWithAppId:@"7eb7c775936eef758a5314cd4349f236"];
    //启动更新检查SDK
//    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:@"PGY_APP_ID"];
    return YES;
}

#pragma mark settings

- (void)setRootViewController
{
    
    self.centerView = [[CenterViewController alloc]init];
    self.sideMenuController = [[JASidePanelController alloc] init];
    self.sideMenuController.shouldDelegateAutorotateToVisiblePanel = NO;
    self.sideMenuController.recognizesPanGesture = NO;
    
    self.sideMenuController.leftPanel = [[LeftSideViewController alloc] init];
    self.sideMenuController.centerPanel = [[BaseNaviViewController alloc] initWithRootViewController:self.centerView];
    self.window.rootViewController = self.sideMenuController;

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
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
    [APService setupWithOption:launchOptions];
    [APService crashLogON];
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
        
        if ([reach isReachable]) {
            if ([reach isReachableViaWiFi]) {
                [[UIApplication sharedApplication].keyWindow makeToast:@"您已切换至Wifi网络" duration:3 position:@"center"];
            }else if ([reach isReachableViaWWAN]){
                if ([[reach currentReachabilityFrom234G]isEqualToString:@"2G"]) {
                    
                    [[UIApplication sharedApplication].keyWindow makeToast:@"您已切换至2G网络" duration:3 position:@"center"];
                }else if ([[reach currentReachabilityFrom234G]isEqualToString:@"3G"]) {
                    [[UIApplication sharedApplication].keyWindow makeToast:@"您已切换至3G网络" duration:3 position:@"center"];
                }else if ([[reach currentReachabilityFrom234G]isEqualToString:@"4G"]){
                    [[UIApplication sharedApplication].keyWindow makeToast:@"您已切换至4G网络" duration:3 position:@"center"];
                    
                }
            }
        }else {
            [[UIApplication sharedApplication].keyWindow makeToast:@"没有网络,请检查您的网络！" duration:3 position:@"center"];
        }
    } @catch (NSException *e) {
        ;
    }
}

- (void)setNetworkNoti
{
    YYReachability *reachablity = [YYReachability reachabilityWithHostname:@"www.baidu.com"];
    reachablity.notifyBlock = ^(YYReachability *reachability){
        netReachability = reachablity;
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
    NSArray *coverImageNames = @[@"font_1_min", @"font_2_min", @"font_3_min"];
    NSArray *backgroundImageNames = @[@"pic_introduce_1", @"pic_introduce_2", @"pic_introduce_3"];
    
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
    //因为在主界面进行切换设备，没有办法进行更新
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadUserDevice) name:kUserChangeUUIDInCenterView object:nil];//主界面切换设备

}

- (void)reloadUserDevice
{
    self.sideMenuController.centerPanel = nil;
    self.centerView = nil;
    self.centerView = [[CenterViewController alloc]init];
    self.sideMenuController.centerPanel = [[UINavigationController alloc]initWithRootViewController:self.centerView];
}

- (void)uploadRegisterID
{
    NSString *registerID = [APService registrationID];
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
    [APService registerDeviceToken:deviceToken];
    registeredID = [APService registrationID];
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

@end
