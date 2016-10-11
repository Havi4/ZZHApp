//
//  FriendDeviceListViewController.m
//  SleepRecoding
//
//  Created by Havi on 15/11/11.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import "FriendDeviceListViewController.h"
#import "JASwipeCell.h"
#import "FriendDeviceDelegate.h"
#import "ReNameDeviceNameViewController.h"
#import "ReNameDoubleDeviceViewController.h"

@interface FriendDeviceListViewController ()

@property (nonatomic, strong) UITableView *friendDeviceListView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) FriendDeviceDelegate *friendDeviceDelegate;

@property (nonatomic, strong) NSArray *resultArr;
@property (nonatomic, strong) UIImageView *messageLabel;
@property (nonatomic, strong) DeviceList *selectDeviceUUID;
@property (nonatomic, strong) JASwipeCell *selectTableViewCell;

@end

@implementation FriendDeviceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.    //测试数据
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self addTableViewDataHandle];
    [self getFriendDeviceList];
}

- (void)addTableViewDataHandle
{
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self action:@selector(getFriendDeviceList) forControlEvents:UIControlEventValueChanged];
    [self.friendDeviceListView addSubview:self.refreshControl];
    [self.view addSubview:self.friendDeviceListView];
    TableViewCellConfigureBlock configureCellBlock = ^(NSIndexPath *indexPath, id item, UITableViewCell *cell){
        [cell configure:cell customObj:item indexPath:indexPath];
        
    };
    CellHeightBlock configureCellHeightBlock = ^ CGFloat (NSIndexPath *indexPath, id item){
        return 70;
    };
    @weakify(self);
    DidSelectCellBlock didSelectBlock = ^(NSIndexPath *indexPath, id item){
        @strongify(self);
        [self changeUUID:indexPath obj:item];
    };
    self.friendDeviceDelegate = [[FriendDeviceDelegate alloc]initWithItems:nil cellIdentifier:@"cell" configureCellBlock:configureCellBlock cellHeightBlock:configureCellHeightBlock didSelectBlock:didSelectBlock];
    [self.friendDeviceDelegate handleTableViewDataSourceAndDelegate:self.friendDeviceListView];
    [self.friendDeviceListView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
    }];
    self.friendDeviceDelegate.cellRightButtonTaped = ^(CellSelectType type, NSIndexPath *indexPath, id item, UITableViewCell *cell){
        @strongify(self);
        [self cellRightButtonSelectedType:type indexPath:indexPath obj:item cell:cell];
    };
    [[NSNotificationCenter defaultCenter]addObserverForName:kRefreshDeviceList object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self getFriendDeviceList];
    }];
}

#pragma mark setter meathod

- (UIImageView *)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = [[UIImageView alloc]init];
        _messageLabel.frame = CGRectMake((self.view.frame.size.width -112)/2, (self.view.frame.size.height -126-64)/2,112 , 126);
        _messageLabel.image = [UIImage imageNamed:@"feiji"];
        UILabel *label = [[UILabel alloc]init];
        label.text = @"空空如也,没有收到消息";
        label.frame = (CGRect){-44,126-20,200,30};
        label.font = [UIFont systemFontOfSize:16];
        [_messageLabel addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor lightGrayColor];
//        _messageLabel.font = [UIFont systemFontOfSize:17];
        
    }
    return _messageLabel;
}


- (UITableView *)friendDeviceListView
{
    if (!_friendDeviceListView) {
        _friendDeviceListView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStyleGrouped];
        _friendDeviceListView.backgroundColor = [UIColor whiteColor];
        _friendDeviceListView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return _friendDeviceListView;
}

- (void)getFriendDeviceList
{
    ZZHAPIManager *apiManager = [ZZHAPIManager sharedAPIManager];
    NSDictionary *dic12 = @{
                            @"UserID":thirdPartyLoginUserId,
                            };
    [apiManager requestCheckFriendDeviceListParams:dic12 andBlock:^(MyDeviceListModel *friendDevice, NSError *error) {
        [self.refreshControl endRefreshing];
        if (friendDevice.deviceList.count==0) {
            [self.friendDeviceListView addSubview:self.messageLabel];
        }else{
            [self.messageLabel removeFromSuperview];
        }
        self.friendDeviceDelegate.items = friendDevice.deviceList;
        [self.friendDeviceListView reloadData];
    }];
    
}

#pragma mark cell处理

- (void)cellRightButtonSelectedType:(CellSelectType)type indexPath:(NSIndexPath *)indexPath obj:(id)obj cell:(UITableViewCell *)tableCell
{
    DeviceList *deviceModel = obj;
    if (type == DeleteCell) {
        self.selectTableViewCell = (JASwipeCell *)tableCell;
        [self deleteMyDevice:deviceModel];
        
    }else if (type == RenameCell){
        [self renameMyDevice:deviceModel];
    }
}

- (void)changeUUID:(NSIndexPath *)indexPath obj:(id)obj
{
    DeviceList *model = obj;
    if (model) {
        
        NSDictionary *dic14 = @{
                                @"UserID": thirdPartyLoginUserId,
                                @"UUID": model.deviceUUID,
                                @"FriendUserID":model.friendUserID,
                                };
        ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
        [client requestActiveFriendDeviceParams:dic14 andBlock:^(BaseModel *resultModel, NSError *error) {
            if ([resultModel.returnCode intValue]==200) {
                [[NSNotificationCenter defaultCenter]postNotificationName:kRefreshDeviceList object:nil];
                gloableActiveDevice = model;
                [[NSNotificationCenter defaultCenter]postNotificationName:kUserChangeUUIDInCenterView object:nil];
            }
        }];
    }
}

- (void)deleteMyDevice:(DeviceList *)deviceUUID
{
    self.selectDeviceUUID = deviceUUID;
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"您确认删除该设备？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alertView.tag = 1001;
    [alertView show];
}

- (void)renameMyDevice:(DeviceList *)deviceInfo

{
    if (deviceInfo.detailDeviceList.count > 0) {
        ReNameDoubleDeviceViewController *name = [[ReNameDoubleDeviceViewController alloc]init];
        name.deviceInfo = deviceInfo;
        [self.navigationController pushViewController:name animated:YES];
    }else{
        ReNameDeviceNameViewController *name = [[ReNameDeviceNameViewController alloc]init];
        name.deviceInfo = deviceInfo;
        [self.navigationController pushViewController:name animated:YES];
    }
}

#pragma mark alertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1001) {
        switch (buttonIndex) {
            case 0:{
                [self.selectTableViewCell resetContainerView];
                break;
            }
            case 1:{
                [self deleteMySureUUID:self.selectDeviceUUID];
                [[NSNotificationCenter defaultCenter]postNotificationName:kUserChangeUUIDInCenterView object:nil];
                break;
            }
                
            default:
                break;
        }
        
    }else if (alertView.tag == 1002){
    }
}

- (void)deleteMySureUUID:(DeviceList *)friendInfo
{
    ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
    NSDictionary *dic8 = @{
                           @"RequestUserId": thirdPartyLoginUserId, //申请加好友的人
                           @"ResponseUserId": friendInfo.friendUserID, //被请求的用户
                           };
    [client requestRemoveFriendParam:dic8 andBlock:^(BaseModel *resultModel, NSError *error) {
        if ([resultModel.returnCode intValue]==200) {
            [[NSNotificationCenter defaultCenter]postNotificationName:kRefreshDeviceList object:nil];

        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self getFriendDeviceList];
}


@end
