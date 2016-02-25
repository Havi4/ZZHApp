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

@interface CenterGaugeTableViewCell ()

@property (nonatomic, strong) CHCircleGaugeView *leftCircleView;
@property (nonatomic, assign) int value;

@end

@implementation CenterGaugeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        int datePickerHeight = kScreen_Height*0.202623;
        if (ISIPHON4) {
            _leftCircleView = [[CHCircleGaugeView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - (64 + 4*44 +30 + 10)-datePickerHeight-10-35+60)];
            
        }else{
            _leftCircleView = [[CHCircleGaugeView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - (64 + 4*44 +30 + 10)-datePickerHeight-10-35)];
        }
        _leftCircleView.trackTintColor = selectedThemeIndex==0?[UIColor colorWithRed:0.259f green:0.392f blue:0.498f alpha:1.00f] : [UIColor colorWithRed:0.961f green:0.863f blue:0.808f alpha:1.00f];
        _leftCircleView.trackWidth = 1;
        _leftCircleView.gaugeStyle = CHCircleGaugeStyleOutside;
        _leftCircleView.gaugeTintColor = [UIColor blackColor];
        _leftCircleView.gaugeWidth = 15;
        _leftCircleView.valueTitleLabel.dk_textColorPicker = kTextColorPicker;
        _leftCircleView.textColor = selectedThemeIndex==0?kDefaultColor:[UIColor whiteColor];
        _leftCircleView.responseColor = [UIColor greenColor];
        _leftCircleView.font = [UIFont systemFontOfSize:30];
        _leftCircleView.rotationValue = 100;
        _leftCircleView.value = 0.90;
        _leftCircleView.rotationValue = 88;
        _leftCircleView.userInteractionEnabled = YES;
        UITapGestureRecognizer *_tapLeftGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeValueAnimation:)];
        [_leftCircleView addGestureRecognizer:_tapLeftGesture];
        [self addSubview:_leftCircleView];
    }
    return self;
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
    [SleepModelChange changeSleepValueDuration:model callBack:^(id callBack) {
        @strongify(self);
        int sleepLevel = [callBack intValue];
        self.value = sleepLevel;
        [self.leftCircleView changeSleepQualityValue:sleepLevel*20];//睡眠指数
        [self.leftCircleView changeSleepTimeValue:sleepLevel*20];
        [self.leftCircleView changeSleepLevelValue:[self changeNumToWord:sleepLevel]];
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
    CGPoint point = [gesture locationInView:self.leftCircleView];
    if (point.x>(self.leftCircleView.frame.size.width- self.leftCircleView.frame.size.height)/2 && point.x <self.leftCircleView.frame.size.height+(self.leftCircleView.frame.size.width- self.leftCircleView.frame.size.height)/2) {
        self.leftCircleView.value = 0.1;
        [self.leftCircleView changeSleepQualityValue:self.value*20];//睡眠指数
        [self.leftCircleView changeSleepTimeValue:self.value*20];
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
