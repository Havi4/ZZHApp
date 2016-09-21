//
//  ModifyPassWordViewController.m
//  SleepRecoding
//
//  Created by Havi on 15/3/15.
//  Copyright (c) 2015年 Havi. All rights reserved.
//

#import "ModifyPassWordViewController.h"
#import "BetaNaoTextField.h"
@interface ModifyPassWordViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) BetaNaoTextField *oldTextFieldPass;
@property (nonatomic,strong) BetaNaoTextField *changeTextFieldPass;
@property (nonatomic,strong) BetaNaoTextField *confirmTextFieldPass;
@property (nonatomic, strong) SCBarButtonItem *leftBarItem;
@end

@implementation ModifyPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backgroundImageView.image = [UIImage imageNamed:@""];
    self.view.backgroundColor = KTableViewBackGroundColor;
    self.navigationController.navigationBarHidden = YES;
    self.leftBarItem = [[SCBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_navi_back"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.sc_navigationItem.title = @"密码修改";
    self.sc_navigationItem.leftBarButtonItem = self.leftBarItem;
    // Do any additional setup after loading the view.
    [self setSubView];
}

- (void)setSubView
{
    self.oldTextFieldPass = [[BetaNaoTextField alloc]init];
    _oldTextFieldPass = [[BetaNaoTextField alloc]init];
    _oldTextFieldPass.frame = CGRectMake(16, -20, kScreenSize.width-32, 80);
    _oldTextFieldPass.textPlaceHolder = @"旧密码";
    _oldTextFieldPass.secureTextEntry = YES;
    _oldTextFieldPass.textPlaceHolderColor = [UIColor lightGrayColor];
    @weakify(self);
    _oldTextFieldPass.returnBlock = ^(BetaNaoTextField *text){
        @strongify(self);
        [self changeReturn:text];
    };
    _oldTextFieldPass.textLineColor = [UIColor colorWithRed:0.161 green:0.659 blue:0.902 alpha:1.00];
    _oldTextFieldPass.returnKeyType = UIReturnKeyNext;
    [self.view addSubview:_oldTextFieldPass];
    
    self.changeTextFieldPass = [[BetaNaoTextField alloc]init];
    _changeTextFieldPass = [[BetaNaoTextField alloc]init];
    _changeTextFieldPass.frame = CGRectMake(16, -20, kScreenSize.width-32, 80);
    _changeTextFieldPass.textPlaceHolder = @"新密码";
    _changeTextFieldPass.textPlaceHolderColor = [UIColor lightGrayColor];
    _changeTextFieldPass.textLineColor = [UIColor colorWithRed:0.161 green:0.659 blue:0.902 alpha:1.00];
    _changeTextFieldPass.returnKeyType = UIReturnKeyNext;
    _changeTextFieldPass.secureTextEntry = YES;
    _changeTextFieldPass.returnBlock = ^(BetaNaoTextField *text){
        @strongify(self);
        [self changeReturn:text];
    };
    [self.view addSubview:_changeTextFieldPass];
    
    self.confirmTextFieldPass = [[BetaNaoTextField alloc]init];
    _confirmTextFieldPass = [[BetaNaoTextField alloc]init];
    _confirmTextFieldPass.frame = CGRectMake(16, -20, kScreenSize.width-32, 80);
    _confirmTextFieldPass.textPlaceHolder = @"重复新密码";
    _confirmTextFieldPass.textPlaceHolderColor = [UIColor lightGrayColor];
    _confirmTextFieldPass.textLineColor = [UIColor colorWithRed:0.161 green:0.659 blue:0.902 alpha:1.00];
    _confirmTextFieldPass.returnKeyType = UIReturnKeyDone;
    _confirmTextFieldPass.returnBlock = ^(BetaNaoTextField *text){
        @strongify(self);
        [self changeReturn:text];
    };
    _confirmTextFieldPass.secureTextEntry = YES;
    [self.view addSubview:_confirmTextFieldPass];
    
    
    [_oldTextFieldPass makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(self.view.mas_top).offset(44);
        make.height.height.equalTo(@80);
    }];
    
    
    [_changeTextFieldPass makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(_oldTextFieldPass.mas_bottom).offset(0);
        make.height.height.equalTo(@80);
    }];
    
    [_confirmTextFieldPass makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(_changeTextFieldPass.mas_bottom).offset(0);
        make.height.height.equalTo(@80);
    }];
//
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:selectedThemeIndex==0?kDefaultColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"button_down_image@3x"] forState:UIControlStateNormal];
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

- (void)changeReturn:(BetaNaoTextField *)text
{
    if ([text isEqual:self.oldTextFieldPass]) {
        [self.changeTextFieldPass becomeFirstResponder];
    }else if ([text isEqual:self.changeTextFieldPass]){
        [self.confirmTextFieldPass becomeFirstResponder];
    }else{
        [text resignFirstResponder];
    }
}

- (void)savePassWord:(UIButton *)button
{
    if (self.oldTextFieldPass.text.length == 0) {
        [NSObject showHudTipStr:@"请输入旧密码"];
        return;
    }
    if (self.changeTextFieldPass.text.length == 0 || self.confirmTextFieldPass.text.length == 0) {
        [NSObject showHudTipStr:@"请输入新密码"];
        return;
    }
    
    if (![self.changeTextFieldPass.text isEqualToString:self.confirmTextFieldPass.text]) {
        [NSObject showHudTipStr:@"新密码输入不一致"];
        return;
    }
    [self saveDone];
}

- (void)saveDone
{
    ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
    NSDictionary *dic = @{
                          @"UserID": thirdPartyLoginUserId, //关键字，必须传递
                          @"Password": self.changeTextFieldPass.text,
                          @"OldPassword":self.oldTextFieldPass.text,//密码
                          };
    [client requestChangeUserInfoParam:dic andBlock:^(BaseModel *resultModel, NSError *error) {
        if ([resultModel.returnCode intValue] == 200) {
            [NSObject showHudTipStr:@"密码修改成功"];
        }
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
