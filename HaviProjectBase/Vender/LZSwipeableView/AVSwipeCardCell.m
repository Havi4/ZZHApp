//
//  AVSwipeCardCell.m
//  LZSwipeableViewDemo
//
//  Created by 周济 on 16/4/21.
//  Copyright © 2016年 LeoZ. All rights reserved.
//

#import "AVSwipeCardCell.h"

@interface AVSwipeCardCell ()
/**<#desc#>*/
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UILabel *subLabel;
@property (nonatomic, strong) UIImageView *questionImageView;
@property (nonatomic, strong) UIImageView *answerImageView;
@property (nonatomic, strong) UILabel *likeLabel;
@property (nonatomic, strong) UIScrollView *iconScrollView;
@end

@implementation AVSwipeCardCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupSubviews];
    }
    return  self;
}

- (void)setupSubviews{
    self.backImageView = [[UIImageView alloc]init];
    self.backImageView.image = [UIImage imageNamed:@"pai"];
    [self addSubview:self.backImageView];
    [self.backImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(self.mas_width).multipliedBy(0.9);
        make.width.equalTo(self.backImageView.mas_height);
    }];
    self.questionImageView = [[UIImageView alloc]init];
    self.questionImageView.image = [UIImage imageNamed:@"wen"];
    [self addSubview:self.questionImageView];
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textColor = [UIColor colorWithRed:0.353 green:0.353 blue:0.353 alpha:1.00];
    self.titleLabel.font = kDefaultWordFont;
    self.titleLabel.text = @"";
    [self addSubview:self.titleLabel];
    [self.questionImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.mas_top).offset(30);
        make.height.width.equalTo(@22);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.questionImageView.mas_right).offset(10);
        make.top.equalTo(self.mas_top).offset(30);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    //
    self.answerImageView = [[UIImageView alloc]init];
    self.answerImageView.image = [UIImage imageNamed:@"s"];
    [self addSubview:self.answerImageView];
    self.subLabel = [[UILabel alloc]init];
    self.subLabel.numberOfLines = 0;
    self.subLabel.textColor = [UIColor colorWithRed:0.306 green:0.678 blue:0.910 alpha:1.00];
    self.subLabel.font = kDefaultWordFont;
    self.subLabel.text = @"";
    [self addSubview:self.subLabel];
    [self.answerImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.subLabel.mas_top).offset(0);
        make.height.width.equalTo(@22);
    }];
    
    [self.subLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.questionImageView.mas_right).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-145);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    
    self.likeLabel = [[UILabel alloc]init];
    [self addSubview:self.likeLabel];
    self.likeLabel.textColor = [UIColor colorWithRed:0.353 green:0.353 blue:0.353 alpha:1.00];
    self.likeLabel.font = [UIFont systemFontOfSize:10];
    self.likeLabel.text = @"0人喜欢";
    [self.likeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom).offset(-75);
    }];
    
    self.iconScrollView = [[UIScrollView alloc]init];
    [self addSubview:self.iconScrollView];
    [self.iconScrollView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.likeLabel.mas_top).offset(-10);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(@20);
    }];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.text = [self.cardInfo objectForKey:@"Question"];
    NSDictionary *answer = [self.cardInfo objectForKey:@"Answers"];
    self.subLabel.text = [answer objectForKey:@"Answer"];
    self.likeLabel.text = [NSString stringWithFormat:@"%@人喜欢",[answer objectForKey:@"IsUse"]];
    [self layoutScrollView];
}

- (void)layoutScrollView
{
    NSDictionary *answer = [self.cardInfo objectForKey:@"Answers"];
    NSArray *arr = [answer objectForKey:@"Icons"];
    self.iconScrollView.contentSize = (CGSize){21*arr.count,20};
    for (UIView *subView in self.iconScrollView.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            [subView removeFromSuperview];
        }
    }
    for (int i = 0; i<arr.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = (CGRect){21*i,0,20,20};
        imageView.layer.cornerRadius = 10;
        imageView.layer.masksToBounds = YES;
        [imageView setImageWithURL:[NSURL URLWithString:[arr objectAtIndex:i]] placeholder:[UIImage imageNamed:@"head_placeholder"]];
        [self.iconScrollView addSubview:imageView];
    }
    
    
}

- (void)configCardView:(id)item
{
    self.titleLabel.text = [item objectForKey:@"Question"];
    NSDictionary *answer = [item objectForKey:@"Answers"];
    self.subLabel.text = [answer objectForKey:@"Answer"];
    self.likeLabel.text = [NSString stringWithFormat:@"%@人喜欢",[answer objectForKey:@"IsUse"]];
}

@end
