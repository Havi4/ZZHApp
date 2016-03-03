//
//
//
//
//  Created by lbxia on 15/10/21.
//  Copyright © 2015年 lbxia. All rights reserved.
//

#import "QBarScanViewController.h"
#import "LBXScanResult.h"
#import "LBXScanWrapper.h"
#import "EditUUIDView.h"
#import "NameDoubleViewController.h"
#import "ReactiveSingleViewController.h"

@interface QBarScanViewController ()

@property (nonatomic, strong) UIView *currentView;
@property (nonatomic, strong) EditUUIDView *editView;

@end

@implementation QBarScanViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor blackColor];
}

- (EditUUIDView*)editView
{
    if (!_editView) {
        _editView = [[EditUUIDView alloc]initWithFrame:self.view.bounds];
        @weakify(self);
        _editView.bindDeviceButtonTaped = ^(NSString *barUUID){
            @strongify(self);
            [self checkIsDoubleBed:barUUID];
        };
        _editView.scanBarButtonTaped = ^(NSInteger index){
            @strongify(self);
            [self showBarScan];
        };
    }
    return _editView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_isQQSimulator) {
         [self drawBottomItems];
        [self drawNavi];
        [self drawTitle];
         [self.view bringSubviewToFront:_topTitle];
    }
    else
        _topTitle.hidden = YES;
    [self.view addSubview:self.currentView];
   
}

- (void)drawNavi
{
    if (_naviItemsView) {
        return;
    }
    self.naviItemsView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,
                                                                   CGRectGetWidth(self.view.frame), 64)];
    _naviItemsView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [self.view addSubview:_naviItemsView];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(15, 25, 30, 30);
    [backButton setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_titlebar_back_nor"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_titlebar_back_pressed"] forState:UIControlStateSelected];
    [backButton addTarget:self action:@selector(backToHome:) forControlEvents:UIControlEventTouchUpInside];
    [_naviItemsView addSubview:backButton];
}

//绘制扫描区域
- (void)drawTitle
{
    if (!_topTitle)
    {
        
        
        self.topTitle = [[UILabel alloc]init];
        _topTitle.bounds = CGRectMake(0, 64, 145, 60);
        _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 94);
        
        //3.5inch iphone
        if ([UIScreen mainScreen].bounds.size.height <= 568 )
        {
            _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 38);
            _topTitle.font = [UIFont systemFontOfSize:14];
        }
        
        
        _topTitle.textAlignment = NSTextAlignmentCenter;
        _topTitle.numberOfLines = 0;
        _topTitle.text = @"将取景框对准二维码即可自动扫描";
        _topTitle.textColor = [UIColor whiteColor];
        [self.view addSubview:_topTitle];
    }
}

- (void)drawBottomItems
{
    if (_bottomItemsView) {
        
        return;
    }
    
    self.bottomItemsView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame)-100,
                                                                      CGRectGetWidth(self.view.frame), 100)];
    
    _bottomItemsView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    [self.view addSubview:_bottomItemsView];
    
    CGSize size = CGSizeMake(65, 87);
    self.btnFlash = [[UIButton alloc]init];
    _btnFlash.bounds = CGRectMake(0, 0, size.width, size.height);
    _btnFlash.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame)/4, CGRectGetHeight(_bottomItemsView.frame)/2);
     [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
    [_btnFlash addTarget:self action:@selector(openOrCloseFlash) forControlEvents:UIControlEventTouchUpInside];
    self.btnMyQR = [[UIButton alloc]init];
    _btnMyQR.bounds = _btnFlash.bounds;
    _btnMyQR.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame) * 3/4, CGRectGetHeight(_bottomItemsView.frame)/2);
    [_btnMyQR setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_myqrcode_nor"] forState:UIControlStateNormal];
    [_btnMyQR setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_myqrcode_down"] forState:UIControlStateHighlighted];
    [_btnMyQR addTarget:self action:@selector(editUUID) forControlEvents:UIControlEventTouchUpInside];
    
    [_bottomItemsView addSubview:_btnFlash];
    [_bottomItemsView addSubview:_btnMyQR];
    
}


- (void)showError:(NSString*)str
{
    [LBXAlertAction showAlertWithTitle:@"提示" msg:str chooseBlock:nil buttonsStatement:@"知道了",nil];
}



- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    
    if (array.count < 1)
    {
        [self popAlertMsgWithScanResult:nil];
     
        return;
    }
    
    //经测试，可以同时识别2个二维码，不能同时识别二维码和条形码
    for (LBXScanResult *result in array) {
        
        NSLog(@"scanResult:%@",result.strScanned);
    }
    
    LBXScanResult *scanResult = array[0];
    
    NSString*strResult = scanResult.strScanned;
    
    self.scanImage = scanResult.imgScanned;
    
    if (!strResult) {
        
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //震动提醒
    [LBXScanWrapper systemVibrate];
    //声音提醒
    [LBXScanWrapper systemSound];
    
    
    [self popAlertMsgWithScanResult:strResult];
    
   
}

- (void)popAlertMsgWithScanResult:(NSString*)strResult
{
    if (!strResult) {
        
        strResult = @"识别失败";
        [NSObject showHudTipStr:strResult];
        return;
    }
    [self checkIsDoubleBed:strResult];
    
}

#pragma mark 检测设备是不是双人的

- (void)checkIsDoubleBed:(NSString *)deviceUUID
{
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
                [UIView transitionFromView:self.editView toView:self.view duration:0.0f options:UIViewAnimationOptionTransitionNone completion:^(BOOL finished) {
                    NameDoubleViewController *doubleBed = [[NameDoubleViewController alloc]init];
                    doubleBed.barUUIDString = deviceUUID;
                    doubleBed.doubleDeviceName = self.deviceDescription;
                    doubleBed.dicDetailDevice = sensorModel.sensorDetail.detailSensorInfoList;
                    [self.navigationController pushViewController:doubleBed animated:YES];
                }];
            }
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self reStartDevice];
            });
        }
    }];
}

#pragma mark 绑定

- (void)bindingDeviceWithUUID:(NSString *)uuid
{
    NSDictionary *dic13 = @{
                            @"UserID": thirdPartyLoginUserId,
                            @"UUID": uuid,
                            @"Description":self.deviceDescription,
                            };
    ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
    @weakify(self);
    [client requestUserBindingDeviceParams:dic13 andBlock:^(BaseModel *resultModel, NSError *error) {
        @strongify(self);
        if (resultModel) {
            [self activeUserDefaultDevice:uuid];
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self reStartDevice];
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
            [LBXAlertAction showAlertWithTitle:@"扫描设备成功" msg:@"您已经成功绑定该设备，是否现在激活？" chooseBlock:^(NSInteger buttonIdx) {
                @strongify(self);
                //点击完，继续扫码
                switch (buttonIdx) {
                    case 0:{
                        [UIView transitionFromView:self.editView toView:self.view duration:0.0f options:UIViewAnimationOptionTransitionNone completion:^(BOOL finished) {
                        }];
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
                [self reStartDevice];
            } buttonsStatement:@"稍后激活",@"现在激活",nil];
        }
    }];
}

#pragma mark -底部功能项
- (void)backToHome:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//开关闪光灯
- (void)openOrCloseFlash
{
    
    [super openOrCloseFlash];
   
    
    if (self.isOpenFlash)
    {
        [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_down"] forState:UIControlStateNormal];
    }
    else
        [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
}


#pragma mark -底部功能项


- (void)editUUID
{
    [UIView transitionFromView:self.view toView:self.editView duration:0.4f options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
    }];
}

- (void)showBarScan
{
    [UIView transitionFromView:self.editView toView:self.view duration:0.4f options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
    }];
}

@end
