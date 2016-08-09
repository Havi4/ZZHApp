//
//  LeaveContainerViewController.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/25.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "ChartTableContainerViewController.h"
#import "BaseViewContainerView.h"
#import "ChartTableViewController.h"
#import "NaviTitleScrollView.h"

@interface ChartTableContainerViewController ()
@property (nonatomic, strong) NaviTitleScrollView *naviBarTitle;

@property (nonatomic, strong) BaseViewContainerView *containerDataView;
@property (nonatomic, strong) SCBarButtonItem *leftBarItem;
@property (nonatomic, strong) SCBarButtonItem *rightBarItem;

@end

@implementation ChartTableContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNaviBarView];
    [self initCenterViewControllers];
}

- (void)initNaviBarView
{
    self.naviBarTitle = [[NaviTitleScrollView alloc]initWithFrame:(CGRect){(self.view.frame.size.width-100)/2.0+1,20,100,44}];
    self.naviBarTitle.userInteractionEnabled = NO;
    self.naviBarTitle.backgroundColor = [UIColor clearColor];

    self.navigationController.navigationBarHidden = YES;
    self.containerDataView = [[BaseViewContainerView alloc]initWithNavBarControllers:nil navBarBackground:nil showPageControl:NO];
    self.containerDataView.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.containerDataView.view];
    [self addChildViewController:self.containerDataView];
    @weakify(self);
    self.containerDataView.didChangedPage = ^(NSInteger currentPageIndex){
        // Do something
        @strongify(self);
        [self.naviBarTitle setCurrentIndex:currentPageIndex];
    };
    self.leftBarItem = [[SCBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_navi_back"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        [self backToHome];
    }];
    
    self.sc_navigationItem.leftBarButtonItem = self.leftBarItem;
    
    self.rightBarItem = [[SCBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_share@3x"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        [self showMoreInfo];
    }];
    self.sc_navigationItem.rightBarButtonItem = self.rightBarItem;
    [self.sc_navigationBar addSubview:self.naviBarTitle];
    self.sc_navigationBar.backgroundColor = [UIColor clearColor];
}

- (void)initCenterViewControllers
{
    if (gloableActiveDevice.detailDeviceList.count == 0) {
        ChartTableViewController *dataShow = [[ChartTableViewController alloc]init];
        dataShow.title = gloableActiveDevice.nDescription;
        dataShow.deviceUUID = gloableActiveDevice.deviceUUID;
        dataShow.sensorType = self.sensorType;
        [self.containerDataView addViewControllers:dataShow needToRefresh:YES];
    }else{
        NSMutableArray *arr = @[].mutableCopy;
        @weakify(self);
        [gloableActiveDevice.detailDeviceList enumerateObjectsUsingBlock:^(DetailDeviceList*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self);
            ChartTableViewController *dataShow = [[ChartTableViewController alloc]init];
            dataShow.deviceUUID = obj.detailUUID;
            dataShow.title = @"";
            dataShow.sensorType = self.sensorType;
            [self.containerDataView addViewControllers:dataShow needToRefresh:YES];
            [arr addObject:obj.detailDescription];
        }];
        [self.containerDataView setCurrentIndex:selectPageIndex animated:NO];
        self.naviBarTitle.titles = arr;
    }
}

#pragma mark setter

- (void)backToHome
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showMoreInfo
{
    [self.shareNewMenuView showInView:self.view];
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
