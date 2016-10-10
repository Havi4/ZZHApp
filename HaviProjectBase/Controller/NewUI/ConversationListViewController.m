//
//  ConversationListViewController.m
//  HaviProjectBase
//
//  Created by Havi on 16/9/12.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "ConversationListViewController.h"
#import "ConversationListTableViewCell.h"
#import "XHDemoWeChatMessageTableViewController.h"
#import "ConsultVViewController.h"
#import "WTRequestCenter.h"
#import "EvaluationViewController.h"
#import "JAActionButton.h"

@interface ConversationListViewController ()<UITableViewDelegate,UITableViewDataSource,JASwipeCellDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *consultView;
@property (nonatomic, strong) SCBarButtonItem *leftBarItem;
@property (nonatomic, strong) SCBarButtonItem *rightBarItem;
@property (nonatomic, strong) UIView *noProblemBack;
@property (nonatomic, strong) NSArray *problemArr;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSIndexPath *deleteIndexPath;

@end

@implementation ConversationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backgroundImageView.image = [UIImage imageNamed:@""];
    // Do any additional setup after loading the view.
    [self initNavigationBar];
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self action:@selector(getProblemList) forControlEvents:UIControlEventValueChanged];
    [self.consultView addSubview:self.refreshControl];
    [self.view addSubview:self.consultView];
    [self getProblemList];
    [self configNoti];
}

- (void)configNoti
{
    [[NSNotificationCenter defaultCenter]addObserverForName:@"deletProblem" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self getProblemList];
    }];
    [[NSNotificationCenter defaultCenter]addObserverForName:@"docGiveMessage" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self getProblemList];
    }];
}

- (void)getProblemList
{
    NSString *url = @"http://testzzhapi.meddo99.com:8088/v1/cy/Problem/List/My";
    NSDictionary *dicPara = @{
                              @"UserId": thirdPartyLoginUserId,
                              @"pagenum":@"1",
                              @"count":@"100",
                              };
    [NSObject showHud];
    [WTRequestCenter postWithURL:url header:@{@"AccessToken":@"123456789",@"Content-Type":@"application/json"} parameters:dicPara finished:^(NSURLResponse *response, NSData *data) {
        [self.refreshControl endRefreshing];
        [NSObject hideHud];
        NSDictionary *obj = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *probleList = [obj objectForKey:@"Result"];
        if (probleList.count>0) {
            [self.noProblemBack removeFromSuperview];
            self.noProblemBack = nil;
            self.problemArr = probleList;
            [self.consultView reloadData];
            DeBugLog(@"咨询列表是%@",obj);
        }else{
            self.problemArr = nil;
            [self.consultView reloadData];
            [self.view addSubview:self.noProblemBack];
        }
    } failed:^(NSURLResponse *response, NSError *error) {
        [NSObject hideHud];
        [self.refreshControl endRefreshing];
        self.problemArr = nil;
        [self.consultView reloadData];
        [self.view addSubview:self.noProblemBack];
    }];
    
}

- (void)initNavigationBar
{
    self.navigationController.navigationBarHidden = YES;
    self.leftBarItem = [[SCBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_navi_back"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.sc_navigationItem.leftBarButtonItem = self.leftBarItem;
    
    self.rightBarItem = [[SCBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"jia"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        [self addNewProblem:nil];
    }];
    self.sc_navigationItem.rightBarButtonItem = self.rightBarItem;
    self.sc_navigationItem.title = @"我的提问";
    self.view.backgroundColor = [UIColor colorWithRed:0.957 green:0.961 blue:0.965 alpha:1.00];
}

- (UIView *)noProblemBack
{
    if (!_noProblemBack) {
        
        _noProblemBack = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 232, 232)];
        _noProblemBack.center = self.view.center;
        _noProblemBack.backgroundColor = [UIColor clearColor];
        UIImageView *doc = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"doc"]];
        doc.frame = (CGRect){(232-100)/2,0,100,125};
        UILabel *subLabel = [[UILabel alloc]init];
        subLabel.text = @"您还没有向医生咨询过问题";
        subLabel.frame = (CGRect){0,125,232,30};
        subLabel.textColor = [UIColor grayColor];
        subLabel.textAlignment = NSTextAlignmentCenter;
        subLabel.font = [UIFont systemFontOfSize:13];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = (CGRect){8,160,232-16,44};
        [button setBackgroundImage:[UIImage imageNamed:@"button_down_image"] forState:UIControlStateNormal];
        [button setTitle:@"免费问诊" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button addTarget:self action:@selector(addNewProblem:) forControlEvents:UIControlEventTouchUpInside];
        _noProblemBack.userInteractionEnabled = YES;
        [_noProblemBack addSubview:button];
        [_noProblemBack addSubview:subLabel];
        [_noProblemBack addSubview:doc];
    }
    return _noProblemBack;
}

- (UITableView *)consultView
{
    if (!_consultView) {
        _consultView = [[UITableView alloc]initWithFrame:(CGRect){0,64,self.view.frame.size.width,self.view.frame.size.height-64} style:UITableViewStylePlain];
        _consultView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _consultView.delegate = self;
        _consultView.dataSource = self;
        _consultView.backgroundColor = [UIColor colorWithRed:0.957 green:0.961 blue:0.965 alpha:1.00];
    }
    return _consultView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.problemArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConversationListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
    if (!cell) {
        cell = [[ConversationListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"];
    }
    cell.didSelectedAssessmentButton = ^(NSString *problemID){
        [self goAssementView:problemID];
    };
    cell.backgroundColor = [UIColor colorWithRed:0.996 green:1.000 blue:1.000 alpha:1.00];
    [cell configCellWithDic:[self.problemArr objectAtIndex:indexPath.section]];
    [cell addActionButtons:[self rightButtonsWithTable:tableView] withButtonWidth:kJAButtonWidth withButtonPosition:JAButtonLocationRight];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

- (NSArray *)rightButtonsWithTable:(UITableView *)table
{
    
    @weakify(self);
    JAActionButton *button1 = [JAActionButton actionButtonWithTitle:@"删除" color:[UIColor redColor] handler:^(UIButton *actionButton, JASwipeCell*cell) {
        @strongify(self);
        [cell resetContainerView];
        NSIndexPath *indexPath = [table indexPathForCell:cell];
        self.deleteIndexPath = indexPath;
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要删除本条信息?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
//        self.cellRightButtonTaped(DeleteCell,indexPath,[self itemAtIndexPath:indexPath],cell);
    }];
    
    return @[button1];
}

- (void)rightMostButtonSwipeCompleted:(JASwipeCell *)cell
{
    NSIndexPath *indexPath = [self.consultView indexPathForCell:cell];
    self.deleteIndexPath = indexPath;
    [cell resetContainerView];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要删除本条信息?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)leftMostButtonSwipeCompleted:(JASwipeCell *)cell
{
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSDictionary *para = [self.problemArr objectAtIndex:self.deleteIndexPath.section];
        NSString *problemID = [[para objectForKey:@"problem"]objectForKey:@"id"];
        [self deleteProblemWith:problemID];

    }
}

#pragma mark - JASwipeCellDelegate methods

- (void)swipingRightForCell:(JASwipeCell *)cell
{
    NSArray *indexPaths = [self.consultView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in indexPaths) {
        JASwipeCell *visibleCell = (JASwipeCell *)[self.consultView cellForRowAtIndexPath:indexPath];
        if (visibleCell != cell) {
            [visibleCell resetContainerView];
        }
    }
}

- (void)swipingLeftForCell:(JASwipeCell *)cell
{
    NSArray *indexPaths = [self.consultView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in indexPaths) {
        JASwipeCell *visibleCell = (JASwipeCell *)[self.consultView cellForRowAtIndexPath:indexPath];
        if (visibleCell != cell) {
            [visibleCell resetContainerView];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *isAnswer = [[[self.problemArr objectAtIndex:indexPath.section] objectForKey:@"problem"]objectForKey:@"status"];
    XHDemoWeChatMessageTableViewController *demoWeChatMessageTableViewController = [[XHDemoWeChatMessageTableViewController alloc] init];
    demoWeChatMessageTableViewController.allowsSendFace = NO;
    demoWeChatMessageTableViewController.allowsSendVoice = NO;
    demoWeChatMessageTableViewController.allowsSendMultiMedia = YES;
    NSString *problemId = [[[self.problemArr objectAtIndex:indexPath.section] objectForKey:@"problem"]objectForKey:@"id"];
    demoWeChatMessageTableViewController.problemID = problemId;
    if ([isAnswer isEqualToString:@"c"]) {
        demoWeChatMessageTableViewController.isShowInputView = NO;
    }else{
        demoWeChatMessageTableViewController.isShowInputView = YES;
    }

    [self.navigationController pushViewController:demoWeChatMessageTableViewController animated:YES];
}

- (void)goAssementView:(NSString *)problemID
{
    EvaluationViewController *evaluation = [[EvaluationViewController alloc]init];
    evaluation.problemID = problemID;
    [self.navigationController pushViewController:evaluation animated:YES];
}

- (void)addNewProblem:(UIButton *)button
{
    ConsultVViewController *consult = [[ConsultVViewController alloc]init];
    [self.navigationController pushViewController:consult animated:YES];

}

- (void)deleteProblemWith:(NSString *)problemID
{
    NSString *url = @"http://testzzhapi.meddo99.com:8088/v1/cy/Problem/Delete";
    NSDictionary *dicPara = @{
                              @"UserId": thirdPartyLoginUserId,
                              @"ProblemId": problemID,
                              };
    
    [NSObject showHud];
    [WTRequestCenter postWithURL:url header:@{@"AccessToken":@"123456789",@"Content-Type":@"application/json"} parameters:dicPara finished:^(NSURLResponse *response, NSData *data) {
        [NSObject hideHud];
        NSDictionary *obj = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([[[obj objectForKey:@"Result"] objectForKey:@"error"] intValue]==0) {
            [NSObject showHudTipStr:@"删除提问成功"];
            [self getProblemList];
        }else if ([[[obj objectForKey:@"Result"] objectForKey:@"error"] intValue]==1){
            [NSObject showHudTipStr:[[obj objectForKey:@"Result"] objectForKey:@"error_msg"]];
        }
    } failed:^(NSURLResponse *response, NSError *error) {
        [NSObject hideHud];
    }];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self refreshAction];
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
