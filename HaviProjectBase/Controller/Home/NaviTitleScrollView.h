//
//  NaviTitleScrollView.h
//  HaviProjectBase
//
//  Created by Havi on 16/8/2.
//  Copyright © 2016年 Havi. All rights reserved.
//
#import "SLPagingViewController.h"
#import <UIKit/UIKit.h>
#define SCREEN_SIZE [[UIScreen mainScreen] bounds].size

@interface NaviTitleScrollView : UIView

@property (nonatomic, strong) NSArray *titles;
- (void)setCurrentIndex:(NSInteger)index;
@end
