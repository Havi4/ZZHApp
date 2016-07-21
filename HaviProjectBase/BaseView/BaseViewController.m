//
//  BaseViewController.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/3.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "BaseViewController.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import "AppDelegate.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "ThirdLoginCallBackManager.h"
#import "MMPopupItem.h"
#import "THPinViewController.h"
#import "DeviceListViewController.h"

@interface BaseViewController ()<LXActivityDelegate>

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
        _backgroundImageView.dk_imagePicker = DKImageWithNames(@"background", @"background");
    }
    return _backgroundImageView;
}

- (UIButton *)menuButton
{
    if (!_menuButton) {
        _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _menuButton.backgroundColor = [UIColor clearColor];
        [_menuButton dk_setImage:DKImageWithNames(@"re_order_0", @"re_order_1") forState:UIControlStateNormal];
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
        [_leftButton dk_setImage:DKImageWithNames(@"btn_back_0", @"btn_back_1") forState:UIControlStateNormal];
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

- (LXActivity*)shareNewMenuView
{
    
    NSArray *shareButtonTitleArray = @[@"朋友圈",@"微信好友",@"新浪微博",@"QQ好友",@"QQ空间"];
    NSArray *shareButtonImageNameArray = @[@"icon_wechat",@"weixin",@"sina",@"qq",@"qqzone"];
    
    _shareNewMenuView = [[LXActivity alloc] initWithTitle:@"分享到社交平台" delegate:self cancelButtonTitle:nil ShareButtonTitles:shareButtonTitleArray withShareButtonImagesName:shareButtonImageNameArray];
    return _shareNewMenuView;
}

#pragma mark lxactivity delegate

- (void)didClickOnImageIndex:(NSInteger *)imageIndex
{
    NSLog(@"%d",(int)imageIndex);
    if ((int)imageIndex ==0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self sendImageContent];
        });
        
    }else if ((int)imageIndex==1){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self sendImageToFriend];
        });
    }else if ((int)imageIndex == 2){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self shareButtonPressed];
        });
    }else if ((int)imageIndex == 3){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self shareButtonQQ];
        });
    }else if ((int)imageIndex == 4){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self shareButtonQQZone];
        });
    }
}


#pragma mark 分享到qq

- (void)shareButtonQQZone
{
    NSString *utf8String = @"http://www.meddo.com.cn";
    NSString *title = @"智照护";
    NSString *description = @"我正在使用智照护App监控我的睡眠";
    NSString *previewImageUrl = @"http://www.meddo.com.cn/images/logo.jpg";
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:[NSURL URLWithString:utf8String]
                                title:title
                                description:description
                                previewImageURL:[NSURL URLWithString:previewImageUrl]];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    //将内容分享到qzone
    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    if (sent ==0 || sent==7) {
        DeBugLog(@"分享成功");
    }else{
        [NSObject showHudTipStr:@"分享出错啦"];
    }
}

- (void)shareButtonQQ
{
    NSData *data;
    UIImage *image1 = [UIImage captureScreen];
    
    if (UIImagePNGRepresentation(image1) == nil) {
        
        data = UIImageJPEGRepresentation(image1, 1);
        
    } else {
        
        data = UIImagePNGRepresentation(image1);
    }    //
    QQApiImageObject *imgObj = [QQApiImageObject objectWithData:data
                                               previewImageData:data
                                                          title:@"智照护"
                                                    description:@"我正在使用智照护app监控我的睡眠"];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
    //将内容分享到qq
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    if (sent ==0) {
        DeBugLog(@"分享成功");
    }else{
        [NSObject showHudTipStr:@"分享出错啦"];
    }
    
}

#pragma mark 分享到微博
- (void)shareButtonPressed
{
    ThirdLoginCallBackManager *myDelegate =[ThirdLoginCallBackManager sharedInstance];
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = kWBRedirectURL;
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare] authInfo:authRequest access_token:myDelegate.wbtoken];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [WeiboSDK sendRequest:request];
}

- (WBMessageObject *)messageToShare
{
    WBMessageObject *message = [WBMessageObject message];
    message.text = NSLocalizedString(@"我正在使用智照护App监控我的睡眠,快来使用啦!", nil);
    WBImageObject *image = [WBImageObject object];
    NSData *data;
    UIImage *image1 = [UIImage captureScreen];
    
    if (UIImagePNGRepresentation(image1) == nil) {
        
        data = UIImageJPEGRepresentation(image1, 1);
        
    } else {
        
        data = UIImagePNGRepresentation(image1);
    }
    image.imageData = data;
    message.imageObject = image;
    return message;
}
#pragma mark 分享给好友
- (void)sendImageToFriend
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"专访张小龙：产品之上的世界观";
    message.description = @"微信的平台化发展方向是否真的会让这个原本简洁的产品变得臃肿？在国际化发展方向上，微信面临的问题真的是文化差异壁垒吗？腾讯高级副总裁、微信产品负责人张小龙给出了自己的回复。";
    UIImage *image = [UIImage captureScreen];
    [message setThumbImage:image];
    
    WXImageObject *ext = [WXImageObject object];
    NSData *data;
    if (UIImagePNGRepresentation(image) == nil) {
        
        data = UIImageJPEGRepresentation(image, 1);
        
    } else {
        
        data = UIImagePNGRepresentation(image);
    }
    ext.imageData = data;
    
    message.mediaObject = ext;
    message.mediaTagName = @"WECHAT_TAG_JUMP_APP";
    message.messageExt = @"这是第三方带的测试字段";
    message.messageAction = @"<action>dotalist</action>";
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
}
#pragma mark 分享到朋友圈
- (void)sendImageContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    UIImage *image = [UIImage captureScreen];
    [message setThumbImage:image];
    WXImageObject *ext = [WXImageObject object];
    NSData *data;
    if (UIImagePNGRepresentation(image) == nil) {
        
        data = UIImageJPEGRepresentation(image, 1);
        
    } else {
        
        data = UIImagePNGRepresentation(image);
    }
    ext.imageData = data;
    
    message.mediaObject = ext;
    message.title = @"智照护";
    message.mediaTagName = @"WECHAT_TAG_JUMP_APP";
    message.messageExt = @"智照护-您的睡眠管家";
    message.messageAction = @"<action>dotalist</action>";
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
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
    navIV.dk_imagePicker = DKImageWithNames(@"navigation_bar_bg_0", @"navigation_bar_bg_1");
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
        titleLabel.dk_textColorPicker = kTextColorPicker;
        [titleLabel setFont:kTextTitleWordFont];
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
        _clearNaviTitleLabel.dk_textColorPicker = kTextColorPicker;
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

- (void)showNoDeviceBindingAlert
{
    MMPopupItemHandler block = ^(NSInteger index){
        DeBugLog(@"clickd %@ button",@(index));
        if (index == 1) {
            DeviceListViewController *controller = [[DeviceListViewController alloc]init];
            self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:controller];
        }
    };
    NSArray *items =
    @[MMItemMake(@"取消", MMItemTypeNormal, block),MMItemMake(@"确定", MMItemTypeNormal, block)];
    MMAlertView *alert = [[MMAlertView alloc]initWithTitle:@"提示" detail:@"您还没有绑定或者激活床垫设备,没有办法显示数据,是否现在绑定或者激活?" items:items];
    [alert show];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
