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
#import "DXPopover.h"//弹出model
#import "LongpressShowView.h"

@interface SensorChartTableViewCell ()<UIScrollViewDelegate>

@property (nonatomic,strong) ChartGrapheView *chartGraphView;
@property (nonatomic,strong) UIScrollView *scrollContainerView;
@property (nonatomic,strong) UIView *yCoorBackView;
@property (nonatomic,strong) UIView *yCoorBackView1;
@property (nonatomic,strong) FloatLayerView *layerFloatView;
@property (nonatomic,strong) NSArray *changedArr;
@property (nonatomic,assign) int type;
@property (nonatomic,strong) LongpressShowView *pressView;
@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UIImageView *iconImageView1;
@property (nonatomic,strong) NSTimer *timer;

@end

@implementation SensorChartTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.scrollContainerView];
        [self addSubview:self.iconImageView];
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
        _chartGraphView.heartViewLeft.graphColor = [UIColor whiteColor];
//        [_chartGraphView addSubview:self.layerFloatView];
        
    }
    return _chartGraphView;
}

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 15, 15)];
    }
    return _iconImageView;
}
- (UIImageView *)iconImageView1
{
    if (!_iconImageView1) {
        _iconImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 15, 15)];
    }
    return _iconImageView1;
}


- (UIScrollView *)scrollContainerView
{
    if (!_scrollContainerView) {
        _scrollContainerView = [[UIScrollView alloc]initWithFrame:CGRectMake(24, 0, self.frame.size.width-32, 180)];
        [_scrollContainerView addSubview:self.chartGraphView];
        _scrollContainerView.contentSize = CGSizeMake(self.frame.size.width*4, 180);
        _scrollContainerView.showsHorizontalScrollIndicator = NO;
        _scrollContainerView.delegate = self;
        _scrollContainerView.userInteractionEnabled = YES;
        UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
        longPressGr.minimumPressDuration = 1.0;
        [_scrollContainerView addGestureRecognizer:longPressGr];
    }
    return _scrollContainerView;
}

- (UIView*)yCoorBackView
{
    if (!_yCoorBackView) {
        _yCoorBackView = [[UIView alloc]initWithFrame:CGRectMake(5, 0, 15, 160)];
        _yCoorBackView.backgroundColor = [UIColor clearColor];
        UILabel *sixLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, 20, 20)];
        sixLabel.text = self.type == 0? @"60" : @"15";
        sixLabel.textAlignment = NSTextAlignmentLeft;
        sixLabel.textColor = [UIColor whiteColor];
        sixLabel.font = [UIFont systemFontOfSize:14];
        [_yCoorBackView addSubview:sixLabel];
        UIView *sixLine = [[UIView alloc]initWithFrame:CGRectMake(19, 79.5, self.frame.size.width-32, 0.5)];
        sixLine.dk_backgroundColorPicker = DKColorWithColors([UIColor colorWithWhite:0.9 alpha:0.5], [UIColor colorWithWhite:0.9 alpha:0.5]);
        [_yCoorBackView addSubview:sixLine];
        
        UILabel *fiveLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 104, 20, 20)];
        fiveLabel.text = self.type == 0? @"50" : @"10";
        fiveLabel.textAlignment = NSTextAlignmentLeft;
        fiveLabel.dk_textColorPicker = kTextColorPicker;
        fiveLabel.font = [UIFont systemFontOfSize:14];
        [_yCoorBackView addSubview:fiveLabel];
        UIView *fiveLine = [[UIView alloc]initWithFrame:CGRectMake(19, 114, self.frame.size.width-32, 0.5)];
        fiveLine.dk_backgroundColorPicker = DKColorWithColors([UIColor colorWithWhite:0.9 alpha:0.5], [UIColor colorWithWhite:0.9 alpha:0.5]);
        [_yCoorBackView addSubview:fiveLine];
        
        UILabel *sevenLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 33, 20, 20)];
        sevenLabel.text = self.type == 0? @"70" : @"20";
        sevenLabel.textAlignment = NSTextAlignmentLeft;
        sevenLabel.dk_textColorPicker = kTextColorPicker;
        sevenLabel.font = [UIFont systemFontOfSize:14];
        [_yCoorBackView addSubview:sevenLabel];
        UIView *sevenLine = [[UIView alloc]initWithFrame:CGRectMake(19, 43, self.frame.size.width-32, 0.5)];
        sevenLine.dk_backgroundColorPicker = DKColorWithColors([UIColor colorWithWhite:0.9 alpha:0.5], [UIColor colorWithWhite:0.9 alpha:0.5]);;
        [_yCoorBackView addSubview:sevenLine];
    }
    return _yCoorBackView;
}

- (UIView*)yCoorBackView1
{
    if (!_yCoorBackView1) {
        _yCoorBackView1 = [[UIView alloc]initWithFrame:CGRectMake(5, 0, 15, 140)];
        _yCoorBackView1.backgroundColor = [UIColor clearColor];
        UILabel *sixLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, 20, 20)];
        sixLabel.text = self.type == 0? @"60" : @"15";
        sixLabel.textAlignment = NSTextAlignmentLeft;
        sixLabel.textColor = [UIColor whiteColor];
        sixLabel.font = [UIFont systemFontOfSize:13];
        [_yCoorBackView1 addSubview:sixLabel];
        UIView *sixLine = [[UIView alloc]initWithFrame:CGRectMake(19, 79.5, self.frame.size.width-19, 0.5)];
        sixLine.dk_backgroundColorPicker = DKColorWithColors([UIColor colorWithWhite:0.9 alpha:0.5], [UIColor colorWithWhite:0.9 alpha:0.5]);
        [_yCoorBackView1 addSubview:sixLine];
        
        UILabel *fiveLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 104, 20, 20)];
        fiveLabel.text = self.type == 0? @"50" : @"10";
        fiveLabel.textAlignment = NSTextAlignmentLeft;
        fiveLabel.dk_textColorPicker = kTextColorPicker;
        fiveLabel.font = [UIFont systemFontOfSize:13];
        [_yCoorBackView1 addSubview:fiveLabel];
        UIView *fiveLine = [[UIView alloc]initWithFrame:CGRectMake(19, 114, self.frame.size.width-19, 0.5)];
        fiveLine.dk_backgroundColorPicker = DKColorWithColors([UIColor colorWithWhite:0.9 alpha:0.5], [UIColor colorWithWhite:0.9 alpha:0.5]);
        [_yCoorBackView1 addSubview:fiveLine];
        
        UILabel *sevenLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 33, 20, 20)];
        sevenLabel.text = self.type == 0? @"70" : @"20";
        sevenLabel.textAlignment = NSTextAlignmentLeft;
        sevenLabel.dk_textColorPicker = kTextColorPicker;
        sevenLabel.font = [UIFont systemFontOfSize:13];
        [_yCoorBackView1 addSubview:sevenLabel];
        UIView *sevenLine = [[UIView alloc]initWithFrame:CGRectMake(19, 43, self.frame.size.width-19, 0.5)];
        sevenLine.dk_backgroundColorPicker = DKColorWithColors([UIColor colorWithWhite:0.9 alpha:0.5], [UIColor colorWithWhite:0.9 alpha:0.5]);;
        [_yCoorBackView1 addSubview:sevenLine];
    }
    return _yCoorBackView1;
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
        self.iconImageView.image = [UIImage imageNamed:@"icon_heart@3x"];
    }else if (self.type == SensorDataBreath){
        self.chartGraphView.heartViewLeft.maxValue = kBreathMaxAlarmValue;
        self.chartGraphView.heartViewLeft.minValue = kBreathMinAlarmValue;
        self.chartGraphView.heartViewLeft.horizonValue = kBreathHorizonbleAlarmValue;
        self.chartGraphView.heartViewLeft.type = SensorDataBreath;
        self.iconImageView.image = [UIImage imageNamed:@"icon_breath@3x"];
    }
    SensorDataModel *model = objInfo;
    [self addSubview:self.yCoorBackView];
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
//    CGRect yRect = self.yCoorBackView.frame;
//    yRect.origin.x = scrollView.contentOffset.x;
//    self.yCoorBackView.frame = yRect;
    CGFloat xLeft = self.frame.size.width*4/25/2;
    //浮标的位置
    CGFloat xScaleValue = scrollView.contentOffset.x+(scrollView.contentOffset.x)*(self.frame.size.width-2*xLeft)/(self.frame.size.width*3)+xLeft;
    CGPoint point = CGPointMake(xScaleValue, 180-20-7.5);
    self.layerFloatView.center = point;
    //浮标数据
    if (self.type == SensorDataHeart) {
        
        CGFloat xWidth = ([[UIScreen mainScreen] applicationFrame].size.width*4-2*20)/kChartDataCount;
        int xIndex = (int)((xScaleValue-20)/xWidth);
        if (xIndex<kChartDataCount) {
            int xValue = [[self.changedArr objectAtIndex:xIndex] intValue];
            if (xValue==60) {
                xValue = xValue-60;
            }
            self.layerFloatView.dataString = [NSString stringWithFormat:@"%d",xValue];
        }
    }else if(self.type == SensorDataBreath){
        CGFloat xWidth = ([[UIScreen mainScreen] applicationFrame].size.width*4-2*20)/kChartDataCount;
        int xIndex = (int)((xScaleValue-20)/xWidth);
        if (xIndex<kChartDataCount) {
            int xValue = [[self.changedArr objectAtIndex:xIndex] intValue];
            if (xValue==15) {
                xValue = xValue-15;
            }
            self.layerFloatView.dataString = [NSString stringWithFormat:@"%d",xValue];
        }
    }
}

- (void)longPressToDo:(UILongPressGestureRecognizer *)gesture{
    
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        
        CGPoint location = [gesture locationInView:[UIApplication sharedApplication].keyWindow];
        CGPoint timeLocation = [gesture locationInView:self.scrollContainerView];
        
        
        float hour = (timeLocation.x-10)/((self.frame.size.width*4)/25);
        if (hour<0) {
            hour = 0;
            location = CGPointMake((self.frame.size.width*4)/25/2, location.y);
        }
        if (hour>24) {
            hour = 24;
            location = CGPointMake(self.frame.size.width-(self.frame.size.width*4)/25/2, location.y);
        }
        float minute = (hour - (int)hour)*60;
        int hourEnd = (18+(int)hour)<24?(18+(int)hour):(18+(int)hour-24);
        NSString *hr = hourEnd < 10?[NSString stringWithFormat:@"0%d",hourEnd]:[NSString stringWithFormat:@"%d",hourEnd];
        NSString *mi = (int)minute>9?[NSString stringWithFormat:@"%d",(int)minute]:[NSString stringWithFormat:@"0%d",(int)minute];
        NSString *time = [NSString stringWithFormat:@"%@:%@",hr,mi];
        NSString *year = @"";
        if ([hr intValue]>18 || [hr intValue]==18) {
            year = [NSString stringWithFormat:@"%@",[[selectedDateToUse dateByAddingHours:8] dateByAddingDays:-1]];
        }else{
            year = [NSString stringWithFormat:@"%@",[selectedDateToUse dateByAddingHours:8]];
        }
        NSString *tapTime = [NSString stringWithFormat:@"%@ %@:00",[year substringToIndex:10],[time substringWithRange:NSMakeRange(0, 2)]];
        NSDateFormatter *dateF = [[NSDateFormatter alloc]init];
        dateF.dateFormat = @"yyyy-MM-dd HH:mm";
        NSDate *date ;
        date = [dateF dateFromString:tapTime];
//        if ([hr intValue]>18 || [hr intValue]==18) {
//            date = [[[dateF dateFromString:tapTime] dateByAddingHours:8] dateByAddingDays:-1];
//        }else{
//            date = [[[dateF dateFromString:tapTime] dateByAddingHours:8] dateByAddingDays:0];
//        }
        NSMutableArray *arr = @[].mutableCopy;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            for (int i= 0; i<16; i++) {
                NSDateFormatter *dateF = [[NSDateFormatter alloc]init];
                dateF.dateFormat = @"yyyy-MM-dd HH:mm";
                NSDate *new = [[date dateByAddingMinutes:4*(i)] dateByAddingHours:8];
                NSString *newD = [NSString stringWithFormat:@"%@",new];
                DeBugLog(@"%@",newD);
                NSString *sub = [newD substringWithRange:NSMakeRange(11, 5)];
                [arr addObject:sub];
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.pressView.xValues = arr;
            });
        });

        self.pressView.heartViewLeft.curved = YES;
        self.pressView.heartViewLeft.minValue = 0;
        self.pressView.heartViewLeft.maxValue = 100;
        self.pressView.heartViewLeft.type = self.type;
        
        UIView *chaBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 195)];
        
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(17, 20, self.frame.size.width-17, 165)];
        scrollView.contentSize = CGSizeMake(2*self.frame.size.width, 165);
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.delegate = self;
        [scrollView addSubview:self.pressView];
        [chaBackView addSubview:scrollView];
        [chaBackView addSubview:self.yCoorBackView1];
        [chaBackView addSubview:self.iconImageView1];
        self.iconImageView1.image = self.type == 0? [UIImage imageNamed:@"icon_heart@3x"]: [UIImage imageNamed:@"icon_breath@3x"];
        
        UILabel *cellDataLabel = [[UILabel alloc]init];
        cellDataLabel.font = [UIFont systemFontOfSize:25];
        cellDataLabel.text = @"--";
        cellDataLabel.textColor = [UIColor whiteColor];
        [chaBackView addSubview:cellDataLabel];
        [cellDataLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(chaBackView.mas_left).offset(30);
            make.top.equalTo(chaBackView.mas_top);
            
        }];
        UILabel *cellDataSub = [[UILabel alloc]init];
        [chaBackView addSubview:cellDataSub];
        cellDataSub.text = @"次/分";
        cellDataSub.font = [UIFont systemFontOfSize:15];
        
        cellDataSub.textColor = [UIColor whiteColor];
        [cellDataSub makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cellDataLabel.mas_right).offset(0);
            make.baseline.equalTo(cellDataLabel.mas_baseline).offset(0);
        }];
        
        NSDate *new = [date dateByAddingHours:8];
        NSString *newD = [NSString stringWithFormat:@"%@",new];
        ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
        NSDictionary *dic18 = @{
                                @"UUID" : self.UUID,
                                @"DataProperty":@(self.type+3),
                                @"FromDate": [NSString stringWithFormat:@"%@%@%@",[newD substringWithRange:NSMakeRange(0, 4)],[newD substringWithRange:NSMakeRange(5, 2)],[newD substringWithRange:NSMakeRange(8, 2)]],
                                @"FromTime": [NSString stringWithFormat:@"%@:00",[tapTime substringWithRange:NSMakeRange(11, 5)]],
                                };
        [client requestRealSensorDataParams:dic18 andBlock:^(SensorDataModel *sensorModel, NSError *error) {
            if ([sensorModel.returnCode integerValue]==200) {
                [SleepModelChange filterRealSensorDataWithTime:sensorModel withType:self.type startTime:date endTime:[NSString stringWithFormat:@"%@:00",[tapTime substringWithRange:NSMakeRange(11, 5)]] callBack:^(id callBack)  {
                    [self.pressView addlineView];
                    _pressView.heartViewLeft.graphColor = selectedThemeIndex==0?[UIColor whiteColor]:[UIColor whiteColor];
                    self.pressView.heartViewLeft.values = (NSArray *)callBack;
                    [self.pressView.heartViewLeft animate];
                }];
                
                [SleepModelChange filterAverSensorDataWithTime:sensorModel callBack:^(int callBack) {
                    if (callBack==0) {
                        cellDataLabel.text = @"--";
                    }else{
                        
                        cellDataLabel.text = [NSString stringWithFormat:@"%d",callBack];
                    }
                }];
            }else{
                self.pressView.heartViewLeft.values = nil;
                [self.pressView removeLine];
            }
        }];

        if ([new isLaterThan:[[NSDate date] dateByAddingHours:8]]) {
            self.timer = [NSTimer timerWithTimeInterval:5 repeats:YES block:^(NSTimer * _Nonnull timer) {
                ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
                NSDictionary *dic18 = @{
                                        @"UUID" : self.UUID,
                                        @"DataProperty":@(self.type+3),
                                        @"FromDate": [NSString stringWithFormat:@"%@%@%@",[newD substringWithRange:NSMakeRange(0, 4)],[newD substringWithRange:NSMakeRange(5, 2)],[newD substringWithRange:NSMakeRange(8, 2)]],
                                        @"FromTime": [NSString stringWithFormat:@"%@:00",[tapTime substringWithRange:NSMakeRange(11, 5)]],
                                        };
                [client requestRealSensorDataParams:dic18 andBlock:^(SensorDataModel *sensorModel, NSError *error) {
                    if ([sensorModel.returnCode integerValue]==200) {
                        [SleepModelChange filterRealSensorDataWithTime:sensorModel withType:self.type startTime:date endTime:[NSString stringWithFormat:@"%@:00",[tapTime substringWithRange:NSMakeRange(11, 5)]] callBack:^(id callBack)  {
                            [self.pressView addlineView];
                            _pressView.heartViewLeft.graphColor = selectedThemeIndex==0?[UIColor whiteColor]:[UIColor whiteColor];
                            self.pressView.heartViewLeft.values = (NSArray *)callBack;
                            [self.pressView.heartViewLeft animate];
                        }];
                        
                        [SleepModelChange filterAverSensorDataWithTime:sensorModel callBack:^(int callBack) {
                            if (callBack==0) {
                                cellDataLabel.text = @"--";
                            }else{
                                
                                cellDataLabel.text = [NSString stringWithFormat:@"%d",callBack];
                            }
                        }];
                    }else{
                        self.pressView.heartViewLeft.values = nil;
                        [self.pressView removeLine];
                    }
                }];
            }];
        }
        
        
        SleepQualityModel *model = self.sleepModel;
        switch (self.type) {
            case 0:
            {
                if ([model.averageHeartRate intValue]==0) {
                    cellDataLabel.text = @"--";
                }else{
                    
                    cellDataLabel.text = [NSString stringWithFormat:@"%d",[model.averageHeartRate intValue]];
                }
                break;
            }
            case 1:{
                cellDataLabel.text = [NSString stringWithFormat:@"%d",[model.averageRespiratoryRate intValue]];
                break;
            }
                
            default:
                break;
        }

        DXPopover *popover = [DXPopover popover];
        popover.backgroundColor = [UIColor colorWithRed:0.161 green:0.718 blue:0.816 alpha:1.00];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:(CGRect){0,0,self.bounds.size.width,self.bounds.size.height-5}];
        imageView.image = [UIImage imageNamed:@"background"];
        [popover addSubview:imageView];
        popover.cornerRadius = .5;
        popover.arrowSize = CGSizeMake(10, 5);
        [popover showAtPoint:CGPointMake(location.x, 264) popoverPostion:DXPopoverPositionUp withContentView:chaBackView inView:[UIApplication sharedApplication].keyWindow];
        //add your code here
    }
    
}

- (LongpressShowView *)pressView
{
    if (_pressView == nil) {
        CGRect rect = CGRectMake(0, 0, self.frame.size.width*2, 165);
        _pressView = [[LongpressShowView alloc]initWithFrame:rect];
        _pressView.heartViewLeft.graphColor = selectedThemeIndex==0?[UIColor whiteColor]:[UIColor whiteColor];
    }
    return _pressView;
}

@end
