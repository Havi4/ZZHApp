//
//  SCBarButtonItem.m
//  v2ex-iOS
//
//  Created by Singro on 5/25/14.
//  Copyright (c) 2014 Singro. All rights reserved.
//

#import "SCBarButtonItem.h"


#import "UIImage+Tint.h"

@interface SCBarButtonItem ()



@property (nonatomic, strong) UIImage *buttonImage;
@property (nonatomic, strong) UILabel *badgeLabel;
@property (nonatomic, copy) void (^tapAction)(id sender);

@end

@implementation SCBarButtonItem

- (instancetype)init {
    
    if (self = [super init]) {
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveThemeChangeNotification) name:kThemeDidChangeNotification object:nil];
        
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithTitle:(NSString *)title style:(SCBarButtonItemStyle)style handler:(void (^)(id sender))action {
    
    if ([self init]) {
        
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:title forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button sizeToFit];
        button.height = 44;
        button.width += 30;
        button.centerY = 20 + 22;
        button.x = 0;
        self.view = button;
        self.tapAction = action;
        [button addTarget:self action:@selector(touchupinside:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(touchupdown:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(other:) forControlEvents:UIControlEventTouchCancel|UIControlEventTouchUpOutside|UIControlEventTouchDragOutside ];
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title style:(SCBarButtonItemStyle)style withColor:(UIColor *)color handler:(void (^)(id sender))action {
    
    if ([self init]) {
        
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:title forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [button setTitleColor:color forState:UIControlStateNormal];
        [button sizeToFit];
        button.height = 44;
        button.width += 30;
        button.centerY = 20 + 22;
        button.x = 0;
        self.view = button;
        self.tapAction = action;
        [button addTarget:self action:@selector(touchupinside:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(touchupdown:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(other:) forControlEvents:UIControlEventTouchCancel|UIControlEventTouchUpOutside|UIControlEventTouchDragOutside ];
    }
    
    return self;
}

- (void)touchupinside:(UIButton *)button {
    self.tapAction(button);
    [UIView animateWithDuration:0.2 animations:^{
        button.alpha = 1.0;
    }];
}

- (void)touchupdown:(UIButton *)button
{
    button.alpha = 0.3;
}

- (void)other:(UIButton *)button
{
    [UIView animateWithDuration:0.3 animations:^{
        button.alpha = 1.0;
    }];
}

- (instancetype)initWithImage:(UIImage *)image style:(SCBarButtonItemStyle)style handler:(void (^)(id sender))action {
    
    if ([self init]) {
        
        self.buttonImage = image;
        
//        image = image.imageForCurrentTheme;
        
        UIButton *button = [[UIButton alloc] init];
        [button setImage:image forState:UIControlStateNormal];
        [button setImage:image forState:UIControlStateHighlighted];
        [button sizeToFit];
        button.height = 44;
        button.width += 30;
        button.centerY = 20 + 22;
        button.x = 0;
        self.view = button;
        self.tapAction = action;
        [button addTarget:self action:@selector(touchupinside:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(touchupdown:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(other:) forControlEvents:UIControlEventTouchCancel|UIControlEventTouchUpOutside|UIControlEventTouchDragOutside ];
        
    }
    
    return self;
}

- (instancetype)initWithImage:(UIImage *)image style:(SCBarButtonItemStyle)style withTitileColor:(UIColor*)color handler:(void (^)(id sender))action {
    
    if ([self init]) {
        
        self.buttonImage = image;
        
        //        image = image.imageForCurrentTheme;
        
        UIButton *button = [[UIButton alloc] init];
        [button setImage:image forState:UIControlStateNormal];
        [button setImage:image forState:UIControlStateHighlighted];
        [button sizeToFit];
        button.height = 44;
        button.width += 30;
        button.centerY = 20 + 22;
        button.x = 0;
        self.view = button;
        self.tapAction = action;
        [button addTarget:self action:@selector(touchupinside:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(touchupdown:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(other:) forControlEvents:UIControlEventTouchCancel|UIControlEventTouchUpOutside|UIControlEventTouchDragOutside ];
        
    }
    
    return self;
}


- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    
    if (enabled) {
        self.view.userInteractionEnabled = YES;
        self.view.alpha = 1.0;
    } else {
        self.view.userInteractionEnabled = NO;
        self.view.alpha = 0.3;
    }
    
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
        [self.view addSubview:self.badgeLabel];
    }
    
    if (badge) {
        self.badgeLabel.hidden = NO;
    } else {
        self.badgeLabel.hidden = YES;
    }
    
    self.badgeLabel.frame = (CGRect){self.view.width - 15, 10, kBadgeWidth, kBadgeWidth};
    self.badgeLabel.text = badge;

}

#pragma mark - Notifications

- (void)didReceiveThemeChangeNotification {
    
    UIButton *button  = (UIButton *)self.view;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setImage:self.buttonImage.imageForCurrentTheme forState:UIControlStateNormal];

}

@end
