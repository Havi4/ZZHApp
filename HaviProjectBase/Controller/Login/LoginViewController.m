//
//  LoginViewController.m
//  SleepRecoding
//
//  Created by Havi_li on 15/3/16.
//  Copyright (c) 2015年 Havi. All rights reserved.
//

#import "LoginViewController.h"
#import "CKTextField.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "LabelLine.h"
#import "AppDelegate.h"
#import "GetInavlideCodeApi.h"
#import "GetCodeViewController.h"
#import "ThirdLoginCallBackManager.h"
#import "APService.h"

@interface LoginViewController ()<UITextFieldDelegate,WXApiDelegate>
@property (nonatomic,strong) CKTextField *nameText;
@property (nonatomic,strong) UITextField *passWordText;

@property (nonatomic,strong)  NSString *cellPhone;
@property (assign,nonatomic)  int forgetPassWord;
//@property (nonatomic,strong) RegisterPhoneViewController *phoneView;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //接受消息，弹出输入电话号码
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showPhoneInputView) name:ShowPhoneInputViewNoti object:nil];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    int picIndex = [ThemeSelectConfigureObj defaultConfigure].nThemeIndex;
    NSString *imageName = [NSString stringWithFormat:@"icon_logo_login_%d",picIndex];
    UIImageView *logoImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    [self.view addSubview:logoImage];
    self.nameText = [[CKTextField alloc]init];
    [self.nameText setMaxLength:@"11"];
    [self.view addSubview:self.nameText];
    self.passWordText = [[UITextField alloc]init];
    [self.view addSubview:self.passWordText];
    self.nameText.delegate = self;
    self.passWordText.delegate = self;
    [self.nameText setTextColor:selectedThemeIndex==0?kDefaultColor:[UIColor grayColor]];
    self.passWordText.textColor = selectedThemeIndex==0?kDefaultColor:[UIColor grayColor];
    self.nameText.borderStyle = UITextBorderStyleNone;
    self.passWordText.borderStyle = UITextBorderStyleNone;
    self.nameText.font = kDefaultWordFont;
    self.passWordText.font = kDefaultWordFont;
    
    NSDictionary *boldFont = @{NSForegroundColorAttributeName:selectedThemeIndex==0?kDefaultColor:[UIColor grayColor],NSFontAttributeName:kDefaultWordFont};
    NSAttributedString *attrValue = [[NSAttributedString alloc] initWithString:@"电话号码" attributes:boldFont];
    NSAttributedString *attrValue1 = [[NSAttributedString alloc] initWithString:@"密码" attributes:boldFont];
    self.nameText.attributedPlaceholder = attrValue;
    self.passWordText.attributedPlaceholder = attrValue1;
    if (thirdMeddoPhone) {
        self.nameText.text = thirdMeddoPhone;
    }
    if (thirdMeddoPassWord) {
        self.passWordText.text = thirdMeddoPassWord;
    }
    self.nameText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passWordText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nameText.keyboardType = UIKeyboardTypeNumberPad;
    self.passWordText.keyboardType = UIKeyboardTypeAlphabet;
    self.passWordText.secureTextEntry = YES;
    //
    self.passWordText.background = [UIImage imageNamed:[NSString stringWithFormat:@"textbox_password_%d",selectedThemeIndex]];
    self.nameText.background = [UIImage imageNamed:[NSString stringWithFormat:@"textbox_password_%d",selectedThemeIndex]];
//
    int padding = (self.view.bounds.size.height/2 - 200)/3;
    [logoImage makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.nameText.mas_top).offset(-padding);
        make.height.width.equalTo(@100);
    }];
//
    [self.nameText makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(kButtonViewWidth));
        make.height.equalTo(@49);
        make.centerY.equalTo(self.passWordText.mas_centerY).offset(-54);
        
    }];
//    
    [self.passWordText makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(kButtonViewWidth));
        make.height.equalTo(@49);
        make.centerY.equalTo(self.view.mas_centerY).offset(-32);
    }];
//
//    添加小图标
    UIImageView *phoneImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"phone_%d",selectedThemeIndex]]];
    phoneImage.frame = CGRectMake(0, 0,30, 20);
    phoneImage.contentMode = UIViewContentModeScaleAspectFit;
    self.nameText.leftViewMode = UITextFieldViewModeAlways;
    self.nameText.leftView = phoneImage;
//
    UIImageView *passImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_password_%d",selectedThemeIndex]]];
    passImage.frame = CGRectMake(0, 0,30, 20);
    passImage.contentMode = UIViewContentModeScaleAspectFit;
    self.passWordText.leftViewMode = UITextFieldViewModeAlways;
    self.passWordText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.passWordText.leftView = passImage;
    
//    添加button
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"textbox_devicename_%d",selectedThemeIndex]] forState:UIControlStateNormal];
    [loginButton setTitle:@"登 录" forState:UIControlStateNormal];
    [loginButton setTitleColor:selectedThemeIndex==0?kDefaultColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.titleLabel.font = kDefaultWordFont;
    [loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    loginButton.layer.cornerRadius = 0;
    loginButton.layer.masksToBounds = YES;
    [self.view addSubview:loginButton];
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"textbox_hollow_%d",selectedThemeIndex]] forState:UIControlStateNormal];
    registerButton.tag = 10001;
    [registerButton setTitle:@"还没有帐号" forState:UIControlStateNormal];
    registerButton.titleLabel.font = kDefaultWordFont;
    [registerButton setTitleColor:selectedThemeIndex==0?kDefaultColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(registerButton:) forControlEvents:UIControlEventTouchUpInside];
    registerButton.layer.cornerRadius = 0;
    registerButton.layer.masksToBounds = YES;
    [self.view addSubview:registerButton];
    
//
    [loginButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(kButtonViewWidth));
        make.height.equalTo(@49);
        make.centerY.equalTo(self.view.mas_centerY).offset(32);
    }];
    
    [registerButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(kButtonViewWidth));
        make.height.equalTo(@49);
        make.centerY.equalTo(loginButton.mas_centerY).offset(54);
    }];
//
    LabelLine *forgetButton = [[LabelLine alloc]init];
    forgetButton.text = @"忘记密码?";
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(forgetPassWord:)];
    forgetButton.userInteractionEnabled = YES;
    [forgetButton addGestureRecognizer:tap];
    forgetButton.backgroundColor = [UIColor clearColor];
    forgetButton.font = kDefaultWordFont;
    forgetButton.textColor = selectedThemeIndex==0?kDefaultColor:[UIColor whiteColor];
    [self.view addSubview:forgetButton];
    [forgetButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(registerButton.mas_bottom).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-20);
    }];
    //第三方登录
    UILabel *thirdLoginLabel = [[UILabel alloc]init];
    if ([WXApi isWXAppInstalled]||[WeiboSDK isWeiboAppInstalled]||[TencentOAuth iphoneQQInstalled]) {
        
        [self.view addSubview:thirdLoginLabel];
        thirdLoginLabel.text = @"其他登录方式";
        thirdLoginLabel.font = [UIFont systemFontOfSize:15];
        thirdLoginLabel.textColor = selectedThemeIndex==0?kDefaultColor:[UIColor whiteColor];
        [thirdLoginLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(forgetButton.mas_bottom).offset(0);
            make.height.equalTo(@40);
        }];
        UIView *leftLineView = [[UIView alloc]init];
        [self.view addSubview:leftLineView];
        leftLineView.backgroundColor = selectedThemeIndex==0?kDefaultColor:[UIColor whiteColor];
        [leftLineView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(thirdLoginLabel.mas_centerY);
            make.height.equalTo(@0.5);
            make.left.equalTo(self.view.mas_left).offset(15);
            make.right.equalTo(thirdLoginLabel.mas_left).offset(-15);
        }];
        
        UIView *rightLineView = [[UIView alloc]init];
        [self.view addSubview:rightLineView];
        rightLineView.backgroundColor = selectedThemeIndex==0?kDefaultColor:[UIColor whiteColor];
        [rightLineView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(thirdLoginLabel.mas_centerY);
            make.height.equalTo(@0.5);
            make.left.equalTo(thirdLoginLabel.mas_right).offset(15);
            make.right.equalTo(self.view.mas_right).offset(-15);
        }];
        //
    }
    float centerfriend = self.view.frame.size.width/4;
    if ([WeiboSDK isWeiboAppInstalled]&&[WXApi isWXAppInstalled]&&![TencentOAuth iphoneQQInstalled]) {
        UIButton *weixinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:weixinButton];
        [weixinButton addTarget:self action:@selector(weixinButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
        [weixinButton setBackgroundImage:[UIImage imageNamed:@"weixin"] forState:UIControlStateNormal];
        [weixinButton makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(weixinButton.mas_width);
            make.height.equalTo(@60);
            make.top.equalTo(thirdLoginLabel.mas_bottom).offset(10);
            make.centerX.equalTo(self.view.mas_centerX).offset(-centerfriend);
        }];
        
        UIButton *sinaButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sinaButton addTarget:self action:@selector(sinaButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:sinaButton];
        [sinaButton setBackgroundImage:[UIImage imageNamed:@"sina"] forState:UIControlStateNormal];
        float centerfriend = self.view.frame.size.width/4;
        [sinaButton makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(sinaButton.mas_width);
            make.height.equalTo(@60);
            make.top.equalTo(thirdLoginLabel.mas_bottom).offset(10);
            make.centerX.equalTo(self.view.mas_centerX).offset(centerfriend);
        }];


    }else if ([WeiboSDK isWeiboAppInstalled]&&[TencentOAuth iphoneQQInstalled]&&![WXApi isWXAppInstalled]){
        UIButton *sinaButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sinaButton addTarget:self action:@selector(sinaButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:sinaButton];
        [sinaButton setBackgroundImage:[UIImage imageNamed:@"sina"] forState:UIControlStateNormal];
        float centerfriend = self.view.frame.size.width/4;
        [sinaButton makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(sinaButton.mas_width);
            make.height.equalTo(@60);
            make.top.equalTo(thirdLoginLabel.mas_bottom).offset(10);
            make.centerX.equalTo(self.view.mas_centerX).offset(centerfriend);
        }];
        
        UIButton *qqButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:qqButton];
        [qqButton addTarget:self action:@selector(qqButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
        [qqButton setBackgroundImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
        [qqButton makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(qqButton.mas_width);
            make.height.equalTo(@60);
            make.top.equalTo(thirdLoginLabel.mas_bottom).offset(10);
            make.centerX.equalTo(self.view.mas_centerX).offset(-centerfriend);
        }];
    }else if ([WXApi isWXAppInstalled]&&[TencentOAuth iphoneQQInstalled]&&![WeiboSDK isWeiboAppInstalled]){
        UIButton *weixinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:weixinButton];
        [weixinButton addTarget:self action:@selector(weixinButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
        [weixinButton setBackgroundImage:[UIImage imageNamed:@"weixin"] forState:UIControlStateNormal];
        [weixinButton makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(weixinButton.mas_width);
            make.height.equalTo(@60);
            make.top.equalTo(thirdLoginLabel.mas_bottom).offset(10);
            make.centerX.equalTo(self.view.mas_centerX).offset(centerfriend);
        }];
        
        UIButton *qqButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:qqButton];
        [qqButton addTarget:self action:@selector(qqButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
        [qqButton setBackgroundImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
        [qqButton makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(qqButton.mas_width);
            make.height.equalTo(@60);
            make.top.equalTo(thirdLoginLabel.mas_bottom).offset(10);
            make.centerX.equalTo(self.view.mas_centerX).offset(-centerfriend);
        }];
    }else if (![WXApi isWXAppInstalled]&&![TencentOAuth iphoneQQInstalled]&&[WeiboSDK isWeiboAppInstalled]){
        UIButton *sinaButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sinaButton addTarget:self action:@selector(sinaButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:sinaButton];
        [sinaButton setBackgroundImage:[UIImage imageNamed:@"sina"] forState:UIControlStateNormal];
        [sinaButton makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(sinaButton.mas_width);
            make.height.equalTo(@60);
            make.top.equalTo(thirdLoginLabel.mas_bottom).offset(10);
            make.centerX.equalTo(self.view.mas_centerX);
        }];
    }else if ([WXApi isWXAppInstalled]&&![TencentOAuth iphoneQQInstalled]&&![WeiboSDK isWeiboAppInstalled]){
        UIButton *weixinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:weixinButton];
        [weixinButton addTarget:self action:@selector(weixinButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
        [weixinButton setBackgroundImage:[UIImage imageNamed:@"weixin"] forState:UIControlStateNormal];
        [weixinButton makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.height.equalTo(weixinButton.mas_width);
            make.height.equalTo(@60);
            make.top.equalTo(thirdLoginLabel.bottom).offset(10);
        }];
    }else if (![WXApi isWXAppInstalled]&&[TencentOAuth iphoneQQInstalled]&&![WeiboSDK isWeiboAppInstalled]){
        UIButton *qqButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self.view addSubview:qqButton];
        [qqButton addTarget:self action:@selector(qqButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
        [qqButton setBackgroundImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
        [qqButton makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(qqButton.mas_width);
            make.height.equalTo(@60);
            make.top.equalTo(thirdLoginLabel.mas_bottom).offset(10);
            make.centerX.equalTo(self.view.mas_centerX);
        }];
    }else if ([WXApi isWXAppInstalled]&&[WeiboSDK isWeiboAppInstalled]&&[TencentOAuth iphoneQQInstalled]){
        UIButton *weixinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:weixinButton];
        [weixinButton addTarget:self action:@selector(weixinButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
        [weixinButton setBackgroundImage:[UIImage imageNamed:@"weixin"] forState:UIControlStateNormal];
        [weixinButton makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.height.equalTo(weixinButton.mas_width);
            make.height.equalTo(@60);
            make.top.equalTo(thirdLoginLabel.mas_bottom).offset(10);
        }];
        
        UIButton *qqButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self.view addSubview:qqButton];
        [qqButton addTarget:self action:@selector(qqButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
        float centerfriend = self.view.frame.size.width/4;
        [qqButton setBackgroundImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
        [qqButton makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(qqButton.mas_width);
            make.height.equalTo(@60);
            make.top.equalTo(thirdLoginLabel.mas_bottom).offset(10);
            make.centerX.equalTo(self.view.mas_centerX).offset(-centerfriend);
        }];
        
        UIButton *sinaButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sinaButton addTarget:self action:@selector(sinaButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:sinaButton];
        [sinaButton setBackgroundImage:[UIImage imageNamed:@"sina"] forState:UIControlStateNormal];
        [sinaButton makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(sinaButton.mas_width);
            make.height.equalTo(@60);
            make.top.equalTo(thirdLoginLabel.mas_bottom).offset(10);
            make.centerX.equalTo(self.view.mas_centerX).offset(centerfriend);
        }];
    }
}

//userbutton taped
- (void)weixinButtonTaped:(UIButton *)sender
{
//    isThirdLogin = YES;
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact";
    req.state = @"xxx";
    req.openID = @"0c806938e2413ce73eef92cc3";
    
    [WXApi sendAuthReq:req viewController:self delegate:self];
}

- (void)qqButtonTaped:(UIButton *)sender
{
//    isThirdLogin = YES;
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_ADD_ALBUM,
                            kOPEN_PERMISSION_ADD_IDOL,
                            kOPEN_PERMISSION_ADD_ONE_BLOG,
                            kOPEN_PERMISSION_ADD_PIC_T,
                            kOPEN_PERMISSION_ADD_SHARE,
                            kOPEN_PERMISSION_ADD_TOPIC,
                            kOPEN_PERMISSION_CHECK_PAGE_FANS,
                            kOPEN_PERMISSION_DEL_IDOL,
                            kOPEN_PERMISSION_DEL_T,
                            kOPEN_PERMISSION_GET_FANSLIST,
                            kOPEN_PERMISSION_GET_IDOLLIST,
                            kOPEN_PERMISSION_GET_INFO,
                            kOPEN_PERMISSION_GET_OTHER_INFO,
                            kOPEN_PERMISSION_GET_REPOST_LIST,
                            kOPEN_PERMISSION_LIST_ALBUM,
                            kOPEN_PERMISSION_UPLOAD_PIC,
                            kOPEN_PERMISSION_GET_VIP_INFO,
                            kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                            kOPEN_PERMISSION_GET_INTIMATE_FRIENDS_WEIBO,
                            kOPEN_PERMISSION_MATCH_NICK_TIPS_WEIBO,
                            nil];
    ThirdLoginCallBackManager *app = [ThirdLoginCallBackManager sharedInstance];
    [app.tencentOAuth authorize:permissions inSafari:NO];
}

- (void)sinaButtonTaped: (UIButton *)sender
{
//    isThirdLogin = YES;
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kWBRedirectURL;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}


- (void)login:(UIButton *)sender
{
    if ([self.nameText.text isEqualToString:@""]) {
        [NSObject showHudTipStr:@"请输入电话号码"];
        return;
    }
    if ([self.passWordText.text isEqualToString:@""]) {
        [NSObject showHudTipStr:@"请输入密码"];
        return;
    }

    NSDictionary *dic1 = @{
                           @"UserIDOrigianal":self.nameText.text,
                           @"Password": self.passWordText.text ,//传递明文，服务器端做加密存储
                           };
    ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
    [client requestUserLoginWithParam:dic1 andBlock:^(AddUserModel *loginModel, NSError *error) {
        DeBugLog(@"登录信息是%@",loginModel);
        if ([loginModel.returnCode intValue]==200) {
            thirdPartyLoginPlatform = kMeddoPlatform;
            thirdPartyLoginUserId = loginModel.userId;
            NSRange range = [thirdPartyLoginUserId rangeOfString:@"$"];
            thirdPartyLoginNickName = [loginModel.userId substringFromIndex:range.location+range.length];
            thirdPartyLoginOriginalId = [loginModel.userId substringFromIndex:range.location+range.length];
            thirdPartyLoginIcon = @"";
            thirdPartyLoginToken = @"";
            thirdMeddoPhone = self.nameText.text;
            thirdMeddoPassWord = self.passWordText.text;
            [UserManager setGlobalOauth];
            [self uploadRegisterID];
            self.loginButtonClicked(1);
        }else if ([loginModel.returnCode intValue]==10012){
            [NSObject showHudTipStr:@"登录密码错误"];
        }
    }];
}

- (void)uploadRegisterID
{
    NSString *registerID = [APService registrationID];
    if (registerID.length > 0) {
        NSDictionary *dic = @{
                              @"UserId": thirdPartyLoginUserId, //关键字，必须传递
                              @"PushRegistrationId": registeredID, //密码
                              @"AppVersion" : [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                              @"OSName" : @"iOS",
                              @"OSVersion" : [UIDevice currentDevice].systemVersion,
                              @"CellPhoneModal" : [UIDevice currentDevice].machineModelName,
                              };
        ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
        [client requestRegisterUserIdForPush:dic andBlock:^(BaseModel *baseModel, NSError *error) {
            
        }];
    }
}

- (void)registerButton:(UIButton *)sender
{
//    self.getCodeButtonClicked(1);
    GetCodeViewController *get = [[GetCodeViewController alloc]init];
    [self.navigationController pushViewController:get animated:YES];
}

- (void)forgetPassWord:(UITapGestureRecognizer *)gesture
{
    MMPopupBlock completeBlock = ^(MMPopupView *popupView){
    };
    [[[MMAlertView alloc] initWithInputTitle:@"提示" detail:@"请输入手机号码,我们会将密码以短信的方式发到您的手机上。" placeholder:@"请输入手机号" handler:^(NSString *text) {
        self.cellPhone = text;
        [self getPassWordSelf:text];
    }] showWithBlock:completeBlock];
}
#pragma mark 获取验证码
- (void)getPassWordSelf:(NSString *)cellPhone
{
    if (cellPhone.length == 0) {
        [NSObject showHudTipStr:@"请输入手机号"];
        return;
    }
    if (cellPhone.length != 11) {
        [NSObject showHudTipStr:@"请输入正确的手机号"];
        return;
    }
    self.forgetPassWord = [self getRandomNumber:100000 to:1000000];
    NSString *codeMessage = [NSString stringWithFormat:@"您的密码已经重置，新密码是%d,请及时修改您的密码。",self.forgetPassWord];
    NSDictionary *dicPara = @{
                              @"cell" : cellPhone,
                              @"codeMessage" : codeMessage,
                              };
    GetInavlideCodeApi *client = [GetInavlideCodeApi shareInstance];
    [client getInvalideCode:dicPara witchBlock:^(NSData *receiveData) {
        NSString *string = [[NSString alloc]initWithData:receiveData encoding:NSUTF8StringEncoding];
        NSRange range = [string rangeOfString:@"<error>"];
        if ([[string substringFromIndex:range.location +range.length]intValue]==0) {
            [self modifyPassWord];
        }else{
            [NSObject showHudTipStr:@"短信运营商出错啦"];
        }
    }];

}

-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}

- (void)modifyPassWord
{
    
    NSDictionary *dic = @{
                          @"UserID": [NSString stringWithFormat:@"%@$%@",kMeddoPlatform,self.cellPhone], //关键字，必须传递
                          @"Password": [NSString stringWithFormat:@"%d",self.forgetPassWord], //密码
                        };
    ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
    [client requestChangeUserInfoParam:dic andBlock:^(BaseModel *resultModel, NSError *error) {
        [NSObject showHudTipStr:@"新的密码已发送到您手机,请查收"];
        self.passWordText.text = @"";
    }];
}

#pragma mark textfeild delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ([textField isEqual:self.nameText]) {
        [textField setReturnKeyType:UIReturnKeyNext];
        return YES;
    }else if([textField isEqual:self.passWordText]){
        [textField setReturnKeyType:UIReturnKeyDone];
        return YES;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.nameText]) {
        [self.passWordText becomeFirstResponder];
        if (textField.text.length >4) {
            CKTextField *text = (CKTextField *)textField;
            [text shake];
        }
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (void)textFieldChanged:(NSNotification *)noti
{
    UITextField *textField = (UITextField *)noti.object;
    if ([textField isEqual:self.nameText]) {
        if (self.nameText.text.length>11) {
            self.nameText.text = [self.nameText.text substringToIndex:11];
            [self shake:self.nameText];
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


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:self.nameText];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:self.nameText];
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
