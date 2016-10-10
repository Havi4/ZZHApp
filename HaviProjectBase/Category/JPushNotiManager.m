//
//  JPushNotiManager.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/29.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "JPushNotiManager.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "LeftSideViewController.h"
#import "XHDemoWeChatMessageTableViewController.h"
#import "RxWebViewController.h"
#import "ConversationListViewController.h"
#import "TSMessage.h"
#import "CWStatusBarNotification.h"
#import "NotiView.h"

static JPushNotiManager *shareInstance = nil;

@interface JPushNotiManager ()

@property (strong, nonatomic) CWStatusBarNotification *notification;

@end

@implementation JPushNotiManager

- (CWStatusBarNotification *)notification
{
    if (!_notification) {
        _notification = [CWStatusBarNotification new];
        
        // set default blue color (since iOS 7.1, default window tintColor is black)
//        _notification.notificationLabelBackgroundColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
        _notification.notificationAnimationInStyle = CWNotificationAnimationStyleTop;
        _notification.notificationAnimationOutStyle = CWNotificationAnimationStyleBottom;
        _notification.notificationStyle = CWNotificationStyleNavigationBarNotification;
    }
    return _notification;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[JPushNotiManager alloc]init];
    });
    return shareInstance;
}

- (void)handPushApplication:(UIApplication *)application receiveRemoteNotification:(NSDictionary *)userInfo
{
    [JPUSHService handleRemoteNotification:userInfo];
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
//        [self playSound];
    }
}

- (void)handPushApplication:(UIApplication *)application receiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [JPUSHService handleRemoteNotification:userInfo];
    NSString *alertString = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    NSString *key = [userInfo objectForKey:@"message_type"];
    switch ([key intValue]) {
        case 101:{
            //离床警报
            if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
                [self playSound];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:alertString message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                alert.tag = 101;
                [alert show];
            }
        } break;
        case 102:{
            //上床警报
        } break;
        case 103:{
            if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
                [self playSound];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:alertString message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                alert.tag = 103;
                [alert show];
            }
            //久睡警报
        } break;
        case 104:{
            //心率异常
        } break;
        case 105:{
            //呼吸异常
        } break;
        case 106:{
            NSInteger badage = application.applicationIconBadgeNumber;
             AppDelegate *app = [UIApplication sharedApplication].delegate;
            if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
                [(LeftSideViewController *)app.sideMenuController.leftPanel showBadageValue:[NSString stringWithFormat:@"%d",1]];
            }else if (badage > 0) {
                [(LeftSideViewController *)app.sideMenuController.leftPanel showBadageValue:[NSString stringWithFormat:@"%d",1]];
            }
            //好友请求
        } break;
        case 107:{
            //异常登录
            [UserManager resetUserInfo];
            AppDelegate *app = [UIApplication sharedApplication].delegate;
            [app setLoginViewController];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:alertString delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
        } break;
        case 108:{
            
        } break;
        case 109:{
            [[NSNotificationCenter defaultCenter]postNotificationName:kUserBedStatusChanged object:nil userInfo:userInfo];
        } break;
        case 110:{
            [[NSNotificationCenter defaultCenter]postNotificationName:kUserBedStatusChanged object:nil userInfo:userInfo];
            //版本更新
            
        } break;
        case 111:{
            DeBugLog(@"文章推送");
            AppDelegate *app = [UIApplication sharedApplication].delegate;
            NSString *articleUrl = [userInfo objectForKey:@"ArticleUrl"];
            if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
                NotiView *no = [[NotiView alloc]init];
                no.frame = (CGRect){0,0,100,64};
                [no configNotiView:userInfo];
                no.buttonClockTaped = ^(NSInteger index){
                    DeBugLog(@"查看文章");
                    DeBugLog(@"当前controller%@",[self getCurrentVC]);
                    [self.notification dismissNotification];
                    if (![[self getCurrentVC] isKindOfClass:[RxWebViewController class]]) {
                        
                        RxWebViewController* webViewController = [[RxWebViewController alloc] initWithUrl:[NSURL URLWithString:articleUrl]];
                        webViewController.urlString = articleUrl;
                        webViewController.articleTitle = alertString;
                        [app.currentNavigationController pushViewController:webViewController animated:YES];
                    }else{
                        DeBugLog(@"当前已在RXWebView");
                    }
                };
                [self.notification displayNotificationWithView:no forDuration:4];
            }else  if([[UIApplication sharedApplication] applicationState] ==UIApplicationStateInactive || [[UIApplication sharedApplication] applicationState] ==UIApplicationStateBackground){
                RxWebViewController* webViewController = [[RxWebViewController alloc] initWithUrl:[NSURL URLWithString:articleUrl]];
                webViewController.urlString = articleUrl;
                webViewController.articleTitle = alertString;
                [app.currentNavigationController pushViewController:webViewController animated:YES];
            }
            break;
        }
        case 112:{
            DeBugLog(@"医生回复");
            NSString *problemId = [userInfo objectForKey:@"ProblemId"];
            AppDelegate *app = [UIApplication sharedApplication].delegate;
            if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
                
                NotiView *no = [[NotiView alloc]init];
                no.frame = (CGRect){0,0,100,64};
                [no configNotiView:userInfo];
                no.buttonClockTaped = ^(NSInteger index){
                    [self.notification dismissNotification];
                    DeBugLog(@"查看回复");
                    [self.notification dismissNotification];
                    if (![[self getCurrentVC] isKindOfClass:[XHDemoWeChatMessageTableViewController class]]) {
                        XHDemoWeChatMessageTableViewController *demoWeChatMessageTableViewController = [[XHDemoWeChatMessageTableViewController alloc] init];
                        demoWeChatMessageTableViewController.allowsSendFace = NO;
                        demoWeChatMessageTableViewController.allowsSendVoice = NO;
                        demoWeChatMessageTableViewController.allowsSendMultiMedia = YES;
                        demoWeChatMessageTableViewController.problemID = problemId;
                        [app.currentNavigationController pushViewController:demoWeChatMessageTableViewController animated:YES];
                    }else{
                        [[NSNotificationCenter defaultCenter]postNotificationName:kJPushNotification object:nil userInfo:userInfo];
                    }
                };
                [self.notification displayNotificationWithView:no forDuration:4];
                
            }else  {
                XHDemoWeChatMessageTableViewController *demoWeChatMessageTableViewController = [[XHDemoWeChatMessageTableViewController alloc] init];
                demoWeChatMessageTableViewController.allowsSendFace = NO;
                demoWeChatMessageTableViewController.allowsSendVoice = NO;
                demoWeChatMessageTableViewController.allowsSendMultiMedia = YES;
                demoWeChatMessageTableViewController.problemID = problemId;
                [app.currentNavigationController pushViewController:demoWeChatMessageTableViewController animated:YES];
            }
            break;
        }
        case 113:{
            
            [[NSNotificationCenter defaultCenter]postNotificationName:kUserBedStatusChanged object:nil userInfo:userInfo];
        } break;
        case 114:{
            
            [[NSNotificationCenter defaultCenter]postNotificationName:kUserBedStatusChanged object:nil userInfo:userInfo];
        } break;

        default:
            break;
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

/**
 *  播放完成回调函数
 *
 *  @param soundID    系统声音ID
 *  @param clientData 回调时传递的数据
 */
void soundCompleteCallback(SystemSoundID soundID,void * clientData){
    AudioServicesDisposeSystemSoundID (soundID);
}

static SystemSoundID soundId;

-(void) playSound
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"leaveAlert" ofType:@"wav"];
    if (path) {
        AudioServicesCreateSystemSoundID( (__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundId );
        AudioServicesAddSystemSoundCompletion(soundId, NULL, NULL, soundCompleteCallback, NULL);
        AudioServicesPlaySystemSound(soundId);
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101 || alertView.tag == 103) {
        if (buttonIndex == 1) {
            AudioServicesDisposeSystemSoundID (soundId);
        }
    }
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    UIViewController *controllers = app.currentNavigationController.topViewController;
    return controllers;
}

- (void)handJPushMessage:(NSNotification *)userInfo
{
    
}

@end
