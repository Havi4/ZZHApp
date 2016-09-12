//
//  ConsultBirthTableViewCell.m
//  HaviProjectBase
//
//  Created by Havi on 16/9/11.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "ConsultBirthTableViewCell.h"

@interface ConsultBirthTableViewCell ()
@property (nonatomic, strong) UILabel *userLabel;
@property (nonatomic, strong) UIImageView *userIcon;
@property (nonatomic, strong) UILabel *rigthLabel;

@end

@implementation ConsultBirthTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _userLabel = [[UILabel alloc]init];
        _userLabel.font = kTextNormalWordFont;
        _userLabel.text = @"出生年月";
        [self addSubview:_userLabel];
        [self.userLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(8);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@120);
        }];
        _rigthLabel = [[UILabel alloc]init];
        _rigthLabel.font = kTextNormalWordFont;
        _rigthLabel.text = @"请选择";
        [self addSubview:_rigthLabel];
        
        _userIcon = [[UIImageView alloc]init];
        _userIcon.image = [[UIImage imageNamed:@"btn_right_1"] imageByTintColor:[UIColor lightGrayColor]];
        [self addSubview:_userIcon];
        [self.userIcon makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@10);
            make.height.equalTo(@20);
            make.right.equalTo(self.mas_right).offset(-8);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        [self.rigthLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.userIcon.mas_left).offset(-5);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
