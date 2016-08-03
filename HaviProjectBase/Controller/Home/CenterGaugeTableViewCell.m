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
        float height = 0;
        if (ISIPHON6S) {
            height = 315;
        }else{
            
            height = 315/1.174;
        }
        self.cellCircleView = [[ZZHCircleView alloc]initWithFrame:(CGRect){0,0,self.frame.size.width,height-50}];
        self.cellCircleView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.cellCircleView];
        _cellCircleView.userInteractionEnabled = YES;
        UIView *tapBack = [[UIView alloc]init];
        tapBack.backgroundColor = [UIColor clearColor];
        tapBack.layer.masksToBounds = YES;
        tapBack.layer.cornerRadius = 100;
        [_cellCircleView addSubview:tapBack];
        [tapBack makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_cellCircleView.mas_centerY);
            make.centerX.equalTo(_cellCircleView.mas_centerX);
            make.width.height.equalTo(@200);
        }];
        UITapGestureRecognizer *_tapLeftGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeValueAnimation:)];
        [self addSubview:_cellCircleView];
        [tapBack addGestureRecognizer:_tapLeftGesture];
        [self addSubview:self.cellRecommend];
        _cellRecommend.frame = (CGRect){0,height-65,self.frame.size.width,50};
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
        [self.cellCircleView setPercentage:sleepLevel];
        [self.cellCircleView setPeoplePer:sleepLevel];
        
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
    if (point.x>self.cellCircleView.frame.origin.x && point.x< (self.cellCircleView.frame.origin.x +self.cellCircleView.frame.size.width) && point.y>self.cellCircleView.frame.origin.y && point.y< (self.cellCircleView.frame.origin.y +self.cellCircleView.frame.size.height)) {
//
        [self showEndTimePicker];
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
