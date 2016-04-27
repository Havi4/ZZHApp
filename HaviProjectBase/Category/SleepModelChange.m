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
        NSString *sleepDuration = detail.sleepDuration;
        int hour = [sleepDuration intValue];
        double second2 = 0.0;
        double subsecond2 = modf([sleepDuration floatValue], &second2);
        NSString *sleepTimeDuration= @"";
        if((int)round(subsecond2*60)<10){
            sleepTimeDuration = [NSString stringWithFormat:@"%@时0%d分",hour<10?[NSString stringWithFormat:@"0%d",hour]:[NSString stringWithFormat:@"%d",hour],(int)round(subsecond2*60)];
        }else{
            sleepTimeDuration = [NSString stringWithFormat:@"%@时%d分",hour<10?[NSString stringWithFormat:@"0%d",hour]:[NSString stringWithFormat:@"%d",hour],(int)round(subsecond2*60)];
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
            [mutableArr replaceObjectAtIndex:dayComponents.day withObject:[NSString stringWithFormat:@"%@",dic.sleepQuality]];
            [mutableTimeArr replaceObjectAtIndex:dayComponents.day withObject:[NSString stringWithFormat:@"%@",dic.sleepDuration]];
            
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
            NSDate *toDate = [[[CalendarDateCaculate sharedInstance] dateFormmatter] dateFromString:toDateString];
            NSDateComponents *dayComponents = [[[CalendarDateCaculate sharedInstance] calender] components:NSDayCalendarUnit fromDate:fromDate toDate:toDate options:0];
            [mutableArr replaceObjectAtIndex:dayComponents.day withObject:[NSString stringWithFormat:@"%@",dic.sleepQuality]];
            [mutableTimeArr replaceObjectAtIndex:dayComponents.day withObject:[NSString stringWithFormat:@"%@",dic.sleepDuration]];
            
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
            [mutableArr replaceObjectAtIndex:path withObject:[NSString stringWithFormat:@"%@",dic.sleepQuality]];
            [mutableTimeArr replaceObjectAtIndex:path withObject:[NSString stringWithFormat:@"%@",dic.sleepDuration]];
            
        }
        dispatch_async_on_main_queue(^{
            block(mutableArr,mutableTimeArr);
        });
    });
}

@end
