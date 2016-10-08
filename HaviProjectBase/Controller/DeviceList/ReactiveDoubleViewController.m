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
#import "BetaNaoTextField.h"
#import "ProgressView.h"
#import "SliderView.h"

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
@property (nonatomic, strong) SCBarButtonItem *leftBarItem;
@property (nonatomic, strong) SliderView *sliderView;

@property (nonatomic,strong) BetaNaoTextField *textFiledName;
@property (nonatomic,strong) BetaNaoTextField *textFiledPassWord;


@end

@implementation ReactiveDoubleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _sliderView = [[SliderView alloc]init];
    [self.view addSubview:_sliderView];
    ProgressView *p = [[ProgressView alloc]init];
    p.frame = (CGRect){0,64,self.view.frame.size.width,3};
    [self.view addSubview:p];
    p.selectIndex = 3;
    smtlk = [SmartLinkInstance sharedManagerWithDelegate:self];
//    smtlk = [[HFSmtlkV30 alloc]initWithDelegate:self];
    smtlkState= 0;
    showKey= 1;
    macArray=[[NSMutableArray alloc] init];
    self.navigationController.navigationBarHidden = YES;
    // Do any additional setup after loading the view.
    self.backgroundImageView.image = [UIImage imageNamed:@""];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.leftBarItem = [[SCBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_navi_back"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.sc_navigationItem.title = @"网络配置";
    self.sc_navigationItem.leftBarButtonItem = self.leftBarItem;
    //    UILabel *titleLabel = [[UILabel alloc]init];
    //    [self.view addSubview:titleLabel];
    //    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerX.equalTo(self.view.mas_centerX);
    //        make.top.equalTo(self.view).offset(40);
    //        make.height.equalTo(@40);
    //    }];
    //    titleLabel.text = @"激活单人设备";
    //    titleLabel.textColor = [UIColor whiteColor];
    //    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    //
    self.textFiledName = [[BetaNaoTextField alloc]initWithFrame:(CGRect){10,64,200,80}];
    self.textFiledName.textPlaceHolder = @"WiFi名称";
    self.textFiledName.textPlaceHolderColor = [UIColor lightGrayColor];
    self.textFiledName.returnKeyType = UIReturnKeyDone;
    self.textFiledName.userInteractionEnabled = NO;
    self.textFiledName.textLineColor = [UIColor colorWithRed:0.161 green:0.659 blue:0.902 alpha:1.00];

    [self.view addSubview:self.textFiledName];
    self.textFiledPassWord = [[BetaNaoTextField alloc]initWithFrame:(CGRect){10,64,200,80}];
    self.textFiledPassWord.textPlaceHolder = @"密码";
    self.textFiledPassWord.textPlaceHolderColor = [UIColor lightGrayColor];
    self.textFiledPassWord.returnKeyType = UIReturnKeyGo;
    self.textFiledPassWord.textLineColor = [UIColor colorWithRed:0.161 green:0.659 blue:0.902 alpha:1.00];

    [self.view addSubview:self.textFiledPassWord];
    //    self.textFiledName.backgroundColor = [UIColor colorWithRed:0.400f green:0.400f blue:0.400f alpha:1.00f];
    //    self.textFiledPassWord.backgroundColor = [UIColor colorWithRed:0.400f green:0.400f blue:0.400f alpha:1.00f];
    //    self.textFiledName.textColor = [UIColor whiteColor];
    //    self.textFiledPassWord.textColor = [UIColor whiteColor];
    //    self.textFiledName.delegate = self;
    //    self.textFiledPassWord.delegate = self;
    //    self.textFiledName.clearButtonMode = UITextFieldViewModeWhileEditing;
    //    self.textFiledPassWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    //    self.textFiledName.keyboardType = UIKeyboardTypeAlphabet;
    //    self.textFiledPassWord.keyboardType = UIKeyboardTypeAlphabet;
    //    self.textFiledName.background = [UIImage imageNamed:[NSString stringWithFormat:@"textbox_hollow_%d",selectedThemeIndex]];
    //    self.textFiledPassWord.background = [UIImage imageNamed:[NSString stringWithFormat:@"textbox_hollow_%d",selectedThemeIndex]];
    //    //
    //    self.textFiledPassWord.textColor = [UIColor whiteColor];
    //增加左侧的空格
    //    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 44)];
    //    UIView *leftView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 44)];
    //    self.textFiledName.leftViewMode = UITextFieldViewModeAlways;
    //    self.textFiledName.leftView = leftView1;
    //    self.textFiledPassWord.leftView = leftView;
    //    self.textFiledPassWord.leftViewMode = UITextFieldViewModeAlways;
    //    [self.textFiledPassWord makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.view.mas_left).offset(20);
    //        make.right.equalTo(self.view.mas_right).offset(-20);
    //        make.height.equalTo(@44);
    //        make.centerY.equalTo(self.view.mas_centerY).offset(-30);
    //    }];
    self.textFiledPassWord.secureTextEntry = YES;
    
    [self.textFiledName makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(56);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.equalTo(@80);
    }];
    
    
    [self.textFiledPassWord makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.textFiledName.mas_bottom).offset(-8);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.equalTo(@80);
    }];
    
    //
    //    UILabel *passWordLabel = [[UILabel alloc]init];
    //    [self.view addSubview:passWordLabel];
    //    passWordLabel.textColor = [UIColor whiteColor];
    //    passWordLabel.text = @"请输入无线网络密码";
    //    [passWordLabel makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.view.mas_left).offset(20);
    //        make.right.equalTo(self.view.mas_right).offset(-20);
    //        make.height.equalTo(@44);
    //        make.bottom.equalTo(self.textFiledPassWord.mas_top).offset(0);
    //    }];
    //
    //    //
    //
    //    self.textFiledName.text = @"WiFi";
    //    [self.textFiledName makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.view.mas_left).offset(20);
    //        make.right.equalTo(self.view.mas_right).offset(-20);
    //        make.height.equalTo(@44);
    //        make.centerY.equalTo(passWordLabel.mas_centerY).offset(-64);
    //    }];
    //    //
    //    UILabel *nameLabel = [[UILabel alloc]init];
    //    [self.view addSubview:nameLabel];
    //    nameLabel.textColor = [UIColor whiteColor];
    //    nameLabel.text = @"请输入需要的无线网络名称";
    //    [nameLabel makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.view.mas_left).offset(20);
    //        make.right.equalTo(self.view.mas_right).offset(-20);
    //        make.height.equalTo(@44);
    //        make.bottom.equalTo(self.textFiledName.mas_top).offset(5);
    //    }];
    
    //
    UILabel *showLabel = [[UILabel alloc]init];
    [self.view addSubview:showLabel];
    showLabel.textColor = kWhiteBackTextColor;
    showLabel.text = @"1.确保设备处于待配置状态(按一下指示灯后变红)\n\n2.确保手机已连入家庭网络\n\n3.输入正确的Wifi密码";
    showLabel.numberOfLines = 0;
    [showLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.centerY.equalTo(self.view.mas_centerY).offset(16);
    }];
    //
    UIButton *lookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:lookButton];
    [lookButton setBackgroundImage:[UIImage imageNamed:@"button_down_image@3x"] forState:UIControlStateNormal];
    lookButton.layer.cornerRadius = 0;
    lookButton.layer.masksToBounds = YES;
    lookButton.tag = 8000;
    [lookButton setTitle:@"激活设备" forState:UIControlStateNormal];
    [lookButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lookButton addTarget:self action:@selector(searchHardware:) forControlEvents:UIControlEventTouchUpInside];
    [lookButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@44);
        make.top.mas_lessThanOrEqualTo(showLabel.mas_bottom).offset(34);
    }];
    [_sliderView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(showLabel.mas_bottom).offset(5);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.equalTo(@15);
    }];
    //
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:cancelButton];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"button_back_image@3x"] forState:UIControlStateNormal];
    cancelButton.layer.cornerRadius = 0;
    cancelButton.layer.masksToBounds = YES;
    [cancelButton setTitle:@"暂时不激活" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonDone:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitleColor:[UIColor colorWithRed:0.467 green:0.467 blue:0.467 alpha:1.00] forState:UIControlStateNormal];
    [cancelButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@44);
        make.top.equalTo(lookButton.mas_bottom).offset(8);
    }];
    //
    
    //获取wifi的SSID
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.textFiledName reloadTextFieldWithTextString:[self fetchSSIDInfo]];
}

#pragma mark text delegate

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
    return wifiName;
}

- (void)cancelButtonDone:(UIButton *)button
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//搜索硬件UDP
- (void)searchHardware:(UIButton *)button
{
    if ([button.titleLabel.text isEqualToString:@"取消激活"]) {
        [button setTitle:@"激活激活" forState:UIControlStateNormal];
        [self.sliderView stop];
        [self stopSmartLink];
    }else{
        [button setTitle:@"取消激活" forState:UIControlStateNormal];
        if ([self.textFiledName.text isEqualToString:@""]) {
            [NSObject showHudTipStr:@"请输入网络名"];
            return;
        }
        //    ZZHHUDManager *hud = [ZZHHUDManager shareHUDInstance];
        //    [hud showHUDWithView:kKeyWindow];
        [self.sliderView start];
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
}

// do smartLink
- (void)startSmartLink
{
    [smtlk SmtlkV30StartWithKey:self.textFiledPassWord.text];
}

- (void)stopSmartLink
{
    [smtlk SmtlkV30Stop];
//    ZZHHUDManager *hud = [ZZHHUDManager shareHUDInstance];
//    [hud hideHUD];
    UIButton *button = (UIButton *)[self.view viewWithTag:8000];
    [button setTitle:@"激活激活" forState:UIControlStateNormal];
    [self.sliderView stop];
}

- (void)SmtlkTimeOut
{
    if (!isfinding)
    {
        [self stopSmartLink];
        smtlkState= 0;
        [self.sliderView stop];
        UIButton *button = (UIButton *)[self.view viewWithTag:8000];
        [button setTitle:@"激活激活" forState:UIControlStateNormal];
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
//    ZZHHUDManager *hud = [ZZHHUDManager shareHUDInstance];
//    [hud hideHUD];
    [self.sliderView stop];
    [NSObject showHudTipStr:@"激活成功"];
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    DeviceListViewController *controller = [[DeviceListViewController alloc]init];
    delegate.sideMenuController.centerPanel = [[UINavigationController alloc] initWithRootViewController:controller];
    [self cancelButtonDone:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [smtlk SmtlkV30Stop];
    [smtlk SendSmartlinkEnd:@"" moduelIp:@""];
    smtlk = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
