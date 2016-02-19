//
//  TagListModel.m
//  HaviModel
//
//  Created by Havi on 15/12/5.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import "TagListModel.h"

@implementation UserTag

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"userTag":@"Tag",
             @"tagType": @"TagType",  //-1:睡前，1:睡眠
             @"tagDate": @"At",
             @"userTagDate": @"UserTagDate",
             };
}

@end

@implementation TagListModel
+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"serverTime" : @"ServerTime",
             @"returnCode" : @"ReturnCode",
             @"errorMessage" : @"ErrorMessage",
             @"date":@"Date",
             @"tagList" : @"Tags",
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"beingRequestUserList" : UserTag.class,
             };
}
@end
