//
//  FriendDeviceListModel.m
//  HaviModel
//
//  Created by Havi on 15/12/26.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import "FriendDeviceListModel.h"

@implementation FriendDetailDeviceList

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"detailUUID" : @"UUID",
             @"detailDescription" : @"Description",
             };
}

@end

@implementation FriendDeviceList

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
             @"detailDeviceList" : FriendDetailDeviceList.class,
             };
}

@end

@implementation FriendDeviceListModel

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
             @"deviceList" : FriendDeviceList.class,
             };
}

@end
