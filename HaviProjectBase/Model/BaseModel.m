//
//  BaseModel.m
//  HaviModel
//
//  Created by Havi on 15/12/5.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"serverTime" : @"ServerTime",
             @"returnCode" : @"ReturnCode",
             @"errorMessage" : @"ErrorMessage",
             @"date":@"Date",
             };
}
@end
