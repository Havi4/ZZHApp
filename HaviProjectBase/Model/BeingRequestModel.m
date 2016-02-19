//
//  BeingRequestModel.m
//  HaviModel
//
//  Created by Havi on 15/12/5.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import "BeingRequestModel.h"

@implementation RequestUserInfo

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"userID": @"UserID", //申请加好友的人
             @"userValidationServer": @"UserValidationServer", //迈动、微信、腾信等
             @"userIdOriginal": @"UserIdOriginal", //注册用户名
             @"cellPhone": @"CellPhone", //手机
             @"email": @"Email", //
             @"userName": @"UserName", //真实姓名
             @"comment": @"Comment", //备注
             @"requestDate": @"RequestDate",
             @"statusCode": @"StatusCode" //-1:拒绝、0:申请中、1:已同意

             };
}

@end

@implementation BeingRequestModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"serverTime" : @"ServerTime",
             @"returnCode" : @"ReturnCode",
             @"errorMessage" : @"ErrorMessage",
             @"date":@"Date",
             @"beingRequestUserList" : @"UserList",
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"beingRequestUserList" : RequestUserInfo.class,
             };
}

@end
