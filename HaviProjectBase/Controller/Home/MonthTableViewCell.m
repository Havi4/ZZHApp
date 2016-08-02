//
//  MonthTableViewCell.m
//  HaviProjectBase
//
//  Created by Havi on 16/8/1.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "MonthTableViewCell.h"

@interface MonthTableViewCell ()

@property (nonatomic, strong) UIImageView *cellIcon;
@property (nonatomic, strong) UILabel *cellTitle;

@property (nonatomic, strong) UILabel *cellNum;

@end

@implementation MonthTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cellIcon = [[UIImageView alloc]init];
        [self addSubview:_cellIcon];
        
        _cellTitle = [[UILabel alloc]init];
        [self addSubview:_cellTitle];
        
        _cellNum = [[UILabel alloc]init];
        [self addSubview:_cellNum];
        
        [_cellIcon makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(16);
            make.centerY.equalTo(self.mas_centerY);
            make.width.height.equalTo(@20);
            
        }];
        
        [_cellTitle makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_cellIcon.mas_right).offset(25);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        [_cellNum makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-16);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line];
        [line makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
            make.height.equalTo(@0.5);
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
    _cellIcon.image  = [UIImage imageNamed:obj];
    _cellTitle.text = objInfo;
//    SleepQualityModel *model = objInfo;
//    @weakify(self);
//    [SleepModelChange changeSleepQualityModel:model callBack:^(id callBack) {
//        @strongify(self);
//        QualityDetailModel *detailModel = callBack;
//    }];
//    [SleepModelChange changeSleepDuration:model callBack:^(id callBack) {
//        @strongify(self);
//    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
