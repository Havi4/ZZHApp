//
//  ConsultTableViewCell.m
//  HaviProjectBase
//
//  Created by Havi on 16/9/11.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "ConsultTableViewCell.h"

@interface ConsultTableViewCell ()
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UILabel *lineLabel;

@property (nonatomic, strong) UILabel *pictureLabel;
@property (nonatomic, strong) UIButton *takePictureIcon;

@property (nonatomic, strong) UITextView *textView;

@end

@implementation ConsultTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _backImageView = [[UIImageView alloc]init];
        _backImageView.image = [UIImage imageNamed:@"wenzhen"];
        _backImageView.userInteractionEnabled = YES;
        [self addSubview:_backImageView];
        [_backImageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(8);
            make.right.equalTo(self.mas_right).offset(-8);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        _lineLabel = [[UILabel alloc]init];
        _lineLabel.backgroundColor = [UIColor lightGrayColor];
        [_backImageView addSubview:_lineLabel];
        [_lineLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backImageView.mas_left);
            make.right.equalTo(_backImageView.mas_right);
            make.height.equalTo(@0.5);
            make.bottom.equalTo(_backImageView.mas_bottom).offset(-44);
        }];
        
        _pictureLabel = [[UILabel alloc]init];
        _pictureLabel.text = @"上传病历或者患者部位照片";
        _pictureLabel.textColor = [UIColor lightGrayColor];
        _pictureLabel.font = kTextPlaceHolderFont;
        [_backImageView addSubview:_pictureLabel];
        [_pictureLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backImageView.mas_left).offset(8);
            make.top.equalTo(_lineLabel.mas_bottom);
            make.bottom.equalTo(_backImageView.mas_bottom);
        }];
        
        _takePictureIcon = [UIButton buttonWithType:UIButtonTypeCustom];
        [_takePictureIcon setBackgroundImage:[UIImage imageNamed:@"photo"] forState:UIControlStateNormal];
        [_backImageView addSubview:_takePictureIcon];
        [_takePictureIcon makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_backImageView.mas_right).offset(-8);
            make.centerY.equalTo(_pictureLabel.mas_centerY);
            make.height.equalTo(@14);
            make.width.equalTo(@18);
        }];
        
        _textView = [[UITextView alloc]init];
        [_backImageView addSubview:_textView];
        [_textView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backImageView.mas_left).offset(8);
            make.right.equalTo(_backImageView.mas_right).offset(-8);
            make.top.equalTo(_backImageView.mas_top).offset(1.5);
            make.bottom.equalTo(self.lineLabel.mas_top).offset(-1.5);
        }];
        _textView.text = @"请输入50-200个字";
        _textView.textColor = [UIColor grayColor];
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
