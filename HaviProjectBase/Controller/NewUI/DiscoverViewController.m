//
//  DiscoverViewController.m
//  HaviProjectBase
//
//  Created by HaviLee on 2016/11/3.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "DiscoverViewController.h"

@interface DiscoverViewController ()

@property (nonatomic, strong) SCBarButtonItem *leftBarItem;

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavigationBar];
}

- (void)initNavigationBar
{
    self.navigationController.navigationBarHidden = YES;
    self.leftBarItem = [[SCBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gn"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowMenuNotification object:nil];
    }];
    self.sc_navigationItem.leftBarButtonItem = self.leftBarItem;
    
    self.sc_navigationItem.title = @"发现";
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
