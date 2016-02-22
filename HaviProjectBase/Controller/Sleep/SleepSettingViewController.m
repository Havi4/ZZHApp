//
//  SleepSettingViewController.m
//  SleepRecoding
//
//  Created by Havi_li on 15/3/10.
//  Copyright (c) 2015年 Havi. All rights reserved.
//

#import "SleepSettingViewController.h"
#import "SettingDataDelegate.h"

@interface SleepSettingViewController ()

@property (nonatomic, strong) UITableView *sleepSettingView;
@property (nonatomic, strong) SettingDataDelegate *settingDelegate;
@property (nonatomic, strong) UserInfoDetailModel *userInfoModel;

@end

@implementation SleepSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [self initNavigationBar];
    [self addTableViewDataHandle];
    [self getUserDetailInfo];
        // Do any additional setup after loading the view.
}

- (void)initNavigationBar
{
    self.navigationController.navigationBarHidden = YES;
    [self createNavWithTitle:@"睡眠设置" createMenuItem:^UIView *(int nIndex)
     {
         if (nIndex == 1)
         {
             return self.menuButton;
         }
         return nil;
     }];
}

- (void)addTableViewDataHandle
{
    [self.view addSubview:self.sleepSettingView];
    TableViewCellConfigureBlock configureCellBlock = ^(NSIndexPath *indexPath, id item, UITableViewCell *cell){
        [cell configure:cell customObj:item indexPath:indexPath withOtherInfo:self.userInfoModel];
        
    };
    CellHeightBlock configureCellHeightBlock = ^ CGFloat (NSIndexPath *indexPath, id item){
        return 49;
    };
    @weakify(self);
    DidSelectCellBlock didSelectBlock = ^(NSIndexPath *indexPath, id item){
        @strongify(self);
        [self getUserDetailInfo];
    };
    NSString *dataPath = [[NSBundle mainBundle]pathForResource:@"SleepSetting" ofType:@"plist"];
    NSArray *dataArr = [NSArray arrayWithContentsOfFile:dataPath];

    self.settingDelegate = [[SettingDataDelegate alloc]initWithItems:dataArr cellIdentifier:@"cell" configureCellBlock:configureCellBlock cellHeightBlock:configureCellHeightBlock didSelectBlock:didSelectBlock];
    
    [self.settingDelegate handleTableViewDataSourceAndDelegate:self.sleepSettingView];
    [self.sleepSettingView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.view.mas_top).offset(64);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
    }];
}

- (UITableView *)sleepSettingView
{
    if (!_sleepSettingView) {
        _sleepSettingView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _sleepSettingView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _sleepSettingView.backgroundColor = KTableViewBackGroundColor;
    }
    return _sleepSettingView;
}

- (void)getUserDetailInfo
{
    NSDictionary *userIdDic = @{
                                @"UserID":kUserID,
                                };
    ZZHAPIManager *apiManager = [ZZHAPIManager sharedAPIManager];
    [apiManager requestUserInfoWithParam:userIdDic andBlock:^(UserInfoDetailModel *userInfo, NSError *error) {
        self.userInfoModel = userInfo;
        [self.sleepSettingView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
