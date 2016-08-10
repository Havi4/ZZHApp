//
//  ReportTableViewCell.m
//  SleepRecoding
//
//  Created by Havi on 15/8/10.
//  Copyright (c) 2015年 Havi. All rights reserved.
//

#import "ReportTableViewCell.h"

@interface ReportTableViewCell ()
{
    UILabel *titleLabel;
    UILabel *dataLabel;
    UIView *lineViewBottom;
    
    UIView *backView;
    UILabel *leftTitleLabel;
    UILabel *leftTitleSubLabel;
    UILabel *leftDataLabel;
    
    UILabel *middleTitleLabel;
    UILabel *middleTitleSubLabel;
    UILabel *middleDataLabel;
    
    UILabel *rightTitleLabel;
    UILabel *rightTitleSubLabel;
    UILabel *rightDataLabel;
    
}
@end

@implementation ReportTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"心率分析:";
        titleLabel.textColor = kReportCellColor;
        titleLabel.font = [UIFont systemFontOfSize:20];
        [self addSubview:titleLabel];
        [titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(8);
            make.top.equalTo(self.mas_top).offset(16);
        }];
        
        backView = [[UIView alloc]init];
        backView.backgroundColor = [UIColor colorWithRed:0.910 green:0.914 blue:0.918 alpha:1.00];
        [self addSubview:backView];
        [backView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(8);
            make.left.equalTo(self.mas_left).offset(8);
            make.bottom.equalTo(self.mas_bottom).offset(-8);
            make.right.equalTo(self.mas_right).offset(-8);
        }];
        
        UIView *leftLine = [[UIView alloc]init];
        leftLine.backgroundColor = [UIColor colorWithRed:0.980 green:0.984 blue:0.988 alpha:1.00];
        [self addSubview:leftLine];
        [leftLine makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@1);
            make.top.equalTo(backView.mas_top).offset(8);
            make.bottom.equalTo(backView.mas_bottom).offset(-8);
            make.centerX.equalTo(backView.mas_centerX).multipliedBy(0.66667);
        }];
        
        UIView *rightLine = [[UIView alloc]init];
        rightLine.backgroundColor = [UIColor colorWithRed:0.980 green:0.984 blue:0.988 alpha:1.00];
        [self addSubview:rightLine];
        [rightLine makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@1);
            make.top.equalTo(backView.mas_top).offset(8);
            make.bottom.equalTo(backView.mas_bottom).offset(-8);
            make.centerX.equalTo(backView.mas_centerX).multipliedBy(1.333333);
        }];
        
        leftTitleLabel = [[UILabel alloc]init];
        leftTitleLabel.text = @"";
        leftTitleLabel.font = [UIFont systemFontOfSize:13];
        leftTitleLabel.textColor = kReportCellColor;
        [backView addSubview:leftTitleLabel];
        
        leftTitleSubLabel = [[UILabel alloc]init];
        leftTitleSubLabel.text = @"正常";
        leftTitleSubLabel.layer.borderColor = kReportCellColor.CGColor;
        leftTitleSubLabel.layer.borderWidth = 0.5;
        leftTitleSubLabel.layer.cornerRadius = 7.5;
        leftTitleSubLabel.textAlignment = NSTextAlignmentCenter;
        leftTitleSubLabel.font = [UIFont systemFontOfSize:10];
        leftTitleSubLabel.textColor = kReportCellColor;
        [backView addSubview:leftTitleSubLabel];
        
        [leftTitleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(backView.mas_top).offset(8);
            make.height.equalTo(@30);
            make.left.mas_greaterThanOrEqualTo(backView.mas_left).offset(0).priorityHigh();
            make.right.equalTo(leftTitleSubLabel.mas_left).offset(0);
        }];
        [leftTitleSubLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(leftTitleLabel.mas_centerY);
            make.right.mas_greaterThanOrEqualTo(leftLine.mas_left).offset(-3).priorityHigh();
            make.width.equalTo(@25);
            make.height.equalTo(@15);
        }];
        
        leftDataLabel = [[UILabel alloc]init];
        leftDataLabel.textAlignment = NSTextAlignmentLeft;
        leftDataLabel.textColor = kReportCellColor;
        leftDataLabel.text = @"--次/分钟";
        leftDataLabel.font = [UIFont systemFontOfSize:17];
        [backView addSubview:leftDataLabel];
        [leftDataLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(leftTitleLabel.mas_bottom).offset(5);
            make.left.equalTo(leftTitleLabel.mas_left);
        }];
        //
        middleTitleLabel = [[UILabel alloc]init];
        middleTitleLabel.text = @"";
        middleTitleLabel.font = [UIFont systemFontOfSize:13];
        middleTitleLabel.textColor = kReportCellColor;
        [backView addSubview:middleTitleLabel];
        
        middleTitleSubLabel = [[UILabel alloc]init];
        middleTitleSubLabel.text = @"偏高";
        middleTitleSubLabel.layer.borderColor = kReportCellColor.CGColor;
        middleTitleSubLabel.layer.borderWidth = 0.5;
        middleTitleSubLabel.layer.cornerRadius = 7.5;
        middleTitleSubLabel.textAlignment = NSTextAlignmentCenter;
        middleTitleSubLabel.font = [UIFont systemFontOfSize:10];
        middleTitleSubLabel.textColor = kReportCellColor;
        [backView addSubview:middleTitleSubLabel];
        
        middleDataLabel = [[UILabel alloc]init];
        middleDataLabel.textAlignment = NSTextAlignmentLeft;
        middleDataLabel.textColor = kReportCellColor;
        middleDataLabel.text = @"--次/分钟";
        middleDataLabel.font = [UIFont systemFontOfSize:17];
        [backView addSubview:middleDataLabel];
        [middleTitleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(backView.mas_top).offset(8);
            make.height.equalTo(@30);
            make.left.mas_greaterThanOrEqualTo(leftLine.mas_left).offset(0).priorityHigh();
            make.right.equalTo(middleTitleSubLabel.mas_left).offset(0);
        }];
        [middleTitleSubLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(leftTitleLabel.mas_centerY);
            make.right.mas_greaterThanOrEqualTo(rightLine.mas_left).offset(-3).priorityHigh();
            make.width.equalTo(@25);
            make.height.equalTo(@15);
        }];
        [middleDataLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(leftTitleLabel.mas_bottom).offset(5);
            make.left.equalTo(middleTitleLabel.mas_left);
        }];
        //
        rightTitleLabel = [[UILabel alloc]init];
        rightTitleLabel.text = @"";
        rightTitleLabel.font = [UIFont systemFontOfSize:13];
        rightTitleLabel.textColor = kReportCellColor;
        rightTitleLabel.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:rightTitleLabel];
        
        rightTitleSubLabel = [[UILabel alloc]init];
        rightTitleSubLabel.text = @"";
        rightTitleSubLabel.layer.borderColor = kReportCellColor.CGColor;
        rightTitleSubLabel.layer.borderWidth = 0.5;
        rightTitleSubLabel.layer.cornerRadius = 7.5;
        rightTitleSubLabel.textAlignment = NSTextAlignmentCenter;
        rightTitleSubLabel.font = [UIFont systemFontOfSize:10];
        rightTitleSubLabel.textColor = kReportCellColor;
//        [backView addSubview:rightTitleSubLabel];
        
        rightDataLabel = [[UILabel alloc]init];
        rightDataLabel.textAlignment = NSTextAlignmentLeft;
        rightDataLabel.textColor = kReportCellColor;
        rightDataLabel.text = @"--次/分钟";
        
        rightDataLabel.font = [UIFont systemFontOfSize:17];
        [backView addSubview:rightDataLabel];
        [rightTitleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(backView.mas_top).offset(8);
            make.height.equalTo(@30);
//            make.left.equalTo(rightLine.mas_left).offset(0);
//            make.right.equalTo(backView.mas_right).offset(0);
            make.centerX.equalTo(backView.mas_centerX).multipliedBy(1.6667);
        }];
        [rightDataLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(leftTitleLabel.mas_bottom).offset(5);
            make.leadingMargin.equalTo(rightTitleLabel.mas_leadingMargin);
        }];
    }
    return self;
}

- (void)configure:(UITableViewCell *)cell
        customObj:(id)obj
        indexPath:(NSIndexPath *)indexPath
    withOtherInfo:(id)objInfo
{
    NSDictionary *titleDic = obj;
    // Rewrite this func in SubClass !
    titleLabel.text = [NSString stringWithFormat:@"%@",[titleDic objectForKey:@"title"]];
    leftTitleLabel.text = [NSString stringWithFormat:@"%@",[titleDic objectForKey:@"left"]];
    middleTitleLabel.text = [NSString stringWithFormat:@"%@",[titleDic objectForKey:@"middle"]];
    rightTitleLabel.text = [NSString stringWithFormat:@"%@",[titleDic objectForKey:@"right"]];
    SleepQualityModel *model = objInfo;
    if (indexPath.section == 1) {
        if ([model.averageHeartRate intValue]==0) {
            leftDataLabel.text = [NSString stringWithFormat:@"--次/分钟"];
        }else{
            leftDataLabel.text = [NSString stringWithFormat:@"%d次/分钟",[model.averageHeartRate intValue]];
        }
        if (([model.fastHeartRateTimes intValue]+[model.slowHeartRateTimes intValue])==0) {
            middleDataLabel.text = [NSString stringWithFormat:@"--次"];
        }else{
            middleDataLabel.text = [NSString stringWithFormat:@"%d次",[model.fastHeartRateTimes intValue]+[model.slowHeartRateTimes intValue]];
        }
        if ([model.abnormalHeartRatePercent intValue]==0) {
            rightDataLabel.text = [NSString stringWithFormat:@"--%@用户",@"%"];
        }else{
            rightDataLabel.text = [NSString stringWithFormat:@"%d%@用户",[model.abnormalHeartRatePercent intValue],@"%"];
        }
        
    }else if (indexPath.section == 2){
        if ([model.averageRespiratoryRate intValue]==0) {
            leftDataLabel.text = [NSString stringWithFormat:@"--次/分钟"];
        }else{
            leftDataLabel.text = [NSString stringWithFormat:@"%d次/分钟",[model.averageRespiratoryRate intValue]];
        }
        
        if ([model.fastRespiratoryRateTimes intValue]+[model.slowRespiratoryRateTimes intValue]==0) {
            middleDataLabel.text = [NSString stringWithFormat:@"--次"];
        }else{
            middleDataLabel.text = [NSString stringWithFormat:@"%d次",[model.fastRespiratoryRateTimes intValue]+[model.slowRespiratoryRateTimes intValue]];
        }
        
        if ([model.abnormalRespiratoryRatePercent intValue]==0) {
            rightDataLabel.text = [NSString stringWithFormat:@"--%@用户",@"%"];
        }else{
            rightDataLabel.text = [NSString stringWithFormat:@"%d%@用户",[model.abnormalRespiratoryRatePercent intValue],@"%"];
        }
        
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
}

@end
