//
//  ChartTableViewController.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/26.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "ChartTableViewController.h"
#import "ChartTableDataDelegate.h"

@interface ChartTableViewController ()

@property (nonatomic, strong) UITableView *sensorShowTableView;
@property (nonatomic, strong) ChartTableDataDelegate *sensorDelegate;
@property (nonatomic, strong) SleepQualityModel *sleepQualityModel;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation ChartTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTableViewDataHandle];
    [self getSleepQualityData];
    [self getSensorData];
}

- (void)addTableViewDataHandle
{
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.dk_tintColorPicker = kTextColorPicker;
    [self.refreshControl addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
    [self.sensorShowTableView addSubview:self.refreshControl];
    [self.view addSubview:self.sensorShowTableView];
    TableViewCellConfigureBlock configureCellBlock = ^(NSIndexPath *indexPath, id item, UITableViewCell *cell){
        [cell configure:cell customObj:item indexPath:indexPath withOtherInfo:@(self.sensorType)];
        
    };
    CellHeightBlock configureCellHeightBlock = ^ CGFloat (NSIndexPath *indexPath, id item){
        return 60;
    };
    
    DidSelectCellBlock didSelectBlock = ^(NSIndexPath *indexPath, id item){
    };
    self.sensorDelegate = [[ChartTableDataDelegate alloc]initWithItems:nil cellIdentifier:@"cell" configureCellBlock:configureCellBlock cellHeightBlock:configureCellHeightBlock didSelectBlock:didSelectBlock];
    [self.sensorDelegate handleTableViewDataSourceAndDelegate:self.sensorShowTableView];
}

- (UITableView *)sensorShowTableView
{
    if (!_sensorShowTableView) {
        _sensorShowTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height -64) style:UITableViewStylePlain];
        _sensorShowTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _sensorShowTableView.backgroundColor = [UIColor clearColor];
    }
    return _sensorShowTableView;
}


- (void)getSleepQualityData
{
    NSString *queryFromDate = [SleepModelChange chageDateFormatteToQueryString:selectedDateToUse];
    NSString *queryEndDate = [SleepModelChange chageDateFormatteToQueryString:[selectedDateToUse dateByAddingDays:1]];
    ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
    /*
     NSDictionary *dic19 = @{
     @"UUID" : self.deviceUUID,
     @"FromDate": queryFromDate,
     @"EndDate": queryEndDate,
     };
     */
    NSDictionary *dic19 = @{
                            @"UUID" : self.deviceUUID,
                            @"FromDate": @"20151221",
                            @"EndDate": @"20151222",
                            };
    @weakify(self);
    [client requestGetSleepQualityParams:dic19 andBlock:^(SleepQualityModel *qualityModel, NSError *error) {
        @strongify(self);
        [self.refreshControl endRefreshing];
        [self.sensorDelegate reloadTableViewHeaderWith:qualityModel withType:self.sensorType];
    }];
}

- (void)getSensorData
{
    NSString *queryFromDate = [SleepModelChange chageDateFormatteToQueryString:selectedDateToUse];
    NSString *queryEndDate = [SleepModelChange chageDateFormatteToQueryString:[selectedDateToUse dateByAddingDays:1]];
    ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
    NSDictionary *dic18 = @{
                            @"UUID" : self.deviceUUID,
                            @"DataProperty":@(self.sensorType-1),
                            @"FromDate": @"20151221",
                            @"EndDate": @"20151222",
                            };
    [client requestGetSensorDataParams:dic18 andBlock:^(SensorDataModel *sensorModel, NSError *error) {
        @weakify(self);
        [SleepModelChange filterSensorLeaveDataWithTime:sensorModel callBack:^(id callBack) {
            @strongify(self);
            self.sensorDelegate.items = callBack;
            [self.sensorShowTableView reloadData];
        }];
    }];
    
}

- (void)refreshAction
{
    [self.refreshControl endRefreshing];
//    [self getSleepQualityData];
//    [self getSensorData];
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
