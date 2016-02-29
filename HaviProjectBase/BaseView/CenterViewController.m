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
#import "CalendarHomeViewController.h"
#import "CalendarDateCaculate.h"

static CGFloat CALENDER_VIEW_HEIGHT = 106.f;
@interface CenterViewController ()<CLWeeklyCalendarViewDelegate>

@property (nonatomic, strong) BaseViewContainerView *containerDataView;
@property (nonatomic, strong) DeviceList *activeDeviceInfo;
@property (nonatomic, strong) CLWeeklyCalendarView* calendarView;
@property (nonatomic, strong) CalendarHomeViewController *chvc;//日历包括农历

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
}

- (void)queryDeviceListForControllers
{
    @weakify(self)
    [self checkUserDevice:^(DeviceList *device, NSError *error) {
        @strongify(self);
        self.activeDeviceInfo = device;
        gloableActiveDevice = device;
        [self initCenterViewControllers];
    }];
}

- (void)initDatePicker
{
    [self.view addSubview:self.calendarView];
    if (selectedDateToUse) {
        [self.calendarView redrawToDate:selectedDateToUse];
    }
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
            if(myDeviceList.myDeviceList.count == 0 && myDeviceList.friendDeviceList.count == 0){
                NSError *error = [NSError errorWithDomain:@"没有" code:00000 userInfo:nil];
                block(nil,error);
            }
        }
    }];
}

- (void)initCenterViewControllers
{
    if (self.activeDeviceInfo.detailDeviceList.count == 0) {
        isDoubleDevice = NO;
        CenterDataShowViewController *dataShow = [[CenterDataShowViewController alloc]init];
        dataShow.title = self.activeDeviceInfo.nDescription.length == 0?@"":self.activeDeviceInfo.nDescription;
        dataShow.deviceUUID = self.activeDeviceInfo.deviceUUID;
        dataShow.view.frame = self.containerDataView.view.bounds;
        [self.containerDataView addViewControllers:dataShow needToRefresh:YES];
    }else{
        isDoubleDevice = YES;
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
        @weakify(self);
        _calendarView.tapedCalendar = ^(NSInteger index){
            @strongify(self);
            [self showCalendar];
        };
    }
    return _calendarView;
}

#pragma mark setter
- (CalendarHomeViewController *)chvc
{
    if (_chvc == nil) {
        _chvc = [[CalendarHomeViewController alloc]init];
        _chvc.view.dk_backgroundColorPicker = DKColorWithColors([UIColor colorWithRed:0.008 green:0.114 blue:0.227 alpha:1.00], [UIColor colorWithRed:0.322 green:0.592 blue:0.761 alpha:1.00]);
        _chvc.calendartitle = @"日历";
        NSDate *date = [[NSDate date]dateByAddingHours:8];
        NSDate *oldDate = [[CalendarDateCaculate sharedInstance].dateFormmatterBase dateFromString:@"20150101"];
        int day = (int)[date daysFrom:oldDate]+1;
        [_chvc setAirPlaneToDay:day ToDateforString:[NSString stringWithFormat:@"2015-01-01"]];//
    }
    return _chvc;
}


- (void)showCalendar
{
    @weakify(self);
    self.chvc.calendarblock = ^(CalendarDayModel *model){
        NSDate *selectedDate = [model date];
        @strongify(self);
        selectedDateToUse = selectedDate;
        [self.calendarView redrawToDate:selectedDate];
        
    };
    self.navigationController.navigationBarHidden = NO;
    
    [self.navigationController.navigationBar setBackgroundImage:selectedThemeIndex == 0 ? [UIImage imageNamed:@"navigation_bar_bg_0"]:[UIImage imageNamed:@"navigation_bar_bg_1"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.dk_tintColorPicker= DKColorWithColors([UIColor colorWithRed:0.008 green:0.114 blue:0.227 alpha:1.00], [UIColor colorWithRed:0.322 green:0.592 blue:0.761 alpha:1.00]);
    [self.navigationController pushViewController:self.chvc animated:YES];
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
    NSString *queryFromDate = [SleepModelChange chageDateFormatteToQueryString:date];
    NSString *queryEndDate = [SleepModelChange chageDateFormatteToQueryString:[date dateByAddingDays:1]];
    [self.containerDataView.childViewControllers enumerateObjectsUsingBlock:^(__kindof CenterDataShowViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj getSleepDataWithStartTime:queryFromDate endTime:queryEndDate];
    }];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initDatePicker];
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
