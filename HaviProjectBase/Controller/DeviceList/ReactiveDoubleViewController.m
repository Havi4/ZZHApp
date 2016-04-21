//
//  ReactiveDoubleViewController.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/18.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "ReactiveDoubleViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#include <netdb.h>
#include <net/if.h>
#import <dlfcn.h>
#import "DeviceListViewController.h"
#import "HFSmtlkV30.h"
#import "SmartLinkInstance.h"
#import "DeviceListViewController.h"
#import "UIViewController+JASidePanel.h"
#import "AppDelegate.h"

@interface ReactiveDoubleViewController ()<UITextFieldDelegate>
{
    HFSmtlkV30 *smtlk;
    int smtlkState;
    int showKey;
    NSInteger times;
    NSInteger findTimes;
    BOOL isfinding ;
    NSMutableArray *macArray;
}

@property (nonatomic,strong) UITextField *textFiledName;
@property (nonatomic,strong) UITextField *textFiledPassWord;

@end

@implementation ReactiveDoubleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    smtlk = [SmartLinkInstance sharedManagerWithDelegate:self];
//    smtlk = [[HFSmtlkV30 alloc]initWithDelegate:self];
    smtlkState= 0;
    showKey= 1;
    macArray=[[NSMutableArray alloc] init];
    self.navigationController.navigationBarHidden = YES;
    // Do any additional setup after loading the view.
    self.backgroundImageView.image = [UIImage imageNamed:@""];
    self.view.backgroundColor = [UIColor colorWithRed:0.188f green:0.184f blue:0.239f alpha:1.00f];
    UILabel *titleLabel = [[UILabel alloc]init];
    [self.view addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view).offset(40);
        make.height.equalTo(@40);
    }];
    titleLabel.text = @"激活双人设备";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    //
    self.textFiledName = [[UITextField alloc]init];
    self.textFiledName.borderStyle = UITextBorderStyleNone;
    [self.view addSubview:self.textFiledName];
    self.textFiledPassWord = [[UITextField alloc]init];
    self.textFiledPassWord.borderStyle = UITextBorderStyleNone;
    [self.view addSubview:self.textFiledPassWord];
    self.textFiledName.backgroundColor = [UIColor colorWithRed:0.400f green:0.400f blue:0.400f alpha:1.00f];
    self.textFiledPassWord.backgroundColor = [UIColor colorWithRed:0.400f green:0.400f blue:0.400f alpha:1.00f];
    self.textFiledName.textColor = [UIColor whiteColor];
    self.textFiledPassWord.textColor = [UIColor whiteColor];
    self.textFiledName.delegate = self;
    self.textFiledPassWord.delegate = self;
    self.textFiledName.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textFiledPassWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textFiledName.keyboardType = UIKeyboardTypeAlphabet;
    self.textFiledPassWord.keyboardType = UIKeyboardTypeAlphabet;
    self.textFiledName.background = [UIImage imageNamed:[NSString stringWithFormat:@"textbox_hollow_%d",0]];
    self.textFiledPassWord.background = [UIImage imageNamed:[NSString stringWithFormat:@"textbox_hollow_%d",selectedThemeIndex]];
    //
    self.textFiledPassWord.placeholder = @"请输入密码";
    self.textFiledPassWord.textColor = [UIColor whiteColor];
    //增加左侧的空格
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 44)];
    UIView *leftView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 44)];
    self.textFiledName.leftViewMode = UITextFieldViewModeAlways;
    self.textFiledName.leftView = leftView1;
    self.textFiledPassWord.leftView = leftView;
    self.textFiledPassWord.leftViewMode = UITextFieldViewModeAlways;
    [self.textFiledPassWord makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.equalTo(@44);
        make.centerY.equalTo(self.view.mas_centerY).offset(-30);
    }];
    self.textFiledPassWord.secureTextEntry = YES;
    //
    UILabel *passWordLabel = [[UILabel alloc]init];
    [self.view addSubview:passWordLabel];
    passWordLabel.textColor = [UIColor whiteColor];
    passWordLabel.text = @"请输入无线网络密码";
    [passWordLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.equalTo(@44);
        make.bottom.equalTo(self.textFiledPassWord.mas_top).offset(0);
    }];
    
    //
    
    self.textFiledName.text = @"by001";
    [self.textFiledName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.equalTo(@44);
        make.centerY.equalTo(passWordLabel.mas_centerY).offset(-64);
    }];
    //
    UILabel *nameLabel = [[UILabel alloc]init];
    [self.view addSubview:nameLabel];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.text = @"请输入需要的无线网络名称";
    [nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.equalTo(@44);
        make.bottom.equalTo(self.textFiledName.mas_top).offset(5);
    }];
    
    //
    UILabel *showLabel = [[UILabel alloc]init];
    [self.view addSubview:showLabel];
    showLabel.textColor = [UIColor whiteColor];
    showLabel.text = @"1.在使用前请确保床垫处于工作状态。\n2.请手动输入需要接入的无线网络名称和密码。";
    showLabel.numberOfLines = 0;
    [showLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.centerY.equalTo(self.view.mas_centerY).offset(40);
    }];
    //
    UIButton *lookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:lookButton];
    [lookButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"textbox_save_settings_%d",selectedThemeIndex]] forState:UIControlStateNormal];
    lookButton.layer.cornerRadius = 0;
    lookButton.layer.masksToBounds = YES;
    [lookButton setTitle:@"激活设备" forState:UIControlStateNormal];
    [lookButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lookButton addTarget:self action:@selector(searchHardware:) forControlEvents:UIControlEventTouchUpInside];
    [lookButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@44);
        make.centerY.equalTo(showLabel.mas_centerY).offset(84);
    }];
    //
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:cancelButton];
    [cancelButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"textbox_hollow_%d",selectedThemeIndex]] forState:UIControlStateNormal];
    cancelButton.layer.cornerRadius = 0;
    cancelButton.layer.masksToBounds = YES;
    [cancelButton setTitle:@"暂时不激活" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonDone:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@44);
        make.centerY.equalTo(lookButton.mas_centerY).offset(64);
    }];
    //
    
    //获取wifi的SSID
    [self fetchSSIDInfo];
    
}

#pragma mark text delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//获取ssid
- (NSString *)fetchSSIDInfo {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) { break; }
    }
    NSString *wifiName = [info objectForKey:@"SSID"];
    self.textFiledName.text = wifiName;
    return wifiName;
}

- (void)cancelButtonDone:(UIButton *)button
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//搜索硬件UDP
- (void)searchHardware:(UIButton *)button
{
    if ([self.textFiledName.text isEqualToString:@""]||[self.textFiledPassWord.text isEqualToString:@""]) {
        [NSObject showHudTipStr:@"请输入网络名或者密码"];
        return;
    }
    NSArray *images = @[[UIImage imageNamed:@"havi1_0"],
                        [UIImage imageNamed:@"havi1_1"],
                        [UIImage imageNamed:@"havi1_2"],
                        [UIImage imageNamed:@"havi1_3"],
                        [UIImage imageNamed:@"havi1_4"],
                        [UIImage imageNamed:@"havi1_5"]];
    [[MMProgressHUD sharedHUD] setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithTitle:nil status:nil images:images];
    times= 0;
    smtlkState= 0;
    isfinding = YES;
    [macArray removeAllObjects];
    if (smtlkState== 0)
    {
        
        smtlkState= 1;
        times= 0;
        findTimes= 0;
        [macArray removeAllObjects];
        // start to do smtlk
        [self startSmartLink];
    }
    else
    {
        // stop smtlk
        [self stopSmartLink];
        smtlkState= 0;
        isfinding = NO;
    }
}

// do smartLink
- (void)startSmartLink
{
    [smtlk SmtlkV30StartWithKey:self.textFiledPassWord.text];
}

- (void)stopSmartLink
{
    [smtlk SmtlkV30Stop];
    [MMProgressHUD dismiss];
}

- (void)SmtlkTimeOut
{
    if (!isfinding)
    {
        [self stopSmartLink];
        smtlkState= 0;
        [NSObject showHudTipStr:@"激活超时"];
        return;
    }
    
    [smtlk SendSmtlkFind];
    
}

// SmartLink delegate
- (void)SmtlkV30Finished
{
    if (times < 3)
    {
        NSLog(@"第%ld次",times);
        times++;
        [self startSmartLink];
        findTimes= 0;
        isfinding = YES;
        [self SmtlkTimeOut];
        sleep(1);
    }else{
        isfinding = NO;
        [self stopSmartLink];
        [self SmtlkTimeOut];
    }
}
- (void)SmtlkV30ReceivedRspMAC:(NSString *)mac fromHost:(NSString *)host
{
    NSLog(@"Receive MAC:%@",mac);
    NSLog(@"Receive IP:%@",host);
    isfinding = NO;
    [smtlk SmtlkV30Stop];
    smtlkState = 0;
    times = 0;
    // 让模块停止发送信息。
    [MMProgressHUD dismiss];
    [NSObject showHudTipStr:@"激活成功"];
    [[MMProgressHUD sharedHUD]setDismissAnimationCompletion:^{
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        DeviceListViewController *controller = [[DeviceListViewController alloc]init];
        delegate.sideMenuController.centerPanel = [[UINavigationController alloc] initWithRootViewController:controller];
        [self cancelButtonDone:nil];
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [smtlk SmtlkV30Stop];
    [smtlk SendSmartlinkEnd:@"" moduelIp:@""];
    smtlk = nil;
}
- (void)dealloc
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
