//
//  ZZHPieView.m
//  ChartView
//
//  Created by Havi on 16/8/8.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "ZZHPieView.h"
#import "VBPieChart.h"
#import "UIColor+HexColor.h"

@interface ZZHPieView ()

@property (nonatomic, retain) VBPieChart *chart;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *sleepNum;
@property (nonatomic, strong) UILabel *sleepSub;

@end

@implementation ZZHPieView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self chartInit];
    }
    return self;
}

- (void) chartInit {
    
    if (!_chart) {
        _chart = [[VBPieChart alloc] init];
        [self addSubview:_chart];
    }
    [_chart setFrame:CGRectMake((self.frame.size.width-self.frame.size.height*0.65)/2, 30, self.frame.size.height*0.65, self.frame.size.height*0.65)];
    _chart.labelsPosition = VBLabelsPositionOutChart;
    
    _chart.startAngle = M_PI+M_PI_2;
    _chart.radiusPrecent = 0.8;
    
    [_chart setHoleRadiusPrecent:0.7];
    _imageView = [[UIImageView alloc]init];
    _imageView.image = [UIImage imageNamed:@"leave@3x"];
    [_chart addSubview:_imageView];
    [_imageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_chart.mas_centerX);
        make.centerY.equalTo(_chart.mas_centerY).offset(-25);
        make.height.width.equalTo(@30);
    }];
    
    _sleepNum = [[UILabel alloc]init];
    [_chart addSubview:_sleepNum];
    _sleepNum.text = @"--";
    _sleepNum.font = [UIFont systemFontOfSize:30];
    _sleepNum.textColor = [UIColor whiteColor];
    
    [_sleepNum makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_chart.mas_centerY).offset(15);
        make.centerX.equalTo(_chart.mas_centerX).offset(-10);
    }];
    
    _sleepSub = [[UILabel alloc]init];
    [_chart addSubview:_sleepSub];
    _sleepSub.text = @"次";
    _sleepSub.font = [UIFont systemFontOfSize:17];
    _sleepSub.textColor = [UIColor whiteColor];
    [_sleepSub makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_sleepNum.mas_right).offset(0);
        make.baseline.equalTo(_sleepNum.mas_baseline);
    }];
    
    UIView *leftView = [[UIView alloc]init];
    leftView.backgroundColor = [UIColor colorWithRed:0.635 green:0.851 blue:0.867 alpha:1.00];
    [self addSubview:leftView];
    
    UILabel *leftLabel = [[UILabel alloc]init];
    leftLabel.text = @"入睡";
    leftLabel.textColor = [UIColor whiteColor];
    leftLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:leftLabel];
    
    UIView *rightView = [[UIView alloc]init];
    rightView.backgroundColor = [UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1.00];
    [self addSubview:rightView];
    
    UILabel *rightLabel = [[UILabel alloc]init];
    rightLabel.text = @"离床";
    rightLabel.textColor = [UIColor whiteColor];
    rightLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:rightLabel];
    
    [rightLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-8);
        make.right.equalTo(self.mas_right).offset(-16);
    }];
    
    [rightView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(rightLabel.mas_centerY);
        make.right.equalTo(rightLabel.mas_left).offset(-8);
        make.height.width.equalTo(@15);
    }];
    
    [leftLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(rightLabel.mas_centerY);
        make.right.equalTo(rightView.mas_left).offset(-16);
    }];
    
    [leftView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(leftLabel.mas_centerY);
        make.right.equalTo(leftLabel.mas_left).offset(-8);
        make.height.width.equalTo(@15);
    }];
//
}

- (void)setChartValues:(NSArray *)chartValues
{
    
}

- (void)reloadTableViewHeaderWith:(id)data withType:(SensorDataType)type
{
    SleepQualityModel *model = data;
    if ([model.outOfBedTimes intValue]==0) {
        _sleepNum.text = @"--";
    }else{
        _sleepNum.text = [NSString stringWithFormat:@"%d",[model.outOfBedTimes intValue]];
    }
}

- (void)reloadTableViewWith:(id)data withType:(SensorDataType)type
{
    [_chart setChartValues:data animation:YES];
}

@end
