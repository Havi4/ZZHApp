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
@interface ArticleViewController ()<UIWebViewDelegate, NJKWebViewProgressDelegate>

{
    UIWebView *_webView;
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;

}
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
    
    self.sc_navigationItem.title = self.articleTitle;
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
    NSString *url = [NSString stringWithFormat:@"%@",self.articleURL];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [_webView loadRequest:req];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}


@end
