//
//  NameDoubleViewController.m
//  SleepRecoding
//
//  Created by Havi on 15/11/13.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import "NameDoubleViewController.h"
#import "MMPopupItem.h"
#import "LBXAlertAction.h"
//#import "UDPAddProductViewController.h"
#import "ReactiveDoubleViewController.h"

@interface NameDoubleViewController ()
@property (nonatomic, strong) UITextField *leftText;
@property (nonatomic, strong) UITextField *rightText;
@end

@implementation NameDoubleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubView];
}

- (void)initSubView
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
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.text = @"命名左右床垫名称";
    titleLabel.textColor = [UIColor whiteColor];
    //
    UILabel *deviceLabel = [[UILabel alloc]init];
    [self.view addSubview:deviceLabel];
    [deviceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.height.equalTo(@44);
    }];
    deviceLabel.font = kDefaultWordFont;
    deviceLabel.text = self.doubleDeviceName;
    deviceLabel.textColor = [UIColor whiteColor];
    //
    UIImageView *bgView = [[UIImageView alloc]init];
    bgView.image = [UIImage imageNamed:@"double_bed"];
    [self.view addSubview:bgView];
    bgView.layer.cornerRadius = 10;
    bgView.layer.masksToBounds = YES;
    bgView.userInteractionEnabled = YES;
    bgView.layer.borderColor = [UIColor whiteColor].CGColor;
    bgView.layer.borderWidth = 1;
    [bgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(deviceLabel.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(@200);
    }];
    //
    UIView *lineView = [[UIView alloc]init];
    [bgView addSubview:lineView];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView.mas_centerX);
        make.width.equalTo(@2);
        make.top.equalTo(bgView.mas_top);
        make.bottom.equalTo(bgView.mas_bottom);
    }];
    //
    _leftText = [[UITextField alloc]init];
    [bgView addSubview:_leftText];
    _leftText.text = @"Left";
    _leftText.layer.borderWidth = 0.5;
    _leftText.layer.cornerRadius = 5;
    _leftText.layer.masksToBounds = YES;
    _leftText.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _leftText.textAlignment = NSTextAlignmentLeft;
    _leftText.borderStyle = UITextBorderStyleNone;
    _leftText.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    leftImage.image = [UIImage imageNamed:@"edit_double_bed"];
    [bgView addSubview:leftImage];
    _rightText = [[UITextField alloc]init];
    [bgView addSubview:_rightText];
    _rightText.textAlignment = NSTextAlignmentLeft;
    _rightText.layer.borderWidth = 0.5;
    _rightText.layer.cornerRadius = 5;
    _rightText.layer.masksToBounds = YES;
    _rightText.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _rightText.text = @"Right";
    _rightText.leftViewMode = UITextFieldViewModeAlways;
    _rightText.borderStyle = UITextBorderStyleNone;
    UIImageView *rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    rightImage.image = [UIImage imageNamed:@"edit_double_bed"];
    [bgView addSubview:rightImage];
    //
    [_leftText makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView.mas_centerY);
        make.height.equalTo(@25);
        make.left.equalTo(bgView.mas_left).offset(10);
    }];
    [_rightText makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView.mas_centerY);
        make.height.equalTo(@25);
        make.left.equalTo(lineView.mas_right).offset(10);
        make.right.equalTo(rightImage.mas_left).offset(-5);
    }];
    //
    [leftImage makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftText.mas_right).offset(5);
        make.right.equalTo(lineView.mas_left).offset(-10);
        make.height.equalTo(@20);
        make.width.equalTo(@20);
        make.centerY.equalTo(_leftText.mas_centerY);
    }];
    [rightImage makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_rightText.mas_right).offset(5);
        make.right.equalTo(bgView.mas_right).offset(-10);
        make.height.equalTo(@20);
        make.width.equalTo(@20);
        make.centerY.equalTo(_leftText.mas_centerY);
    }];
    
    //
    //
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:nextButton];
    [nextButton setTitle:@"保存" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(addProduct:) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"textbox_save_settings_%d",selectedThemeIndex]] forState:UIControlStateNormal];
    nextButton.layer.cornerRadius = 0;
    nextButton.layer.masksToBounds = YES;
    [nextButton.titleLabel setFont:kDefaultWordFont];
    [nextButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(bgView.mas_bottom).offset(40);
        make.height.equalTo(@49);
        make.width.equalTo(bgView.mas_width);
    }];
    //返回
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:backButton];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitle:@"暂时不关联" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backSuperView:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"textbox_hollow_%d",selectedThemeIndex]] forState:UIControlStateNormal];
    backButton.layer.cornerRadius = 0;
    backButton.layer.masksToBounds = YES;
    [backButton.titleLabel setFont:kDefaultWordFont];
    [backButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(nextButton.mas_bottom).offset(20);
        make.height.equalTo(@49);
        make.width.equalTo(bgView.mas_width);
    }];
    
}

- (void)addProduct:(UIButton *)sender
{
    [self bindingDeviceWithUUID:nil];
}

-(void)backSuperView:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark 绑定硬件

- (void)bindingDeviceWithUUID:(NSString *)UUID
{
    if (self.leftText.text.length == 0) {
        [self.view makeToast:@"请输入左侧床垫名称" duration:2 position:@"center"];
        return;
    }
    if (self.rightText.text.length == 0) {
        [self.view makeToast:@"请输入右侧床垫名称" duration:2 position:@"center"];
        return;
    }
    NSArray *_arrDeatilListDescription = self.dicDetailDevice;
    NSArray *_sortedDetailDevice = [_arrDeatilListDescription sortedArrayUsingComparator:^NSComparisonResult(SensorList* _Nonnull obj1, SensorList* _Nonnull obj2) {
        return [obj1.subDeviceUUID compare:obj2.subDeviceUUID options:NSCaseInsensitiveSearch];
    }];
    NSDictionary *para = @{
                           @"UserID":kUserID,
                           @"DeviceList":@[
                                   @{
                                       @"UUID":self.barUUIDString,
                                       @"Description":self.doubleDeviceName,
                                       },
                                   @{
                                       @"UUID":((SensorList *)[_sortedDetailDevice objectAtIndex:0]).subDeviceUUID,
                                       @"Description":self.leftText.text,
                                       },
                                   @{
                                       @"UUID":((SensorList *)[_sortedDetailDevice objectAtIndex:1]).subDeviceUUID,
                                       @"Description":self.rightText.text,
                                       }
                                   ]
                           };
    ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
    [client requestRenameMyDeviceParams:para andBlock:^(BaseModel *resultModel, NSError *error) {
        if (resultModel) {
            [self activeUUID:self.barUUIDString];
        }
    }];
    /*
    NSArray *images = @[[UIImage imageNamed:@"havi1_0"],
                        [UIImage imageNamed:@"havi1_1"],
                        [UIImage imageNamed:@"havi1_2"],
                        [UIImage imageNamed:@"havi1_3"],
                        [UIImage imageNamed:@"havi1_4"],
                        [UIImage imageNamed:@"havi1_5"]];
    [[MMProgressHUD sharedHUD] setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithTitle:nil status:nil images:images];
    NSArray *_arrDeatilListDescription = [self.dicDetailDevice  objectForKey:@"DetailSensorInfo"];
    NSArray *_sortedDetailDevice = [_arrDeatilListDescription sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [[obj1 objectForKey:@"UUID"] compare:[obj2 objectForKey:@"UUID"] options:NSCaseInsensitiveSearch];
    }];
    NSDictionary *header = @{
                             @"AccessToken":@"123456789"
                             };
    
    NSString *urlString = [NSString stringWithFormat:@"v1/user/RenameUserDevice"];

    [WTRequestCenter putWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,urlString] header:header parameters:para finished:^(NSURLResponse *response, NSData *data) {
        [MMProgressHUD dismiss];
        NSDictionary *resposeDic = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([[resposeDic objectForKey:@"ReturnCode"]intValue]==200) {
            HaviLog(@"当前用户%@设备信息%@",thirdPartyLoginUserId,resposeDic);
            thirdHardDeviceUUID = self.barUUIDString;
            thirdHardDeviceName = self.doubleDeviceName;
            thirdLeftDeviceUUID = [[[self.dicDetailDevice objectForKey:@"DetailSensorInfo"]objectAtIndex:0]objectForKey:@"UUID"];
            thirdRightDeviceUUID = [[[self.dicDetailDevice objectForKey:@"DetailSensorInfo"]objectAtIndex:1]objectForKey:@"UUID"];
            thirdLeftDeviceName = self.leftText.text;
            thirdRightDeviceName = self.rightText.text;
            [UserManager setGlobalOauth];
            [[NSNotificationCenter defaultCenter]postNotificationName:CHANGEDEVICEUUID object:nil];
            DoubleDUPViewController *udp = [[DoubleDUPViewController alloc]init];
            udp.productName = self.doubleDeviceName;//测试
            thirdHardDeviceUUID = self.barUUIDString;
            udp.productUUID = self.barUUIDString;
            [self.navigationController pushViewController:udp animated:YES];
        }
        
    } failed:^(NSURLResponse *response, NSError *error) {
        
    }];
    */
}
//激活
- (void)activeUUID:(NSString *)UUID
{
    NSDictionary *dic14 = @{
                            @"UserID": kUserID,
                            @"UUID": UUID,
                            };
    ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
    
    [client requestActiveMyDeviceParams:dic14 andBlock:^(BaseModel *resultModel, NSError *error) {
        if (resultModel) {
            
            @weakify(self);
            [LBXAlertAction showAlertWithTitle:@"扫描设备成功" msg:@"您已经成功绑定该设备，是否现在激活？" chooseBlock:^(NSInteger buttonIdx) {
                @strongify(self);
                //点击完，继续扫码
                switch (buttonIdx) {
                    case 0:{
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        break;
                    }
                    case 1:{
                        ReactiveDoubleViewController *doubleUDP = [[ReactiveDoubleViewController alloc]init];
                        [self.navigationController pushViewController:doubleUDP animated:YES];
                        break;
                    }
                        
                    default:
                        break;
                }
            } buttonsStatement:@"稍后激活",@"现在激活",nil];
        }
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
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
