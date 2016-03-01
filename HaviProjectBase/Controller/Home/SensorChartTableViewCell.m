//
//  SensorChartTableViewCell.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/25.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "SensorChartTableViewCell.h"
#import "ChartGrapheView.h"
#import "FloatLayerView.h"

@interface SensorChartTableViewCell ()<UIScrollViewDelegate>

@property (nonatomic,strong) ChartGrapheView *chartGraphView;
@property (nonatomic,strong) UIScrollView *scrollContainerView;
@property (nonatomic,strong) UIView *yCoorBackView;
@property (nonatomic,strong) FloatLayerView *layerFloatView;
@property (nonatomic,strong) NSArray *changedArr;
@property (nonatomic,assign) int type;

@end

@implementation SensorChartTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.scrollContainerView];
    }
    return self;
}


- (ChartGrapheView *)chartGraphView
{
    if (!_chartGraphView) {
        _chartGraphView = [[ChartGrapheView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width*4, 180)];
        _chartGraphView.xValues = @[@"18:00",@"19:00",@"20:00",@"21:00",@"22:00",@"23:00",@"24:00",@"01:00",@"02:00",@"03:00",@"04:00",@"05:00",@"06:00",@"07:00",@"08:00",@"09:00",@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00",@"18:00"];
        _chartGraphView.heartViewLeft.maxValue = 100;
        _chartGraphView.heartViewLeft.minValue = 50;
        _chartGraphView.heartViewLeft.horizonValue = 140;
        _chartGraphView.heartViewLeft.graphColor = selectedThemeIndex==0?[UIColor colorWithRed:0.008f green:0.839f blue:0.573f alpha:.70f]:[UIColor colorWithRed:0.008f green:0.839f blue:0.573f alpha:.70f];
        [_chartGraphView addSubview:self.layerFloatView];
        
    }
    return _chartGraphView;
}

- (UIScrollView *)scrollContainerView
{
    if (!_scrollContainerView) {
        _scrollContainerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 180)];
        [_scrollContainerView addSubview:self.chartGraphView];
        _scrollContainerView.contentSize = CGSizeMake(self.frame.size.width*4, 180);
        _scrollContainerView.showsHorizontalScrollIndicator = NO;
        _scrollContainerView.delegate = self;
    }
    return _scrollContainerView;
}

- (UIView*)yCoorBackView
{
    if (!_yCoorBackView) {
        _yCoorBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 160)];
        _yCoorBackView.dk_backgroundColorPicker = DKColorWithColors([UIColor colorWithRed:0.075f green:0.149f blue:0.290f alpha:1.00f], [UIColor colorWithRed:0.408f green:0.616f blue:0.757f alpha:1.00f]);
        UILabel *sixLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, 20, 20)];
        sixLabel.text = self.type == 0? @"60" : @"15";
        sixLabel.textAlignment = NSTextAlignmentLeft;
        sixLabel.dk_textColorPicker = kTextColorPicker;
        sixLabel.font = [UIFont systemFontOfSize:14];
        [_yCoorBackView addSubview:sixLabel];
        UIView *sixLine = [[UIView alloc]initWithFrame:CGRectMake(17, 79.5, self.frame.size.width-17, 1)];
        sixLine.dk_backgroundColorPicker = DKColorWithColors([UIColor colorWithRed:0.133f green:0.698f blue:0.914f alpha:.30f], [UIColor colorWithWhite:1 alpha:0.3]);
        [_yCoorBackView addSubview:sixLine];
        
        UILabel *fiveLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 104, 20, 20)];
        fiveLabel.text = self.type == 0? @"50" : @"10";
        fiveLabel.textAlignment = NSTextAlignmentLeft;
        fiveLabel.dk_textColorPicker = kTextColorPicker;
        fiveLabel.font = [UIFont systemFontOfSize:14];
        [_yCoorBackView addSubview:fiveLabel];
        UIView *fiveLine = [[UIView alloc]initWithFrame:CGRectMake(17, 114, self.frame.size.width-17, 1)];
        fiveLine.dk_backgroundColorPicker = DKColorWithColors([UIColor colorWithRed:0.133f green:0.698f blue:0.914f alpha:.30f], [UIColor colorWithWhite:1 alpha:0.3]);
        [_yCoorBackView addSubview:fiveLine];
        
        UILabel *sevenLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 33, 20, 20)];
        sevenLabel.text = self.type == 0? @"70" : @"20";
        sevenLabel.textAlignment = NSTextAlignmentLeft;
        sevenLabel.dk_textColorPicker = kTextColorPicker;
        sevenLabel.font = [UIFont systemFontOfSize:14];
        [_yCoorBackView addSubview:sevenLabel];
        UIView *sevenLine = [[UIView alloc]initWithFrame:CGRectMake(17, 43, self.frame.size.width-17, 1)];
        sevenLine.dk_backgroundColorPicker = DKColorWithColors([UIColor colorWithRed:0.133f green:0.698f blue:0.914f alpha:.30f], [UIColor colorWithWhite:1 alpha:0.3]);
        [_yCoorBackView addSubview:sevenLine];
    }
    return _yCoorBackView;
}

- (FloatLayerView *)layerFloatView
{
    if (!_layerFloatView) {
        _layerFloatView = [[FloatLayerView alloc]initWithFrame:CGRectMake(0, 0, 20, 15)];
        CGFloat xCoor = self.frame.size.width*4/25/2;
        CGPoint xPoint = CGPointMake(xCoor, 180-20-7.5);
        self.layerFloatView.center = xPoint;
        
    }
    return _layerFloatView;
}



- (void)configure:(UITableViewCell *)cell
        customObj:(id)obj
        indexPath:(NSIndexPath *)indexPath
    withOtherInfo:(id)objInfo
{
    // Rewrite this func in SubClass !
    NSNumber *type = obj;
    self.type = [type intValue];
    if (self.type == SensorDataHeart) {
        self.chartGraphView.heartViewLeft.maxValue = kHeartMaxAlarmValue;
        self.chartGraphView.heartViewLeft.minValue = kHeartMinAlarmValue;
        self.chartGraphView.heartViewLeft.horizonValue = kHeartHorizonbleAlarmValue;
        self.chartGraphView.heartViewLeft.type = SensorDataHeart;
    }else if (self.type == SensorDataBreath){
        self.chartGraphView.heartViewLeft.maxValue = kBreathMaxAlarmValue;
        self.chartGraphView.heartViewLeft.minValue = kBreathMinAlarmValue;
        self.chartGraphView.heartViewLeft.horizonValue = kBreathHorizonbleAlarmValue;
        self.chartGraphView.heartViewLeft.type = SensorDataBreath;
    }
    SensorDataModel *model = objInfo;
    [self.scrollContainerView addSubview:self.yCoorBackView];
    @weakify(self);
    [SleepModelChange filterSensorDataWithTime:model withType:self.type callBack:^(id callBack) {
        @strongify(self);
        self.chartGraphView.heartViewLeft.values = (NSArray *)callBack;
        self.changedArr = callBack;
        [self.chartGraphView.heartViewLeft animate];
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x < 0) {
        scrollView.contentOffset = CGPointMake(0, 0);
        return;
    }
    if (scrollView.contentSize.width>scrollView.frame.size.width&&scrollView.contentOffset.x>0) {
        if (scrollView.contentSize.width-scrollView.contentOffset.x < scrollView.frame.size.width) {
            scrollView.contentOffset = CGPointMake(scrollView.contentSize.width - scrollView.frame.size.width,0 );
            return;
        }
    }
    //纵坐标
    CGRect yRect = self.yCoorBackView.frame;
    yRect.origin.x = scrollView.contentOffset.x;
    self.yCoorBackView.frame = yRect;
    CGFloat xLeft = self.frame.size.width*4/25/2;
    //浮标的位置
    CGFloat xScaleValue = scrollView.contentOffset.x+(scrollView.contentOffset.x)*(self.frame.size.width-2*xLeft)/(self.frame.size.width*3)+xLeft;
    CGPoint point = CGPointMake(xScaleValue, 180-20-7.5);
    self.layerFloatView.center = point;
    //浮标数据
    if (self.type == SensorDataHeart) {
        
        CGFloat xWidth = ([[UIScreen mainScreen] applicationFrame].size.width*4-2*20)/kChartDataCount;
        int xIndex = (int)(xScaleValue/xWidth)-5;
        if (xIndex<kChartDataCount) {
            int xValue = [[self.changedArr objectAtIndex:xIndex] intValue];
            if (xValue==60) {
                xValue = xValue-60;
            }
            self.layerFloatView.dataString = [NSString stringWithFormat:@"%d",xValue];
        }
    }else if(self.type == SensorDataBreath){
        CGFloat xWidth = ([[UIScreen mainScreen] applicationFrame].size.width*4-2*20)/kChartDataCount;
        int xIndex = (int)(xScaleValue/xWidth)-5;
        if (xIndex<kChartDataCount) {
            int xValue = [[self.changedArr objectAtIndex:xIndex] intValue];
            if (xValue==15) {
                xValue = xValue-15;
            }
            self.layerFloatView.dataString = [NSString stringWithFormat:@"%d",xValue];
        }
    }
}


@end
