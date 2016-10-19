//
//  SleepModelChange.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/24.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "SleepModelChange.h"
#import "CalendarDateCaculate.h"
#import "NSDate+NSDateLogic.h"
#import <YYKit.h>

@implementation SleepModelChange

+ (void)changeSleepDuration:(id)obj callBack:(void(^)(id callBack))block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SleepQualityModel *model = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithArray:model.data];
        NSString *selectString = [NSString stringWithFormat:@"%@",selectedDateToUse];
        NSString *subString = [selectString substringToIndex:10];
        __block QualityDetailModel *detail;
        [arr enumerateObjectsUsingBlock:^( QualityDetailModel *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.date isEqualToString:subString]) {
                detail = obj;
                *stop = YES;
            }
        }];
        if (arr.count ==1) {
            detail = [arr objectAtIndex:0];
        }
        NSString *sleepDuration = detail.sleepDuration;
        int hour = [sleepDuration intValue];
        double second2 = 0.0;
        double subsecond2 = modf([sleepDuration floatValue], &second2);
        NSString *sleepTimeDuration= @"";
        if((int)round(subsecond2*60)<10){
            sleepTimeDuration = [NSString stringWithFormat:@"%@小时0%d分",hour<10?[NSString stringWithFormat:@"0%d",hour]:[NSString stringWithFormat:@"%d",hour],(int)round(subsecond2*60)];
        }else{
            sleepTimeDuration = [NSString stringWithFormat:@"%@小时%d分",hour<10?[NSString stringWithFormat:@"0%d",hour]:[NSString stringWithFormat:@"%d",hour],(int)round(subsecond2*60)];
        }
        if (hour == 0 & subsecond2 == 0) {
            sleepTimeDuration = [NSString stringWithFormat:@"--小时--分"];
        }
        dispatch_async_on_main_queue(^{
            block(sleepTimeDuration);
        });
    });

}

+ (void)changeSleepValueDuration:(id)obj callBack:(void(^)(id callBack))block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SleepQualityModel *model = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithArray:model.data];
        NSString *selectString = [NSString stringWithFormat:@"%@",selectedDateToUse];
        NSString *subString = [selectString substringToIndex:10];
        //测试
        __block QualityDetailModel *detail;
        [arr enumerateObjectsUsingBlock:^( QualityDetailModel *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.date isEqualToString:subString]) {
                detail = obj;
                *stop = YES;
            }
        }];
        NSString *sleepDuration = detail.sleepQuality;
        dispatch_async_on_main_queue(^{
            block(sleepDuration);
        });
    });
}

+ (void)changeSleepQualityModel:(id)obj callBack:(void(^)(id callBack))block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SleepQualityModel *model = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithArray:model.data];
        NSString *selectString = [NSString stringWithFormat:@"%@",selectedDateToUse];
        NSString *subString = [selectString substringToIndex:10];
        __block QualityDetailModel *detail;
        [arr enumerateObjectsUsingBlock:^( QualityDetailModel *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.date isEqualToString:subString]) {
                detail = obj;
                *stop = YES;
            }
        }];
        if (arr.count == 1) {
            detail = [arr objectAtIndex:0];
        }
        dispatch_async_on_main_queue(^{
            block(detail);
        });
    });

}

+ (NSString *)chageDateFormatteToQueryString:(NSDate *)date
{
    @synchronized(self) {
        NSString *month = [NSString stringWithFormat:@"%ld",(long)date.month];
        if (date.month < 10) {
            month = [NSString stringWithFormat:@"0%ld",(long)date.month];
        }
        NSString *day = [NSString stringWithFormat:@"%ld",(long)date.day];
        if (date.day < 10) {
            day = [NSString stringWithFormat:@"0%ld",(long)date.day];
        }
        NSString *queryString = [NSString stringWithFormat:@"%ld%@%@",(long)date.year,month,day];
        return queryString;
    }
}

+ (void)filterSensorDataWithTime:(SensorDataModel *)sensorData withType:(SensorDataType)sensorType callBack:(void(^)(id callBack))block
{

    @synchronized(self) {
        if (sensorData) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                SensorDataInfo *sensorArr = [sensorData.sensorDataList objectAtIndex:0];
                NSArray *sensorInfo = sensorArr.propertyDataList;
                NSMutableArray *arr = [[NSMutableArray alloc]init];
                for (int i=0; i<kChartDataCount; i++) {
                    if (SensorDataHeart == sensorType) {
                        [arr addObject:[NSNumber numberWithFloat:60]];
                    }else{
                        [arr addObject:[NSNumber numberWithFloat:15]];
                    }
                }
                for (int i = 0; i<sensorInfo.count; i++) {
                    PropertyData *dic = [sensorInfo objectAtIndex:i];
                    NSString *date = dic.propertyDate;
                    NSString *hourDate1 = [date substringWithRange:NSMakeRange(11, 2)];
                    NSString *minuteDate2 = [date substringWithRange:NSMakeRange(14, 2)];
                    int indexIn = 0;
                    if ([hourDate1 intValue]<18) {
                        indexIn = (int)((24 -18)*60 + [hourDate1 intValue]*60 + [minuteDate2 intValue])/kCharDataIntervalTime;
                    }else {
                        indexIn = (int)(([hourDate1 intValue]-18)*60 + [minuteDate2 intValue])/kCharDataIntervalTime;
                    }
                    [arr replaceObjectAtIndex:indexIn withObject:[NSNumber numberWithFloat:[dic.propertyValue floatValue]]];
                }
                dispatch_async_on_main_queue(^{
                    block(arr);
                });
            });
        }
    }
}

+ (void)filterRealSensorDataWithTime:(SensorDataModel *)sensorData withType:(SensorDataType)sensorType startTime:(NSDate *)startTime endTime:(NSString *)endTime callBack:(void(^)(id callBack))block
{
    @synchronized(self) {
        if (sensorData) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                SensorDataInfo *sensorArr = [sensorData.sensorDataList objectAtIndex:0];
                NSArray *sensorInfo = sensorArr.propertyDataList;
                NSMutableArray *arr = [[NSMutableArray alloc]init];
                for (int i=0; i<60; i++) {
                    if (SensorDataHeart == sensorType) {
                        [arr addObject:[NSNumber numberWithFloat:60]];
                    }else{
                        [arr addObject:[NSNumber numberWithFloat:15]];
                    }
                }
                for (int i = 0; i<sensorInfo.count; i++) {
                    PropertyData *dic = [sensorInfo objectAtIndex:i];
                    NSDateFormatter *dateF = [[NSDateFormatter alloc]init];
                    dateF.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                    NSDate *queryDate = [startTime  dateByAddingHours:8 ];
                    NSString *date = dic.propertyDate;
                    NSDate *dateS = [[dateF dateFromString:date] dateByAddingHours:8];
                    NSInteger minute = (NSInteger)[dateS minutesLaterThan:queryDate];
                    DeBugLog(@"date is %@,sensorDate %@,mintue is %ld",queryDate,dateS,(long)minute);
                    if (minute < 60) {
                        [arr replaceObjectAtIndex:minute withObject:[NSNumber numberWithFloat:[dic.propertyValue floatValue]]];
                    }
                    
//                    PropertyData *dic1 = [sensorInfo objectAtIndex:i+1];
//                    NSDate *dateS2 = [dateF dateFromString:date1];
//                    if ([dateS1 minutesEarlierThan:dateS2]>=1) {
//                        [arr addObject:[NSNumber numberWithFloat:[dic.propertyValue floatValue]]];
//                    }
                }
                dispatch_async_on_main_queue(^{
                    block(arr);
                });
            });
        }
    }
}

+ (void)filterTurnAroundWithTime:(SensorDataModel *)sensorData withType:(SensorDataType)sensorType callBack:(void(^)(id callBack))block
{
    
    @synchronized(self) {
        if (sensorData) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                SensorDataInfo *sensorArr = [sensorData.sensorDataList objectAtIndex:0];
                NSArray *sensorInfo = sensorArr.propertyDataList;
                NSMutableArray *arr = [[NSMutableArray alloc]init];
                for (int i = 0; i<sensorInfo.count; i++) {
                    PropertyData *dic = [sensorInfo objectAtIndex:i];
                    NSString *date = dic.propertyDate;
                    NSString *hourDate1 = [date substringWithRange:NSMakeRange(11, 2)];
                    NSString *minuteDate2 = [date substringWithRange:NSMakeRange(14, 2)];
                    int indexIn = 0;
                    if ([hourDate1 intValue]<18) {
                        indexIn = (int)((24 -18)*60 + [hourDate1 intValue]*60 + [minuteDate2 intValue])/1;
                    }else {
                        indexIn = (int)(([hourDate1 intValue]-18)*60 + [minuteDate2 intValue])/1;
                    }
                    [arr addObject:[NSNumber numberWithInt:indexIn]];
                }
                dispatch_async_on_main_queue(^{
                    block(arr);
                });
            });
        }
    }
}

+ (void)filterNewTurnAroundWithTime:(SensorDataModel *)sensorData withType:(SensorDataType)sensorType callBack:(void(^)(id callBack))block
{
    
    @synchronized(self) {
        if (sensorData) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                SensorDataInfo *sensorArr = [sensorData.sensorDataList objectAtIndex:0];
                NSArray *sensorInfo = sensorArr.propertyDataList;
                NSMutableArray *arr = [[NSMutableArray alloc]init];
                for (int i=0; i<24; i++) {
                    [arr addObject:@0];
                }
                
                for (int i = 0; i<sensorInfo.count; i++) {
                    PropertyData *dic = [sensorInfo objectAtIndex:i];
                    NSString *date = dic.propertyDate;
                    NSString *hourDate1 = [date substringWithRange:NSMakeRange(11, 2)];
                    int indexIn = 0;
                    if (([hourDate1 intValue] > 18 || [hourDate1 intValue] == 18) && [hourDate1 intValue] < 19) {
                        indexIn = 0;
                    }else if(([hourDate1 intValue] > 19 || [hourDate1 intValue] == 19) && [hourDate1 intValue] < 20){
                        indexIn = 1;
                    }else if(([hourDate1 intValue] > 20 || [hourDate1 intValue] == 20) && [hourDate1 intValue] < 21){
                        indexIn = 2;
                    }else if(([hourDate1 intValue] > 21 || [hourDate1 intValue] == 21) && [hourDate1 intValue] < 22){
                        indexIn = 3;
                    }else if(([hourDate1 intValue] > 22 || [hourDate1 intValue] == 22) && [hourDate1 intValue] < 23){
                        indexIn = 4;
                    }else if(([hourDate1 intValue] > 23 || [hourDate1 intValue] == 23) && [hourDate1 intValue] < 24){
                        indexIn = 5;
                    }else if(([hourDate1 intValue] > 0 || [hourDate1 intValue] == 0) && [hourDate1 intValue] < 1){
                        indexIn = 6;
                    }else if(([hourDate1 intValue] > 1 || [hourDate1 intValue] == 1) && [hourDate1 intValue] < 2){
                        indexIn = 7;
                    }else if(([hourDate1 intValue] > 2 || [hourDate1 intValue] == 2) && [hourDate1 intValue] < 3){
                        indexIn = 8;
                    }else if(([hourDate1 intValue] > 3 || [hourDate1 intValue] == 3) && [hourDate1 intValue] < 4){
                        indexIn = 9;
                    }else if(([hourDate1 intValue] > 4 || [hourDate1 intValue] == 4) && [hourDate1 intValue] < 5){
                        indexIn = 10;
                    }else if(([hourDate1 intValue] > 5 || [hourDate1 intValue] == 5) && [hourDate1 intValue] < 6){
                        indexIn = 11;
                    }else if(([hourDate1 intValue] > 6 || [hourDate1 intValue] == 6) && [hourDate1 intValue] < 7){
                        indexIn = 12;
                    }else if(([hourDate1 intValue] > 7 || [hourDate1 intValue] == 7) && [hourDate1 intValue] < 8){
                        indexIn = 13;
                    }else if(([hourDate1 intValue] > 8 || [hourDate1 intValue] == 8) && [hourDate1 intValue] < 9){
                        indexIn = 14;
                    }else if(([hourDate1 intValue] > 9 || [hourDate1 intValue] == 9) && [hourDate1 intValue] < 10){
                        indexIn = 15;
                    }else if(([hourDate1 intValue] > 10 || [hourDate1 intValue] == 10) && [hourDate1 intValue] < 11){
                        indexIn = 16;
                    }else if(([hourDate1 intValue] > 11 || [hourDate1 intValue] == 11) && [hourDate1 intValue] < 12){
                        indexIn = 17;
                    }else if(([hourDate1 intValue] > 12 || [hourDate1 intValue] == 12) && [hourDate1 intValue] < 13){
                        indexIn = 18;
                    }else if(([hourDate1 intValue] > 13 || [hourDate1 intValue] == 13) && [hourDate1 intValue] < 14){
                        indexIn = 19;
                    }else if(([hourDate1 intValue] > 14 || [hourDate1 intValue] == 14) && [hourDate1 intValue] < 15){
                        indexIn = 20;
                    }else if(([hourDate1 intValue] > 15 || [hourDate1 intValue] == 15) && [hourDate1 intValue] < 16){
                        indexIn = 21;
                    }else if(([hourDate1 intValue] > 16 || [hourDate1 intValue] == 16) && [hourDate1 intValue] < 17){
                        indexIn = 22;
                    }else if(([hourDate1 intValue] > 17 || [hourDate1 intValue] == 17) && [hourDate1 intValue] < 18){
                        indexIn = 23;
                    }
                    NSInteger index = [[arr objectAtIndex:indexIn] integerValue];
                    index +=1;
                    [arr replaceObjectAtIndex:indexIn withObject:[NSNumber numberWithInteger:index]];
                }
                dispatch_async_on_main_queue(^{
                    block(arr);
                });
            });
        }
    }
}


+ (void)filterSensorLeaveDataWithTime:(SensorDataModel *)sensorData callBack:(void(^)(id callBack))block
{
    @synchronized(self) {
        if (sensorData) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                SensorDataInfo *sensorArr = [sensorData.sensorDataList objectAtIndex:0];
                NSArray *sensorInfo = sensorArr.propertyDataList;
                NSMutableArray *arr = [[NSMutableArray alloc]init];
                [sensorInfo enumerateObjectsUsingBlock:^(PropertyData *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.propertyValue intValue]==1 || [obj.propertyValue intValue]==3) {
                        [arr addObject:obj];
                    }
                }];
                dispatch_async_on_main_queue(^{
                    block(arr);
                });
            });
        }
    }
}

+ (void)filterSensorNewLeaveDataWithTime:(SensorDataModel *)sensorData callBack:(void(^)(id callBack))block
{
    @synchronized(self) {
        if (sensorData.sensorDataList) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                SensorDataInfo *sensorArr = [sensorData.sensorDataList objectAtIndex:0];
                NSArray *sensorInfo = sensorArr.propertyDataList;
                NSArray *_sortedDetailDevice = [sensorInfo sortedArrayUsingComparator:^NSComparisonResult(PropertyData* _Nonnull obj1, PropertyData* _Nonnull obj2) {
                    return [obj1.propertyDate compare:obj2.propertyDate options:NSCaseInsensitiveSearch];
                }];
                NSMutableArray *arr1 = [[NSMutableArray alloc]init];
                int i,j;
//                @{@"name":@"third", @"value":@40, @"color":[UIColor blueColor], @"strokeColor":[UIColor whiteColor]},
                for (i = 0,j = 1; j < _sortedDetailDevice.count ; i++,j++) {
                    NSMutableDictionary *dic = @{}.mutableCopy;
                    PropertyData *datai = [_sortedDetailDevice objectAtIndex:i];
                    PropertyData *dataj = [_sortedDetailDevice objectAtIndex:j];
                    if ([datai.propertyValue integerValue]==0) {
                        //上床
                        [dic setObject:[UIColor colorWithRed:0.694 green:0.835 blue:0.800 alpha:1.00] forKey:@"color"];
                    }else{
                        [dic setObject:[UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1.00] forKey:@"color"];
                    }
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    //设定时间格式,这里可以设置成自己需要的格式
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSDate *datei = [dateFormatter dateFromString:datai.propertyDate];
                    NSDate *datej = [dateFormatter dateFromString:dataj.propertyDate];
                    double timeSub = [datej minutesLaterThan:datei];
                    if (timeSub<2) {
                        timeSub += 5;
                    }
                    
                    NSString *timei = [NSString stringWithFormat:@"%@",datai.propertyDate];
                    NSString *timej = [NSString stringWithFormat:@"%@",dataj.propertyDate];
                    NSString *time = [NSString stringWithFormat:@"%@-%@",[timei substringWithRange:NSMakeRange(11, 5)],[timej substringWithRange:NSMakeRange(11, 5)]];
                    [dic setObject:time forKey:@"name"];
                    [dic setObject:[UIColor clearColor] forKey:@"strokeColor"];
                    [dic setObject:[NSNumber numberWithDouble:timeSub] forKey:@"value"];
                    [arr1 addObject:dic];
                }
                PropertyData *data0 = [_sortedDetailDevice objectAtIndex:0];
                NSString *time0 = [NSString stringWithFormat:@"%@",data0.propertyDate];
                if ([[NSString stringWithFormat:@"%@",[time0 substringWithRange:NSMakeRange(11, 2)]] intValue]>18 || [[NSString stringWithFormat:@"%@",[time0 substringWithRange:NSMakeRange(11, 2)]] intValue]==18) {
                    int hour = [[time0 substringWithRange:NSMakeRange(11, 2)] intValue];
                    int minute = [[time0 substringWithRange:NSMakeRange(15, 2)] intValue];
                    int timeLong = (hour-18) *60  + minute;
                    NSMutableDictionary *dic = @{}.mutableCopy;
                    if ([data0.propertyValue integerValue]==0) {
                        [dic setObject:[UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1.00] forKey:@"color"];
                    }else{
                        [dic setObject:[UIColor colorWithRed:0.694 green:0.835 blue:0.800 alpha:1.00] forKey:@"color"];
                    }
                    NSString *time = [NSString stringWithFormat:@"18:00-%@",[time0 substringWithRange:NSMakeRange(11, 5)]];
                    [dic setObject:time forKey:@"name"];
                    [dic setObject:[UIColor clearColor] forKey:@"strokeColor"];
                    [dic setObject:[NSNumber numberWithInt:timeLong] forKey:@"value"];
                    [arr1 insertObject:dic atIndex:0];
                    
                }else{
                    int hour = [[time0 substringWithRange:NSMakeRange(11, 2)] intValue];
                    int minute = [[time0 substringWithRange:NSMakeRange(15, 2)] intValue];
                    int timeLong = (hour+6) *60  + minute;
                    NSMutableDictionary *dic = @{}.mutableCopy;
                    if ([data0.propertyValue integerValue]==0) {
                        [dic setObject:[UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1.00] forKey:@"color"];
                    }else{
                        [dic setObject:[UIColor colorWithRed:0.694 green:0.835 blue:0.800 alpha:1.00] forKey:@"color"];
                    }
                    NSString *time = [NSString stringWithFormat:@"18:00-%@",[time0 substringWithRange:NSMakeRange(11, 5)]];
                    [dic setObject:time forKey:@"name"];
                    [dic setObject:[UIColor clearColor] forKey:@"strokeColor"];
                    [dic setObject:[NSNumber numberWithInt:timeLong] forKey:@"value"];
                    [arr1 insertObject:dic atIndex:0];
                }
                
                PropertyData *dataLast = [_sortedDetailDevice lastObject];
                NSString *timeLast = [NSString stringWithFormat:@"%@",dataLast.propertyDate];
                if ([[NSString stringWithFormat:@"%@",[timeLast substringWithRange:NSMakeRange(11, 2)]] intValue]>18 || [[NSString stringWithFormat:@"%@",[timeLast substringWithRange:NSMakeRange(11, 2)]] intValue]==18) {
                    int hour = [[timeLast substringWithRange:NSMakeRange(11, 2)] intValue];
                    int minute = [[timeLast substringWithRange:NSMakeRange(15, 2)] intValue];
                    int timeLong = (hour-18) *60  + minute;
                    NSMutableDictionary *dic = @{}.mutableCopy;
                    if ([dataLast.propertyValue integerValue]==0) {
                        //上床
                        [dic setObject:[UIColor colorWithRed:0.694 green:0.835 blue:0.800 alpha:1.00] forKey:@"color"];
                    }else{
                        [dic setObject:[UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1.00] forKey:@"color"];
                    }
                    NSString *time = [NSString stringWithFormat:@"%@-18:00",[timeLast substringWithRange:NSMakeRange(11, 5)]];
                    [dic setObject:time forKey:@"name"];
                    [dic setObject:[UIColor clearColor] forKey:@"strokeColor"];
                    [dic setObject:[NSNumber numberWithInt:timeLong] forKey:@"value"];
                    [arr1 addObject:dic];
                    
                }else{
                    int hour = [[timeLast substringWithRange:NSMakeRange(11, 2)] intValue];
                    int minute = [[timeLast substringWithRange:NSMakeRange(15, 2)] intValue];
                    int timeLong = (18 -hour) *60  + minute;
                    NSMutableDictionary *dic = @{}.mutableCopy;
                    if ([dataLast.propertyValue integerValue]==0) {
                        //上床
                        [dic setObject:[UIColor colorWithRed:0.694 green:0.835 blue:0.800 alpha:1.00] forKey:@"color"];
                    }else{
                        [dic setObject:[UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1.00] forKey:@"color"];
                    }
                    NSString *time = [NSString stringWithFormat:@"%@-18:00",[timeLast substringWithRange:NSMakeRange(11, 5)]];
                    [dic setObject:time forKey:@"name"];
                    [dic setObject:[UIColor clearColor] forKey:@"strokeColor"];
                    [dic setObject:[NSNumber numberWithInt:timeLong] forKey:@"value"];
                    [arr1 addObject:dic];
                }
//                [sensorInfo enumerateObjectsUsingBlock:^(PropertyData *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    if ([obj.propertyValue intValue]==1 || [obj.propertyValue intValue]==3) {
//                        [arr addObject:obj];
//                    }
//                }];
                dispatch_async_on_main_queue(^{
                    block(arr1);
                });
            });
        }
    }
}

+ (void)getSleepLongOrShortDurationWith:(id)obj type:(int)type callBack:(void(^)(id longSleep))block
{
    @synchronized(self) {//1最长，-1最短
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            SleepQualityModel *model = obj;
            QualityDetailModel *longInfo = nil;
            for (QualityDetailModel *dic in model.data) {
                if ([dic.tagFlag intValue]== type) {
                    longInfo = dic;
                    break;
                }
            }
            dispatch_async_on_main_queue(^{
                block(longInfo);
            });
        });
    }
}

+ (void)filterReportData:(NSArray *)reportData queryDate:(id)query callBack:(void (^)(id qualityBack,id sleepDurationBack))block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *mutableArr = [[NSMutableArray alloc]init];
        NSMutableArray *mutableTimeArr = [[NSMutableArray alloc]init];
        if (mutableArr.count>0) {
            [mutableArr removeAllObjects];
        }
        if (mutableTimeArr.count>0) {
            [mutableTimeArr removeAllObjects];
        }
        for (int i=0; i<7; i++) {
            [mutableArr addObject:[NSString stringWithFormat:@"0"]];
            [mutableTimeArr addObject:[NSString stringWithFormat:@"0"]];
        }
        NSString *queryStart = [(NSDictionary *)query objectForKey:@"queryStartTime"];
        NSString *year = [queryStart substringWithRange:NSMakeRange(0, 4)];
        NSString *month = [queryStart substringWithRange:NSMakeRange(4, 2)];
        NSString *day = [queryStart substringWithRange:NSMakeRange(6, 2)];
        NSString *fromDateString = [NSString stringWithFormat:@"%@年%@月%@日",year,month,day];
        NSDate *fromDate = [[[CalendarDateCaculate sharedInstance] dateFormmatter] dateFromString:fromDateString];
        for (int i=0; i<reportData.count; i++) {
            QualityDetailModel *dic = [reportData objectAtIndex:i];
            NSString *dateString = dic.date;
            NSString *toDateString = [NSString stringWithFormat:@"%@年%@月%@日",[dateString substringWithRange:NSMakeRange(0, 4)],[dateString substringWithRange:NSMakeRange(5, 2)],[dateString substringWithRange:NSMakeRange(8, 2)]];
            NSDate *toDate = [[[CalendarDateCaculate sharedInstance] dateFormmatter] dateFromString:toDateString];
            NSDateComponents *dayComponents = [[[CalendarDateCaculate sharedInstance] calender] components:NSDayCalendarUnit fromDate:fromDate toDate:toDate options:0];
            if (dayComponents.day>-1 && dayComponents.day < 7) {
                [mutableArr replaceObjectAtIndex:dayComponents.day withObject:[NSString stringWithFormat:@"%@",dic.sleepQuality]];
                [mutableTimeArr replaceObjectAtIndex:dayComponents.day withObject:[NSString stringWithFormat:@"%@",dic.sleepDuration]];
            }
            
        }
        dispatch_async_on_main_queue(^{
            block(mutableArr,mutableTimeArr);
        });
    });
}

+ (void)filterMonthReportData:(NSArray *)reportData queryDate:(id)query callBack:(void (^)(id qualityBack,id sleepDurationBack))block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *mutableArr = [[NSMutableArray alloc]init];
        NSMutableArray *mutableTimeArr = [[NSMutableArray alloc]init];
        if (mutableArr.count>0) {
            [mutableArr removeAllObjects];
        }
        if (mutableTimeArr.count>0) {
            [mutableTimeArr removeAllObjects];
        }
        
        NSString *queryStart = [(NSDictionary *)query objectForKey:@"queryStartTime"];
        if ([queryStart isEqualToString:@"20151221"]) {
            return;
        }
        NSString *year = [queryStart substringWithRange:NSMakeRange(0, 4)];
        NSString *month = [queryStart substringWithRange:NSMakeRange(4, 2)];
        NSString *fromDateString = [NSString stringWithFormat:@"%@年%@月01日",year,month];
        NSDate *fromDate = [[[[CalendarDateCaculate sharedInstance] dateFormmatter] dateFromString:fromDateString] dateByAddingHours:8];
        NSInteger dayNums = [fromDate getdayNumsInOneMonth];
        DeBugLog(@"测试时间数：%ld,fromdate 是%@",(long)dayNums,fromDate);
        for (int i=0; i<dayNums; i++) {
            [mutableArr addObject:[NSString stringWithFormat:@"0"]];
            [mutableTimeArr addObject:[NSString stringWithFormat:@"0"]];
        }
        for (int i=0; i<reportData.count; i++) {
            QualityDetailModel *dic = [reportData objectAtIndex:i];
            NSString *dateString = dic.date;
            NSString *toDateString = [NSString stringWithFormat:@"%@年%@月%@日",[dateString substringWithRange:NSMakeRange(0, 4)],[dateString substringWithRange:NSMakeRange(5, 2)],[dateString substringWithRange:NSMakeRange(8, 2)]];
            NSDate *toDate = [[[[CalendarDateCaculate sharedInstance] dateFormmatter] dateFromString:toDateString]dateByAddingHours:8];
            NSDateComponents *dayComponents = [[[CalendarDateCaculate sharedInstance] calender] components:NSDayCalendarUnit fromDate:fromDate toDate:toDate options:0];
            if (dayComponents.day>-1 && dayComponents.day < dayNums+1) {
                [mutableArr replaceObjectAtIndex:dayComponents.day withObject:[NSString stringWithFormat:@"%@",dic.sleepQuality]];
                [mutableTimeArr replaceObjectAtIndex:dayComponents.day withObject:[NSString stringWithFormat:@"%@",dic.sleepDuration]];
            }
            
        }
        dispatch_async_on_main_queue(^{
            block(mutableArr,mutableTimeArr);
        });
    });
}

+ (void)filterQuaterReportData:(NSArray *)reportData queryDate:(id)query callBack:(void (^)(id qualityBack,id sleepDurationBack))block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *mutableArr = [[NSMutableArray alloc]init];
        NSMutableArray *mutableTimeArr = [[NSMutableArray alloc]init];
        if (mutableArr.count>0) {
            [mutableArr removeAllObjects];
        }
        if (mutableTimeArr.count>0) {
            [mutableTimeArr removeAllObjects];
        }
        for (int i=0; i<3; i++) {
            [mutableArr addObject:[NSString stringWithFormat:@"0"]];
            [mutableTimeArr addObject:[NSString stringWithFormat:@"0"]];
        }
        
        NSString *queryStart = [(NSDictionary *)query objectForKey:@"queryStartTime"];
        NSString *monthFrom = [queryStart substringWithRange:NSMakeRange(4, 2)];

        for (int i=0; i<reportData.count; i++) {
            QualityDetailModel *dic = [reportData objectAtIndex:i];
            NSString *dateString = dic.date;
            NSString *month = [dateString substringWithRange:NSMakeRange(5, 2)];
            int path = [month intValue]-[monthFrom intValue];
            if (path>=0 && path<3) {
                [mutableArr replaceObjectAtIndex:path withObject:[NSString stringWithFormat:@"%@",dic.sleepQuality]];
                [mutableTimeArr replaceObjectAtIndex:path withObject:[NSString stringWithFormat:@"%@",dic.sleepDuration]];
            }
            
        }
        dispatch_async_on_main_queue(^{
            block(mutableArr,mutableTimeArr);
        });
    });
}

+ (void)filterAverSensorDataWithTime:(SensorDataModel *)sensorData callBack:(void(^)(int callBack))block{
    @synchronized(self) {
        if (sensorData) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                int averX = 0;
                SensorDataInfo *sensorArr = [sensorData.sensorDataList objectAtIndex:0];
                NSArray *sensorInfo = sensorArr.propertyDataList;
                for (int i = 0; i<sensorInfo.count; i++) {
                    PropertyData *dic = [sensorInfo objectAtIndex:i];
                    averX += [dic.propertyValue intValue];
                }
                dispatch_async_on_main_queue(^{
                    block((int)(averX/(sensorInfo.count)));
                });
            });
        }
    }
}

@end
