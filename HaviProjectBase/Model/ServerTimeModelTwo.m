//
//  ServerTimeModelTwo.m
//  HaviModel
//
//  Created by Havi on 15/12/5.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import "ServerTimeModelTwo.h"

@implementation ServerTimeModelTwo

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"serverTime" : @"ServerTime",
             @"returnCode" : @"ReturnCode",
             @"errorMessage" : @"ErrorMessage",
             @"queryDate" : @"Date",
             };
}

@end
