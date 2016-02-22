//
//  BaseViewController.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/3.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@property (nonatomic, assign) float nSpaceNavY;
@property (nonatomic, strong) UIImageView *statusBarView;//状态栏
@property (nonatomic, strong) UIView *navView;//导航栏
@property (nonatomic, strong) UIView *rightV;//右侧button
@property (nonatomic, strong) UIImageView *clearStatusBarView;//状态栏
@property (nonatomic, strong) UIView *clearNavView;//透明导航栏
@property (nonatomic, strong) UIView *clearRightV;//透明右侧button
@property (nonatomic, strong) UILabel *clearNaviTitleLabel;//透明导航栏title


@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.backgroundImageView];
    
}

#pragma mark setters

- (UIImageView *)backgroundImageView
{
    if (_backgroundImageView==nil) {
        _backgroundImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        _backgroundImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"pic_bg_%d",selectedThemeIndex]];
    }
    return _backgroundImageView;
}

- (UIButton *)menuButton
{
    if (!_menuButton) {
        _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _menuButton.backgroundColor = [UIColor clearColor];
        UIImage *i = [UIImage imageNamed:[NSString stringWithFormat:@"re_order_%d",1]];
        [_menuButton setImage:i forState:UIControlStateNormal];
        [_menuButton setFrame:CGRectMake(0, 0, 44, 44)];
        [_menuButton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _menuButton;
}

- (UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.frame = CGRectMake(0, 0, 44, 44);
        [_leftButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_back_%d",selectedThemeIndex]] forState:UIControlStateNormal];
    }
    return _leftButton;
}

- (UIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _rightButton;
}

#pragma mark 设置导航栏

/**
 *  自定义导航栏有背景图片
 *
 *  @param szTitle  导航栏标题
 *  @param menuItem 导航栏的左右两侧的button
 */
- (void)createNavWithTitle:(NSString *)szTitle createMenuItem:(UIView *(^)(int nIndex))menuItem
{
    UIImageView *navIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, _nSpaceNavY, self.view.frame.size.width, 64-_nSpaceNavY)];
    navIV.tag = 3000;
//    int picIndex = [QHConfiguredObj defaultConfigure].nThemeIndex;
    NSString *imageName = [NSString stringWithFormat:@"navigation_bar_bg_%d",1];
    [navIV setImage:[UIImage imageNamed:imageName]];
    [self.view addSubview:navIV];
    
    /* { 导航条 } */
    if (_navView == nil) {
        _navView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, StatusbarSize, self.view.frame.size.width, 44.f)];
    }
    ((UIImageView *)_navView).backgroundColor = [UIColor clearColor];
    [self.view addSubview:_navView];
    _navView.userInteractionEnabled = YES;
    
    if (szTitle != nil)
    {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((_navView.frame.size.width - 200)/2, (_navView.frame.size.height - 40)/2, 200, 40)];
        [titleLabel setText:szTitle];
        titleLabel.tag = 3001;
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setTextColor:selectedThemeIndex == 0?kDefaultColor:[UIColor whiteColor]];
        [titleLabel setFont:kDefaultWordFont];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [_navView addSubview:titleLabel];
    }
    
    UIView *item1 = menuItem(0);
    if (item1 != nil)
    {
        [_navView addSubview:item1];
    }
    UIView *item2 = menuItem(1);
    if (item2 != nil)
    {
        _rightV = item2;
        [_navView addSubview:item2];
    }
}
/**
 *  创建透明的导航栏
 *
 *  @param szTitle  标题
 *  @param menuItem 左右放回键
 */
- (void)createClearBgNavWithTitle:(NSString *)szTitle createMenuItem:(UIView *(^)(int nIndex))menuItem
{
    UIImageView *navIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, _nSpaceNavY, self.view.frame.size.width, 64-_nSpaceNavY)];
    navIV.tag = 2000;
    [self.view addSubview:navIV];
    
    /* { 导航条 } */
    _clearNavView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, StatusbarSize, self.view.frame.size.width, 44.f)];
    ((UIImageView *)_navView).backgroundColor = [UIColor clearColor];
    [self.view addSubview:_clearNavView];
    _clearNavView.userInteractionEnabled = YES;
    
    if (szTitle != nil)
    {
        self.clearNaviTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake((_clearNavView.frame.size.width - 200)/2, 0, 200, 44)];
        [_clearNaviTitleLabel setText:szTitle];
        _clearNaviTitleLabel.tag = 2001;
        [_clearNaviTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [_clearNaviTitleLabel setTextColor:selectedThemeIndex == 0?kDefaultColor:[UIColor whiteColor]];
        [_clearNaviTitleLabel setFont:kDefaultWordFont];
        [_clearNaviTitleLabel setBackgroundColor:[UIColor clearColor]];
        [_clearNavView addSubview:_clearNaviTitleLabel];
    }
    
    UIView *item1 = menuItem(0);
    if (item1 != nil)
    {
        [_clearNavView addSubview:item1];
    }
    UIView *item2 = menuItem(1);
    if (item2 != nil)
    {
        _clearRightV = item2;
        [_clearNavView addSubview:item2];
    }
}

- (void)createClearBgNavWithTitle:(NSString *)szTitle andTitleColor:(UIColor *)color createMenuItem:(UIView *(^)(int nIndex))menuItem
{
    UIImageView *navIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, _nSpaceNavY, self.view.frame.size.width, 64-_nSpaceNavY)];
    navIV.tag = 2000;
    [self.view addSubview:navIV];
    
    /* { 导航条 } */
    _clearNavView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, StatusbarSize, self.view.frame.size.width, 44.f)];
    ((UIImageView *)_navView).backgroundColor = [UIColor clearColor];
    [self.view addSubview:_clearNavView];
    _clearNavView.userInteractionEnabled = YES;
    
    if (szTitle != nil)
    {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((_clearNavView.frame.size.width - 200)/2, 0, 200, 40)];
        [titleLabel setText:szTitle];
        titleLabel.tag = 2001;
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setTextColor:color];
        [titleLabel setFont:kDefaultWordFont];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [_clearNavView addSubview:titleLabel];
    }
    
    UIView *item1 = menuItem(0);
    if (item1 != nil)
    {
        [_clearNavView addSubview:item1];
    }
    UIView *item2 = menuItem(1);
    if (item2 != nil)
    {
        _clearRightV = item2;
        [_clearNavView addSubview:item2];
    }
}

#pragma mark user action
- (void)presentLeftMenuViewController:(id)sender
{
    [self.sidePanelController showLeftPanelAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
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
