//
//  WeatherModel.m
//  HaviProjectBase
//
//  Created by Havi on 16/9/1.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "WeatherModel.h"

@implementation WeatherDataModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"airCondition" : @"AirCondition",
             @"city" : @"City",
             @"temp"        :@"Temp",
             @"humidity" : @"Humidity",
             @"weather" : @"Weather",
             @"weatherCode" : @"WeatherCode",
            @"exerciseIndex"        :@"ExerciseIndex",
             @"coldIndex" : @"ColdIndex",
             @"dressingIndex" : @"DressingIndex",
             @"updateTime" : @"UpdateTime",
             };
}


@end

@implementation WeatherModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"returnCode" : @"ReturnCode",
             @"errorMessage" : @"ErrorMessage",
             @"date"        :@"Date",
             @"weatherData" : @"WeatherDataModel",
             
             };
}


@end
