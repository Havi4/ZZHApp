//
//  MyDeviceDelegate.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/14.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "MyDeviceDelegate.h"
#import "MyDeviceTableViewCell.h"
#import "JAActionButton.h"

@interface MyDeviceDelegate ()<JASwipeCellDelegate>

@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation MyDeviceDelegate

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
    self.myTableView = tableView;
}

#pragma mark delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = [self itemAtIndexPath:indexPath];
    MyDeviceTableViewCell *cell = (MyDeviceTableViewCell*)[tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    if (!cell) {
        cell = [[MyDeviceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifier];
    }
    [cell addActionButtons:[self rightButtonsWithTable:tableView] withButtonWidth:kJAButtonWidth withButtonPosition:JAButtonLocationRight];
    cell.delegate = self;
    self.configureCellBlock(indexPath,item,cell);
    return cell;
}

#pragma mark datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = [self itemAtIndexPath:indexPath];
    return self.heightConfigureBlock(indexPath,item);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id item = [self itemAtIndexPath:indexPath];
    if (self.didSelectCellBlock) {
        self.didSelectCellBlock(indexPath,item);
    }
}

- (NSArray *)rightButtonsWithTable:(UITableView *)table
{
   
    @weakify(self);
    JAActionButton *button1 = [JAActionButton actionButtonWithTitle:@"删除" color:[UIColor redColor] handler:^(UIButton *actionButton, JASwipeCell*cell) {
        @strongify(self);
        [cell resetContainerView];
        NSIndexPath *indexPath = [table indexPathForCell:cell];
        self.cellRightButtonTaped(DeleteCell,indexPath,[self itemAtIndexPath:indexPath],cell);
    }];
    
    JAActionButton *button2 = [JAActionButton actionButtonWithTitle:@"命名" color:kFlagButtonColor handler:^(UIButton *actionButton, JASwipeCell*cell) {
        @strongify(self);
        [cell resetContainerView];
        NSIndexPath *indexPath = [table indexPathForCell:cell];
        self.cellRightButtonTaped(RenameCell, indexPath,[self itemAtIndexPath:indexPath],cell);
    }];
    JAActionButton *button3 = [JAActionButton actionButtonWithTitle:@"配置" color:kMoreButtonColor handler:^(UIButton *actionButton, JASwipeCell*cell) {
        @strongify(self);
        [cell resetContainerView];
        NSIndexPath *indexPath = [table indexPathForCell:cell];
        self.cellRightButtonTaped(ReactiveCell, indexPath,[self itemAtIndexPath:indexPath],cell);
    }];
    
    return @[button1, button2, button3];
}

#pragma swip cell delegate
- (void)rightMostButtonSwipeCompleted:(JASwipeCell *)cell
{
    NSIndexPath *indexPath = [self.myTableView indexPathForCell:cell];
    self.cellRightButtonTaped(DeleteCell,indexPath,[self itemAtIndexPath:indexPath],cell);
}

- (void)leftMostButtonSwipeCompleted:(JASwipeCell *)cell
{
    
}

#pragma mark - JASwipeCellDelegate methods

- (void)swipingRightForCell:(JASwipeCell *)cell
{
    NSArray *indexPaths = [self.myTableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in indexPaths) {
        JASwipeCell *visibleCell = (JASwipeCell *)[self.myTableView cellForRowAtIndexPath:indexPath];
        if (visibleCell != cell) {
            [visibleCell resetContainerView];
        }
    }
}

- (void)swipingLeftForCell:(JASwipeCell *)cell
{
    NSArray *indexPaths = [self.myTableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in indexPaths) {
        JASwipeCell *visibleCell = (JASwipeCell *)[self.myTableView cellForRowAtIndexPath:indexPath];
        if (visibleCell != cell) {
            [visibleCell resetContainerView];
        }
    }
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSArray *indexPaths = [self.sideTableView indexPathsForVisibleRows];
//    for (NSIndexPath *indexPath in indexPaths) {
//        MyDeviceListCell *cell = (MyDeviceListCell *)[self.sideTableView cellForRowAtIndexPath:indexPath];
//        [cell resetContainerView];
//    }
}


@end
