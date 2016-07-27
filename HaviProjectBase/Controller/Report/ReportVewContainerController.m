//
//  ReportVewContainerController.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/26.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "ReportVewContainerController.h"
#import "BaseViewContainerView.h"
#import "ReportDataShowViewController.h"
#import "UIImage+Tint.h"

@interface ReportVewContainerController ()

@property (nonatomic, strong) BaseViewContainerView *containerDataView;
@property (nonatomic, strong) SCBarButtonItem *leftBarItem;
@property (nonatomic, strong) SCBarButtonItem *rightBarItem;

@end

@implementation ReportVewContainerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNaviBarView];
    [self initCenterViewControllers];
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
    [self.containerDataView.navigationBarView addSubview:self.leftButton];
    self.leftBarItem = [[SCBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_menu"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowMenuNotification object:nil];
    }];
    
    self.sc_navigationItem.leftBarButtonItem = self.leftBarItem;
    
    self.rightBarItem = [[SCBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"btn_share_0"] imageWithTintColor:[UIColor whiteColor]] style:SCBarButtonItemStylePlain handler:^(id sender) {
        [self showMoreInfo];
    }];
    self.sc_navigationItem.rightBarButtonItem = self.rightBarItem;
}

- (void)initCenterViewControllers
{
    if (gloableActiveDevice.detailDeviceList.count == 0) {
        ReportDataShowViewController *dataShow = [[ReportDataShowViewController alloc]init];
        dataShow.title = gloableActiveDevice.nDescription.length == 0?@"":gloableActiveDevice.nDescription;
        dataShow.deviceUUID = gloableActiveDevice.deviceUUID;
        dataShow.reportType = self.reportType;
        [self.containerDataView addViewControllers:dataShow needToRefresh:YES];
    }else{
        @weakify(self);
        [gloableActiveDevice.detailDeviceList enumerateObjectsUsingBlock:^(DetailDeviceList*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self);
            ReportDataShowViewController *dataShow = [[ReportDataShowViewController alloc]init];
            dataShow.deviceUUID = obj.detailUUID;
            dataShow.title = obj.detailDescription;
            dataShow.reportType = self.reportType;
            [self.containerDataView addViewControllers:dataShow needToRefresh:YES];
        }];
    }
}

- (void)backToHome
{
    [self.sidePanelController showLeftPanelAnimated:YES];
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
