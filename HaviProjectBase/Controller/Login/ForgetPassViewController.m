//
//  ForgetPassViewController.m
//  HaviProjectBase
//
//  Created by Havi on 16/8/22.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "ForgetPassViewController.h"
#import "RegisterViewController.h"
#import "GetInavlideCodeApi.h"
#import "ForgetViewController.h"

@interface ForgetPassViewController ()<UITextFieldDelegate>
{
    int timeToShow;
}

@property (nonatomic,strong) UITextField *phoneText;
@property (nonatomic,strong) UITextField *codeText;
@property (nonatomic,strong) UIButton *getCodeButton;
@property (nonatomic,assign) int randomCode;
@property (assign,nonatomic) float yCordinate;
@end

@implementation ForgetPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    // Do any additional setup after loading the view.
    [self createClearBgNavWithTitle:nil createMenuItem:^UIView *(int nIndex) {
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
    self.phoneText = [[UITextField alloc]init];
    [self.view addSubview:self.phoneText];
    self.phoneText.delegate = self;
    self.phoneText.textColor = selectedThemeIndex==0?[UIColor grayColor]:[UIColor grayColor];
    self.phoneText.borderStyle = UITextBorderStyleNone;
    self.phoneText.font = kTextFieldWordFont;
    self.phoneText.clearButtonMode = UITextFieldViewModeWhileEditing;
    NSDictionary *boldFont = @{NSForegroundColorAttributeName:kTextPlaceHolderColor,NSFontAttributeName:kTextPlaceHolderFont};
    NSAttributedString *attrValue = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:boldFont];
    self.phoneText.attributedPlaceholder = attrValue;
    self.phoneText.keyboardType = UIKeyboardTypePhonePad;
    //
    self.codeText = [[UITextField alloc]init];
    [self.view addSubview:self.codeText];
    self.codeText.delegate = self;
    self.codeText.textColor = selectedThemeIndex==0?[UIColor grayColor]:[UIColor grayColor];
    self.codeText.borderStyle = UITextBorderStyleNone;
    self.codeText.font = kTextFieldWordFont;
    NSAttributedString *attrValue1 = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:boldFont];
    self.codeText.attributedPlaceholder = attrValue1;
    self.codeText.clearButtonMode = UITextFieldViewModeNever;
    self.codeText.keyboardType = UIKeyboardTypePhonePad;
    //
    [self.phoneText makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.width.equalTo(@(kButtonViewWidth));
        make.height.equalTo(@49);
        make.centerY.equalTo(self.view.mas_centerY).offset(-22);
        
    }];
    //
    self.phoneText.background = [UIImage imageNamed:[NSString stringWithFormat:@"textback"]];
    self.codeText.background = [UIImage imageNamed:[NSString stringWithFormat:@"textback"]];
    
    UIImageView *nameImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"phone"]]];
    nameImage.frame = CGRectMake(0, 0,30, 20);
    nameImage.contentMode = UIViewContentModeScaleAspectFit;
    self.phoneText.leftViewMode = UITextFieldViewModeAlways;
    self.phoneText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.phoneText.leftView = nameImage;
    //
    [self.codeText makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.width.equalTo(@(kButtonViewWidth));
        make.height.equalTo(@49);
        make.centerY.equalTo(self.view.mas_centerY).offset(22);
        
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(kButtonViewWidth));
        make.height.equalTo(@0.5);
        make.centerY.equalTo(self.view.mas_centerY);
    }];
    UIImageView *codeImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"password"]]];
    codeImage.frame = CGRectMake(0, 0,30, 20);
    codeImage.contentMode = UIViewContentModeScaleAspectFit;
    self.codeText.leftViewMode = UITextFieldViewModeAlways;
    self.codeText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.codeText.leftView = codeImage;
    //
    self.getCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.codeText addSubview:self.getCodeButton];
    [self.getCodeButton setTitle:@"验证码" forState:UIControlStateNormal];
    [self.getCodeButton setTitleColor:selectedThemeIndex==0?[UIColor whiteColor]:[UIColor whiteColor] forState:UIControlStateNormal];
    self.getCodeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.getCodeButton addTarget:self action:@selector(tapedGetCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.getCodeButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"button_background"]] forState:UIControlStateNormal];
    self.getCodeButton.layer.cornerRadius = 5;
    self.getCodeButton.layer.masksToBounds = YES;
    //
    [self.getCodeButton makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.centerY.equalTo(self.codeText.mas_centerY).offset(1);
        make.right.equalTo(self.codeText.mas_right).offset(-10);
        make.width.equalTo(@65);
    }];
    //
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setBackgroundColor:[UIColor lightGrayColor]];
    nextButton.tag = 1001;
    nextButton.userInteractionEnabled = YES;
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:selectedThemeIndex==0?[UIColor whiteColor]:[UIColor whiteColor] forState:UIControlStateNormal];
    nextButton.titleLabel.font = kDefaultWordFont;
    [nextButton addTarget:self action:@selector(registerUser:) forControlEvents:UIControlEventTouchUpInside];
    nextButton.layer.cornerRadius = 5;
    nextButton.layer.masksToBounds = YES;
    nextButton.userInteractionEnabled = YES;
    [self.view addSubview:nextButton];
    
    //
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"button_background"] forState:UIControlStateNormal];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.titleLabel.font = kDefaultWordFont;
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backToHomeView:) forControlEvents:UIControlEventTouchUpInside];
    backButton.layer.cornerRadius = 5;
    backButton.layer.masksToBounds = YES;
    
    //
    [nextButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(kButtonViewWidth));
        make.height.equalTo(@44);
        make.top.equalTo(self.codeText.mas_bottom).offset(44);
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
    ZZHHUDManager *hud = [ZZHHUDManager shareHUDInstance];
    [hud showHUDWithView:kKeyWindow];

    self.randomCode = [self getRandomNumber:1000 to:10000];
    phoneGetCode = [NSString stringWithFormat:@"%d",self.randomCode];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kCodeValideTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        phoneGetCode = @"";
    });
    NSString *codeMessage = [NSString stringWithFormat:@"您的验证码是%d",self.randomCode];
    NSLog(@"验证码是%@",codeMessage);
    NSDictionary *dicPara = @{
                              @"cell" : self.phoneText.text,
                              @"codeMessage" : codeMessage,
                              };
    GetInavlideCodeApi *client = [GetInavlideCodeApi shareInstance];
    [client getInvalideCode:dicPara witchBlock:^(NSData *receiveData) {
        [hud hideHUD];
        NSString *string = [[NSString alloc]initWithData:receiveData encoding:NSUTF8StringEncoding];
        NSRange range = [string rangeOfString:@"<error>"];
        if ([[string substringFromIndex:range.location +range.length]intValue]==0) {
            [NSObject showHudTipStr:@"验证码发送成功"];
            timeToShow = 60;
            [self showTime];
        }else{
            [NSObject showHudTipStr:@"验证码发送失败,请稍候重试"];
        }
    }];
}

- (void)textFieldChanged:(NSNotification *)noti
{
    UITextField *textField = (UITextField *)noti.object;
    if ([textField isEqual:self.phoneText]) {
        self.randomCode = 000000;
        if (self.phoneText.text.length>11) {
            self.phoneText.text = [self.phoneText.text substringToIndex:11];
            [self shake:self.phoneText];
        }
    }else{
        UIButton *button = (UIButton *)[self.view viewWithTag:1001];
        if (self.codeText.text.length == 4) {
            button.userInteractionEnabled = YES;
            [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"button_background"]] forState:UIControlStateNormal];
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

-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}

- (void)showTime
{
    self.getCodeButton.backgroundColor = [UIColor lightGrayColor];
    self.getCodeButton.userInteractionEnabled = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (timeToShow) {
            timeToShow --;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString *buttonTitle = [NSString stringWithFormat:@"%ds重发",timeToShow];
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

- (void)registerUser:(UIButton *)button
{
    if (self.phoneText.text.length == 0) {
        [NSObject showHudTipStr:@"请输入手机号"];
        return;
    }
    if ([self.codeText.text intValue]!= [phoneGetCode intValue] || [self.codeText.text intValue]<999) {
        [NSObject showHudTipStr:@"验证码错误"];
        return;
    }
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    ForgetViewController *f = [[ForgetViewController alloc]init];
    f.phone = self.phoneText.text;
    [self.navigationController pushViewController:f animated:YES];
}

//- (void)modifyPassWord
//{
//    
//    NSDictionary *dic = @{
//                          @"UserID": [NSString stringWithFormat:@"%@$%@",kMeddoPlatform,self.phoneText], //关键字，必须传递
//                          @"Password": [NSString stringWithFormat:@"%d",self.forgetPassWord], //密码
//                          };
//    ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
//    [client requestChangeUserInfoParam:dic andBlock:^(BaseModel *resultModel, NSError *error) {
//        [NSObject showHudTipStr:@"新的密码已发送到您手机,请查收"];
//        self.passWordText.text = @"";
//    }];
//}

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

- (void)backToHomeView:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)keyboardWillShow:(NSNotification *)info
{
    CGRect keyboardBounds = [[[info userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float f =  keyboardBounds.size.height;
    UIButton *login = (UIButton *)[self.view viewWithTag:1001];
    float y = login.frame.origin.y;
    self.yCordinate = f-(kScreenHeight - y -49);
    self.view.frame = CGRectMake(0, -_yCordinate, self.view.frame.size.width, self.view.frame.size.height);
    
}
- (void)keyboardWillHide:(NSNotification *)info
{
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
