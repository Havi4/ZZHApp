//
//  SleepQualityModel.m
//  HaviModel
//
//  Created by Havi on 15/12/27.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import "SleepQualityModel.h"

@implementation QualityDetailModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"date" : @"Date",
             @"sleepQuality" : @"SleepQuality",
             @"sleepStartTime":@"SleepStartTime",
             @"sleepEndTime" : @"SleepEndTime",
             
             @"sleepDuration" : @"SleepDuration",
             @"tagsBeforeSleep" : @"TagsBeforeSleep",
             @"tagsAfterSleep":@"TagsAfterSleep",
             @"tagFlag" : @"TagFlag",
             };
}

@end

@implementation SleepQualityModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"returnCode" : @"ReturnCode",
             @"errorMessage" : @"ErrorMessage",
             @"date":@"Date",
             @"data" : @"Data",
             
             @"sleepQuality" : @"SleepQuality",
             @"assessmentCode" : @"AssessmentCode",
             @"averageHeartRate":@"AverageHeartRate",
             @"averageRespiratoryRate" : @"AverageRespiratoryRate",
             @"slowHeartRateTimes" : @"SlowHeartRateTimes",
             @"fastHeartRateTimes" : @"FastHeartRateTimes",
             @"slowRespiratoryRateTimes":@"SlowRespiratoryRateTimes",
             @"fastRespiratoryRateTimes" : @"FastRespiratoryRateTimes",
             @"abnormalHeartRatePercent" : @"AbnormalHeartRatePercent",
             @"abnormalRespiratoryRatePercent" : @"AbnormalRespiratoryRatePercent",
             @"bodyMovementTimes":@"BodyMovementTimes",
             @"outOfBedTimes" : @"OutOfBedTimes",
             @"averageSleepDuration" : @"AverageSleepDuration",
             };
}
//属性的类型说明数组中对象是什么
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"data" : QualityDetailModel.class,
             };
}

@end
