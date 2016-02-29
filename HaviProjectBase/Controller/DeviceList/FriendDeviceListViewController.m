//
//  FriendDeviceListViewController.m
//  SleepRecoding
//
//  Created by Havi on 15/11/11.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import "FriendDeviceListViewController.h"
#import "JASwipeCell.h"
#import "ODRefreshControl.h"
#import "FriendDeviceDelegate.h"
#import "ReNameDeviceNameViewController.h"
#import "ReNameDoubleDeviceViewController.h"

@interface FriendDeviceListViewController ()

@property (nonatomic, strong) UITableView *friendDeviceListView;
@property (nonatomic, strong) ODRefreshControl *refreshControl;
@property (nonatomic, strong) FriendDeviceDelegate *friendDeviceDelegate;

@property (nonatomic, strong) NSArray *resultArr;
@property (nonatomic, strong) UILabel *messageLabel;
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
    self.refreshControl = [[ODRefreshControl alloc] initInScrollView:self.friendDeviceListView];;
    [self.refreshControl addTarget:self action:@selector(getFriendDeviceList) forControlEvents:UIControlEventValueChanged];
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
}

#pragma mark setter meathod

- (UILabel *)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc]init];
        _messageLabel.frame = CGRectMake(0, self.friendDeviceListView.frame.size.height/2-100,self.friendDeviceListView.frame.size.width , 40);
        _messageLabel.text = @"没有他人设备！";
        _messageLabel.font = [UIFont systemFontOfSize:17];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.textColor = [UIColor grayColor];
        
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
                                };
        ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
        [client requestActiveFriendDeviceParams:dic14 andBlock:^(BaseModel *resultModel, NSError *error) {
            if ([resultModel.returnCode intValue]==200) {
                [self getFriendDeviceList];
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
            [self getFriendDeviceList];
        }
    }];
}

@end
