//
//  BaseTableViewDataDelegate.h
//  HaviProjectBase
//
//  Created by Havi on 16/2/5.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseTableViewDataDelegate : NSObject<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) TableViewCellConfigureBlock configureCellBlock;
@property (nonatomic, copy) CellHeightBlock heightConfigureBlock;
@property (nonatomic, copy) DidSelectCellBlock didSelectCellBlock;


/**
 *  初始化viewModel
 *
 *  @param cellItems       列表内容
 *  @param cellIdentifier  reuse identifier
 *  @param cellHeightBlock height
 *  @param didSelectBlock  select
 *
 *  @return object
 */
- (id)initWithItems:(NSArray *)cellItems
     cellIdentifier:(NSString *)cellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock
    cellHeightBlock:(CellHeightBlock)cellHeightBlock
     didSelectBlock:(DidSelectCellBlock)didSelectBlock;

- (void)handleTableViewDataSourceAndDelegate:(UITableView *)tableView;

- (id)itemAtIndexPath:(NSIndexPath*)indexPath;

@end
