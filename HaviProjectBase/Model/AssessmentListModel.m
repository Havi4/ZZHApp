//
//  AssessmentListModel.m
//  HaviProjectBase
//
//  Created by Havi on 16/3/1.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "AssessmentListModel.h"

@implementation AssessmentDetail

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"code" : @"Code",
             @"conclusion" : @"Conclusion",
             @"ndescription":@"Description",
             @"suggestion" : @"Suggestion",
             };
}

@end

@implementation AssessmentListModel

//这个方法是将属性和json中的key进行关联
+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"serverTime" : @"ServerTime",
             @"returnCode" : @"ReturnCode",
             @"errorMessage" : @"ErrorMessage",
             @"date":@"Date",
             @"assessmentList":@"Assessments",
             };
}
//属性的类型说明数组中对象是什么
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"assessmentList" : AssessmentDetail.class,
             };
}


@end
