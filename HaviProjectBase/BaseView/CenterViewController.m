//
//  CenterViewController.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/3.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "CenterViewController.h"
#import "BaseViewContainerView.h"
#import "CenterDataShowViewController.h"
#import "CLWeeklyCalendarView.h"

static CGFloat CALENDER_VIEW_HEIGHT = 106.f;
@interface CenterViewController ()<CLWeeklyCalendarViewDelegate>

@property (nonatomic, strong) BaseViewContainerView *containerDataView;
@property (nonatomic, strong) DeviceList *activeDeviceInfo;
@property (nonatomic, strong) CLWeeklyCalendarView* calendarView;

@property (nonatomic, strong) UIButton *leftMenuButton;
@property (nonatomic, strong) UIButton *rightMenuButton;

@end

@implementation CenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.backgroundImageView.dk_imagePicker = DKImageWithNames(@"pic_bg_center_0", @"pic_bg_center_1");
    [self initNaviBarView];
    [self queryDeviceListForControllers];
    [self initDatePicker];
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

- (void)initDatePicker
{
    [self.view addSubview:self.calendarView];
}

- (void)initNaviBarView
{
    self.navigationController.navigationBarHidden = YES;
    self.containerDataView = [[BaseViewContainerView alloc]initWithNavBarControllers:nil];
    self.containerDataView.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.containerDataView.view];
    [self addChildViewController:self.containerDataView];
    self.containerDataView.didChangedPage = ^(NSInteger currentPageIndex){
        // Do something
        NSLog(@"index %ld", (long)currentPageIndex);
    };
    [self.containerDataView.view setHeight:[UIScreen mainScreen].bounds.size.height - CALENDER_VIEW_HEIGHT];
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
        CenterDataShowViewController *dataShow = [[CenterDataShowViewController alloc]init];
        dataShow.title = self.activeDeviceInfo.nDescription;
        dataShow.deviceUUID = self.activeDeviceInfo.deviceUUID;
        dataShow.view.frame = self.containerDataView.view.bounds;
        [self.containerDataView addViewControllers:dataShow needToRefresh:YES];
    }else{
        @weakify(self);
        [self.activeDeviceInfo.detailDeviceList enumerateObjectsUsingBlock:^(DetailDeviceList*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self);
            CenterDataShowViewController *dataShow = [[CenterDataShowViewController alloc]init];
            dataShow.title = obj.detailDescription;
            dataShow.deviceUUID = obj.detailUUID;
            dataShow.view.frame = self.containerDataView.view.bounds;
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
        [_leftMenuButton dk_setImage:DKImageWithNames(@"re_order_0", @"re_order_1") forState:UIControlStateNormal];
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
        [_rightMenuButton dk_setImage:DKImageWithNames(@"btn_point_0", @"btn_point_1") forState:UIControlStateNormal];
        [_rightMenuButton setFrame:CGRectMake(self.view.frame.size.width-50, 20, 44, 44)];
        [_rightMenuButton addTarget:self action:@selector(showMoreInfo:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightMenuButton;
}

-(CLWeeklyCalendarView *)calendarView
{
    if(!_calendarView){
        _calendarView = [[CLWeeklyCalendarView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-CALENDER_VIEW_HEIGHT, self.view.bounds.size.width, CALENDER_VIEW_HEIGHT)];
        _calendarView.delegate = self;
    }
    return _calendarView;
}
#pragma mark calendar delegate
- (NSDictionary *)CLCalendarBehaviorAttributes
{
    return @{
             CLCalendarDayTitleTextColor : kDefaultColor,
             CLCalendarSelectedDatePrintFontSize:@19,
             CLCalendarBackgroundImageColor:[UIColor clearColor],
             };
}

-(void)dailyCalendarViewDidSelect: (NSDate *)date
{
    DeBugLog(@"选择日期是%@",date);
    selectedDateToUse = date;
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
