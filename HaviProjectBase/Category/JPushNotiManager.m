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

static JPushNotiManager *shareInstance = nil;

@implementation JPushNotiManager

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
    [APService handleRemoteNotification:userInfo];
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
//        [self playSound];
    }
}

- (void)handPushApplication:(UIApplication *)application receiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [APService handleRemoteNotification:userInfo];
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
            AppDelegate *app = [UIApplication sharedApplication].delegate;
            [app setLoginViewController];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:alertString delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
        } break;
        case 108:{
            //版本更新
            
        } break;
        default:
            break;
    }
    
    NSLog(@"收到");
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


@end
