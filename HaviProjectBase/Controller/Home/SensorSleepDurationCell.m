//
//  SensorSleepDurationCell.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/25.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "SensorSleepDurationCell.h"
#import "SleepTimeTagView.h"

@interface SensorSleepDurationCell ()

@property (nonatomic,strong) SleepTimeTagView *longSleepView;

@end

@implementation SensorSleepDurationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.longSleepView];
        UIView *lineViewBottom = [[UIView alloc]init];
        lineViewBottom.dk_backgroundColorPicker = DKColorWithColors([UIColor colorWithRed:0.161f green:0.251f blue:0.365f alpha:1.00f], [UIColor colorWithRed:0.349f green:0.608f blue:0.780f alpha:1.00f]);
        [self addSubview:lineViewBottom];
        [lineViewBottom makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom).offset(-0.5);
            make.height.equalTo(@0.5);
            make.width.equalTo(self.mas_width);
        }];
    }
    return self;
}

- (SleepTimeTagView *)longSleepView
{
    if (_longSleepView == nil) {
        _longSleepView = [[SleepTimeTagView alloc]init ];
        _longSleepView.frame = CGRectMake(0, 1, self.frame.size.width, 58);
        _longSleepView.sleepNightCategoryString = @"睡眠时长";
    }
    return _longSleepView;
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
        self.longSleepView.sleepYearMonthDayString = detailModel.date;
        self.longSleepView.grade = [detailModel.sleepDuration floatValue]/24;
    }];
    [SleepModelChange changeSleepDuration:model callBack:^(id callBack) {
        @strongify(self);
        self.longSleepView.sleepTimeLongString = callBack;
    }];
    cell.dk_backgroundColorPicker = DKColorWithColors([UIColor colorWithRed:0.059f green:0.141f blue:0.231f alpha:1.00f], [UIColor colorWithRed:0.475f green:0.686f blue:0.820f alpha:1.00f]);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}


@end
