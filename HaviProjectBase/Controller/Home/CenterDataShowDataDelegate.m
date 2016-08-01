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
#import "RMDateSelectionViewController.h"
#import "CenterSubTableViewCell.h"

@interface CenterDataShowDataDelegate ()

@property (nonatomic, strong) UILabel *leftSleepTimeLabel;//睡眠时长
@property (nonatomic, strong) UIButton *iWantSleepLabel;

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

- (UIButton *)iWantSleepLabel
{
    if (_iWantSleepLabel==nil) {
        _iWantSleepLabel = [[UIButton alloc]init];
        _iWantSleepLabel.frame = CGRectMake((kScreen_Width-90)/2, 14, 90,25);
        [_iWantSleepLabel setTitle:@"我要睡觉" forState:UIControlStateNormal];
        [_iWantSleepLabel dk_setBackgroundImage:DKImageWithNames(@"btn_textbox_0", @"btn_textbox_1") forState:UIControlStateNormal];
        [_iWantSleepLabel dk_setTitleColorPicker:DKColorWithColors([UIColor colorWithRed:0.000f green:0.859f blue:0.573f alpha:1.00f], [UIColor whiteColor]) forState:UIControlStateNormal];
        [_iWantSleepLabel.titleLabel setFont:[UIFont systemFontOfSize:15]];
    }
    return _iWantSleepLabel;
}


- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row>0 && indexPath.row < 3) {
        NSInteger row = indexPath.row;
        return [self.items objectAtIndex:row-1];
    }
    return nil;
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
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        CenterGaugeTableViewCell *cell = (CenterGaugeTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cellGauge"];
        if (!cell) {
            cell = [[CenterGaugeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellGauge"];
        }
        self.configureCellBlock(indexPath,nil,cell);
        @weakify(self);
        cell.cellClockTaped = ^(id index){
            @strongify(self);
            [self cellIconSelected];
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }else if (indexPath.row == 1 || indexPath.row ==2){
        id item = [self itemAtIndexPath:indexPath];
        CenterDataTableViewCell *cell = (CenterDataTableViewCell*)[tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
        if (!cell) {
            cell = [[CenterDataTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifier];
        }
        if (indexPath.row==2) {
            UITableView *line = [cell viewWithTag:101];
            line.hidden = YES;
        }
        self.configureCellBlock(indexPath,item,cell);
        return cell;

    }else{
        id item = [self itemAtIndexPath:indexPath];
        CenterSubTableViewCell*cell = (CenterSubTableViewCell*)[tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
        if (!cell) {
            cell = [[CenterSubTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifier];
        }
//        self.configureCellBlock(indexPath,item,cell);
        return cell;
    }
    return nil;
//    if (indexPath.row<4) {
//    }else if(indexPath.row == 4){
//        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellOne"];
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellOne"];
//        }
//        [cell addSubview:self.leftSleepTimeLabel];
//        self.configureCellBlock(indexPath,self.leftSleepTimeLabel,cell);
    
//        cell.backgroundColor = [UIColor clearColor];
//        return cell;
//    }else if(indexPath.row == 5){
//    }else{
//        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellFive"];
//        if (!cell) {
//            cell = [[CenterGaugeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellFive"];
//        }
//        if ((selectedDateToUse.year == [NSDate date].year)&&(selectedDateToUse.month == [NSDate date].month)&&(selectedDateToUse.day == [NSDate date].day) ) {
//            [cell addSubview:self.iWantSleepLabel];
//            self.configureCellBlock(indexPath,self.iWantSleepLabel,cell);
//        }else{
//            self.configureCellBlock(indexPath,nil,cell);
//        }
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.backgroundColor = [UIColor clearColor];
//        return cell;
//    }
}

#pragma mark datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 4) {
        id item = [self itemAtIndexPath:indexPath];
        return self.heightConfigureBlock(indexPath,item);
    }else {
        return self.heightConfigureBlock(indexPath,nil);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row ==0) {
        if (self.didSelectCellBlock) {
            self.didSelectCellBlock(indexPath,nil);
        }

    }
//    if (indexPath.row<4) {
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];
//        id item = [self itemAtIndexPath:indexPath];
//        if (self.didSelectCellBlock) {
//            self.didSelectCellBlock(indexPath,item);
//        }
//    }
}

- (void)cellIconSelected
{
    if (self.didSelectCellBlock) {
        self.didSelectCellBlock([NSIndexPath indexPathForRow:0 inSection:0],nil);
    }
    /*
    RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:RMActionControllerStyleWhite];
    @weakify(self);
    RMAction *selectAction = [RMAction actionWithTitle:@"确认" style:RMActionStyleDone andHandler:^(RMActionController *controller) {
        NSDate *date = ((UIDatePicker *)controller.contentView).date;
        @strongify(self);
        if (self.cellSelectedTaped) {
            self.cellSelectedTaped(date,cellTapEndTime);
        }
    }];
    
    //Create cancel action
    RMAction *cancelAction = [RMAction actionWithTitle:@"取消" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
        
    }];
    
    [dateSelectionController addAction:selectAction];
    [dateSelectionController addAction:cancelAction];
    dateSelectionController.datePicker.datePickerMode = UIDatePickerModeTime;
    [[NSObject appNaviRootViewController] presentViewController:dateSelectionController animated:YES completion:nil];
     */
}

@end
