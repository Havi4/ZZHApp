//
//  RegisterPhoneViewController.m
//  SleepRecoding
//
//  Created by Havi on 15/8/11.
//  Copyright (c) 2015年 Havi. All rights reserved.
//

#import "RegisterPhoneViewController.h"
#import "GetInavlideCodeApi.h"
#import "AppDelegate.h"

@interface RegisterPhoneViewController ()<UITextFieldDelegate>
{
    int timeToShow;
    
}

@property (nonatomic,strong) UITextField *phoneText;
@property (nonatomic,strong) UITextField *codeText;
@property (nonatomic,strong) UIButton *getCodeButton;
@property (nonatomic,assign) int randomCode;
@end

@implementation RegisterPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createClearBgNavWithTitle:@"补充手机号" createMenuItem:^UIView *(int nIndex) {
        if (nIndex == 1)
        {
            [self.leftButton addTarget:self action:@selector(backToHomeView:) forControlEvents:UIControlEventTouchUpInside];
            return self.leftButton;
        }
        
        return nil;
    }];
    [self creatSubView];
}

- (void)creatSubView
{
    //防止出现键盘
    self.phoneText = [[UITextField alloc]init];
    [self.view addSubview:self.phoneText];
    self.phoneText.delegate = self;
    self.phoneText.dk_textColorPicker = DKColorWithColors(kDefaultColor, [UIColor grayColor]);
    self.phoneText.borderStyle = UITextBorderStyleNone;
    self.phoneText.font = kDefaultWordFont;
    self.phoneText.clearButtonMode = UITextFieldViewModeWhileEditing;
    NSDictionary *boldFont = @{NSForegroundColorAttributeName:selectedThemeIndex==0?kDefaultColor:[UIColor grayColor],NSFontAttributeName:kDefaultWordFont};
    NSAttributedString *attrValue = [[NSAttributedString alloc] initWithString:@"手机号" attributes:boldFont];
    self.phoneText.attributedPlaceholder = attrValue;
    self.phoneText.keyboardType = UIKeyboardTypePhonePad;
    //
    self.codeText = [[UITextField alloc]init];
    [self.view addSubview:self.codeText];
    self.codeText.delegate = self;
    self.codeText.dk_textColorPicker = DKColorWithColors(kDefaultColor, [UIColor grayColor]);
    self.codeText.borderStyle = UITextBorderStyleNone;
    self.codeText.font = kDefaultWordFont;
    NSAttributedString *attrValue1 = [[NSAttributedString alloc] initWithString:@"验证码" attributes:boldFont];
    self.codeText.attributedPlaceholder = attrValue1;
    self.codeText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.codeText.keyboardType = UIKeyboardTypePhonePad;
    //
    [self.phoneText makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.width.equalTo(@(kButtonViewWidth));
        make.height.equalTo(@44);
        make.top.equalTo(self.view.mas_top).offset(84);
        
    }];
    //
    self.phoneText.background = [UIImage imageNamed:[NSString stringWithFormat:@"textbox_password_%d",selectedThemeIndex]];
    self.codeText.background = [UIImage imageNamed:[NSString stringWithFormat:@"textbox_password_%d",selectedThemeIndex]];
    
    UIImageView *nameImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"phone_%d",selectedThemeIndex]]];
    nameImage.frame = CGRectMake(0, 0,30, 20);
    nameImage.contentMode = UIViewContentModeScaleAspectFit;
    self.phoneText.leftViewMode = UITextFieldViewModeAlways;
    self.phoneText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.phoneText.leftView = nameImage;
    //
    [self.codeText makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.height.equalTo(@44);
        make.top.equalTo(self.phoneText.mas_bottom).offset(10);
        
    }];
    UIImageView *codeImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_password_%d",selectedThemeIndex]]];
    codeImage.frame = CGRectMake(0, 0,30, 20);
    codeImage.contentMode = UIViewContentModeScaleAspectFit;
    self.codeText.leftViewMode = UITextFieldViewModeAlways;
    self.codeText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.codeText.leftView = codeImage;
    //
    self.getCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.getCodeButton];
    [self.getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.getCodeButton setTitleColor:selectedThemeIndex==0?kDefaultColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.getCodeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.getCodeButton addTarget:self action:@selector(tapedGetCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.getCodeButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_gain_%d",selectedThemeIndex]] forState:UIControlStateNormal];
    self.getCodeButton.layer.cornerRadius = 0;
    self.getCodeButton.layer.masksToBounds = YES;
    //
    [self.getCodeButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.codeText.mas_centerY);
        make.left.equalTo(self.codeText.mas_right).offset(5);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.equalTo(@44);
        make.width.equalTo(self.codeText.mas_width).multipliedBy(0.5);
    }];
    //
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setBackgroundColor:[UIColor lightGrayColor]];
    nextButton.tag = 1001;
    nextButton.userInteractionEnabled = YES;
    [nextButton setTitle:@"完成" forState:UIControlStateNormal];
    [nextButton setTitleColor:selectedThemeIndex==0?kDefaultColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextButton.titleLabel.font = kDefaultWordFont;
    [nextButton addTarget:self action:@selector(registerUser:) forControlEvents:UIControlEventTouchUpInside];
    nextButton.layer.cornerRadius = 0;
    nextButton.layer.masksToBounds = YES;
    nextButton.userInteractionEnabled = NO;
    [self.view addSubview:nextButton];
    
    //
    [nextButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(kButtonViewWidth));
        make.height.equalTo(@44);
        make.top.equalTo(self.codeText.mas_bottom).offset(20);
    }];
}

- (void)tapedGetCode:(UIButton *)sender
{
    if (self.phoneText.text.length == 0) {
        [NSObject showHudTipStr:@"请输入手机号"];
        return;
    }
    if (self.phoneText.text.length != 11) {
        [NSObject showHudTipStr:@"请输入正确的手机号"];
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
    self.randomCode = [self getRandomNumber:1000 to:10000];
    NSString *codeMessage = [NSString stringWithFormat:@"您的验证码是%d",self.randomCode];
    NSDictionary *dicPara = @{
                              @"cell" : self.phoneText.text,
                              @"codeMessage" : codeMessage,
                              };
    GetInavlideCodeApi *client = [GetInavlideCodeApi shareInstance];
    [client getInvalideCode:dicPara witchBlock:^(NSData *receiveData) {
        NSString *string = [[NSString alloc]initWithData:receiveData encoding:NSUTF8StringEncoding];
        NSRange range = [string rangeOfString:@"<error>"];
        if ([[string substringFromIndex:range.location +range.length]intValue]==0) {
            [MMProgressHUD dismiss];
            [[MMProgressHUD sharedHUD] setDismissAnimationCompletion:^{
                [NSObject showHudTipStr:@"验证码发送成功"];
            }];
            timeToShow = 60;
            [self showTime];
        }else{
            [MMProgressHUD dismiss];
            [[MMProgressHUD sharedHUD] setDismissAnimationCompletion:^{
                [NSObject showHudTipStr:@"验证码发送失败,请稍候重试"];
            }];
        }
    }];
}

- (void)registerUser:(UIButton *)button
{
    if (self.phoneText.text.length == 0) {
        [NSObject showHudTipStr:@"请输入手机号"];
        return;
    }
    if ([self.codeText.text intValue]!=self.randomCode || [self.codeText.text intValue]<999) {
        [NSObject showHudTipStr:@"验证码错误"];
        return;
    }
    [self thirdUserRegister:self.thirdPlatformInfoDic andPlatform:self.platform];
}

- (void)showTime
{
    self.getCodeButton.backgroundColor = [UIColor lightGrayColor];
    self.getCodeButton.userInteractionEnabled = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (timeToShow) {
            timeToShow --;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString *buttonTitle = [NSString stringWithFormat:@"%ds后重发",timeToShow];
                [self.getCodeButton setTitle:buttonTitle forState:UIControlStateNormal];
                if (timeToShow<1) {
                    self.getCodeButton.userInteractionEnabled = YES;
                    self.getCodeButton.backgroundColor = [UIColor colorWithRed:0.259f green:0.718f blue:0.686f alpha:1.00f];
                    [self.getCodeButton setTitle:@"重新发送" forState:UIControlStateNormal];
                }
            });
            sleep(1);
        }
    });
}

-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}

#pragma mark textfeild delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([textField isEqual:self.phoneText]) {
        [textField setReturnKeyType:UIReturnKeyNext];
    }else{
        [textField setReturnKeyType:UIReturnKeyDone];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.phoneText]) {
        [self.codeText becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.randomCode) {
        self.randomCode = 0;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:self.codeText];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:self.phoneText];
}

#pragma mark delegate 隐藏键盘

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:self.codeText];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:self.phoneText];
}

- (void)textFieldChanged:(NSNotification *)noti
{
    UITextField *textField = (UITextField *)noti.object;
    if ([textField isEqual:self.phoneText]) {
        if (self.phoneText.text.length>11) {
            self.phoneText.text = [self.phoneText.text substringToIndex:11];
            [self shake:self.phoneText];
        }
    }else{
        UIButton *button = (UIButton *)[self.view viewWithTag:1001];
        if (self.codeText.text.length == 4) {
            button.userInteractionEnabled = YES;
            [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"textbox_save_settings_%d",selectedThemeIndex]] forState:UIControlStateNormal];
        }else if(self.codeText.text.length > 4){
            self.codeText.text = [self.codeText.text substringToIndex:4];
            [self shake:self.codeText];
        }else if (self.codeText.text.length<4){
            button.userInteractionEnabled = NO;
            [button setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor lightGrayColor];
        }
    }
}

- (void)shake:(UITextField *)textField
{
    textField.layer.transform = CATransform3DMakeTranslation(10.0, 0.0, 0.0);
    [UIView animateWithDuration:0.8 delay:0.0 usingSpringWithDamping:0.2 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
        textField.layer.transform = CATransform3DIdentity;
    } completion:^(BOOL finished) {
        textField.layer.transform = CATransform3DIdentity;
    }];
}

- (void)backToHomeView:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 向我们自己的后台完成注册
- (void)thirdUserRegister:(NSDictionary *)infoDic andPlatform:(NSString*)platform
{
    NSString *thirdID;
    NSString *thirdName;
    if ([platform isEqualToString:kWXPlatform]) {
        thirdName = [infoDic objectForKey:@"nickname"];
    }else if ([platform isEqualToString:kSinaPlatform]){
        thirdName = [infoDic objectForKey:@"name"];
    }else{
        thirdName = [infoDic objectForKey:@"nickname"];
    }
    if ([platform isEqualToString:kWXPlatform]) {
        thirdID = [infoDic objectForKey:@"unionid"];
    }else if ([platform isEqualToString:kSinaPlatform]){
        thirdID = [infoDic objectForKey:@"id"];
    }else{
        thirdID = self.tencentId;
    }
    NSDictionary *dic = @{
                          @"CellPhone": self.phoneText.text, //手机号码
                          @"Email": @"", //邮箱地址，可留空，扩展注册用
                          @"Password": @"" ,//传递明文，服务器端做加密存储
                          @"UserValidationServer" : platform,
                          @"UserIdOriginal":thirdID
                          };
    ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
    [client requestAddUserWithParams:dic andBlock:^(AddUserModel *userModel, NSError *error) {
        if ([userModel.returnCode intValue]==200) {
            thirdPartyLoginPlatform = platform;
            thirdPartyLoginOriginalId = thirdID;//
            thirdPartyLoginUserId = userModel.userId;
            thirdPartyLoginNickName = thirdName;
            thirdPartyLoginToken = @"";
            if ([platform isEqualToString:kWXPlatform]) {
                thirdPartyLoginIcon = [NSString stringWithFormat:@"%@",[self.thirdPlatformInfoDic objectForKey:@"headimgurl"]];
            }else if ([platform isEqualToString:kSinaPlatform]){
                thirdPartyLoginIcon = [NSString stringWithFormat:@"%@",[self.thirdPlatformInfoDic objectForKey:@"avatar_hd"]];
            }else {
                thirdPartyLoginIcon = [NSString stringWithFormat:@"%@",[self.thirdPlatformInfoDic objectForKey:@"figureurl_qq_2"]];
            }
            [UserManager setGlobalOauth];
            AppDelegate *app = [UIApplication sharedApplication].delegate;
            [app setRootViewController];
        }else{
            [NSObject showHudTipStr:[NSString stringWithFormat:@"%@",error]];
        }

    }];
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
