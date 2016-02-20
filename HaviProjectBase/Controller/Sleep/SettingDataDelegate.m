//
//  SettingDataDelegate.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/20.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "SettingDataDelegate.h"
#import "SleepSettingCell.h"
#import "RMDateSelectionViewController.h"

@interface SettingDataDelegate ()

@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation SettingDataDelegate

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = [self.items objectAtIndex:section];
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SleepSettingCell *cell = (SleepSettingCell*)[tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    if (!cell) {
        cell = [[SleepSettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifier];
    }
    @weakify(self);
    cell.cellInfoButtonTaped = ^(UITableViewCell *cell,id item){
        @strongify(self);
        [self cellTapedButton:cell cellButton:item];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = [self itemAtIndexPath:indexPath];
    self.configureCellBlock(indexPath,item,cell);
}

#pragma mark datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = [self itemAtIndexPath:indexPath];
    return self.heightConfigureBlock(indexPath,item);
}

- (void)cellTapedButton:(UITableViewCell *)cell cellButton:(UIButton *)button
{
    NSIndexPath *index = [self.myTableView indexPathForCell:cell];
    SleepSettingType type;
    switch (index.section) {
        case 0:
        {
            type = SleepSettingStartTime;
            break;
        }
        case 1:{
            type = SleepSettingEndTime;
            break;
        }
        case 2:{
            type = SleepSettingAlertTime;
            break;
        }
        case 3:{
            type = SleepSettingLongTime;
            break;
        }
        case 4:{
            type = SleepSettingLeaveBedTime;
            break;
        }
            
        default:
            break;
    }
//    self.DidTapedButtonBlock(type,index,[self itemAtIndexPath:index]);
}

- (void)openDateSelectionController:(id)sender {
    //Create select action
    RMAction *selectAction = [RMAction actionWithTitle:@"确认" style:RMActionStyleDone andHandler:^(RMActionController *controller) {
        NSString *date = [[NSString stringWithFormat:@"%@",((UIDatePicker *)controller.contentView).date]substringToIndex:10];
    }];
    
    //Create cancel action
    RMAction *cancelAction = [RMAction actionWithTitle:@"取消" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
        
    }];
    
    RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:RMActionControllerStyleWhite];
    [dateSelectionController addAction:selectAction];
    [dateSelectionController addAction:cancelAction];
    //Create date selection view controller
    dateSelectionController.datePicker.datePickerMode = UIDatePickerModeDate;
    //Now just present the date selection controller using the standard iOS presentation method
    [self.myTableView presentViewController:dateSelectionController animated:YES completion:nil];
}

@end
