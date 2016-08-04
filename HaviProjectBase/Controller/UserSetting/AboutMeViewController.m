//
//  AboutMeViewController.m
//  SleepRecoding
//
//  Created by Havi_li on 15/3/31.
//  Copyright (c) 2015年 Havi. All rights reserved.
//

#import "AboutMeViewController.h"


@interface AboutMeViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) NSCalendar *currentCalendar;
@property (nonatomic, strong) SCBarButtonItem *leftBarItem;

@end

@implementation AboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    // 使用方法
    self.view.backgroundColor = [UIColor whiteColor];
    self.leftBarItem = [[SCBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_navi_back"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.sc_navigationItem.title = @"关于迈动";
    self.sc_navigationItem.leftBarButtonItem = self.leftBarItem;
//    [self setDateView];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    image.image = [UIImage imageNamed:@"new_about"];
    [self.view addSubview:image];
    self.sc_navigationBar.backgroundColor = [UIColor clearColor];
}

- (void)backToHomeView:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
