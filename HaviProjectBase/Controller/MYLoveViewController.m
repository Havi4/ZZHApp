//
//  MYLoveViewController.m
//  HaviProjectBase
//
//  Created by HaviLee on 2016/10/31.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "MYLoveViewController.h"
#import "MyLoveTableViewCell.h"
#import "JAActionButton.h"
#import "RefreshHeader.h"
#import "MJChiBaoZiFooter2.h"
#import "WTRequestCenter.h"
#import "ArticleViewController.h"

@interface MYLoveViewController ()<UITableViewDelegate,UITableViewDataSource,JASwipeCellDelegate>

@property (nonatomic, strong) SCBarButtonItem *leftBarItem;
@property (nonatomic, strong) UITableView *loveTableView;
@property (nonatomic, assign) int pageNum;
@property (nonatomic, strong) NSMutableArray *articleArr;
@property (nonatomic, strong) UIImageView *messageLabel;

@end

@implementation MYLoveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavigationBar];
    self.pageNum = 1;
    self.articleArr = @[].mutableCopy;
    [self.view addSubview:self.loveTableView];
    
    self.loveTableView.mj_header = [RefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 马上进入刷新状态
    [self.loveTableView.mj_header beginRefreshing];
    self.loveTableView.mj_footer = [MJChiBaoZiFooter2 footerWithRefreshingTarget:self refreshingAction:@selector(loadLastData)];
    self.loveTableView.mj_footer.automaticallyChangeAlpha = YES;
}


- (UITableView *)loveTableView
{
    if (!_loveTableView) {
        _loveTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
        _loveTableView.delegate = self;
        _loveTableView.dataSource = self;
        _loveTableView.showsVerticalScrollIndicator = YES;
        _loveTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _loveTableView;
}

- (UIImageView *)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = [[UIImageView alloc]init];
        _messageLabel.frame = CGRectMake((self.view.frame.size.width -112)/2, (self.view.frame.size.height -126-64-64)/2,112 , 126);
        _messageLabel.image = [UIImage imageNamed:@"feiji"];
        UILabel *label = [[UILabel alloc]init];
        label.text = @"空空如也,没有收藏文章";
        label.frame = (CGRect){-44,126-20,200,30};
        label.font = kDefaultWordFont;
        [_messageLabel addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor lightGrayColor];
        //        _messageLabel.font = [UIFont systemFontOfSize:17];
        
    }
    return _messageLabel;
}


- (void)initNavigationBar
{
    self.navigationController.navigationBarHidden = YES;
    self.leftBarItem = [[SCBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gn"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowMenuNotification object:nil];
    }];
    self.sc_navigationItem.leftBarButtonItem = self.leftBarItem;
    
    self.sc_navigationItem.title = @"我的收藏";
}

#pragma mark delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.articleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyLoveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"loveCell"];
    if (!cell) {
        cell = [[MyLoveTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"loveCell"];
    }
    [cell cellConfigWithItem:[self.articleArr objectAtIndex:indexPath.row] andIndex:indexPath];
    [cell addActionButtons:[self rightButtonsWithTable:tableView] withButtonWidth:kJAButtonWidth withButtonPosition:JAButtonLocationRight];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *indexPaths = [self.loveTableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in indexPaths) {
        JASwipeCell *visibleCell = (JASwipeCell *)[self.loveTableView cellForRowAtIndexPath:indexPath];
        [visibleCell resetContainerView];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ArticleViewController *article = [[ArticleViewController alloc]init];
    article.articleTitle = [[self.articleArr objectAtIndex:indexPath.row] objectForKey:@"Title"];
    article.articleURL = [[self.articleArr objectAtIndex:indexPath.row] objectForKey:@"Url"];
    article.isShowCollectionButton = NO;
    [self.navigationController pushViewController:article animated:YES];

}

- (NSArray *)rightButtonsWithTable:(UITableView *)table
{
    
    @weakify(self);
    JAActionButton *button1 = [JAActionButton actionButtonWithTitle:@"删除" color:[UIColor redColor] handler:^(UIButton *actionButton, JASwipeCell*cell) {
        @strongify(self);
        [cell resetContainerView];
        NSIndexPath *indexPath = [table indexPathForCell:cell];
        NSString *aID =[[self.articleArr objectAtIndex:indexPath.row] objectForKey:@"ArticleId"];
        NSString *url = [NSString stringWithFormat:@"%@v1/news/DeleteCollection", kAppBaseURL];
        
        NSDictionary *dicPara = @{
                                  @"UserId": thirdPartyLoginUserId,
                                  @"ArticleId": aID,
                                  };
        
        [WTRequestCenter postWithURL:url header:@{@"AccessToken":accessTocken,@"Content-Type":@"application/json"} parameters:dicPara finished:^(NSURLResponse *response, NSData *data) {
            NSDictionary *obj = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if ([[obj objectForKey:@"ReturnCode"] intValue]==200) {
                [self.loveTableView.mj_header beginRefreshing];
            }else {
                [NSObject showHudTipStr:[[obj objectForKey:@"Result"] objectForKey:@"error_msg"]];
            }
        } failed:^(NSURLResponse *response, NSError *error) {
        }];
    }];
    
    return @[button1];
}
#pragma mark - JASwipeCellDelegate methods

- (void)swipingRightForCell:(JASwipeCell *)cell
{
    NSArray *indexPaths = [self.loveTableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in indexPaths) {
        JASwipeCell *visibleCell = (JASwipeCell *)[self.loveTableView cellForRowAtIndexPath:indexPath];
        if (visibleCell != cell) {
            [visibleCell resetContainerView];
        }
    }
}

- (void)swipingLeftForCell:(JASwipeCell *)cell
{
    NSArray *indexPaths = [self.loveTableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in indexPaths) {
        JASwipeCell *visibleCell = (JASwipeCell *)[self.loveTableView cellForRowAtIndexPath:indexPath];
        if (visibleCell != cell) {
            [visibleCell resetContainerView];
        }
    }
}

- (void)loadNewData
{
    [self.articleArr removeAllObjects];
    NSString *url = [NSString stringWithFormat:@"%@v1/news/CollectionList?pageNum=%d&count=20&UserID=%@", kAppBaseURL,self.pageNum,thirdPartyLoginUserId];
    [WTRequestCenter getWithURL:url headers:@{@"AccessToken":accessTocken,@"Content-Type":@"application/json"} parameters:nil option:WTRequestCenterCachePolicyNormal finished:^(NSURLResponse *response, NSData *data) {
        [self.loveTableView.mj_header endRefreshing];
        NSDictionary *obj = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        DeBugLog(@"文章列表是%@",obj);
        if ([[obj objectForKey:@"ReturnCode"] intValue]==200) {
            
            if ([[obj objectForKey:@"ArticleList"] count] == 0 ) {
                [self.loveTableView addSubview:self.messageLabel];
                [self.loveTableView reloadData];
            }else{
                [self.messageLabel removeFromSuperview];
                [self.articleArr addObjectsFromArray:[obj objectForKey:@"ArticleList"]];
                [self.loveTableView reloadData];
            }
        }else{
            [NSObject showHudTipStr:[obj objectForKey:@"ErrorMessage"]];
        }
        
    } failed:^(NSURLResponse *response, NSError *error) {
        [self.loveTableView addSubview:self.messageLabel];
    }];
}

- (void)loadLastData
{
    self.pageNum +=1;
    NSString *url = [NSString stringWithFormat:@"%@v1/news/CollectionList?pageNum=%d&count=20&UserID=%@", kAppBaseURL,self.pageNum,thirdPartyLoginUserId];
    [WTRequestCenter getWithURL:url headers:@{@"AccessToken":accessTocken,@"Content-Type":@"application/json"} parameters:nil option:WTRequestCenterCachePolicyNormal finished:^(NSURLResponse *response, NSData *data) {
        [self.loveTableView.mj_footer endRefreshing];
        NSDictionary *obj = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        DeBugLog(@"文章列表是%@",obj);
        if ([[obj objectForKey:@"ReturnCode"] intValue]==200) {
            
            if ([[obj objectForKey:@"ArticleList"] count] > 0 ) {
                [self.articleArr addObjectsFromArray:[obj objectForKey:@"ArticleList"]];
                [self.loveTableView reloadData];
            }else{
                self.pageNum -= 1;
            }
        }else{
            [NSObject showHudTipStr:[obj objectForKey:@"ErrorMessage"]];
        }
        
    } failed:^(NSURLResponse *response, NSError *error) {
        [self.loveTableView addSubview:self.messageLabel];
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
