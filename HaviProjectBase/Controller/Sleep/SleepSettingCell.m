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
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation SleepSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cellInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cellInfoButton setTitle:@"" forState:UIControlStateNormal];
        [_cellInfoButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
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
    self.indexPath = indexPath;
    if (objInfo) {
        
        UserInfoDetailModel *userInfo = objInfo;
        switch (indexPath.section) {
            case 0:
            {
                NSString *cellString = userInfo.nUserInfo.sleepStartTime.length == 0 ? @"18:00":userInfo.nUserInfo.sleepStartTime;
                [_cellInfoButton setTitle:cellString forState:UIControlStateNormal];
                break;
            }
            case 1:{
                NSString *cellString = userInfo.nUserInfo.sleepEndTime.length == 0?@"06:00":userInfo.nUserInfo.sleepEndTime;
                [_cellInfoButton setTitle:cellString forState:UIControlStateNormal];
                break;
            }
            case 2:{
                [[NSUserDefaults standardUserDefaults]registerDefaults:@{kAlarmStatusValue:@"False"}];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [[NSUserDefaults standardUserDefaults]registerDefaults:@{kAlarmTimeValue:@"08:00"}];
                [[NSUserDefaults standardUserDefaults]synchronize];
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:kAlarmStatusValue]isEqualToString:@"False"]) {
                    _cellInfoSwitch.on = NO;
                    _cellInfoButton.userInteractionEnabled = NO;
                }else{
                    _cellInfoSwitch.on = YES;
                    _cellInfoButton.userInteractionEnabled = YES;
                }
                NSString *time;
                if ([[[NSUserDefaults standardUserDefaults]objectForKey:kAlarmTimeValue]isKindOfClass:[NSString class]]) {
                    time = [[NSUserDefaults standardUserDefaults]objectForKey:kAlarmTimeValue];
                }else{
                    NSDate *date = [[NSUserDefaults standardUserDefaults]objectForKey:kAlarmTimeValue];
                    NSString *hour = date.hour > 10 ? [NSString stringWithFormat:@"%d",(int)date.hour] : [NSString stringWithFormat:@"0%d",(int)date.hour];
                    NSString *minute = date.minute > 10 ? [NSString stringWithFormat:@"%d",(int)date.minute] : [NSString stringWithFormat:@"0%d",(int)date.minute];
                    time = [NSString stringWithFormat:@"%@:%@",hour,minute];
                }
                [_cellInfoButton setTitle:time forState:UIControlStateNormal];
                break;
            }
            case 3:{
                if ([userInfo.nUserInfo.isTimeoutAlarmSleepTooLong isEqualToString:@"True"]) {
                    [_cellInfoSwitch setOn:YES];
                    _cellInfoButton.userInteractionEnabled = YES;
                }else{
                    [_cellInfoSwitch setOn:NO];
                    _cellInfoButton.userInteractionEnabled = NO;
                }
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
                if ([userInfo.nUserInfo.isTimeoutAlarmOutOfBed isEqualToString:@"True"]) {
                    [_cellInfoSwitch setOn:YES];
                    _cellInfoButton.userInteractionEnabled = YES;
                }else{
                    [_cellInfoSwitch setOn:NO];
                    _cellInfoButton.userInteractionEnabled = NO;
                }
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
    if (self.indexPath.section == 2) {
        if (sender.on) {
            _cellInfoButton.userInteractionEnabled = YES;
        }else{
            _cellInfoButton.userInteractionEnabled = NO;
        }
    }
    self.cellInfoSwitchTaped(self,sender);
}

@end
