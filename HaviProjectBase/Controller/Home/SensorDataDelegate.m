//
//  SensorDataDelegate.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/25.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "SensorDataDelegate.h"
#import "SensorTitleTableViewCell.h"
#import "SensorChartTableViewCell.h"
#import "SensorSleepDurationCell.h"
#import "SensorReportTableViewCell.h"

@interface SensorDataDelegate ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SensorDataDelegate

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
    return [[self.items objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
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
    if (section==0) {
        return 2;
    }else if (section==1) {
        return 5;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0.001;
    }else{
        return 30;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            SensorTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellTitle"];
            if (cell == nil) {
                cell = [[SensorTitleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellTitle"];
            }
            self.configureCellBlock(indexPath,nil,cell);
            return cell;
        }else{
            SensorChartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellChart"];
            if (cell == nil) {
                cell = [[SensorChartTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellChart"];
            }
            self.configureCellBlock(indexPath,nil,cell);
            return cell;
        }
    }else{
        if (indexPath.row == 0) {
            static NSString *cellIndentifier = @"cell2";
            UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
                
            }
            cell.textLabel.font = [UIFont systemFontOfSize:18];
            cell.dk_backgroundColorPicker = DKColorWithColors([UIColor colorWithRed:0.059f green:0.141f blue:0.231f alpha:1.00f], [UIColor colorWithRed:0.475f green:0.686f blue:0.820f alpha:1.00f]);
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.dk_textColorPicker = kTextColorPicker;
            UIView *lineViewBottom = [[UIView alloc]init];
            lineViewBottom.dk_backgroundColorPicker = DKColorWithColors([UIColor colorWithRed:0.161f green:0.251f blue:0.365f alpha:1.00f], [UIColor colorWithRed:0.349f green:0.608f blue:0.780f alpha:1.00f]);
            [cell addSubview:lineViewBottom];
            [lineViewBottom makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.mas_bottom).offset(-0.5);
                make.height.equalTo(@0.5);
                make.width.equalTo(cell.mas_width);
            }];
            self.configureCellBlock(indexPath,nil,cell);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if(indexPath.row == 1){
            SensorSleepDurationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellDuration"];
            if (cell == nil) {
                cell = [[SensorSleepDurationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellDuration"];
            }
            self.configureCellBlock(indexPath,nil,cell);
            return cell;
        }else{
            SensorReportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellReport"];
            if (cell == nil) {
                cell = [[SensorReportTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellReport"];
            }
            self.configureCellBlock(indexPath,nil,cell);
            return cell;
        }
        
    }
    return nil;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 30)];
    view.dk_backgroundColorPicker = DKColorWithColors([UIColor colorWithRed:0.012f green:0.082f blue:0.184f alpha:1.00f], [UIColor colorWithRed:0.349f green:0.608f blue:0.780f alpha:1.00f]);
    return view;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 30)];
    view.dk_backgroundColorPicker = DKColorWithColors([UIColor colorWithRed:0.012f green:0.082f blue:0.184f alpha:1.00f], [UIColor colorWithRed:0.349f green:0.608f blue:0.780f alpha:1.00f]);
    return view;
}

#pragma mark datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row==0) {
            return 60;
        }else{
            return 180;
        }
    }else {
        return 60;
    }
}

@end
