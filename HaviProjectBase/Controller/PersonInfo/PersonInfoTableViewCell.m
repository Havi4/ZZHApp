//
//  PersonInfoTableViewCell.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/5.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "PersonInfoTableViewCell.h"
#import "UserInfoDetailModel.h"

@interface PersonInfoTableViewCell ()
{
    UIImageView *_cellInfoIcon;
    UILabel *_cellInfoTitle;
    UILabel *_cellInfoData;
    UIImageView *_cellInfoArrow;
}
@end

@implementation PersonInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cellInfoIcon = [[UIImageView alloc]init];
        [self addSubview:_cellInfoIcon];
        _cellInfoTitle = [[UILabel alloc]init];
        _cellInfoTitle.numberOfLines = 0;
        [self addSubview:_cellInfoTitle];
        _cellInfoArrow = [[UIImageView alloc]init];
        [self addSubview:_cellInfoArrow];
        _cellInfoData = [[UILabel alloc]init];
        [self addSubview:_cellInfoData];
        _cellInfoData.numberOfLines = 0;
        //add contranints
        [_cellInfoIcon makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(@25);
            make.width.equalTo(_cellInfoIcon.mas_height);
        }];
        
        
        [_cellInfoTitle makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_cellInfoIcon.mas_right).offset(10);
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(self);
            make.width.equalTo(@100);
        }];
        
        [_cellInfoData makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_cellInfoTitle.mas_right).offset(5);
            make.right.equalTo(_cellInfoArrow.mas_left).offset(-5);
            make.height.equalTo(self);
        }];
        
        [_cellInfoArrow makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_cellInfoData.mas_right).offset(5);
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right).offset(-15);
            make.width.equalTo(@10);
            make.height.equalTo(@15);
        }];
    }
    return self;
}

- (void)configure:(UITableViewCell *)cell
        customObj:(id)obj
        indexPath:(NSIndexPath *)indexPath
{
    // Rewrite this func in SubClass !
    NSDictionary *dic = obj;
    _cellInfoArrow.image = [UIImage imageNamed:@"person_back_right"];
    _cellInfoIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[dic objectForKey:@"cellIcon"]]];
    _cellInfoTitle.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cellName"]];
    _cellInfoData.text = @"";
    cell.backgroundColor = [UIColor whiteColor];
}

- (void)configure:(UITableViewCell *)cell
        customObj:(id)obj
        indexPath:(NSIndexPath *)indexPath
    withOtherInfo:(id)objInfo
{
    // Rewrite this func in SubClass !
    NSDictionary *dic = obj;
    UserInfoDetailModel *userModel = (UserInfoDetailModel *)objInfo;
    _cellInfoArrow.image = [UIImage imageNamed:@"person_back_right"];
    _cellInfoIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[dic objectForKey:@"cellIcon"]]];
    _cellInfoTitle.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cellName"]];
    NSString *cellDataString = [dic objectForKey:@"cellData"];
    if ([cellDataString isEqualToString:@"userName"]) {
        _cellInfoData.text = [NSString stringWithFormat:@"%@",userModel.nUserInfo.userName];
    }else if ([cellDataString isEqualToString:@"birthday"]) {
        _cellInfoData.text = [NSString stringWithFormat:@"%@",userModel.nUserInfo.birthday];
    }else if ([cellDataString isEqualToString:@"gender"]) {
        _cellInfoData.text = [NSString stringWithFormat:@"%@",userModel.nUserInfo.gender];
    }else if ([cellDataString isEqualToString:@"emergencyContact"]) {
        _cellInfoData.text = [NSString stringWithFormat:@"%@",userModel.nUserInfo.emergencyContact];
    }else if ([cellDataString isEqualToString:@"telephone"]) {
        _cellInfoData.text = [NSString stringWithFormat:@"%@",userModel.nUserInfo.telephone];
    }else if ([cellDataString isEqualToString:@"height"]) {
        _cellInfoData.text = [NSString stringWithFormat:@"%@ CM",userModel.nUserInfo.height];
    }else if ([cellDataString isEqualToString:@"weight"]) {
        _cellInfoData.text = [NSString stringWithFormat:@"%@ KG",userModel.nUserInfo.weight];
    }else if ([cellDataString isEqualToString:@"address"]) {
        _cellInfoData.text = [NSString stringWithFormat:@"%@",userModel.nUserInfo.address];
    }
    cell.backgroundColor = [UIColor whiteColor];
}

+ (CGFloat)getCellHeightWithCustomObj:(id)obj
                            indexPath:(NSIndexPath *)indexPath
                         withOtherObj:(id)otherObj
{
    NSDictionary *dic = obj;
    UserInfoDetailModel *userModel = (UserInfoDetailModel *)otherObj;
    NSString *cellDataString = [dic objectForKey:@"cellData"];
    if ([cellDataString isEqualToString:@"address"]) {
        NSString *addString = [NSString stringWithFormat:@"%@",userModel.nUserInfo.address];
        NSDictionary *attrbute = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
        CGFloat width = 320-185;
        return [addString boundingRectWithSize:CGSizeMake(width, 100) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrbute context:nil].size.height+15;
    }else {
        return 60;
    }
}

#pragma mark 计算高度
- (CGFloat)heightForText:(NSString *)text
{
    //设置计算文本时字体的大小,以什么标准来计算
    NSDictionary *attrbute = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    CGFloat width = self.frame.size.width-185;
    return [text boundingRectWithSize:CGSizeMake(width, 100) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrbute context:nil].size.height+15;
}

@end
