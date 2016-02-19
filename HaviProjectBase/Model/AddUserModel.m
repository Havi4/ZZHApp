//
//  AddUserModel.m
//  HaviModel
//
//  Created by Havi on 15/12/25.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import "AddUserModel.h"

@implementation AddUserModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"serverTime" : @"ServerTime",
             @"returnCode" : @"ReturnCode",
             @"errorMessage" : @"ErrorMessage",
             @"queryDate" : @"Date",
             @"userId" : @"UserID",
             };
}


@end
