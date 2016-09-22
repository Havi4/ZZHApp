//
//  SubImagePickerViewController.m
//  HaviProjectBase
//
//  Created by Havi on 16/9/22.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "SubImagePickerViewController.h"

@interface SubImagePickerViewController ()

@end

@implementation SubImagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark status bar style
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark navigationBar tintColor & title textColor
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.navigationBar.tintColor = [UIColor whiteColor];
        [self.navigationBar setTitleTextAttributes:@{
                                                     UITextAttributeTextColor : [UIColor whiteColor], UITextAttributeFont:[UIFont systemFontOfSize:17]
                                                     }];
        self.navigationBar.backgroundColor = [UIColor blackColor];
    }
    return self;
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
