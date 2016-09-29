//
//  HeartContainerViewController.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/25.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "ChartContainerViewController.h"
#import "BaseViewContainerView.h"
#import "ChartDataViewController.h"
#import "NaviTitleScrollView.h"
//new
#import "ConsultVViewController.h"

@interface ChartContainerViewController ()
@property (nonatomic, strong) NaviTitleScrollView *naviBarTitle;

@property (nonatomic, strong) BaseViewContainerView *containerDataView;
@property (nonatomic, strong) SCBarButtonItem *leftBarItem;
@property (nonatomic, strong) SCBarButtonItem *rightBarItem;


@end

@implementation ChartContainerViewController

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
        [self shareInfo];
    }];
    self.sc_navigationItem.rightBarButtonItem = self.rightBarItem;
    [self.sc_navigationBar addSubview:self.naviBarTitle];
    self.sc_navigationBar.backgroundColor = [UIColor clearColor];

}

- (void)initCenterViewControllers
{
    if (gloableActiveDevice.detailDeviceList.count == 0) {
        ChartDataViewController *dataShow = [[ChartDataViewController alloc]init];
        dataShow.title = gloableActiveDevice.nDescription;
        dataShow.deviceUUID = gloableActiveDevice.deviceUUID;
        dataShow.sensorType = self.sensorType;
        [self.containerDataView addViewControllers:dataShow needToRefresh:YES];
    }else{
        @weakify(self);
        NSMutableArray *arr = @[].mutableCopy;
        [gloableActiveDevice.detailDeviceList enumerateObjectsUsingBlock:^(DetailDeviceList*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self);
            ChartDataViewController *dataShow = [[ChartDataViewController alloc]init];
            dataShow.deviceUUID = obj.detailUUID;
            dataShow.title = @"";
            dataShow.sensorType = self.sensorType;
            [self.containerDataView addViewControllers:dataShow needToRefresh:YES];
            [arr addObject:obj.detailDescription];
        }];
         [self.containerDataView setCurrentIndex:selectPageIndex animated:NO];
        self.naviBarTitle.titles = arr;
        [self.naviBarTitle setCurrentIndex:selectPageIndex];
    }
}


#pragma mark setter

- (void)backToHome
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareInfo
{
     [self.shareNewMenuView showInView:self.view];
}

#pragma mark showMoreInfo

- (void)showMoreInfo:(UIButton *)sender
{
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"快速提问"
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
    if ([item.title isEqualToString:@"快速提问"]) {
        ConsultVViewController *consult = [[ConsultVViewController alloc]init];
        [self.navigationController pushViewController:consult animated:YES];
    }else if ([item.title isEqualToString:@"分享应用"]){
        [self shareInfo];
    }
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
