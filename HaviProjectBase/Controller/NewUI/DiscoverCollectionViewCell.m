//
//  DiscoverCollectionViewCell.m
//  HaviProjectBase
//
//  Created by HaviLee on 2016/11/3.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "DiscoverCollectionViewCell.h"

@interface DiscoverCollectionViewCell ()

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *iconTitleLabel;

@end

@implementation DiscoverCollectionViewCell

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.iconImage = [[UIImageView alloc]init];
        [self.contentView addSubview:self.iconImage];
        self.iconTitleLabel = [[UILabel alloc]init];
        self.iconTitleLabel.font = kDefaultWordFont;
        [self.contentView addSubview:self.iconTitleLabel];
        
        [self.iconImage makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(17.5);
            make.height.width.equalTo(@25);
            make.centerX.equalTo(self.contentView.mas_centerX);
        }];
        
        [self.iconTitleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconImage.mas_bottom).offset(17.5);
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.height.equalTo(@30);
        }];
        UIView *selectView = [[UIView alloc]initWithFrame:self.bounds];
        selectView.backgroundColor = [UIColor lightGrayColor];
        selectView.alpha = 0.5;
        self.selectedBackgroundView = selectView ;
    }
    return self;
}

- (void)configCell:(id)item
{
    NSDictionary *dic = item;
    self.iconImage.image = [UIImage imageNamed:[dic objectForKey:@"icon"]];
    self.iconTitleLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
}

@end
