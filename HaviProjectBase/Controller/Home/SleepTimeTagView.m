//
//  SleepTimeTagView.m
//  SleepRecoding
//
//  Created by Havi on 15/8/9.
//  Copyright (c) 2015年 Havi. All rights reserved.
//

#import "SleepTimeTagView.h"
#import "PNLineView.h"
@interface SleepTimeTagView ()
{
    UIImageView *sleepTimeImageView;
    UILabel *sleepNightCategoryLabel;
    UILabel *sleepYearMonthDayLabel;
    UILabel *sleepTimeLongLabel;
    PNLineView *sleepLineView;
}
@end

@implementation SleepTimeTagView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubView];
        [self setContraints];
    }
    return self;
}

- (void)initSubView
{
    sleepNightCategoryLabel = [[UILabel alloc]init];
    sleepNightCategoryLabel.font = [UIFont systemFontOfSize:11];
    sleepNightCategoryLabel.text = @"最长的夜晚";
    sleepNightCategoryLabel.dk_textColorPicker = DKColorWithColors([UIColor colorWithRed:0.000f green:0.851f blue:0.573f alpha:1.00f], [UIColor whiteColor]);
    [self addSubview:sleepNightCategoryLabel];
    
    sleepYearMonthDayLabel = [[UILabel alloc]init];
    sleepYearMonthDayLabel.font = [UIFont systemFontOfSize:11];
    sleepYearMonthDayLabel.text = @"2013-12-12";
    sleepYearMonthDayLabel.dk_textColorPicker = DKColorWithColors([UIColor colorWithRed:0.000f green:0.851f blue:0.573f alpha:1.00f], [UIColor whiteColor]);
    [self addSubview:sleepYearMonthDayLabel];
    
    sleepTimeLongLabel = [[UILabel alloc]init];
    sleepTimeLongLabel.font = [UIFont systemFontOfSize:11];
    sleepTimeLongLabel.text = @"12小时23分";
    sleepTimeLongLabel.textAlignment = NSTextAlignmentRight;
    sleepTimeLongLabel.dk_textColorPicker = DKColorWithColors([UIColor colorWithRed:0.000f green:0.851f blue:0.573f alpha:1.00f], [UIColor whiteColor]);
    [self addSubview:sleepTimeLongLabel];
    
    sleepTimeImageView = [[UIImageView alloc]init];
    sleepTimeImageView.backgroundColor = [UIColor colorWithRed:0.157f green:0.255f blue:0.357f alpha:0.80f];
    sleepTimeImageView.layer.cornerRadius = 2;
    sleepTimeImageView.layer.masksToBounds = YES;
    [self addSubview:sleepTimeImageView];
    
    sleepLineView  = [[PNLineView alloc]initWithFrame:CGRectMake(0, 0, 0, 5)];
    [sleepTimeImageView addSubview:sleepLineView];
}

- (void)setContraints
{
    [sleepNightCategoryLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(5);
        make.left.equalTo(self).offset(10);
        make.height.equalTo(@25);
    }];
    
    [sleepYearMonthDayLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sleepNightCategoryLabel.mas_centerY);
        make.height.equalTo(@25);
        make.right.equalTo(sleepTimeLongLabel.mas_left).offset(5);
    }];
    
    [sleepTimeLongLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(sleepNightCategoryLabel.mas_centerY);
        make.height.equalTo(@25);
        make.width.equalTo(@80);
    }];
    
    [sleepTimeImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(sleepNightCategoryLabel.mas_bottom).offset(10);
        make.right.equalTo(self).offset(-10);
        make.height.equalTo(@5);
    }];
}

//setter

- (void)setSleepNightCategoryString:(NSString *)sleepNightCategoryString
{
    sleepNightCategoryLabel.text = sleepNightCategoryString;
}

- (void)setSleepYearMonthDayString:(NSString *)sleepYearMonthDayString
{
    sleepYearMonthDayLabel.text = sleepYearMonthDayString;
}

- (void)setSleepTimeLongString:(NSString *)sleepTimeLongString
{
    sleepTimeLongLabel.text = sleepTimeLongString;
}

- (void)setGrade:(CGFloat)grade
{
    CGFloat width = (self.frame.size.width - 20)*grade;
    [UIView animateWithDuration:0.5 animations:^{
        sleepLineView.frame = CGRectMake(0, 2.5, width, 5);
    }];
}

- (void)setLineColorArr:(NSArray *)lineColorArr
{
    sleepLineView.colorsArr = lineColorArr;
}

@end
