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
    }];
    
    [_notiSubTitile makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.top.equalTo(_notiTitle.mas_bottom);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(_notiTitle.mas_height);
    }];
}

@end
