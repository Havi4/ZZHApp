//
//  NSObject+Common.h
//  HaviModel
//
//  Created by Havi on 15/12/28.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Common)

#pragma mark Tip M
+ (NSString *)tipFromError:(NSError *)error;
+ (BOOL)showError:(NSError *)error;
+ (void)showHudTipStr:(NSString *)tipStr;
+ (void)showStatusBarQueryStr:(NSString *)tipStr;
+ (void)showStatusBarSuccessStr:(NSString *)tipStr;
+ (void)showStatusBarErrorStr:(NSString *)errorStr;
+ (void)showStatusBarError:(NSError *)error;
+ (void)showHud;
+ (void)hideHud;
+ (void)showHUBAnimation;
+ (void)hideHUBAnimation;

#pragma mark BaseURL

+ (NSString *)baseURLStr;
+ (BOOL)baseURLStrIsTest;
+ (void)changeBaseURLStrToTest:(BOOL)isTest;

+ (id) loadResponseWithPath:(NSString *)requestPath;
+ (BOOL)saveResponseData:(NSDictionary *)data toPath:(NSString *)requestPath;

#pragma mark NetError
-(id)handleResponse:(id)responseJSON;
-(id)handleResponse:(id)responseJSON autoShowError:(BOOL)autoShowError;

#pragma mark 顶层controller

+ (UIViewController *)appPresentedRootViewController;

+ (UIViewController *)appNaviRootViewController;

@end
