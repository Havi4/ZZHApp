//
//  SensorDataModel.m
//  HaviModel
//
//  Created by Havi on 15/12/5.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import "SensorDataModel.h"

@implementation PropertyData

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"propertyDate" : @"At",
             @"propertyValue" : @"Value",
             };
}

@end

@implementation SensorDataInfo

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"properyType" : @"PropertyCode",
             @"propertyDataList" : @"Data",
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"propertyDataList" : PropertyData.class,
             };
}

@end

@implementation SensorDataModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"serverTime" : @"ServerTime",
             @"returnCode" : @"ReturnCode",
             @"errorMessage" : @"ErrorMessage",
             @"date":@"Date",
             @"sensorDataList" : @"SensorData",
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"sensorDataList" : SensorDataInfo.class,
             };
}

@end
