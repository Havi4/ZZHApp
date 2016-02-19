//
//  MyDeviceListViewController.m
//  SleepRecoding
//
//  Created by Havi on 15/12/2.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import "MyDeviceListViewController.h"
#import "ODRefreshControl.h"
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
@property (nonatomic, strong) ODRefreshControl *refreshControl;

@property (nonatomic, strong) JASwipeCell *selectTableViewCell;
@property (nonatomic, strong) NSString *selectDeviceUUID;
@property (nonatomic, strong) UILabel *messageLabel;

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
    self.refreshControl = [[ODRefreshControl alloc] initInScrollView:self.myDeviceListView];;
    [self.refreshControl addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
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

- (void)refreshAction{
    
    [self getUserDeviceList];
    
}

#pragma mark 请求数据
- (void)getUserDeviceList
{
    ZZHAPIManager *apiManager = [ZZHAPIManager sharedAPIManager];
    NSDictionary *dic12 = @{
                            @"UserID":kUserID,
                            };
    [apiManager requestCheckMyDeviceListParams:dic12 andBlock:^(MyDeviceListModel *myDeviceList, NSError *error) {
        [self.refreshControl endRefreshing];
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
        [self deleteMyDevice:deviceModel.deviceUUID];
        
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
                                @"UserID": kUserID,
                                @"UUID": model.deviceUUID,
                                };
        ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
        [client requestActiveMyDeviceParams:dic14 andBlock:^(BaseModel *resultModel, NSError *error) {
            if ([resultModel.returnCode intValue]==200) {
                [self getUserDeviceList];
            }
        }];
    }
}

- (void)deleteMyDevice:(NSString *)deviceUUID
{
    self.selectDeviceUUID = deviceUUID;
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"您确认删除该设备？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alertView.tag = 1001;
    [alertView show];
}

- (void)reActiveMyDevice:(DeviceList *)deviceInfo
{
    if (deviceInfo.detailDeviceList.count > 0) {
        ReactiveDoubleViewController *doubleUDP = [[ReactiveDoubleViewController alloc]init];
//        doubleUDP.deviceName = deviceInfo.description;
//        doubleUDP.deviceUUID = deviceInfo.deviceUUID;
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

/*
#pragma mark 操作设备
- (void)deleteFriendSureUUID:(NSString *)deviceUUID
{
    NSArray *images = @[[UIImage imageNamed:@"havi1_0"],
                        [UIImage imageNamed:@"havi1_1"],
                        [UIImage imageNamed:@"havi1_2"],
                        [UIImage imageNamed:@"havi1_3"],
                        [UIImage imageNamed:@"havi1_4"],
                        [UIImage imageNamed:@"havi1_5"]];
    [[MMProgressHUD sharedHUD] setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithTitle:nil status:nil images:images];
    NSString *urlString = [NSString stringWithFormat:@"%@v1/user/DeleteUserDevice",BaseUrl];
    NSDictionary *header = @{
                             @"AccessToken":@"123456789"
                             };
    NSDictionary *para = @{
                           @"UserID":thirdPartyLoginUserId,
                           @"UUID": deviceUUID,
                           };
    [WTRequestCenter putWithURL:urlString header:header parameters:para finished:^(NSURLResponse *response, NSData *data) {
        NSDictionary *obj = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        HaviLog(@"数据是%@",obj);
        if ([[obj objectForKey:@"ReturnCode"]intValue]==200) {
            [MMProgressHUD dismiss];
            [self getUserDeviceList];
        }else{
            [MMProgressHUD dismissWithError:[obj objectForKey:@"ErrorMessage"] afterDelay:2];
            [self.selectTableViewCell resetContainerView];
        }
    } failed:^(NSURLResponse *response, NSError *error) {
        [MMProgressHUD dismiss];
        [self.view makeToast:@"网络出错啦,请检查您的网络" duration:2 position:@"center"];
    }];
}

#pragma mark rename device

- (void)renameFriendDevice:(NSIndexPath *)indexPath
{
    [self.selectTableViewCell resetContainerView];
    if ([[[self.deviceArr objectAtIndex:indexPath.row] objectForKey:@"DetailDevice"] count]>0) {
        ReNameDoubleDeviceViewController *name = [[ReNameDoubleDeviceViewController alloc]init];
        name.deviceInfo = [self.deviceArr objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:name animated:YES];
    }else{
        ReNameDeviceNameViewController *name = [[ReNameDeviceNameViewController alloc]init];
        name.deviceInfo = [self.deviceArr objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:name animated:YES];
    }
}

- (void)reActiveFriendDevice:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.deviceArr objectAtIndex:indexPath.row];
    if ([[[self.deviceArr objectAtIndex:indexPath.row] objectForKey:@"DetailDevice"] count]>0) {
        DoubleDUPViewController *udp = [[DoubleDUPViewController alloc]init];
        udp.productName = [dic objectForKey:@"Description"];//测试
        thirdHardDeviceUUID = [dic objectForKey:@"UUID"];
        udp.productUUID = [dic objectForKey:@"UUID"];
        [self.navigationController pushViewController:udp animated:YES];
    }else{
        UDPAddProductViewController *udp = [[UDPAddProductViewController alloc]init];
        udp.productName = [dic objectForKey:@"Description"];;
        thirdHardDeviceUUID = [dic objectForKey:@"UUID"];
        udp.productUUID = [dic objectForKey:@"UUID"];
        [self.navigationController pushViewController:udp animated:YES];
    }
}

- (UILabel *)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc]init];
        _messageLabel.frame = CGRectMake(0, self.sideTableView.frame.size.height/2-100,self.sideTableView.frame.size.width , 40);
        _messageLabel.text = @"您还没有绑定设备！";
        _messageLabel.font = [UIFont systemFontOfSize:17];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.textColor = [UIColor grayColor];
        
    }
    return _messageLabel;
}

//在界面出现的时候进行刷新数据
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //获取数据
    [self getUserDeviceList];
}
- (void)refreshBegining
{
    [self refresh];
    
}
*/

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

#pragma mark 操作设备
- (void)deleteMySureUUID:(NSString *)deviceUUID
{
    NSDictionary *dic = @{
                            @"UserID": kUserID,
                            @"UUID": deviceUUID,
                            };
    ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
    [client requestRemoveDeviceParams:dic andBlock:^(BaseModel *resultModel, NSError *error) {
        if ([resultModel.returnCode intValue]==200) {
            [self getUserDeviceList];
        }
    }];
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
