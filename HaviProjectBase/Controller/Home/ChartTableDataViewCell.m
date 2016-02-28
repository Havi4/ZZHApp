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
    UIImageView *cellImage;
    UIImageView *cellImage1;
    UILabel *leftTitleLabel;
    UILabel *rightTitleLabel;
    UILabel *leftSubTitleLabel;
    UILabel *righSubtTitleLabel;
}
@end

@implementation ChartTableDataViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        cellImage = [[UIImageView alloc]init];
        [self addSubview:cellImage];
        [cellImage makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.width.equalTo(@2);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
        cellImage.image = [UIImage imageNamed:[NSString stringWithFormat: @"ic_line_%d",selectedThemeIndex]];
        cellImage1 = [[UIImageView alloc]init];
        [self addSubview:cellImage1];
        [cellImage1 makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@14);
            make.height.equalTo(@14);
        }];
        cellImage1.image = [UIImage imageNamed:[NSString stringWithFormat: @"ic_dot_%d",selectedThemeIndex]];
        //
        leftTitleLabel = [[UILabel alloc]init];
        [self addSubview:leftTitleLabel];
        leftTitleLabel.textAlignment = NSTextAlignmentRight;
        leftTitleLabel.text = @"9月1日";
        leftTitleLabel.font = [UIFont systemFontOfSize:15];
        leftTitleLabel.textColor = selectedThemeIndex == 0?[UIColor colorWithRed:0.000f green:0.859f blue:0.573f alpha:1.00f]:[UIColor whiteColor];
        [leftTitleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(cellImage1.mas_left).offset(-10);
            make.top.equalTo(self).offset(5);
            
            make.height.equalTo(@20);
            
        }];
        leftSubTitleLabel = [[UILabel alloc]init];
        [self addSubview:leftSubTitleLabel];
        leftSubTitleLabel.textColor = selectedThemeIndex == 0?[UIColor colorWithRed:0.000f green:0.859f blue:0.573f alpha:1.00f]:[UIColor whiteColor];
        leftSubTitleLabel.font = [UIFont systemFontOfSize:17];
        leftSubTitleLabel.textAlignment = NSTextAlignmentRight;
        leftSubTitleLabel.text = @"22:12";
        [leftSubTitleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(cellImage1.mas_left).offset(-10);
            make.top.equalTo(leftTitleLabel.mas_bottom);
            make.height.equalTo(@30);
            
        }];
        
        //
        rightTitleLabel = [[UILabel alloc]init];
        [self addSubview:rightTitleLabel];
        rightTitleLabel.dk_textColorPicker = DKColorWithColors([UIColor colorWithRed:0.000f green:0.859f blue:0.573f alpha:1.00f], [UIColor whiteColor]);
        rightTitleLabel.textAlignment = NSTextAlignmentLeft;
        rightTitleLabel.text = @"9月1日";
        rightTitleLabel.font = [UIFont systemFontOfSize:15];
        [rightTitleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cellImage1.mas_right).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
            make.top.equalTo(self).offset(5);
            
            make.height.equalTo(@20);
            
        }];
        righSubtTitleLabel = [[UILabel alloc]init];
        [self addSubview:righSubtTitleLabel];
        righSubtTitleLabel.dk_textColorPicker = DKColorWithColors([UIColor colorWithRed:0.000f green:0.859f blue:0.573f alpha:1.00f], [UIColor whiteColor]);
        righSubtTitleLabel.font = [UIFont systemFontOfSize:17];
        righSubtTitleLabel.textAlignment = NSTextAlignmentLeft;
        righSubtTitleLabel.text = @"22:12";
        [righSubtTitleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cellImage1.mas_right).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
            make.top.equalTo(leftTitleLabel.mas_bottom);
            make.height.equalTo(@30);
            
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
    PropertyData *dataModel = obj;
    NSString *cellString = dataModel.propertyDate;
    
    NSString *month = [NSString stringWithFormat:@"%@月%@日",[cellString substringWithRange:NSMakeRange(5, 2)],[cellString substringWithRange:NSMakeRange(8, 2)]];
    NSString *time = [NSString stringWithFormat:@"%@",[cellString substringWithRange:NSMakeRange(11, 8)]];

    if (indexPath.row%2==0) {
        leftTitleLabel.text = month;
        leftSubTitleLabel.text = time;
        rightTitleLabel.text = @"";
        righSubtTitleLabel.text = @"";
    }else{
        leftTitleLabel.text = @"";
        leftSubTitleLabel.text = @"";
        rightTitleLabel.text = month;
        righSubtTitleLabel.text = time;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
