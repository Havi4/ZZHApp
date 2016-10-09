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
#import "ZESegmentedsView.h"

@interface CalendarShowView ()<SelectedWeek,SelectedMonth,SelectedQuater,ZESegmentedsViewDelegate>

@property (nonatomic, strong) UIView *calenderBackView;
@property (nonatomic,strong) UIButton *leftCalButton;
@property (nonatomic,strong) UIButton *rightCalButton;
@property (nonatomic,strong) UILabel *monthTitleLabel;
@property (nonatomic,strong) UIImageView *calenderImage;
@property (nonatomic,strong) UILabel *monthLabel;
@property (nonatomic,assign) ReportViewType reportType;
@property (nonatomic,strong) ZESegmentedsView *segmentView;


@property (nonatomic,strong) UIImageView *headerImageView;
@property (nonatomic,strong) UILabel *headerLongLabel;
@property (nonatomic,strong) UILabel *headerShortLabel;
@property (nonatomic,strong) UILabel *headerLongData;
@property (nonatomic,strong) UILabel *headerShortData;

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

- (ZESegmentedsView*)segmentView
{
    if (!_segmentView) {
        _segmentView = [[ZESegmentedsView alloc]initWithFrame:(CGRect){200,10,120,30} segmentedCount:3 segmentedTitles:@[@"周",@"月",@"季"]];
        _segmentView.delegate = self;
        [_segmentView setSelectIndex:self.reportType];
    }
    return _segmentView;
}

- (UIImageView *)headerImageView
{
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc]init];
        _headerImageView.image = [[UIImage imageNamed:@"chang1@3x"]imageByTintColor:[UIColor whiteColor]];
    }
    return _headerImageView;
}

- (UILabel *)headerLongLabel
{
    if (!_headerLongLabel) {
        _headerLongLabel = [[UILabel alloc]init];
        _headerLongLabel.text = @"最长夜晚";
        _headerLongLabel.textColor = [UIColor whiteColor];
        _headerLongLabel.font = [UIFont systemFontOfSize:13];
    }
    return _headerLongLabel;
}

- (UILabel *)headerShortLabel
{
    if (!_headerShortLabel) {
        _headerShortLabel = [[UILabel alloc]init];
        _headerShortLabel.text = @"最短夜晚";
        _headerShortLabel.textColor = [UIColor whiteColor];
        _headerShortLabel.font = [UIFont systemFontOfSize:13];
    }
    return _headerShortLabel;
}

- (UILabel *)headerLongData
{
    if (!_headerLongData) {
        _headerLongData = [[UILabel alloc]init];
        _headerLongData.text = @"--小时--分钟";
        _headerLongData.textColor = [UIColor whiteColor];
        _headerLongData.textAlignment = NSTextAlignmentCenter;
        _headerLongData.font = [UIFont systemFontOfSize:13];
    }
    return _headerLongData;
}

- (UILabel *)headerShortData
{
    if (!_headerShortData) {
        _headerShortData = [[UILabel alloc]init];
        _headerShortData.text = @"--小时--分钟";
        _headerShortData.textColor = [UIColor whiteColor];
        _headerShortData.textAlignment = NSTextAlignmentCenter;
        _headerShortData.font = [UIFont systemFontOfSize:13];
    }
    return _headerShortData;
}


- (UIView *)calenderBackView
{
    if (!_calenderBackView) {
        _calenderBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _calenderBackView.backgroundColor = [UIColor clearColor];
        
        [_calenderBackView addSubview:self.headerImageView];
        [_headerImageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_calenderBackView.mas_top).offset(20);
            make.width.height.equalTo(@15);
            make.left.equalTo(_calenderBackView.mas_left).offset(8);
        }];
        
        [_calenderBackView addSubview:self.headerLongLabel];
        [_headerLongLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headerImageView.mas_centerY).offset(-10);
            make.height.equalTo(@25);
            make.left.equalTo(_headerImageView.mas_right).offset(8);
            
        }];
        
        [_calenderBackView addSubview:self.headerShortLabel];
        [_headerShortLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headerImageView.mas_centerY).offset(10);
            make.height.equalTo(@25);
            make.left.equalTo(_headerImageView.mas_right).offset(8);

        }];
        
        [_calenderBackView addSubview:self.headerLongData];
        [_headerLongData makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headerLongLabel.mas_centerY);
            make.left.equalTo(_headerLongLabel.mas_right).offset(8);
        }];
        
        [_calenderBackView addSubview:self.headerShortData];
        [_headerShortData makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headerShortLabel.mas_centerY);
            make.left.equalTo(_headerShortLabel.mas_right).offset(8);
        }];
    
        //
        [_calenderBackView addSubview:self.monthTitleLabel];
        [self.monthTitleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_calenderBackView.mas_centerX).offset(0);
            make.height.equalTo(@34.5);
            make.bottom.equalTo(_calenderBackView.mas_bottom).offset(-5);
            
        }];
        
        
        //
////        [_calenderBackView addSubview:self.calenderImage];
//        [self.calenderImage makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.monthTitleLabel.mas_right).offset(10);
//            make.width.height.equalTo(@20);
//            make.centerY.equalTo(self.monthTitleLabel.mas_centerY);
//        }];
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
            make.left.equalTo(self.monthTitleLabel.mas_right).offset(15);
            make.centerY.equalTo(self.monthTitleLabel.mas_centerY);
            make.height.equalTo(@20);
            make.width.equalTo(@15);
        }];
        //
//        [_calenderBackView addSubview:self.monthLabel];
//        [self.monthLabel makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(_calenderBackView);
//            make.top.equalTo(self.monthTitleLabel.mas_bottom);
//            make.height.equalTo(@34.5);
//        }];
        [_calenderBackView addSubview:self.segmentView];
        [_segmentView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headerImageView.mas_centerY);
            make.right.equalTo(_calenderBackView.mas_right).offset(-8);
            make.width.equalTo(@120);
            make.height.equalTo(@30);
        }];
    }
    return _calenderBackView;
}

- (UILabel *)monthTitleLabel
{
    if (!_monthTitleLabel) {
        _monthTitleLabel = [[UILabel alloc]init];
        _monthTitleLabel.font = [UIFont systemFontOfSize:13];
        _monthTitleLabel.textColor = [UIColor whiteColor];
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
        [_leftCalButton setImage:[[UIImage imageNamed:[NSString stringWithFormat:@"btn_back_%d",0]] imageByTintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_leftCalButton addTarget:self action:@selector(lastStep:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftCalButton;
}

- (UIButton *)rightCalButton
{
    if (!_rightCalButton) {
        _rightCalButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightCalButton setImage:[[UIImage imageNamed:[NSString stringWithFormat:@"btn_right_%d",selectedThemeIndex]] imageByTintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_rightCalButton addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightCalButton;
}

- (UILabel *)monthLabel
{
    if (!_monthLabel) {
        _monthLabel = [[UILabel alloc]init];
        _monthLabel.font = [UIFont systemFontOfSize:16];
        _monthLabel.textColor = selectedThemeIndex==0?[UIColor whiteColor]:[UIColor whiteColor];
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
            NSUInteger a = [[self.monthTitleLabel.text substringWithRange:NSMakeRange(6, 2)] integerValue];
            NSUInteger titleYear = [[self.monthTitleLabel.text substringWithRange:NSMakeRange(0, 4)] integerValue];

            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSInteger unitFlags = NSWeekCalendarUnit|NSWeekdayCalendarUnit|NSYearCalendarUnit;
            NSDateComponents *comps = [calendar components:unitFlags fromDate:[NSDate date]];
            if (titleYear > [comps year] ) {
                [NSObject showHudTipStr:@"请选择历史日期"];
                return;
            }
            if ((a > [comps week] || a == [comps week]) && (titleYear == [comps year] )) {
                [NSObject showHudTipStr:@"请选择历史日期"];
                return;
            }
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
            NSUInteger titleMonth = [[self.monthTitleLabel.text substringWithRange:NSMakeRange(5, 2)] integerValue];
            NSUInteger titleYear = [[self.monthTitleLabel.text substringWithRange:NSMakeRange(0, 4)] integerValue];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
            
            NSDateComponents *components = [calendar components:unitFlags fromDate:[NSDate date]];
            NSInteger iCurYear = [components year];  //当前的年份
            NSInteger iCurMonth = [components month];  //当前的月份
            if (titleYear > iCurYear ) {
                [NSObject showHudTipStr:@"请选择历史日期"];
                return;
            }
            if ((titleMonth > iCurMonth || titleMonth == iCurMonth) && (titleYear == iCurYear)) {
                [NSObject showHudTipStr:@"请选择历史日期"];
                return;
            }
            

            @weakify(self);
            [[CalendarDateCaculate sharedInstance]getChangeMonth:self.monthTitleLabel.text withCalendarStep:CalendarStepTypeNext callBack:^(NSString *monthTitle, NSInteger daysInMonth) {
                @strongify(self);
                self.monthTitleLabel.text = monthTitle;
                [self changeQueryDate];
            }];
            break;
        }
        case ReportViewQuater:{
            NSUInteger a = [[self.monthTitleLabel.text substringWithRange:NSMakeRange(6, 1)] integerValue];
            NSUInteger titleYear = [[self.monthTitleLabel.text substringWithRange:NSMakeRange(0, 4)] integerValue];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            unsigned unitFlags = NSYearCalendarUnit | NSQuarterCalendarUnit;
            
            NSDateComponents *components = [calendar components:unitFlags fromDate:[NSDate date]];
            NSInteger iCurYear = [components year];  //当前的年份
            NSInteger iCurQuar = [components quarter];
            if (titleYear > iCurYear ) {
                [NSObject showHudTipStr:@"请选择历史日期"];
                return;
            }
            
            if (titleYear == iCurYear && a == 4) {
                [NSObject showHudTipStr:@"请选择历史日期"];
                return;
            }

            if ((a > iCurQuar || a == iCurQuar) && (titleYear == iCurYear) && iCurQuar != 0) {
                [NSObject showHudTipStr:@"请选择历史日期"];

                return;
            }
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
            NSString *currentWeekL = [self.monthTitleLabel.text substringFromIndex:6];
            NSString *c = [currentWeekL substringToIndex:currentWeekL.length-1];
            [self showWeekCalender:c];
            break;
        }
        case ReportViewMonth:{
            NSString *currentWeekL = [self.monthTitleLabel.text substringFromIndex:5];
            NSString *c = [currentWeekL substringToIndex:currentWeekL.length-1];
            [self showMonthCalender:c];
            break;
        }
        case ReportViewQuater:{
            NSString *currentWeekL = [self.monthTitleLabel.text substringFromIndex:6];
            NSString *c = [currentWeekL substringToIndex:currentWeekL.length-2];
            [self showQuaterCalender:c];
            break;
        }
            
        default:
            break;
    }

}

#pragma mark week

- (void)showWeekCalender:(NSString *)currentWeek
{
    NSString *dateString = self.monthTitleLabel.text;
    WeekCalenderView *monthView = [[WeekCalenderView alloc]init];
    monthView.currentWeek = currentWeek;
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
        self.monthTitleLabel.text = monthString;
        self.monthLabel.text = monthSubTitle;
        [self changeQueryDate];
    }];
}

#pragma mark month
- (void)showMonthCalender:(NSString *)currentWeek
{
    NSString *dateString = self.monthTitleLabel.text;
    MonthCalenderView *monthView = [[MonthCalenderView alloc]init];
    monthView.currentMonth = currentWeek;
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

- (void)showQuaterCalender:(NSString *)currentWeek
{
    NSString *dateString = self.monthTitleLabel.text;
    QuaterCalenderView *monthView = [[QuaterCalenderView alloc]init];
    monthView.frame = [UIScreen mainScreen].bounds;
    monthView.currentQuater = currentWeek;
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

- (void)reloadSleepDuration:(id)sleepData
{
    SleepQualityModel *model = sleepData;
    __block QualityDetailModel *detailModel;
    @weakify(self);
    [SleepModelChange getSleepLongOrShortDurationWith:model type:1 callBack:^(id longSleep) {
        detailModel = longSleep;
        @strongify(self);
        NSString *sleepDuration = detailModel.sleepDuration;
        int hour = [sleepDuration intValue];
        if (hour == 0) {
            self.headerLongData.text = @"--小时--分钟";
            return ;
        }
        double second2 = 0.0;
        double subsecond2 = modf([sleepDuration floatValue], &second2);
        NSString *sleepTimeDuration= @"";
        if((int)round(subsecond2*60)<10){
            sleepTimeDuration = [NSString stringWithFormat:@"%@小时0%d分钟",hour<10?[NSString stringWithFormat:@"0%d",hour]:[NSString stringWithFormat:@"%d",hour],(int)round(subsecond2*60)];
        }else{
            sleepTimeDuration = [NSString stringWithFormat:@"%@小时%d分钟",hour<10?[NSString stringWithFormat:@"0%d",hour]:[NSString stringWithFormat:@"%d",hour],(int)round(subsecond2*60)];
        }
        self.headerLongData.text = sleepTimeDuration;
    }];
    __block QualityDetailModel *detailModel1;
    [SleepModelChange getSleepLongOrShortDurationWith:model type:-1 callBack:^(id longSleep) {
        detailModel1 = longSleep;
        @strongify(self);
        NSString *sleepDuration = detailModel1.sleepDuration;
        int hour = [sleepDuration intValue];
        if (hour == 0) {
            self.headerShortData.text = @"--小时--分钟";
            return ;
        }
        double second2 = 0.0;
        double subsecond2 = modf([sleepDuration floatValue], &second2);
        NSString *sleepTimeDuration= @"";
        if((int)round(subsecond2*60)<10){
            sleepTimeDuration = [NSString stringWithFormat:@"%@小时0%d分钟",hour<10?[NSString stringWithFormat:@"0%d",hour]:[NSString stringWithFormat:@"%d",hour],(int)round(subsecond2*60)];
        }else{
            sleepTimeDuration = [NSString stringWithFormat:@"%@小时%d分钟",hour<10?[NSString stringWithFormat:@"0%d",hour]:[NSString stringWithFormat:@"%d",hour],(int)round(subsecond2*60)];
        }
        self.headerShortData.text = sleepTimeDuration;
    }];
}

- (void)selectedZESegmentedsViewItemAtIndex:(NSInteger )selectedItemIndex{
    
    if (selectedItemIndex != self.reportType) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kReportTagSelected object:nil userInfo:@{@"tag":[NSNumber numberWithInteger:selectedItemIndex]}];
    }
    
}

@end
