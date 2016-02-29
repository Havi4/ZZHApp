//
//  LeftSideTableViewCell.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/4.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "LeftSideTableViewCell.h"
#import "UIBadgeView.h"

@interface LeftSideTableViewCell ()
{
    UIImageView *_leftIconImage;
    UILabel *_leftTitleLabel;
    UIImageView *_leftArrowImage;
}

@property (nonatomic, strong) UIBadgeView *badageView;

@end

@implementation LeftSideTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _leftIconImage = [[UIImageView alloc]init];
        _leftTitleLabel = [[UILabel alloc]init];
        _leftTitleLabel.dk_textColorPicker = kTextColorPicker;
        _leftTitleLabel.font = kDefaultWordFont;
        _leftArrowImage = [[UIImageView alloc]init];
        _leftArrowImage.dk_imagePicker = DKImageWithNames(@"btn_right_0", @"btn_right_1");
        [self addSubview:_leftArrowImage];
        [self addSubview:_leftIconImage];
        [self addSubview:_leftTitleLabel];
        [_leftTitleLabel addSubview:_badageView];
        [_leftIconImage makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(20);
            make.width.equalTo(@17);
            make.height.equalTo(@17);
        }];
        [_leftTitleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(_leftIconImage.mas_right).offset(10);
            make.height.equalTo(self);
            make.width.equalTo(@100);
        }];
        [_leftArrowImage makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.rightMargin.equalTo(self).offset(-5);
            make.width.equalTo(@12);
            make.height.equalTo(@20);
        }];
        
    }
    return self;
}

- (UIBadgeView *)badageView
{
    if (_badageView == nil) {
        NSInteger appBadage =  (int)[[NSUserDefaults standardUserDefaults] integerForKey:kBadgeKey];
        _badageView = [UIBadgeView viewWithBadgeTip:[NSString stringWithFormat:@"%d",(int)appBadage]];
    }
    return _badageView;
}

- (void)configure:(UITableViewCell *)cell
        customObj:(id)obj
        indexPath:(NSIndexPath *)indexPath
    withOtherInfo:(id)objInfo
{
    // Rewrite this func in SubClass !
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{kBadgeKey:@0}];
    NSInteger appBadage =  (int)[[NSUserDefaults standardUserDefaults] integerForKey:kBadgeKey];
    if (appBadage > 0) {
        if (indexPath.row == 4) {
            [_leftTitleLabel addSubview:self.badageView];
            self.badageView.badgeValue = [NSString stringWithFormat:@"%d",(int)appBadage];
            [self.badageView setCenter:CGPointMake(80, 15)];
        }
    }else{
        [self.badageView removeFromSuperview];
        self.badageView = nil;
    }
    NSDictionary *dic = obj;
    _leftIconImage.dk_imagePicker = DKImageWithNames([NSString stringWithFormat:@"%@0",[dic objectForKey:@"iconTitle"]], [NSString stringWithFormat:@"%@1",[dic objectForKey:@"iconTitle"]]);
    _leftTitleLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"iconName"]];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.145f green:0.733f blue:0.957f alpha:0.15f];
}

+ (CGFloat)getCellHeightWithCustomObj:(id)obj
                            indexPath:(NSIndexPath *)indexPath
{
    // Rewrite this func in SubClass if necessary
    return 49.0f; // default cell height
}



@end
