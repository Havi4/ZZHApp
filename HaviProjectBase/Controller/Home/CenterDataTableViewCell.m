//
//  CenterViewTableViewCell.m
//  SleepRecoding
//
//  Created by Havi on 15/8/4.
//  Copyright (c) 2015年 Havi. All rights reserved.
//

#import "CenterDataTableViewCell.h"

@interface CenterDataTableViewCell ()
{
    UILabel *cellNameLabel;
    YYAnimatedImageView *cellImage;
    UILabel *cellDataLabel;
}
@end

@implementation CenterDataTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        cellNameLabel = [[UILabel alloc]init];
        cellNameLabel.text = @"心率";
        cellNameLabel.dk_textColorPicker = kTextColorPicker;
        [self addSubview:cellNameLabel];
        [cellNameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.mas_height);
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).offset(30);
        }];
        
        cellImage = [[YYAnimatedImageView alloc]init];
        [self addSubview:cellImage];
        [cellImage makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cellNameLabel.mas_right).offset(30);
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(cellImage.mas_width);
            make.height.equalTo(@30);
        }];
        
        cellDataLabel = [[UILabel alloc]init];
        cellDataLabel.dk_textColorPicker = kTextColorPicker;
        cellDataLabel.text = @"5次/天";
        [self addSubview:cellDataLabel];
        [cellDataLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-30);
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(self.mas_height);
        }];
        
        UIImageView *imageLine = [[UIImageView alloc]init];
        imageLine.dk_imagePicker = DKImageWithNames(@"cell_seperator_0", @"cell_seperator_1");
        imageLine.tag = 100;
        [self addSubview:imageLine];
        [imageLine makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(5);
            make.right.equalTo(self.mas_right).offset(-5);
            make.bottom.equalTo(self.mas_bottom).offset(-0.5);
            make.height.equalTo(@0.5);
        }];
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.145f green:0.733f blue:0.957f alpha:0.15f];
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
    NSDictionary *dic = obj;
    SleepQualityModel *model = objInfo;
    cellNameLabel.text = [dic objectForKey:@"cellTitle"];
    YYImage *image = [YYImage imageNamed:[NSString stringWithFormat:@"%@%d",[dic objectForKey:@"cellIcon"],0]];
    YYImage *image2 = [YYImage imageNamed:[NSString stringWithFormat:@"%@%d",[dic objectForKey:@"cellIcon"],1]];
    cellImage.dk_imagePicker = DKImageWithImages(image,image2);
    switch (indexPath.row) {
        case 0:{
            cellDataLabel.text = [NSString stringWithFormat:@"%d次/分",[model.averageHeartRate intValue]];
            break;
        }
        case 1:{
            cellDataLabel.text = [NSString stringWithFormat:@"%d次/分",[model.averageRespiratoryRate intValue]];
            break;
        }
        case 2:{
            cellDataLabel.text = [NSString stringWithFormat:@"%d次/天",[model.outOfBedTimes intValue]];
            break;
        }
        case 3:{
            cellDataLabel.text = [NSString stringWithFormat:@"%d次/天",[model.bodyMovementTimes intValue]];
            break;
        }
            
        default:
            break;
    }
    cell.backgroundColor = [UIColor clearColor];
}

+ (CGFloat)getCellHeightWithCustomObj:(id)obj
                            indexPath:(NSIndexPath *)indexPath
{
    return 44;
}

@end
