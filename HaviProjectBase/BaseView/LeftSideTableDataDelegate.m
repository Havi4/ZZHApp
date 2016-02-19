//
//  LeftViewModel.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/4.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "LeftSideTableDataDelegate.h"
#import "LeftSideTableViewCell.h"
#import "DataShowTableViewCell.h"

@interface LeftSideTableDataDelegate ()

@end

@implementation LeftSideTableDataDelegate

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = [self itemAtIndexPath:indexPath];
    if (indexPath.row == 1) {
        DataShowTableViewCell *cell = (DataShowTableViewCell*)[tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
        if (!cell) {
            cell = [[DataShowTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifier];
        }
        self.configureCellBlock(indexPath,item,cell);
        return cell;
    }else{
        LeftSideTableViewCell *cell = (LeftSideTableViewCell*)[tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
        if (!cell) {
            cell = [[LeftSideTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifier];
        }
        self.configureCellBlock(indexPath,item,cell);
        return cell;
    }
    
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
    if (indexPath.row != 1) {
        self.didSelectCellBlock(indexPath,item);
    }
}

@end
