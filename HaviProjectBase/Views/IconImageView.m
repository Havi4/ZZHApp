//
//  IconImageView.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/3.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "IconImageView.h"

@interface IconImageView ()
{
    UIImageView *_iconImageView;
    UILabel *_nameLabel;
    NSString *_iconUrl;
}

@end

@implementation IconImageView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.layer.cornerRadius = 30;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.shouldRasterize = YES;
        _iconImageView.userInteractionEnabled = YES;
        _iconImageView.layer.borderWidth = 1;
        _iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _iconImageView.layer.rasterizationScale = [UIScreen screenScale];
        [self addSubview:_iconImageView];
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.userInteractionEnabled = YES;
        _nameLabel.dk_textColorPicker = kTextColorPicker;
        _nameLabel.font = [UIFont systemFontOfSize:20];
        [self addSubview:_nameLabel];
        
        [_iconImageView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(10);
            make.width.equalTo(@60);
            make.height.equalTo(@60);
        }];
        [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconImageView.rightMargin).offset(20);
            make.centerY.equalTo(self);
        }];
        @weakify(self);
        UITapGestureRecognizer *iconTapGesture = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id sender) {
            @strongify(self);
            if (self.tapIconBlock) {
                self.tapIconBlock(1);
            }
        }];
        UITapGestureRecognizer *nameTapGesture = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id sender) {
            @strongify(self);
            if (self.tapIconBlock) {
                self.tapIconBlock(1);
            }
        }];
        [_iconImageView addGestureRecognizer:iconTapGesture];
        [_nameLabel addGestureRecognizer:nameTapGesture];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshImage) name:@"iconImageChanged" object:nil];
    }
    return self;
}

- (void)setUserIconURL:(NSString *)userIconURL
{
    _iconUrl = userIconURL;
    [_iconImageView setImageWithURL:[NSURL URLWithString:userIconURL] placeholder:[UIImage imageNamed:@"head_placeholder"]];
}

- (void)refreshImage
{
    [_iconImageView setImageWithURL:[NSURL URLWithString:_iconUrl] placeholder:[UIImage imageNamed:@"head_placeholder"]];
}

- (void)setUserName:(NSString *)userName
{
    _nameLabel.text = userName;
}

@end
