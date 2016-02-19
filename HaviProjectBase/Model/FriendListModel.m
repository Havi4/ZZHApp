//
//  FriendListModel.m
//  HaviModel
//
//  Created by Havi on 15/12/5.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import "FriendListModel.h"

@implementation UserList

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"userID": @"UserID",
             @"userValidationServer": @"UserValidationServer", //迈动、微信、腾信等
             @"userIdOriginal": @"UserIdOriginal", //注册用户名
             @"cellPhone": @"CellPhone", //手机
             @"email": @"Email", //
             @"locked": @"Locked", //是否该用户锁定
             @"userName": @"UserName", //真实姓名
             };
}

@end

@implementation FriendListModel
//这个方法是将属性和json中的key进行关联
+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"serverTime" : @"ServerTime",
             @"returnCode" : @"ReturnCode",
             @"errorMessage" : @"ErrorMessage",
             @"date":@"Date",
             @"userList" : @"UserList",
             };
}
//属性的类型说明数组中对象是什么
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"userList" : UserList.class,
             };
}

@end
