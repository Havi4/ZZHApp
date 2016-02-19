//
//  NestModel.m
//  HaviModel
//
//  Created by Havi on 15/12/5.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import "UserInfoDetailModel.h"

@implementation UserInfo

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"userID"                  : @"UserID",
             @"userValidationServer"    : @"UserValidationServer",
             @"userIdOriginal"          : @"UserIdOriginal",
             @"cellPhone"               : @"CellPhone",
             @"email"                   : @"Email",
             @"locked"                  : @"Locked",
             @"userName"                : @"UserName",
             @"birthday"                : @"Birthday",
             @"gender"                  : @"Gender",
             @"height"                  : @"Height",
             @"weight"                  : @"Weight",
             @"telephone"               : @"Telephone",
             @"address"                 : @"Address",
             @"emergencyContact"        : @"EmergencyContact",
             @"isTimeoutAlarmOutOfBed"  : @"IsTimeoutAlarmOutOfBed",
             @"alarmTimeOutOfBed"       : @"AlarmTimeOutOfBed",
             @"isTimeoutAlarmSleepTooLong" : @"IsTimeoutAlarmSleepTooLong",
             @"alarmTimeSleepTooLong"   : @"AlarmTimeSleepTooLong",
             @"sleepStartTime"          : @"SleepStartTime",
             @"sleepEndTime"            : @"SleepEndTime",
             };
}

@end

@implementation UserInfoDetailModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"serverTime" : @"ServerTime",
             @"returnCode" : @"ReturnCode",
             @"errorMessage" : @"ErrorMessage",
             @"date":@"Date",
             @"nUserInfo" : @"UserInfo",
             };
}

@end
