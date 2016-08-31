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
#import "NameDoubleViewController.h"
#import "ReactiveSingleViewController.h"


@interface AddProductNameViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)  UITextField *productNameTextField;
@property (nonatomic,strong)  UITextField *productCodeTextField;

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)setSubView
{
    ProgressView *p = [[ProgressView alloc]init];
    p.frame = (CGRect){0,64,self.view.frame.size.width,2};
    [self.view addSubview:p];
    p.selectIndex = 1;
    self.backgroundImageView.image = [UIImage imageNamed:@""];
    self.leftBarItem = [[SCBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_navi_back"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.sc_navigationItem.title = @"添加设备";
    self.sc_navigationItem.leftBarButtonItem = self.leftBarItem;
    self.view.backgroundColor = [UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1.00];
    UIImageView *deviceImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cp@3x"]];
    [self.view addSubview:deviceImage];
    
    //
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor clearColor];
    backView.tag = 2001;
    [self.view addSubview:backView];
    
    
    UIView *backViewDown = [[UIView alloc]init];
    backViewDown.backgroundColor = [UIColor clearColor];
    backViewDown.tag = 2002;
    [self.view addSubview:backViewDown];
    
    
    [deviceImage makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(deviceImage.mas_width);
        make.top.equalTo(p.mas_bottom);
        make.bottom.equalTo(backView.mas_top).offset(-16);
    }];
    
    [backView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(self.view.frame.size.width-40));
        make.height.equalTo(@44);
        make.bottom.equalTo(backViewDown.mas_top).offset(-10);
    }];
    
    [backViewDown makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(self.view.frame.size.width-40));
        make.height.equalTo(@44);
    }];
    
    UIView *backline = [[UIView alloc]init];
    backline.backgroundColor = [UIColor lightGrayColor];
    backline.alpha = 0.5;
    [backView addSubview:backline];
    [backline makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left);
        make.right.equalTo(backView.mas_right);
        make.bottom.equalTo(backView.mas_bottom);
        make.height.equalTo(@0.5);
    }];
    
    
    UILabel *backTitleLabel = [[UILabel alloc]init];
    backTitleLabel.text = @"设备名:";
    backTitleLabel.font = kDefaultWordFont;
    backTitleLabel.textColor = [UIColor blackColor];
    [backView addSubview:backTitleLabel];
    [backTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left);
        make.height.equalTo(backView.mas_height);
        make.width.equalTo(@80);
        make.centerY.equalTo(backView.mas_centerY);
    }];
    
    [backView addSubview:self.productNameTextField];
    [self.productNameTextField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backTitleLabel.mas_right);
        make.height.equalTo(backView.mas_height);
        make.centerY.equalTo(backTitleLabel.mas_centerY).offset(2);
        make.right.equalTo(backView.mas_right);
    }];
    
    
    UIView *backDownline = [[UIView alloc]init];
    backDownline.backgroundColor = [UIColor lightGrayColor];
    backDownline.alpha = 0.5;
    [backView addSubview:backDownline];
    [backDownline makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backViewDown.mas_left);
        make.right.equalTo(backViewDown.mas_right);
        make.bottom.equalTo(backViewDown.mas_bottom);
        make.height.equalTo(@0.5);
    }];
    
    
    UILabel *backDownTitleLabel = [[UILabel alloc]init];
    backDownTitleLabel.text = @"序列号:";
    backDownTitleLabel.font = kDefaultWordFont;
    backDownTitleLabel.textColor = [UIColor blackColor];
    [backViewDown addSubview:backDownTitleLabel];
    [backDownTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backViewDown.mas_left);
        make.height.equalTo(backViewDown.mas_height);
        make.width.equalTo(@80);
        make.centerY.equalTo(backViewDown.mas_centerY);
    }];
    
    [backViewDown addSubview:self.productCodeTextField];
    [self.productCodeTextField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backDownTitleLabel.mas_right);
        make.height.equalTo(backViewDown.mas_height);
        make.centerY.equalTo(backDownTitleLabel.mas_centerY).offset(2);
    }];

    
    UIButton *scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanButton setImage:[UIImage imageNamed:@"erweim@3x"] forState:UIControlStateNormal];
    [scanButton addTarget:self action:@selector(showBarCode:) forControlEvents:UIControlEventTouchUpInside];
    [backViewDown addSubview:scanButton];
    [scanButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backViewDown.mas_centerY).offset(0);
        make.height.width.equalTo(@30);
        make.left.equalTo(self.productCodeTextField.mas_right);
        make.right.equalTo(backViewDown.mas_right);
    }];
    //
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:nextButton];
    [nextButton setTitle:@"添加设备" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(checkIsDoubleBed:) forControlEvents:UIControlEventTouchUpInside];

    [nextButton setBackgroundImage:[UIImage imageNamed:@"button_down_image@3x"] forState:UIControlStateNormal];
    nextButton.layer.cornerRadius = 0;
    nextButton.layer.masksToBounds = YES;
    [nextButton.titleLabel setFont:kDefaultWordFont];
    [nextButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.lessThanOrEqualTo(backViewDown.mas_bottom).offset(40);
        make.height.equalTo(@44);
        make.width.equalTo(backView.mas_width);
    }];
    //返回
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:backButton];
    [backButton setTitleColor:[UIColor colorWithRed:0.718 green:0.718 blue:0.718 alpha:1.00] forState:UIControlStateNormal];
    [backButton setTitle:@"暂不添加" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backSuperView:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"button_back_image@3x"] forState:UIControlStateNormal];
    [backButton.titleLabel setFont:kDefaultWordFont];
    [backButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(nextButton.mas_bottom).offset(10);
        make.height.equalTo(@44);
        make.width.equalTo(backView.mas_width);
        make.bottom.equalTo(self.view.mas_bottom).offset(-26);
    }];
}

- (UITextField *)productNameTextField
{
    if (!_productNameTextField) {
        NSDictionary *boldFont = @{NSForegroundColorAttributeName:kTextPlaceHolderColor,NSFontAttributeName:kTextPlaceHolderFont};
        NSAttributedString *attrValue = [[NSAttributedString alloc] initWithString:@"请输入设备名称" attributes:boldFont];

        _productNameTextField = [[UITextField alloc]initWithFrame:(CGRect){10,80,200,60}];
        _productNameTextField.attributedPlaceholder = attrValue;
        _productNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _productNameTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    }
    return _productNameTextField;
}

- (UITextField *)productCodeTextField
{
    if (!_productCodeTextField) {
        NSDictionary *boldFont = @{NSForegroundColorAttributeName:kTextPlaceHolderColor,NSFontAttributeName:kTextPlaceHolderFont};
        NSAttributedString *attrValue = [[NSAttributedString alloc] initWithString:@"请输入设备序列号" attributes:boldFont];
        _productCodeTextField = [[UITextField alloc]initWithFrame:(CGRect){10,80,200,60}];
        _productCodeTextField.attributedPlaceholder = attrValue;
        _productCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _productCodeTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    }
    return _productCodeTextField;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark 用户自定义事件

- (void)showBarCode:(UIButton *)sender
{
//    if (_productNameTextField.text.length == 0) {
//        [NSObject showHudTipStr:@"请输入设备名称"];
//        return;
//    }
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
    [self.productCodeTextField resignFirstResponder];
    [self.productNameTextField resignFirstResponder];
    QBarScanViewController *vc = [QBarScanViewController new];
    vc.style = style;
    vc.isOpenInterestRect = YES;
    vc.isQQSimulator = YES;
    vc.deviceDescription = self.productNameTextField.text;
    vc.barcodeDetected = ^(NSString *barcode){
        self.productCodeTextField.text = barcode;
    };
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

- (void)keyboardWillShow:(NSNotification *)info
{
    CGRect keyboardBounds = [[[info userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float f =  keyboardBounds.size.height;
    UIView *backView = [self.view viewWithTag:2002];
    float y = backView.frame.origin.y;
    self.yCordinate = f-(kScreenHeight - y -49);
    self.view.frame = CGRectMake(0, -_yCordinate, self.view.frame.size.width, self.view.frame.size.height);
    
}
- (void)keyboardWillHide:(NSNotification *)info
{
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

//new magic

#pragma mark 检测设备是不是双人的

- (void)checkIsDoubleBed:(NSString *)deviceUUID
{
    if (self.productNameTextField.text.length == 0) {
        [NSObject showHudTipStr:@"请输入设备名称"];
        return;
    }
    if (self.productCodeTextField.text.length == 0) {
        [NSObject showHudTipStr:@"请输入设备序列号"];
        return;
    }
    
    deviceUUID = self.productCodeTextField.text;
    NSDictionary *para = @{
                           @"UUID": deviceUUID,
                           };
    @weakify(self);
    ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
    [client requestCheckSensorInfoParams:para andBlcok:^(SensorInfoModel *sensorModel, NSError *error) {
        @strongify(self);
        if (sensorModel) {
            if (sensorModel.sensorDetail.detailSensorInfoList.count == 0) {
                [self bindingDeviceWithUUID:deviceUUID];
            }else{
                NameDoubleViewController *doubleBed = [[NameDoubleViewController alloc]init];
                doubleBed.barUUIDString = deviceUUID;
//                doubleBed.doubleDeviceName = self.deviceDescription;
                doubleBed.dicDetailDevice = sensorModel.sensorDetail.detailSensorInfoList;
                [self.navigationController pushViewController:doubleBed animated:YES];
            }
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self reStartDevice];
            });
        }
    }];
    
}

#pragma mark 绑定

- (void)bindingDeviceWithUUID:(NSString *)uuid
{
//    ReactiveSingleViewController *doubleUDP = [[ReactiveSingleViewController alloc]init];
//    [self.navigationController pushViewController:doubleUDP animated:YES];
    
     NSDictionary *dic13 = @{
         @"UserID": thirdPartyLoginUserId,
         @"UUID": uuid,
         @"Description":self.productNameTextField.text,
     };
     ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
     @weakify(self);
     [client requestUserBindingDeviceParams:dic13 andBlock:^(BaseModel *resultModel, NSError *error) {
         @strongify(self);
         if (resultModel) {
             [self activeUserDefaultDevice:uuid];
         }else{
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                 [self reStartDevice];
             });
         }
     }];
}

#pragma mark 切换默认设备

- (void)activeUserDefaultDevice:(NSString *)UUID
{
    NSDictionary *dic14 = @{
                            @"UserID": thirdPartyLoginUserId,
                            @"UUID": UUID,
                            };
    ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
    
    [client requestActiveMyDeviceParams:dic14 andBlock:^(BaseModel *resultModel, NSError *error) {
        if (resultModel) {
            
            @weakify(self);
            [LBXAlertAction showAlertWithTitle:@"绑定成功" msg:@"您已经成功绑定该设备，是否现在激活？" chooseBlock:^(NSInteger buttonIdx) {
                @strongify(self);
                //点击完，继续扫码
                switch (buttonIdx) {
                    case 0:{
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        break;
                    }
                    case 1:{
                        ReactiveSingleViewController *doubleUDP = [[ReactiveSingleViewController alloc]init];
                        [self.navigationController pushViewController:doubleUDP animated:YES];
                        break;
                    }
                        
                    default:
                        break;
                }
//                [self reStartDevice];
            } buttonsStatement:@"稍后激活",@"现在激活",nil];
        }
    }];
}


@end
