//
//  DeviceListViewController.m
//  SleepRecoding
//
//  Created by Havi on 15/11/11.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import "DeviceListViewController.h"
#import "FriendDeviceListViewController.h"
#import "UISearchBar+Common.h"
#import "AddProductNameViewController.h"
#import "MyDeviceListViewController.h"

@interface DeviceListViewController ()<UISearchBarDelegate,UISearchDisplayDelegate>

@property (nonatomic, strong) UISegmentedControl *segmentTitle;
@property (nonatomic, strong) FriendDeviceListViewController *friendDeviceList;
@property (nonatomic, strong) MyDeviceListViewController *myNewDeviceList;
@property (nonatomic, strong) UIButton *rightMenuButton;

@property (nonatomic, strong) SCBarButtonItem *leftBarItem;
@property (nonatomic, strong) SCBarButtonItem *rightBarItem;

@end

@implementation DeviceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavigationBar];
    [self setNaviTitleView];
}

- (void)initNavigationBar
{
    self.navigationController.navigationBarHidden = YES;
    self.leftBarItem = [[SCBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gn"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowMenuNotification object:nil];
    }];
    
    self.sc_navigationItem.leftBarButtonItem = self.leftBarItem;
    self.rightBarItem = [[SCBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"jia"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        [self addProduct:nil];
    }];
    self.sc_navigationItem.rightBarButtonItem = self.rightBarItem;

}

- (UIButton *)rightMenuButton
{
    if (!_rightMenuButton) {
        _rightMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightMenuButton.frame = CGRectMake(self.view.frame.size.width-49, 0, 49, 44);
    }
    return _rightMenuButton;
}

- (MyDeviceListViewController*)myNewDeviceList
{
    if (!_myNewDeviceList) {
        _myNewDeviceList = [[MyDeviceListViewController alloc]init];
        _myNewDeviceList.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
        _myNewDeviceList.view.tag = 1001;
    }
    return _myNewDeviceList;
}

- (FriendDeviceListViewController *)friendDeviceList
{
    if (!_friendDeviceList) {
        _friendDeviceList = [[FriendDeviceListViewController alloc]init];
        _friendDeviceList.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
        _friendDeviceList.view.tag = 1002;
    }
    return _friendDeviceList;
}

//设置导航栏中的titleView
- (void)setNaviTitleView
{
    self.segmentTitle = [[UISegmentedControl alloc] initWithItems:@[@"我的设备", @"好友设备"]];
    self.segmentTitle.selectedSegmentIndex = 0;
    self.segmentTitle.dk_tintColorPicker = kTextColorPicker;
    self.segmentTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.segmentTitle.frame = CGRectMake(70, 30, self.view.frame.size.width-140, 25);
    UIView *backView = [[UIView alloc]init];
    backView.frame = (CGRect){70,20,self.view.frame.size.width - 140,44};
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom ];
    [leftButton setTitle:@"我的设备" forState:UIControlStateNormal];
    [leftButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftButton.frame = (CGRect){0,0,(self.view.frame.size.width - 140)/2,44};
    leftButton.tag = 9000;
    [leftButton addTarget:self action:@selector(switchView:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom ];
    [rightButton setTitle:@"他人设备" forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    rightButton.frame = (CGRect){(self.view.frame.size.width - 140)/2,0,(self.view.frame.size.width - 140)/2,44};
    rightButton.tag = 9001;
    [rightButton addTarget:self action:@selector(switchView:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:leftButton];
    [backView addSubview:rightButton];
    [self.sc_navigationBar addSubview:backView];
    
    [self addChildViewController:self.myNewDeviceList];
    
    [self.view addSubview:_myNewDeviceList.view];
}

//选择控件的事件
- (void)switchView:(UIButton *)button
{
    for (UIView *subview in [self.view subviews]) {
        if (subview.tag == 1001 || subview.tag == 1002) {
            [subview removeFromSuperview];
        }
    }
    switch (button.tag) {
        case 9000: {
            [button.titleLabel setFont:[UIFont systemFontOfSize:17]];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            UIButton *buttonRight = [self.view viewWithTag:9001];
            [buttonRight.titleLabel setFont:[UIFont systemFontOfSize:16]];
            [buttonRight setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            self.rightBarItem = [[SCBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"jia"] style:SCBarButtonItemStylePlain handler:^(id sender) {
                [self addProduct:nil];
            }];
            self.sc_navigationItem.rightBarButtonItem = self.rightBarItem;

            [self.view addSubview:_myNewDeviceList.view];
            _myNewDeviceList.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
            break;
        }
        case 9001: {
            if (![self.childViewControllers containsObject:self.friendDeviceList]) {
                [self addChildViewController:self.friendDeviceList];
            }
            [button.titleLabel setFont:[UIFont systemFontOfSize:17]];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            UIButton *buttonRight = [self.view viewWithTag:9000];
            [buttonRight.titleLabel setFont:[UIFont systemFontOfSize:16]];
            [buttonRight setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            self.rightBarItem = [[SCBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sousuo"] style:SCBarButtonItemStylePlain handler:^(id sender) {
                [self searchDevice:nil];
            }];
            self.sc_navigationItem.rightBarButtonItem = self.rightBarItem;

            [self.view addSubview:_friendDeviceList.view];
            _friendDeviceList.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
            
            break;
        }
        default:
            break;
    }
}

- (void)addProduct:(UIButton *)sender
{
    AddProductNameViewController *addProductName = [[AddProductNameViewController alloc]init];
    [self.navigationController pushViewController:addProductName animated:YES];
}

- (void)searchDevice:(UIButton*)sender
{
    _searchBar = ({
        SearchBarCustom *searchBar = [[SearchBarCustom alloc] init];
        searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 64);
        searchBar.delegate = self;
        [searchBar sizeToFit];
        [searchBar setPlaceholder:@"输入手机号查找相应的设备"];
        [searchBar setTintColor:[UIColor blueColor]];
        searchBar.showsCancelButton = YES;
        [searchBar setTranslucent:NO];
        [searchBar insertBGColor:[UIColor colorWithHexString:@"0x28303b"]];
        [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor whiteColor]];
        searchBar;
    });
    [self.navigationController.view addSubview:_searchBar];
    [_searchBar setTop:20];
    [_searchBar setHeight:64];
    _searchDisplayVC = ({
        SearchBarDisplayController *searchVC = [[SearchBarDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
        searchVC.parentVC = self;
        searchVC;
    });
    [_searchBar becomeFirstResponder];
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
