//
//  CenterSubTableViewCell.m
//  HaviProjectBase
//
//  Created by Havi on 16/8/1.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "CenterSubTableViewCell.h"

@interface CenterSubTableViewCell ()

@property (nonatomic, strong) UIImageView *bedImageView;
@property (nonatomic, strong) UIImageView *longSleepView;
@property (nonatomic, strong) UIImageView *deepSleepView;
@property (nonatomic, strong) UIImageView *lightSleepView;

@property (nonatomic, strong) UILabel *longSleepTitle;
@property (nonatomic, strong) UILabel *deepSleepTitle;
@property (nonatomic, strong) UILabel *lightSleepTitle;

@property (nonatomic, strong) UILabel *longSleepNum;
@property (nonatomic, strong) UILabel *deepSleepNum;
@property (nonatomic, strong) UILabel *lightSleepNum;

@property (nonatomic, strong) UIImageView *statusImage;

@end

@implementation CenterSubTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _bedImageView = [[UIImageView alloc]init];
        _bedImageView.image = [UIImage imageNamed:@"bed_no_people@3x"];
        [self addSubview:_bedImageView];
        
        _statusImage = [[UIImageView alloc]init];
        _statusImage.image = [UIImage imageNamed:@"tuoji"];
        [_bedImageView addSubview:_statusImage];
        _statusImage.hidden = YES;
        
        _longSleepView = [[UIImageView alloc]init];
        _longSleepView.image = [UIImage imageNamed:@"long_sleep@3x"];
        [self addSubview:_longSleepView];
        
        _deepSleepView = [[UIImageView alloc]init];
        _deepSleepView.image = [UIImage imageNamed:@"deep_sleep@3x"];

        [self addSubview:_deepSleepView];
        
        _lightSleepView = [[UIImageView alloc]init];
        _lightSleepView.image = [UIImage imageNamed:@"light_sleep@3x"];
        [self addSubview:_lightSleepView];
        
        _longSleepTitle = [[UILabel alloc]init];
        _longSleepTitle.font = [UIFont systemFontOfSize:14];
        _longSleepTitle.text = @"睡眠时长";
        _longSleepTitle.textAlignment = NSTextAlignmentCenter;
        _longSleepTitle.textColor  = [UIColor whiteColor];
        [self addSubview:_longSleepTitle];
        
        _deepSleepTitle = [[UILabel alloc]init];
        _deepSleepTitle.text = @"深睡眠";
        _deepSleepTitle.font = [UIFont systemFontOfSize:14];
        _deepSleepTitle.textAlignment = NSTextAlignmentCenter;
        _deepSleepTitle.textColor = [UIColor whiteColor];
        [self addSubview:_deepSleepTitle];
        
        _lightSleepTitle = [[UILabel alloc]init];
        _lightSleepTitle.text = @"浅睡眠";
        _lightSleepTitle.font = [UIFont systemFontOfSize:14];
        _lightSleepTitle.textAlignment = NSTextAlignmentCenter;
        _lightSleepTitle.textColor = [UIColor whiteColor];
        [self addSubview:_lightSleepTitle];
        
        _longSleepNum = [[UILabel alloc]init];
        _longSleepNum.textColor = [UIColor whiteColor];
        _longSleepNum.text = @"--小时--分";
        _longSleepNum.textAlignment = NSTextAlignmentCenter;
        _longSleepNum.font = [UIFont systemFontOfSize:14];
        [self addSubview:_longSleepNum];
        
        _deepSleepNum = [[UILabel alloc]init];
        _deepSleepNum.textAlignment = NSTextAlignmentCenter;
        _deepSleepNum.textColor = [UIColor whiteColor];
        _deepSleepNum.text = @"--小时--分";
        _deepSleepNum.font = [UIFont systemFontOfSize:14];
        [self addSubview:_deepSleepNum];
        
        _lightSleepNum = [[UILabel alloc]init];
        _lightSleepNum.textColor = [UIColor whiteColor];
        _lightSleepNum.textAlignment = NSTextAlignmentCenter;
        _lightSleepNum.text = @"--小时--分";
        _lightSleepNum.font = [UIFont systemFontOfSize:14];
        [self addSubview:_lightSleepNum];
        
        [_bedImageView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).offset(25);
            make.height.with.equalTo(@40);
        }];
        
        [_statusImage makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_bedImageView.mas_centerY);
            make.centerX.equalTo(_bedImageView.mas_centerX);
            make.width.equalTo(@42);
            make.height.equalTo(@36);
        }];
        
        [_longSleepView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY).offset(-35);
            make.left.equalTo(_bedImageView.mas_right).offset(16);
            make.width.height.equalTo(@17);
        }];
        [_deepSleepView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(_bedImageView.mas_right).offset(16);
            make.width.height.equalTo(@15);
        }];
        
        [_lightSleepView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY).offset(35);
            make.left.equalTo(_bedImageView.mas_right).offset(16);
            make.width.height.equalTo(@15);
        }];
        
        [_longSleepTitle makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_longSleepView.mas_centerY);
            make.left.equalTo(_longSleepView.mas_right).offset(16);
            make.width.equalTo(@65);
        }];
        
        [_deepSleepTitle makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_deepSleepView.mas_centerY);
            make.left.equalTo(_deepSleepView.mas_right).offset(16);
            make.width.equalTo(@65);
        }];
        
        [_lightSleepTitle makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_lightSleepView.mas_centerY);
            make.left.equalTo(_lightSleepView.mas_right).offset(16);
            make.width.equalTo(@65);
        }];
        
        [_longSleepNum makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.longSleepTitle.mas_right).offset(16);
            make.centerY.equalTo(self.longSleepTitle.mas_centerY);
            make.width.equalTo(@100);
        }];
        
        [_deepSleepNum makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.deepSleepTitle.mas_right).offset(16);
            make.centerY.equalTo(self.deepSleepTitle.mas_centerY);
            make.width.equalTo(@100);
        }];
        
        [_lightSleepNum makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lightSleepTitle.mas_right).offset(16);
            make.centerY.equalTo(self.lightSleepTitle.mas_centerY);
            make.width.equalTo(@100);
        }];
        
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.145f green:0.733f blue:0.957f alpha:0.15f];
        self.backgroundColor = [UIColor clearColor];
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
    
    SleepQualityModel *model = (SleepQualityModel*)objInfo;
    [SleepModelChange changeSleepDuration:model callBack:^(id callBack) {
        _longSleepNum.text = [NSString stringWithFormat:@"%@",callBack];
    }];
    SensorInfoModel *sensor = (SensorInfoModel *)obj;
    if (!sensor) {
        return;
    }
    if ([sensor.sensorDetail.isAnybodyOnBed isEqualToString:@"False"]) {
        if (gloableActiveDevice.detailDeviceList.count == 0) {
            _bedImageView.image = [UIImage imageNamed:@"bed_no_sigle@3x"];
        }else if (gloableActiveDevice.detailDeviceList.count == 1){
            _bedImageView.image = [UIImage imageNamed:@"bed_no_sigle@3x"];
        }else if (gloableActiveDevice.detailDeviceList.count == 2){
            _bedImageView.image = [UIImage imageNamed:@"bed_no_people@3x"];
        }

    }else{
        if (gloableActiveDevice.detailDeviceList.count == 0) {
            _bedImageView.image = [UIImage imageNamed:@"single@3x"];
        }else if (gloableActiveDevice.detailDeviceList.count == 1){
            _bedImageView.image = [UIImage imageNamed:@"single@3x"];
        }else if (gloableActiveDevice.detailDeviceList.count == 2){
            _bedImageView.image = [UIImage imageNamed:@"two@3x"];
        }
    }
    if (sensor.sensorDetail.activationStatusCode == 0) {
        self.statusImage.hidden = NO;
        self.statusImage.image = [UIImage imageNamed:@"lixian"];
    }else if (sensor.sensorDetail.activationStatusCode == -1){
        self.statusImage.hidden = NO;
        self.statusImage.image = [UIImage imageNamed:@"tuoji"];
    }else{
        self.statusImage.hidden = YES;
        self.statusImage.image = [UIImage imageNamed:@"tuoji"];
    }
    
    cell.backgroundColor = [UIColor clearColor];
}

+ (CGFloat)getCellHeightWithCustomObj:(id)obj
                            indexPath:(NSIndexPath *)indexPath
{
    return 44;
}

@end
