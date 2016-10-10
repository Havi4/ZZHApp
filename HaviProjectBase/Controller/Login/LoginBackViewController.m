//
//  LoginBackViewController.m
//  HaviProjectBase
//
//  Created by HaviLee on 2016/10/10.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "LoginBackViewController.h"

@interface LoginBackViewController ()

@end

@implementation LoginBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.backgroundImageView.image = [UIImage imageNamed:@"backlogin"];
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
