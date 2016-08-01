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
    
    UIButton *leftBackView;
    UIButton *rightBackView;
    UILabel *leftTitleLabel;
    UILabel *leftNumLabel;
    UILabel *leftSubLabel;
    YYAnimatedImageView *leftImage;
    
    UILabel *rightTitleLabel;
    UILabel *rightNumLabel;
    UILabel *rightSubLabel;
    YYAnimatedImageView *rightImage;
    UIImageView *triage1;
    UIImageView *triage2;
}
@end

@implementation CenterDataTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        leftBackView = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBackView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.4];
        [self addSubview:leftBackView];
        rightBackView = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBackView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.4];;
        [self addSubview:rightBackView];
        triage1 = [[UIImageView alloc]init];
        triage2 = [[UIImageView alloc]init];
        [leftBackView addSubview:triage1];
        [rightBackView addSubview:triage2];
        triage1.image = [UIImage imageNamed:@"triagle"];
        triage2.image = [UIImage imageNamed:@"triagle"];
        
        leftTitleLabel = [[UILabel alloc]init];
        leftTitleLabel.textColor = [UIColor whiteColor];
        leftTitleLabel.font = [UIFont systemFontOfSize:16];
        [leftBackView addSubview:leftTitleLabel];
        
        leftNumLabel = [[UILabel alloc]init];
        leftNumLabel.textColor = [UIColor whiteColor];
        leftNumLabel.font = [UIFont systemFontOfSize:30];
        [leftBackView addSubview:leftNumLabel];
        
        leftSubLabel = [[UILabel alloc]init];
        leftSubLabel.textColor = [UIColor whiteColor];
        leftSubLabel.font = [UIFont systemFontOfSize:12];
        [leftBackView addSubview:leftSubLabel];
        
        leftImage = [[YYAnimatedImageView alloc]init];
        [leftBackView addSubview:leftImage];
        
        rightTitleLabel = [[UILabel alloc]init];
        rightTitleLabel.textColor = [UIColor whiteColor];
        rightTitleLabel.font = [UIFont systemFontOfSize:16];

        [rightBackView addSubview:rightTitleLabel];
        
        rightNumLabel = [[UILabel alloc]init];
        rightNumLabel.textColor = [UIColor whiteColor];
        rightNumLabel.font = [UIFont systemFontOfSize:30];

        [rightBackView addSubview:rightNumLabel];
        
        rightSubLabel = [[UILabel alloc]init];
        rightSubLabel.textColor = [UIColor whiteColor];
        rightSubLabel.font = [UIFont systemFontOfSize:12];

        [rightBackView addSubview:rightSubLabel];
        rightImage = [[YYAnimatedImageView alloc]init];
        [rightBackView addSubview:rightImage];
        [leftBackView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(0);
            make.height.equalTo(self.mas_height);
            make.width.equalTo(self.mas_width).multipliedBy(0.5);
        }];
        
        [triage1 makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(leftBackView.mas_right);
            make.top.equalTo(leftBackView.mas_top).offset(-0.1);
            make.height.width.equalTo(@12);
        }];
        
        [triage2 makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(rightBackView.mas_right);
            make.top.equalTo(rightBackView.mas_top).offset(-0.1);
            make.height.width.equalTo(@12);
        }];
        
        [leftImage makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftBackView.mas_left).offset(16);
            make.centerY.equalTo(leftBackView.mas_centerY);
            make.height.equalTo(@35);
            make.width.equalTo(@35);
        }];
        
        [leftTitleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftImage.mas_right).offset(5);
            make.top.equalTo(leftBackView.mas_top);
            make.height.equalTo(@30);
            
        
        }];
        [leftNumLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftImage.mas_right).offset(5);
            make.top.equalTo(leftBackView.mas_top).offset(28);
            make.height.equalTo(@30);
            make.width.equalTo(@60);
        }];
        [leftSubLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftNumLabel.mas_right).offset(0);
            make.bottom.equalTo(leftBackView.mas_bottom).offset(-5);
        }];
        
        [rightBackView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftBackView.mas_right).offset(0);
            make.height.equalTo(self.mas_height);
            make.width.equalTo(self.mas_width).multipliedBy(0.5);
        }];
        
        [rightImage makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(rightBackView.mas_left).offset(16);
            make.centerY.equalTo(rightBackView.mas_centerY);
            make.height.equalTo(@35);
            make.width.equalTo(@30);
        }];
        
        [rightTitleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(rightImage.mas_right).offset(5);
            make.top.equalTo(rightBackView.mas_top);
            make.height.equalTo(@30);
            
            
        }];
        [rightNumLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(rightImage.mas_right).offset(5);
            make.top.equalTo(rightBackView.mas_top).offset(28);
            make.height.equalTo(@30);
            make.width.equalTo(@60);
        }];
        [rightSubLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(rightNumLabel.mas_right).offset(0);
            make.bottom.equalTo(rightBackView.mas_bottom).offset(-5);
        }];
        UIImageView *imageLine1 = [[UIImageView alloc]init];
        imageLine1.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
        imageLine1.tag = 100;
        [self addSubview:imageLine1];
        [imageLine1 makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX).offset(0);
            make.top.equalTo(self.mas_top).offset(0);
            make.bottom.equalTo(self.mas_bottom).offset(0);
            make.width.equalTo(@0.5);
        }];
        
        UIImageView *imageLine = [[UIImageView alloc]init];
        imageLine.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
        imageLine.tag = 101;
        [self addSubview:imageLine];
        [imageLine makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
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
    NSArray *dic = obj;
    NSDictionary *leftDic = dic[0];
    NSDictionary *rightDic = dic[1];
    SleepQualityModel *model = objInfo;
    YYImage *image = [YYImage imageNamed:[NSString stringWithFormat:@"%@",[leftDic objectForKey:@"cellIcon"]]];
    YYImage *image1 = [YYImage imageNamed:[NSString stringWithFormat:@"%@",[rightDic objectForKey:@"cellIcon"]]];
    leftImage.image = image;
    rightImage.image = image1;
    leftTitleLabel.text = [NSString stringWithFormat:@"%@",[leftDic objectForKey:@"cellTitle"]];
    leftNumLabel.text = @"100";
    leftSubLabel.text = [NSString stringWithFormat:@"%@",[leftDic objectForKey:@"cellSub"]];
    rightTitleLabel.text = [NSString stringWithFormat:@"%@",[rightDic objectForKey:@"cellTitle"]];
    rightNumLabel.text = @"100";
    rightSubLabel.text = [NSString stringWithFormat:@"%@",[leftDic objectForKey:@"cellSub"]];
    switch (indexPath.row) {
        case 0:{
            cellDataLabel.text = [NSString stringWithFormat:@"%d次/分",[model.averageHeartRate intValue]];
            break;
        }
        case 1:{
            cellDataLabel.text = [NSString stringWithFormat:@"%d次/分",[model.averageRespiratoryRate intValue]];
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
