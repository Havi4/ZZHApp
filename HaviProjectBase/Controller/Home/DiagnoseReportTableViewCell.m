//
//  DiagnoseReportTableViewCell.m
//  SleepRecoding
//
//  Created by Havi_li on 15/4/6.
//  Copyright (c) 2015年 Havi. All rights reserved.
//

#import "DiagnoseReportTableViewCell.h"

@interface DiagnoseReportTableViewCell ()
{
    UILabel *reportTimeLabel;
    UILabel *reportResultLabel;
    UILabel *reportTypeLabel;
    UILabel *reportNumLabel;
}
@end

@implementation DiagnoseReportTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *timeTitleLabel = [[UILabel alloc]init];
        timeTitleLabel.dk_textColorPicker = kTextColorPicker;
        timeTitleLabel.text = @"时间:";
        timeTitleLabel.font = [UIFont systemFontOfSize:17];
        [self addSubview:timeTitleLabel];
        [timeTitleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(5);
            make.height.equalTo(@30);
            make.width.equalTo(@40);
        }];
        //
        reportTimeLabel = [[UILabel alloc]init];
        reportTimeLabel.dk_textColorPicker = kTextColorPicker;
        reportTimeLabel.font = [UIFont systemFontOfSize:17];
        reportTimeLabel.text = @"23时11分";
        [self addSubview:reportTimeLabel];
        [reportTimeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(timeTitleLabel.mas_centerY);
            make.left.equalTo(timeTitleLabel.mas_right);
            make.right.equalTo(self.mas_right).offset(-10);
            make.height.equalTo(@30);
        }];
        //
        reportTypeLabel = [[UILabel alloc]init];
        reportTypeLabel.dk_textColorPicker = kTextColorPicker;
        reportTypeLabel.text = @"心率:";
        reportTypeLabel.font = [UIFont systemFontOfSize:17];
        [self addSubview:reportTypeLabel];
        [reportTypeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(reportTimeLabel.mas_bottom).offset(10);
            make.height.equalTo(@30);
            make.width.equalTo(@40);
        }];
        //
        reportNumLabel = [[UILabel alloc]init];
        reportNumLabel.dk_textColorPicker = kTextColorPicker;
        reportNumLabel.font = [UIFont systemFontOfSize:17];
        reportNumLabel.text = @"50次/分钟";
        [self addSubview:reportNumLabel];
        [reportNumLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(reportTypeLabel.mas_right);
            make.centerY.equalTo(reportTypeLabel.mas_centerY);
            make.height.equalTo(@30);
        }];
        //
        reportResultLabel = [[UILabel alloc]init];
        reportResultLabel.dk_textColorPicker = kTextColorPicker;
        reportResultLabel.font = [UIFont systemFontOfSize:17];
        reportResultLabel.text = @"严重异常";
        reportResultLabel.textColor = [UIColor colorWithRed:0.984f green:0.549f blue:0.463f alpha:1.00f];
        [self addSubview:reportResultLabel];
        [reportResultLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(reportNumLabel.mas_right);
            make.centerY.equalTo(reportNumLabel.mas_centerY);
            make.height.equalTo(@30);
            make.right.equalTo(self.mas_right).offset(-10);
            make.width.equalTo(reportNumLabel.mas_width);
        }];        
    }
    return self;
}

- (void)layoutSubviews
{
    reportTimeLabel.text = self.reportTimeString;
    reportTypeLabel.text = self.reportTypeString;
    reportNumLabel.text = self.reportNumString;
    reportResultLabel.text = self.reportResultString;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
