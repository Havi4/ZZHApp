//
//  ChartTableTitleView.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/26.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "ChartTableTitleView.h"

@interface ChartTableTitleView ()

@property (nonatomic, strong) UIImageView *leaveImage;
@property (nonatomic, strong) UILabel *sleepTimeLabel;
@property (nonatomic, strong) UIView *circleSleepView;
@property (nonatomic, strong) UILabel *timesLabel;
@property (nonatomic, strong) UILabel *circleTitle;
@property (nonatomic, strong) UILabel *circleSubTitle;


@end

@implementation ChartTableTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViewWithFrame:frame];
    }
    return self;
}

- (void)createSubViewWithFrame:(CGRect)frame
{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 188)];
    backView.backgroundColor = [UIColor clearColor];
    [backView addSubview:self.leaveImage];
    [backView addSubview:self.sleepTimeLabel];
    [backView addSubview:self.circleSleepView];
    [self.circleSleepView addSubview:self.timesLabel];
    [self.circleSleepView addSubview:self.circleTitle];
    [self.circleSleepView addSubview:self.circleSubTitle];
    [self.leaveImage makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView);
        make.height.equalTo(@34);
        make.width.equalTo(@51);
        make.left.equalTo(backView.mas_left).offset((self.frame.size.width-51-150)/2);
        
    }];
    [self.sleepTimeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leaveImage.mas_centerY);
        make.height.equalTo(@30);
        make.width.equalTo(@150);
        make.left.equalTo(self.leaveImage.mas_right).offset(20);
    }];
    
    [self.circleSleepView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView.mas_centerX);
        make.top.equalTo(self.leaveImage.mas_bottom).offset(10);
        make.width.equalTo(@142);
        make.width.equalTo(self.circleSleepView.mas_height);
    }];
    
    [self.timesLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.circleSleepView.mas_centerX);
        make.centerY.equalTo(self.circleSleepView.mas_centerY);
        make.height.equalTo(@30);
        make.width.equalTo(@50);
    }];
    
    [self.circleTitle makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.timesLabel.mas_centerX);
        make.bottom.equalTo(self.timesLabel.mas_top).offset(-5);
        make.height.equalTo(@30);
        make.width.equalTo(@100);
    }];
    
    [self.circleSubTitle makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.timesLabel.mas_centerX);
        make.top.equalTo(self.timesLabel.mas_bottom).offset(5);
        make.height.equalTo(@20);
        make.width.equalTo(@20);
    }];
    
    [self addSubview:backView];
}

- (UIImageView *)leaveImage
{
    if (_leaveImage==nil) {
        _leaveImage = [[UIImageView alloc]init];
        //                       WithFrame:CGRectMake(100, 0, 51, 34)];
        _leaveImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"ic_body_movement_%d",selectedThemeIndex]];
    }
    return _leaveImage;
}

- (UILabel *)sleepTimeLabel
{
    if (_sleepTimeLabel==nil) {
        _sleepTimeLabel = [[UILabel alloc]init];
        //                           WithFrame:CGRectMake(151, 2, 100, 30)];
        _sleepTimeLabel.text = @"睡眠时长:0小时";
        _sleepTimeLabel.font = [UIFont systemFontOfSize:17];
        _sleepTimeLabel.textColor = [UIColor colorWithRed:0.000f green:0.859f blue:0.573f alpha:1.00f];
        
    }
    return _sleepTimeLabel;
}

- (UIView *)circleSleepView
{
    if (_circleSleepView == nil) {
        _circleSleepView = [[UIView alloc]init];
        _circleSleepView.layer.cornerRadius = 68.5;
        _circleSleepView.layer.masksToBounds = YES;
        _circleSleepView.dk_backgroundColorPicker = DKColorWithColors([UIColor colorWithRGBHex:0x0e254c], [UIColor colorWithRGBHex:0x5e8abe]);
    }
    return _circleSleepView;
}

- (UILabel *)timesLabel
{
    if (_timesLabel == nil) {
        _timesLabel = [[UILabel alloc]init];
        _timesLabel.text = @"0";
        _timesLabel.font = [UIFont systemFontOfSize:25];
        _timesLabel.textAlignment = NSTextAlignmentCenter;
        _timesLabel.textColor = [UIColor colorWithRed:0.000f green:0.859f blue:0.573f alpha:1.00f];
    }
    return _timesLabel;
}

- (UILabel *)circleTitle{
    if (_circleTitle==nil) {
        _circleTitle = [[UILabel alloc]init];
        _circleTitle.text = @"您昨晚体动";
        _circleTitle.font = [UIFont systemFontOfSize:15];
        _circleTitle.textAlignment = NSTextAlignmentCenter;
        _circleTitle.dk_textColorPicker = kTextColorPicker;
        
    }
    return _circleTitle;
}

- (UILabel *)circleSubTitle
{
    if (_circleSubTitle==nil) {
        _circleSubTitle = [[UILabel alloc]init];
        _circleSubTitle.font = [UIFont systemFontOfSize:15];
        _circleSubTitle.textAlignment = NSTextAlignmentCenter;
        _circleSubTitle.text = @"次";
        _circleSubTitle.dk_textColorPicker = kTextColorPicker;
        
    }
    return _circleSubTitle;
}



@end
