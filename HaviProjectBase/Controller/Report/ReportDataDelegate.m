//
//  ReportDataDelegate.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/26.
//  Copyright © 2016年 Havi. All rights reserved.
//


#import "ReportDataDelegate.h"
#import "CalendarShowView.h"
#import "ReportChartTableCell.h"
#import "ReportTableViewCell.h"
#import "ReportDataTableViewCell.h"
#import "ReportSleepViewCell.h"

@interface ReportDataDelegate ()

@property (nonatomic, strong) CalendarShowView *calendarBackView;
@property (nonatomic, assign) ReportViewType type;
@property (nonatomic, assign) float headerHeight;

@end

@implementation ReportDataDelegate

- (id)initWithItems:(NSArray *)cellItems cellIdentifier:(NSString *)cellIdentifier configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock cellHeightBlock:(CellHeightBlock)cellHeightBlock didSelectBlock:(DidSelectCellBlock)didSelectBlock
{
    self = [super init];
    if (self) {
        self.items = cellItems;
        self.cellIdentifier = cellIdentifier;
        self.configureCellBlock = configureCellBlock;
        self.heightConfigureBlock = cellHeightBlock;
        self.didSelectCellBlock = didSelectBlock;
        self.headerHeight = 105;
    }
    return self;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.items objectAtIndex:indexPath.row];
}

- (void)handleTableViewDataSourceAndDelegate:(UITableView *)tableView withReportType:(ReportViewType)type
{
    tableView.delegate = self;
    tableView.dataSource = self;
    self.type = type;
}

- (CalendarShowView*)calendarBackView
{
    if (!_calendarBackView) {
        
        _calendarBackView = [[CalendarShowView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, self.headerHeight) withReportType:self.type];
        @weakify(self);
        _calendarBackView.selectDateBlock = ^(NSString *fromDate,NSString *endDate){
            @strongify(self);
            [self selectDateFrom:fromDate dateEnd:endDate];
        };
    }
    return _calendarBackView;
}

#pragma mark delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }else if (section==1) {
        return 1;
    }else{
        return 1;
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return self.headerHeight;
    
    }else{
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==2) {
        return 0.01;
    }else{
        return 0.01;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return self.calendarBackView;
    }else{
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 0.1)];
        view.backgroundColor = [UIColor colorWithRed:0.980 green:0.984 blue:0.988 alpha:1.00];
        return view;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 0.1)];
    view.backgroundColor = [UIColor colorWithRed:0.980 green:0.984 blue:0.988 alpha:1.00];
    return view;
}

#pragma mark datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 205;
    }else {
        return 135;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ReportChartTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellChart"];
        if (!cell) {
            cell = [[ReportChartTableCell alloc]initWithStyle:UITableViewCellStyleDefault withReportType:self.type reuseIdentifier:@"cellChart"];
        }
        self.configureCellBlock(indexPath,nil,cell);
        return cell;
    }else if (indexPath.section == 1){
        id item = [self.items objectAtIndex:indexPath.section-1];
        if (indexPath.row == 0) {
            static NSString *cellIndentifier = @"cellOne";
            ReportTableViewCell *cell = (ReportTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (!cell) {
                cell = [[ReportTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
                
            }
            self.configureCellBlock(indexPath,item,cell);
            return cell;
        }else{
            NSString *cellIndentifier = [NSString stringWithFormat:@"cellTwo"];
            ReportDataTableViewCell *cell = (ReportDataTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (!cell) {
                cell = [[ReportDataTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
                
            }
            self.configureCellBlock(indexPath,item,cell);
            return cell;
        }
        
    }else{
        if (indexPath.row == 0) {
            id item = [self.items objectAtIndex:indexPath.section-1];
            static NSString *cellIndentifier = @"cellOne";
            ReportTableViewCell *cell = (ReportTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (!cell) {
                cell = [[ReportTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
                
            }
            self.configureCellBlock(indexPath,item,cell);
            return cell;
        }else{
            static NSString *cellIndentifier = @"cellSleep";
            ReportSleepViewCell *cell = (ReportSleepViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (!cell) {
                cell = [[ReportSleepViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
                
            }
            self.configureCellBlock(indexPath,nil,cell);
            return cell;
        }
    }
}

- (void)selectDateFrom:(NSString *)dateFrom dateEnd:(NSString *)dateEnd
{
    self.selectDateFromCalendar(dateFrom,dateEnd);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {    
    if (scrollView.contentSize.height>scrollView.frame.size.height&&scrollView.contentOffset.y>0) {
        if (scrollView.contentSize.height-scrollView.contentOffset.y < scrollView.frame.size.height) {
            scrollView.contentOffset = CGPointMake(0, scrollView.contentSize.height - scrollView.frame.size.height);
            return;
        }
    }
    if (scrollView.contentSize.height<scrollView.frame.size.height) {
        scrollView.contentOffset = CGPointMake(0, 0);
        return;
    }
    
}

- (void)reloadHeader:(id)data
{
    [self.calendarBackView reloadSleepDuration:data];
}

@end
