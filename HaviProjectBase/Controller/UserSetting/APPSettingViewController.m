//
//  APPSettingViewController.m
//  SleepRecoding
//
//  Created by Havi on 15/3/15.
//  Copyright (c) 2015年 Havi. All rights reserved.
//

#import "APPSettingViewController.h"
#import "AppSettingDelegate.h"
#import "PersonManagerViewController.h"
#import "ModifyPassWordViewController.h"
#import "UserProtocolViewController.h"
#import "AboutMeViewController.h"
#import "SelectThemeViewController.h"
#import "PassCodeSettingViewController.h"
//#import "LoginViewController.h"
#import "AppDelegate.h"
//#import "WeiBoLogoutAPI.h"

@interface APPSettingViewController ()

@property (nonatomic, strong) UITableView *appSettingView;
@property (nonatomic, strong) AppSettingDelegate *appDelegate;
@property (nonatomic, strong) NSMutableArray *controllerClassArray;

@end

@implementation APPSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBar];
    [self addTableViewDataHandle];
    // Do any additional setup after loading the view.
}

- (void)initNavigationBar
{
    self.navigationController.navigationBarHidden = YES;
    self.controllerClassArray = @[].mutableCopy;
    [self createNavWithTitle:@"设定" createMenuItem:^UIView *(int nIndex)
     {
         if (nIndex == 1)
         {
             return self.menuButton;
         }
         return nil;
     }];
    [self addControllerToCellArrayWithClassName:@[@"PersonManagerViewController",@"ModifyPassWordViewController",@"SelectThemeViewController",@"PassCodeSettingViewController"]];
    [self addControllerToCellArrayWithClassName:@[@"UserProtocolViewController",@"AboutMeViewController"]];
    [self addControllerToCellArrayWithClassName:@[@""]];
    
    
}

- (void)addTableViewDataHandle
{
    [self.view addSubview:self.appSettingView];
    TableViewCellConfigureBlock configureCellBlock = ^(NSIndexPath *indexPath, id item, UITableViewCell *cell){
        [cell configure:cell customObj:item indexPath:indexPath];
        
    };
    CellHeightBlock configureCellHeightBlock = ^ CGFloat (NSIndexPath *indexPath, id item){
        return 49;
    };
    @weakify(self);
    DidSelectCellBlock didSelectBlock = ^(NSIndexPath *indexPath, id item){
        @strongify(self);
        [self didSelectedCell:indexPath obj:item];
    };
    NSString *dataPath = [[NSBundle mainBundle]pathForResource:@"AppSetting" ofType:@"plist"];
    NSArray *dataArr = [NSArray arrayWithContentsOfFile:dataPath];
    
    self.appDelegate = [[AppSettingDelegate alloc]initWithItems:dataArr cellIdentifier:@"cell" configureCellBlock:configureCellBlock cellHeightBlock:configureCellHeightBlock didSelectBlock:didSelectBlock];
    
    [self.appDelegate handleTableViewDataSourceAndDelegate:self.appSettingView];
    [self.appSettingView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.view.mas_top).offset(64);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
    }];
}

- (UITableView *)appSettingView
{
    if (!_appSettingView) {
        _appSettingView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _appSettingView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _appSettingView.backgroundColor = KTableViewBackGroundColor;
    }
    return _appSettingView;
}

- (void)addControllerToCellArrayWithClassName:(NSArray *)controllerName
{
    [self.controllerClassArray addObject:controllerName];
}

- (void)didSelectedCell:(NSIndexPath *)indexPath obj:(id)obj
{
    NSString *className = [[self.controllerClassArray objectOrNilAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    Class class = NSClassFromString(className);
    if (class) {
        UIViewController *controller = class.new;
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        [self logoutMyId];
    }
}

#pragma mark setter

- (void)logoutMyId
{
    [UserManager resetUserInfo];
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    if ([thirdPartyLoginPlatform isEqualToString:SinaPlatform]) {
//        [WeiBoLogoutAPI weiBoLogoutWithTocken:app.wbtoken parameters:nil finished:^(NSURLResponse *response, NSData *data) {
//            NSDictionary *obj = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//            NSLog(@"微博登出结果%@",obj);
//        } failed:^(NSURLResponse *response, NSError *error) {
//            
//        }];
//    }
//    [[NSUserDefaults standardUserDefaults]setObject:@"18:00" forKey:UserDefaultStartTime ];
//    [[NSUserDefaults standardUserDefaults]setObject:@"06:00" forKey:UserDefaultEndTime ];
//    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc]initWithRootViewController:app.containerView] animated:YES];
//    [self.sideMenuViewController hideMenuViewController];
//    isDoubleDevice = NO;
//    [[NSNotificationCenter defaultCenter]postNotificationName:ThirdUserLogoutNoti object:nil];
}


- (void)backToHomeView:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reloadThemeImage
{
//    [super reloadThemeImage];
//    UIImage *i = [UIImage imageNamed:[NSString stringWithFormat:@"re_order_%d",selectedThemeIndex]];
//    [self.menuButton setImage:i forState:UIControlStateNormal];
//    self.bgImageView.image = [UIImage imageNamed:@""];
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
