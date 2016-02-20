//
//  MessageDataDelegate.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/19.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "MessageDataDelegate.h"
#import "MessageShowTableViewCell.h"

@interface MessageDataDelegate ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MessageDataDelegate

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
    MessageShowTableViewCell *cell = (MessageShowTableViewCell*)[tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    if (!cell) {
        cell = [[MessageShowTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifier];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = [self itemAtIndexPath:indexPath];
    MessageShowTableViewCell *messageCell = (MessageShowTableViewCell *)cell;
    @weakify(self);
    messageCell.tapMessageButton = ^(MessageType type,UITableViewCell *cell,NSIndexPath *index){
        @strongify(self);
        [self replayMessage:type cell:cell index:indexPath];
    };
    self.configureCellBlock(indexPath,item,cell);
}

#pragma mark datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = [self itemAtIndexPath:indexPath];
    return self.heightConfigureBlock(indexPath,item);
}

- (void)replayMessage:(MessageType)type cell:(UITableViewCell*)cell index:(NSIndexPath *)index
{
    if (self.cellReplayButtonTaped) {
        self.cellReplayButtonTaped(type,index,[self itemAtIndexPath:index],cell);
    }
}

@end
