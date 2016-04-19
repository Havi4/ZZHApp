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
    UIView *lineView;
}
@end

@implementation ReportTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        titleLabel = [[UILabel alloc]init];
        [self addSubview:titleLabel];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.dk_textColorPicker = kTextColorPicker;
        titleLabel.font = [UIFont systemFontOfSize:17];
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
        dataLabel.font = [UIFont systemFontOfSize:17];
        dataLabel.dk_textColorPicker = kTextColorPicker;
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
    if (indexPath.section == 1) {
        NSArray *arr = obj;
        titleLabel.text = [arr objectAtIndex:0];
        dataLabel.text = [arr objectAtIndex:1];
    }else if (indexPath.section == 2){
        SleepQualityModel *model = objInfo;
        switch ([obj intValue]) {
            case ReportViewWeek:
                titleLabel.text = @"周平均睡眠时间";
                break;
            case ReportViewMonth:
                titleLabel.text = @"月平均睡眠时间";
                break;
            case ReportViewQuater:
                titleLabel.text = @"季平均睡眠时间";
                break;
                
            default:
                break;
        }
        
        [SleepModelChange changeSleepDuration:model callBack:^(id callBack) {
            dataLabel.text = callBack;
        }];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dk_backgroundColorPicker = DKColorWithColors([UIColor colorWithRed:0.059f green:0.141f blue:0.231f alpha:1.00f], [UIColor colorWithRed:0.475f green:0.686f blue:0.820f alpha:1.00f]);
}

@end
