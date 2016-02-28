//
//  CalendarShowView.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/26.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "CalendarShowView.h"
#import "CalendarDateCaculate.h"
#import "WeekCalenderView.h"
#import "MonthCalenderView.h"
#import "QuaterCalenderView.h"

@interface CalendarShowView ()<SelectedWeek,SelectedMonth,SelectedQuater>

@property (nonatomic, strong) UIView *calenderBackView;
@property (nonatomic,strong) UIButton *leftCalButton;
@property (nonatomic,strong) UIButton *rightCalButton;
@property (nonatomic,strong) UILabel *monthTitleLabel;
@property (nonatomic,strong) UIImageView *calenderImage;
@property (nonatomic,strong) UILabel *monthLabel;
@property (nonatomic,assign) ReportViewType reportType;

@end

@implementation CalendarShowView

- (instancetype)initWithFrame:(CGRect)frame withReportType:(ReportViewType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.reportType = type;
        [self addSubview:self.calenderBackView];
    }
    return self;
}

- (UIView *)calenderBackView
{
    if (!_calenderBackView) {
        _calenderBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 69)];
        _calenderBackView.backgroundColor = selectedThemeIndex==0?[UIColor colorWithRed:0.012f green:0.082f blue:0.184f alpha:1.00f]:[UIColor colorWithRed:0.349f green:0.608f blue:0.780f alpha:1.00f];
        //
        [_calenderBackView addSubview:self.monthTitleLabel];
        [self.monthTitleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_calenderBackView.mas_centerX).offset(-10);
            make.height.equalTo(@34.5);
            make.top.equalTo(_calenderBackView.mas_top);
            
        }];
        //
        [_calenderBackView addSubview:self.calenderImage];
        [self.calenderImage makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.monthTitleLabel.mas_right).offset(10);
            make.width.height.equalTo(@20);
            make.centerY.equalTo(self.monthTitleLabel.mas_centerY);
        }];
        //
        [_calenderBackView addSubview:self.leftCalButton];
        [self.leftCalButton makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.monthTitleLabel.mas_left).offset(-15);
            make.centerY.equalTo(self.monthTitleLabel.mas_centerY);
            make.height.equalTo(@20);
            make.width.equalTo(@15);
        }];
        //
        [_calenderBackView addSubview:self.rightCalButton];
        [self.rightCalButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.calenderImage.mas_right).offset(15);
            make.centerY.equalTo(self.monthTitleLabel.mas_centerY);
            make.height.equalTo(@20);
            make.width.equalTo(@15);
        }];
        //
        [_calenderBackView addSubview:self.monthLabel];
        [self.monthLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_calenderBackView);
            make.top.equalTo(self.monthTitleLabel.mas_bottom);
            make.height.equalTo(@34.5);
        }];
    }
    return _calenderBackView;
}

- (UILabel *)monthTitleLabel
{
    if (!_monthTitleLabel) {
        _monthTitleLabel = [[UILabel alloc]init];
        _monthTitleLabel.font = [UIFont systemFontOfSize:18];
        _monthTitleLabel.textColor = selectedThemeIndex==0?kDefaultColor:[UIColor whiteColor];
        _monthTitleLabel.textAlignment = NSTextAlignmentCenter;
        if (self.reportType == ReportViewWeek) {
            _monthTitleLabel.text = [[CalendarDateCaculate sharedInstance] getCurrentWeekInOneYear:[NSDate date]];
        }else if (self.reportType == ReportViewMonth){
            _monthTitleLabel.text = [[CalendarDateCaculate sharedInstance]getCurrentMonthInOneYear:[NSDate date]];
        }else if (self.reportType == ReportViewQuater){
            _monthTitleLabel.text = [[CalendarDateCaculate sharedInstance] getCurrentQuaterInOneYear:[NSDate date]];
        }
    }
    return _monthTitleLabel;
}

- (UIImageView *)calenderImage
{
    if (!_calenderImage) {
        _calenderImage = [[UIImageView alloc]init];
        _calenderImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"menology_%d",selectedThemeIndex]];
        _calenderImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showCalender:)];
        [_calenderImage addGestureRecognizer:tapImage];
    }
    return _calenderImage;
}

- (UIButton *)leftCalButton
{
    if (!_leftCalButton) {
        _leftCalButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftCalButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_back_%d",selectedThemeIndex]] forState:UIControlStateNormal];
        [_leftCalButton addTarget:self action:@selector(lastStep:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftCalButton;
}

- (UIButton *)rightCalButton
{
    if (!_rightCalButton) {
        _rightCalButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightCalButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_right_%d",selectedThemeIndex]] forState:UIControlStateNormal];
        [_rightCalButton addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightCalButton;
}

- (UILabel *)monthLabel
{
    if (!_monthLabel) {
        _monthLabel = [[UILabel alloc]init];
        _monthLabel.font = [UIFont systemFontOfSize:16];
        _monthLabel.textColor = selectedThemeIndex==0?kDefaultColor:[UIColor whiteColor];
        _monthLabel.textAlignment = NSTextAlignmentCenter;
        if (self.reportType == ReportViewWeek) {
            _monthLabel.text = [[CalendarDateCaculate sharedInstance]getWeekTimeDuration:[NSDate date]];
        }else if (self.reportType == ReportViewMonth){
            _monthLabel.text = @"";
        }else if (self.reportType == ReportViewQuater){
            _monthLabel.text = [[CalendarDateCaculate sharedInstance] getQuaterTimeDuration:[NSDate date]];
        }
    }
    return _monthLabel;
}

- (void)lastStep:(UIButton *)sender
{
    switch (self.reportType) {
        case ReportViewWeek:
        {
            @weakify(self);
            [[CalendarDateCaculate sharedInstance] getChangeWeek:self.monthTitleLabel.text monthSubTitleString:self.monthLabel.text withWeekStep:CalendarStepTypeLast callBack:^(NSString *monthTitle, NSString *monthSubTitle) {
                @strongify(self);
                self.monthTitleLabel.text = monthTitle;
                self.monthLabel.text = monthSubTitle;
                [self changeQueryDate];
            }];
            break;
        }
        case ReportViewMonth:{
            @weakify(self);
            [[CalendarDateCaculate sharedInstance]getChangeMonth:self.monthTitleLabel.text withCalendarStep:CalendarStepTypeLast callBack:^(NSString *monthTitle, NSInteger daysInMonth) {
                @strongify(self);
                self.monthTitleLabel.text = monthTitle;
                [self changeQueryDate];
            }];
            break;
        }
        case ReportViewQuater:{
            @weakify(self);
            [[CalendarDateCaculate sharedInstance]getChangeQuater:self.monthTitleLabel.text withQuaterStep:CalendarStepTypeLast callBack:^(NSString *monthTitle, NSString *monthSubTitle) {
                @strongify(self);
                self.monthTitleLabel.text = monthTitle;
                self.monthLabel.text = monthSubTitle;
                [self changeQueryDate];
            }];
            break;
        }
            
        default:
            break;
    }
}

- (void)nextStep:(UIButton *)sender
{
    switch (self.reportType) {
        case ReportViewWeek:
        {
            @weakify(self);
            [[CalendarDateCaculate sharedInstance] getChangeWeek:self.monthTitleLabel.text monthSubTitleString:self.monthLabel.text withWeekStep:CalendarStepTypeNext callBack:^(NSString *monthTitle, NSString *monthSubTitle) {
                @strongify(self);
                self.monthTitleLabel.text = monthTitle;
                self.monthLabel.text = monthSubTitle;
                [self changeQueryDate];
            }];
            break;
        }
        case ReportViewMonth:{
            @weakify(self);
            [[CalendarDateCaculate sharedInstance]getChangeMonth:self.monthTitleLabel.text withCalendarStep:CalendarStepTypeNext callBack:^(NSString *monthTitle, NSInteger daysInMonth) {
                @strongify(self);
                self.monthTitleLabel.text = monthTitle;
                [self changeQueryDate];
            }];
            break;
        }
        case ReportViewQuater:{
            @weakify(self);
            [[CalendarDateCaculate sharedInstance]getChangeQuater:self.monthTitleLabel.text withQuaterStep:CalendarStepTypeNext callBack:^(NSString *monthTitle, NSString *monthSubTitle) {
                @strongify(self);
                self.monthTitleLabel.text = monthTitle;
                self.monthLabel.text = monthSubTitle;
                [self changeQueryDate];
            }];
            break;
        }
            
        default:
            break;
    }
}

- (void)showCalender:(UIButton *)sender
{
    switch (self.reportType) {
        case ReportViewWeek:
        {
            [self showWeekCalender:nil];
            break;
        }
        case ReportViewMonth:{
            [self showMonthCalender:nil];
            break;
        }
        case ReportViewQuater:{
            [self showQuaterCalender:nil];
            break;
        }
            
        default:
            break;
    }

}

#pragma mark week

- (void)showWeekCalender:(UITapGestureRecognizer *)gesture
{
    NSString *dateString = self.monthTitleLabel.text;
    WeekCalenderView *monthView = [[WeekCalenderView alloc]init];
    monthView.frame = [UIScreen mainScreen].bounds;
    NSRange range = [dateString rangeOfString:@"年第"];
    NSString *sub1 = [dateString substringToIndex:range.location];
    NSString *sub2 = [dateString substringFromIndex:range.location + range.length];
    NSRange range1 = [sub2 rangeOfString:@"周"];
    NSString *sub3 = [sub2 substringToIndex:range1.location];
    monthView.weekTitle = sub1;
    monthView.currentWeekNum = [sub3 intValue];
    monthView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:monthView];
    
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    theAnimation.delegate = self;
    theAnimation.duration = 0.5;
    theAnimation.repeatCount = 0;
    theAnimation.removedOnCompletion = FALSE;
    theAnimation.fillMode = kCAFillModeForwards;
    theAnimation.autoreverses = NO;
    theAnimation.fromValue = [NSNumber numberWithFloat:-[UIScreen mainScreen].bounds.size.height];
    theAnimation.toValue = [NSNumber numberWithFloat:0];
    [monthView.layer addAnimation:theAnimation forKey:@"animateLayer"];
}

- (void)selectedWeek:(NSString *)monthString
{
    @weakify(self);
    [[CalendarDateCaculate sharedInstance]getSelectWeekMonth:self.monthTitleLabel.text selectedMonth:monthString subMonth:self.monthLabel.text callBack:^(NSString *monthTitle, NSString *monthSubTitle) {
        @strongify(self);
        self.monthTitleLabel.text = monthTitle;
        self.monthLabel.text = monthSubTitle;
        [self changeQueryDate];
    }];
}

#pragma mark month
- (void)showMonthCalender:(UITapGestureRecognizer *)gesture
{
    NSString *dateString = self.monthTitleLabel.text;
    MonthCalenderView *monthView = [[MonthCalenderView alloc]init];
    monthView.frame = [UIScreen mainScreen].bounds;
    NSRange range = [dateString rangeOfString:@"年"];
    NSString *sub2 = [dateString substringWithRange:NSMakeRange(range.location+range.length, 2)];
    NSString *sub1 = [dateString substringToIndex:range.location];
    monthView.monthTitle = sub1;
    monthView.currentMonthNum = [sub2 intValue];
    monthView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:monthView];
    
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    theAnimation.delegate = self;
    theAnimation.duration = 0.5;
    theAnimation.repeatCount = 0;
    theAnimation.removedOnCompletion = FALSE;
    theAnimation.fillMode = kCAFillModeForwards;
    theAnimation.autoreverses = NO;
    theAnimation.fromValue = [NSNumber numberWithFloat:-[UIScreen mainScreen].bounds.size.height];
    theAnimation.toValue = [NSNumber numberWithFloat:0];
    [monthView.layer addAnimation:theAnimation forKey:@"animateLayer"];
}

#pragma mark 日历delegate

- (void)selectedMonth:(NSString *)monthString
{
    self.monthTitleLabel.text = monthString;
    [self changeQueryDate];
}

#pragma mark 季度

- (void)showQuaterCalender:(UITapGestureRecognizer *)gesture
{
    NSString *dateString = self.monthTitleLabel.text;
    QuaterCalenderView *monthView = [[QuaterCalenderView alloc]init];
    monthView.frame = [UIScreen mainScreen].bounds;
    NSRange range = [dateString rangeOfString:@"年第"];
    NSString *sub1 = [dateString substringToIndex:range.location];
    NSString *sub2 = [dateString substringWithRange:NSMakeRange(range.location +range.length, 1)];
    monthView.quaterTitle = sub1;
    monthView.currentQuaterNum = [sub2 intValue];
    monthView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:monthView];
    
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    theAnimation.delegate = self;
    theAnimation.duration = 0.5;
    theAnimation.repeatCount = 0;
    theAnimation.removedOnCompletion = FALSE;
    theAnimation.fillMode = kCAFillModeForwards;
    theAnimation.autoreverses = NO;
    theAnimation.fromValue = [NSNumber numberWithFloat:-[UIScreen mainScreen].bounds.size.height];
    theAnimation.toValue = [NSNumber numberWithFloat:0];
    [monthView.layer addAnimation:theAnimation forKey:@"animateLayer"];
}

#pragma mark 日历delegate

- (void)selectedQuater:(NSString *)monthString
{
    self.monthTitleLabel.text = monthString;
    NSRange range = [monthString rangeOfString:@"年第"];
    NSString *quater = [monthString substringWithRange:NSMakeRange(range.location + range.length, 1)];
    NSString *selectedMonth = [[CalendarDateCaculate sharedInstance] changeQuaterToMonth:[quater intValue]];
    self.monthLabel.text = selectedMonth;
    [self changeQueryDate];
}

- (void)changeQueryDate
{
    DeBugLog(@"访问");
    switch (self.reportType) {
        case ReportViewWeek:
        {
            NSString *year = [self.monthTitleLabel.text substringWithRange:NSMakeRange(0, 4)];
            NSString *fromMonth = [self.monthLabel.text substringWithRange:NSMakeRange(0, 2)];
            NSString *fromDay = [self.monthLabel.text substringWithRange:NSMakeRange(3, 2)];
            NSString *toMonth = [self.monthLabel.text substringWithRange:NSMakeRange(7, 2)];
            NSString *toDay = [self.monthLabel.text substringWithRange:NSMakeRange(10, 2)];
            NSString *fromDate = [NSString stringWithFormat:@"%@%@%@",year,fromMonth,fromDay];
            NSString *toDate = [NSString stringWithFormat:@"%@%@%@",year,toMonth,toDay];
            self.selectDateBlock(fromDate,toDate);
            break;
        }
        case ReportViewMonth:{
            NSString *year = [self.monthTitleLabel.text substringWithRange:NSMakeRange(0, 4)];
            NSString *fromMonth = [self.monthTitleLabel.text substringWithRange:NSMakeRange(5, 2)];
            NSString *fromDate = [NSString stringWithFormat:@"%@%@%@",year,fromMonth,@"01"];
            NSString *toDate = @"";
            toDate = [NSString stringWithFormat:@"%@%@%ld",year,fromMonth,[[CalendarDateCaculate sharedInstance] getCurrentMonthDayNum:year month:fromMonth]];
            self.selectDateBlock(fromDate,toDate);
            break;
        }
        case ReportViewQuater:{
            NSString *year = [self.monthTitleLabel.text substringWithRange:NSMakeRange(0, 4)];
            NSString *fromMonth = [self.monthLabel.text substringWithRange:NSMakeRange(0, 2)];
            NSString *fromDateString = [NSString stringWithFormat:@"%@%@%@",year,fromMonth,@"01"];
            NSString *toMonth = [self.monthLabel.text substringWithRange:NSMakeRange(4, 2)];
            NSString *toDateString = [NSString stringWithFormat:@"%@%@%ld",year,toMonth,(long)[[CalendarDateCaculate sharedInstance] getCurrentMonthDayNum:year month:toMonth]];
            self.selectDateBlock(fromDateString,toDateString);
            break;
        }
            
        default:
            break;
    }
}

@end
