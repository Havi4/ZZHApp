//
//  ArticleListViewController.m
//  HaviProjectBase
//
//  Created by Havi on 2016/9/28.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "ArticleListViewController.h"
#import "ArticleViewController.h"

@interface ArticleListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) SCBarButtonItem *leftBarItem;
@property (nonatomic, strong) UITableView *tagTableView;


@end

@implementation ArticleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavigationBar];
    [self.view addSubview:self.tagTableView];
}

- (void)initNavigationBar
{
    self.backgroundImageView.image = [UIImage imageNamed:@""];
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
        _tagTableView.backgroundColor = [UIColor lightGrayColor];
    }
    return _tagTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.articleList objectForKey:@"ArticleList"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell11"];
    UILabel *cellTitle ;
    UILabel *date ;
    UIView *backView ;
    if (!cell) {
        backView = [[UIView alloc]init];
        cellTitle = [[UILabel alloc]init];
        date = [[UILabel alloc]init];
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell11"];
        backView.backgroundColor = [UIColor whiteColor];
        [cell addSubview:backView];
        [backView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.mas_left).offset(4);
            make.right.equalTo(cell.mas_right).offset(-4);
            make.top.equalTo(cell.mas_top).offset(4);
            make.bottom.equalTo(cell.mas_bottom).offset(-4);
        }];
        [cell addSubview:cellTitle];
        cellTitle.font = [UIFont systemFontOfSize:15];
        [cellTitle makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.left.equalTo(cell.mas_left).offset(8);
        }];
        cellTitle.text = [[[self.articleList objectForKey:@"ArticleList"] objectAtIndex:indexPath.row] objectForKey:@"Title"];
        [cell addSubview:date];
        date.font = [UIFont systemFontOfSize:12];
        [date makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.right.equalTo(cell.mas_right).offset(-8);
            make.left.equalTo(cellTitle.mas_right).offset(-4);
            make.width.equalTo(@70);
        }];
    }
    date.text = [[[[self.articleList objectForKey:@"ArticleList"] objectAtIndex:indexPath.row] objectForKey:@"SystemDate"] substringToIndex:10];
    cell.backgroundColor = [UIColor clearColor];
    
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
    article.articleTitle = [[[self.articleList objectForKey:@"ArticleList"] objectAtIndex:indexPath.row] objectForKey:@"Title"];
    article.articleURL = [[[self.articleList objectForKey:@"ArticleList"] objectAtIndex:indexPath.row] objectForKey:@"FileName"];
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
