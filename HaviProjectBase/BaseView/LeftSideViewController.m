//
//  LeftSideViewController.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/3.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "LeftSideViewController.h"
#import "IconImageView.h"
#import "LeftSideTableDataDelegate.h"
#import "LeftSideTableViewCell.h"
#import "DataShowTableViewCell.h"
#import "AppDelegate.h"
//侧栏
#import "PersonManagerViewController.h"
#import "DeviceListViewController.h"
#import "MessageListViewController.h"
#import "SleepSettingViewController.h"
#import "APPSettingViewController.h"
#import "ReportVewContainerController.h"

@interface LeftSideViewController ()

@property (nonatomic, strong) IconImageView *userIconImageView;
@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) LeftSideTableDataDelegate *dataDelegate;
@property (nonatomic, strong) NSMutableArray *controllerClassArray;
@property (nonatomic, strong) PersonManagerViewController *personInfo;

@end

@implementation LeftSideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addSubView];
    [self addConstraintsToViews];
    [self addTableViewDataHandle];
}

#pragma mark init views

- (void)addSubView
{
    self.backgroundImageView.dk_imagePicker = DKImageWithNames( @"left_bg_night",@"left_bg_day");
    [self.view addSubview:self.userIconImageView];
    @weakify(self);
    self.userIconImageView.tapIconBlock = ^(NSUInteger index){
        @strongify(self);
        [self tapedUserInfoView];
    };
    [self.view addSubview:self.listTableView];
    self.controllerClassArray = [NSMutableArray new];
    [self addControllerToCellArrayWithClassName:@"CenterViewController"];
    [self addControllerToCellArrayWithClassName:@""];
    [self addControllerToCellArrayWithClassName:@"DeviceListViewController"];
    [self addControllerToCellArrayWithClassName:@"SleepSettingViewController"];
    [self addControllerToCellArrayWithClassName:@"MessageListViewController"];
    [self addControllerToCellArrayWithClassName:@"APPSettingViewController"];
    [self setUserInfo];

}

- (void)setUserInfo
{
    NSMutableString *userId = [[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"%@",thirdPartyLoginNickName]];
    if (userId.length == 0) {
        _userIconImageView.userName = @"匿名用户";
    }else if ([userId intValue]>0){
        [userId replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        _userIconImageView.userName = userId;
    }else{
        _userIconImageView.userName = userId;
    }
    
    
    if (thirdPartyLoginIcon.length>0) {
        _userIconImageView.userIconURL = thirdPartyLoginIcon;
    }else{
        _userIconImageView.userIconURL = [NSString stringWithFormat:@"%@%@%@",kAppBaseURL,@"v1/file/DownloadFile/",thirdPartyLoginUserId];
    }
}

- (void)addTableViewDataHandle
{
    TableViewCellConfigureBlock configureCellBlock = ^(NSIndexPath *indexPath, id item, UITableViewCell *cell){
        if (indexPath.row == 1) {
            ((DataShowTableViewCell *)cell).target = self;
            ((DataShowTableViewCell *)cell).buttonTaped = @selector(tapReportView:);
            [cell configure:cell customObj:item indexPath:indexPath];
        }else{
            [cell configure:cell customObj:item indexPath:indexPath withOtherInfo:nil];
        }
    };
    CellHeightBlock configureCellHeightBlock = ^ CGFloat (NSIndexPath *indexPath, id item){
        if (indexPath.row == 1) {
            return 110;
        }else{
            return [LeftSideTableViewCell getCellHeightWithCustomObj:item indexPath:indexPath];
        }
    };
    @weakify(self);
    DidSelectCellBlock didSelectBlock = ^(NSIndexPath *indexPath, id item){
        DeBugLog(@"select cell %ld",(long)indexPath.row);
        @strongify(self);
        [self didSeletedCellIndexPath:indexPath withData:item];
    };
    NSString *dataPath = [[NSBundle mainBundle]pathForResource:@"LeftSidePlist" ofType:@"plist"];
    NSArray *dataArr = [NSArray arrayWithContentsOfFile:dataPath];
    self.dataDelegate = [[LeftSideTableDataDelegate alloc]initWithItems:dataArr cellIdentifier:@"cell" configureCellBlock:configureCellBlock cellHeightBlock:configureCellHeightBlock didSelectBlock:didSelectBlock];
    [self.dataDelegate handleTableViewDataSourceAndDelegate:self.listTableView];
}

- (UITableView *)listTableView
{
    if (!_listTableView) {
        _listTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _listTableView.backgroundColor = [UIColor clearColor];
        _listTableView.tableFooterView = [[UIView alloc]init];
        _listTableView.dk_separatorColorPicker = kTextColorPicker;
    }
    return _listTableView;
}

- (IconImageView *)userIconImageView
{
    if (!_userIconImageView) {
        _userIconImageView = [[IconImageView alloc]init];
    }
    return _userIconImageView;
}

- (PersonManagerViewController *)personInfo
{
    if (!_personInfo) {
        _personInfo = [[PersonManagerViewController alloc]init];
    }
    return _personInfo;
}

#pragma mark add Constraints

- (void)addConstraintsToViews
{
    [_userIconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.view).offset(44);
        make.height.equalTo(@90);
        make.width.equalTo(self.view).multipliedBy(0.75);
    }];
    [_userIconImageView updateConstraintsIfNeeded];
    [_listTableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userIconImageView.bottomMargin).offset(5);
        make.bottom.equalTo(self.view).offset(-10);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view).multipliedBy(0.70);
    }];
}

#pragma mark userAction

- (void)tapedUserInfoView
{    
    self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:self.personInfo];
    self.personInfo.navigationController.navigationBarHidden = YES;
}

- (void)tapReportView:(UIButton *)button
{
    dispatch_async_on_main_queue(^{
        
        DeBugLog(@"taped report %ld",button.tag);
        ReportVewContainerController *reportView = [[ReportVewContainerController alloc]init];
        switch (button.tag) {
            case 101:
            {
                reportView.reportType = ReportViewWeek;
                break;
            }
            case 102:{
                reportView.reportType = ReportViewMonth;
                break;
            }
            case 103:{
                reportView.reportType = ReportViewQuater;
                break;
            }
                
            default:
                break;
        }
        self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:reportView];
    });
}

- (void)didSeletedCellIndexPath:(NSIndexPath *)indexPath withData:(id)data
{
    NSString *className = [self.controllerClassArray objectOrNilAtIndex:indexPath.row];
    Class class = NSClassFromString(className);
    if (class) {
        UIViewController *controller = class.new;
        self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:controller];
    }
    if (indexPath.row == 4) {
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kBadgeKey];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self.listTableView reloadData];
    }
    
}

- (void)addControllerToCellArrayWithClassName:(NSString *)controllerName
{
    [self.controllerClassArray addObject:controllerName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showBadageValue:(NSString *)badageValue
{
    NSInteger appBadage =  (int)[[NSUserDefaults standardUserDefaults] integerForKey:kBadgeKey];
    appBadage +=1;
    [[NSUserDefaults standardUserDefaults] setInteger:appBadage forKey:kBadgeKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.listTableView reloadData];
}

@end
