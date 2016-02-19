//
//  GlobalModel.m
//  HaviModel
//
//  Created by Havi on 15/12/27.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import "GlobalModel.h"

@implementation GlobalDetailModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"serviceHotline" : @"ServiceHotline",
             @"isTimeoutAlarmOutOfBed" : @"IsTimeoutAlarmOutOfBed",
             @"alarmTimeOutOfBed":@"AlarmTimeOutOfBed",
             @"isTimeoutAlarmSleepTooLong" : @"IsTimeoutAlarmSleepTooLong",
             @"alarmTimeSleepTooLong" : @"AlarmTimeSleepTooLong",
             @"fromTimeShowData" : @"FromTimeShowData",
             @"toTimeShowData" : @"ToTimeShowData",
             @"sleepStartTime" : @"SleepStartTime",
             @"sleepEndTime" : @"SleepEndTime",
             };
}

- (NSString *)description
{
    NSString *description = [NSString stringWithFormat:@"%@,%@",_serviceHotline,_isTimeoutAlarmOutOfBed];
    return description;
}

@end

@implementation GlobalModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"returnCode" : @"ReturnCode",
             @"errorMessage" : @"ErrorMessage",
             @"date":@"Date",
             @"parameterList" : @"ParameterList",
             };
}
@end
