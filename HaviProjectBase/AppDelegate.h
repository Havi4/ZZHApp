//
//  AppDelegate.h
//  HaviProjectBase
//
//  Created by Havi on 16/2/3.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "CenterViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) TencentOAuth *tencentOAuth;

@property (strong, nonatomic) CenterViewController *centerView;

@property (strong, nonatomic) JASidePanelController *sideMenuController;

@property (strong, nonatomic) NSString *wbtoken;

@property (strong, nonatomic) NSString *wbCurrentUserID;

- (void)setRootViewController;

@end

