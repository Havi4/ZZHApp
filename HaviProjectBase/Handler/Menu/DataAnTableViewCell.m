//
//  DataAnTableViewCell.m
//  HaviProjectBase
//
//  Created by Havi on 16/7/27.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "DataAnTableViewCell.h"
#import "V2MenuSectionCell.h"
#import "UIImage+Tint.h"
#define kColorBlueDefault             RGBA(63, 183, 252, 1)


static CGFloat const kCellHeight = 90;
static CGFloat const kFontSize   = 14;

@interface DataAnTableViewCell ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel     *titleLabel;

@property (nonatomic, strong) UIImage     *normalImage;
@property (nonatomic, strong) UIImage     *highlightedImage;
@property (nonatomic, strong) UILabel     *badgeLabel;
@property (nonatomic, assign) BOOL cellHighlighted;

@end

@implementation DataAnTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.titleLabel.textColor = [UIColor blackColor];
        self.backgroundColor = [UIColor clearColor];

        
        [self configureViews];
        [[NSNotificationCenter defaultCenter]addObserverForName:@"tapcell" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = 1001;
            [self buttonTaped:button];
        }];
        
    }
    return self;
}


//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//    
//    if (selected) {
//        
//        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//            self.cellHighlighted = selected;
//        } completion:nil];
//        
//    } else {
//        
//        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//            self.cellHighlighted = selected;
//        } completion:nil];
//        
//    }
//    
//}

//- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
//    [super setHighlighted:highlighted animated:animated];
//    
//    if (self.isSelected) {
//        return;
//    }
//    
//    if (highlighted) {
//        
//        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//            self.cellHighlighted = highlighted;
//        } completion:nil];
//        
//    } else {
//        
//        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//            self.cellHighlighted = highlighted;
//        } completion:nil];
//        
//    }
//    
//}

- (void)setCellHighlighted:(BOOL)cellHighlighted {
    _cellHighlighted = cellHighlighted;
    
    if (cellHighlighted) {
        
        //        if (kSetting.theme == V2ThemeNight) {
        //            self.titleLabel.textColor = kFontColorBlackMid;
        //            self.backgroundColor = kMenuCellHighlightedColor;
        //            self.iconImageView.image = self.normalImage;
        //        } else {
        //            self.titleLabel.textColor = kColorBlue;
        //            self.backgroundColor = kMenuCellHighlightedColor;
        //            self.iconImageView.image = self.highlightedImage;
        //        }
//        self.titleLabel.textColor = kColorBlueDefault;
//        self.iconImageView.image = self.highlightedImage;
        
    } else {
        
//        self.titleLabel.textColor = [UIColor blackColor];
//        self.backgroundColor = [UIColor clearColor];
//        self.iconImageView.image = self.normalImage;
        
    }
    
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.iconImageView.frame = (CGRect){30, 21, 18, 18};
    self.titleLabel.frame    = (CGRect){64, 0, 110, 60};
    self.weekButton.frame = (CGRect){64,51,44,44};
    self.monthButton.frame = (CGRect){113,51,44,44};
    self.quaterButton.frame = (CGRect){162,51,44,44};
    
}

#pragma mark - Configure Views

- (void)configureViews {
    self.iconImageView              = [[UIImageView alloc] init];
    self.iconImageView.contentMode  = UIViewContentModeScaleAspectFill;
    [self addSubview:self.iconImageView];
    
    self.titleLabel                 = [[UILabel alloc] init];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textAlignment   = NSTextAlignmentLeft;
    self.titleLabel.font            = [UIFont fontWithName:@"STHeitiSC-Light" size:kFontSize];
    self.titleLabel.font            = [UIFont systemFontOfSize:kFontSize];
    [self addSubview:self.titleLabel];
    self.weekButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.weekButton setImage:[[UIImage imageNamed:@"week"] imageWithTintColor:[UIColor blackColor]] forState:UIControlStateNormal];
    [self.weekButton setImage:[[UIImage imageNamed:@"week"] imageWithTintColor:kColorBlueDefault] forState:UIControlStateSelected];
    [self.weekButton addTarget:self action:@selector(buttonTaped:) forControlEvents:UIControlEventTouchUpInside];
    self.weekButton.tag = 1001;
    self.weekButton.frame = (CGRect){64,51,44,44};

    [self.contentView addSubview:self.weekButton];
    
    self.monthButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.monthButton setImage:[[UIImage imageNamed:@"month"] imageWithTintColor:[UIColor blackColor]] forState:UIControlStateNormal];
    [self.monthButton setImage:[[UIImage imageNamed:@"month"] imageWithTintColor:kColorBlueDefault] forState:UIControlStateSelected];
    [self.monthButton addTarget:self action:@selector(buttonTaped:) forControlEvents:UIControlEventTouchUpInside];
    self.monthButton.tag = 1002;
    [self addSubview:self.monthButton];
    
    self.quaterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.quaterButton setImage:[[UIImage imageNamed:@"ji"] imageWithTintColor:[UIColor blackColor]] forState:UIControlStateNormal];
    [self.quaterButton setImage:[[UIImage imageNamed:@"ji"] imageWithTintColor:kColorBlueDefault] forState:UIControlStateSelected];
    [self.quaterButton addTarget:self action:@selector(buttonTaped:) forControlEvents:UIControlEventTouchUpInside];
    self.quaterButton.tag = 1003;
    [self addSubview:self.quaterButton];
    
}

#pragma mark - Data Methods
- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLabel.text = self.title;
    
}

- (void)buttonTaped:(UIButton *)button
{
    self.titleLabel.textColor = kColorBlueDefault;
    self.iconImageView.image = self.highlightedImage;
    NSInteger tag = button.tag;
    UIButton *button1 = (UIButton *)[self viewWithTag:1001];
    UIButton *button2 = (UIButton *)[self viewWithTag:1002];
    UIButton *button3 = (UIButton *)[self viewWithTag:1003];
    switch (tag) {
        case 1001:
            [[NSNotificationCenter defaultCenter]postNotificationName:kUserTapedDataReportButton object:nil userInfo:@{@"key":@1001}];
            button1.selected = YES;
            button2.selected = NO;
            button3.selected = NO;
            break;
        case 1002:
            [[NSNotificationCenter defaultCenter]postNotificationName:kUserTapedDataReportButton object:nil userInfo:@{@"key":@1002}];
            button1.selected = NO;
            button2.selected = YES;
            button3.selected = NO;
            break;
            
        default:
            [[NSNotificationCenter defaultCenter]postNotificationName:kUserTapedDataReportButton object:nil userInfo:@{@"key":@1003}];
            button1.selected = NO;
            button2.selected = NO;
            button3.selected = YES;
            break;
    }
}

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    
    
    self.normalImage  = [[UIImage imageNamed:_imageName]imageWithTintColor:[UIColor blackColor]];
    self.highlightedImage = [[UIImage imageNamed:_imageName] imageWithTintColor:RGBA(63, 183, 252, 1)];
    self.iconImageView.image = self.normalImage;

    //
    //    self.iconImageView.alpha = kSetting.imageViewAlphaForCurrentTheme;
    
}


- (void)setBadge:(NSString *)badge {
    _badge = badge;
    
    static const CGFloat kBadgeWidth = 6;
    
    if (!self.badgeLabel && badge) {
        self.badgeLabel = [[UILabel alloc] init];
        self.badgeLabel.backgroundColor = [UIColor redColor];
        self.badgeLabel.textColor = [UIColor whiteColor];
        self.badgeLabel.hidden = YES;
        self.badgeLabel.font = [UIFont systemFontOfSize:5];
        self.badgeLabel.layer.cornerRadius = kBadgeWidth/2.0;
        self.badgeLabel.clipsToBounds = YES;
        [self addSubview:self.badgeLabel];
    }
    
    if (badge) {
        self.badgeLabel.hidden = NO;
    } else {
        self.badgeLabel.hidden = YES;
    }
    
    self.badgeLabel.frame = (CGRect){80, 10, kBadgeWidth, kBadgeWidth};
    self.badgeLabel.text = badge;
    
}

#pragma mark - Class Methods

+ (CGFloat)getCellHeight {
    
    return kCellHeight;
    
}

- (void)resetCell
{
    self.titleLabel.textColor = [UIColor blackColor];
    self.backgroundColor = [UIColor clearColor];
    self.iconImageView.image = self.normalImage;

}


@end
