//
//  ReportDataShowViewController.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/26.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "ReportDataShowViewController.h"
#import "ReportDataDelegate.h"

@interface ReportDataShowViewController ()

@property (nonatomic, strong) UITableView *reportShowTableView;
@property (nonatomic, strong) ReportDataDelegate *reportDelegate;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) SleepQualityModel *sleepQualityModel;
@property (nonatomic, strong) NSString *queryStartTime;
@property (nonatomic, strong) NSString *queryEndTime;

@end

@implementation ReportDataShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTableViewDataHandle];
    
}

- (void)addTableViewDataHandle
{
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.dk_tintColorPicker = kTextColorPicker;
    [self.refreshControl addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
    [self.reportShowTableView addSubview:self.refreshControl];
    [self.view addSubview:self.reportShowTableView];
    TableViewCellConfigureBlock configureCellBlock = ^(NSIndexPath *indexPath, id item, UITableViewCell *cell){
        if (indexPath.section == 0) {
            
        }else if (indexPath.section == 1){
            [cell configure:cell customObj:item indexPath:indexPath withOtherInfo:self.sleepQualityModel];
        }else if (indexPath.section == 2){
            [cell configure:cell customObj:@(self.reportType) indexPath:indexPath withOtherInfo:self.sleepQualityModel];
        }
        
    };
    CellHeightBlock configureCellHeightBlock = ^ CGFloat (NSIndexPath *indexPath, id item){
        return 60;
    };
    
    DidSelectCellBlock didSelectBlock = ^(NSIndexPath *indexPath, id item){
    };
    NSString *path = [[NSBundle mainBundle]pathForResource:@"ReportTitle" ofType:@"plist"];
    NSArray *title = [NSArray arrayWithContentsOfFile:path];
    self.reportDelegate = [[ReportDataDelegate alloc]initWithItems:title cellIdentifier:@"cell" configureCellBlock:configureCellBlock cellHeightBlock:configureCellHeightBlock didSelectBlock:didSelectBlock];
    [self.reportDelegate handleTableViewDataSourceAndDelegate:self.reportShowTableView withReportType:self.reportType];
    @weakify(self);
    self.reportDelegate.selectDateFromCalendar = ^(NSString *fromDate,NSString *endDate){
        @strongify(self);
        [self getSleepDataWithFromDate:fromDate endDate:endDate];
    };
}

- (UITableView *)reportShowTableView
{
    if (!_reportShowTableView) {
        _reportShowTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height -64) style:UITableViewStylePlain];
        _reportShowTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _reportShowTableView.backgroundColor = [UIColor clearColor];
    }
    return _reportShowTableView;
}

- (void)getSleepDataWithFromDate:(NSString *)fromDate endDate:(NSString *)endDate
{
    DeBugLog(@"开始%@:结束%@",fromDate,endDate);
    self.queryStartTime = fromDate;
    self.queryEndTime = endDate;
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
        //[self.reportShowTableView reloadData];不使用避免无限加载
        [self.reportShowTableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
        [self.reportShowTableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
        [self.reportShowTableView reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)refreshAction
{
    [self.refreshControl endRefreshing];
}

- (void)getFirstQueryDate
{
    switch (self.reportType) {
        case ReportViewWeek:
        {
            break;
        }
            
        default:
            break;
    }
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
