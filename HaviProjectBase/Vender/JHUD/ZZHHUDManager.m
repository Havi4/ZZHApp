//
//  ZZHHUDManager.m
//  HaviProjectBase
//
//  Created by Havi on 16/8/23.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "ZZHHUDManager.h"
#import "JHUD.h"

static ZZHHUDManager *client = nil;

@implementation ZZHHUDManager

+ (instancetype)shareHUDInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[ZZHHUDManager alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
        
    });
    return client;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.messageLabel.text = @"";
        self.indicatorBackGroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.3];
        self.indicatorForegroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)showHUDWithView:(UIView *)view
{
    [self showAtView:view hudType:JHUDLoadingTypeCircle];
}

- (void)hideHUD
{
    [self hide];
}



@end
