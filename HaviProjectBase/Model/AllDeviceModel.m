//
//  AllDeviceModel.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/23.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "AllDeviceModel.h"

@implementation AllDeviceModel

//这个方法是将属性和json中的key进行关联
+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"returnCode" : @"ReturnCode",
             @"errorMessage" : @"ErrorMessage",
             @"date":@"Date",
             @"myDeviceList" : @"UserDeviceList",
             @"friendDeviceList" : @"FriendDeviceList",
             };
}
//属性的类型说明数组中对象是什么
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"myDeviceList" : DeviceList.class,
             @"friendDeviceList" : DeviceList.class,
             };
}


@end
