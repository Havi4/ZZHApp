//
//  ChartTableDataDelegate.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/26.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "ChartTableDataDelegate.h"
#import "ChartTableDataViewCell.h"
#import "ChartTableTitleView.h"

@interface ChartTableDataDelegate ()

@property (nonatomic, strong) ChartTableTitleView *titleView;

@end

@implementation ChartTableDataDelegate

- (id)initWithItems:(NSArray *)cellItems cellIdentifier:(NSString *)cellIdentifier configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock cellHeightBlock:(CellHeightBlock)cellHeightBlock didSelectBlock:(DidSelectCellBlock)didSelectBlock
{
    self = [super init];
    if (self) {
        self.items = cellItems;
        self.cellIdentifier = cellIdentifier;
        self.configureCellBlock = configureCellBlock;
        self.heightConfigureBlock = cellHeightBlock;
        self.didSelectCellBlock = didSelectBlock;
    }
    return self;
}

- (void)handleTableViewDataSourceAndDelegate:(UITableView *)tableView
{
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableHeaderView = self.titleView;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.items objectAtIndex:indexPath.row];
}

- (ChartTableTitleView*)titleView
{
    if (!_titleView) {
        _titleView = [[ChartTableTitleView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 188)];
    }
    return _titleView;
}

#pragma mark delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = [self itemAtIndexPath:indexPath];
    ChartTableDataViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    if (!cell) {
        cell = [[ChartTableDataViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifier];
    }
    self.configureCellBlock(indexPath,item,cell);
    return cell;
}

#pragma mark datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.heightConfigureBlock(indexPath,nil);
}

- (void)reloadTableViewHeaderWith:(id)data withType:(SensorDataType)type{
    [self.titleView reloadTableViewHeaderWith:data withType:type];
}

@end
