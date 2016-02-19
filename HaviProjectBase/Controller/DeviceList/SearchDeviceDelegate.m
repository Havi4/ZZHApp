//
//  SearchDevice.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/18.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "SearchDeviceDelegate.h"
#import "SearchUserTableViewCell.h"

@interface SearchDeviceDelegate ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SearchDeviceDelegate

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

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.items objectAtIndex:indexPath.row];
}

- (void)handleTableViewDataSourceAndDelegate:(UITableView *)tableView
{
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
}

#pragma mark delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
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
    SearchUserTableViewCell *cell = (SearchUserTableViewCell*)[tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    if (!cell) {
        cell = [[SearchUserTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifier];
    }
    self.configureCellBlock(indexPath,item,cell);
    @weakify(self);
    cell.sendMessageTaped = ^(UITableViewCell *cell ,NSString *commendString){
        @strongify(self);
        [self didSelectedButton:cell andCommend:commendString];
    };
    return cell;
}

#pragma mark datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = [self itemAtIndexPath:indexPath];
    return self.heightConfigureBlock(indexPath,item);
}

- (void)didSelectedButton:(UITableViewCell *)cell andCommend:(NSString *)string
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (self.didSelectCellBlock) {
        self.didSelectCellBlock(indexPath,string);
    }
}

@end
