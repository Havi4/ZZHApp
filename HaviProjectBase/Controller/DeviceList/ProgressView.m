//
//  ProgressView.m
//  HaviProjectBase
//
//  Created by Havi on 16/8/13.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "ProgressView.h"

@interface ProgressView ()
{
    int index;
}

@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *view2;
@property (nonatomic, strong) UIView *view3;
@end

@implementation ProgressView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    _view1 = [[UIView alloc]init];
    _view1.backgroundColor = [UIColor colorWithRed:0.761 green:0.761 blue:0.761 alpha:1.00];
    [self addSubview:_view1];
    
    _view2 = [[UIView alloc]init];
    _view2.backgroundColor = [UIColor colorWithRed:0.761 green:0.761 blue:0.761 alpha:1.00];
    [self addSubview:_view2];
    
    _view3 = [[UIView alloc]init];
    _view3.backgroundColor = [UIColor colorWithRed:0.761 green:0.761 blue:0.761 alpha:1.00];
    [self addSubview:_view3];
    
    [_view1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@3);
        make.left.equalTo(self.mas_left);
    }];
    
    [_view2 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@3);
        make.left.equalTo(_view1.mas_right).offset(8);
    }];
    
    [_view3 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@3);
        make.left.equalTo(_view2.mas_right).offset(8);
        make.right.equalTo(self.mas_right);
        make.width.equalTo(_view2.mas_width);
        make.width.equalTo(_view1.mas_width);
    }];
    
}

- (void)setSelectIndex:(int)selectIndex
{
    index = selectIndex;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.backColor) {
        self.backgroundColor = self.backColor;

    }else{
    
        self.backgroundColor = [UIColor whiteColor];
    }
    switch (index) {
        case 1:
            _view1.backgroundColor = [UIColor colorWithRed:0.161 green:0.659 blue:0.902 alpha:1.00];
            break;
        case 2:
            _view2.backgroundColor = [UIColor colorWithRed:0.161 green:0.659 blue:0.902 alpha:1.00];
            break;
        case 3:
            _view3.backgroundColor = [UIColor colorWithRed:0.161 green:0.659 blue:0.902 alpha:1.00];
            break;
            
        default:
            break;
    }

}


@end
