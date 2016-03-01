//
//  PinLockSetting.m
//  HaviProjectBase
//
//  Created by Havi on 16/3/1.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "PinLockSetting.h"

#import "THPinViewController.h"
static PinLockSetting *shareInstance = nil;
@interface PinLockSetting ()<THPinViewControllerDelegate>

@property (nonatomic, strong) NSString *correctPin;
@property (nonatomic, assign) int remainingPinEntries;//验证次数

@end

@implementation PinLockSetting

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[PinLockSetting alloc]init];
        [shareInstance addObserver];
        [shareInstance isShowAppSettingPassWord];
    });
    return shareInstance;
}

- (void)addObserver
{
    //检测设置APP密码
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(isShowAppSettingPassWord) name:kAppPassWorkSetOkNoti object:nil];
    //移除检测
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeAppSettingPassWord) name:kAppPassWordCancelNoti object:nil];
}
#pragma mark 设备锁
- (void)removeAppSettingPassWord
{
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:kAppPassWordKeyNoti] isEqualToString:@"NO"]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification
                                                      object:nil];
    }
}

- (void)isShowAppSettingPassWord
{
    if (![[[NSUserDefaults standardUserDefaults]objectForKey:kAppPassWordKeyNoti] isEqualToString:@"NO"]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground)
                                                     name:UIApplicationWillResignActiveNotification object:nil];
    }
}

#pragma mark 设备锁
- (void)showPinViewAnimated:(BOOL)animated
{
    THPinViewController *pinViewController = [[THPinViewController alloc] initWithDelegate:shareInstance];
    self.correctPin = [[NSUserDefaults standardUserDefaults]objectForKey:kAppPassWordKeyNoti];
    pinViewController.promptTitle = @"密码验证";
    pinViewController.promptColor = [UIColor whiteColor];
    pinViewController.view.tintColor = [UIColor whiteColor];
    
    // for a solid background color, use this:
    pinViewController.backgroundColor = [UIColor colorWithRed:0.141f green:0.165f blue:0.208f alpha:1.00f];
    
    // for a translucent background, use this:
    [[NSObject appNaviRootViewController] presentViewController:pinViewController animated:YES completion:^{
        
    }];
}

- (void)applicationDidEnterBackground
{
    [self showPinViewAnimated:NO];
}

#pragma mark - THPinViewControllerDelegate

- (NSUInteger)pinLengthForPinViewController:(THPinViewController *)pinViewController
{
    return 4;
}

- (BOOL)pinViewController:(THPinViewController *)pinViewController isPinValid:(NSString *)pin
{
    if ([pin isEqualToString:self.correctPin]) {
        return YES;
    } else {
        self.remainingPinEntries--;
        return NO;
    }
}

- (BOOL)userCanRetryInPinViewController:(THPinViewController *)pinViewController
{
    //f返回yes可以无限次的验证
    return YES;
}

- (void)incorrectPinEnteredInPinViewController:(THPinViewController *)pinViewController
{
    if (self.remainingPinEntries > 6 / 2) {
        return;
    }
    
}

- (void)pinViewControllerWillDismissAfterPinEntryWasCancelled:(THPinViewController *)pinViewController
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //默认值改变
        [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:kAppPassWordKeyNoti];
        [[NSUserDefaults standardUserDefaults]synchronize];
        //移除后台检测
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:kAppPassWordKeyNoti] isEqualToString:@"NO"]) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification
                                                          object:nil];
        }
    });
}
@end
