//
//  NewDataShowChartTableViewCell.m
//  SleepRecoding
//
//  Created by Havi on 15/9/18.
//  Copyright (c) 2015年 Havi. All rights reserved.
//

#import "SensorTitleTableViewCell.h"

@interface SensorTitleTableViewCell ()
{
    UIImageView *cellImage;
    UILabel *cellDataLabel;
}
@end

@implementation SensorTitleTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        cellImage = [[UIImageView alloc]init];
        [self addSubview:cellImage];
        [cellImage makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(25);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@40);
            make.height.equalTo(@40);
        }];
        cellImage.layer.cornerRadius = 10;
        //
        cellDataLabel = [[UILabel alloc]init];
        [self addSubview:cellDataLabel];
        [cellDataLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cellImage.mas_right).offset(20);
            make.centerY.equalTo(cellImage.mas_centerY);
        }];
        cellDataLabel.dk_textColorPicker = kTextColorPicker;
        cellDataLabel.text = @"0次/分";
        cellDataLabel.font = [UIFont systemFontOfSize:15];
                
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
    SleepQualityModel *model = objInfo;
    switch ([type intValue]) {
        case 0:
        {
            cellImage.dk_imagePicker = DKImageWithNames(@"icon_heart_rate_0", @"icon_heart_rate_1");
            cellDataLabel.text = [NSString stringWithFormat:@"%d次/分",[model.averageHeartRate intValue]];
            break;
        }
        case 1:{
            cellDataLabel.text = [NSString stringWithFormat:@"%d次/分",[model.averageRespiratoryRate intValue]];
            cellImage.dk_imagePicker = DKImageWithNames(@"icon_breathe_0", @"icon_breathe_1");
            break;
        }
            
        default:
            break;
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

+ (CGFloat)getCellHeightWithCustomObj:(id)obj
                            indexPath:(NSIndexPath *)indexPath
{
    return 44;
}


@end
