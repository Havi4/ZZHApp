//
//  ArticleModel.m
//  HaviProjectBase
//
//  Created by Havi on 16/9/12.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "ArticleModel.h"

@implementation ArticleNewModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"articleId" : @"ArticleId",
             @"title" : @"Title",
             @"tips":@"Tips",
             @"systemDate" : @"SystemDate",
             @"source":@"Source",
             @"url" : @"Url",
             };
}

@end

@implementation ArticleModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"serverTime" : @"ServerTime",
             @"returnCode" : @"ReturnCode",
             @"errorMessage" : @"ErrorMessage",
             @"date":@"Date",
             @"articleNewsList":@"Result",
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"articleNewsList" : ArticleNewModel.class,
             };
}

@end
