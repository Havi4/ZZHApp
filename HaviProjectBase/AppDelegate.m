//
//  AppDelegate.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/3.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "LeftSideViewController.h"
#import "CenterViewController.h"
#import "BaseNaviViewController.h"
#import "ZWIntroductionViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong) ZWIntroductionViewController *introductionView;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self setAppSetting];
    [self registerLocalNotification];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.sideMenuController = [[JASidePanelController alloc] init];
    self.sideMenuController.shouldDelegateAutorotateToVisiblePanel = NO;
    
    self.sideMenuController.leftPanel = [[LeftSideViewController alloc] init];
    self.sideMenuController.centerPanel = [[BaseNaviViewController alloc] initWithRootViewController:[[CenterViewController alloc] init]];
    
    self.window.rootViewController = self.sideMenuController;
    //状态栏
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    //
    [self.window makeKeyAndVisible];
    [self setIntroduceView];
    return YES;
}

#pragma mark settings

- (void)registerLocalNotification
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound |UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
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
}

#pragma mark 设置引导画面

- (void)setIntroduceView
{
    BOOL hasSet = [[NSUserDefaults standardUserDefaults]objectForKey:kAppIntroduceViewKey];
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

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"接收到本地提醒 in app"
                          
                                                    message:notification.alertBody
                          
                                                   delegate:nil
                          
                                          cancelButtonTitle:@"确定"
                          
                                          otherButtonTitles:nil];
    
    [alert show];
    
    //这里，你就可以通过notification的useinfo，干一些你想做的事情了
    
    application.applicationIconBadgeNumber -= 1;
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"收到");
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"收到");
}


@end
