//
//  XHDemoWeChatMessageTableViewController.m
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-4-27.
//  Copyright (c) 2014年 嗨，我是曾宪华(@xhzengAIB)，曾加入YY Inc.担任高级移动开发工程师，拍立秀App联合创始人，热衷于简洁、而富有理性的事物 QQ:543413507 主页:http://zengxianhua.com All rights reserved.
//

#import "XHDemoWeChatMessageTableViewController.h"

#import "XHDisplayTextViewController.h"
#import "XHDisplayMediaViewController.h"
#import "XHDisplayLocationViewController.h"

#import "XHAudioPlayerHelper.h"
#import "WTRequestCenter.h"
#import "DoctorInfomationViewController.h"
#import "JTSImageViewController.h"
#import "JTSImageInfo.h"
#import "EvaluationViewController.h"
#import "IMTitleView.h"
//#import "XHContactDetailTableViewController.h"


@interface XHDemoWeChatMessageTableViewController () <XHAudioPlayerHelperDelegate>

@property (nonatomic, strong) NSArray *emotionManagers;

@property (nonatomic, strong) XHMessageTableViewCell *currentSelectedCell;
@property (nonatomic, strong) NSString *docThumUrl;
@property (nonatomic, strong) NSString *docID;
@property (nonatomic, strong) NSString *myThumUrl;
@property (nonatomic, strong) NSString *eduIntro;
@property (nonatomic, strong) SCBarButtonItem *leftBarItem;
@property (nonatomic, strong) SCBarButtonItem *rightBarItem;
@property (nonatomic, strong) IMTitleView *titleView;
@property (nonatomic, strong) NSDictionary *docInfo;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation XHDemoWeChatMessageTableViewController

- (XHMessage *)getTextMessageWithBubbleMessageType:(XHBubbleMessageType)bubbleMessageType withDic:(NSDictionary *)messdic andIconUrl:(NSString *)iconUrl{
    XHMessage *textMessage = [[XHMessage alloc] initWithText:[messdic objectForKey:@"text"] sender:@"华仔" timestamp:[NSDate distantPast]];
    textMessage.avatar = [UIImage imageNamed:@"doc"];
    textMessage.avatarUrl = iconUrl;
    textMessage.bubbleMessageType = bubbleMessageType;
    
    return textMessage;
}

- (XHMessage *)getPhotoMessageWithBubbleMessageType:(XHBubbleMessageType)bubbleMessageType withDic:(NSDictionary *)messdic andIconUrl:(NSString *)iconUrl {
    XHMessage *photoMessage = [[XHMessage alloc] initWithPhoto:nil thumbnailUrl:[messdic objectForKey:@"file"] originPhotoUrl:[messdic objectForKey:@"file"] sender:@"Jack" timestamp:[NSDate date]];
    photoMessage.avatar = [UIImage imageNamed:@"doc"];
    photoMessage.avatarUrl = iconUrl;
    photoMessage.bubbleMessageType = bubbleMessageType;
    
    return photoMessage;
}

- (XHMessage *)getVoiceMessageWithBubbleMessageType:(XHBubbleMessageType)bubbleMessageType withDic:(NSDictionary *)messdic andIconUrl:(NSString *)iconUrl {
    XHMessage *voiceMessage = [[XHMessage alloc] initWithVoicePath:[[NSBundle mainBundle] pathForResource:@"new_noise" ofType:@"mp3"] voiceUrl:[messdic objectForKey:@"file"] voiceDuration:@"1" sender:@"Jayson" timestamp:[NSDate date] isRead:NO];
    voiceMessage.avatar = [UIImage imageNamed:@"doc"];
    voiceMessage.avatarUrl = iconUrl;
    voiceMessage.bubbleMessageType = bubbleMessageType;
    
    return voiceMessage;
}
//######

- (XHMessage *)getTextMessageWithBubbleMessageType:(XHBubbleMessageType)bubbleMessageType {
    XHMessage *textMessage = [[XHMessage alloc] initWithText:@"这是华捷微信，希望大家喜欢这个开源库，请大家帮帮忙支持这个开源库吧！我是Jack，叫华仔也行，曾宪华就是我啦！" sender:@"华仔" timestamp:[NSDate distantPast]];
    textMessage.avatar = [UIImage imageNamed:@"avatar"];
    textMessage.avatarUrl = @"http://childapp.pailixiu.com/jack/meIcon@2x.png";
    textMessage.bubbleMessageType = bubbleMessageType;
    
    return textMessage;
}


- (XHMessage *)getPhotoMessageWithBubbleMessageType:(XHBubbleMessageType)bubbleMessageType {
    XHMessage *photoMessage = [[XHMessage alloc] initWithPhoto:nil thumbnailUrl:@"http://d.hiphotos.baidu.com/image/pic/item/30adcbef76094b361721961da1cc7cd98c109d8b.jpg" originPhotoUrl:nil sender:@"Jack" timestamp:[NSDate date]];
    photoMessage.avatar = [UIImage imageNamed:@"avatar"];
    photoMessage.avatarUrl = @"http://childapp.pailixiu.com/jack/JieIcon@2x.png";
    photoMessage.bubbleMessageType = bubbleMessageType;
    
    return photoMessage;
}

- (XHMessage *)getVideoMessageWithBubbleMessageType:(XHBubbleMessageType)bubbleMessageType {
    NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"IMG_1555.MOV" ofType:@""];
    XHMessage *videoMessage = [[XHMessage alloc] initWithVideoConverPhoto:[XHMessageVideoConverPhotoFactory videoConverPhotoWithVideoPath:videoPath] videoPath:videoPath videoUrl:nil sender:@"Jayson" timestamp:[NSDate date]];
    videoMessage.avatar = [UIImage imageNamed:@"avatar"];
    videoMessage.avatarUrl = @"http://childapp.pailixiu.com/jack/JieIcon@2x.png";
    videoMessage.bubbleMessageType = bubbleMessageType;
    
    return videoMessage;
}

- (XHMessage *)getVoiceMessageWithBubbleMessageType:(XHBubbleMessageType)bubbleMessageType {
    XHMessage *voiceMessage = [[XHMessage alloc] initWithVoicePath:nil voiceUrl:nil voiceDuration:@"1" sender:@"Jayson" timestamp:[NSDate date] isRead:NO];
    voiceMessage.avatar = [UIImage imageNamed:@"avatar"];
    voiceMessage.avatarUrl = @"http://childapp.pailixiu.com/jack/JieIcon@2x.png";
    voiceMessage.bubbleMessageType = bubbleMessageType;
    
    return voiceMessage;
}

- (XHMessage *)getEmotionMessageWithBubbleMessageType:(XHBubbleMessageType)bubbleMessageType {
    XHMessage *emotionMessage = [[XHMessage alloc] initWithEmotionPath:[[NSBundle mainBundle] pathForResource:@"emotion1.gif" ofType:nil] sender:@"Jayson" timestamp:[NSDate date]];
    emotionMessage.avatar = [UIImage imageNamed:@"avatar"];
    emotionMessage.avatarUrl = @"http://childapp.pailixiu.com/jack/JieIcon@2x.png";
    emotionMessage.bubbleMessageType = bubbleMessageType;
    
    return emotionMessage;
}

- (XHMessage *)getGeolocationsMessageWithBubbleMessageType:(XHBubbleMessageType)bubbleMessageType {
    XHMessage *localPositionMessage = [[XHMessage alloc] initWithLocalPositionPhoto:[UIImage imageNamed:@"Fav_Cell_Loc"] geolocations:@"中国广东省广州市天河区东圃二马路121号" location:[[CLLocation alloc] initWithLatitude:23.110387 longitude:113.399444] sender:@"Jack" timestamp:[NSDate date]];
    localPositionMessage.avatar = [UIImage imageNamed:@"avatar"];
    localPositionMessage.avatarUrl = @"http://childapp.pailixiu.com/jack/meIcon@2x.png";
    localPositionMessage.bubbleMessageType = bubbleMessageType;
    
    return localPositionMessage;
}

- (NSMutableArray *)getTestMessages {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@/%@/",docDir,@"messageList"];
    NSString *txtPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",self.problemID]];
    NSFileManager *verfileManager = [[NSFileManager alloc]init];
    if (![verfileManager fileExistsAtPath:txtPath]) {
        return nil;
    }
    NSData *data = [NSData dataWithContentsOfFile:txtPath];
    NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    DeBugLog(@"问题列表是%@",arr);
    NSMutableArray *messages = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < arr.count; i ++) {
        if ([[[arr objectAtIndex:i] objectForKey:@"type"] isEqualToString:@"d"]) {
            NSString *contentString = [[arr objectAtIndex:i] objectForKey:@"content"];
            NSData *data = [contentString dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            for (NSDictionary *contentDic in dic) {
                if ([[contentDic objectForKey:@"type"]isEqualToString:@"text"]) {
                    [messages addObject:[self getTextMessageWithBubbleMessageType:XHBubbleMessageTypeReceiving withDic:contentDic andIconUrl:self.docThumUrl]];
                }else if ([[contentDic objectForKey:@"type"]isEqualToString:@"image"]) {
                    [messages addObject:[self getPhotoMessageWithBubbleMessageType:XHBubbleMessageTypeReceiving withDic:contentDic andIconUrl:self.docThumUrl]];
                }else if ([[contentDic objectForKey:@"type"]isEqualToString:@"audio"]) {
                    [messages addObject:[self getVoiceMessageWithBubbleMessageType:XHBubbleMessageTypeReceiving withDic:contentDic andIconUrl:self.docThumUrl]];
                }
            }
        }else if ([[[arr objectAtIndex:i] objectForKey:@"type"] isEqualToString:@"p"]){
            NSString *contentString = [[arr objectAtIndex:i] objectForKey:@"content"];
            NSData *data = [contentString dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            for (NSDictionary *contentDic in dic) {
                if ([[contentDic objectForKey:@"type"]isEqualToString:@"text"]) {
                    [messages addObject:[self getTextMessageWithBubbleMessageType:XHBubbleMessageTypeSending withDic:contentDic andIconUrl:self.myThumUrl]];
                }else if ([[contentDic objectForKey:@"type"]isEqualToString:@"image"]) {
                    [messages addObject:[self getPhotoMessageWithBubbleMessageType:XHBubbleMessageTypeSending withDic:contentDic andIconUrl:self.myThumUrl]];
                }else if ([[contentDic objectForKey:@"type"]isEqualToString:@"audio"]) {
                    [messages addObject:[self getVoiceMessageWithBubbleMessageType:XHBubbleMessageTypeSending withDic:contentDic andIconUrl:self.myThumUrl]];
                }
            }
        }
    }
    return messages;
}

- (void)loadDemoDataSource {
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *messages = [weakSelf getTestMessages];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.messages = messages;
            [weakSelf.messageTableView reloadData];
            
            [weakSelf scrollToBottomAnimated:NO];
        });
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[XHAudioPlayerHelper shareInstance] stopAudio];
}

- (id)init {
    self = [super init];
    if (self) {
        // 配置输入框UI的样式
//        self.allowsSendVoice = NO;
//        self.allowsSendFace = NO;
//        self.allowsSendMultiMedia = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (CURRENT_SYS_VERSION >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delaysTouchesBegan=NO;
    }
    self.title = NSLocalizedStringFromTable(@"Chat", @"MessageDisplayKitString", @"聊天");
    
    // Custom UI
//    [self setBackgroundColor:[UIColor clearColor]];
//    [self setBackgroundImage:[UIImage imageNamed:@"TableViewBackgroundImage"]];
    
    // 设置自身用户名
    self.messageSender = @"Jack";
    self.myThumUrl = [NSString stringWithFormat:@"%@%@%@",kAppBaseURL,@"v1/file/DownloadFile/",thirdPartyLoginUserId];
    
    // 添加第三方接入数据
    NSMutableArray *shareMenuItems = [NSMutableArray array];
    NSArray *plugIcons = @[@"sharemore_pic", @"sharemore_video"];
    NSArray *plugTitle = @[@"照片", @"拍摄"];
    for (NSString *plugIcon in plugIcons) {
        XHShareMenuItem *shareMenuItem = [[XHShareMenuItem alloc] initWithNormalIconImage:[UIImage imageNamed:plugIcon] title:[plugTitle objectAtIndex:[plugIcons indexOfObject:plugIcon]]];
        [shareMenuItems addObject:shareMenuItem];
    }
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self action:@selector(getContentMessage) forControlEvents:UIControlEventValueChanged];
    [self.messageTableView addSubview:self.refreshControl];
    NSMutableArray *emotionManagers = [NSMutableArray array];
    for (NSInteger i = 0; i < 10; i ++) {
        XHEmotionManager *emotionManager = [[XHEmotionManager alloc] init];
        emotionManager.emotionName = [NSString stringWithFormat:@"表情%ld", (long)i];
        NSMutableArray *emotions = [NSMutableArray array];
        for (NSInteger j = 0; j < 18; j ++) {
            XHEmotion *emotion = [[XHEmotion alloc] init];
            NSString *imageName = [NSString stringWithFormat:@"section%ld_emotion%ld", (long)i , (long)j % 16];
            emotion.emotionPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"emotion%ld.gif", (long)j] ofType:@""];
            emotion.emotionConverPhoto = [UIImage imageNamed:imageName];
            [emotions addObject:emotion];
        }
        emotionManager.emotions = emotions;
        
        [emotionManagers addObject:emotionManager];
    }
    
    self.emotionManagers = emotionManagers;
    [self.emotionManagerView reloadData];
    
    self.shareMenuItems = shareMenuItems;
    [self.shareMenuView reloadData];
    
    [self loadDemoDataSource];
    [self getContentMessage];
    [self initNavigationBar];
}

- (void)initNavigationBar
{
    self.navigationController.navigationBarHidden = YES;
    self.leftBarItem = [[SCBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_navi_back"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.sc_navigationItem.leftBarButtonItem = self.leftBarItem;
    
    self.sc_navigationItem.title = @"问题详情";
    self.view.backgroundColor = [UIColor colorWithRed:0.957 green:0.961 blue:0.965 alpha:1.00];
}


- (void)getContentMessage
{
    NSString *url = @"http://testzzhapi.meddo99.com:8088/v1/cy/Problem/Detail";
    NSDictionary *dicPara = @{
                              @"UserId": @"meddo99.com$13122785292",
                              @"ProblemId":self.problemID,
                              };
    [WTRequestCenter postWithURL:url header:@{@"AccessToken":@"123456789",@"Content-Type":@"application/json"} parameters:dicPara finished:^(NSURLResponse *response, NSData *data) {
            [self.refreshControl endRefreshing];
            NSDictionary *obj = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([obj objectForKey:@"Result"]) {
            
            NSArray *probleList = [[obj objectForKey:@"Result"] objectForKey:@"content"];
            self.docThumUrl =  [[[obj objectForKey:@"Result"] objectForKey:@"doctor"] objectForKey:@"image"];
            self.docID = [[[obj objectForKey:@"Result"] objectForKey:@"doctor"] objectForKey:@"id"];
            self.eduIntro = [[[obj objectForKey:@"Result"] objectForKey:@"doctor"] objectForKey:@"education_background"];
            if ([[[obj objectForKey:@"Result"] objectForKey:@"need_assess"] intValue]==1) {
                [self addAssementButtonWith:[[[obj objectForKey:@"Result"] objectForKey:@"problem"] objectForKey:@"id"]];
            }
            self.docInfo = [[obj objectForKey:@"Result"] objectForKey:@"doctor"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self createMessageFile:probleList];
            });
        }
                }
    failed:^(NSURLResponse *response, NSError *error) {
        [self.refreshControl endRefreshing];
    }];
}

- (void)addAssementButtonWith:(NSString *)problemID
{
    self.rightBarItem = [[SCBarButtonItem alloc] initWithTitle:@"评价" style:SCBarButtonItemStylePlain withColor:[UIColor colorWithRed:0.157 green:0.659 blue:0.902 alpha:1.00] handler:^(id sender) {
        EvaluationViewController *evaluation = [[EvaluationViewController alloc]init];
        evaluation.problemID = problemID;
        [self.navigationController pushViewController:evaluation animated:YES];

    }];
    
    self.sc_navigationItem.rightBarButtonItem = self.rightBarItem;
}

- (void)createMessageFile:(NSArray *)messageData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);;
    NSString *docDir = [paths objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@/%@/",docDir,@"messageList"];
    NSString *txtPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",self.problemID]];
    NSData * Data =[NSKeyedArchiver archivedDataWithRootObject:messageData];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:txtPath]) {
        [fileManager createFileAtPath:txtPath contents:nil attributes:nil];
    }
    
    NSError *error;
    BOOL isDone = [Data writeToFile:txtPath options:NSDataWritingAtomic error:&error];
    if (isDone) {
        [self loadDemoDataSource];
        DeBugLog(@"文件写入成功");
    }else{
        WEAKSELF
        NSMutableArray *messages = [weakSelf getTestMessagesWithArr:messageData];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.messages = [NSMutableArray arrayWithArray:messages];
                [weakSelf.messageTableView reloadData];
                
                [weakSelf scrollToBottomAnimated:NO];
            });
        });
        DeBugLog(@"错误是%@",error);
    }
}

- (NSMutableArray *)getTestMessagesWithArr:(NSArray *)message {
    NSMutableArray *messages = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < message.count; i ++) {
        if ([[[message objectAtIndex:i] objectForKey:@"type"] isEqualToString:@"d"]) {
            NSString *contentString = [[message objectAtIndex:i] objectForKey:@"content"];
            NSData *data = [contentString dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            for (NSDictionary *contentDic in dic) {
                if ([[contentDic objectForKey:@"type"]isEqualToString:@"text"]) {
                    [messages addObject:[self getTextMessageWithBubbleMessageType:XHBubbleMessageTypeReceiving withDic:contentDic andIconUrl:self.docThumUrl]];
                }else if ([[contentDic objectForKey:@"type"]isEqualToString:@"image"]) {
                    [messages addObject:[self getPhotoMessageWithBubbleMessageType:XHBubbleMessageTypeReceiving withDic:contentDic andIconUrl:self.docThumUrl]];
                }else if ([[contentDic objectForKey:@"type"]isEqualToString:@"audio"]) {
                    [messages addObject:[self getVoiceMessageWithBubbleMessageType:XHBubbleMessageTypeReceiving withDic:contentDic andIconUrl:self.docThumUrl]];
                }
            }
        }else if ([[[message objectAtIndex:i] objectForKey:@"type"] isEqualToString:@"p"]){
            NSString *contentString = [[message objectAtIndex:i] objectForKey:@"content"];
            NSData *data = [contentString dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            for (NSDictionary *contentDic in dic) {
                if ([[contentDic objectForKey:@"type"]isEqualToString:@"text"]) {
                    [messages addObject:[self getTextMessageWithBubbleMessageType:XHBubbleMessageTypeSending withDic:contentDic andIconUrl:self.myThumUrl]];
                }else if ([[contentDic objectForKey:@"type"]isEqualToString:@"image"]) {
                    [messages addObject:[self getPhotoMessageWithBubbleMessageType:XHBubbleMessageTypeSending withDic:contentDic andIconUrl:self.myThumUrl]];
                }else if ([[contentDic objectForKey:@"type"]isEqualToString:@"audio"]) {
                    [messages addObject:[self getVoiceMessageWithBubbleMessageType:XHBubbleMessageTypeSending withDic:contentDic andIconUrl:self.myThumUrl]];
                }
            }
        }
    }
    return messages;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.emotionManagers = nil;
    [[XHAudioPlayerHelper shareInstance] setDelegate:nil];
}

/*
 [self removeMessageAtIndexPath:indexPath];
 [self insertOldMessages:self.messages];
 */

#pragma mark - XHMessageTableViewCell delegate

- (void)multiMediaMessageDidSelectedOnMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath onMessageTableViewCell:(XHMessageTableViewCell *)messageTableViewCell {
    UIViewController *disPlayViewController;
    switch (message.messageMediaType) {
        case XHBubbleMessageMediaTypeVideo:
        case XHBubbleMessageMediaTypePhoto: {
            DLog(@"message : %@", message.photo);
            DLog(@"message : %@", message.videoConverPhoto);
            JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
            if (message.originPhotoUrl) {
                
                imageInfo.imageURL = [NSURL URLWithString:message.originPhotoUrl];
            }else if (message.photo){
                imageInfo.image = message.photo;
            }
            imageInfo.referenceRect = self.view.frame;
            imageInfo.referenceView = self.view;
            
            // Setup view controller
            JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                                   initWithImageInfo:imageInfo
                                                   mode:JTSImageViewControllerMode_Image
                                                   backgroundStyle:JTSImageViewControllerBackgroundOption_Blurred];
            
            // Present the view controller.
            [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
            break;
        }
            break;
        case XHBubbleMessageMediaTypeVoice: {
            DLog(@"message : %@", message.voicePath);
            
            // Mark the voice as read and hide the red dot.
            message.isRead = YES;
            messageTableViewCell.messageBubbleView.voiceUnreadDotImageView.hidden = YES;
            
            [[XHAudioPlayerHelper shareInstance] setDelegate:(id<NSFileManagerDelegate>)self];
            if (_currentSelectedCell) {
                [_currentSelectedCell.messageBubbleView.animationVoiceImageView stopAnimating];
            }
            if (_currentSelectedCell == messageTableViewCell) {
                [messageTableViewCell.messageBubbleView.animationVoiceImageView stopAnimating];
                [[XHAudioPlayerHelper shareInstance] stopAudio];
                self.currentSelectedCell = nil;
            } else {
                self.currentSelectedCell = messageTableViewCell;
                [messageTableViewCell.messageBubbleView.animationVoiceImageView startAnimating];
                if (message.voiceUrl) {
                    [[XHAudioPlayerHelper shareInstance] managerAudioWithFileName:message.voiceUrl toPlay:YES];
                }else{
                    [[XHAudioPlayerHelper shareInstance] managerAudioWithFileName:message.voicePath toPlay:YES];
                }
            }
            
            break;
        }
        case XHBubbleMessageMediaTypeEmotion:
            DLog(@"facePath : %@", message.emotionPath);
            break;
        case XHBubbleMessageMediaTypeLocalPosition: {
            DLog(@"facePath : %@", message.localPositionPhoto);
            XHDisplayLocationViewController *displayLocationViewController = [[XHDisplayLocationViewController alloc] init];
            displayLocationViewController.message = message;
            disPlayViewController = displayLocationViewController;
            break;
        }
        default:
            break;
    }
    if (disPlayViewController) {
        [self.navigationController pushViewController:disPlayViewController animated:YES];
    }
}


- (void)didDoubleSelectedOnTextMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath {
    DLog(@"text : %@", message.text);
//    XHDisplayTextViewController *displayTextViewController = [[XHDisplayTextViewController alloc] init];
//    displayTextViewController.message = message;
//    [self.navigationController pushViewController:displayTextViewController animated:YES];
}

- (void)didSelectedAvatarOnMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath {
    DLog(@"indexPath : %@", indexPath);
    if ([message bubbleMessageType] == XHBubbleMessageTypeReceiving) {
        DoctorInfomationViewController *doc = [[DoctorInfomationViewController alloc]init];
        doc.docID = self.docID;
        doc.eduIntroduction = self.eduIntro;
        [self.navigationController pushViewController:doc animated:YES];
    }
//
}

- (void)menuDidSelectedAtBubbleMessageMenuSelecteType:(XHBubbleMessageMenuSelecteType)bubbleMessageMenuSelecteType {
    
}

#pragma mark - XHAudioPlayerHelper Delegate

- (void)didAudioPlayerStopPlay:(AVAudioPlayer *)audioPlayer {
    if (!_currentSelectedCell) {
        return;
    }
    [_currentSelectedCell.messageBubbleView.animationVoiceImageView stopAnimating];
    self.currentSelectedCell = nil;
}

#pragma mark - XHEmotionManagerView DataSource

- (NSInteger)numberOfEmotionManagers {
    return self.emotionManagers.count;
}

- (XHEmotionManager *)emotionManagerForColumn:(NSInteger)column {
    return [self.emotionManagers objectAtIndex:column];
}

- (NSArray *)emotionManagersAtManager {
    return self.emotionManagers;
}

#pragma mark - XHMessageTableViewController Delegate

- (BOOL)shouldLoadMoreMessagesScrollToTop {
    return NO;
}

- (void)loadMoreMessagesScrollTotop {
    if (!self.loadingMoreMessage) {
        self.loadingMoreMessage = YES;
        
        WEAKSELF
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableArray *messages = [weakSelf getTestMessages];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf insertOldMessages:messages];
                weakSelf.loadingMoreMessage = NO;
            });
        });
    }
}

/**
 *  发送文本消息的回调方法
 *
 *  @param text   目标文本字符串
 *  @param sender 发送者的名字
 *  @param date   发送时间
 */
- (void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date {
    XHMessage *textMessage = [[XHMessage alloc] initWithText:text sender:sender timestamp:date];
    textMessage.avatar = [UIImage imageNamed:@"Avatar"];
    textMessage.avatarUrl = self.myThumUrl;
    [self addMessage:textMessage];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeText];
    [self sendImessageWith:text];
}

/**
 *  发送图片消息的回调方法
 *
 *  @param photo  目标图片对象，后续有可能会换
 *  @param sender 发送者的名字
 *  @param date   发送时间
 */
- (void)didSendPhoto:(UIImage *)photo fromSender:(NSString *)sender onDate:(NSDate *)date {
    XHMessage *photoMessage = [[XHMessage alloc] initWithPhoto:photo thumbnailUrl:nil originPhotoUrl:nil sender:sender timestamp:date];
    photoMessage.avatar = [UIImage imageNamed:@"avatar"];
    photoMessage.avatarUrl = self.myThumUrl;
    [self addMessage:photoMessage];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypePhoto];
    [self upDateIcon:@{@"image":photo}];
}

/**
 *  发送视频消息的回调方法
 *
 *  @param videoPath 目标视频本地路径
 *  @param sender    发送者的名字
 *  @param date      发送时间
 */
- (void)didSendVideoConverPhoto:(UIImage *)videoConverPhoto videoPath:(NSString *)videoPath fromSender:(NSString *)sender onDate:(NSDate *)date {
    XHMessage *videoMessage = [[XHMessage alloc] initWithVideoConverPhoto:videoConverPhoto videoPath:videoPath videoUrl:nil sender:sender timestamp:date];
    videoMessage.avatar = [UIImage imageNamed:@"avatar"];
    videoMessage.avatarUrl = @"http://childapp.pailixiu.com/jack/meIcon@2x.png";
    [self addMessage:videoMessage];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeVideo];
}

/**
 *  发送语音消息的回调方法
 *
 *  @param voicePath        目标语音本地路径
 *  @param voiceDuration    目标语音时长
 *  @param sender           发送者的名字
 *  @param date             发送时间
 */
- (void)didSendVoice:(NSString *)voicePath voiceDuration:(NSString *)voiceDuration fromSender:(NSString *)sender onDate:(NSDate *)date {
    XHMessage *voiceMessage = [[XHMessage alloc] initWithVoicePath:voicePath voiceUrl:nil voiceDuration:voiceDuration sender:sender timestamp:date];
    voiceMessage.avatar = [UIImage imageNamed:@"avatar"];
    voiceMessage.avatarUrl = self.myThumUrl;
    [self addMessage:voiceMessage];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeVoice];
    NSData *voiceData = [NSData dataWithContentsOfFile:voicePath];
    DeBugLog(@"音频路径是%@",voiceData);
    [self uploadWithImageData:voiceData withType:@"audio"];
}

/**
 *  发送第三方表情消息的回调方法
 *
 *  @param facePath 目标第三方表情的本地路径
 *  @param sender   发送者的名字
 *  @param date     发送时间
 */
- (void)didSendEmotion:(NSString *)emotionPath fromSender:(NSString *)sender onDate:(NSDate *)date {
    XHMessage *emotionMessage = [[XHMessage alloc] initWithEmotionPath:emotionPath sender:sender timestamp:date];
    emotionMessage.avatar = [UIImage imageNamed:@"avatar"];
    emotionMessage.avatarUrl = @"http://childapp.pailixiu.com/jack/meIcon@2x.png";
    [self addMessage:emotionMessage];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeEmotion];
}

/**
 *  有些网友说需要发送地理位置，这个我暂时放一放
 */
- (void)didSendGeoLocationsPhoto:(UIImage *)geoLocationsPhoto geolocations:(NSString *)geolocations location:(CLLocation *)location fromSender:(NSString *)sender onDate:(NSDate *)date {
    XHMessage *geoLocationsMessage = [[XHMessage alloc] initWithLocalPositionPhoto:geoLocationsPhoto geolocations:geolocations location:location sender:sender timestamp:date];
    geoLocationsMessage.avatar = [UIImage imageNamed:@"avatar"];
    geoLocationsMessage.avatarUrl = @"http://childapp.pailixiu.com/jack/meIcon@2x.png";
    [self addMessage:geoLocationsMessage];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeLocalPosition];
}

/**
 *  是否显示时间轴Label的回调方法
 *
 *  @param indexPath 目标消息的位置IndexPath
 *
 *  @return 根据indexPath获取消息的Model的对象，从而判断返回YES or NO来控制是否显示时间轴Label
 */
- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2) {
        return YES;
    } else {
        return NO;
    }
}

/**
 *  配置Cell的样式或者字体
 *
 *  @param cell      目标Cell
 *  @param indexPath 目标Cell所在位置IndexPath
 */
- (void)configureCell:(XHMessageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {

}

/**
 *  协议回掉是否支持用户手动滚动
 *
 *  @return 返回YES or NO
 */
- (BOOL)shouldPreventScrollToBottomWhileUserScrolling {
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.docInfo) {
        return 60;
    }else{
        return 0.001;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.docInfo) {
        return self.titleView;
    }else{
        return nil;
    }

}

- (IMTitleView *)titleView
{
    if (!_titleView) {
        _titleView = [[IMTitleView alloc]init];
        _titleView.frame = (CGRect){0,0,self.view.frame.size.width,60};
        [_titleView configTitleView:self.docInfo];
        _titleView.backgroundColor = [UIColor whiteColor];
        _titleView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showDocInfo)];
        [_titleView addGestureRecognizer:tap];
    }
    return _titleView;
}

- (void)showDocInfo
{
    DoctorInfomationViewController *doc = [[DoctorInfomationViewController alloc]init];
    doc.docID = self.docID;
    doc.eduIntroduction = self.eduIntro;
    [self.navigationController pushViewController:doc animated:YES];
}

- (void)sendImessageWith:(NSString *)text
{
    NSString *url = @"http://testzzhapi.meddo99.com:8088/v1/cy/ProblemContent/Create";
    NSDictionary *textPloblem = @{
                                  @"type": @"text",
                                  @"text": text,
                                  };
    NSDictionary *dicPara = @{
                              @"UserId": @"meddo99.com$13122785292",
                              @"Content": @[textPloblem],
                              @"ProblemId":self.problemID
                              };
    [WTRequestCenter postWithURL:url header:@{@"AccessToken":@"123456789",@"Content-Type":@"application/json"} parameters:dicPara finished:^(NSURLResponse *response, NSData *data) {
        NSDictionary *obj = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([[[obj objectForKey:@"Result"] objectForKey:@"error"] intValue]==0) {
            [NSObject showHudTipStr:@"提交成功"];
        }else if ([[[obj objectForKey:@"Result"] objectForKey:@"error"] intValue]==1){
            [NSObject showHudTipStr:[[obj objectForKey:@"Result"] objectForKey:@"error_msg"]];
        }
    } failed:^(NSURLResponse *response, NSError *error) {
        [NSObject showHudTipStr:@"提交失败"];
    }];
}

- (void)upDateIcon:(id)op
{
    NSDictionary *dic = (NSDictionary*)op;
    NSData *imageData = [self calculateIconImage:[dic objectForKey:@"image"]];
    if (imageData) {
        [self uploadWithImageData:imageData withType:@"image"];
    }
}

#define UploadImageSize          100000
- (NSData *)calculateIconImage:(UIImage *)image
{
    if(image){
        
        [image fixOrientation];
        CGFloat height = image.size.height;
        CGFloat width = image.size.width;
        NSData *data = UIImageJPEGRepresentation(image,1);
        
        float n;
        n = (float)UploadImageSize/data.length;
        data = UIImageJPEGRepresentation(image, n);
        while (data.length > UploadImageSize) {
            image = [UIImage imageWithData:data];
            height /= 2;
            width /= 2;
            image = [image scaleToSize:CGSizeMake(width, height)];
            data = UIImageJPEGRepresentation(image,1);
        }
        return data;
        
    }
    return nil;
}


- (void)uploadWithImageData:(NSData*)imageData withType:(NSString *)type
{
    NSDictionary *dicHeader = @{
                                @"AccessToken": @"123456789",
                                };
    NSString *urlStr = [NSString stringWithFormat:@"%@/v1/cy/CyUploadFile/%@",kAppTestBaseURL,thirdPartyLoginUserId];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:0 timeoutInterval:5.0f];
    [request setValue:[dicHeader objectForKey:@"AccessToken"] forHTTPHeaderField:@"AccessToken"];
    [self setRequest:request withImageData:imageData];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([[dic objectForKey:@"ReturnCode"] intValue]==200) {
            if ([type isEqualToString:@"image"]) {
                [self sendImageWith:[dic objectForKey:@"FileUrl"]];
            }else{
                [self sendAudioWith:[dic objectForKey:@"FileUrl"]];
            }
            DeBugLog(@"问题追问的url,%@",[dic objectForKey:@"FileUrl"]);
        }
    }];
}

- (void)setRequest:(NSMutableURLRequest *)request withImageData:(NSData*)imageData
{
    NSMutableData *body = [NSMutableData data];
    // 表单数据
    
    /// 图片数据部分
    NSMutableString *topStr = [NSMutableString string];
    [body appendData:[topStr dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:imageData];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    // 设置请求类型为post请求
    request.HTTPMethod = @"post";
    // 设置request的请求体
    request.HTTPBody = body;
    // 设置头部数据，标明上传数据总大小，用于服务器接收校验
    [request setValue:[NSString stringWithFormat:@"%ld", body.length] forHTTPHeaderField:@"Content-Length"];
    // 设置头部数据，指定了http post请求的编码方式为multipart/form-data（上传文件必须用这个）。
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; image/png"] forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; audio/amr"] forHTTPHeaderField:@"Content-Type"];
}

- (void)sendImageWith:(NSString *)text
{
    NSString *url = @"http://testzzhapi.meddo99.com:8088/v1/cy/ProblemContent/Create";
    NSDictionary *textPloblem = @{
                                  @"type": @"image",
                                  @"file": text,
                                  };
    NSDictionary *dicPara = @{
                              @"UserId": @"meddo99.com$13122785292",
                              @"Content": @[textPloblem],
                              @"ProblemId":self.problemID
                              };
    [WTRequestCenter postWithURL:url header:@{@"AccessToken":@"123456789",@"Content-Type":@"application/json"} parameters:dicPara finished:^(NSURLResponse *response, NSData *data) {
        NSDictionary *obj = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([[[obj objectForKey:@"Result"] objectForKey:@"error"] intValue]==0) {
            [NSObject showHudTipStr:@"提交成功"];
            
        }else if ([[[obj objectForKey:@"Result"] objectForKey:@"error"] intValue]==1){
            [NSObject showHudTipStr:[[obj objectForKey:@"Result"] objectForKey:@"error_msg"]];
        }
    } failed:^(NSURLResponse *response, NSError *error) {
        [NSObject showHudTipStr:@"提交失败"];
    }];
}

- (void)sendAudioWith:(NSString *)text
{
    NSString *url = @"http://testzzhapi.meddo99.com:8088/v1/cy/ProblemContent/Create";
    NSDictionary *textPloblem = @{
                                  @"type": @"audio",
                                  @"file": text,
                                  };
    NSDictionary *dicPara = @{
                              @"UserId": @"meddo99.com$13122785292",
                              @"Content": @[textPloblem],
                              @"ProblemId":self.problemID
                              };
    [WTRequestCenter postWithURL:url header:@{@"AccessToken":@"123456789",@"Content-Type":@"application/json"} parameters:dicPara finished:^(NSURLResponse *response, NSData *data) {
        NSDictionary *obj = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([[[obj objectForKey:@"Result"] objectForKey:@"error"] intValue]==0) {
            [NSObject showHudTipStr:@"提交成功"];
            
        }else if ([[[obj objectForKey:@"Result"] objectForKey:@"error"] intValue]==1){
            [NSObject showHudTipStr:[[obj objectForKey:@"Result"] objectForKey:@"error_msg"]];
        }
    } failed:^(NSURLResponse *response, NSError *error) {
        [NSObject showHudTipStr:@"提交失败"];
    }];
}



@end
