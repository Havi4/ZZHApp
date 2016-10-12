//
//  DoctorInfomationViewController.m
//  HaviProjectBase
//
//  Created by Havi on 16/9/20.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "DoctorInfomationViewController.h"
#import "DocInfoTitileTableViewCell.h"
#import "DocInfoDetailTableViewCell.h"
#import "WTRequestCenter.h"

@interface DoctorInfomationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) SCBarButtonItem *leftBarItem;
@property (nonatomic, strong) UITableView *assementView;
@property (nonatomic, strong) NSDictionary *docDic;

@end

@implementation DoctorInfomationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.backgroundImageView.image = [UIImage imageNamed:@""];
    self.view.backgroundColor = [UIColor colorWithRed:0.957 green:0.961 blue:0.965 alpha:1.00];

    [self initNavigationBar];
    [self.view addSubview:self.assementView];
    [self getDocInfomation];
}

- (void)initNavigationBar
{
    self.navigationController.navigationBarHidden = YES;
    self.leftBarItem = [[SCBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_navi_back"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.sc_navigationItem.leftBarButtonItem = self.leftBarItem;
    
    self.sc_navigationItem.title = @"医生详情";
}

- (UITableView *)assementView
{
    if (!_assementView) {
        _assementView = [[UITableView alloc]initWithFrame:(CGRect){0,64,self.view.frame.size.width,self.view.frame.size.height-64} style:UITableViewStylePlain];
        _assementView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _assementView.tableHeaderView = [[UIView alloc]initWithFrame:(CGRect){0,0,self.view.frame.size.width,0.01}];
        _assementView.delegate = self;
        _assementView.dataSource = self;
        _assementView.backgroundColor = [UIColor colorWithRed:0.957 green:0.961 blue:0.965 alpha:1.00];
    }
    return _assementView;
}

- (void)getDocInfomation
{
    NSString *url = [NSString stringWithFormat:@"%@v1/cy/Doctor/Detail",[NSObject baseURLStrIsTest] ? kAppTestBaseURL: kAppBaseURL];
    NSDictionary *dicPara = @{
                              @"UserId": thirdPartyLoginUserId,
                              @"DoctorId":self.docID,
                              };
    [NSObject showHud];
    [WTRequestCenter postWithURL:url header:@{@"AccessToken":accessTocken,@"Content-Type":@"application/json"} parameters:dicPara finished:^(NSURLResponse *response, NSData *data) {
        [NSObject hideHud];
        NSDictionary *obj = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([[obj objectForKey:@"ReturnCode"] intValue]==200) {
            
            NSDictionary *docInfo = [obj objectForKey:@"Result"];
            self.docDic = docInfo;
            [self.assementView reloadData];
        }else{
            [NSObject showHudTipStr:@"获取医生信息失败"];
        }
    } failed:^(NSURLResponse *response, NSError *error) {
        [NSObject hideHud];
        [NSObject showHudTipStr:@"获取医生信息失败"];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        DocInfoTitileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
        if (!cell) {
            cell = [[DocInfoTitileTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"];
        }
        [cell configCellWithDic:self.docDic];
//        cell.selectAssementView = ^(NSInteger assementNum){
//            self.docAssementNum = assementNum;
//        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else{
        DocInfoDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (!cell) {
            cell = [[DocInfoDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        }
        if (self.docDic) {
            if (indexPath.section==1) {
                NSDictionary *dic = @{
                                      @"title":@"擅长疾病及诊所介绍",
                                      @"detail":[self.docDic objectForKey:@"good_at"]
                                      };
                [cell configCellWithDic:dic];
            }else if (indexPath.section==2) {
                NSDictionary *dic = @{
                                      @"title":@"医学教育背景介绍",
                                      @"detail":self.eduIntroduction
                                      };
                [cell configCellWithDic:dic];
            }else if (indexPath.section==3) {
                NSDictionary *dic = @{
                                      @"title":@"学术研究成果、获奖介绍",
                                      @"detail":[self.docDic objectForKey:@"description"]
                                      };
                [cell configCellWithDic:dic];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==0) {
        return 16;
    }
    return 0.0001;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 60;
    }
    else if (indexPath.section == 1){
        if (self.docDic) {
            CGFloat a = [self heightForText:[self.docDic objectForKey:@"good_at"]];
            if (a<30) {
                a = 30;
            }
            return 44 + 8 +a;
        }
    }if (indexPath.section == 2){
        if (self.docDic) {
        
            CGFloat a = [self heightForText:self.eduIntroduction];
            if (a<30) {
                a = 30;
            }
            return 44 + 8 +a;
        }
    }if (indexPath.section == 3){
        if (self.docDic) {
            CGFloat a = [self heightForText:[self.docDic objectForKey:@"description"]];
            if (a<30) {
                a = 30;
            }
            return 44 + 8 +a;
        }
    }
    return 44;
}

- (CGFloat)heightForText:(NSString *)text
{
    //设置计算文本时字体的大小,以什么标准来计算
    NSDictionary *attrbute = @{NSFontAttributeName:[UIFont systemFontOfSize:11]};
    CGFloat width = self.view.frame.size.width-32;
    return [text boundingRectWithSize:CGSizeMake(width, 100) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrbute context:nil].size.height+15;
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
