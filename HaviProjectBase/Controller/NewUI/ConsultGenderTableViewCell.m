//
//  ConsultGenderTableViewCell.m
//  HaviProjectBase
//
//  Created by Havi on 16/9/11.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "ConsultGenderTableViewCell.h"

@interface ConsultGenderTableViewCell ()
@property (nonatomic, strong) UILabel *userLabel;
@property (nonatomic, strong) UIButton *boyIcon;
@property (nonatomic, strong) UILabel *boyLabel;
@property (nonatomic, strong) UIButton *girlIcon;
@property (nonatomic, strong) UILabel *girlLabel;
@end

@implementation ConsultGenderTableViewCell

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
        _userLabel.text = @"性别";
        [self addSubview:_userLabel];
        [self.userLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(8);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@120);
        }];
        _boyLabel = [[UILabel alloc]init];
        _boyLabel.font = kTextNormalWordFont;
        _boyLabel.text = @"男";
        [self addSubview:_boyLabel];
        
        _girlLabel = [[UILabel alloc]init];
        _girlLabel.font = kTextNormalWordFont;
        _girlLabel.text = @"女";
        [self addSubview:_girlLabel];
        
        _boyIcon = [UIButton buttonWithType:UIButtonTypeCustom];
        _boyIcon.tag = 101;
        [_boyIcon addTarget:self action:@selector(changeIcon:) forControlEvents:UIControlEventTouchUpInside];
        [_boyIcon setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
        [self addSubview:_boyIcon];
        
        _girlIcon = [UIButton buttonWithType:UIButtonTypeCustom];
        [_girlIcon setImage:[UIImage imageNamed:@"tuoy"] forState:UIControlStateNormal];
        _girlIcon.tag = 102;
        [_girlIcon addTarget:self action:@selector(changeIcon:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_girlIcon];
        
        
        [self.girlIcon makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-8);
            make.centerY.equalTo(self.mas_centerY);
            make.height.width.equalTo(@16);
        }];
        
        [self.girlLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.girlIcon.mas_left).offset(-5);
        }];
        
        [self.boyIcon makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.girlLabel.mas_left).offset(-24);
            make.centerY.equalTo(self.mas_centerY);
            make.height.width.equalTo(@16);
        }];
        
        [self.boyLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.boyIcon.mas_left).offset(-5);
        }];

    }
    return self;
}

- (void)configure:(UITableViewCell *)cell customObj:(id)obj indexPath:(NSIndexPath *)indexPath
{
    
}

- (void)changeIcon:(UIButton *)button
{
    if (button.tag == 101) {
        [_boyIcon setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
        [_girlIcon setImage:[UIImage imageNamed:@"tuoy"] forState:UIControlStateNormal];
    }else{
        [_girlIcon setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
        [_boyIcon setImage:[UIImage imageNamed:@"tuoy"] forState:UIControlStateNormal];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
