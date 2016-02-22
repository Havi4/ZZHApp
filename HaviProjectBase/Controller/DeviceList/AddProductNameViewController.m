//
//  AddProductNameViewController.m
//  SleepRecoding
//
//  Created by Havi_li on 15/3/28.
//  Copyright (c) 2015年 Havi. All rights reserved.
//

#import "AddProductNameViewController.h"
#import "QBarScanViewController.h"

@interface AddProductNameViewController ()<UITextFieldDelegate>
@property (nonatomic,strong) UITextField *productNameTextField;

@end

@implementation AddProductNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    // Do any additional setup after loading the view.
    [self setSubView];
}

- (void)setSubView
{
    self.backgroundImageView.image = [UIImage imageNamed:@""];
    self.view.backgroundColor = [UIColor colorWithRed:0.188f green:0.184f blue:0.239f alpha:1.00f];
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
    backView.layer.borderWidth = 1;
    backView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:backView];
    [backView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(titleLabel.mas_bottom).offset(104);
        make.width.equalTo(@(self.view.frame.size.width-40));
        make.height.equalTo(@200);
    }];
    UILabel *labelCenter = [[UILabel alloc]init];
    labelCenter.text = @"下一步";
    labelCenter.font = [UIFont systemFontOfSize:18];
    labelCenter.textColor = [UIColor whiteColor];
    [backView addSubview:labelCenter];
    [labelCenter makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView);
        make.centerY.equalTo(backView);
        make.height.equalTo(@40);
    }];
    UILabel *label1 = [[UILabel alloc]init];
    label1.textColor = [UIColor whiteColor];
    label1.numberOfLines = 0;
    label1.text = @"1、给设备命名，用来标识您关联的设备。请根据说明书正确摆放设备。";
    [backView addSubview:label1];
    [label1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_top);
        make.bottom.equalTo(labelCenter.mas_top);
        make.left.equalTo(backView).offset(10);
        make.right.equalTo(backView).offset(-10);
    }];
    //
    UILabel *label2 = [[UILabel alloc]init];
    label2.textColor = [UIColor whiteColor];
    label2.numberOfLines = 0;
    label2.text = @"2、请扫描二维码添加设备。";
    [backView addSubview:label2];
    [label2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelCenter.mas_bottom);
        make.left.equalTo(backView).offset(10);
        make.right.equalTo(backView).offset(-100);
    }];

    //
    UIImageView *imageLeft = [[UIImageView alloc]init];
    imageLeft.backgroundColor = [UIColor whiteColor];
    [backView addSubview:imageLeft];
    [imageLeft makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(10);
        make.right.equalTo(labelCenter.mas_left).offset(-10);
        make.centerY.equalTo(labelCenter);
        make.height.equalTo(@1);
    }];
    //
    UIImageView *imageRight = [[UIImageView alloc]init];
    imageRight.backgroundColor = [UIColor whiteColor];
    [backView addSubview:imageRight];
    [imageRight makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelCenter.mas_right).offset(10);
        make.right.equalTo(backView.mas_right).offset(-10);
        make.centerY.equalTo(labelCenter);
        make.height.equalTo(@1);
    }];
    //
    UIImageView *barImage = [[UIImageView alloc]init];
    [backView addSubview:barImage];
    barImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"qr_code_%d",selectedThemeIndex]];
    [barImage makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelCenter.mas_bottom).offset(0);
        make.left.equalTo(label2.mas_right).offset(15);
        make.height.width.equalTo(@60);
    }];
    //
    [self.view addSubview:self.productNameTextField];
    [_productNameTextField makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        if (ISIPHON4) {
            make.bottom.equalTo(backView.mas_top).offset(-10);
        }else{
            make.bottom.equalTo(backView.mas_top).offset(-20);
        }
        make.width.equalTo(backView.mas_width);
        make.height.equalTo(@49);
    }];
    
    //
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:nextButton];
    [nextButton setTitle:@"扫描设备二维码" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(showBarCode:) forControlEvents:UIControlEventTouchUpInside];

    [nextButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"textbox_save_settings_%d",selectedThemeIndex]] forState:UIControlStateNormal];
    nextButton.layer.cornerRadius = 0;
    nextButton.layer.masksToBounds = YES;
    [nextButton.titleLabel setFont:kDefaultWordFont];
    [nextButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        if (ISIPHON4) {
            make.top.equalTo(backView.mas_bottom).offset(20);
        }else{
            make.top.equalTo(backView.mas_bottom).offset(20);
        }
        make.height.equalTo(@49);
        make.width.equalTo(backView.mas_width);
    }];
    //返回
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:backButton];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitle:@"暂时不添加" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backSuperView:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"textbox_hollow_%d",selectedThemeIndex]] forState:UIControlStateNormal];
    [backButton.titleLabel setFont:kDefaultWordFont];
    [backButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        if (ISIPHON4) {
            make.top.equalTo(nextButton.mas_bottom).offset(10);
        }else{
            make.top.equalTo(nextButton.mas_bottom).offset(20);
        }        make.height.equalTo(@49);
        make.width.equalTo(backView.mas_width);
    }];
}

- (UITextField *)productNameTextField
{
    if (!_productNameTextField) {
        _productNameTextField = [[UITextField alloc]init];
        _productNameTextField.borderStyle = UITextBorderStyleNone;
        _productNameTextField.background = [UIImage imageNamed:[NSString stringWithFormat:@"textbox_hollow_%d",selectedThemeIndex]];
        _productNameTextField.backgroundColor = [UIColor clearColor];
        _productNameTextField.layer.cornerRadius = 0;
        NSDictionary *boldFont = @{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:kDefaultWordFont};
        NSAttributedString *attrValue = [[NSAttributedString alloc] initWithString:@"请输入设备名称" attributes:boldFont];
        _productNameTextField.attributedPlaceholder = attrValue;
        _productNameTextField.textColor = [UIColor whiteColor];
        _productNameTextField.textAlignment = NSTextAlignmentCenter;
        _productNameTextField.returnKeyType = UIReturnKeyDone;
        _productNameTextField.delegate = self;
    }
    return _productNameTextField;
}

#pragma mark 用户自定义事件

- (void)showBarCode:(UIButton *)sender
{
    if (_productNameTextField.text.length == 0) {
        [self.view makeToast:@"请输入设备名称" duration:2 position:@"center"];
        return;
    }
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 40;
    style.xScanRetangleOffset = 30;
    
    if ([UIScreen mainScreen].bounds.size.height <= 480 )
    {
        //3.5inch 显示的扫码缩小
        style.centerUpOffset = 40;
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

@end
