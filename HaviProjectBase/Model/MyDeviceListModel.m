//
//  MyDeviceListModel.m
//  HaviModel
//
//  Created by Havi on 15/12/26.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import "MyDeviceListModel.h"

@implementation DeviceList

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"deviceUUID" : @"UUID",
             @"nDescription" : @"Description",
             @"isActivated":@"IsActivated",
             @"detailDeviceList" : @"DetailDevice",
             };
}
//属性的类型说明数组中对象是什么
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"detailDeviceList" : DetailDeviceList.class,
             };
}

@end

@implementation DetailDeviceList

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"detailUUID" : @"UUID",
             @"detailDescription" : @"Description",
             };
}

@end

@implementation MyDeviceListModel

//这个方法是将属性和json中的key进行关联
+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"returnCode" : @"ReturnCode",
             @"errorMessage" : @"ErrorMessage",
             @"date":@"Date",
             @"deviceList" : @"DeviceList",
             };
}
//属性的类型说明数组中对象是什么
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"deviceList" : DeviceList.class,
             };
}

@end
