//
//  ProfileTableViewCell.m
//  HaviProjectBase
//
//  Created by Havi on 16/7/25.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "ProfileTableViewCell.h"

@interface ProfileTableViewCell ()
@property (nonatomic, strong) UIView *profileBorderView;
@end

@implementation ProfileTableViewCell

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
        _userLabel.text = @"哈维";
        [self addSubview:_userLabel];
        [self.userLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@120);
        }];
        _userIcon = [[UIImageView alloc]init];
        _userIcon.image = [UIImage imageNamed:@"person_background@3x"];
        _userIcon.layer.cornerRadius = 37.5;
        _userIcon.layer.masksToBounds = YES;
        _userIcon.layer.borderWidth = 0.0;
        _userIcon.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self addSubview:_userIcon];
        [self.userIcon makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@75);
            make.height.equalTo(@75);
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        self.profileBorderView = [[UIView alloc] init];
        self.profileBorderView.layer.cornerRadius = 40;
        self.profileBorderView.backgroundColor = [UIColor clearColor];
        self.profileBorderView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.profileBorderView.layer.borderWidth = 1.f;
        [self addSubview:self.profileBorderView];
        [_profileBorderView makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@80);
            make.height.equalTo(@80);
            make.centerY.equalTo(self.userIcon.mas_centerY);
            make.centerX.equalTo(self.userIcon.mas_centerX);
        }];
    }
    return self;
}

- (void)configure:(UITableViewCell *)cell customObj:(id)obj indexPath:(NSIndexPath *)indexPath
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
