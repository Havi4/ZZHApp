//
//  UserProtocolViewController.m
//  SleepRecoding
//
//  Created by Havi on 15/4/22.
//  Copyright (c) 2015年 Havi. All rights reserved.
//

#import "UserProtocolViewController.h"

@interface UserProtocolViewController ()
@property (nonatomic, strong) SCBarButtonItem *leftBarItem;

@end

@implementation UserProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.leftBarItem = [[SCBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_navi_back"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.sc_navigationItem.title = @"用户协议";
    self.sc_navigationItem.leftBarButtonItem = self.leftBarItem;
    
    UIWebView *view = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    view.scrollView.scrollEnabled = YES;
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"protocol" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.view addSubview:view];
    [view loadRequest:request];
}

- (void)backToHomeView:(UIButton *)sender
{
    NSArray *arr = self.navigationController.viewControllers;
    if ([arr containsObject:self]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
   
    
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
