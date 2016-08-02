//
//  NewCalendarViewController.h
//  HaviProjectBase
//
//  Created by Havi on 16/8/1.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "JTCalendar.h"
@interface NewCalendarViewController : BaseViewController
@property (strong, nonatomic) JTCalendarMenuView *calendarMenuView;
@property (strong, nonatomic) JTCalendarWeekDayView *weekDayView;
@property (strong, nonatomic) JTHorizontalCalendarView *calendarContentView;

@property (strong, nonatomic) JTCalendarManager *calendarManager;

@end
