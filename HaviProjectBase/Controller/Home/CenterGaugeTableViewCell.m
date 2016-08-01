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

@property (nonatomic, strong) StartTimeView *cellStartView;
@property (nonatomic, strong) UILabel *cellRecommend;
@property (nonatomic, assign) int value;

@end

@implementation CenterGaugeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (ISIPHON4) {
            
            
        }else{
            
        }
        self.cellCircleView = [[ZZHCircleView alloc]initWithFrame:(CGRect){0,0,self.frame.size.width,250}];
        self.cellCircleView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.cellCircleView];
        _cellCircleView.userInteractionEnabled = YES;
        UITapGestureRecognizer *_tapLeftGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeValueAnimation:)];
        [_cellCircleView addGestureRecognizer:_tapLeftGesture];
        [self addSubview:_cellCircleView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showEndTimePicker)];
        [self.cellCircleView addGestureRecognizer:tap];
        [self addSubview:self.cellRecommend];
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

- (UILabel *)cellRecommend
{
    if (_cellRecommend == nil) {
        _cellRecommend = [[UILabel alloc]init];
        _cellRecommend.frame = (CGRect){0,240,self.frame.size.width,50};
        _cellRecommend.textAlignment = NSTextAlignmentCenter;
        _cellRecommend.text = @"优质的睡眠保证充足的精神";
        _cellRecommend.textColor = [UIColor whiteColor];
    }
    return _cellRecommend;
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
        double p = arc4random_uniform(100);
        double end = p/100;
        [self.cellCircleView setPercentage:end];
        [self.cellCircleView setPeoplePer:(int)p];
//        if (!detailModel.sleepStartTime || !detailModel.sleepEndTime) {
//            self.cellEndView.hidden = YES;
//            self.cellStartView.hidden = YES;
//        }else{
//            self.cellEndView.hidden = NO;
//            self.cellStartView.hidden = NO;
//            NSString *sleepEndTime = detailModel.sleepEndTime;
//            self.cellEndView.endTime = [sleepEndTime substringWithRange:NSMakeRange(11, 5)];
//            NSString *sleepStartTime = detailModel.sleepStartTime;
//            self.cellStartView.startTime = [sleepStartTime substringWithRange:NSMakeRange(11, 5)];
//        }
//        if (abs((int)[selectedDateToUse daysFrom:[NSDate date]]) > 7) {
//            self.cellEndView.hidden = YES;
//            self.cellStartView.hidden = YES;
//        }
        
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
//        self.cellCircleView.value = 0;
//        [self.cellCircleView changeSleepQualityValue:self.value*20];//睡眠指数
//        [self.cellCircleView changeSleepTimeValue:self.value*20];
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
