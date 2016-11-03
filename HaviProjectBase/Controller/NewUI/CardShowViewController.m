//
//  CardShowViewController.m
//  HaviProjectBase
//
//  Created by HaviLee on 2016/11/3.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "CardShowViewController.h"
#import "LZSwipeableView.h"
#import "AVCardInfo.h"
#import "AVSwipeCardCell.h"
#import "AVKnackBottomToolView.h"
#import "WTRequestCenter.h"

@interface CardShowViewController ()<LZSwipeableViewDataSource,
LZSwipeableViewDelegate,AVKnackBottomToolViewDelegate>

@property (nonatomic, strong) SCBarButtonItem *leftBarItem;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) LZSwipeableView *swipeableView;
@property (nonatomic, strong) LZSwipeableViewCell *topCell;
@property (nonatomic, strong) NSMutableArray *cardInfoList;
@property (nonatomic, strong) UIView *buttonBackView;
@property (nonatomic, assign) int pageNum;

@end

@implementation CardShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageNum = 0;
    self.backgroundImageView.image = [UIImage imageNamed:@""];
    self.view.backgroundColor = [UIColor colorWithRed:0.588 green:0.588 blue:0.588 alpha:1.00];
    [self initNavigationBar];
    [self.view addSubview:self.swipeableView];
    self.swipeableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.swipeableView registerClass:[AVSwipeCardCell class] forCellReuseIdentifier:NSStringFromClass([AVSwipeCardCell class])];
    
    self.swipeableView.bottomCardInsetHorizontalMargin = 15;
    self.swipeableView.bottomCardInsetVerticalMargin = 0.1;
    /*
    for (int i = 0; i < 100; i++) {
        AVCardInfo *info = [[AVCardInfo alloc] init];
        info.feed_id = 123145;
        info.title = [NSString stringWithFormat:@"测试%zd",i];
        info.summary = [NSString stringWithFormat:@"测试desc%zd",i];
        info.fav_count = arc4random_uniform(100);
        info.is_fav = arc4random_uniform(1);
        [self.cardInfoList addObject:info];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.swipeableView.hidden = NO;
        [self.swipeableView reloadData];
    });
     */
    self.swipeableView.hidden = NO;
    [self setButtonView];
    [self loadData];
}

- (void)loadData
{
    NSString *url = [NSString stringWithFormat:@"%@v1/news/SleepCognition?pageNum=%d&count=20&UserID=%@", kAppTestBaseURL,self.pageNum,thirdPartyLoginUserId];
    [WTRequestCenter getWithURL:url headers:@{@"AccessToken":kTestAccessTocken,@"Content-Type":@"application/json"} parameters:nil option:WTRequestCenterCachePolicyNormal finished:^(NSURLResponse *response, NSData *data) {
        NSDictionary *obj = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *arr = [obj objectForKey:@"SleepCognitionList"];
        for (NSDictionary *question in arr) {
            
            NSArray *answer = [question objectForKey:@"Answers"];
            for (NSDictionary *answerDic in answer) {
                NSDictionary *newQAndA = @{
                                         @"Question":[question objectForKey:@"Question"],
                                         @"Answers":answerDic
                                         };
                [self.cardInfoList addObject:newQAndA];
                DeBugLog(@"问题是%@",self.cardInfoList);
            }
        }
        [self.swipeableView reloadData];
        
    } failed:^(NSURLResponse *response, NSError *error) {
    }];
}

- (void)setButtonView
{
    [self.view addSubview:self.buttonBackView];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(((self.view.frame.size.width -180)/3), -15, 100, 50);
    button.backgroundColor = [UIColor clearColor];
    //设置button正常状态下的图片
    [button setImage:[UIImage imageNamed:@"bu"] forState:UIControlStateNormal];

    //button图片的偏移量，距上左下右分别(10, 10, 10, 60)像素点
    button.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 60);
    [button setTitle:@"不喜欢" forState:UIControlStateNormal];
    //button标题的偏移量，这个偏移量是相对于图片的
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    //设置button正常状态下的标题颜色
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //设置button高亮状态下的标题颜色
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button addTarget:self action:@selector(unLike:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonBackView addSubview:button];
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake((self.view.frame.size.width -180)/3*2 + 100, -15, 80, 50);
    button1.backgroundColor = [UIColor clearColor];
    //设置button正常状态下的图片
    [button1 setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    
    //button图片的偏移量，距上左下右分别(10, 10, 10, 60)像素点
    button1.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 50);
    [button1 setTitle:@"喜欢" forState:UIControlStateNormal];
    //button标题的偏移量，这个偏移量是相对于图片的
    button1.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    //设置button正常状态下的标题颜色
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //设置button高亮状态下的标题颜色
    button1.titleLabel.font = [UIFont systemFontOfSize:14];
    [button1 addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.buttonBackView addSubview:button1];
}

- (void)unLike:(UIButton *)button
{
    [self.swipeableView removeTopCardViewFromSwipe:LZSwipeableViewCellSwipeDirectionLeft];
    CAKeyframeAnimation * keyAnimaion = [CAKeyframeAnimation animation];
    keyAnimaion.keyPath = @"transform.rotation";
    keyAnimaion.values = @[@(-10 / 180.0 * M_PI),@(10 /180.0 * M_PI),@(-10/ 180.0 * M_PI),@(0 /180.0 * M_PI)];//度数转弧度
    
    keyAnimaion.removedOnCompletion = NO;
    keyAnimaion.fillMode = kCAFillModeForwards;
    keyAnimaion.duration = 0.3;
    keyAnimaion.repeatCount = 1;
    [button.layer addAnimation:keyAnimaion forKey:nil];
}

- (void)like:(UIButton *)button
{
    [self.swipeableView removeTopCardViewFromSwipe:LZSwipeableViewCellSwipeDirectionRight];
    CAKeyframeAnimation * keyAnimaion = [CAKeyframeAnimation animation];
    keyAnimaion.keyPath = @"transform.rotation";
    keyAnimaion.values = @[@(-10 / 180.0 * M_PI),@(10 /180.0 * M_PI),@(-10/ 180.0 * M_PI),@(0 /180.0 * M_PI)];//度数转弧度
    
    keyAnimaion.removedOnCompletion = NO;
    keyAnimaion.fillMode = kCAFillModeForwards;
    keyAnimaion.duration = 0.3;
    keyAnimaion.repeatCount = 1;
    [button.layer addAnimation:keyAnimaion forKey:nil];
}

- (UIView *)buttonBackView
{
    if (!_buttonBackView) {
        _buttonBackView = [[UIView alloc]init];
        _buttonBackView.frame = (CGRect){0,kScreenSize.height-49,kScreenSize.width,75};
        _buttonBackView.backgroundColor = [UIColor clearColor];
    }
    return _buttonBackView;
}

- (void)initNavigationBar
{
    self.navigationController.navigationBarHidden = YES;
    self.leftBarItem = [[SCBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_navi_back"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.sc_navigationItem.leftBarButtonItem = self.leftBarItem;
    self.sc_navigationItem.title = @"认知重构";
}

- (NSMutableArray *)cardInfoList{
    if (!_cardInfoList) {
        _cardInfoList = [NSMutableArray array];
    }
    return _cardInfoList;
}

- (LZSwipeableView *)swipeableView{
    if (!_swipeableView) {
        _swipeableView = [[LZSwipeableView alloc] initWithFrame:self.view.bounds];
        _swipeableView.datasource = self;
        _swipeableView.delegate = self;
        _swipeableView.backgroundColor = [UIColor colorWithHex:0xebebeb];
        _swipeableView.topCardInset = UIEdgeInsetsMake(64, 0, 0, 0);
        _swipeableView.hidden = YES;
    }
    return _swipeableView;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.swipeableView.frame = self.view.bounds;
}

#pragma mark LZSwipeableViewDataSource
- (NSInteger)swipeableViewNumberOfRowsInSection:(LZSwipeableView *)swipeableView{
    return self.cardInfoList.count;
}

- (LZSwipeableViewCell *)swipeableView:(LZSwipeableView *)swipeableView cellForIndex:(NSInteger)index{
    AVSwipeCardCell *cell = [swipeableView dequeueReusableCellWithIdentifier:NSStringFromClass([AVSwipeCardCell class])];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.cornerRadius = 5;
    cell.layer.masksToBounds = YES;
    //[cell configCardView:self.cardInfoList[index]];
    cell.cardInfo = self.cardInfoList[index];
    return cell;
}

- (LZSwipeableViewCell *)swipeableView:(LZSwipeableView *)swipeableView substituteCellForIndex:(NSInteger)index{
    AVSwipeCardCell *cell = [[AVSwipeCardCell alloc] initWithReuseIdentifier:@""];
    cell.cardInfo = self.cardInfoList[index];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.cornerRadius = 5;
    cell.layer.masksToBounds = YES;
    return cell;
}

#pragma mark LZSwipeableViewDelegate
- (NSInteger)swipeableViewMaxCardNumberWillShow:(LZSwipeableView *)swipeableView{
    return 4;
}
- (void)swipeableView:(LZSwipeableView *)swipeableView didTapCellAtIndex:(NSInteger)index{
    
}

/*
- (UIView *)footerViewForSwipeableView:(LZSwipeableView *)swipeableView{
    return [self showHeaderOrFooterView];
}

- (UIView *)showHeaderOrFooterView{
    AVKnackBottomToolView *bottomView = [AVKnackBottomToolView viewFromXib];
    bottomView.superVCtl = self;
    bottomView.delegate  = self;
    bottomView.backgroundColor = [UIColor whiteColor];
    return bottomView;
}

- (CGFloat)heightForFooterView:(LZSwipeableView *)swipeableView{
    return 75;
}
*/
// 拉到最后一个
- (void)swipeableViewDidLastCardRemoved:(LZSwipeableView *)swipeableView{
    
}


- (void)swipeableView:(LZSwipeableView *)swipeableView didCardRemovedAtIndex:(NSInteger)index withDirection:(LZSwipeableViewCellSwipeDirection)direction{
    NSLog(@"%zd",direction);
}


- (void)swipeableView:(LZSwipeableView *)swipeableView didTopCardShow:(LZSwipeableViewCell *)topCell{
    
}


- (void)swipeableView:(LZSwipeableView *)swipeableView didLastCardShow:(LZSwipeableViewCell *)cell{
    
}

#pragma mark - AVKnackBottomToolViewDelegate
- (void)knackBottomToolViewDidCheckDetailBtnClick:(AVCardInfo *)idInfo{
    [self.swipeableView removeTopCardViewFromSwipe:LZSwipeableViewCellSwipeDirectionLeft];
}


- (void)knackBottomToolViewDidCollectBtnClick:(AVCardInfo *)idInfo{
    [self.swipeableView removeTopCardViewFromSwipe:LZSwipeableViewCellSwipeDirectionRight];
}

- (void)knackBottomToolViewDidShareBtnClick:(AVCardInfo *)idInfo{
    [self.swipeableView removeTopCardViewFromSwipe:LZSwipeableViewCellSwipeDirectionBottom];
    
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
