//
//  HomePageViewController.m
//  HaviProjectBase
//
//  Created by Havi on 16/7/21.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "HomePageViewController.h"
#import "SCBarButtonItem.h"

@interface HomePageViewController ()
@property (nonatomic, strong) SCBarButtonItem *leftBarItem;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createBarItems];
}

- (void)createBarItems
{
    self.leftBarItem = [[SCBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_menu"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowMenuNotification object:nil];
    }];
    self.sc_navigationItem.leftBarButtonItem = self.leftBarItem;
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
