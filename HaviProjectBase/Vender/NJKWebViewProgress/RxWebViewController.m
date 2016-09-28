//
//  RxWebViewController.m
//  RxWebViewController
//
//  Created by roxasora on 15/10/23.
//  Copyright © 2015年 roxasora. All rights reserved.
//

#import "RxWebViewController.h"
#import "WTRequestCenter.h"
#import "ConversationListViewController.h"
#import "ArticleListViewController.h"
#import "ArticleViewController.h"

#define boundsWidth self.view.bounds.size.width
#define boundsHeight (self.view.bounds.size.height-64)
@interface RxWebViewController ()<UIWebViewDelegate,UINavigationBarDelegate,UITableViewDelegate,UITableViewDataSource>

//@property (strong, nonatomic) UIBarButtonItem* customBackBarItem;
@property (strong, nonatomic) UIBarButtonItem* closeButtonItem;
@property (strong, nonatomic) UILabel *hostInfoLabel;

@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) BOOL loading;
@property (nonatomic, strong) SCBarButtonItem *leftBarItem;
@property (nonatomic, strong) UIImageView *docImageView;
@property (nonatomic, strong) UITableView *consultView;
@property (nonatomic, strong) UITableView *tagTableView;
@property (nonatomic, strong) UIView *tagBackView;


/**
 *  array that hold snapshots
 */
@property (nonatomic)NSMutableArray* snapShotsArray;

/**
 *  current snapshotview displaying on screen when start swiping
 */
@property (nonatomic)UIView* currentSnapShotView;

/**
 *  previous view
 */
@property (nonatomic)UIView* prevSnapShotView;

/**
 *  background alpha black view
 */
@property (nonatomic)UIView* swipingBackgoundView;

/**
 *  left pan ges
 */
@property (nonatomic)UIPanGestureRecognizer* swipePanGesture;

/**
 *  if is swiping now
 */
@property (nonatomic)BOOL isSwipingBack;

@property (nonatomic, strong) NSDictionary *articleList;

@end

@implementation RxWebViewController

-(UIStatusBarStyle) preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - init
-(instancetype)initWithUrl:(NSURL *)url{
    self = [super init];
    if (self) {
        _url = url;
        _progressViewColor = [UIColor colorWithRed:0.000 green:0.482 blue:0.976 alpha:1.00];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self initNavigationBar];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.title = @"";
//    self.urlString = @"http://adad184.com/2014/09/28/use-masonry-to-quick-solve-autolayout/";

    //config navigation item
    self.navigationItem.leftItemsSupplementBackButton = YES;
//    [self.view addSubview:self.consultView];
    [self.view addSubview:self.webView];
    [self.webView insertSubview:self.hostInfoLabel belowSubview:self.webView.scrollView];
    [self.view addSubview:self.progressView];
    NSString * htmlstr = [[NSString alloc]initWithContentsOfURL:[NSURL URLWithString:self.urlString] encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:htmlstr]]];
    [self.webView loadHTMLString:htmlstr baseURL:[NSURL URLWithString:self.urlString]];
    _docImageView = [[UIImageView alloc]init];
    _docImageView.image = [UIImage imageNamed:@"xiumeimei"];
    _docImageView.frame = (CGRect){self.view.frame.size.width - 50,self.view.frame.size.height - 70,40,60};
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showDoc)];
    _docImageView.userInteractionEnabled = YES;
    [_docImageView addGestureRecognizer:tap];
    [self.view addSubview:_docImageView];
}

//- (UITableView *)consultView
//{
//    if (!_consultView) {
//        _consultView = [[UITableView alloc]initWithFrame:(CGRect){0,64,self.view.frame.size.width,self.view.frame.size.height-64} style:UITableViewStylePlain];
//        _consultView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _consultView.delegate = self;
//        _consultView.dataSource = self;
//        _consultView.backgroundColor = [UIColor redColor];
//    }
//    return _consultView;
//}

- (UITableView *)tagTableView
{
    if (!_tagTableView) {
        _tagTableView = [[UITableView alloc]initWithFrame:(CGRect){0,self.webView.scrollView.contentSize.height-44*6,self.view.frame.size.width,44*6} style:UITableViewStylePlain];
        _tagTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tagTableView.delegate = self;
        _tagTableView.dataSource = self;
        _tagTableView.backgroundColor = [UIColor whiteColor];
    }
    return _tagTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([tableView isEqual:self.consultView]) {
//        if (indexPath.section == 0) {
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
//            if (!cell) {
//                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"];
//            }
//            [cell addSubview:self.webView];
//            return cell;
//        }else{
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
//            if (!cell) {
//                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
//            }
//            [cell addSubview:self.tagTableView];
//            cell.backgroundColor = [UIColor redColor];
//            return cell;
//        }
//
//    }else{
//    }
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell01"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell01"];
        }
        UIButton *cellTitle = [UIButton buttonWithType:UIButtonTypeCustom];
        [cellTitle setTitle:self.tagLists[0] forState:UIControlStateNormal];
        [cellTitle setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        cellTitle.backgroundColor = [UIColor lightGrayColor];
        cellTitle.titleLabel.font = [UIFont systemFontOfSize:14];
        [cellTitle addTarget:self action:@selector(showTagList:) forControlEvents:UIControlEventTouchUpInside];
        cellTitle.layer.cornerRadius = 3;
        cellTitle.layer.masksToBounds = YES;
        [cell addSubview:cellTitle];
        [cellTitle makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.left.equalTo(cell.mas_left).offset(8);
            make.height.equalTo(@25);
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell11"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell11"];
        }
        UILabel *cellTitle = [[UILabel alloc]init];
        [cell addSubview:cellTitle];
        cellTitle.font = [UIFont systemFontOfSize:15];
        [cellTitle makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.left.equalTo(cell.mas_left).offset(8);
        }];
        cellTitle.text = [[[self.articleList objectForKey:@"ArticleList"] objectAtIndex:indexPath.row] objectForKey:@"Title"];
        UILabel *date = [[UILabel alloc]init];
        [cell addSubview:date];
        date.font = [UIFont systemFontOfSize:12];
        date.textColor = [UIColor lightGrayColor];
        [date makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.right.equalTo(cell.mas_right).offset(-8);
            make.left.equalTo(cellTitle.mas_right).offset(-4);
            make.width.equalTo(@70);
        }];
        date.text = [[[[self.articleList objectForKey:@"ArticleList"] objectAtIndex:indexPath.row] objectForKey:@"SystemDate"] substringToIndex:10];
        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([tableView isEqual:self.consultView]) {
//        
//        if (indexPath.section ==0) {
//            return self.view.frame.size.height -64;
//        }else{
//            return 100;
//        }
//    }else{
//    }
    return 44;
}

- (void)showDoc{

    NSString *url = @"http://testzzhapi.meddo99.com:8088/v1/cy/Login";
    NSDictionary *dicPara = @{
                              @"UserId": thirdPartyLoginUserId
                              };
    [NSObject showHud];
    [WTRequestCenter postWithURL:url header:@{@"AccessToken":@"123456789",@"Content-Type":@"application/json"} parameters:dicPara finished:^(NSURLResponse *response, NSData *data) {
        [NSObject hideHud];
        NSDictionary *obj = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        DeBugLog(@"登录结果%@",obj);
        if ([[[obj objectForKey:@"Result"] objectForKey:@"error"] intValue]==0) {
            ConversationListViewController *c = [[ConversationListViewController alloc]init];
            [self.navigationController pushViewController:c animated:YES];
        }else{
            [NSObject showHudTipStr:@"登录问诊失败"];
        }
    } failed:^(NSURLResponse *response, NSError *error) {
        [NSObject hideHud];
        [NSObject showHudTipStr:@"服务器出错了"];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row>0) {
        ArticleViewController *article = [[ArticleViewController alloc]init];
        article.articleTitle = [[[self.articleList objectForKey:@"ArticleList"] objectAtIndex:indexPath.row] objectForKey:@"Title"];
        article.articleURL = [[[self.articleList objectForKey:@"ArticleList"] objectAtIndex:indexPath.row] objectForKey:@"FileName"];
        [self.navigationController pushViewController:article animated:YES];
    }
}

- (void)getArticleList{
    
    NSString *url = [NSString stringWithFormat:@"http://testzzhapi.meddo99.com:8088/v1/news/ArticleList?PageNum=0&Count=100&Tips=%@",self.tagLists[0]];
    
    [NSObject showHud];
    [WTRequestCenter getWithURL:url headers:@{@"AccessToken":@"123456789",@"Content-Type":@"application/json"} parameters:nil option:WTRequestCenterCachePolicyNormal finished:^(NSURLResponse *response, NSData *data) {
        [NSObject hideHud];
        NSDictionary *obj = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        DeBugLog(@"文章列表是%@",obj);
        self.articleList = obj;
        if ([[self.articleList objectForKey:@"ArticleList"] count]>0) {
            self.webView.scrollView.contentSize = (CGSize){self.webView.scrollView.contentSize.width,self.webView.scrollView.contentSize.height+44*6};
            [self.webView.scrollView addSubview:self.tagTableView];
            [self.tagTableView reloadData];
        }
    } failed:^(NSURLResponse *response, NSError *error) {
        [NSObject hideHud];
        [NSObject showHudTipStr:@"服务器出错了"];
    }];
}

- (void)initNavigationBar
{
    self.leftBarItem = [[SCBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_navi_back"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.sc_navigationItem.leftBarButtonItem = self.leftBarItem;
    
    self.sc_navigationItem.title = self.articleTitle;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.webView.delegate = nil;
    if (self.timer) {
        [self.timer invalidate];
    }
}


#pragma mark - public funcs
-(void)reloadWebView{
    [self.webView reload];
}

#pragma mark - logic of push and pop snap shot views
-(void)pushCurrentSnapshotViewWithRequest:(NSURLRequest*)request{
    NSLog(@"push with request %@",request);
    NSURLRequest* lastRequest = (NSURLRequest*)[[self.snapShotsArray lastObject] objectForKey:@"request"];
    
    //如果url是很奇怪的就不push
    if ([request.URL.absoluteString isEqualToString:@"about:blank"]) {
//        NSLog(@"about blank!! return");
        return;
    }
    //如果url一样就不进行push
    if ([lastRequest.URL.absoluteString isEqualToString:request.URL.absoluteString]) {
        return;
    }
    
    UIView* currentSnapShotView = [self.webView snapshotViewAfterScreenUpdates:YES];
    [self.snapShotsArray addObject:
     @{
       @"request":request,
       @"snapShotView":currentSnapShotView
       }
     ];
//    NSLog(@"now array count %d",self.snapShotsArray.count);
}

-(void)startPopSnapshotView{
    if (self.isSwipingBack) {
        return;
    }
    if (!self.webView.canGoBack) {
        return;
    }
    self.isSwipingBack = YES;
    //create a center of scrren
    CGPoint center = CGPointMake(self.view.bounds.size.width/2,64 + (self.view.bounds.size.height-64)/2);
    
    self.currentSnapShotView = [self.webView snapshotViewAfterScreenUpdates:YES];
    
    //add shadows just like UINavigationController
    self.currentSnapShotView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.currentSnapShotView.layer.shadowOffset = CGSizeMake(3, 3);
    self.currentSnapShotView.layer.shadowRadius = 5;
    self.currentSnapShotView.layer.shadowOpacity = 0.75;
    
    //move to center of screen
    self.currentSnapShotView.center = center;
    
    self.prevSnapShotView = (UIView*)[[self.snapShotsArray lastObject] objectForKey:@"snapShotView"];
    center.x -= 60;
    self.prevSnapShotView.center = center;
    self.prevSnapShotView.alpha = 1;
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.webView addSubview:self.prevSnapShotView];
    [self.webView addSubview:self.swipingBackgoundView];
    [self.webView addSubview:self.currentSnapShotView];
}

-(void)popSnapShotViewWithPanGestureDistance:(CGFloat)distance{
    if (!self.isSwipingBack) {
        return;
    }
    
    if (distance <= 0) {
        return;
    }
    
    CGPoint currentSnapshotViewCenter = CGPointMake(boundsWidth/2, (boundsHeight)/2);
    currentSnapshotViewCenter.x += distance;
    CGPoint prevSnapshotViewCenter = CGPointMake(boundsWidth/2, (boundsHeight)/2);
    prevSnapshotViewCenter.x -= (boundsWidth - distance)*60/boundsWidth;
//    NSLog(@"prev center x%f",prevSnapshotViewCenter.x);
    
    self.currentSnapShotView.center = currentSnapshotViewCenter;
    self.prevSnapShotView.center = prevSnapshotViewCenter;
    self.swipingBackgoundView.alpha = (boundsWidth - distance)/boundsWidth;
}

-(void)endPopSnapShotView{
    if (!self.isSwipingBack) {
        return;
    }
    
    //prevent the user touch for now
    self.view.userInteractionEnabled = NO;
    
    if (self.currentSnapShotView.center.x >= boundsWidth) {
        // pop success
        [UIView animateWithDuration:0.2 animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            
            self.currentSnapShotView.center = CGPointMake(boundsWidth*3/2, boundsHeight/2);
            self.prevSnapShotView.center = CGPointMake(boundsWidth/2, boundsHeight/2);
            self.swipingBackgoundView.alpha = 0;
        }completion:^(BOOL finished) {
            
            [self.webView goBack];
            [self.snapShotsArray removeLastObject];
            [self.currentSnapShotView removeFromSuperview];
            [self.prevSnapShotView removeFromSuperview];
            [self.swipingBackgoundView removeFromSuperview];
            
            self.view.userInteractionEnabled = YES;
            self.isSwipingBack = NO;
        }];
    }else{
        //pop fail
        [UIView animateWithDuration:0.2 animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            
            self.currentSnapShotView.center = CGPointMake(boundsWidth/2, boundsHeight/2);
            self.prevSnapShotView.center = CGPointMake(boundsWidth/2-60, boundsHeight/2);
            self.prevSnapShotView.alpha = 1;
        }completion:^(BOOL finished) {
            [self.prevSnapShotView removeFromSuperview];
            [self.swipingBackgoundView removeFromSuperview];
            [self.currentSnapShotView removeFromSuperview];
            self.view.userInteractionEnabled = YES;
            
            self.isSwipingBack = NO;
        }];
    }
}

#pragma mark - update nav items

-(void)updateNavigationItems{
    if (self.webView.canGoBack) {
        
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        [self.navigationItem setLeftBarButtonItems:@[self.closeButtonItem] animated:NO];
        
        //弃用customBackBarItem，使用原生backButtonItem
//        UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//        spaceButtonItem.width = -6.5;
//                [self.navigationItem setLeftBarButtonItems:@[spaceButtonItem,self.customBackBarItem,self.closeButtonItem] animated:NO];
        
    }else{
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        [self.navigationItem setLeftBarButtonItems:nil];
    }
}

#pragma mark - events handler
-(void)swipePanGestureHandler:(UIPanGestureRecognizer*)panGesture{
    CGPoint translation = [panGesture translationInView:self.webView];
    CGPoint location = [panGesture locationInView:self.webView];
//    NSLog(@"pan x %f,pan y %f",translation.x,translation.y);
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        if (location.x <= 50 && translation.x >= 0) {  //开始动画
            [self startPopSnapshotView];
        }
    }else if (panGesture.state == UIGestureRecognizerStateCancelled || panGesture.state == UIGestureRecognizerStateEnded){
        [self endPopSnapShotView];
        
    }else if (panGesture.state == UIGestureRecognizerStateChanged){
        [self popSnapShotViewWithPanGestureDistance:translation.x];
    }
}

-(void)customBackItemClicked{
    [self.webView goBack];
}

-(void)closeItemClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)timerCallback {
    if (!self.loading) {
        if (self.progressView.progress >= 1) {
            self.progressView.hidden = true;
            [self.timer invalidate];
        }
        else {
            self.progressView.progress += 0.5;
        }
    }
    else {
        self.progressView.progress += 0.05;
        if (self.progressView.progress >= 0.9) {
            self.progressView.progress = 0.9;
        }
    }
}

- (void)updateHostLabelWithRequest:(NSURLRequest *)request {
    NSString *host = [request.URL host];
    if (host) {
        self.hostInfoLabel.text = [NSString stringWithFormat:@"网页由 %@ 提供", host];
    }
}

#pragma mark - webView delegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    self.progressView.progress = 0;
    self.progressView.hidden = false;
    self.loading = YES;
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
    }
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//    NSLog(@"navigation type %ld",(long)navigationType);
    NSLog(@"url: %@",request.URL);
    [self updateHostLabelWithRequest:request];
    
    switch (navigationType) {
        case UIWebViewNavigationTypeLinkClicked: {
            [self pushCurrentSnapshotViewWithRequest:request];
            break;
        }
        case UIWebViewNavigationTypeFormSubmitted: {
            [self pushCurrentSnapshotViewWithRequest:request];
            break;
        }
        case UIWebViewNavigationTypeBackForward: {
            break;
        }
        case UIWebViewNavigationTypeReload: {
            break;
        }
        case UIWebViewNavigationTypeFormResubmitted: {
            break;
        }
        case UIWebViewNavigationTypeOther: {
            [self pushCurrentSnapshotViewWithRequest:request];
            break;
        }
        default: {
            break;
        }
    }
//    [self updateNavigationItems];
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self updateNavigationItems];
    NSString *theTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (theTitle.length > 10) {
        theTitle = [[theTitle substringToIndex:9] stringByAppendingString:@"…"];
    }
    self.title = theTitle;
    
    self.loading = NO;
    if (self.prevSnapShotView.superview) {
        [self.prevSnapShotView removeFromSuperview];
    }
    [self getArticleList];

    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark - setters and getters

-(UIWebView*)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:(CGRect){0,64,self.view.frame.size.width,self.view.frame.size.height-64}];
        _webView.delegate = (id)self;
        _webView.scalesPageToFit = NO;
        _webView.contentMode = UIViewContentModeScaleAspectFit;
//        _webView.autoresizingMask=(UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleWidth);
        [_webView addGestureRecognizer:self.swipePanGesture];
    }
    return _webView;
}

//-(UIBarButtonItem*)customBackBarItem{
//    if (!_customBackBarItem) {
//        UIImage* backItemImage = [[UIImage imageNamed:@"backItemImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//        UIImage* backItemHlImage = [[UIImage imageNamed:@"backItemImage-hl"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//        
//        UIButton* backButton = [[UIButton alloc] init];
//        [backButton setTitle:@"返回" forState:UIControlStateNormal];
//        [backButton setTitleColor:self.navigationController.navigationBar.tintColor forState:UIControlStateNormal];
//        [backButton setTitleColor:[self.navigationController.navigationBar.tintColor colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
//        [backButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
//        [backButton setImage:backItemImage forState:UIControlStateNormal];
//        [backButton setImage:backItemHlImage forState:UIControlStateHighlighted];
//        [backButton sizeToFit];
//        
//        [backButton addTarget:self action:@selector(customBackItemClicked) forControlEvents:UIControlEventTouchUpInside];
//        _customBackBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    }
//    return _customBackBarItem;
//}

-(UIBarButtonItem*)closeButtonItem{
    if (!_closeButtonItem) {
        _closeButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeItemClicked)];
    }
    return _closeButtonItem;
}

-(UIView*)swipingBackgoundView{
    if (!_swipingBackgoundView) {
        _swipingBackgoundView = [[UIView alloc] initWithFrame:self.view.bounds];
        _swipingBackgoundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }
    return _swipingBackgoundView;
}

-(NSMutableArray*)snapShotsArray{
    if (!_snapShotsArray) {
        _snapShotsArray = [NSMutableArray array];
    }
    return _snapShotsArray;
}

-(BOOL)isSwipingBack{
    if (!_isSwipingBack) {
        _isSwipingBack = NO;
    }
    return _isSwipingBack;
}

-(UIPanGestureRecognizer*)swipePanGesture{
    if (!_swipePanGesture) {
        _swipePanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipePanGestureHandler:)];
    }
    return _swipePanGesture;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        CGRect frame = CGRectMake(0, 64, self.view.frame.size.width, 2.0);
        _progressView = [[UIProgressView alloc] initWithFrame:frame];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth ;
        _progressView.tintColor = self.progressViewColor;
        _progressView.trackTintColor = [UIColor clearColor];
    }
    
    return _progressView;
}

- (UILabel *)hostInfoLabel {
    if (!_hostInfoLabel) {
        _hostInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 20)];
        _hostInfoLabel.textColor = [UIColor grayColor];
        _hostInfoLabel.font = [UIFont systemFontOfSize:11];
        _hostInfoLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _hostInfoLabel;
}

- (void)showTagList:(UIButton *)sender
{
    ArticleListViewController *article = [[ArticleListViewController alloc]init];
    article.articleList = self.articleList;
    article.stitle = self.tagLists[0];
    [self.navigationController pushViewController:article animated:YES];
}

@end
