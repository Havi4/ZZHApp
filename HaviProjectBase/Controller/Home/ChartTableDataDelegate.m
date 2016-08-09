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
#import "ZZHPieView.h"

@interface ChartTableDataDelegate ()

@property (nonatomic, strong) ChartTableTitleView *titleView;


@property (nonatomic, strong) ZZHPieView *pieView;

@end

@implementation ChartTableDataDelegate

- (id)initWithItems:(NSArray *)cellItems cellIdentifier:(NSString *)cellIdentifier configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock cellHeightBlock:(CellHeightBlock)cellHeightBlock didSelectBlock:(DidSelectCellBlock)didSelectBlock
{
    self = [super init];
    if (self) {
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
    if (self.type == SensorDataLeave) {
        tableView.tableHeaderView = self.pieView;
    }else if (self.type == SensorDataTurn){
        tableView.tableHeaderView = self.titleView;
    }
    
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.items objectAtIndex:indexPath.row];
}

- (ZZHPieView *)pieView
{
    if (!_pieView) {
        _pieView = [[ZZHPieView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.width)];
//        _pieView.backgroundColor = [UIColor redColor];
    }
    return _pieView;
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
    if (self.type == SensorDataLeave) {
        return 2;
    }else if (self.type == SensorDataTurn){
        return 2;
    }
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
    if (self.type == SensorDataLeave) {
        if (indexPath.row == 0) {
            static NSString *cellIndentifier = @"cell2";
            UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
                
            }
            cell.textLabel.font = [UIFont systemFontOfSize:18];
            cell.dk_backgroundColorPicker = DKColorWithColors([UIColor clearColor], [UIColor clearColor]);
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.dk_textColorPicker = kTextColorPicker;
            UIView *lineViewBottom = [[UIView alloc]init];
            lineViewBottom.dk_backgroundColorPicker = DKColorWithColors([UIColor colorWithRed:0.627 green:0.847 blue:0.890 alpha:1.00], [UIColor colorWithRed:0.627 green:0.847 blue:0.890 alpha:1.00]);
            [cell addSubview:lineViewBottom];
            [lineViewBottom makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.textLabel.mas_baseline).offset(-15);
                make.height.equalTo(@0.5);
                make.centerX.equalTo(cell.mas_centerX);
                make.width.equalTo(@70);
            }];
            self.configureCellBlock(indexPath,nil,cell);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            ChartTableDataViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
            if (!cell) {
                cell = [[ChartTableDataViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifier];
            }
            self.configureCellBlock(indexPath,nil,cell);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }else{
        id item = [self itemAtIndexPath:indexPath];
        ChartTableDataViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
        if (!cell) {
            cell = [[ChartTableDataViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifier];
        }
        self.configureCellBlock(indexPath,item,cell);
        return cell;
    }
    
}

#pragma mark datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.heightConfigureBlock(indexPath,nil);
}

- (void)reloadTableViewHeaderWith:(id)data withType:(SensorDataType)type{
    [self.pieView reloadTableViewHeaderWith:data withType:type];
}

- (void)reloadTableViewWith:(id)data withType:(SensorDataType)type
{
    [self.pieView reloadTableViewWith:data withType:type];
}

@end
