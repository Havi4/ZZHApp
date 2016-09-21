//
//  SatisfactionTableViewCell.m
//  HaviProjectBase
//
//  Created by Havi on 16/9/20.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "SatisfactionTableViewCell.h"
#import "HCSStarRatingView.h"

@interface SatisfactionTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) HCSStarRatingView *starRatingView;
@property (nonatomic, strong) UILabel *stausLabel;
@property (nonatomic, strong) UIImageView *stausView;

@end

@implementation SatisfactionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (HCSStarRatingView*)starRatingView
{
    if (!_starRatingView) {
        _starRatingView = [HCSStarRatingView new];
        _starRatingView.maximumValue = 5;
        _starRatingView.minimumValue = 1;
        _starRatingView.value = 5;
        _starRatingView.tintColor = [UIColor colorWithRed:0.157 green:0.659 blue:0.902 alpha:1.00];
        _starRatingView.allowsHalfStars = NO;
        _starRatingView.emptyStarImage = [[UIImage imageNamed:@"star_nofill"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
        _starRatingView.filledStarImage = [[UIImage imageNamed:@"star_fill"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
        [_starRatingView addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
        
        
    }
    return _starRatingView;
}

- (void)didChangeValue:(HCSStarRatingView *)sender {
    NSLog(@"Changed rating to %.1f", sender.value);
    if (sender.value<3) {
        _stausLabel.text = @"不满意";
        _stausView.image = [UIImage imageNamed:@"cry"];
    }else if (sender.value < 5){
        _stausLabel.text = @"一般";
        _stausView.image = [UIImage imageNamed:@"yb"];
    }else{
        _stausLabel.text = @"满意";
        _stausView.image = [UIImage imageNamed:@"manyi"];
    }
    self.selectAssementView(sender.value);
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"满意度";
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_titleLabel];
        [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).offset(8);
        }];
        [self addSubview:self.starRatingView];
        
        _stausLabel = [[UILabel alloc]init];
        _stausLabel.text = @"满意";
        _stausLabel.textColor = [UIColor grayColor];
        _stausLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_stausLabel];
        
        [self.starRatingView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(_titleLabel.mas_right).offset(8);
            make.height.equalTo(self.mas_height);
            make.width.equalTo(@150);
        }];
        
        _stausView = [[UIImageView alloc]init];
        _stausView.image = [UIImage imageNamed:@"manyi"];
        [self addSubview:_stausView];
        [_stausView makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-8);
            make.centerY.equalTo(self.mas_centerY);
            make.height.width.equalTo(@20);
        }];
        
        
        [_stausLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(_stausView.mas_left).offset(-8);
        }];
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
