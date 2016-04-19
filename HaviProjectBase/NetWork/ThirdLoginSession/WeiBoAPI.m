//
//  WeiBoAPI.m
//  SleepRecoding
//
//  Created by Havi on 15/8/12.
//  Copyright (c) 2015年 Havi. All rights reserved.
//

#import "WeiBoAPI.h"
#import "WTRequestCenter.h"

@implementation WeiBoAPI
+(NSURLRequest*)getWeiBoInfoWith:(NSString*)wxCode
                       parameters:(NSDictionary*)parameters
                         finished:(WeiBoFinishedBlock)finished
                           failed:(WeiBonFailedBlock)failed
{
    NSString *tockenUrl = [NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?access_token=%@&uid=%@",[parameters objectForKey:@"access_token"],[parameters objectForKey:@"uid"]];
    [WTRequestCenter getWithURL:tockenUrl parameters:nil finished:finished failed:failed];
    return nil;
    
}
@end
