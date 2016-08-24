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

@interface ReportChartTableCell ()<UIScrollViewDelegate>

@property (nonatomic,strong) NewWeekReport *weekReport;
@property (nonatomic,strong) NewWeekReport *monthReport;
@property (nonatomic,strong) NewWeekReport *quaterReport;
@property (nonatomic,strong) UIScrollView *dataScrollView;
@property (nonatomic,assign) NSInteger dayNums;
@property (nonatomic,assign) ReportViewType reportType;
@property (nonatomic,strong) UIView *noDataImageView;
@property (nonatomic,strong) UIView *subView;

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
        [self subView];
    }
    return self;
}

- (UIView*)subView
{
    if (!_subView) {
        _subView = [[UIView alloc]initWithFrame:(CGRect){0,0,24,200}];
        _subView.backgroundColor = [UIColor clearColor];
        CGFloat cY = (200 - bottomLineMargin-16)/5;
        for (int i = 0; i<3; i++) {
            UILabel *lineView = [[UILabel alloc] init];
            lineView.frame = CGRectMake(2, 16 + cY*i*2-10, 24, 20);
            lineView.textColor = [UIColor whiteColor];
            lineView.font = [UIFont systemFontOfSize:14];
            lineView.textAlignment = NSTextAlignmentCenter;
            if (i==0) {
                lineView.text = @"12";
            }else if (i==1){
                lineView.text = @"8";
            }else if (i==2){
                lineView.text = @"6";
            }
            
            [self addSubview:lineView];
        }
        
        UIView *leftView1 = [[UIView alloc]init];
        leftView1.backgroundColor = [UIColor redColor];
        [self addSubview:leftView1];
        
        UILabel *leftLabel1 = [[UILabel alloc]init];
        leftLabel1.text = @"加油哦";
        leftLabel1.textColor = [UIColor whiteColor];
        leftLabel1.font = [UIFont systemFontOfSize:12];
        [self addSubview:leftLabel1];
        
        UIView *leftView = [[UIView alloc]init];
        leftView.backgroundColor = [UIColor whiteColor];
        [self addSubview:leftView];
        
        UILabel *leftLabel = [[UILabel alloc]init];
        leftLabel.text = @"时长";
        leftLabel.textColor = [UIColor whiteColor];
        leftLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:leftLabel];
        
        UIView *rightView = [[UIView alloc]init];
        rightView.backgroundColor = [UIColor greenColor];
        [self addSubview:rightView];
        
        UILabel *rightLabel = [[UILabel alloc]init];
        rightLabel.text = @"棒棒哒";
        rightLabel.textColor = [UIColor whiteColor];
        rightLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:rightLabel];
        
        [leftLabel1 makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(2);
            make.right.equalTo(self.mas_right).offset(-16);
        }];
        
        [leftView1 makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(leftLabel1.mas_centerY);
            make.right.equalTo(leftLabel1.mas_left).offset(-8);
            make.height.width.equalTo(@10);
        }];
        
        [rightLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(leftView1.mas_centerY);
            make.right.equalTo(leftView1.mas_left).offset(-16);
        }];
        
        [rightView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(rightLabel.mas_centerY);
            make.right.equalTo(rightLabel.mas_left).offset(-8);
            make.height.width.equalTo(@10);
        }];
        
        [leftLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(rightLabel.mas_centerY);
            make.right.equalTo(rightView.mas_left).offset(-16);
        }];
        
        [leftView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(leftLabel.mas_centerY);
            make.right.equalTo(leftLabel.mas_left).offset(-8);
            make.height.width.equalTo(@10);
        }];
    }
    return _subView;
}

- (NewWeekReport*)weekReport
{
    if (!_weekReport) {
        _weekReport = [[NewWeekReport alloc]initWithFrame:CGRectMake(24, 0, self.frame.size.width-32, 180)];
        _weekReport.xValues = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
        _weekReport.sleepQulityDataValues = [NSMutableArray arrayWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0",@"0"]];
        _weekReport.sleepTimeDataValues = [NSMutableArray arrayWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0",@"0"]];
        _weekReport.backgroundColor = [UIColor clearColor];
        
    }
    return _weekReport;
}

- (UIScrollView *)dataScrollView
{
    if (!_dataScrollView) {
        _dataScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(24, 0, self.frame.size.width-32, 180)];
        _dataScrollView.contentSize = CGSizeMake(4*self.frame.size.width+self.frame.size.width/7*3, 00);
        _dataScrollView.backgroundColor = [UIColor clearColor];
        _dataScrollView.delegate = self;
        [_dataScrollView addSubview:self.monthReport];
        _dataScrollView.showsHorizontalScrollIndicator = NO;
    }
    
    return _dataScrollView;
}

- (NewWeekReport*)monthReport
{
    if (!_monthReport) {
        _monthReport = [[NewWeekReport alloc]initWithFrame:CGRectMake(0, 0, 4*self.frame.size.width+self.frame.size.width/7*3, 180)];
        self.dayNums = [[NSDate date] getdayNumsInOneMonth];
        [self changeXvaluel:self.dayNums];
        
    }
    return _monthReport;
}

- (UIView*)noDataImageView
{
    if (!_noDataImageView) {
        _noDataImageView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 105)];
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(59, 16, 32.5, 32.5)];
        image.dk_imagePicker = DKImageWithNames(@"sad-75_0", @"sad-75_1");
        [_noDataImageView addSubview:image];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 49, 150, 30)];
        label.text= @"没有数据哦!";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:17];
        label.dk_textColorPicker = kTextColorPicker;
        [_noDataImageView addSubview:label];
    }
    return _noDataImageView;
}


- (void)changeXvaluel:(NSInteger )daysNum
{
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

- (NewWeekReport*)quaterReport
{
    if (!_quaterReport) {
        _quaterReport = [[NewWeekReport alloc]initWithFrame:CGRectMake(24, 0, self.frame.size.width-32, 180)];
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
    if (model.data.count == 0) {
        switch (self.reportType) {
            case ReportViewWeek:
            {
//                [self.weekReport addSubview:self.noDataImageView];
//                self.noDataImageView.center = self.weekReport.center;
                break;
            }
            case ReportViewMonth:{
//                [self.dataScrollView addSubview:self.noDataImageView];
//                self.noDataImageView.center = self.dataScrollView.center;
                break;
            }
            case ReportViewQuater:{
//                [self.quaterReport addSubview:self.noDataImageView];
//                self.noDataImageView.center = self.quaterReport.center;
                break;
            }
                
            default:
                break;
        }
    }else{
//        [self.noDataImageView removeFromSuperview];
        self.noDataImageView = nil;
    }
    if (self.reportType == ReportViewWeek) {
        @weakify(self);
        [SleepModelChange filterReportData:model.data queryDate:obj callBack:^(id qualityBack, id sleepDurationBack) {
            @strongify(self);
            self.weekReport.sleepQulityDataValues = qualityBack;
            self.weekReport.sleepTimeDataValues = sleepDurationBack;
            
            [self.weekReport reloadChartView];
            
        }];
    }else if (self.reportType == ReportViewMonth){
        @weakify(self);
        NSString *queryStart = [(NSDictionary *)obj objectForKey:@"queryStartTime"];
        if ([queryStart isEqualToString:@"20151221"]) {
            return;
        }
        NSString *year = [queryStart substringWithRange:NSMakeRange(0, 4)];
        NSString *month = [queryStart substringWithRange:NSMakeRange(4, 2)];
        NSString *day = [queryStart substringWithRange:NSMakeRange(6, 2)];
        NSString *fromDateString = [NSString stringWithFormat:@"%@年%@月%@日",year,month,day];
        NSDate *fromDate = [[[[CalendarDateCaculate sharedInstance] dateFormmatter] dateFromString:fromDateString]dateByAddingHours:8];
        self.dayNums = [fromDate getdayNumsInOneMonth];
        [self changeXvaluel:self.dayNums];
        [SleepModelChange filterMonthReportData:model.data queryDate:obj callBack:^(id qualityBack, id sleepDurationBack) {
            @strongify(self);
            self.monthReport.sleepQulityDataValues = qualityBack;
            self.monthReport.sleepTimeDataValues = sleepDurationBack;
            [self.monthReport reloadChartView];
        }];
    }else if (self.reportType == ReportViewQuater){
        NSString *queryStart = [(NSDictionary *)obj objectForKey:@"queryStartTime"];
        NSString *month = [queryStart substringWithRange:NSMakeRange(4, 2)];
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
        @weakify(self);
        [SleepModelChange filterQuaterReportData:model.data queryDate:obj callBack:^(id qualityBack, id sleepDurationBack) {
            @strongify(self);
            
            self.quaterReport.sleepQulityDataValues = qualityBack;
            self.quaterReport.sleepTimeDataValues = sleepDurationBack;
            NSLog(@"坐标数目%d,qulity数目%lu,duration%lu",(int)self.dayNums,(unsigned long)[(NSArray*)qualityBack count],(unsigned long)[(NSArray*)sleepDurationBack count]);
            [self.quaterReport reloadChartView];
        }];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
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
    self.noDataImageView.center = centerPoint;
    
}
@end
