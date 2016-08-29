//
//  ForgetViewController.m
//  HaviProjectBase
//
//  Created by Havi on 16/8/22.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "ForgetViewController.h"

@interface ForgetViewController ()<UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate>
@property (nonatomic,strong) UITextField *nameText;
@property (nonatomic,strong) UITextField *passWordText;
@property (nonatomic,strong) NSData *iconData;
@property (assign,nonatomic) float yCordinate;
@end


@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //    self.bgImageView.image = [UIImage imageNamed:@"pic_login_bg"];
    
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
    //
    self.nameText = [[UITextField alloc]init];
    [self.view addSubview:self.nameText];
    self.nameText.delegate = self;
    [self.nameText setTextColor:kTextFieldWordColor];
    self.nameText.borderStyle = UITextBorderStyleNone;
    self.nameText.font = kTextFieldWordFont;
    NSDictionary *boldFont = @{NSForegroundColorAttributeName:kTextPlaceHolderColor,NSFontAttributeName:kTextPlaceHolderFont};
    NSAttributedString *attrValue = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:boldFont];
    self.nameText.attributedPlaceholder = attrValue;
    self.nameText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nameText.keyboardType = UIKeyboardTypeAlphabet;
    [self.nameText setReturnKeyType:UIReturnKeyDone];
    self.nameText.secureTextEntry = YES;
    
    self.passWordText = [[UITextField alloc]init];
    [self.view addSubview:self.passWordText];
    self.passWordText.delegate = self;
    [self.passWordText setReturnKeyType:UIReturnKeyDone];
    self.passWordText.textColor = kTextFieldWordColor;
    self.passWordText.borderStyle = UITextBorderStyleNone;
    self.passWordText.font = kTextFieldWordFont;
    NSAttributedString *attrValue1 = [[NSAttributedString alloc] initWithString:@"请确认密码" attributes:boldFont];
    self.passWordText.attributedPlaceholder = attrValue1;
    self.passWordText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passWordText.keyboardType = UIKeyboardTypeAlphabet;
    self.passWordText.secureTextEntry = YES;
    //
    self.nameText.background = [UIImage imageNamed:[NSString stringWithFormat:@"textback"]];
    self.passWordText.background = [UIImage imageNamed:[NSString stringWithFormat:@"textback"]];
    //
    /*
     self.iconButton = [[BTRippleButtton alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"head_placeholder"]]
     andFrame:CGRectMake((self.view.bounds.size.width-100)/2, 84, 100, 100)
     onCompletion:^(BOOL success) {
     [self tapIconImage:nil];
     }];
     
     [self.iconButton setRippeEffectEnabled:YES];
     [self.iconButton setRippleEffectWithColor:[UIColor colorWithRed:0.953f green:0.576f blue:0.420f alpha:1.00f]];
     //    [self.view addSubview:self.iconButton];
     self.iconButton.userInteractionEnabled = YES;
     */
    //
    [self.nameText makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(kButtonViewWidth));
        make.height.equalTo(@49);
        make.centerY.equalTo(self.view.mas_centerY).offset(-22);
        
    }];
    //
    [self.passWordText makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(kButtonViewWidth));
        make.height.equalTo(@49);
        make.centerY.equalTo(self.view.mas_centerY).offset(22);
    }];
    //    添加小图标
    UIImageView *phoneImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"password"]]];
    phoneImage.frame = CGRectMake(0, 0,30, 20);
    phoneImage.contentMode = UIViewContentModeScaleAspectFit;
    self.nameText.leftViewMode = UITextFieldViewModeAlways;
    self.nameText.leftView = phoneImage;
    //
    UIImageView *passImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"password"]]];
    passImage.frame = CGRectMake(0, 0,30, 20);
    passImage.contentMode = UIViewContentModeScaleAspectFit;
    self.passWordText.leftViewMode = UITextFieldViewModeAlways;
    self.passWordText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.passWordText.leftView = passImage;
    //    添加button
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(kButtonViewWidth));
        make.height.equalTo(@0.5);
        make.centerY.equalTo(self.view.mas_centerY);
    }];
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.tag = 9000;
    [registerButton setTitle:@"修改密码" forState:UIControlStateNormal];
    [registerButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"button_background"]] forState:UIControlStateNormal];
    [registerButton setTitleColor:selectedThemeIndex==0?[UIColor whiteColor]:[UIColor whiteColor] forState:UIControlStateNormal];
    registerButton.titleLabel.font = kDefaultWordFont;
    [registerButton addTarget:self action:@selector(registerUser:) forControlEvents:UIControlEventTouchUpInside];
    registerButton.layer.cornerRadius = 5;
    registerButton.layer.masksToBounds = YES;
    [self.view addSubview:registerButton];
    
    //
    //
    [registerButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(kButtonViewWidth));
        make.height.equalTo(@44);
        make.top.equalTo(self.passWordText.mas_bottom).offset(44);
    }];
    
    
}

- (void)registerUser:(UIButton *)sender
{
    if (![self.nameText.text isEqualToString:self.passWordText.text]) {
        [NSObject showHudTipStr:@"密码不一致"];
        return;
    }
    if (self.passWordText.text.length == 0) {
        [NSObject showHudTipStr:@"请输入密码"];
        return;
    }

    ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
    NSDictionary *dic = @{
                          @"UserID": [NSString stringWithFormat:@"%@$%@",kMeddoPlatform,self.phone], //关键字，必须传递
                          @"Password": [NSString stringWithFormat:@"%@",self.nameText.text], //密码
                          };
    [client requestChangeUserInfoParam:dic andBlock:^(BaseModel *resultModel, NSError *error) {
        if (error) {
            [NSObject showHudTipStr:@"出错了"];
            return;
        }
        if ([resultModel.returnCode intValue] == 200) {
            
            [NSObject showHudTipStr:@"密码修改成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
    
}

#pragma mark 拍照


- (void)tapIconImage:(UIGestureRecognizer *)gesture
{
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
        
    }
    
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
        
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self.view];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

#pragma mark delegate 隐藏键盘

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (void)backToHomeView:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
    //    self.backToCodeButtonClicked(1);
}

- (void)keyboardWillShow:(NSNotification *)info
{
    CGRect keyboardBounds = [[[info userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float f =  keyboardBounds.size.height;
    UIButton *login = (UIButton *)[self.view viewWithTag:9000];
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

@end
