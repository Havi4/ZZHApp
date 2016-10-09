//
//  AccessTockenModel.m
//  HaviProjectBase
//
//  Created by HaviLee on 2016/10/9.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "AccessTockenModel.h"

@implementation AccessTockenModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"serverTime" : @"ServerTime",
             @"returnCode" : @"ReturnCode",
             @"errorMessage" : @"ErrorMessage",
             @"date":@"Date",
             @"accessTockenString":@"AccessToken",
             };
}

@end
