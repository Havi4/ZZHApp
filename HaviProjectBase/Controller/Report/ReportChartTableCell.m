//
//  ReportChartTableCell.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/26.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "ReportChartTableCell.h"
#import "NewWeekReport.h"
#import "NSDate+NSDateLogic.h"
#import "CalendarDateCaculate.h"

@interface ReportChartTableCell ()

@property (nonatomic,strong) NewWeekReport *weekReport;
@property (nonatomic,strong) NewWeekReport *monthReport;
@property (nonatomic,strong) NewWeekReport *quaterReport;
@property (nonatomic,strong) UIScrollView *dataScrollView;
@property (nonatomic,assign) NSInteger dayNums;
@property (nonatomic,assign) ReportViewType reportType;

@end

@implementation ReportChartTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style withReportType:(ReportViewType)type reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        switch (type) {
            case ReportViewWeek:
                [self addSubview:self.weekReport];
                break;
            case ReportViewMonth:
                [self addSubview:self.dataScrollView];
                break;
            case ReportViewQuater:
                [self addSubview:self.quaterReport];
                break;
                
            default:
                break;
        }
        self.reportType = type;
    }
    return self;
}

- (NewWeekReport*)weekReport
{
    if (!_weekReport) {
        _weekReport = [[NewWeekReport alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 216)];
        _weekReport.xValues = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
        _weekReport.sleepQulityDataValues = [NSMutableArray arrayWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0",@"0"]];
        _weekReport.sleepTimeDataValues = [NSMutableArray arrayWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0",@"0"]];
    }
    return _weekReport;
}

- (UIScrollView *)dataScrollView
{
    if (!_dataScrollView) {
        _dataScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 216)];
        _dataScrollView.contentSize = CGSizeMake(4*self.frame.size.width+self.frame.size.width/7*3, 216);
        _dataScrollView.backgroundColor = [UIColor colorWithRed:0.059f green:0.141f blue:0.231f alpha:1.00f];
        _dataScrollView.delegate = self;
        [_dataScrollView addSubview:self.monthReport];
        _dataScrollView.showsHorizontalScrollIndicator = NO;
    }
    
    return _dataScrollView;
}

- (NewWeekReport*)monthReport
{
    if (!_monthReport) {
        _monthReport = [[NewWeekReport alloc]initWithFrame:CGRectMake(0, 0, 4*self.frame.size.width+self.frame.size.width/7*3, 216)];
        self.dayNums = [[NSDate date] getdayNumsInOneMonth];
        if (self.dayNums==30) {
            _monthReport.xValues = @[@"1日",@"2日",@"3日",@"4日",@"5日",@"6日",@"7日",@"8日",@"9日",@"10日",@"11日",@"12日",@"13日",@"14日",@"15日",@"16日",@"17日",@"18日",@"19日",@"20日",@"21日",@"22日",@"23日",@"24日",@"25日",@"26日",@"27日",@"28日",@"29日",@"30日"];
            _monthReport.sleepQulityDataValues = [NSMutableArray arrayWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"]];
            _monthReport.sleepTimeDataValues = [NSMutableArray arrayWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"]];
            
        }else if(self.dayNums>30){
            _monthReport.xValues = @[@"1日",@"2日",@"3日",@"4日",@"5日",@"6日",@"7日",@"8日",@"9日",@"10日",@"11日",@"12日",@"13日",@"14日",@"15日",@"16日",@"17日",@"18日",@"19日",@"20日",@"21日",@"22日",@"23日",@"24日",@"25日",@"26日",@"27日",@"28日",@"29日",@"30日",@"31日"];
            _monthReport.sleepQulityDataValues = [NSMutableArray arrayWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"]];
            _monthReport.sleepTimeDataValues = [NSMutableArray arrayWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"]];
        }else if(self.dayNums==28){
            _monthReport.xValues = @[@"1日",@"2日",@"3日",@"4日",@"5日",@"6日",@"7日",@"8日",@"9日",@"10日",@"11日",@"12日",@"13日",@"14日",@"15日",@"16日",@"17日",@"18日",@"19日",@"20日",@"21日",@"22日",@"23日",@"24日",@"25日",@"26日",@"27日",@"28日"];
            _monthReport.sleepQulityDataValues = [NSMutableArray arrayWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"]];
            _monthReport.sleepTimeDataValues = [NSMutableArray arrayWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"]];
        }else if (self.dayNums==29){
            _monthReport.xValues = @[@"1日",@"2日",@"3日",@"4日",@"5日",@"6日",@"7日",@"8日",@"9日",@"10日",@"11日",@"12日",@"13日",@"14日",@"15日",@"16日",@"17日",@"18日",@"19日",@"20日",@"21日",@"22日",@"23日",@"24日",@"25日",@"26日",@"27日",@"28日",@"29日"];
            _monthReport.sleepQulityDataValues = [NSMutableArray arrayWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"]];
            _monthReport.sleepTimeDataValues = [NSMutableArray arrayWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"]];
        }
        
        
    }
    return _monthReport;
}

- (NewWeekReport*)quaterReport
{
    if (!_quaterReport) {
        _quaterReport = [[NewWeekReport alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 216)];
        NSString *currentDate = [[NSString stringWithFormat:@"%@",[NSDate date]]substringToIndex:7];
        NSString *month = [currentDate substringWithRange:NSMakeRange(5, 2)];
        NSString *quater = [[CalendarDateCaculate sharedInstance] changeMonthToQuater:month];
        if ([quater intValue]==1) {
            self.quaterReport.xValues = @[@"一月",@"二月",@"三月"];
        }else if ([quater intValue]==2){
            self.quaterReport.xValues = @[@"四月",@"五月",@"六月"];
        }else if ([quater intValue]==3){
            self.quaterReport.xValues = @[@"七月",@"八月",@"九月"];
        }else if ([quater intValue]==4){
            self.quaterReport.xValues = @[@"十月",@"十一月",@"十二月"];
        }
        _quaterReport.sleepQulityDataValues = [NSMutableArray arrayWithArray:@[@"0",@"0",@"0"]];
        _quaterReport.sleepTimeDataValues = [NSMutableArray arrayWithArray:@[@"0",@"0",@"0"]];
    }
    return _quaterReport;
}

- (void)configure:(UITableViewCell *)cell
        customObj:(id)obj
        indexPath:(NSIndexPath *)indexPath
    withOtherInfo:(id)objInfo
{
    // Rewrite this func in SubClass !
    //obj,请求时间
    SleepQualityModel *model = objInfo;
    if (self.reportType == ReportViewWeek) {
        @weakify(self);
        [SleepModelChange filterReportData:model.data queryDate:obj callBack:^(id qualityBack, id sleepDurationBack) {
            @strongify(self);
            self.weekReport.sleepQulityDataValues = qualityBack;
            self.weekReport.sleepTimeDataValues = sleepDurationBack;
            
            [self.weekReport reloadChartView];
            
        }];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dk_backgroundColorPicker = DKColorWithColors([UIColor colorWithRed:0.059f green:0.141f blue:0.231f alpha:1.00f], [UIColor colorWithRed:0.475f green:0.686f blue:0.820f alpha:1.00f]);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x < 0) {
        scrollView.contentOffset = CGPointMake(0, 0);
        return;
    }
    if (scrollView.contentSize.width>scrollView.frame.size.width&&scrollView.contentOffset.x>0) {
        if (scrollView.contentSize.width-scrollView.contentOffset.x < scrollView.frame.size.width) {
            scrollView.contentOffset = CGPointMake(scrollView.contentSize.width - scrollView.frame.size.width,0 );
            return;
        }
    }
    CGPoint centerPoint = CGPointMake(scrollView.contentOffset.x + self.frame.size.width/2, scrollView.center.y);
//    self.noDataImageView.center = centerPoint;
    
}
@end
