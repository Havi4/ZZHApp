//
//  ReactiveSingleViewController.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/18.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "ReactiveSingleViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "AppDelegate.h"
#import "DeviceListViewController.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#include <netdb.h>
#include <net/if.h>
#import <dlfcn.h>
#import "BetaNaoTextField.h"
#import "Sniffer.h"
#import "ProgressView.h"

@interface ReactiveSingleViewController ()<UITextFieldDelegate,EventListener>
{
    Sniffer *sniffer;
    dispatch_queue_t   queue;
    NSInteger   times;
}
@property (nonatomic, strong) SCBarButtonItem *leftBarItem;

@property (nonatomic,strong) BetaNaoTextField *textFiledName;
@property (nonatomic,strong) BetaNaoTextField *textFiledPassWord;
@property (nonatomic, assign) BOOL noReceiveData;
@property (nonatomic,assign) CGFloat keyBoardHeight;


@end

@implementation ReactiveSingleViewController

- (void)viewDidLoad {
    ProgressView *p = [[ProgressView alloc]init];
    p.frame = (CGRect){0,64,self.view.frame.size.width,3};
    [self.view addSubview:p];
    p.selectIndex = 3;
    self.navigationController.navigationBarHidden = YES;
    self.backgroundImageView.image = [UIImage imageNamed:@""];
    [super viewDidLoad];
    sniffer = [[Sniffer alloc]init];
    sniffer.delegate = self;
    //udp启动    //
    self.noReceiveData = YES;
    // Do any additional setup after loading the view.
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
    self.textFiledName.returnKeyType = UIReturnKeyGo;
    self.textFiledName.textLineColor = [UIColor colorWithRed:0.161 green:0.659 blue:0.902 alpha:1.00];
    [self.view addSubview:self.textFiledName];
    self.textFiledPassWord = [[BetaNaoTextField alloc]initWithFrame:(CGRect){10,64,200,80}];
    self.textFiledPassWord.textPlaceHolderColor = [UIColor lightGrayColor];
    self.textFiledPassWord.returnKeyType = UIReturnKeyGo;
    self.textFiledPassWord.textLineColor = [UIColor colorWithRed:0.161 green:0.659 blue:0.902 alpha:1.00];

    self.textFiledPassWord.textPlaceHolder = @"密码";
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
    [lookButton setTitle:@"激活设备" forState:UIControlStateNormal];
    [lookButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lookButton addTarget:self action:@selector(searchHardware:) forControlEvents:UIControlEventTouchUpInside];
    [lookButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@44);
        make.top.mas_lessThanOrEqualTo(showLabel.mas_bottom).offset(24);
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
//    self.textFiledName.text = [self fetchSSIDInfo];

}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.textFiledName reloadTextFieldWithTextString:[self fetchSSIDInfo]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if ([textField isEqual:self.textFiledPassWord]) {
        [self searchHardware:nil];
    }
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
//搜索硬件UDP
- (void)searchHardware:(UIButton *)button
{
    if ([self.textFiledName.text isEqualToString:@""]||[self.textFiledPassWord.text isEqualToString:@""]) {
        [NSObject showHudTipStr:@"请输入网络名或者密码"];
        return;
    }
    ZZHHUDManager *hud = [ZZHHUDManager shareHUDInstance];
    [hud showHUDWithView:kKeyWindow];
    self.noReceiveData = YES;
    NSError *error =[sniffer startSniffer:[self fetchSSIDInfo] password:self.textFiledPassWord.text];
    if (error) {
        ZZHHUDManager *hud = [ZZHHUDManager shareHUDInstance];
        [hud hideHUD];
        [NSObject showStatusBarErrorStr:[NSString stringWithFormat:@"硬件出错了%@",error.localizedDescription]];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(120 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.noReceiveData) {
            [self stopUDPAndAgain];
        }
    });
    //这里是调用不同的硬件设备
}
#pragma mark 江波龙硬件设备配置
//激活设备超时提示
- (void)stopUDPAndAgain
{
    [self stopSniffer];
    self.noReceiveData = NO;
    ZZHHUDManager *hud = [ZZHHUDManager shareHUDInstance];
    [hud hideHUD];
    [NSObject showHudTipStr:@"激活超时,请重试"];
}
//江波龙硬件配置
- (void)getInfo:(NSString*)ip
{
    BOOL isOK = NO;
    
    int  sock = socket(AF_INET, SOCK_DGRAM, 0);
    if (sock != -1)
    {
        int bOptVal= 1;
        if (setsockopt(sock, SOL_SOCKET, SO_BROADCAST, (const char*)&bOptVal, sizeof(int)))
        {
            DeBugLog(@"socket option  SO_BROADCAST not support\n");
            
            close(sock);
            return;
        }
        
        struct timeval tv;
        tv.tv_sec = 2;
        tv.tv_usec = 0;
        if(setsockopt(sock, SOL_SOCKET, SO_RCVTIMEO, &tv, sizeof(tv))<0){
            DeBugLog(@"socket option  SO_RCVTIMEO not support\n");
            close(sock);
            return;
        }
        
        char *findString = "Content-Length:52;{\"cmd\":\"DeviceFind\",\"at\":\"2015-05-18T01:15:43+0800\"}";
        
        char buffer[256] = {0};
        long ret = -1;
        struct sockaddr_in addr;
        unsigned int addr_len =sizeof(struct sockaddr_in);
        /*填写sockaddr_in 结构*/
        bzero ( &addr, sizeof(addr) );
        addr.sin_family=AF_INET;
        addr.sin_port = htons(8000);
        addr.sin_addr.s_addr=inet_addr((char*)[ip UTF8String]) ;
        
        times ++;
        
        ret = sendto(sock, findString, strlen(findString), 0, (struct sockaddr *)&addr, addr_len);
        
        if (ret == -1)
        {
            DeBugLog(@"errno=%i", errno);
            NSString *recString = [NSString stringWithFormat:@"sendto %ld error: %s", times,  strerror(errno)];
            [NSObject showHudTipStr:recString];
            //错误处理 是否再次发送find
        }
        else
        {
            ret = recvfrom(sock, buffer, sizeof(buffer), 0, (struct sockaddr *)&addr, &addr_len);
            if (ret != -1)
            {
                NSString *recString = [NSString stringWithFormat:@"receive %ld:%s",times, buffer];
                DeBugLog(@"设备激活成功%@", recString);
                
                dispatch_async(dispatch_get_main_queue(), ^(){
                    [[MMProgressHUD sharedHUD]setDismissAnimationCompletion:^{
                        [NSObject showHudTipStr:@"设备激活成功"];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }];
                    [MMProgressHUD dismiss];
                });
                //havi
                self.noReceiveData = NO;
                //成功 不再发送find
                isOK = YES;
            }
            else
            {
                NSString *recString = [NSString stringWithFormat:@"recvfrom (%ld) error: %s", (long)times, strerror(errno)];
                dispatch_async(dispatch_get_main_queue(), ^(){
                    [MMProgressHUD dismiss];
                    [NSObject showHudTipStr:recString];
                });
                
                //错误处理 是否再次发送find
            }
        }
        
        
        close(sock);
        
        // 30次之内
        if ((!isOK) && (times < 30))
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), queue, ^{
                [self getInfo:ip];
            });
        }
        if (times>30||times==30) {
            [self stopSniffer];
            [MMProgressHUD dismiss];
            [[MMProgressHUD sharedHUD]setDismissAnimationCompletion:^{
                [NSObject showHudTipStr:@"激活失败"];
            }];
            
        }
    }
    
    
}
//停止配置设备
-(void)stopSniffer{
    //停止配置设备 如果不停止会一直在配置
    [sniffer stopSniffer];
}

#pragma mark 江波龙硬件回调
//设备配置成功 回调函数 获得设备的 ip 地址
- (void)onDeviceOnline:(NSString*)ip{
    [self stopSniffer];
    sniffer = nil;
    //江波龙
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), queue, ^{
        [self getInfo:ip];
    });
}

#pragma mark 江波龙接收

-(void)udpReceiveDataString:(NSString *)string{
    //接收到udp包后，将标识位改为no
    self.noReceiveData = NO;
    ZZHHUDManager *hud = [ZZHHUDManager shareHUDInstance];
    [hud hideHUD];
    [NSObject showHudTipStr:@"激活成功"];
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[DeviceListViewController class]]) {
            
            [self.navigationController popToViewController:controller animated:YES];
            break;
        }
    }
}

- (void)cancelButtonDone:(UIButton *)button
{
    //    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark 键盘事件
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    self.keyBoardHeight = height;
    CGFloat  bottomLine = self.textFiledPassWord.frame.origin.y + self.textFiledPassWord.frame.size.height;
    CGRect rect = self.view.frame;
    rect.origin.y = -self.keyBoardHeight + (rect.size.height - bottomLine);
    if (rect.origin.y<0) {
        self.view.frame = rect;
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGRect rect = self.view.frame;
    rect.origin.y = 0;
    self.view.frame = rect;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
