//
//  DataShowDataDelegate.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/23.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "CenterDataShowDataDelegate.h"
#import "CenterDataTableViewCell.h"
#import "CenterGaugeTableViewCell.h"

@interface CenterDataShowDataDelegate ()

@property (nonatomic, strong) UILabel *leftSleepTimeLabel;//睡眠时长

@end

@implementation CenterDataShowDataDelegate

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

- (UILabel *)leftSleepTimeLabel
{
    if (_leftSleepTimeLabel == nil) {
        _leftSleepTimeLabel = [[UILabel alloc]init];
        _leftSleepTimeLabel.frame = CGRectMake(0,0, kScreen_Width, 30);
        _leftSleepTimeLabel.textAlignment = NSTextAlignmentCenter;
        _leftSleepTimeLabel.dk_textColorPicker = kTextColorPicker;
        _leftSleepTimeLabel.backgroundColor = [UIColor clearColor];
        _leftSleepTimeLabel.font = [UIFont systemFontOfSize:17];
        _leftSleepTimeLabel.text = @"睡眠时长:0小时0分";
    }
    return _leftSleepTimeLabel;
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
    return self.items.count + 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<4) {
        id item = [self itemAtIndexPath:indexPath];
        CenterDataTableViewCell *cell = (CenterDataTableViewCell*)[tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
        if (!cell) {
            cell = [[CenterDataTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifier];
        }
        self.configureCellBlock(indexPath,item,cell);
        return cell;
    }else if(indexPath.row == 4){
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell addSubview:self.leftSleepTimeLabel];
        self.configureCellBlock(indexPath,self.leftSleepTimeLabel,cell);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }else {
        CenterGaugeTableViewCell *cell = (CenterGaugeTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cellGauge"];
        if (!cell) {
            cell = [[CenterGaugeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellGauge"];
        }
        self.configureCellBlock(indexPath,nil,cell);
        return cell;
    }
}

#pragma mark datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 4) {
        id item = [self itemAtIndexPath:indexPath];
        return self.heightConfigureBlock(indexPath,item);
    }else{
        return self.heightConfigureBlock(indexPath,nil);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<4) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        id item = [self itemAtIndexPath:indexPath];
        if (self.didSelectCellBlock) {
            self.didSelectCellBlock(indexPath,item);
        }
    }
}


@end
