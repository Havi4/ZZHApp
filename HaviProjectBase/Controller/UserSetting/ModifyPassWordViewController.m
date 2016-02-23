//
//  ModifyPassWordViewController.m
//  SleepRecoding
//
//  Created by Havi on 15/3/15.
//  Copyright (c) 2015年 Havi. All rights reserved.
//

#import "ModifyPassWordViewController.h"

@interface ModifyPassWordViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) UITextField *oldTextFieldPass;
@property (nonatomic,strong) UITextField *changeTextFieldPass;
@property (nonatomic,strong) UITextField *confirmTextFieldPass;

@end

@implementation ModifyPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backgroundImageView.image = [UIImage imageNamed:@""];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    [self createNavWithTitle:@"修改密码" createMenuItem:^UIView *(int nIndex)
     {
         if (nIndex == 1)
         {
             [self.leftButton addTarget:self action:@selector(backToHomeView:) forControlEvents:UIControlEventTouchUpInside];
             return self.leftButton;
         }
         return nil;
     }];
    // Do any additional setup after loading the view.
    [self setSubView];
}

- (void)setSubView
{
    self.oldTextFieldPass = [[UITextField alloc]init];
    _oldTextFieldPass.borderStyle = UITextBorderStyleNone;
    _oldTextFieldPass.placeholder = @"请输入旧密码";
    _oldTextFieldPass.secureTextEntry = YES;
    _oldTextFieldPass.delegate = self;
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 44)];
    self.oldTextFieldPass.leftView = leftView;
    self.oldTextFieldPass.leftViewMode = UITextFieldViewModeAlways;
    _oldTextFieldPass.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:_oldTextFieldPass];
    
    self.changeTextFieldPass = [[UITextField alloc]init];
    _changeTextFieldPass.borderStyle = UITextBorderStyleNone;
    _changeTextFieldPass.placeholder = @"请输入新密码";
    _changeTextFieldPass.secureTextEntry = YES;
    _changeTextFieldPass.delegate = self;
    UIView *leftView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 44)];
    self.changeTextFieldPass.leftView = leftView1;
    self.changeTextFieldPass.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_changeTextFieldPass];
    
    self.confirmTextFieldPass = [[UITextField alloc]init];
    _confirmTextFieldPass.borderStyle = UITextBorderStyleNone;
    _confirmTextFieldPass.placeholder = @"请确认新密码";
    _confirmTextFieldPass.secureTextEntry = YES;
    _confirmTextFieldPass.delegate = self;
    UIView *leftView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 44)];
    self.confirmTextFieldPass.leftView = leftView2;
    self.confirmTextFieldPass.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_confirmTextFieldPass];
    
    
    [_oldTextFieldPass makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(self.view.mas_top).offset(84);
        make.height.height.equalTo(@44);
    }];
    
    _oldTextFieldPass.layer.borderColor = selectedThemeIndex == 1?kDefaultColor.CGColor:[UIColor lightGrayColor].CGColor;
    _oldTextFieldPass.layer.borderWidth = 1;
    _oldTextFieldPass.layer.cornerRadius = 0;
    
    [_changeTextFieldPass makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(_oldTextFieldPass.mas_bottom).offset(20);
        make.height.height.equalTo(@44);
    }];
    _changeTextFieldPass.layer.borderColor = selectedThemeIndex == 0?kDefaultColor.CGColor:[UIColor colorWithRed:0.447f green:0.765f blue:0.910f alpha:1.00f].CGColor;
    _changeTextFieldPass.layer.borderWidth = 1;
    _changeTextFieldPass.layer.cornerRadius = 0;
    
    [_confirmTextFieldPass makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(_changeTextFieldPass.mas_bottom).offset(10);
        make.height.height.equalTo(@44);
    }];
    _confirmTextFieldPass.layer.borderColor = selectedThemeIndex == 0?kDefaultColor.CGColor:[UIColor colorWithRed:0.447f green:0.765f blue:0.910f alpha:1.00f].CGColor;
    _confirmTextFieldPass.layer.borderWidth = 1;
    _confirmTextFieldPass.layer.cornerRadius = 0;
//
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:selectedThemeIndex==0?kDefaultColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"textbox_devicename_%d",selectedThemeIndex]] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(savePassWord:) forControlEvents:UIControlEventTouchUpInside];
    saveButton.layer.cornerRadius = 0;
    saveButton.layer.masksToBounds = YES;
    [self.view addSubview:saveButton];

    [saveButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(_confirmTextFieldPass.mas_bottom).offset(20);
        make.height.height.equalTo(@44);
    }];
}

- (void)savePassWord:(UIButton *)button
{
    if (self.oldTextFieldPass.text.length == 0) {
        [self.view makeToast:@"请输入旧密码" duration:2 position:@"center"];
        return;
    }
    if (self.changeTextFieldPass.text.length == 0 || self.confirmTextFieldPass.text.length == 0) {
        [self.view makeToast:@"请输入新密码" duration:2 position:@"center"];
        return;
    }
    
    if (![self.changeTextFieldPass.text isEqualToString:self.confirmTextFieldPass.text]) {
        [self.view makeToast:@"新密码输入不一致" duration:2 position:@"center"];
        return;
    }
    [self saveDone];
}

- (void)saveDone
{
    ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
    NSDictionary *dic = @{
                          @"UserID": kUserID, //关键字，必须传递
                          @"Password": self.changeTextFieldPass.text,
                          @"OldPassword":self.oldTextFieldPass.text,//密码
                          };
    [client requestChangeUserInfoParam:dic andBlock:^(BaseModel *resultModel, NSError *error) {
        [self.view makeToast:@"ok" duration:2 position:@"center"];
    }];
    
}

#pragma mark textfield delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ([textField isEqual:self.oldTextFieldPass]) {
        [textField setReturnKeyType:UIReturnKeyNext];
        return YES;
    }else if([textField isEqual:self.changeTextFieldPass]){
        [textField setReturnKeyType:UIReturnKeyNext];
        return YES;
    }else{
        [textField setReturnKeyType:UIReturnKeyDone];
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.oldTextFieldPass]) {
        [self.changeTextFieldPass becomeFirstResponder];
        return YES;
    }else if ([textField isEqual:self.changeTextFieldPass]){
        [self.confirmTextFieldPass becomeFirstResponder];
        return YES;
    }else{
        [textField resignFirstResponder];
        return YES;
    }
    return NO;
}

#pragma mark delegate 隐藏键盘

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (void)backToHomeView:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
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
