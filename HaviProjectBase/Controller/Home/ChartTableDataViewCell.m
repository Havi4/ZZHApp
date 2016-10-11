//
//  DataTableViewCell.m
//  SleepRecoding
//
//  Created by Havi on 15/9/6.
//  Copyright (c) 2015年 Havi. All rights reserved.
//

#import "ChartTableDataViewCell.h"

@interface ChartTableDataViewCell ()
{
    UILabel *titleLabel;
    UILabel *dataLabel;
    //    UIView *lineViewBottom;
    //    UIView *lineView;
    UIImageView *backImageView;
    UILabel *dataSub;
}
@end

@implementation ChartTableDataViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        backImageView = [[UIImageView alloc]init];
        backImageView.image = [UIImage imageNamed:@"heart_cell_back@3x"];
        [self addSubview:backImageView];
        [backImageView makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(self.mas_height).multipliedBy(0.75);
            make.width.equalTo(self.mas_width).multipliedBy(0.8);
        }];
        
        titleLabel = [[UILabel alloc]init];
        [backImageView addSubview:titleLabel];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.dk_textColorPicker = kTextColorPicker;
        titleLabel.font = [UIFont systemFontOfSize:16];
        [titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(backImageView.mas_centerY);
            make.left.equalTo(backImageView.mas_left).offset(10);
            make.height.equalTo(self);
        }];
        
        
        //        lineView = [[UIView alloc]init];
        //        lineView.dk_backgroundColorPicker = DKColorWithColors([UIColor colorWithRed:0.161f green:0.251f blue:0.365f alpha:1.00f], [UIColor colorWithRed:0.349f green:0.608f blue:0.780f alpha:1.00f]);
        //        [self addSubview:lineView];
        //        [lineView makeConstraints:^(MASConstraintMaker *make) {
        //            make.centerX.equalTo(self);
        //            make.height.equalTo(@60);
        //            make.width.equalTo(@0.5);
        //        }];
        //
        dataLabel = [[UILabel alloc]init];
        dataLabel.textAlignment = NSTextAlignmentRight;
        [backImageView addSubview:dataLabel];
        dataLabel.font = [UIFont systemFontOfSize:30];
        
        dataSub = [[UILabel alloc]init];
        dataSub.textColor = [UIColor whiteColor];
        dataSub.font = [UIFont systemFontOfSize:15];
        dataSub.textAlignment = NSTextAlignmentLeft;
        [backImageView addSubview:dataSub];
        dataLabel.dk_textColorPicker = DKColorWithColors([UIColor colorWithRed:0.000f green:0.851f blue:0.573f alpha:1.00f], [UIColor whiteColor]);
        [dataLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(backImageView);
            make.left.equalTo(titleLabel.mas_right).offset(10);
            make.right.equalTo(dataSub.mas_left).offset(0);
            make.width.equalTo(titleLabel.mas_width).multipliedBy(0.5);
        }];
        
        
        [dataSub makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(backImageView.mas_right).offset(-10);
            make.width.equalTo(dataLabel.mas_width);
            make.baseline.equalTo(dataLabel.mas_baseline);
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
    SleepQualityModel *dataModel = obj;
    SensorDataType type = [objInfo intValue];
    if (type == SensorDataLeave) {
        titleLabel.text = @"离床次数";
        if ([dataModel.outOfBedTimes intValue]==0) {
            dataLabel.text = @"--";
        }else{
            dataLabel.text = [NSString stringWithFormat:@"%d",[dataModel.outOfBedTimes intValue]];
        }
        dataSub.text = @"次/天";
    }else{
        titleLabel.text = @"体动次数";
        if ([dataModel.bodyMovementTimes intValue]==0) {
            dataLabel.text = @"--";
        }else{
            dataLabel.text = [NSString stringWithFormat:@"%d",[dataModel.bodyMovementTimes intValue]];
        }
        dataSub.text = @"次/天";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
