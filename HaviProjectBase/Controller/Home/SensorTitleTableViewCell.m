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
    UILabel *cellDataLabel;
    UILabel *cellDataSub;
}
@end

@implementation SensorTitleTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //
        cellDataLabel = [[UILabel alloc]init];
        cellDataLabel.font = [UIFont systemFontOfSize:30];
        [self addSubview:cellDataLabel];
        [cellDataLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(30);
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(self.mas_height);

        }];
        cellDataSub = [[UILabel alloc]init];
        [self addSubview:cellDataSub];
        cellDataSub.text = @"次/分";
        cellDataSub.textColor = [UIColor whiteColor];
        [cellDataSub makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cellDataLabel.mas_right).offset(0);
            make.bottom.equalTo(cellDataLabel.mas_baseline).offset(0);
        }];
        cellDataSub.font = [UIFont systemFontOfSize:15];
        cellDataLabel.textColor = [UIColor whiteColor];
        cellDataLabel.text = @"--";
                
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
            if ([model.averageHeartRate intValue]==0) {
                cellDataLabel.text = @"--";
            }else{
            
                cellDataLabel.text = [NSString stringWithFormat:@"%d",[model.averageHeartRate intValue]];
            }
            break;
        }
        case 1:{
            cellDataLabel.text = [NSString stringWithFormat:@"%d",[model.averageRespiratoryRate intValue]];
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
