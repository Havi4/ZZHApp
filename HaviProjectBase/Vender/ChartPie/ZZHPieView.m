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
    
     NSArray *chartValues = @[
                         // Data can be passed after JSON Deserialization
                         @{@"name":@"first", @"value":@50, @"color":@"#dd191daa", @"strokeColor":@"#fff"},
                         
                         // Chart can use patterns
                         @{@"name":@"sec", @"value":@20, @"color":[UIColor redColor], @"strokeColor":@"#fff"},
                         @{@"name":@"third", @"value":@40, @"color":[UIColor blueColor], @"strokeColor":[UIColor whiteColor]},
                         
                         // chart can be with or without titles
                         @{@"name":@"fourth", @"value":@70, @"color":[UIColor colorWithHex:0x3f51b5aa], @"strokeColor":[UIColor whiteColor]},
                         @{@"value":@65, @"color":[UIColor colorWithHex:0x5677fcaa], @"strokeColor":[UIColor whiteColor]},
                         @{@"value":@23, @"color":[UIColor colorWithHex:0x2baf2baa], @"strokeColor":[UIColor whiteColor]},
                         @{@"value":@34, @"color":[UIColor colorWithHex:0xb0bec5aa], @"strokeColor":[UIColor whiteColor]},
                         @{@"name":@"stroke", @"value":@54, @"color":[UIColor colorWithHex:0xf57c00aa], @"strokeColor":[UIColor whiteColor]}
                         ];
    [_chart setChartValues:data animation:YES];


}

@end
