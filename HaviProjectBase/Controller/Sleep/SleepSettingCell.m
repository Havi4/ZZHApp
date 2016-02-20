//
//  SleepSettingCell.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/20.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "SleepSettingCell.h"

@interface SleepSettingCell ()

@property (nonatomic, strong) UIButton *cellInfoButton;
@property (nonatomic, strong) UISwitch *cellInfoSwitch;

@end

@implementation SleepSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cellInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cellInfoButton setTitle:@"测试" forState:UIControlStateNormal];
        [_cellInfoButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_cellInfoButton addTarget:self action:@selector(cellButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
        [_cellInfoButton setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateSelected];
        [_cellInfoButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:_cellInfoButton];
        
        _cellInfoSwitch = [[UISwitch alloc]init];
        [_cellInfoSwitch addTarget:self action:@selector(cellSwitchTaped:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_cellInfoSwitch];
        
        [_cellInfoButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.centerY.equalTo(self);
            make.height.equalTo(self);
        }];
        
        [_cellInfoSwitch makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15);
            make.centerY.equalTo(self);
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
    if (indexPath.section < 2) {
        _cellInfoSwitch.hidden = YES;
    }
    if (objInfo) {
        UserInfoDetailModel *userInfo = objInfo;
        switch (indexPath.section) {
            case 0:
            {
                NSString *cellString = userInfo.nUserInfo.sleepStartTime;
                [_cellInfoButton setTitle:cellString forState:UIControlStateNormal];
                break;
            }
            case 1:{
                NSString *cellString = userInfo.nUserInfo.sleepEndTime;
                [_cellInfoButton setTitle:cellString forState:UIControlStateNormal];
                break;
            }
            case 2:{
//                NSString *cellString = userInfo.nUserInfo.sleepStartTime;
//                [_cellInfoButton setTitle:cellString forState:UIControlStateNormal];
                break;
            }
            case 3:{
                int time = [userInfo.nUserInfo.alarmTimeSleepTooLong intValue];
                if (time > 60) {
                    NSString *cellString = [NSString stringWithFormat:@"久睡%d小时%d分钟警告",time/60,time%60];
                    [_cellInfoButton setTitle:cellString forState:UIControlStateNormal];
                    
                }else{
                    NSString *cellString = [NSString stringWithFormat:@"久睡%d分钟警告",time];
                    [_cellInfoButton setTitle:cellString forState:UIControlStateNormal];
                }
                break;
            }
            case 4:{
                int time = [userInfo.nUserInfo.alarmTimeOutOfBed intValue];
                if (time > 60) {
                    NSString *cellString = [NSString stringWithFormat:@"离床%d分钟警告",time/60];
                    [_cellInfoButton setTitle:cellString forState:UIControlStateNormal];

                }else{
                    NSString *cellString = [NSString stringWithFormat:@"离床%d秒警告",time];
                    [_cellInfoButton setTitle:cellString forState:UIControlStateNormal];
                }
                break;
            }
                
            default:
                break;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
}

- (void)cellButtonTaped:(UIButton *)button
{
    self.cellInfoButtonTaped(self,button);
}

- (void)cellSwitchTaped:(UISwitch *)sender
{
    DeBugLog(@"switch");
}

@end
