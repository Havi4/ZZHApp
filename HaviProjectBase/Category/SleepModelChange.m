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

@end
