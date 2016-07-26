//
//  ChangeLanguageViewController.m
//  HaviProjectBase
//
//  Created by Havi on 16/7/26.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "ChangeLanguageViewController.h"
#import "LangageTableViewCell.h"

@interface ChangeLanguageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) SCBarButtonItem *leftBarItem;
@property (nonatomic, strong) SCBarButtonItem *rightBarItem;
@property (nonatomic, strong) UITableView *languaeTable;
@end

@implementation ChangeLanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.leftBarItem = [[SCBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_navi_back"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.sc_navigationItem.title = @"语言切换";
    self.sc_navigationItem.leftBarButtonItem = self.leftBarItem;
    [self.view addSubview:self.languaeTable];
    self.rightBarItem = [[SCBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_done"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        [self changeLanguage];
    }];
    self.sc_navigationItem.rightBarButtonItem = self.rightBarItem;
}

- (UITableView *)languaeTable
{
    if (!_languaeTable) {
        _languaeTable = [[UITableView alloc]initWithFrame:(CGRect){0,9,self.view.frame.size.width,self.view.frame.size.height-9} style:UITableViewStyleGrouped];
        _languaeTable.delegate = self;
        _languaeTable.dataSource = self;
    }
    return _languaeTable;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LangageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[LangageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"简体中文";
        if ([langaueChoice intValue]==0) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }else{
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else{
        cell.textLabel.text = @"English";
        if ([langaueChoice intValue]==0) {
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;

        }else{
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    langaueChoice = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    [tableView reloadData];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)changeLanguage
{
    DeBugLog(@"选择语言");
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
