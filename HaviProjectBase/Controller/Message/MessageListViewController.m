//
//  MyDeviceListViewController.m
//  SleepRecoding
//
//  Created by Havi on 15/11/11.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import "MessageListViewController.h"
#import "MessageShowTableViewCell.h"
#import "AddProductNameViewController.h"
#import "MessageDataDelegate.h"

@interface MessageListViewController ()<UIActionSheetDelegate>

@property (nonatomic, strong) UITableView *messageShowListView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) MessageDataDelegate *messageDelegate;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) SCBarButtonItem *leftBarItem;

@end

@implementation MessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavigationBar];
    [self addTableViewDataHandle];
    [self getMessageList];
}

- (void)initNavigationBar
{
    self.navigationController.navigationBarHidden = YES;
    self.leftBarItem = [[SCBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gn"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowMenuNotification object:nil];
    }];
    self.sc_navigationItem.title = @"我的消息";
    self.sc_navigationItem.leftBarButtonItem = self.leftBarItem;
}

- (void)addTableViewDataHandle
{
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self action:@selector(getMessageList) forControlEvents:UIControlEventValueChanged];
    [self.messageShowListView addSubview:self.refreshControl];

    [self.view addSubview:self.messageShowListView];
    
    
    TableViewCellConfigureBlock configureCellBlock = ^(NSIndexPath *indexPath, id item, UITableViewCell *cell){
        [cell configure:cell customObj:item indexPath:indexPath];
        
    };
    CellHeightBlock configureCellHeightBlock = ^ CGFloat (NSIndexPath *indexPath, id item){
        return 64;
    };
    self.messageDelegate = [[MessageDataDelegate alloc]initWithItems:nil cellIdentifier:@"cell" configureCellBlock:configureCellBlock cellHeightBlock:configureCellHeightBlock didSelectBlock:nil];
    @weakify(self);
    self.messageDelegate.cellReplayButtonTaped = ^(MessageType type, NSIndexPath *indexPath, id item, UITableViewCell *cell){
        @strongify(self);
        [self sendMessageReplay:type obj:item];
    };
    [self.messageDelegate handleTableViewDataSourceAndDelegate:self.messageShowListView];
    [self.messageShowListView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.view.mas_top).offset(64);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
    }];
}

- (void)getMessageList
{
    NSDictionary *dic5 = @{
                           @"UserId":thirdPartyLoginUserId,
                           };
    ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
    [client requestBeingRequestFriendParam:dic5 andBlock:^(BeingRequestModel *beingModel, NSError *error) {
        [self.refreshControl endRefreshing];
        NSArray *_resultArr = beingModel.beingRequestUserList;
        NSArray *sortedArray = [_resultArr sortedArrayUsingComparator:^NSComparisonResult(RequestUserInfo *p1, RequestUserInfo *p2){
            return [p2.requestDate compare:p1.requestDate];
            
        }];
        if (sortedArray.count ==0) {
            [self.messageShowListView addSubview:self.messageLabel];
        }else{
            [self.messageLabel removeFromSuperview];
        }
        self.messageDelegate.items = sortedArray;
        [self.messageShowListView reloadData];
    }];
}

//刷新
- (void)refresh{
    
    [self getMessageList];
    
}

#pragma setter meathod

- (UILabel *)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc]init];
        _messageLabel.frame = CGRectMake(0, self.view.frame.size.height/2-100,self.view.frame.size.width , 40);
        _messageLabel.text = @"没有申请消息！";
        _messageLabel.font = [UIFont systemFontOfSize:17];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.textColor = [UIColor lightGrayColor];
        
    }
    return _messageLabel;
}


- (UITableView *)messageShowListView
{
    if (!_messageShowListView) {
        _messageShowListView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _messageShowListView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _messageShowListView.backgroundColor = KTableViewBackGroundColor;
    }
    return _messageShowListView;
}

- (void)sendMessageReplay:(MessageType)type obj:(id)obj
{
    switch (type) {
        case MessageAccept:
        {
            [self acceptMessage:obj];
            break;
        }
        case MessageRefuse:{
            [self refuseMessage:obj];
            break;
        }
            
        default:
            break;
    }
}

- (void)acceptMessage:(id)userInfo
{
    RequestUserInfo *info = userInfo;
    NSDictionary *para = @{
                           @"RequestUserId":info.userID,
                           @"ResponseUserId":thirdPartyLoginUserId,
                           @"StatusCode" : @"1",
                           };
    ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
    [client requestChangeFriendRequestStatus:para andBlock:^(BaseModel *resultModel, NSError *error) {
        if (resultModel) {
            [self getMessageList];
            [NSObject showHudTipStr:@"您已同意该用户的申请"];
        }
    }];
}

- (void)refuseMessage:(id)userInfo
{
    RequestUserInfo *info = userInfo;
    NSDictionary *para = @{
                           @"RequestUserId":info.userID,
                           @"ResponseUserId":thirdPartyLoginUserId,
                           @"StatusCode" : @"-1",
                           };
    ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
    [client requestChangeFriendRequestStatus:para andBlock:^(BaseModel *resultModel, NSError *error) {
        if (resultModel) {
            [self getMessageList];
            [NSObject showHudTipStr:@"您已拒绝该用户的申请"];
        }
    }];
}


/*
#pragma tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _resultArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"cellIndentifier";
    MessageShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell = [[MessageShowTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    NSString *userName = [[_resultArr objectAtIndex:indexPath.row]objectForKey:@"UserName"];
    NSString *url = [NSString stringWithFormat:@"%@/v1/file/DownloadFile/%@",BaseUrl,[[_resultArr objectAtIndex:indexPath.row]objectForKey:@"UserID"]];
    cell.cellUserIcon = url;
    if (userName.length==0) {
        cell.cellUserName = @"匿名用户";
    }else{
        cell.cellUserName = [[_resultArr objectAtIndex:indexPath.row]objectForKey:@"UserName"];
    }
    cell.delegate = self;
    if ([[[_resultArr objectAtIndex:indexPath.row]objectForKey:@"StatusCode"] intValue]==1) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellRequreTime = [[[_resultArr objectAtIndex:indexPath.row]objectForKey:@"RequestDate"]substringToIndex:16];
        cell.cellUserPhone = [[_resultArr objectAtIndex:indexPath.row]objectForKey:@"CellPhone"];
        cell.messageShowString = [[_resultArr objectAtIndex:indexPath.row]objectForKey:@"Comment"];
        cell.backgroundColor = [UIColor colorWithRed:0.859f green:0.867f blue:0.878f alpha:1.00f];
        cell.messageAccepteButton.userInteractionEnabled = NO;
        [cell.messageAccepteButton setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
        cell.messageRefuseButton.userInteractionEnabled = NO;
        [cell.messageRefuseButton setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
        cell.statusImageView.image = [UIImage imageNamed:@"accept"];
        cell.cellDataColor = [UIColor grayColor];
        
    }else if ([[[_resultArr objectAtIndex:indexPath.row]objectForKey:@"StatusCode"] intValue]==-1){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellRequreTime = [[[_resultArr objectAtIndex:indexPath.row]objectForKey:@"RequestDate"]substringToIndex:16];
        cell.cellUserPhone = [[_resultArr objectAtIndex:indexPath.row]objectForKey:@"CellPhone"];
        cell.messageShowString = [[_resultArr objectAtIndex:indexPath.row]objectForKey:@"Comment"];
        cell.backgroundColor = [UIColor colorWithRed:0.859f green:0.867f blue:0.878f alpha:1.00f];
        cell.messageAccepteButton.userInteractionEnabled = NO;
        [cell.messageAccepteButton setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
        cell.messageRefuseButton.userInteractionEnabled = NO;
        [cell.messageRefuseButton setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
        cell.statusImageView.image = [UIImage imageNamed:@"refuse"];
        cell.cellDataColor = [UIColor grayColor];
    }else if([[[_resultArr objectAtIndex:indexPath.row]objectForKey:@"StatusCode"] intValue]==0){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellRequreTime = [[[_resultArr objectAtIndex:indexPath.row]objectForKey:@"RequestDate"]substringToIndex:16];
        cell.cellUserPhone = [[_resultArr objectAtIndex:indexPath.row]objectForKey:@"CellPhone"];
        cell.messageShowString = [[_resultArr objectAtIndex:indexPath.row]objectForKey:@"Comment"];
        cell.backgroundColor = [UIColor colorWithRed:0.859f green:0.867f blue:0.878f alpha:1.00f];
        cell.statusImageView.image = [UIImage imageNamed:@""];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

#pragma mark custom cell action
- (void)customMessageAcceptCell:(MessageShowTableViewCell *)cell didTapButton:(UIButton *)button
{
    NSIndexPath *indexPath = [self.myDeviceListView indexPathForCell:cell];
    NSDictionary *userDic = [_resultArr objectAtIndex:indexPath.row];
    NSString *responseID = [userDic objectForKey:@"UserID"];
    [self acceptMessage:responseID];
}


- (void)customMessageRefuseCell:(MessageShowTableViewCell *)cell didTapButton:(UIButton *)button
{
    NSIndexPath *indexPath = [self.myDeviceListView indexPathForCell:cell];
    HaviLog(@"点击了%ld",(long)indexPath.row);
    NSDictionary *userDic = [_resultArr objectAtIndex:indexPath.row];
    NSString *responseID = [userDic objectForKey:@"UserID"];
    [self refuseMessage:responseID];
}




#pragma mark userAction
 */


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
