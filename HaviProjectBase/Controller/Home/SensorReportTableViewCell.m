//
//  ReportTableViewCell.m
//  SleepRecoding
//
//  Created by Havi on 15/8/10.
//  Copyright (c) 2015年 Havi. All rights reserved.
//

#import "SensorReportTableViewCell.h"

@interface SensorReportTableViewCell ()
{
    UILabel *titleLabel;
    UILabel *dataLabel;
    UIView *lineViewBottom;
    UIView *lineView;
}
@end

@implementation SensorReportTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        titleLabel = [[UILabel alloc]init];
        [self addSubview:titleLabel];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.dk_textColorPicker = kTextColorPicker;
        titleLabel.font = [UIFont systemFontOfSize:14];
        [titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(10);
            make.height.equalTo(self);
        }];
        lineView = [[UIView alloc]init];
        lineView.dk_backgroundColorPicker = DKColorWithColors([UIColor colorWithRed:0.161f green:0.251f blue:0.365f alpha:1.00f], [UIColor colorWithRed:0.349f green:0.608f blue:0.780f alpha:1.00f]);
        [self addSubview:lineView];
        [lineView makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.height.equalTo(@60);
            make.width.equalTo(@0.5);
        }];
        //
        dataLabel = [[UILabel alloc]init];
        dataLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:dataLabel];
        dataLabel.font = [UIFont systemFontOfSize:14];
        dataLabel.dk_textColorPicker = DKColorWithColors([UIColor colorWithRed:0.000f green:0.851f blue:0.573f alpha:1.00f], [UIColor whiteColor]);
        [dataLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(titleLabel.mas_right).offset(20);
            make.height.equalTo(self);
            make.right.equalTo(self).offset(-10);
            make.width.equalTo(titleLabel.mas_width);
        }];
        lineViewBottom = [[UIView alloc]init];
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

- (void)configure:(UITableViewCell *)cell
        customObj:(id)obj
        indexPath:(NSIndexPath *)indexPath
    withOtherInfo:(id)objInfo
{
    // Rewrite this func in SubClass !
    NSNumber *type = obj;
    NSArray *arr = [type intValue] == SensorDataHeart ? @[@"心率平均值",@"心率异常数",@"心率异常数高于"]:@[@"呼吸平均值",@"呼吸异常数",@"呼吸异常数高于"];
    SleepQualityModel *model = objInfo;
    titleLabel.text = [arr objectAtIndex:indexPath.row-2];
    
    NSArray *dataArr = [type intValue] == SensorDataHeart ? @[[NSString stringWithFormat:@"%d次/分",[model.averageHeartRate intValue]],[NSString stringWithFormat:@"%d次",[model.fastHeartRateTimes intValue]+[model.slowHeartRateTimes intValue]],[NSString stringWithFormat:@"%d%@",[model.abnormalHeartRatePercent intValue],@"%用户"]]:@[[NSString stringWithFormat:@"%d次/分",[model.averageRespiratoryRate intValue]],[NSString stringWithFormat:@"%d次",[model.slowRespiratoryRateTimes intValue]+[model.fastRespiratoryRateTimes intValue]],[NSString stringWithFormat:@"%d%@",[model.abnormalRespiratoryRatePercent intValue],@"%用户"]];
    dataLabel.text = [dataArr objectAtIndex:indexPath.row-2];
    cell.dk_backgroundColorPicker = DKColorWithColors([UIColor colorWithRed:0.059f green:0.141f blue:0.231f alpha:1.00f], [UIColor colorWithRed:0.475f green:0.686f blue:0.820f alpha:1.00f]);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

}

@end
