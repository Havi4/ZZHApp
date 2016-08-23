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
#import "CantainerDeviceListViewController.h"
#import "ModalAnimation.h"
#import "NewCalendarViewController.h"
#import "SCNavigationController.h"
#import "NaviTitleScrollView.h"

static CGFloat CALENDER_VIEW_HEIGHT = 106.f;
@interface CenterViewController ()<CLWeeklyCalendarViewDelegate,UIViewControllerTransitioningDelegate>
{
    ModalAnimation *_modalAnimationController;
}

@property (nonatomic, strong) SCBarButtonItem *leftBarItem;
@property (nonatomic, strong) BaseViewContainerView *containerDataView;
@property (nonatomic, strong) DeviceList *activeDeviceInfo;
@property (nonatomic, strong) CLWeeklyCalendarView* calendarView;
@property (nonatomic, strong) CalendarHomeViewController *chvc;//日历包括农历

@property (nonatomic, strong) SCBarButtonItem *rightBarItem;
@property (nonatomic, strong) NaviTitleScrollView *naviBarTitle;
@property (nonatomic, strong) UIButton *calendarButton;

@end

@implementation CenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNaviBarView];
    [self createBarItems];
    [self queryDeviceListForControllers];
//    [self initDatePicker];
}

- (void)queryDeviceListForControllers
{
    @weakify(self)
    [self checkUserDevice:^(DeviceList *device, NSError *error) {
        @strongify(self);
        [self.containerDataView.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromParentViewController];
        }];
        self.activeDeviceInfo = device;
        gloableActiveDevice = device;
        [self initCenterViewControllers];
    }];
}

- (void)initDatePicker
{
//    [self.view addSubview:self.calendarView];
    if (selectedDateToUse) {
        [self.calendarView redrawToDate:selectedDateToUse];
    }
}

- (void)createBarItems
{
    self.naviBarTitle = [[NaviTitleScrollView alloc]initWithFrame:(CGRect){(self.view.frame.size.width-100)/2.0+1,20,100,44}];
    self.naviBarTitle.userInteractionEnabled = NO;
    self.naviBarTitle.backgroundColor = [UIColor clearColor];
    selectedDateToUse = [NSDate date];
    self.backgroundImageView.image = [UIImage imageNamed:@"home_back@3x"];
    self.leftBarItem = [[SCBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gn"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowMenuNotification object:nil];
    }];
    self.sc_navigationItem.leftBarButtonItem = self.leftBarItem;
    
    self.rightBarItem = [[SCBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_share@3x"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        [self shareApp:nil];
    }];
    self.sc_navigationItem.rightBarButtonItem = self.rightBarItem;
    
    self.calendarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.calendarButton.frame = (CGRect){self.view.frame.size.width -16-44-45,20,50,44};
    NSString *dateString = [NSString stringWithFormat:@"%@",selectedDateToUse];
    NSString *dateTime = [NSString stringWithFormat:@"%@/%@",[dateString substringWithRange:NSMakeRange(5, 2)],[dateString substringWithRange:NSMakeRange(8, 2)]];
    [self.calendarButton setTitle:dateTime forState:UIControlStateNormal];
    self.calendarButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.calendarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.calendarButton addTarget:self action:@selector(showCalendarView:) forControlEvents:UIControlEventTouchUpInside];
    [self.sc_navigationBar addSubview:self.calendarButton];
    [self.sc_navigationBar addSubview:self.naviBarTitle];
    self.sc_navigationBar.backgroundColor = [UIColor clearColor];

}

- (void)initNaviBarView
{
    
    self.navigationController.navigationBarHidden = YES;
    self.containerDataView = [[BaseViewContainerView alloc]initWithNavBarControllers:nil navBarBackground:nil showPageControl:NO];
    self.containerDataView.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.containerDataView.view];
    [self addChildViewController:self.containerDataView];
    @weakify(self);
    self.containerDataView.didChangedPage = ^(NSInteger currentPageIndex){
        // Do something
        @strongify(self);
        NSLog(@"index %ld", (long)currentPageIndex);
        selectPageIndex = currentPageIndex;
        [self.naviBarTitle setCurrentIndex:currentPageIndex];
    };
    [self.containerDataView.view setHeight:[UIScreen mainScreen].bounds.size.height];
}

- (void)checkUserDevice:(void (^)(DeviceList *device, NSError *error))block
{
    ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
    NSDictionary *dic = @{
                          @"UserID" : thirdPartyLoginUserId,
                          };
    [client requestCheckAllDeviceListParams:dic andBlock:^(AllDeviceModel *myDeviceList, NSError *error) {
        __block BOOL noMyDevice = YES;
        __block BOOL noFriendDevice = YES;
        if (myDeviceList) {
            NSArray *myDeviceListArr = myDeviceList.myDeviceList;
            [myDeviceListArr enumerateObjectsUsingBlock:^(DeviceList*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.isActivated isEqualToString:@"True"]) {
                    block(obj,nil);
                    *stop = YES;
                    noMyDevice = NO;
                }
            }];
            
            NSArray *friendDeviceListArr = myDeviceList.friendDeviceList;
            [friendDeviceListArr enumerateObjectsUsingBlock:^(DeviceList*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.isActivated isEqualToString:@"True"]) {
                    block(obj,nil);
                    *stop = YES;
                    noFriendDevice = NO;
                }
            }];
            if(noMyDevice && noFriendDevice){
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
        NSMutableArray *arr = @[].mutableCopy;
        [self.activeDeviceInfo.detailDeviceList enumerateObjectsUsingBlock:^(DetailDeviceList*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self);
            CenterDataShowViewController *dataShow = [[CenterDataShowViewController alloc]init];
            dataShow.title = @"";
            dataShow.deviceUUID = obj.detailUUID;
            dataShow.view.frame = self.containerDataView.view.bounds;
            [self.containerDataView addViewControllers:dataShow needToRefresh:YES];
            [arr addObject:obj.detailDescription];
        }];
        self.naviBarTitle.titles = arr;
    }
    
}

- (void)showCalendarView:(UIButton *)button
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshDate:) name:@"kSelectedNewDate" object:nil];
    NewCalendarViewController *modal = [[NewCalendarViewController alloc] init];
    SCNavigationController *navi = [[SCNavigationController alloc]initWithRootViewController:modal];//
    [self presentViewController:navi animated:YES completion:^{
    }];
}

- (void)refreshDate:(NSNotification *)noti
{
    NSDate *selectDate = (NSDate *)[noti.userInfo objectForKey:@"date"];
    selectedDateToUse = [selectDate dateByAddingHours:8];
    NSString *dateString = [NSString stringWithFormat:@"%@",selectedDateToUse];
    NSString *dateTime = [NSString stringWithFormat:@"%@/%@",[dateString substringWithRange:NSMakeRange(5, 2)],[dateString substringWithRange:NSMakeRange(8, 2)]];
    [self.calendarButton setTitle:dateTime forState:UIControlStateNormal];
    __block NSString *queryEndDate = [SleepModelChange chageDateFormatteToQueryString:selectedDateToUse];
    __block NSString *queryFromDate = [SleepModelChange chageDateFormatteToQueryString:[selectedDateToUse dateByAddingDays:-1]];
    [self.containerDataView.childViewControllers enumerateObjectsUsingBlock:^(__kindof CenterDataShowViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj getSleepDataWithStartTime:queryFromDate endTime:queryEndDate];
    }];
}

#pragma mark setter

//- (UIButton *)leftMenuButton
//{
//    if (!_leftMenuButton) {
//        _leftMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _leftMenuButton.backgroundColor = [UIColor clearColor];
//        [_leftMenuButton dk_setImage:DKImageWithNames(@"re_order_0", @"re_order_1") forState:UIControlStateNormal];
//        [_leftMenuButton setFrame:CGRectMake(0, 20, 44, 44)];
//        [_leftMenuButton addTarget:self action:@selector(showLeftView) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _leftMenuButton;
//}
//
//- (UIButton *)rightMenuButton
//{
//    if (!_rightMenuButton) {
//        _rightMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _rightMenuButton.backgroundColor = [UIColor clearColor];
//        [_rightMenuButton dk_setImage:DKImageWithNames(@"btn_point_0", @"btn_point_1") forState:UIControlStateNormal];
//        [_rightMenuButton setFrame:CGRectMake(self.view.frame.size.width-50, 20, 44, 44)];
//        [_rightMenuButton addTarget:self action:@selector(showMoreInfo:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _rightMenuButton;
//}

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
        _chvc.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
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
        if ([selectedDate isLaterThan:[NSDate date]]) {
            [NSObject showHudTipStr:@"不要着急,明天才会睡眠数据呦!"];
            [self.calendarView redrawToDate:[NSDate date]];
            return;
        }
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
    if ([date isLaterThan:[NSDate date]]) {
        [NSObject showHudTipStr:@"不要着急,明天才会有睡眠数据呦!"];
        [self.calendarView redrawToDate:[NSDate date]];
        return;
    }
    selectedDateToUse = date;
    __block NSString *queryEndDate = [SleepModelChange chageDateFormatteToQueryString:date];
    __block NSString *queryFromDate = [SleepModelChange chageDateFormatteToQueryString:[date dateByAddingDays:-1]];
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
        [self showDropDownView];
    }else if ([item.title isEqualToString:@"分享应用"]){
        [self shareApp:nil];
    }
}

#pragma mark dropDown Menu

- (void)showDropDownView
{
    // Init dropdown view
    _modalAnimationController = [[ModalAnimation alloc] init];
    CantainerDeviceListViewController *modal = [[CantainerDeviceListViewController alloc] init];
    modal.transitioningDelegate = self;
    modal.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:modal animated:YES completion:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

#pragma mark - Transitioning Delegate (Modal)
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    _modalAnimationController.type = AnimationTypePresent;
    return _modalAnimationController;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    _modalAnimationController.type = AnimationTypeDismiss;
    return _modalAnimationController;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
