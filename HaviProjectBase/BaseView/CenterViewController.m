//
//  CenterViewController.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/3.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "CenterViewController.h"
#import "BaseViewContainerView.h"
#import "DataShowViewController.h"

@interface CenterViewController ()

@property (nonatomic, strong) BaseViewContainerView *containerDataView;
@property (nonatomic, strong) DeviceList *activeDeviceInfo;
@property (nonatomic, strong) UIButton *leftMenuButton;
@property (nonatomic, strong) UIButton *rightMenuButton;

@end

@implementation CenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.backgroundImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"pic_bg_center_%d",selectedThemeIndex]];
    [self initNaviBarView];
    [self queryDeviceListForControllers];
}

- (void)queryDeviceListForControllers
{
    @weakify(self)
    [self checkUserDevice:^(DeviceList *device, NSError *error) {
        @strongify(self);
        self.activeDeviceInfo = device;
        [self initCenterViewControllers];
    }];
}

- (void)initNaviBarView
{
    self.navigationController.navigationBarHidden = YES;
    self.containerDataView = [[BaseViewContainerView alloc]initWithNavBarControllers:nil];
    self.containerDataView.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.containerDataView.view];
    [self addChildViewController:self.containerDataView];
//    self.containerDataView.pagingViewMovingRedefine = ^(UIScrollView *scrollView, NSArray *subviews){
//        float mid   = [UIScreen mainScreen].bounds.size.width/2 - 45.0;
//        float width = [UIScreen mainScreen].bounds.size.width;
//        CGFloat xOffset = scrollView.contentOffset.x;
//        int i = 0;
//        for(UILabel *v in subviews){
//            CGFloat alpha = 0.0;
//            if(v.frame.origin.x < mid)
//                alpha = 1 - (xOffset - i*width) / width;
//            else if(v.frame.origin.x >mid)
//                alpha=(xOffset - i*width) / width + 1;
//            else if(v.frame.origin.x == mid-5)
//                alpha = 1.0;
//            i++;
//            v.alpha = alpha;
//        }
//    };
    self.containerDataView.didChangedPage = ^(NSInteger currentPageIndex){
        // Do something
        NSLog(@"index %ld", (long)currentPageIndex);
    };
    [self.containerDataView.navigationBarView addSubview:self.leftMenuButton];
    [self.containerDataView.navigationBarView addSubview:self.rightMenuButton];

}

- (void)checkUserDevice:(void (^)(DeviceList *device, NSError *error))block
{
    ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
    NSDictionary *dic = @{
                          @"UserID" : thirdPartyLoginUserId,
                          };
    [client requestCheckAllDeviceListParams:dic andBlock:^(AllDeviceModel *myDeviceList, NSError *error) {
        if (myDeviceList) {
            NSArray *myDeviceListArr = myDeviceList.myDeviceList;
            [myDeviceListArr enumerateObjectsUsingBlock:^(DeviceList*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.isActivated isEqualToString:@"True"]) {
                    block(obj,nil);
                    *stop = YES;
                }
            }];
            
            NSArray *friendDeviceListArr = myDeviceList.friendDeviceList;
            [friendDeviceListArr enumerateObjectsUsingBlock:^(DeviceList*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.isActivated isEqualToString:@"True"]) {
                    block(obj,nil);
                    *stop = YES;
                }
            }];
        }
    }];
}

- (void)initCenterViewControllers
{
    if (self.activeDeviceInfo.detailDeviceList.count == 0) {
        DataShowViewController *dataShow = [[DataShowViewController alloc]init];
        dataShow.title = self.activeDeviceInfo.nDescription;
        dataShow.deviceUUID = self.activeDeviceInfo.deviceUUID;
        [self.containerDataView addViewControllers:dataShow needToRefresh:YES];
    }else{
        @weakify(self);
        [self.activeDeviceInfo.detailDeviceList enumerateObjectsUsingBlock:^(DetailDeviceList*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self);
            DataShowViewController *dataShow = [[DataShowViewController alloc]init];
            dataShow.title = obj.detailDescription;
            dataShow.deviceUUID = obj.detailUUID;
            [self.containerDataView addViewControllers:dataShow needToRefresh:YES];
        }];
    }
}

#pragma mark setter

- (UIButton *)leftMenuButton
{
    if (!_leftMenuButton) {
        _leftMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftMenuButton.backgroundColor = [UIColor clearColor];
        UIImage *i = [UIImage imageNamed:[NSString stringWithFormat:@"re_order_%d",selectedThemeIndex]];
        [_leftMenuButton setImage:i forState:UIControlStateNormal];
        [_leftMenuButton setFrame:CGRectMake(0, 20, 44, 44)];
        [_leftMenuButton addTarget:self action:@selector(showLeftView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftMenuButton;
}

- (UIButton *)rightMenuButton
{
    if (!_rightMenuButton) {
        _rightMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightMenuButton.backgroundColor = [UIColor clearColor];
        UIImage *i = [UIImage imageNamed:[NSString stringWithFormat:@"btn_point_%d",selectedThemeIndex]];
        [_rightMenuButton setImage:i forState:UIControlStateNormal];
        [_rightMenuButton setFrame:CGRectMake(self.view.frame.size.width-50, 20, 44, 44)];
        [_rightMenuButton addTarget:self action:@selector(showMoreInfo:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightMenuButton;
}

#pragma mark showMoreInfo

- (void)showMoreInfo:(UIButton *)sender
{
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"我的设备"
                     image:[UIImage imageNamed:@""]
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"分享应用"
                     image:[UIImage imageNamed:@""]
                    target:self
                    action:@selector(pushMenuItem:)],
      ];
    CGRect popUpPos = sender.frame;
    popUpPos.origin.y -= 10;
    [KxMenu showMenuInView:self.view
                  fromRect:popUpPos
                 menuItems:menuItems];
}

- (void) pushMenuItem:(id)sender
{
    KxMenuItem *item = (KxMenuItem *)sender;
    if ([item.title isEqualToString:@"我的设备"]) {
//        [self showDropDownView];
    }else if ([item.title isEqualToString:@"分享应用"]){
        [self shareApp:nil];
    }
}

#pragma mark user action

- (void)showLeftView
{
    [self.sidePanelController showLeftPanelAnimated:YES];
}

- (void)shareApp:(UIButton *)sender
{
    [self.shareNewMenuView showInView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
