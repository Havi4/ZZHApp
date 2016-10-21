//
//  ArticleListViewController.m
//  HaviProjectBase
//
//  Created by Havi on 2016/9/28.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "ArticleListViewController.h"
#import "ArticleViewController.h"
#import "WTRequestCenter.h"

@interface ArticleListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) SCBarButtonItem *leftBarItem;
@property (nonatomic, strong) UITableView *tagTableView;
@property (nonatomic, strong) NSArray *arr;

@end

@implementation ArticleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavigationBar];
    [self.view addSubview:self.tagTableView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self getArticleListWithError:nil];
}

- (void)getArticleListWithError:(NSError *)error{
    
    NSString *url = [NSString stringWithFormat:@"%@v1/news/ArticleList?PageNum=0&Count=100&Tips=%@",[NSObject baseURLStrIsTest] ? kAppTestBaseURL: kAppBaseURL,self.tag];
    
    [NSObject showHud];
    [WTRequestCenter getWithURL:url headers:@{@"AccessToken":accessTocken,@"Content-Type":@"application/json"} parameters:nil option:WTRequestCenterCachePolicyNormal finished:^(NSURLResponse *response, NSData *data) {
        [NSObject hideHud];
        NSDictionary *obj = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        DeBugLog(@"文章列表是%@",obj);
        if ([[self.articleList objectForKey:@"ArticleList"] count]>0) {
            self.articleList = obj;
            NSArray *_sortedDetailDevice = [[self.articleList objectForKey:@"ArticleList"] sortedArrayUsingComparator:^NSComparisonResult(NSDictionary* _Nonnull obj1, NSDictionary* _Nonnull obj2) {
                return [[obj2 objectForKey:@"SystemDate"] compare:[obj1 objectForKey:@"SystemDate"] options:NSCaseInsensitiveSearch];
            }];
            self.arr = _sortedDetailDevice;
            [self.tagTableView reloadData];
        }
    } failed:^(NSURLResponse *response, NSError *error) {
        [NSObject hideHud];
        [NSObject showHudTipStr:@"服务器出错了"];
    }];
}

- (void)initNavigationBar
{
    self.backgroundImageView.image = [UIImage imageNamed:@""];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.5];
    self.leftBarItem = [[SCBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_navi_back"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.sc_navigationItem.leftBarButtonItem = self.leftBarItem;
    
    self.sc_navigationItem.title = self.stitle;
}

- (UITableView *)tagTableView
{
    if (!_tagTableView) {
        _tagTableView = [[UITableView alloc]initWithFrame:(CGRect){0,64,self.view.frame.size.width,self.view.frame.size.height-64} style:UITableViewStylePlain];
        _tagTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tagTableView.delegate = self;
        _tagTableView.dataSource = self;
        _tagTableView.backgroundColor = [UIColor whiteColor];
    }
    return _tagTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell11"];
    UILabel *cellTitle ;
    UILabel *date ;
    UIView *backView ;
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell11"];
    backView = [[UIView alloc]init];
    cellTitle = [[UILabel alloc]init];
    date = [[UILabel alloc]init];
    backView.backgroundColor = [UIColor whiteColor];
    [cell addSubview:backView];
    [backView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.mas_left).offset(0);
        make.right.equalTo(cell.mas_right).offset(0);
        make.top.equalTo(cell.mas_top).offset(0);
        make.bottom.equalTo(cell.mas_bottom).offset(0);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor grayColor];
    [cell addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.mas_left).offset(0);
        make.bottom.equalTo(cell.mas_bottom).offset(0);
        make.height.equalTo(@0.5);
        make.width.equalTo(cell.mas_width);
    }];
    [cell addSubview:cellTitle];
    cellTitle.font = [UIFont systemFontOfSize:15];
    [cellTitle makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.mas_centerY);
        make.left.equalTo(cell.mas_left).offset(8);
    }];
    
    [cell addSubview:date];
    date.font = [UIFont systemFontOfSize:12];
    [date makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.mas_centerY);
        make.right.equalTo(cell.mas_right).offset(-8);
        make.left.equalTo(cellTitle.mas_right).offset(8);
        make.width.equalTo(@70);
    }];
    cellTitle.text = [[self.arr objectAtIndex:indexPath.row] objectForKey:@"Title"];
    date.text = [[[self.arr objectAtIndex:indexPath.row] objectForKey:@"SystemDate"] substringToIndex:10];
    cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.5];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if ([tableView isEqual:self.consultView]) {
    //
    //        if (indexPath.section ==0) {
    //            return self.view.frame.size.height -64;
    //        }else{
    //            return 100;
    //        }
    //    }else{
    //    }
    return 44;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ArticleViewController *article = [[ArticleViewController alloc]init];
    article.articleTitle = [[self.arr objectAtIndex:indexPath.row] objectForKey:@"Title"];
    article.articleURL = [[self.arr objectAtIndex:indexPath.row] objectForKey:@"Url"];
    [self.navigationController pushViewController:article animated:YES];
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
