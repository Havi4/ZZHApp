//
//  CalendarDateCaculate.h
//  HaviProjectBase
//
//  Created by Havi on 16/2/26.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    CalendarStepTypeLast = 0,
    CalendarStepTypeNext,
} CalendarStepType;

@interface CalendarDateCaculate : NSObject

+ (instancetype)sharedInstance;

//获取当前日期所在的周
- (NSString *)getCurrentWeekInOneYear:(NSDate *)nowDate;
//获取当前日期所在的月
- (NSString *)getCurrentMonthInOneYear:(NSDate *)nowDate;
//获取当前日期所在的季度
- (NSString *)getCurrentQuaterInOneYear:(NSDate *)nowDate;
//将月份转换为季度
- (NSString *)changeMonthToQuater:(NSString *)month;
//获取日期所在周的时间范围
- (NSString *)getWeekTimeDuration:(NSDate *)nowDate;
//获取一个季度是时间范围
- (NSString *)getQuaterTimeDuration:(NSDate *)nowDate;
//季度装换为月份范围
- (NSString *)changeQuaterToMonth:(int)quater;
//获取指定年月中的天数
- (NSInteger)getCurrentMonthDayNum:(NSString *)year month:(NSString *)month;
//获取上一周数，及周的时间范围
- (void)getChangeWeek:(NSString*)monthTitleString monthSubTitleString:(NSString *)monthSub withWeekStep:(CalendarStepType)type callBack:(void (^)(NSString*monthTitle,NSString *monthSubTitle))block;
//获取上一月
- (void)getChangeMonth:(NSString *)monthTitleString withCalendarStep:(CalendarStepType)type callBack:(void (^)(NSString*monthTitle,NSInteger daysInMonth))block;

- (void)getChangeQuater:(NSString*)monthTitleString withQuaterStep:(CalendarStepType)type callBack:(void (^)(NSString*monthTitle,NSString *monthSubTitle))block;

//获取选定的周数
- (void)getSelectWeekMonth:(NSString *)monthTitle selectedMonth:(NSString *)selectMonth subMonth:(NSString *)subMonth callBack:(void (^)(NSString*monthTitle,NSString *monthSubTitle))block;
@end
