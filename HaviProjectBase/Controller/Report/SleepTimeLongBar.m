//
//  SleepTimeLongBar.m
//  SleepRecoding
//
//  Created by Havi on 15/9/15.
//  Copyright (c) 2015年 Havi. All rights reserved.
//

#import "SleepTimeLongBar.h"

@implementation SleepTimeLongBar


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.gradientLayer = [CAGradientLayer layer];
        self.gradientLayer.frame = self.bounds;
        
        //设置渐变颜色方向
        self.gradientLayer.startPoint = CGPointMake(0, 0);
        self.gradientLayer.endPoint = CGPointMake(0, 1);
        
        //设定颜色组
//        self.gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:0.000f green:0.855f blue:0.573f alpha:1.00f].CGColor,(__bridge id)[UIColor colorWithRed:0.200f green:0.443f blue:0.545f alpha:1.00f].CGColor];
        self.gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:0.027 green:0.322 blue:0.400 alpha:1.00].CGColor,(__bridge id)[UIColor colorWithRed:0.027 green:0.322 blue:0.400 alpha:1.00].CGColor];
        
        //设定颜色分割点
        self.gradientLayer.locations = @[@(0.2f) ,@(1.0f)];
        self.gradientLayer.cornerRadius = 0;
        [self.layer addSublayer:self.gradientLayer];
    }
    return self;
}

@end
