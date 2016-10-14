//
//  HeartViewController.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/23.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "CenterDataShowViewController.h"
#import "CenterDataShowDataDelegate.h"
#import "CenterGaugeTableViewCell.h"
#import "CenterDataTableViewCell.h"
#import "SleepModelChange.h"
#import "ChartContainerViewController.h"
#import "ChartTableContainerViewController.h"
#import "MMPopupItem.h"
#import "ArticleViewController.h"
#import "RxWebViewController.h"
#import "CenterSubTableViewCell.h"

@interface CenterDataShowViewController ()

@property (nonatomic, strong) UITableView *dataShowTableView;
@property (nonatomic, strong) CenterDataShowDataDelegate *dataDelegate;
@property (nonatomic, strong) SleepQualityModel *sleepQualityModel;
@property (nonatomic, strong) ArticleNewModel *articleModel;
@property (nonatomic, strong) NSString *queryStartTime;
@property (nonatomic, strong) NSString *queryEndTime;
@property (nonatomic, strong) NSArray *controllersArr;
@property (nonatomic, strong) UILabel *cellRecommend;
@property (nonatomic, strong) NSString *city;

@end

@implementation CenterDataShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backgroundImageView.image = [UIImage imageNamed:@""];
    self.view.backgroundColor = [UIColor clearColor];
    [self addTableViewDataHandle];
    [self initPushController];
    NSString *queryEndDate = [SleepModelChange chageDateFormatteToQueryString:[NSDate date]];
    NSString *queryFromDate = [SleepModelChange chageDateFormatteToQueryString:[[NSDate date] dateByAddingDays:-1]];
    [self getSleepDataWithStartTime:queryFromDate endTime:queryEndDate];
    [self configNoti];
    [self showArticle];
    [self getSensorInfo];
}

- (void)configNoti
{
    [[NSNotificationCenter defaultCenter]addObserverForName:kGetCurrentCity object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSString *city = [note.userInfo objectForKey:@"city"];
        [[NSUserDefaults standardUserDefaults]setObject:city forKey:@"city"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self showArticleL];
    }];
    [[NSNotificationCenter defaultCenter]addObserverForName:kUserBedStatusChanged object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self getSensorInfo];
        
    }];
}

- (void)showArticleL{
    if (self.cellRecommend.text.length > 0) {
        return;
    }else{
        [self showArticle];
    }
}

- (void)showArticle
{
    self.city = [[NSUserDefaults standardUserDefaults] objectForKey:@"city"];
    if (self.city.length > 0) {
        [self getAriticleList:[[NSUserDefaults standardUserDefaults] objectForKey:@"city"]];
    }
}

- (void)getAriticleList:(NSString *)dic
{
    if (self.deviceUUID.length==0) {
        return;
    }
    ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
    NSDictionary *dic19 = @{
                            @"UUID" : self.deviceUUID,
                            @"FromDate": self.queryStartTime,
                            @"EndDate": self.queryEndTime,
                            @"City":dic,
                            @"UserId":thirdPartyLoginUserId
                            };
    @weakify(self);
    [client requestArticle:dic19 andBlock:^(ArticleModel *baseModel, NSError *error) {
        @strongify(self);
        ArticleNewModel *article = [baseModel.articleNewsList objectAtIndex:0];
        self.articleModel = article;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.cellRecommend.text = article.title;
        });
    }];
}

- (void)initPushController
{
    self.controllersArr = @[@[@"ChartContainerViewController",@"ChartTableContainerViewController"],@[@"ChartContainerViewController",@"ChartTableContainerViewController"],];
    
}
#pragma mark setter

- (UITableView *)dataShowTableView
{
    if (!_dataShowTableView) {
        _dataShowTableView = [[UITableView alloc]initWithFrame:(CGRect){0,0,self.view.frame.size.width,self.view.size.height-64} style:UITableViewStyleGrouped];
        _dataShowTableView.scrollEnabled = YES;
        _dataShowTableView.backgroundColor = [UIColor clearColor];
        _dataShowTableView.showsVerticalScrollIndicator = NO;
        _dataShowTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _dataShowTableView.scrollEnabled = NO;
    }
    return _dataShowTableView;
}

- (UILabel *)cellRecommend
{
    if (_cellRecommend == nil) {
        _cellRecommend = [[UILabel alloc]init];
        _cellRecommend.textAlignment = NSTextAlignmentCenter;
        _cellRecommend.numberOfLines = 0;
        _cellRecommend.text = @"";
        _cellRecommend.userInteractionEnabled = YES;
        _cellRecommend.textColor = [UIColor whiteColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapArticle:)];
        [_cellRecommend addGestureRecognizer:tap];
    }
    return _cellRecommend;
}

- (void)tapArticle:(UIGestureRecognizer *)gesture
{
    
    RxWebViewController* webViewController = [[RxWebViewController alloc] initWithUrl:[NSURL URLWithString:self.articleModel.url]];
    webViewController.tagLists = self.articleModel.tips;
    webViewController.urlString = self.articleModel.url;
    webViewController.articleTitle = self.articleModel.title;
    [self.navigationController pushViewController:webViewController animated:YES];
//    ArticleViewController *articleView = [[ArticleViewController alloc]init];
//    articleView.articleURL = self.articleModel.url;
//    articleView.articleTitle = self.articleModel.title;
//    [self.navigationController pushViewController:articleView animated:YES];
}

- (void)addTableViewDataHandle
{
    [self.view addSubview:self.dataShowTableView];
    TableViewCellConfigureBlock configureCellBlock = ^(NSIndexPath *indexPath, id item, UITableViewCell *cell){
        if (indexPath.row == 0) {
            [cell configure:cell customObj:item indexPath:indexPath withOtherInfo:self.sleepQualityModel];
            [cell addSubview:self.cellRecommend];
            float height = 0;
            if (ISIPHON6S) {
                height = 315;
            }else{
                height = 315/1.174;
            }
            _cellRecommend.frame = (CGRect){0,height-62,self.view.frame.size.width,50};


        }else if (indexPath.row == 1 ||indexPath.row == 2){
            [cell configure:cell customObj:item indexPath:indexPath withOtherInfo:self.sleepQualityModel];

        }else{
            CenterSubTableViewCell *subCell = (CenterSubTableViewCell*)cell;
            [subCell configure:cell customObj:self.sensorInfoDetail indexPath:indexPath withOtherInfo:self.sleepQualityModel andAnObj:self.anInfoDetail andType:self.bedType];
        }
        
    };
    CellHeightBlock configureCellHeightBlock = ^ CGFloat (NSIndexPath *indexPath, id item){
        if (indexPath.row ==0) {
            if (ISIPHON6S) {
                return 315;
            }else{
            
                return 315/1.174;
            }
        }else if (indexPath.row ==1 || indexPath.row ==2){
            if (ISIPHON6S) {
                return 63;
            }else{
                
                return 63/1.174;
            }
        }else if (indexPath.row == 3){
            if (ISIPHON6S) {
                return 160;
            }else{
                
                return 160/1.174;
            }
        }
        return 0;
    };
    
    @weakify(self);
    DidSelectCellBlock didSelectBlock = ^(NSIndexPath *indexPath, id item){
        @strongify(self);
        [self didSeletedCellIndexPath:indexPath withData:item];
    };
    NSString *path = [[NSBundle mainBundle]pathForResource:@"CenterData" ofType:@"plist"];
    NSArray *arr = [NSArray arrayWithContentsOfFile:path];
    self.dataDelegate = [[CenterDataShowDataDelegate alloc]initWithItems:arr cellIdentifier:@"cell" configureCellBlock:configureCellBlock cellHeightBlock:configureCellHeightBlock didSelectBlock:didSelectBlock];
    [self.dataDelegate handleTableViewDataSourceAndDelegate:self.dataShowTableView];
    self.dataDelegate.cellSelectedTaped = ^(id callBackResult ,cellTapType type){
        @strongify(self);
        [self sendCellTapResult:callBackResult type:type];
    };
}

- (void)getSleepDataWithStartTime:(NSString *)startTime endTime:(NSString *)endTime
{
    if (self.deviceUUID.length == 0) {
        [self showNoDeviceBindingAlert];
        return;
    }
    self.queryStartTime = startTime;
    self.queryEndTime = endTime;
    ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
    NSDictionary *dic19 = @{
                            @"UUID" : self.deviceUUID,
                            @"FromDate": self.queryStartTime,
                            @"EndDate": self.queryEndTime,
                            };
    @weakify(self);
    
    [client requestGetSleepQualityParams:dic19 andBlock:^(SleepQualityModel *qualityModel, NSError *error) {
        @strongify(self);
        self.sleepQualityModel = qualityModel;
        [self.dataShowTableView reloadData];
    }];
    if (self.city.length > 0) {
        [self getAriticleList:[[NSUserDefaults standardUserDefaults] objectForKey:@"city"]];
    }
}

- (void)sendCellTapResult:(id)result type:(cellTapType)type
{
    switch (type) {
        case cellTapEndTime:
        {
            [self sendSleepEndTime:result];
            break;
        }
            
        default:
            break;
    }
}

- (void)sendSleepEndTime:(NSDate *)endDate
{
    if (self.deviceUUID.length == 0) {
        [self showNoDeviceBindingAlert];
        return;
    }
    NSString *hour = endDate.hour>9?[NSString stringWithFormat:@"%ld",endDate.hour]:[NSString stringWithFormat:@"0%ld",endDate.hour];
    NSString *minute = endDate.minute>9?[NSString stringWithFormat:@"%ld",endDate.minute]:[NSString stringWithFormat:@"0%ld",endDate.minute];
    NSString *endString = [NSString stringWithFormat:@"%@:%@",hour,minute];
    NSDate *date1 = [selectedDateToUse dateByAddingDays:0];
    NSString *dateString = [NSString stringWithFormat:@"%@",date1];
    NSString *date = [NSString stringWithFormat:@"%@%@:00",[dateString substringToIndex:11],endString];
    NSDictionary *dic = @{
                          @"UUID" : self.deviceUUID,
                          @"UserID" : thirdPartyLoginUserId,
                          @"Tags" :@[ @{
                                          @"Tag": @"<%睡眠时间记录%>",
                                          @"TagType": @"1",
                                          @"UserTagDate": date,
                                          }],
                          };
    ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
    [client requestAddUserTagsParams:dic andBlock:^(BaseModel *resultModel, NSError *error) {
        DeBugLog(@"睡眠成功");
        [self getSleepDataWithStartTime:self.queryStartTime endTime:self.queryEndTime];
    }];
}

- (void)sendSleepStart
{
    DeBugLog(@"sleep start");
    if (self.deviceUUID.length == 0) {
        [self showNoDeviceBindingAlert];
        return;
    }
    NSDate *date = [[NSDate date]dateByAddingHours:8];
    NSString *dateString = [NSString stringWithFormat:@"%@",date];
    NSDictionary *dic = @{
                          @"UUID" : self.deviceUUID,
                          @"UserID" : thirdPartyLoginUserId,
                          @"Tags" : @[@{
                                          @"Tag": @"<%睡眠时间记录%>",
                                          @"TagType": @"-1",
                                          @"UserTagDate": dateString,
                                          }],
                          };
    ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
    [client requestAddUserTagsParams:dic andBlock:^(BaseModel *resultModel, NSError *error) {
        DeBugLog(@"睡眠开始");
        [NSObject showHudTipStr:@"做个好梦!"];
    }];
}

- (void)didSeletedCellIndexPath:(NSIndexPath *)indexPath withData:(id)obj
{
    if (self.deviceUUID.length == 0) {
        [self showNoDeviceBindingAlert];
        return;
    }
    if (indexPath.row == 0) {
        ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
        NSDictionary *dic19 = @{
                                @"UUID" : self.deviceUUID,
                                @"FromDate": self.queryStartTime,
                                @"EndDate": self.queryEndTime,
                                };
        @weakify(self);
        [client requestGetSleepQualityParams:dic19 andBlock:^(SleepQualityModel *qualityModel, NSError *error) {
            @strongify(self);
            self.sleepQualityModel = qualityModel;
            [self.dataShowTableView reloadData];
        }];
    }else if (indexPath.row == 1){
        
        if ([obj integerValue]==0) {
            NSString *className = [[self.controllersArr objectOrNilAtIndex:indexPath.row-1] objectOrNilAtIndex:0];
            Class class = NSClassFromString(className);
            ChartContainerViewController *controller = (ChartContainerViewController*)class.new;
            controller.sensorType = SensorDataHeart;
            [self.navigationController pushViewController:controller animated:YES];
        }else if ([obj integerValue]==1){
            NSString *className = [[self.controllersArr objectOrNilAtIndex:indexPath.row-1] objectOrNilAtIndex:1];
            Class class = NSClassFromString(className);
            ChartTableContainerViewController *controller = (ChartTableContainerViewController*)class.new;
            controller.sensorType = SensorDataTurn;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }else if (indexPath.row == 2){
        if ([obj integerValue]==0) {
            NSString *className = [[self.controllersArr objectOrNilAtIndex:indexPath.row-1] objectOrNilAtIndex:0];
            Class class = NSClassFromString(className);
            ChartContainerViewController *controller = (ChartContainerViewController*)class.new;
            controller.sensorType = SensorDataBreath;
            [self.navigationController pushViewController:controller animated:YES];
        }else if ([obj integerValue]==1){
            NSString *className = [[self.controllersArr objectOrNilAtIndex:indexPath.row-1] objectOrNilAtIndex:1];
            Class class = NSClassFromString(className);
            ChartTableContainerViewController *controller = (ChartTableContainerViewController*)class.new;
            controller.sensorType = SensorDataLeave;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

- (void)getSensorInfo
{
    if (self.deviceUUID.length == 0) {
        return;
    }
    NSDictionary *para = @{
                           @"UUID": self.deviceUUID
                           };
    @weakify(self);
    ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
    [client requestCheckSensorInfoParams:para andBlcok:^(SensorInfoModel *sensorModel, NSError *error) {
        @strongify(self);
        if (sensorModel) {
            self.sensorInfoDetail = sensorModel;
            if (self.anUUID.length == 0) {
                [self.dataShowTableView reloadData];
                return;
            }
            NSDictionary *para = @{
                                   @"UUID": self.anUUID
                                   };
            @weakify(self);
            ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
            [client requestCheckSensorInfoParams:para andBlcok:^(SensorInfoModel *sensorModel, NSError *error) {
                @strongify(self);
                if (sensorModel) {
                    self.anInfoDetail = sensorModel;
                    [self.dataShowTableView reloadData];
                }else{
                }
            }];
        }else{
        }
    }];
}

- (void)refreshBedStaus
{
    [self getSensorInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
