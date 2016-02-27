//
//  CalendarDateCaculate.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/26.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "CalendarDateCaculate.h"
#import "NSDate+NSDateLogic.h"

static CalendarDateCaculate *shareInstance = nil;

@interface CalendarDateCaculate ()


@end

@implementation CalendarDateCaculate

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[CalendarDateCaculate alloc]init];
    });
    return shareInstance;
}

- (NSString *)getCurrentWeekInOneYear:(NSDate *)nowDate
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //获取当前日期
    unsigned unitFlags = NSYearCalendarUnit | NSWeekOfYearCalendarUnit;
    NSDateComponents* comp = [gregorian components: unitFlags fromDate:nowDate];
    NSString *year = [[NSString stringWithFormat:@"%@",nowDate] substringToIndex:4];

    return [NSString stringWithFormat:@"%@年第%ld周",year,comp.weekOfYear];
}

- (NSString *)getCurrentMonthInOneYear:(NSDate *)nowDate
{
    NSString *currentDate = [[NSString stringWithFormat:@"%@",nowDate]substringToIndex:7];
    NSString *year = [currentDate substringToIndex:4];
    NSString *month = [currentDate substringWithRange:NSMakeRange(5, 2)];
    return [NSString stringWithFormat:@"%@年%@月",year,month];
}

- (NSString *)getCurrentQuaterInOneYear:(NSDate *)nowDate
{
    NSString *currentDate = [[NSString stringWithFormat:@"%@",nowDate]substringToIndex:7];
    NSString *year = [currentDate substringToIndex:4];
    NSString *month = [currentDate substringWithRange:NSMakeRange(5, 2)];
    NSString *quater = [self changeMonthToQuater:month];
    return [NSString stringWithFormat:@"%@年第%@季度",year,quater];
}


- (NSString *)getWeekTimeDuration:(NSDate *)nowDate
{
    NSDate *dateOut = nil;
    NSTimeInterval count = 0;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    BOOL b = [gregorian rangeOfUnit:NSWeekCalendarUnit startDate:&dateOut interval:&count forDate:nowDate];
    self.dateComponents.day = 6;//设置日开始
    NSDate *new = [[NSCalendar currentCalendar] dateByAddingComponents:self.dateComponents toDate:dateOut options:0];
    NSString *start = [[NSString stringWithFormat:@"%@",dateOut] substringWithRange:NSMakeRange(5, 5)];
    NSString *newStart = [NSString stringWithFormat:@"%@月%@日",[start substringWithRange:NSMakeRange(0, 2)],[start substringWithRange:NSMakeRange(3, 2)]];
    NSString *end = [[NSString stringWithFormat:@"%@",new] substringWithRange:NSMakeRange(5, 5)];
    NSString *newEnd = [NSString stringWithFormat:@"%@月%@日",[end substringWithRange:NSMakeRange(0, 2)],[end substringWithRange:NSMakeRange(3, 2)]];
    if (b) {
        return [NSString stringWithFormat:@"%@到%@",newStart,newEnd];
    }
    return @"";
}

- (NSString *)getQuaterTimeDuration:(NSDate *)nowDate
{
    NSString *currentDate = [[NSString stringWithFormat:@"%@",nowDate]substringToIndex:7];
    NSString *month = [currentDate substringWithRange:NSMakeRange(5, 2)];
    NSString *quater = [self changeMonthToQuater:month];
    NSString *monthLength = [self changeQuaterToMonth:[quater intValue]];
    return monthLength;
}

- (void)getChangeWeek:(NSString*)monthTitleString monthSubTitleString:(NSString *)monthSub withWeekStep:(CalendarStepType)type callBack:(void (^)(NSString*monthTitle,NSString *monthSubTitle))block
{
    //周数计算
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSRange range = [monthTitleString rangeOfString:@"年"];
        NSString *year = [monthTitleString substringToIndex:range.location];
        NSRange range1 = [monthSub rangeOfString:@"到"];
        NSString *now = [NSString stringWithFormat:@"%@年%@",year,[monthSub substringToIndex:range1.location]];
        NSDate *nowdate = [self.dateFormmatter dateFromString:now];
        int step = type == CalendarStepTypeLast ? -7 : 7;
        self.dateComponents.day = step;
        NSDate *nextWeekStart = [[NSCalendar currentCalendar] dateByAddingComponents:self.dateComponents toDate:nowdate options:0];//下周的日期
        NSString *lastMonthTitle = [self getCurrentWeekInOneYear:nextWeekStart];//上周的周数
        //计算范围
        NSDate *dateOut = nil;
        NSTimeInterval count = 0;
        BOOL b = [self.calender rangeOfUnit:NSWeekCalendarUnit startDate:&dateOut interval:&count forDate:nextWeekStart];
        self.dateComponents.day = 6;
        NSDate *nextWeekEnd = [[NSCalendar currentCalendar] dateByAddingComponents:self.dateComponents toDate:dateOut options:0];
        NSString *start = [[NSString stringWithFormat:@"%@",dateOut] substringWithRange:NSMakeRange(5, 5)];
        NSString *newStart = [NSString stringWithFormat:@"%@月%@日",[start substringWithRange:NSMakeRange(0, 2)],[start substringWithRange:NSMakeRange(3, 2)]];
        NSString *end = [[NSString stringWithFormat:@"%@",nextWeekEnd] substringWithRange:NSMakeRange(5, 5)];
        NSString *newEnd = [NSString stringWithFormat:@"%@月%@日",[end substringWithRange:NSMakeRange(0, 2)],[end substringWithRange:NSMakeRange(3, 2)]];
        NSString *subMonth;
        if (b) {
            subMonth = [NSString stringWithFormat:@"%@到%@",newStart,newEnd];
        }
        dispatch_async_on_main_queue(^{
            block(lastMonthTitle,subMonth);
        });
    });
}

- (void)getChangeMonth:(NSString *)monthTitleString withCalendarStep:(CalendarStepType)type callBack:(void (^)(NSString*monthTitle,NSInteger daysInMonth))block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSDate *showDate = [self.dateMonthFormmatter dateFromString:monthTitleString];
        NSDate *nextMonth = [self dayInTheLastOrNextMonth:showDate withType:type];
        NSString *nextMonthString = [NSString stringWithFormat:@"%@",nextMonth];
        NSString *subString = [nextMonthString substringToIndex:10];
        NSString *year = [subString substringToIndex:4];
        NSString *month = [subString substringWithRange:NSMakeRange(5, 2)];
        NSString *monthString = [NSString stringWithFormat:@"%@年%@月",year,month];
        NSInteger dayNums = [self getdayNumsInOneMonth:nextMonth];
        dispatch_async_on_main_queue(^{
            block(monthString,dayNums);
        });
    });
}

- (void)getChangeQuater:(NSString*)monthTitleString withQuaterStep:(CalendarStepType)type callBack:(void (^)(NSString*monthTitle,NSString *monthSubTitle))block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSRange range = [monthTitleString rangeOfString:@"年第"];
        NSString *year = [monthTitleString substringToIndex:range.location];
        NSString *quater = [monthTitleString substringWithRange:NSMakeRange(range.length +range.location, 1)];
        int nowQuater = 0;
        int nowYear = 0;
        if (type == CalendarStepTypeLast) {
            nowQuater = [quater intValue] - 1;
            nowYear = [year intValue];
            if (nowQuater==0) {
                nowQuater = 4;
                nowYear = nowYear - 1;
            }
        }else{
            nowQuater = [quater intValue] + 1;
            nowYear = [year intValue];
            if (nowQuater==5) {
                nowQuater = 1;
                nowYear = nowYear + 1;
            }
        }
        NSString *month = [NSString stringWithFormat:@"%d年第%d季度",nowYear,nowQuater];
        NSString *subMonth = [self changeQuaterToMonth:nowQuater];
        dispatch_async_on_main_queue(^{
            block(month,subMonth);
        });
        
    });
}

- (void)getSelectWeekMonth:(NSString *)monthTitle selectedMonth:(NSString *)selectMonth subMonth:(NSString *)subMonth callBack:(void (^)(NSString*monthTitle,NSString *monthSubTitle))block
{
    NSInteger oldYear = [[monthTitle substringToIndex:4] intValue];
    NSInteger newYear = [[selectMonth substringToIndex:4]intValue];
    //
    NSRange range = [monthTitle rangeOfString:@"年第"];
    NSString *sub2 = [monthTitle substringFromIndex:range.location + range.length];
    NSRange range1 = [sub2 rangeOfString:@"周"];
    NSString *sub3 = [sub2 substringToIndex:range1.location];
    NSInteger oldWeek = [sub3 integerValue];
    //
    NSRange rangeM = [selectMonth rangeOfString:@"年第"];
    NSString *sub2M = [selectMonth substringFromIndex:rangeM.location + rangeM.length];
    NSRange range1M = [sub2M rangeOfString:@"周"];
    NSString *sub3M = [sub2M substringToIndex:range1M.location];
    NSInteger newWeek = [sub3M integerValue];
    //
    NSString *monthStringSelcet = [NSString stringWithFormat:@"%ld年%@月",newYear,@"06"];
    NSDate *selectedDate = [self.dateMonthFormmatter dateFromString:monthStringSelcet];
    NSInteger weekInNewYear = [selectedDate getWeekNumsInOneYear];
    //
    NSInteger totalWeek = (newYear - oldYear)*weekInNewYear + (newWeek - oldWeek);
    //计算新的日期
    NSRange rangeN = [monthTitle rangeOfString:@"年"];
    NSString *year = [monthTitle substringToIndex:rangeN.location];
    NSRange range1N = [subMonth rangeOfString:@"到"];
    NSString *now = [NSString stringWithFormat:@"%@年%@",year,[subMonth substringToIndex:range1N.location]];
    NSDate *nowdate = [self.dateFormmatter dateFromString:now];
    self.dateComponents.day = 7*totalWeek;
    NSDate *nextWeekStart = [[NSCalendar currentCalendar] dateByAddingComponents:self.dateComponents toDate:nowdate options:0];//下周的日期
    NSString *weekNumString = [self getCurrentWeekInOneYear:nextWeekStart];//周
    NSString *selectDuration = [self getWeekTimeDuration:nextWeekStart];
    block(weekNumString,selectDuration);
}

- (NSInteger)getdayNumsInOneMonth:(NSDate *)date
{
    NSRange rangeW = [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    return rangeW.length;
}


- (NSDate*)dayInTheLastOrNextMonth:(NSDate *)date withType:(CalendarStepType)step
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = step == CalendarStepTypeLast? -1 : 1;
    dateComponents.day = 1;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
}

- (NSInteger)getCurrentMonthDayNum:(NSString *)year month:(NSString *)month
{
    NSString *dateString = [NSString stringWithFormat:@"%@年%@月06日",year,month];
    NSDate *date = [self.dateFormmatter dateFromString:dateString];
    NSInteger dayNum = [date getdayNumsInOneMonth];
    return dayNum;
}

- (NSString *)changeMonthToQuater:(NSString *)month
{
    int monthNum = [month intValue];
    if (monthNum>0 && monthNum<4) {
        return @"1";
    }else if (monthNum>3 && monthNum<7){
        return @"2";
    }else if (monthNum>6 && monthNum<10){
        return @"3";
    }else{
        return @"4";
    }
}

- (NSString *)changeQuaterToMonth:(int)quater
{
    NSString *month ;
    switch (quater) {
        case 1:{
            month = @"01月到03月";
            return month;
            break;
        }
        case 2:{
            month = @"04月到06月";
            return month;
            break;
        }
        case 3:{
            month = @"07月到09月";
            return month;
            break;
        }
        case 4:{
            month = @"10月到12月";
            return month;
            break;
        }
            
        default:
            month = @"01月到03月";
            return month;
            break;
    }
}

#pragma mark setter

- (NSDateComponents*)dateComponents
{
    if (!_dateComponents) {
        _dateComponents = [[NSDateComponents alloc] init];
        _dateComponents.timeZone = self.tmZone;
    }
    return _dateComponents;
}

- (NSTimeZone *)tmZone
{
    if (!_tmZone) {
        _tmZone = [NSTimeZone timeZoneWithName:@"GMT"];
        [NSTimeZone setDefaultTimeZone:_tmZone];
    }
    return _tmZone;
}

- (NSCalendar *)calender
{
    if (!_calender) {
        _calender = [NSCalendar currentCalendar];
        _calender.timeZone = self.tmZone;
    }
    return _calender;
}

- (NSDateFormatter *)dateFormmatter
{
    if (!_dateFormmatter) {
        _dateFormmatter = [[NSDateFormatter alloc]init];
        [_dateFormmatter setDateFormat:@"yyyy年MM月dd日"];
    }
    return _dateFormmatter;
}

- (NSDateFormatter *)dateMonthFormmatter
{
    if (!_dateMonthFormmatter) {
        _dateMonthFormmatter = [[NSDateFormatter alloc]init];
        [_dateMonthFormmatter setDateFormat:@"yyyy年MM月"];
    }
    return _dateMonthFormmatter;
}


@end
