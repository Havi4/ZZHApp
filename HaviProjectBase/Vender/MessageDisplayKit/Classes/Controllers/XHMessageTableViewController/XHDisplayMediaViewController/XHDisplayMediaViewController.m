//
//  XHDisplayMediaViewController.m
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-5-6.
//  Copyright (c) 2014年 嗨，我是曾宪华(@xhzengAIB)，曾加入YY Inc.担任高级移动开发工程师，拍立秀App联合创始人，热衷于简洁、而富有理性的事物 QQ:543413507 主页:http://zengxianhua.com All rights reserved.
//

#import "XHDisplayMediaViewController.h"
#import <MediaPlayer/MediaPlayer.h>

#import "UIView+XHRemoteImage.h"
#import "XHConfigurationHelper.h"

@interface XHDisplayMediaViewController ()

@property (nonatomic, strong) MPMoviePlayerController *moviePlayerController;
@property (nonatomic, strong) SCBarButtonItem *leftBarItem;

@property (nonatomic, weak) UIImageView *photoImageView;

@end

@implementation XHDisplayMediaViewController

- (MPMoviePlayerController *)moviePlayerController {
    if (!_moviePlayerController) {
        _moviePlayerController = [[MPMoviePlayerController alloc] init];
        _moviePlayerController.repeatMode = MPMovieRepeatModeOne;
        _moviePlayerController.scalingMode = MPMovieScalingModeAspectFill;
        _moviePlayerController.view.frame = self.view.frame;
        [self.view addSubview:_moviePlayerController.view];
    }
    return _moviePlayerController;
}

- (UIImageView *)photoImageView {
    if (!_photoImageView) {
        UIImageView *photoImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
        photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        photoImageView.clipsToBounds = YES;
        [self.view addSubview:photoImageView];
        _photoImageView = photoImageView;
    }
    return _photoImageView;
}

- (void)setMessage:(id<XHMessageModel>)message {
    _message = message;
    if ([message messageMediaType] == XHBubbleMessageMediaTypeVideo) {
        self.title = NSLocalizedStringFromTable(@"Video", @"MessageDisplayKitString", @"详细视频");
        self.moviePlayerController.contentURL = [NSURL fileURLWithPath:[message videoPath]];
        [self.moviePlayerController play];
    } else if ([message messageMediaType] ==XHBubbleMessageMediaTypePhoto) {
//        self.title = NSLocalizedStringFromTable(@"Photo", @"MessageDisplayKitString", @"详细照片");
        
        self.photoImageView.image = message.photo;
        if (message.thumbnailUrl) {
            NSString *placeholderImageName = [[XHConfigurationHelper appearance].messageInputViewStyle objectForKey:kXHMessageTablePlaceholderImageNameKey];
            if (!placeholderImageName) {
                placeholderImageName = @"placeholderImage";
            }
            
            [self.photoImageView setImageWithURL:[NSURL URLWithString:[message thumbnailUrl]] placeholer:[UIImage imageNamed:placeholderImageName]];
        }
    }
}

#pragma mark - Life cycle

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.message messageMediaType] == XHBubbleMessageMediaTypeVideo) {
        [self.moviePlayerController stop];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavigationBar];
}

- (void)initNavigationBar
{
    self.navigationController.navigationBarHidden = YES;
    self.leftBarItem = [[SCBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_navi_back"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.sc_navigationItem.leftBarButtonItem = self.leftBarItem;
    
    self.sc_navigationItem.title = @"预览图片";
    self.view.backgroundColor = [UIColor colorWithRed:0.957 green:0.961 blue:0.965 alpha:1.00];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_moviePlayerController stop];
    _moviePlayerController = nil;
    
    _photoImageView = nil;
}

@end
