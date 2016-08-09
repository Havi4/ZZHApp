//
//  SleepModelChange.h
//  HaviProjectBase
//
//  Created by Havi on 16/2/24.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumTypeDefine.h"

@interface SleepModelChange : NSObject

+ (void)changeSleepDuration:(id)obj callBack:(void(^)(id callBack))block;

+ (void)changeSleepValueDuration:(id)obj callBack:(void(^)(id callBack))block;
+ (void)changeSleepQualityModel:(id)obj callBack:(void(^)(id callBack))block;

+ (NSString *)chageDateFormatteToQueryString:(NSDate *)date;

+ (void)filterSensorDataWithTime:(SensorDataModel *)sensorData withType:(SensorDataType)type callBack:(void(^)(id callBack))block;

+ (void)filterSensorLeaveDataWithTime:(SensorDataModel *)sensorData callBack:(void(^)(id callBack))block;

+ (void)getSleepLongOrShortDurationWith:(id)obj type:(int)type callBack:(void(^)(id longSleep))block;

+ (void)filterReportData:(NSArray *)reportData queryDate:(id)query callBack:(void (^)(id qualityBack,id sleepDurationBack))block;

+ (void)filterMonthReportData:(NSArray *)reportData queryDate:(id)query callBack:(void (^)(id qualityBack,id sleepDurationBack))block;

+ (void)filterQuaterReportData:(NSArray *)reportData queryDate:(id)query callBack:(void (^)(id qualityBack,id sleepDurationBack))block;

+ (void)filterSensorNewLeaveDataWithTime:(SensorDataModel *)sensorData callBack:(void(^)(id callBack))block;

+ (void)filterTurnAroundWithTime:(SensorDataModel *)sensorData withType:(SensorDataType)sensorType callBack:(void(^)(id callBack))block;

@end
