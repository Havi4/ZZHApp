//
//  RegisterViewController.m
//  SleepRecoding
//
//  Created by Havi_li on 15/3/17.
//  Copyright (c) 2015年 Havi. All rights reserved.
//

#import "RegisterViewController.h"
#import "btRippleButtton.h"
#import <AudioToolbox/AudioToolbox.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "UserProtocolViewController.h"
#import "HaviAnimationView.h"
#import "ImageUtil.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AppDelegate.h"

@interface RegisterViewController ()<UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate>
@property (nonatomic,strong) UITextField *nameText;
@property (nonatomic,strong) UITextField *passWordText;
@property (nonatomic,strong) BTRippleButtton *iconButton;
@property (nonatomic,strong) NSData *iconData;
@property (assign,nonatomic) float yCordinate;
@end

@implementation RegisterViewController

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
    [self.nameText setTextColor:[UIColor blackColor]];
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
    self.passWordText.textColor = [UIColor blackColor];
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
    [registerButton setTitle:@"完成注册" forState:UIControlStateNormal];
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
    
    //协议说明
    UILabel *protocolLabel = [[UILabel alloc]init];
    [self.view addSubview:protocolLabel];
    [protocolLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(kButtonViewWidth));
        make.height.equalTo(@20);
        make.top.equalTo(registerButton.mas_bottom).offset(10);
    }];
    protocolLabel.font = [UIFont systemFontOfSize:15];
    //
    NSString *sting = [NSString stringWithFormat:@"点击-完成注册,即表示您同意《迈动用户协议》"];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:sting];
    [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, [sting length])];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.984f green:0.549f blue:0.463f alpha:1.00f] range:[sting rangeOfString:@"《迈动用户协议》"]];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:[sting rangeOfString:@"点击-完成注册,即表示您同意"]];
    
    protocolLabel.textAlignment = NSTextAlignmentLeft;
    protocolLabel.numberOfLines = 0;
    protocolLabel.attributedText = attribute;
    protocolLabel.userInteractionEnabled = YES;
    //
    UITapGestureRecognizer *tapProtocol = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showProtocol:)];
    [protocolLabel addGestureRecognizer:tapProtocol];

}

- (void)getUserAccessTockenWith:(NSDictionary *)launchOptions
{
    ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
    [client requestServerTimeWithBlock:^(ServerTimeModel *serVerTime, NSError *error) {
        if (!error) {
            DeBugLog(@"服务器时间是%@",serVerTime.serverTime);
            if (serVerTime.serverTime.length==0) {
                return;
            }
            NSDateFormatter *date = [[NSDateFormatter alloc]init];
            [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *n = [date dateFromString:serVerTime.serverTime];
            NSInteger time = [n timeIntervalSince1970];
            NSString *atTime = [NSString stringWithFormat:@"%@%@%@%@%@%@",[serVerTime.serverTime substringWithRange:NSMakeRange(0, 4)],[serVerTime.serverTime substringWithRange:NSMakeRange(5, 2)],[serVerTime.serverTime substringWithRange:NSMakeRange(8, 2)],[serVerTime.serverTime substringWithRange:NSMakeRange(11, 2)],[serVerTime.serverTime substringWithRange:NSMakeRange(14, 2)],[serVerTime.serverTime substringWithRange:NSMakeRange(17, 2)]];
            NSString *md5OriginalString = [NSString stringWithFormat:@"ZZHAPI:%@:%@",thirdPartyLoginUserId,atTime];
            NSString *md5String = [md5OriginalString md5String];
            NSDictionary *dic = @{
                                  @"UserId": thirdPartyLoginUserId,
                                  @"Atime": [NSNumber numberWithInteger:(time)],
                                  @"MD5":[md5String uppercaseString],
                                  };
            [client requestAccessTockenWithParams:dic withBlock:^(AccessTockenModel *serVerTime, NSError *error) {
                if (!error) {
                    accessTocken = serVerTime.accessTockenString;
                    [self registerUser:nil];
                }else{
                }
            }];
        }else{
        }
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
    NSDictionary *dic = @{
                          @"CellPhone": @"", //手机号码
                          @"Email": @"", //邮箱地址，可留空，扩展注册用
                          @"Password": self.passWordText.text ,//传递明文，服务器端做加密存储
                          @"UserValidationServer" : kMeddoPlatform,
                          @"UserIdOriginal":self.cellPhoneNum,
                          };
    ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
    [client requestAddUserWithParams:dic andBlock:^(AddUserModel *userModel, NSError *error) {
        if ([userModel.returnCode intValue]==200) {
            thirdPartyLoginPlatform = kMeddoPlatform;
            thirdPartyLoginUserId = userModel.userId;
            NSRange range = [thirdPartyLoginUserId rangeOfString:@"$"];
            thirdPartyLoginNickName = [userModel.userId substringFromIndex:range.location+range.length];
            thirdPartyLoginIcon = @"";
            thirdPartyLoginToken = @"";
            [UserManager setGlobalOauth];
            [self.navigationController popToRootViewControllerAnimated:YES];
//            if (self.iconData) {
//                [self uploadWithImageData:self.iconData withUserId:thirdPartyLoginUserId];
//            }
//            AppDelegate *app = [UIApplication sharedApplication].delegate;
//            [app setRootViewController];
        }else{
            [NSObject showHudTipStr:[NSString stringWithFormat:@"%@",error]];
        }

    }];
    
}

#pragma mark 拍照

- (void)showProtocol:(UITapGestureRecognizer *)gesture
{
    UserProtocolViewController *protocol = [[UserProtocolViewController alloc]init];
    protocol.isPush = NO;
    [self presentViewController:protocol animated:YES completion:nil];
}

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

#pragma mark actionSheet代理

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 2:
                    // 取消
                    return;
                case 0:{
                    // 相机
                    NSString *mediaType = AVMediaTypeVideo;
                    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
                    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
                        [NSObject showHudTipStr:@"请在设置中打开照相机权限"];
                        DeBugLog(@"相机权限受限");
                    }else{
                        sourceType = UIImagePickerControllerSourceTypeCamera;
                        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                        imagePickerController.mediaTypes = @[(NSString*) kUTTypeImage];
                        imagePickerController.delegate = self;
                        
                        imagePickerController.allowsEditing = YES;
                        
                        imagePickerController.sourceType = sourceType;
                        
                        [self presentViewController:imagePickerController animated:YES completion:^{}];
                    }
                    
                    break;
                }
                    
                case 1:{
                    // 相册
                    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
                    if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
                        //无权限
                        [NSObject showHudTipStr:@"请在设置中打开照片库权限"];
                    }else{
                        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                        imagePickerController.mediaTypes = @[(NSString*) kUTTypeImage];
                        imagePickerController.delegate = self;
                        
                        imagePickerController.allowsEditing = YES;
                        
                        imagePickerController.sourceType = sourceType;
                        
                        [self presentViewController:imagePickerController animated:YES completion:^{
                            self.navigationController.navigationBarHidden = YES;
                        }];
                    }
                    break;
                }
            }
        }
        else {
            if (buttonIndex == 1) {
                
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                imagePickerController.mediaTypes = @[(NSString*) kUTTypeImage];
                imagePickerController.delegate = self;
                
                imagePickerController.allowsEditing = YES;
                
                imagePickerController.sourceType = sourceType;
                
                [self presentViewController:imagePickerController animated:YES completion:^{}];
                
            }
        }
        // 跳转到相机或相册页面
        
    }
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.iconButton changeImage:image];
    /* 此处info 有六个值
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     * UIImagePickerControllerMediaURL;       // an NSURL
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     */
    // 保存图片至本地，方法见下文
    NSData *imageData = [self calculateIconImage:image];
    self.iconData = imageData;
//    user_Register_Data = imageData;
    [HaviAnimationView animationFlipFromLeft:self.iconButton];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self setNeedsStatusBarAppearanceUpdate];
}

#define UploadImageSize          100000
- (NSData *)calculateIconImage:(UIImage *)image
{
    if(image){
        
        [image fixOrientation];
        CGFloat height = image.size.height;
        CGFloat width = image.size.width;
        NSData *data = UIImageJPEGRepresentation(image,1);
        
        float n;
        n = (float)UploadImageSize/data.length;
        data = UIImageJPEGRepresentation(image, n);
        while (data.length > UploadImageSize) {
            image = [UIImage imageWithData:data];
            height /= 2;
            width /= 2;
            image = [image scaleToSize:CGSizeMake(width, height)];
            data = UIImageJPEGRepresentation(image,1);
        }
        return data;
        
    }
    return nil;
}



#pragma mark 上传头像
- (void)uploadWithImageData:(NSData*)imageData withUserId:(NSString *)userId
{
    NSDictionary *dicHeader = @{
                                @"AccessToken": @"123456789",
                                };
    NSString *urlStr = [NSString stringWithFormat:@"%@/v1/file/UploadFile/%@",kAppBaseURL,thirdPartyLoginUserId];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:0 timeoutInterval:5.0f];
    [request setValue:[dicHeader objectForKey:@"AccessToken"] forHTTPHeaderField:@"AccessToken"];
    [self setRequest:request withImageData:imageData];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([[dic objectForKey:@"ReturnCode"] intValue]==200) {
            [[NSUserDefaults standardUserDefaults]setObject:imageData forKey:[NSString stringWithFormat:@"%@%@",thirdPartyLoginUserId,thirdPartyLoginPlatform]];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
        }
    }];
}

- (void)setRequest:(NSMutableURLRequest *)request withImageData:(NSData*)imageData
{
    NSMutableData *body = [NSMutableData data];
    // 表单数据
    
    /// 图片数据部分
    NSMutableString *topStr = [NSMutableString string];
    [body appendData:[topStr dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:imageData];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    // 设置请求类型为post请求
    request.HTTPMethod = @"post";
    // 设置request的请求体
    request.HTTPBody = body;
    // 设置头部数据，标明上传数据总大小，用于服务器接收校验
    [request setValue:[NSString stringWithFormat:@"%ld", body.length] forHTTPHeaderField:@"Content-Length"];
    // 设置头部数据，指定了http post请求的编码方式为multipart/form-data（上传文件必须用这个）。
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; image/png"] forHTTPHeaderField:@"Content-Type"];
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
