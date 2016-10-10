//
//  NewCalendarViewController.m
//  HaviProjectBase
//
//  Created by Havi on 16/8/1.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "NewCalendarViewController.h"
#import "XHRealTimeBlur.h"
#import "MonthTableViewCell.h"

@interface NewCalendarViewController ()<JTCalendarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSMutableDictionary *_eventsByDate;
    UITableView *calTableview;
    NSDate *_dateSelected;
    NSArray *iconArr;
    NSArray *titleArr;
}
@property (nonatomic, strong) SCBarButtonItem *leftBarItem;

@end

@implementation NewCalendarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.leftBarItem = [[SCBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_navi_back"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    iconArr = @[@"zhong",@"chang",@"duan",@"zan",@"dao"];
    titleArr = @[@"平均睡眠时长",@"最长夜晚",@"最短夜晚",@"最高睡眠得分",@"最低睡眠得分"];
    
    self.sc_navigationItem.leftBarButtonItem = self.leftBarItem;
    self.sc_navigationItem.title = @"选择日期";
    
    XHRealTimeBlur *blur = [[XHRealTimeBlur alloc]initWithFrame:self.view.bounds];
    blur.blurStyle = XHBlurStyleWhite;
    calTableview = [[UITableView alloc]initWithFrame:(CGRect){0,64,self.view.frame.size.width,self.view.frame.size.height -64} style:UITableViewStylePlain];
    calTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    calTableview.showsVerticalScrollIndicator = NO;
    calTableview.backgroundColor = [UIColor whiteColor];
    calTableview.dataSource = self;
    calTableview.delegate = self;
    [self.view addSubview:blur];
    [self.view addSubview:calTableview];
    _calendarMenuView = [[JTCalendarMenuView alloc]initWithFrame:(CGRect){101,0,self.view.frame.size.width-201,44}];
    _calendarContentView = [[JTHorizontalCalendarView alloc]initWithFrame:(CGRect){0,0,self.view.frame.size.width,290}];
    
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    
    _calendarManager.settings.pageViewHaveWeekDaysView = NO;
    _calendarManager.settings.pageViewNumberOfWeeks = 0; // Automatic
    _weekDayView = [[JTCalendarWeekDayView alloc]initWithFrame:(CGRect){0,0,self.view.frame.size.width,44}];
    _weekDayView.manager = _calendarManager;
    [_weekDayView reload];
    // Generate random events sort by date using a dateformatter for the demonstration
    [self createRandomEvents];
    
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:[NSDate date]];
    
    _calendarMenuView.scrollView.scrollEnabled = NO; // Scroll not supported with JTVerticalCalendarView
//    [self.view addSubview:_calendarContentView];
//    [self.view addSubview:_calendarMenuView];
//    [self.view addSubview:_weekDayView];
}

#pragma mark delegate 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 3) {
        static NSString *cellIntifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIntifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIntifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row==0) {
            [cell addSubview:_calendarMenuView];
            UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
            leftButton.tag = 800;
            leftButton.frame = CGRectMake(56, 0, 44, 44);
            [leftButton setImage:[UIImage imageNamed:@"jtz@3x"] forState:UIControlStateNormal];
            [cell addSubview:leftButton];
            [leftButton addTarget:self action:@selector(changeMonth:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
            rightButton.tag = 801;
            rightButton.frame = CGRectMake(self.view.frame.size.width-101, 0, 44, 44);
            [rightButton addTarget:self action:@selector(changeMonth:) forControlEvents:UIControlEventTouchUpInside];
            [rightButton setImage:[UIImage imageNamed:@"jiant@3x"] forState:UIControlStateNormal];
            [cell addSubview:rightButton];
        }else if (indexPath.row ==1){
            [cell addSubview:_weekDayView];
        }else if (indexPath.row == 2){
            [cell addSubview:_calendarContentView];
        }
        return cell;
    }else{
        MonthTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"subCell"];
        if (!cell) {
            cell = [[MonthTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"subCell"];
        }
        if (indexPath.row > 2){
            NSString *icon = [iconArr objectAtIndex:indexPath.row-3];
            NSString *title = [titleArr objectAtIndex:indexPath.row -3];
            [cell configure:nil customObj:icon indexPath:indexPath withOtherInfo:title];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor =[UIColor clearColor];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==0) {
        return 40;
    }else if (indexPath.row ==1){
        return 40;
    }else if (indexPath.row== 2){
        return 290;
    }else{
        return 60;
    }
    return 0;
}

- (void)changeMonth:(UIButton *)button
{
    if (button.tag == 800) {
        [_calendarContentView loadPreviousPageWithAnimation];
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"selectCalendar" object:nil userInfo:@{@"code":@0}];
    }else if (button.tag == 801){
        [_calendarContentView loadNextPageWithAnimation];
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"selectCalendar" object:nil userInfo:@{@"code":@1}];
    }
}

#pragma mark - CalendarManager delegate

// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    
    dayView.hidden = NO;
    double p = arc4random_uniform(100);
    double end = p/100;
    [dayView.bgCircleView setPercentage:end];
    
    // Hide if from another month
    if([dayView isFromAnotherMonth]){
        dayView.hidden = YES;
    }
    
    // Today
    else if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor colorWithRed:0.043 green:0.322 blue:0.396 alpha:1.00];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Selected date
    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor clearColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Other month
    else if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor colorWithRed:0.043 green:0.322 blue:0.396 alpha:1.00];
    }
    
    if([self haveEventForDay:dayView.date]){
        dayView.dotView.hidden = NO;
    }
    else{
    }
    dayView.dotView.hidden = YES;
    if ([dayView.date isLaterThan:[NSDate date]]) {
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    _dateSelected = dayView.date;
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    
    // Don't change page in week mode because block the selection of days in first and last weeks of the month
    if(_calendarManager.settings.weekModeEnabled){
        return;
    }
    
    // Load the previous or next page if touch a day from another month
    
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
    if ([_dateSelected isLaterThan:[NSDate date]]) {
        [NSObject showHudTipStr:@"请选择历史日期"];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

#pragma mark - Fake data

// Used only to have a key for _eventsByDate
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}

- (BOOL)haveEventForDay:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    if(_eventsByDate[key] && [_eventsByDate[key] count] > 0){
        return YES;
    }
    
    return NO;
    
}

- (void)createRandomEvents
{
    _eventsByDate = [NSMutableDictionary new];
    
    for(int i = 0; i < 30; ++i){
        // Generate 30 random dates between now and 60 days later
        NSDate *randomDate = [NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 60)) sinceDate:[NSDate date]];
        
        // Use the date as key for eventsByDate
        NSString *key = [[self dateFormatter] stringFromDate:randomDate];
        
        if(!_eventsByDate[key]){
            _eventsByDate[key] = [NSMutableArray new];
        }
        
        [_eventsByDate[key] addObject:randomDate];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (_dateSelected) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"kSelectedNewDate" object:nil userInfo:@{@"date":_dateSelected}];
    }
}
@end
