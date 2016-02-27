//
//  NSDate+NSDateLogic.m
//  SleepRecoding
//
//  Created by Havi on 15/4/12.
//  Copyright (c) 2015年 Havi. All rights reserved.
//

#import "NSDate+NSDateLogic.h"

@implementation NSDate (NSDateLogic)

- (NSInteger)getWeekNumsInOneYear
{
    NSRange rangeW = [[NSCalendar currentCalendar] rangeOfUnit:NSWeekCalendarUnit inUnit:NSYearCalendarUnit forDate:self];
    return rangeW.length;
}

- (NSInteger)getdayNumsInOneMonth
{
    NSRange rangeW = [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self];
    return rangeW.length;
}

@end
