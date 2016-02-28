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
    [self createNavWithTitle:@"" createMenuItem:^UIView *(int nIndex)
     {
         if (nIndex == 1)
         {
             return self.menuButton;
         }
         else if (nIndex == 0){
             [self.rightMenuButton dk_setBackgroundImage:DKImageWithNames(@"plus_math_0", @"plus_math_1") forState:UIControlStateNormal];
             [self.rightMenuButton addTarget:self action:@selector(addProduct:) forControlEvents:UIControlEventTouchUpInside];
             return self.rightMenuButton;
         }
         
         return nil;
     }];
}

- (UIButton *)rightMenuButton
{
    if (!_rightMenuButton) {
        _rightMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightMenuButton.frame = CGRectMake(self.view.frame.size.width-35, 12, 20, 20);
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
    self.segmentTitle = [[UISegmentedControl alloc] initWithItems:@[@"我的设备", @"他人设备"]];
    self.segmentTitle.selectedSegmentIndex = 0;
    self.segmentTitle.dk_tintColorPicker = kTextColorPicker;
    self.segmentTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.segmentTitle.frame = CGRectMake(70, 30, self.view.frame.size.width-140, 25);
    [self.segmentTitle addTarget:self action:@selector(switchView) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segmentTitle];
    
    [self addChildViewController:self.myNewDeviceList];
    
    [self.view addSubview:_myNewDeviceList.view];
}

//选择控件的事件
- (void)switchView
{
    for (UIView *subview in [self.view subviews]) {
        if (subview.tag == 1001 || subview.tag == 1002) {
            [subview removeFromSuperview];
        }
    }
    switch (_segmentTitle.selectedSegmentIndex) {
        case 0: {
            [self.rightMenuButton dk_setBackgroundImage:DKImageWithNames(@"plus_math_0", @"plus_math_1") forState:UIControlStateNormal];
            [self.rightMenuButton removeTarget:self action:@selector(searchDevice:) forControlEvents:UIControlEventTouchUpInside];
            [self.rightMenuButton addTarget:self action:@selector(addProduct:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_myNewDeviceList.view];
            _myNewDeviceList.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
            break;
        }
        case 1: {
            if (![self.childViewControllers containsObject:self.friendDeviceList]) {
                [self addChildViewController:self.friendDeviceList];
            }
            [self.rightMenuButton dk_setBackgroundImage:DKImageWithNames(@"search_0", @"search_1") forState:UIControlStateNormal];
            [self.rightMenuButton removeTarget:self action:@selector(addProduct:) forControlEvents:UIControlEventTouchUpInside];
            [self.rightMenuButton addTarget:self action:@selector(searchDevice:) forControlEvents:UIControlEventTouchUpInside];
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
