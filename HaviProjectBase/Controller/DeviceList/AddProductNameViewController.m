//
//  AddProductNameViewController.m
//  SleepRecoding
//
//  Created by Havi_li on 15/3/28.
//  Copyright (c) 2015年 Havi. All rights reserved.
//

#import "AddProductNameViewController.h"
#import "QBarScanViewController.h"
#import "BetaNaoTextField.h"
#import "ProgressView.h"

@interface AddProductNameViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)  BetaNaoTextField *productNameTextField;
@property (nonatomic, strong) SCBarButtonItem *leftBarItem;
@property (assign,nonatomic) float yCordinate;

@end

@implementation AddProductNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    // Do any additional setup after loading the view.
    [self setSubView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)setSubView
{
    ProgressView *p = [[ProgressView alloc]init];
    p.frame = (CGRect){0,64,self.view.frame.size.width,3};
    [self.view addSubview:p];
    p.selectIndex = 1;
    self.backgroundImageView.image = [UIImage imageNamed:@""];
    self.leftBarItem = [[SCBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_navi_back"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.sc_navigationItem.title = @"添加设备名称";
    self.sc_navigationItem.leftBarButtonItem = self.leftBarItem;
    self.view.backgroundColor = [UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1.00];
    UILabel *titleLabel = [[UILabel alloc]init];
    [self.view addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view).offset(20);
        make.height.equalTo(@44);
    }];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"添加设备名称";
    titleLabel.textColor = [UIColor whiteColor];
    //
    UIView *backView = [[UIView alloc]init];
    backView.tag = 2001;
    [self.view addSubview:backView];
    [backView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.width.equalTo(@(self.view.frame.size.width-40));
        make.height.equalTo(@200);
    }];
    UILabel *label1 = [[UILabel alloc]init];
    label1.textColor = [UIColor colorWithRed:0.467 green:0.467 blue:0.467 alpha:1.00];
    label1.numberOfLines = 0;
    label1.text = @"1、给设备命名，用来标识您关联的设备。请根据说明书正确摆放设备。";
    [backView addSubview:label1];
    [label1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(0);
        make.right.equalTo(backView).offset(0);
        make.centerY.equalTo(backView.mas_centerY).offset(-40);
    }];
    //
    UILabel *label2 = [[UILabel alloc]init];
    label2.textColor = [UIColor colorWithRed:0.467 green:0.467 blue:0.467 alpha:1.00];
    label2.numberOfLines = 0;
    label2.text = @"2、请扫描设备码添加设备。";
    [backView addSubview:label2];
    [label2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(0);
        make.right.equalTo(backView).offset(-100);
        make.centerY.equalTo(backView.mas_centerY).offset(24);
    }];

    //
    UIImageView *imageLeft = [[UIImageView alloc]init];
    imageLeft.backgroundColor = [UIColor whiteColor];
//    [backView addSubview:imageLeft];
//    [imageLeft makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(backView).offset(10);
//        make.right.equalTo(labelCenter.mas_left).offset(-10);
//        make.centerY.equalTo(labelCenter);
//        make.height.equalTo(@1);
//    }];
    //
    //
//    UIImageView *barImage = [[UIImageView alloc]init];
//    [backView addSubview:barImage];
//    barImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"qr_code_%d",selectedThemeIndex]];
//    [barImage makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(labelCenter.mas_bottom).offset(0);
//        make.left.equalTo(label2.mas_right).offset(15);
//        make.height.width.equalTo(@60);
//    }];
    //
    [self.view addSubview:self.productNameTextField];
    [_productNameTextField makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(64);
        make.width.equalTo(backView.mas_width);
        make.height.equalTo(@80);
    }];
    
    //
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:nextButton];
    nextButton.tag = 2000;
    [nextButton setTitle:@"扫描设备码" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(showBarCode:) forControlEvents:UIControlEventTouchUpInside];

    [nextButton setBackgroundImage:[UIImage imageNamed:@"button_down_image@3x"] forState:UIControlStateNormal];
    nextButton.layer.cornerRadius = 0;
    nextButton.layer.masksToBounds = YES;
    [nextButton.titleLabel setFont:kDefaultWordFont];
    [nextButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        if (ISIPHON4) {
            make.top.lessThanOrEqualTo(backView.mas_bottom).offset(20);
        }else{
            make.top.lessThanOrEqualTo(backView.mas_bottom).offset(20);
        }
        make.height.equalTo(@44);
        make.width.equalTo(backView.mas_width);
    }];
    //返回
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:backButton];
    [backButton setTitleColor:[UIColor colorWithRed:0.718 green:0.718 blue:0.718 alpha:1.00] forState:UIControlStateNormal];
    [backButton setTitle:@"暂时不添加" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backSuperView:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"button_back_image@3x"] forState:UIControlStateNormal];
    [backButton.titleLabel setFont:kDefaultWordFont];
    [backButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        if (ISIPHON4) {
            make.top.equalTo(nextButton.mas_bottom).offset(10);
        }else{
            make.top.equalTo(nextButton.mas_bottom).offset(20);
        }        make.height.equalTo(@44);
        make.width.equalTo(backView.mas_width);
    }];
}

- (BetaNaoTextField *)productNameTextField
{
    if (!_productNameTextField) {
        _productNameTextField = [[BetaNaoTextField alloc]initWithFrame:(CGRect){10,80,200,60}];
        _productNameTextField.textPlaceHolder = @"输入设备名称";
        _productNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _productNameTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    }
    return _productNameTextField;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.productNameTextField.text = @"";
    [self.productNameTextField resignFirstResponder];
}

#pragma mark 用户自定义事件

- (void)showBarCode:(UIButton *)sender
{
    if (_productNameTextField.text.length == 0) {
        [NSObject showHudTipStr:@"请输入设备名称"];
        return;
    }
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 20;
    style.xScanRetangleOffset = 30;
    
    if ([UIScreen mainScreen].bounds.size.height <= 480 )
    {
        //3.5inch 显示的扫码缩小
        style.centerUpOffset = 20;
        style.xScanRetangleOffset = 20;
    }
    
    
    style.alpa_notRecoginitonArea = 0.6;
    
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
    style.photoframeLineW = 2.0;
    style.photoframeAngleW = 16;
    style.photoframeAngleH = 16;
    
    style.isNeedShowRetangle = NO;
    
    style.anmiationStyle = LBXScanViewAnimationStyle_NetGrid;
    
    //使用的支付宝里面网格图片
    UIImage *imgFullNet = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_full_net"];
    
    
    style.animationImage = imgFullNet;
    
    
    [self openScanVCWithStyle:style];
    
}

- (void)openScanVCWithStyle:(LBXScanViewStyle*)style
{
    QBarScanViewController *vc = [QBarScanViewController new];
    vc.style = style;
    vc.isOpenInterestRect = YES;
    vc.isQQSimulator = YES;
    vc.deviceDescription = self.productNameTextField.text;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)backSuperView:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.productNameTextField]) {
        [textField resignFirstResponder];
    }
    return YES;
}
#pragma mark 点击背景隐藏键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

//- (void)keyboardWillShow:(NSNotification *)info
//{
//    CGRect keyboardBounds = [[[info userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    float f =  keyboardBounds.size.height;
//    UIButton *login = (UIButton *)[self.view viewWithTag:2000];
//    float y = login.frame.origin.y;
//    self.yCordinate = y-(f-kScreenHeight + y)-49;
//    [login updateConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo([NSNumber numberWithFloat:_yCordinate]).offset(0);
//    }];
//    
//}
//- (void)keyboardWillHide:(NSNotification *)info
//{
//    UIButton *login = (UIButton *)[self.view viewWithTag:2000];
//    UIView *backView = (UIView *)[self.view viewWithTag:2001];
//    login.frame = (CGRect){100,100,49,90};
//    [login updateConstraints:^(MASConstraintMaker *make) {
//        if (ISIPHON4) {
//            make.top.equalTo(backView.mas_bottom).offset(20);
//        }else{
//            make.top.equalTo(backView.mas_bottom).offset(20);
//        }
//    }];
//}

@end
