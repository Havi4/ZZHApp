//
//  JPushNotiManager.h
//  HaviProjectBase
//
//  Created by Havi on 16/2/29.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JPUSHService.h"

@interface JPushNotiManager : NSObject

+ (instancetype)sharedInstance;

- (void)handPushApplication:(UIApplication *)application receiveRemoteNotification:(NSDictionary *)userInfo;

- (void)handPushApplication:(UIApplication *)application receiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

- (void)handJPushMessage:(NSNotification *)userInfo;

@end
