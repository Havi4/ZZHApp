//
//  CenterGaugeTableViewCell.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/24.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "CenterGaugeTableViewCell.h"
#import "CHCircleGaugeView.h"
#import "SleepModelChange.h"
#import "StartTimeView.h"
#import "EndTimeView.h"

@interface CenterGaugeTableViewCell ()

@property (nonatomic, strong) CHCircleGaugeView *cellCircleView;
@property (nonatomic, strong) StartTimeView *cellStartView;
@property (nonatomic, strong) EndTimeView *cellEndView;
@property (nonatomic, assign) int value;

@end

@implementation CenterGaugeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        int datePickerHeight = kScreen_Height*0.202623;
        if (ISIPHON4) {
            _cellCircleView = [[CHCircleGaugeView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - (64 + 4*44 +30 + 10)-datePickerHeight-10-35+60)];
            
        }else{
            _cellCircleView = [[CHCircleGaugeView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - (64 + 4*44 +30 + 10)-datePickerHeight-10-35)];
        }
        _cellCircleView.trackTintColor = selectedThemeIndex==0?[UIColor colorWithRed:0.259f green:0.392f blue:0.498f alpha:1.00f] : [UIColor colorWithRed:0.961f green:0.863f blue:0.808f alpha:1.00f];
        _cellCircleView.trackWidth = 1;
        _cellCircleView.gaugeStyle = CHCircleGaugeStyleOutside;
        _cellCircleView.gaugeTintColor = [UIColor blackColor];
        _cellCircleView.gaugeWidth = 15;
        _cellCircleView.valueTitleLabel.dk_textColorPicker = kTextColorPicker;
        _cellCircleView.textColor = selectedThemeIndex==0?kDefaultColor:[UIColor whiteColor];
        _cellCircleView.responseColor = [UIColor greenColor];
        _cellCircleView.font = [UIFont systemFontOfSize:30];
        _cellCircleView.rotationValue = 100;
        _cellCircleView.value = 0.90;
        _cellCircleView.rotationValue = 88;
        _cellCircleView.userInteractionEnabled = YES;
        UITapGestureRecognizer *_tapLeftGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeValueAnimation:)];
        [_cellCircleView addGestureRecognizer:_tapLeftGesture];
        [self addSubview:_cellCircleView];
        [_cellCircleView addSubview:self.cellStartView];
        self.cellStartView.center = CGPointMake(85, 10);
        [_cellCircleView addSubview:self.cellEndView];
        self.cellEndView.center = CGPointMake(self.frame.size.width-60, 10);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showEndTimePicker)];
        [self.cellEndView addGestureRecognizer:tap];
    }
    return self;
}

- (StartTimeView *)cellStartView
{
    if (_cellStartView==nil) {
        _cellStartView = [[StartTimeView alloc]init];
        _cellStartView.hidden = YES;
        
    }
    return _cellStartView;
}

- (EndTimeView *)cellEndView
{
    if (_cellEndView == nil) {
        _cellEndView = [[EndTimeView alloc]init];
        _cellEndView.hidden = YES;
    }
    return _cellEndView;
}

- (void)configure:(UITableViewCell *)cell
        customObj:(id)obj
        indexPath:(NSIndexPath *)indexPath
{
    // Rewrite this func in SubClass !
}

- (void)configure:(UITableViewCell *)cell
        customObj:(id)obj
        indexPath:(NSIndexPath *)indexPath
    withOtherInfo:(id)objInfo
{
    // Rewrite this func in SubClass !
    SleepQualityModel *model = objInfo;
    @weakify(self);
    [SleepModelChange changeSleepQualityModel:model callBack:^(id callBack) {
        @strongify(self);
        QualityDetailModel *detailModel = callBack;
        int sleepLevel = [detailModel.sleepQuality intValue];
        self.value = sleepLevel;
        [self.cellCircleView changeSleepQualityValue:sleepLevel*20];//睡眠指数
        [self.cellCircleView changeSleepTimeValue:sleepLevel*20];
        [self.cellCircleView changeSleepLevelValue:[self changeNumToWord:sleepLevel]];
        if (!detailModel.sleepStartTime || !detailModel.sleepEndTime) {
            self.cellEndView.hidden = YES;
            self.cellStartView.hidden = YES;
        }else{
            self.cellEndView.hidden = NO;
            self.cellStartView.hidden = NO;
            NSString *sleepEndTime = detailModel.sleepEndTime;
            self.cellEndView.endTime = [sleepEndTime substringWithRange:NSMakeRange(11, 5)];
            NSString *sleepStartTime = detailModel.sleepStartTime;
            self.cellStartView.startTime = [sleepStartTime substringWithRange:NSMakeRange(11, 5)];
        }
        if (abs((int)[selectedDateToUse daysFrom:[NSDate date]]) > 7) {
            self.cellEndView.hidden = YES;
            self.cellStartView.hidden = YES;
        }
        
    }];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

+ (CGFloat)getCellHeightWithCustomObj:(id)obj
                            indexPath:(NSIndexPath *)indexPath
{
    int datePickerHeight = kScreen_Height*0.202623;
    return kScreen_Height - (64 + 4*44 +30 + 10)-datePickerHeight-10-35;
}

- (void)changeValueAnimation:(UITapGestureRecognizer *)gesture
{
    //在这里请求最新的当日数据或者仅仅是更新数据。
    CGPoint point = [gesture locationInView:self.cellCircleView];
    if (point.x>(self.cellCircleView.frame.size.width- self.cellCircleView.frame.size.height)/2 && point.x <self.cellCircleView.frame.size.height+(self.cellCircleView.frame.size.width- self.cellCircleView.frame.size.height)/2) {
        self.cellCircleView.value = 0;
        [self.cellCircleView changeSleepQualityValue:self.value*20];//睡眠指数
        [self.cellCircleView changeSleepTimeValue:self.value*20];
    }
}

- (void)showEndTimePicker
{
    if (self.cellClockTaped) {
        self.cellClockTaped(@1);
    }
}

- (NSString *)changeNumToWord:(int)level
{
    switch (level) {
        case 1:{
            return @"非常差";
            break;
        }
        case 2:{
            return @"差";
            break;
        }
        case 3:{
            return @"一般";
            break;
        }
        case 4:{
            return @"好";
            break;
        }
        case 5:{
            return @"非常好";
            break;
        }
            
        default:
            return @"没有数据哦";
            break;
    }
}


@end
