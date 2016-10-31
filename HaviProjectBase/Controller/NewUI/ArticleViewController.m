//
//  ArticleViewController.m
//  HaviProjectBase
//
//  Created by Havi on 16/9/12.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "ArticleViewController.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "WTRequestCenter.h"

@interface ArticleViewController ()<UIWebViewDelegate, NJKWebViewProgressDelegate>

{
    UIWebView *_webView;
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;

}
@property (nonatomic, strong) SCBarButtonItem *rightBarItem;

@property (nonatomic, strong) SCBarButtonItem *leftBarItem;

@end

@implementation ArticleViewController

- (void)viewDidLoad {
    [self initNavigationBar];
    [super viewDidLoad];
    _webView = [[UIWebView alloc]init];
    _webView.frame = (CGRect){0,64,self.view.frame.size.width,self.view.size.height-64};
    [self.view addSubview:_webView];
    // Do any additional setup after loading the view.
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.sc_navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self loadGoogle];
}

- (void)initNavigationBar
{
    self.leftBarItem = [[SCBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_navi_back"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.sc_navigationItem.leftBarButtonItem = self.leftBarItem;
    if (self.isShowCollectionButton && !self.isCollection) {
        self.rightBarItem = [[SCBarButtonItem alloc]initWithTitle:@"收藏" style:SCBarButtonItemStylePlain withColor:[UIColor whiteColor] handler:^(id sender) {
            [self collectionView];
        }];
        self.sc_navigationItem.rightBarButtonItem = self.rightBarItem;
    }
    self.sc_navigationItem.title = self.articleTitle;
}

- (void)collectionView
{
    NSString *url = [NSString stringWithFormat:@"%@v1/news/AddCollection", kAppBaseURL];
    
    NSDictionary *dicPara = @{
                              @"UserId": thirdPartyLoginUserId,
                              @"ArticleId": self.articleID,
                              };
    
    [WTRequestCenter postWithURL:url header:@{@"AccessToken":accessTocken,@"Content-Type":@"application/json"} parameters:dicPara finished:^(NSURLResponse *response, NSData *data) {
        NSDictionary *obj = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([[obj objectForKey:@"ReturnCode"] intValue]==200) {
            [NSObject showHudTipStr:@"收藏成功"];
        }else {
            if ([[obj objectForKey:@"ReturnCode"] intValue]==10039){
                [NSObject showHudTipStr:@"该文章已收藏"];
            }else{
                [NSObject showHudTipStr:[[obj objectForKey:@"Result"] objectForKey:@"error_msg"]];
            }
        }
    } failed:^(NSURLResponse *response, NSError *error) {
        [NSObject showHudTipStr:[NSString stringWithFormat:@"%@",error]];
    }];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.sc_navigationBar addSubview:_progressView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [_progressView removeFromSuperview];
}

-(void)loadGoogle
{
//    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.articleURL]];
//    NSString *url = [NSString stringWithFormat:@"%@",self.articleURL];
    NSString * htmlstr = [[NSString alloc]initWithContentsOfURL:[NSURL URLWithString:self.articleURL] encoding:NSUTF8StringEncoding error:nil];
//    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [_webView loadHTMLString:htmlstr baseURL:[NSURL URLWithString:self.articleURL]];
//    [_webView loadRequest:req];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}


@end
