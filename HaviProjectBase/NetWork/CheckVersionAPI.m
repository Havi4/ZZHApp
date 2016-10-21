//
//  CheckVersionAPI.m
//  HaviProjectBase
//
//  Created by HaviLee on 2016/10/20.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "CheckVersionAPI.h"
#import "WTRequestCenter.h"

@interface CheckVersionAPI ()<UIAlertViewDelegate>

@end

@implementation CheckVersionAPI

+(void)checkVersion
{
    NSString *tockenUrl = [NSString stringWithFormat:@"%@v1/app/GetAppVersion?OSName=ios&Language=cn",kAppBaseURL];
    [WTRequestCenter getWithURL:tockenUrl parameters:nil finished:^(NSURLResponse *response, NSData *data) {
        NSDictionary *versionDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSString *miniumVersion = [[versionDic objectForKey:@"AppVersion"] objectForKey:@"MiniumAppVersion"];
        NSString *latestVersion = [[versionDic objectForKey:@"AppVersion"] objectForKey:@"LatestAppVersion"];
        
        // 本地版本号和最新版本号做对比,提示更新
        if ([miniumVersion compare:currentVersion options:NSNumericSearch] == NSOrderedDescending) {
            //最低版本大于当前版本  强制更新
            [[NSNotificationCenter defaultCenter]postNotificationName:kCheckVersion object:nil userInfo:@{@"AppVersion":[versionDic objectForKey:@"AppVersion"],@"mustUpdate":@"YES"}];
            
        } else if ([latestVersion compare:currentVersion options:NSNumericSearch] == NSOrderedDescending){
            [[NSNotificationCenter defaultCenter]postNotificationName:kCheckVersion object:nil userInfo:@{@"AppVersion":[versionDic objectForKey:@"AppVersion"]}];
        }
        
    } failed:^(NSURLResponse *response, NSError *error) {
        
    }];
}


@end
