//
//  BaseViewController.h
//  HaviProjectBase
//
//  Created by Havi on 16/2/3.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXActivity.h"

@interface BaseViewController : UIViewController

@property (nonatomic, strong) UIButton *menuButton;//自定义详细按钮

@property (nonatomic, strong) UIButton *leftButton;//自定义左侧按钮

@property (nonatomic, strong) UIButton *rightButton;//自定义右侧按钮

@property (nonatomic, strong) LXActivity *shareNewMenuView;//社交分享


//set back image to all views
@property (nonatomic, strong) UIImageView *backgroundImageView;

/**
 *  创建自定义导航栏
 *
 *  @param szTitle  导航栏title
 *  @param menuItem 自定义导航栏返回键和有侧键
 */
- (void)createNavWithTitle:(NSString *)szTitle createMenuItem:(UIView *(^)(int nIndex))menuItem;
/**
 *  自定义透明背景的导航栏
 *
 *  @param szTitle  导航栏title
 *  @param menuItem 自定义导航栏返回键和有侧键
 */
- (void)createClearBgNavWithTitle:(NSString *)szTitle createMenuItem:(UIView *(^)(int nIndex))menuItem;
/**
 *  自定义透明背景的导航栏和titile颜色
 *
 *  @param szTitle  title内容
 *  @param color    title颜色
 *  @param menuItem 自定义导航栏返回键和有侧键
 */
- (void)createClearBgNavWithTitle:(NSString *)szTitle andTitleColor:(UIColor *)color createMenuItem:(UIView *(^)(int nIndex))menuItem;

@end
