//
//  EvaluationViewController.m
//  HaviProjectBase
//
//  Created by Havi on 16/9/20.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "EvaluationViewController.h"
#import "SatisfactionTableViewCell.h"
#import "AssementTableViewCell.h"
#import "WTRequestCenter.h"

@interface EvaluationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) SCBarButtonItem *leftBarItem;
@property (nonatomic, strong) SCBarButtonItem *rightBarItem;
@property (nonatomic, strong) UITableView *assementView;
@property (nonatomic, assign) NSInteger docAssementNum;
@property (nonatomic, strong) NSString *textString;

@end

@implementation EvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.backgroundImageView.image = [UIImage imageNamed:@""];
    self.view.backgroundColor = [UIColor colorWithRed:0.957 green:0.961 blue:0.965 alpha:1.00];
    self.docAssementNum = 5;
    self.textString = @"请输入5-20个字";
    [self initNavigationBar];
    [self.view addSubview:self.assementView];
}

- (UITableView *)assementView
{
    if (!_assementView) {
        _assementView = [[UITableView alloc]initWithFrame:(CGRect){0,64,self.view.frame.size.width,self.view.frame.size.height-64} style:UITableViewStyleGrouped];
        _assementView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _assementView.tableHeaderView = [[UIView alloc]initWithFrame:(CGRect){0,0,self.view.frame.size.width,0.01}];
        _assementView.delegate = self;
        _assementView.dataSource = self;
        _assementView.backgroundColor = [UIColor colorWithRed:0.957 green:0.961 blue:0.965 alpha:1.00];
    }
    return _assementView;
}


- (void)initNavigationBar
{
    self.navigationController.navigationBarHidden = YES;
    self.leftBarItem = [[SCBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_navi_back"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.sc_navigationItem.leftBarButtonItem = self.leftBarItem;
    
    self.rightBarItem = [[SCBarButtonItem alloc] initWithTitle:@"提交" style:SCBarButtonItemStylePlain withColor:[UIColor colorWithRed:0.157 green:0.659 blue:0.902 alpha:1.00] handler:^(id sender) {
        [self uploadEvalution];
    }];
    self.sc_navigationItem.rightBarButtonItem = self.rightBarItem;
    self.sc_navigationItem.title = @"评价";
    self.view.backgroundColor = [UIColor colorWithRed:0.957 green:0.961 blue:0.965 alpha:1.00];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        SatisfactionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
        if (!cell) {
            cell = [[SatisfactionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"];
        }
        cell.selectAssementView = ^(NSInteger assementNum){
            self.docAssementNum = assementNum;
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else{
        AssementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (!cell) {
            cell = [[AssementTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        }
        cell.textViewData = ^(NSString *textData){
            self.textString = textData;
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 16;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 44;
    }
    return 150;
}
- (void)uploadEvalution
{
//    if ([self.textString isEqualToString:@"请输入0-20个字"] || self.textString.length == 0) {
//        [NSObject showHudTipStr:@"请输入评价描述"];
//        return;
//    }
    NSString *url = [NSString stringWithFormat:@"%@v1/cy/Problem/Assess",[NSObject baseURLStrIsTest] ? kAppTestBaseURL: kAppBaseURL];
    NSDictionary *dicPara = @{
                              @"UserId": thirdPartyLoginUserId,
                              @"Content": @[
                                      @{
                                          @"type": @"text",
                                          @"text": self.textString,
                                          },
                                      ],
                              @"ProblemId": self.problemID,
                              @"star":[NSNumber numberWithInteger: self.docAssementNum]
                              };
    
    [NSObject showHud];
    [WTRequestCenter postWithURL:url header:@{@"AccessToken":accessTocken,@"Content-Type":@"application/json"} parameters:dicPara finished:^(NSURLResponse *response, NSData *data) {
        [NSObject hideHud];
        NSDictionary *obj = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([[[obj objectForKey:@"Result"] objectForKey:@"error"] intValue]==0) {
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"deletProblem" object:nil];
            [NSObject showHudTipStr:@"评价成功"];
            
        }else if ([[[obj objectForKey:@"Result"] objectForKey:@"error"] intValue]==1){
            [NSObject showHudTipStr:[[obj objectForKey:@"Result"] objectForKey:@"error_msg"]];
        }
    } failed:^(NSURLResponse *response, NSError *error) {
        [NSObject hideHud];
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
