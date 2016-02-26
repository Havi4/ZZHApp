//
//  SleepModelChange.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/24.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "SleepModelChange.h"

@implementation SleepModelChange

+ (void)changeSleepDuration:(id)obj callBack:(void(^)(id callBack))block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SleepQualityModel *model = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithArray:model.data];
//        NSString *selectString = [NSString stringWithFormat:@"%@",selectedDateToUse];
//        NSString *subString = [selectString substringToIndex:10];
        //测试
        NSString *subString = @"2015-12-21";
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
//        NSString *selectString = [NSString stringWithFormat:@"%@",selectedDateToUse];
//        NSString *subString = [selectString substringToIndex:10];
        NSString *subString = @"2015-12-21";
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
        NSString *month = [NSString stringWithFormat:@"%ld",date.month];
        if (date.month < 10) {
            month = [NSString stringWithFormat:@"0%ld",date.month];
        }
        NSString *day = [NSString stringWithFormat:@"%ld",date.day];
        if (date.day < 10) {
            day = [NSString stringWithFormat:@"0%ld",date.day];
        }
        NSString *queryString = [NSString stringWithFormat:@"%ld%@%@",date.year,month,day];
        return queryString;
    }
}

+ (void)filterSensorDataWithTime:(SensorDataModel *)sensorData callBack:(void(^)(id callBack))block
{

    @synchronized(self) {
        if (sensorData) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                SensorDataInfo *sensorArr = [sensorData.sensorDataList objectAtIndex:0];
                NSArray *sensorInfo = sensorArr.propertyDataList;
                NSMutableArray *arr = [[NSMutableArray alloc]init];
                for (int i=0; i<kChartDataCount; i++) {
                    if (sensorArr.properyType == 3) {
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

@end
