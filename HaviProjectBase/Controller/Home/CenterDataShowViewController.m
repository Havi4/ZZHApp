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

@interface CenterDataShowViewController ()

@property (nonatomic, strong) UITableView *dataShowTableView;
@property (nonatomic, strong) CenterDataShowDataDelegate *dataDelegate;
@property (nonatomic, strong) SleepQualityModel *sleepQualityModel;
@property (nonatomic, strong) NSString *queryStartTime;
@property (nonatomic, strong) NSString *queryEndTime;
@property (nonatomic, strong) NSMutableArray *controllersArr;

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
}

- (void)initPushController
{
    self.controllersArr = @[].mutableCopy;
    [self addControllersToWithControllerName:@"ChartContainerViewController"];
    [self addControllersToWithControllerName:@"ChartContainerViewController"];
    [self addControllersToWithControllerName:@"ChartTableContainerViewController"];
    [self addControllersToWithControllerName:@"ChartTableContainerViewController"];
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
    }
    return _dataShowTableView;
}


- (void)addTableViewDataHandle
{
    [self.view addSubview:self.dataShowTableView];
    TableViewCellConfigureBlock configureCellBlock = ^(NSIndexPath *indexPath, id item, UITableViewCell *cell){
        if (indexPath.row == 0) {
            [cell configure:cell customObj:item indexPath:indexPath withOtherInfo:self.sleepQualityModel];

        }else if (indexPath.row == 1 ||indexPath.row == 2){
            [cell configure:cell customObj:item indexPath:indexPath withOtherInfo:self.sleepQualityModel];

        }else{
            [cell configure:cell customObj:item indexPath:indexPath withOtherInfo:self.sleepQualityModel];
        }
        
    };
    CellHeightBlock configureCellHeightBlock = ^ CGFloat (NSIndexPath *indexPath, id item){
        if (indexPath.row ==0) {
            return 300;
        }else if (indexPath.row ==1 || indexPath.row ==2){
            return 60;
        }else if (indexPath.row == 3){
            return 165;
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
    [self.dataShowTableView reloadData];
    /*
    if (self.deviceUUID.length == 0) {
        [self showNoDeviceBindingAlert];
        return;
    }
    NSString *className = [self.controllersArr objectOrNilAtIndex:indexPath.row];
    Class class = NSClassFromString(className);
    if (class) {
        if (indexPath.row <2) {
            ChartContainerViewController *controller = (ChartContainerViewController*)class.new;
            if (indexPath.row == 0) {
                controller.sensorType = SensorDataHeart;
            }else{
                controller.sensorType = SensorDataBreath;
            }
            [self.navigationController pushViewController:controller animated:YES];
        }else {
            ChartTableContainerViewController *controller = (ChartTableContainerViewController*)class.new;
            if (indexPath.row == 2) {
                controller.sensorType = SensorDataLeave;
            }else{
                controller.sensorType = SensorDataTurn;
            }
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
     */
}

- (void)addControllersToWithControllerName:(NSString *)name
{
    [self.controllersArr addObject:name];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
