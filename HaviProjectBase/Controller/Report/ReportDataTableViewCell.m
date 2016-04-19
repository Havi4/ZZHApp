//
//  ReportDataTableViewCell.m
//  SleepRecoding
//
//  Created by Havi on 15/9/15.
//  Copyright (c) 2015年 Havi. All rights reserved.
//

#import "ReportDataTableViewCell.h"

@interface ReportDataTableViewCell ()
{
    UILabel *leftTitleLabel;
    UILabel *rightTitleLabel;
    UILabel *leftDataLabel;
    UILabel *rightDataLabel;
    UIView *lineViewBottom;
    UIView *lineView;
}
@end

@implementation ReportDataTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        leftTitleLabel = [[UILabel alloc]init];
        [self addSubview:leftTitleLabel];
        leftTitleLabel.textAlignment = NSTextAlignmentCenter;
        leftTitleLabel.textColor = selectedThemeIndex==0?kDefaultColor:[UIColor whiteColor];
        leftTitleLabel.font = _cellFont?_cellFont:[UIFont systemFontOfSize:14];
        [leftTitleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self.mas_top).equalTo(@10);
        }];
        //
        leftDataLabel = [[UILabel alloc]init];
        [self addSubview:leftDataLabel];
        leftDataLabel.textAlignment = NSTextAlignmentCenter;
        leftDataLabel.dk_textColorPicker = DKColorWithColors([UIColor colorWithRed:0.000f green:0.855f blue:0.576f alpha:1.00f], [UIColor whiteColor]);
        leftDataLabel.font = _cellFont?_cellFont:[UIFont systemFontOfSize:14];
        [leftDataLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(leftTitleLabel.mas_bottom).offset(0);
            make.height.equalTo(leftTitleLabel.mas_height);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
        }];
        //
        rightTitleLabel = [[UILabel alloc]init];
        [self addSubview:rightTitleLabel];
        rightTitleLabel.textAlignment = NSTextAlignmentCenter;
        rightTitleLabel.textColor = selectedThemeIndex==0?kDefaultColor:[UIColor whiteColor];
        rightTitleLabel.font = _cellFont?_cellFont:[UIFont systemFontOfSize:14];
        [rightTitleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftTitleLabel.mas_right).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
            make.top.equalTo(self.mas_top).offset(10);
            make.width.equalTo(leftTitleLabel.mas_width);
        }];
        //
        rightDataLabel = [[UILabel alloc]init];
        [self addSubview:rightDataLabel];
        rightDataLabel.backgroundColor = [UIColor clearColor];
        rightDataLabel.textAlignment = NSTextAlignmentCenter;
        rightDataLabel.dk_textColorPicker = DKColorWithColors([UIColor colorWithRed:0.000f green:0.855f blue:0.576f alpha:1.00f], [UIColor whiteColor]);
        rightDataLabel.font = _cellFont?_cellFont:[UIFont systemFontOfSize:14];
        [rightDataLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftDataLabel.mas_right).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
            make.top.equalTo(rightTitleLabel.mas_bottom).offset(0);
            make.width.equalTo(leftDataLabel.mas_width);
            make.height.equalTo(rightTitleLabel.mas_height);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
        }];
        //
        lineView = [[UIView alloc]init];
        lineView.dk_backgroundColorPicker = DKColorWithColors([UIColor colorWithRed:0.161f green:0.251f blue:0.365f alpha:1.00f], [UIColor colorWithRed:0.349f green:0.608f blue:0.780f alpha:1.00f]);
        [self addSubview:lineView];
        [lineView makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.height.equalTo(self.mas_height);
            make.width.equalTo(@0.5);
        }];
        //
        lineViewBottom = [[UIView alloc]init];
        lineViewBottom.dk_backgroundColorPicker = DKColorWithColors([UIColor colorWithRed:0.161f green:0.251f blue:0.365f alpha:1.00f], [UIColor colorWithRed:0.349f green:0.608f blue:0.780f alpha:1.00f]);
        [self addSubview:lineViewBottom];
        [lineViewBottom makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom);
            make.height.equalTo(@0.5);
            make.width.equalTo(self);
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
    NSArray *arr = obj;
    leftTitleLabel.text = [arr objectAtIndex:0];
    rightTitleLabel.text = [arr objectAtIndex:1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dk_backgroundColorPicker = DKColorWithColors([UIColor colorWithRed:0.059f green:0.141f blue:0.231f alpha:1.00f], [UIColor colorWithRed:0.475f green:0.686f blue:0.820f alpha:1.00f]);
    SleepQualityModel *model = objInfo;
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 1:
            {
                leftDataLabel.text = [NSString stringWithFormat:@"%d次/分钟",[model.averageHeartRate intValue]];
                rightDataLabel.text = [NSString stringWithFormat:@"%d次/分钟",[model.averageRespiratoryRate intValue]];
                break;
            }
            case 2:{
                leftDataLabel.text = [NSString stringWithFormat:@"%d次",[model.fastHeartRateTimes intValue]+[model.slowHeartRateTimes intValue]];
                rightDataLabel.text = [NSString stringWithFormat:@"%d次",[model.fastRespiratoryRateTimes intValue]+[model.slowRespiratoryRateTimes intValue]];
                break;
            }
            case 3:{
                leftDataLabel.text = [NSString stringWithFormat:@"%d%@用户",[model.abnormalHeartRatePercent intValue],@"%"];
                rightDataLabel.text = [NSString stringWithFormat:@"%d%@用户",[model.abnormalRespiratoryRatePercent intValue],@"%"];
                break;
            }
                
            default:
                break;
        }
    }
}

@end
