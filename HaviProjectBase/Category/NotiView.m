//
//  NotiView.m
//  HaviProjectBase
//
//  Created by Havi on 2016/9/27.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "NotiView.h"

@interface NotiView ()

@property (nonatomic, strong) UILabel *notiTitle;
@property (nonatomic, strong) UILabel *notiSubTitile;
@property (nonatomic, strong) UIButton *checkDetailButton;

@end

@implementation NotiView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIImageView *backImageView = [[UIImageView alloc]init];
        backImageView.image = [UIImage imageWithColor:[UIColor colorWithWhite:0.7 alpha:0.4]];
        [self addSubview:backImageView];
        [backImageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
        _notiTitle = [[UILabel alloc]init];
        _notiTitle.text = @"文章推送";
        _notiTitle.font = [UIFont systemFontOfSize:16];
        _notiTitle.textColor = [UIColor whiteColor];
        [self addSubview:_notiTitle];
        
        _notiSubTitile = [[UILabel alloc]init];
        _notiSubTitile.text = @"中午为什么需要休息";
        _notiSubTitile.font = [UIFont systemFontOfSize:14];
        _notiSubTitile.textColor = [UIColor whiteColor];
        [self addSubview:_notiSubTitile];
        
        _checkDetailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkDetailButton setTitle:@"查看" forState:UIControlStateNormal];
        [_checkDetailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _checkDetailButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _checkDetailButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_checkDetailButton addTarget:self action:@selector(showDetail:) forControlEvents:UIControlEventTouchUpInside];
        _checkDetailButton.layer.borderWidth = 1;
        _checkDetailButton.layer.cornerRadius = 5;
        _checkDetailButton.layer.masksToBounds = YES;
        [self addSubview:_checkDetailButton];
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"header_back"]];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_notiTitle makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(_notiSubTitile.mas_top);
        make.right.equalTo(_checkDetailButton.mas_left).offset(-8);
    }];
    
    [_notiSubTitile makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.top.equalTo(_notiTitle.mas_bottom);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(_notiTitle.mas_height);
        make.right.equalTo(_checkDetailButton.mas_left).offset(-8);
    }];
    
    [_checkDetailButton makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@45);
        make.height.equalTo(@25);
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-16);
        
    }];
}

- (void)showDetail:(UIButton *)button
{
    self.buttonClockTaped(1);
}

- (void)configNotiView:(NSDictionary *)dic
{
    NSString *alertString = [[dic objectForKey:@"aps"] objectForKey:@"alert"];
    NSString *key = [dic objectForKey:@"message_type"];
    if ([key intValue]==111) {
        _notiTitle.text = @"推荐文章";
        _notiSubTitile.text = alertString;
    }else if ([key intValue]==112){
        _notiTitle.text = @"医生回复";
        _notiSubTitile.text = alertString;
    }
}

@end
