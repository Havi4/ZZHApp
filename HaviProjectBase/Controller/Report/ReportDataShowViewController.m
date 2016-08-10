//
//  ReportDataShowViewController.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/26.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "ReportDataShowViewController.h"
#import "ReportDataDelegate.h"
#import "CalendarDateCaculate.h"

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
    [self getFirstQueryDate];
}

- (void)addTableViewDataHandle
{
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = kReportCellColor;
    [self.refreshControl addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
    [self.reportShowTableView addSubview:self.refreshControl];
    [self.view addSubview:self.reportShowTableView];
    TableViewCellConfigureBlock configureCellBlock = ^(NSIndexPath *indexPath, id item, UITableViewCell *cell){
        if (indexPath.section == 0) {
            [cell configure:cell customObj:@{@"queryStartTime":self.queryStartTime==nil ? @"20151221" : self.queryStartTime,@"queryEndTime":self.queryEndTime==nil ? @"20151221":self.queryEndTime} indexPath:indexPath withOtherInfo:self.sleepQualityModel];
        }else if (indexPath.section == 1){
            [cell configure:cell customObj:item indexPath:indexPath withOtherInfo:self.sleepQualityModel];
        }else if (indexPath.section == 2){
            [cell configure:cell customObj:item indexPath:indexPath withOtherInfo:self.sleepQualityModel];
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
        _reportShowTableView.backgroundColor = [UIColor colorWithRed:0.980 green:0.984 blue:0.988 alpha:1.00];
        _reportShowTableView.showsVerticalScrollIndicator = NO;
    }
    return _reportShowTableView;
}

- (void)getSleepDataWithFromDate:(NSString *)fromDate endDate:(NSString *)endDate
{
    if (self.deviceUUID.length == 0) {
        [self.refreshControl endRefreshing];
        dispatch_async_on_main_queue(^{
            [self showNoDeviceBindingAlert];
        });
        return;
    }
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
        [self.refreshControl endRefreshing];
        self.sleepQualityModel = qualityModel;
        //[self.reportShowTableView reloadData];不使用避免无限加载
        [self.reportShowTableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
        [self.reportShowTableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
        [self.reportShowTableView reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
        [self.reportDelegate reloadHeader:qualityModel];
    }];
}

- (void)refreshAction
{
    [self getSleepDataWithFromDate:self.queryStartTime endDate:self.queryEndTime];
}

- (void)getFirstQueryDate
{
    switch (self.reportType) {
        case ReportViewWeek:
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString *monthTitle = [[CalendarDateCaculate sharedInstance] getCurrentWeekInOneYear:[[NSDate date] dateByAddingHours:8]];
                NSString *subTitle = [[CalendarDateCaculate sharedInstance]getWeekTimeDuration:[[NSDate date] dateByAddingHours:8]];
                NSString *year = [monthTitle substringWithRange:NSMakeRange(0, 4)];
                NSString *fromMonth = [subTitle substringWithRange:NSMakeRange(0, 2)];
                NSString *fromDay = [subTitle substringWithRange:NSMakeRange(3, 2)];
                NSString *toMonth = [subTitle substringWithRange:NSMakeRange(7, 2)];
                NSString *toDay = [subTitle substringWithRange:NSMakeRange(10, 2)];
                NSString *fromDate = [NSString stringWithFormat:@"%@%@%@",year,fromMonth,fromDay];
                NSString *toDate = [NSString stringWithFormat:@"%@%@%@",year,toMonth,toDay];
                
                [self getSleepDataWithFromDate:fromDate endDate:toDate];
            });
            break;
        }
        case ReportViewMonth:{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString *monthTitle = [[CalendarDateCaculate sharedInstance]getCurrentMonthInOneYear:[NSDate date]];
                NSString *year = [monthTitle substringWithRange:NSMakeRange(0, 4)];
                NSString *fromMonth = [monthTitle substringWithRange:NSMakeRange(5, 2)];
                NSString *fromDate = [NSString stringWithFormat:@"%@%@%@",year,fromMonth,@"01"];
                NSString *toDate = @"";
                toDate = [NSString stringWithFormat:@"%@%@%ld",year,fromMonth,[[CalendarDateCaculate sharedInstance] getCurrentMonthDayNum:year month:fromMonth]];
                DeBugLog(@"from:%@,end:%@",fromDate,toDate);
                [self getSleepDataWithFromDate:fromDate endDate:toDate];
            });
            break;
        }
        case ReportViewQuater:{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString *monthTitle = [[CalendarDateCaculate sharedInstance] getCurrentQuaterInOneYear:[NSDate date]];
                NSString *subTitle = [[CalendarDateCaculate sharedInstance] getQuaterTimeDuration:[NSDate date]];
                NSString *year = [monthTitle substringWithRange:NSMakeRange(0, 4)];
                NSString *fromMonth = [subTitle substringWithRange:NSMakeRange(0, 2)];
                NSString *fromDateString = [NSString stringWithFormat:@"%@%@%@",year,fromMonth,@"01"];
                NSString *toMonth = [subTitle substringWithRange:NSMakeRange(4, 2)];
                NSString *toDateString = [NSString stringWithFormat:@"%@%@%ld",year,toMonth,(long)[[CalendarDateCaculate sharedInstance] getCurrentMonthDayNum:year month:toMonth]];
                DeBugLog(@"from:%@,end:%@",fromDateString,toDateString);
                [self getSleepDataWithFromDate:fromDateString endDate:toDateString];
            });
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
