//
//  V2MenuSectionCell.m
//  v2ex-iOS
//
//  Created by Singro on 3/30/14.
//  Copyright (c) 2014 Singro. All rights reserved.
//

#import "V2MenuSectionCell.h"
#import "UIImage+Tint.h"
#define kColorBlueDefault             RGBA(63, 183, 252, 1)


static CGFloat const kCellHeight = 50;
static CGFloat const kFontSize   = 16;

@interface V2MenuSectionCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel     *titleLabel;

@property (nonatomic, strong) UIImage     *normalImage;
@property (nonatomic, strong) UIImage     *highlightedImage;
@property (nonatomic, strong) UILabel     *badgeLabel;

@property (nonatomic, assign) BOOL cellHighlighted;

@end

@implementation V2MenuSectionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self configureViews];
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    if (selected) {
        
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.cellHighlighted = selected;
        } completion:nil];
        
    } else {
        
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.cellHighlighted = selected;
        } completion:nil];

    }
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    if (self.isSelected) {
        return;
    }
    
    if (highlighted) {
        
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.cellHighlighted = highlighted;
        } completion:nil];
        
    } else {
        
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.cellHighlighted = highlighted;
        } completion:nil];
        
    }

}

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
        self.titleLabel.textColor = kColorBlueDefault;
        self.iconImageView.image = self.highlightedImage;
        
    } else {
        
        self.titleLabel.textColor = [UIColor blackColor];
        self.backgroundColor = [UIColor clearColor];
        self.iconImageView.image = self.normalImage;
        
    }

}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.iconImageView.frame = (CGRect){30, 16, 18, 18};
    self.titleLabel.frame    = (CGRect){64, 0, 110, self.height};
    
}

#pragma mark - Configure Views

- (void)configureViews {
    
    self.iconImageView              = [[UIImageView alloc] init];
    self.iconImageView.contentMode  = UIViewContentModeScaleAspectFill;
    [self addSubview:self.iconImageView];

    self.titleLabel                 = [[UILabel alloc] init];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor       = [UIColor redColor];
    self.titleLabel.textAlignment   = NSTextAlignmentLeft;
    self.titleLabel.font            = [UIFont fontWithName:@"STHeitiSC-Light" size:kFontSize];
    self.titleLabel.font            = [UIFont systemFontOfSize:kFontSize];
    [self addSubview:self.titleLabel];
    
}

#pragma mark - Data Methods
- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLabel.text = self.title;
    
}

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    
    
    self.normalImage  = [[UIImage imageNamed:_imageName]imageWithTintColor:[UIColor blackColor]];
    self.highlightedImage = [[UIImage imageNamed:_imageName] imageWithTintColor:RGBA(63, 183, 252, 1)];
//
//    self.iconImageView.alpha = kSetting.imageViewAlphaForCurrentTheme;

}


- (void)setBadge:(NSString *)badge {
    _badge = badge;
    CGFloat kBadgeWidth = 16;
    
    if (!self.badgeLabel && badge) {
        self.badgeLabel = [[UILabel alloc] init];
        self.badgeLabel.backgroundColor = [UIColor redColor];
        self.badgeLabel.textColor = [UIColor whiteColor];
        self.badgeLabel.textAlignment = NSTextAlignmentCenter;
        self.badgeLabel.hidden = YES;
        self.badgeLabel.font = [UIFont systemFontOfSize:9];
        self.badgeLabel.layer.cornerRadius = kBadgeWidth/2.0;
        self.badgeLabel.clipsToBounds = YES;
        [self addSubview:self.badgeLabel];
    }
    
    if (badge) {
        self.badgeLabel.hidden = NO;
    } else {
        self.badgeLabel.hidden = YES;
    }
    if ([badge intValue]>99) {
        self.badgeLabel.frame = (CGRect){130,10,25,kBadgeWidth};
    }else{
        self.badgeLabel.frame = (CGRect){130, 10, kBadgeWidth, kBadgeWidth};
    }
    if ([badge intValue]==0) {
        self.badgeLabel.hidden = YES;
    }else{
        self.badgeLabel.hidden = NO;
    }

    self.badgeLabel.text = badge;
    
}

#pragma mark - Class Methods

+ (CGFloat)getCellHeight {
    
    return kCellHeight;
    
}

@end
