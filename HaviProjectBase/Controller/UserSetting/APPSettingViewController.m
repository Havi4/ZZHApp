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
#import "JPUSHService.h"
//#import "LoginViewController.h"
#import "AppDelegate.h"
#import "ChangeLanguageViewController.h"
@interface APPSettingViewController ()

@property (nonatomic, strong) UITableView *appSettingView;
@property (nonatomic, strong) AppSettingDelegate *appDelegate;
@property (nonatomic, strong) NSMutableArray *controllerClassArray;
@property (nonatomic, strong) SCBarButtonItem *leftBarItem;

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
    self.navigationController.navigationBarHidden = YES;
    self.leftBarItem = [[SCBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gn"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowMenuNotification object:nil];
    }];
    self.sc_navigationItem.title = @"设定";
    self.sc_navigationItem.leftBarButtonItem = self.leftBarItem;
    if ([thirdPartyLoginPlatform isEqualToString: kMeddoPlatform]) {
        [self addControllerToCellArrayWithClassName:@[@"PersonManagerViewController",@"ModifyPassWordViewController"]];
//        [self addControllerToCellArrayWithClassName:@[@"PersonManagerViewController",@"ModifyPassWordViewController",@"SelectThemeViewController",@"PassCodeSettingViewController"]];
    }else{
        [self addControllerToCellArrayWithClassName:@[@"PersonManagerViewController"]];
//        [self addControllerToCellArrayWithClassName:@[@"PersonManagerViewController",@"SelectThemeViewController",@"PassCodeSettingViewController"]];
    }
    [self addControllerToCellArrayWithClassName:@[@"UserProtocolViewController",@"AboutMeViewController"]];
//    [self addControllerToCellArrayWithClassName:@[@"ChangeLanguageViewController"]];
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
    NSArray *dataArr = @[];
    if ([thirdPartyLoginPlatform isEqualToString: kMeddoPlatform]){
    
        NSString *dataPath = [[NSBundle mainBundle]pathForResource:@"AppSetting" ofType:@"plist"];
        dataArr = [NSArray arrayWithContentsOfFile:dataPath];
    }else{
        NSString *dataPath = [[NSBundle mainBundle]pathForResource:@"AppSetting1" ofType:@"plist"];
        dataArr = [NSArray arrayWithContentsOfFile:dataPath];
    }
    
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
        if (indexPath.section == 0 && indexPath.row == 0) {
            PersonManagerViewController *person = (PersonManagerViewController *)controller;
            person.isNavi = YES;
            [self.navigationController pushViewController:person animated:YES];

        }else{
            [self.navigationController pushViewController:controller animated:YES];

        }
    }else{
        [self logoutMyId];
    }
}

#pragma mark setter

- (void)logoutMyId
{
    [self uploadRegisterID];
    [UserManager resetUserInfo];
    
}

- (void)uploadRegisterID
{
    NSString *registerID = [JPUSHService registrationID];

    NSDictionary *dic = @{
                          @"UserId": thirdPartyLoginUserId, //关键字，必须传递
                          @"PushRegistrationId": registerID, //密码
                          @"AppVersion" : [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                          @"OSName" : @"iOS",
                          @"OSVersion" : [UIDevice currentDevice].systemVersion,
                          @"CellPhoneModal" : [UIDevice currentDevice].machineModelName,
                          @"OffLine": @"1"
                          };
    ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
    [client requestRegisterUserIdForPush:dic andBlock:^(BaseModel *baseModel, NSError *error) {
        
    }];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app setLoginViewController];
}


- (void)backToHomeView:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
