//
//  MyDeviceListViewController.m
//  SleepRecoding
//
//  Created by Havi on 15/12/2.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import "MyDeviceListViewController.h"
#import "MyDeviceDelegate.h"
#import "JAActionButton.h"
#import "JASwipeCell.h"
#import "ReactiveDoubleViewController.h"
#import "ReactiveSingleViewController.h"
#import "ReNameDeviceNameViewController.h"
#import "ReNameDoubleDeviceViewController.h"

@interface MyDeviceListViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *myDeviceListView;
@property (nonatomic, strong) MyDeviceDelegate *myDeviceDelegate;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, strong) JASwipeCell *selectTableViewCell;
@property (nonatomic, strong) DeviceList *selectDevice;
@property (nonatomic, strong) UIImageView *messageLabel;

@end

@implementation MyDeviceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    [self addTableViewDataHandle];
    [self getUserDeviceList];
}

- (void)addTableViewDataHandle
{
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
    [self.myDeviceListView addSubview:self.refreshControl];
    [self.view addSubview:self.myDeviceListView];
    
    
    TableViewCellConfigureBlock configureCellBlock = ^(NSIndexPath *indexPath, id item, UITableViewCell *cell){
        [cell configure:cell customObj:item indexPath:indexPath];
        
    };
    CellHeightBlock configureCellHeightBlock = ^ CGFloat (NSIndexPath *indexPath, id item){
        return 60;
    };
    @weakify(self);
    DidSelectCellBlock didSelectBlock = ^(NSIndexPath *indexPath, id item){
        DeBugLog(@"select cell %ld",(long)indexPath.row);
        @strongify(self);
        [self changeUUID:indexPath obj:item];
    };
    self.myDeviceDelegate = [[MyDeviceDelegate alloc]initWithItems:nil cellIdentifier:@"cell" configureCellBlock:configureCellBlock cellHeightBlock:configureCellHeightBlock didSelectBlock:didSelectBlock];
    [self.myDeviceDelegate handleTableViewDataSourceAndDelegate:self.myDeviceListView];
    [self.myDeviceListView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
    }];
    self.myDeviceDelegate.cellRightButtonTaped = ^(CellSelectType type, NSIndexPath *indexPath, id item, UITableViewCell *cell){
        @strongify(self);
        [self cellRightButtonSelectedType:type indexPath:indexPath obj:item cell:cell];
    };
    
    [[NSNotificationCenter defaultCenter]addObserverForName:kRefreshDeviceList object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self getUserDeviceList];
    }];
}

#pragma mark setter

- (UITableView *)myDeviceListView
{
    if (_myDeviceListView == nil) {
        _myDeviceListView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _myDeviceListView.backgroundColor = [UIColor whiteColor];
    }
    return _myDeviceListView;
}

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


- (void)refreshAction{
    
    [self getUserDeviceList];
    
}

#pragma mark 请求数据
- (void)getUserDeviceList
{
    ZZHAPIManager *apiManager = [ZZHAPIManager sharedAPIManager];
    NSDictionary *dic12 = @{
                            @"UserID":thirdPartyLoginUserId,
                            };
    [apiManager requestCheckMyDeviceListParams:dic12 andBlock:^(MyDeviceListModel *myDeviceList, NSError *error) {
        [self.refreshControl endRefreshing];
        if (myDeviceList.deviceList.count==0) {
            [self.myDeviceListView addSubview:self.messageLabel];
        }else{
            [self.messageLabel removeFromSuperview];
        }
        self.myDeviceDelegate.items = myDeviceList.deviceList;
        [self.myDeviceListView reloadData];
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
    }else if (type == ReactiveCell){
        [self reActiveMyDevice:deviceModel];
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
        [client requestActiveMyDeviceParams:dic14 andBlock:^(BaseModel *resultModel, NSError *error) {
            if ([resultModel.returnCode intValue]==200) {
                gloableActiveDevice = model;
                [[NSNotificationCenter defaultCenter]postNotificationName:kRefreshDeviceList object:nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:kUserChangeUUIDInCenterView object:nil];
            }
        }];
    }
}

- (void)deleteMyDevice:(DeviceList *)deviceUUID
{
    self.selectDevice = deviceUUID;
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"您确认删除该设备？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alertView.tag = 1001;
    [alertView show];
}

- (void)reActiveMyDevice:(DeviceList *)deviceInfo
{
    if (deviceInfo.detailDeviceList.count > 0) {
        ReactiveDoubleViewController *doubleUDP = [[ReactiveDoubleViewController alloc]init];
        [self.navigationController pushViewController:doubleUDP animated:YES];
    }else{
        ReactiveSingleViewController *sigleUDP = [[ReactiveSingleViewController alloc]init];
        sigleUDP.deviceName = deviceInfo.description;
        sigleUDP.deviceUUID = deviceInfo.deviceUUID;
        [self.navigationController pushViewController:sigleUDP animated:YES];
    }
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
                [self deleteMySureUUID:self.selectDevice.deviceUUID];
                if ([self.selectDevice.isActivated isEqualToString:@"True"]) {
                    gloableActiveDevice = nil;

                    [[NSNotificationCenter defaultCenter]postNotificationName:kUserChangeUUIDInCenterView object:nil];
                }
                break;
            }
                
            default:
                break;
        }
        
    }else if (alertView.tag == 1002){
    }
}

#pragma mark 操作设备
- (void)deleteMySureUUID:(NSString *)deviceUUID
{
    NSDictionary *dic = @{
                            @"UserID": thirdPartyLoginUserId,
                            @"UUID": deviceUUID,
                            };
    ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
    [client requestRemoveDeviceParams:dic andBlock:^(BaseModel *resultModel, NSError *error) {
        if ([resultModel.returnCode intValue]==200) {
            [[NSNotificationCenter defaultCenter]postNotificationName:kRefreshDeviceList object:nil];

        }
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self getUserDeviceList];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
