//
//  ConversationListTableViewCell.m
//  HaviProjectBase
//
//  Created by Havi on 16/9/12.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "ConversationListTableViewCell.h"

@interface ConversationListTableViewCell ()
@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) UILabel *titleDoctorLabel;
@property (nonatomic, strong) UILabel *lineLabel;

@property (nonatomic, strong) UILabel *titleStateLabel;
@property (nonatomic, strong) UIImageView *titleStateImage;

@property (nonatomic, strong) UILabel *pictureLabel;
@property (nonatomic, strong) UIButton *takePictureIcon;

@property (nonatomic, strong) UITextView *textView;

@end

@implementation ConversationListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _lineLabel = [[UILabel alloc]init];
        _lineLabel.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_lineLabel];
        [_lineLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(16);
            make.right.equalTo(self.mas_right).offset(-16);
            make.height.equalTo(@0.5);
            make.top.equalTo(self.mas_top).offset(44);
        }];
        _titleImageView = [[UIImageView alloc]init];
        _titleImageView.image = [UIImage imageNamed:@"icon_wechat"];
        [self addSubview:_titleImageView];
        [_titleImageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(16);
            make.height.width.equalTo(@32);
            make.top.equalTo(self.mas_top).offset(6);
        }];
        
        _titleDoctorLabel = [[UILabel alloc]init];
        _titleDoctorLabel.text = @"医生咨询";
        _titleDoctorLabel.font = [UIFont systemFontOfSize:13];
        _titleDoctorLabel.textColor = kTextDefaultWordColor;
        [self addSubview:_titleDoctorLabel];
        [_titleDoctorLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleImageView.mas_right).offset(8);
            make.centerY.equalTo(self.titleImageView.mas_centerY);
        }];
        
        _titleStateLabel = [[UILabel alloc]init];
        _titleStateLabel.text = @"已回复";
        _titleStateLabel.textColor = kTextDefaultWordColor;
        _titleStateLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_titleStateLabel];
        
        [_titleStateLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-16);
            make.centerY.equalTo(self.titleImageView.mas_centerY);
        }];
        
        _titleStateImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_dot_0"]];
        [self addSubview:_titleStateImage];
        [_titleStateImage makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.titleStateLabel.mas_left).offset(-8);
            make.centerY.equalTo(self.titleImageView.mas_centerY);
            make.height.width.equalTo(@20);
        }];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
