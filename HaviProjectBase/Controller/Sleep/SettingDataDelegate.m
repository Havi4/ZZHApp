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
#import "RMPickerViewController.h"
#import "JDStatusBarNotification.h"
#import "LocalNotificationManager.h"

@interface SettingDataDelegate ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSArray *sleepLeaveBedTime;

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
    
    cell.cellInfoSwitchTaped = ^(UITableViewCell *cell,id item){
        @strongify(self);
        [self cellTapedSwitch:cell cellButton:item];
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

#pragma mark switch

- (void)cellTapedSwitch:(UITableViewCell *)cell cellButton:(UISwitch *)cellSwitch
{
    NSIndexPath *index = [self.myTableView indexPathForCell:cell];
    SleepSettingButtonType type;
    switch (index.section) {
        case 2:{
            type = SleepSettingSwitchAlertTime;
            [self controlLocalNotiOpen:(cellSwitch.on ? @"True" : @"False") type:type];
            break;
        }
        case 3:{
            type = SleepSettingSwitchLongTime;
            [self changeUserSleepSettingInfo:(cellSwitch.on ? @"True" : @"False") type:type];
            break;
        }
        case 4:{
            type = SleepSettingSwitchLeaveBedTime;
            [self changeUserSleepSettingInfo:(cellSwitch.on ? @"True" : @"False") type:type];
            break;
        }
            
        default:
            break;
    }
}


#pragma mark button

- (void)cellTapedButton:(UITableViewCell *)cell cellButton:(UIButton *)button
{
    NSIndexPath *index = [self.myTableView indexPathForCell:cell];
    SleepSettingButtonType type;
    switch (index.section) {
        case 0:
        {
            type = SleepSettingStartTime;
            [self openDateSelectionController:type];
            break;
        }
        case 1:{
            type = SleepSettingEndTime;
            [self openDateSelectionController:type];
            break;
        }
        case 2:{
            type = SleepSettingAlertTime;
            [self openDateSelectionController:type];
            break;
        }
        case 3:{
            type = SleepSettingLongTime;
            [self openDateSelectionController:type];
            break;
        }
        case 4:{
            type = SleepSettingLeaveBedTime;
            [self openPickerController:SleepSettingLeaveBedTime];
            break;
        }
            
        default:
            break;
    }
}

- (void)openDateSelectionController:(SleepSettingButtonType)type {
    //Create select action
    RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:RMActionControllerStyleWhite];
    RMAction *selectAction = [RMAction actionWithTitle:@"确认" style:RMActionStyleDone andHandler:^(RMActionController *controller) {
        NSDate *date = ((UIDatePicker *)controller.contentView).date;
        switch (type) {
            case SleepSettingStartTime:
            {
                if (date.hour < 13) {
                    [dateSelectionController dismissViewControllerAnimated:YES completion:^{
                        [LBXAlertAction showAlertWithTitle:@"提示" msg:@"请选择睡眠时间大于13点" chooseBlock:^(NSInteger buttonIdx) {
                            
                        } buttonsStatement:@"我知道了",nil];
                    }];
                    break;
                }
                NSString *startTime = [NSString stringWithFormat:@"%ld:%ld",date.hour,date.minute];
                [self changeUserSleepSettingInfo:startTime type:SleepSettingStartTime];
                break;
            }
            case SleepSettingEndTime:{
                NSString *endTime = [NSString stringWithFormat:@"%ld:%ld",date.hour,date.minute];
                [self changeUserSleepSettingInfo:endTime type:SleepSettingEndTime];
                break;
            }
            case SleepSettingLongTime:{
                NSString *endTime = [NSString stringWithFormat:@"%ld",date.hour*60 + date.minute];
                [self changeUserSleepSettingInfo:endTime type:SleepSettingLongTime];
                break;
            }
            case SleepSettingAlertTime:{
                [self changeUserAlarm:date];
                break;
            }
                
            default:
                break;
        }
    }];
    
    //Create cancel action
    RMAction *cancelAction = [RMAction actionWithTitle:@"取消" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
        
    }];
    
    [dateSelectionController addAction:selectAction];
    [dateSelectionController addAction:cancelAction];
    //Create date selection view controller
    if (type == SleepSettingLongTime) {
        dateSelectionController.datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
    }else{
        dateSelectionController.datePicker.datePickerMode = UIDatePickerModeTime;
    }
    //Now just present the date selection controller using the standard iOS presentation method
    [[NSObject appRootViewController] presentViewController:dateSelectionController animated:YES completion:nil];
}

- (void)openPickerController:(SleepSettingButtonType)type {
    //Create select action
    RMAction *selectAction = [RMAction actionWithTitle:@"确认" style:RMActionStyleDone andHandler:^(RMActionController *controller) {
        UIPickerView *picker = ((RMPickerViewController *)controller).picker;
        NSMutableArray *selectedRows = [NSMutableArray array];
        for(NSInteger i=0 ; i<[picker numberOfComponents] ; i++) {
            [selectedRows addObject:@([picker selectedRowInComponent:i])];
        }
        NSInteger index = [[selectedRows objectAtIndex:0] integerValue];
        NSString *time = [self.sleepLeaveBedTime objectAtIndex:index];
        NSRange rangeMinute = [time rangeOfString:@"分钟"];
        int num=0;
        if (rangeMinute.length>0) {
            num = [[time substringToIndex:rangeMinute.location] intValue];
            num = num*60;
        }else{
            NSRange rangeMinute1 = [time rangeOfString:@"秒"];
            num = [[time substringToIndex:rangeMinute1.location] intValue];
        }
        [self changeUserSleepSettingInfo:[NSString stringWithFormat:@"%d",num] type:SleepSettingLeaveBedTime];
    }];
    
    
    RMAction *cancelAction = [RMAction actionWithTitle:@"取消" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
        NSLog(@"Row selection was canceled");
    }];
    
    //Create picker view controller
    RMPickerViewController *pickerController = [RMPickerViewController actionControllerWithStyle:RMActionControllerStyleWhite];
    [pickerController addAction:cancelAction];
    [pickerController addAction:selectAction];
    pickerController.picker.delegate = self;
    pickerController.picker.dataSource = self;
    self.sleepLeaveBedTime = @[@"5秒",@"15秒",@"30秒",@"1分钟",@"5分钟",@"10分钟",@"15分钟",];
    
    //Now just present the picker controller using the standard iOS presentation method
    [[NSObject appRootViewController] presentViewController:pickerController animated:YES completion:nil];
}

#pragma mark 控制本地通知

- (void)controlLocalNotiOpen:(NSString*)status type:(SleepSettingButtonType)type
{
    [[NSUserDefaults standardUserDefaults]setObject:status forKey:kAlarmStatusValue];
    if ([status isEqualToString:@"True"]) {
        NSDate *date = [[NSUserDefaults standardUserDefaults]objectForKey:kAlarmTimeValue];
        [self changeUserAlarm:date];
    }else{
        [[LocalNotificationManager sharedManager]cancelAllNotifications];
    }
    
}

- (void)changeUserAlarm:(NSDate *)localDate
{
    if ([localDate isEarlierThanOrEqualTo:[NSDate date]]) {
        NSInteger day = [localDate daysFrom:[NSDate date]]>0?[localDate daysFrom:[NSDate date]]:-[localDate daysFrom:[NSDate date]];
        if (day > 0) {
            localDate = [localDate dateByAddingDays:day];
        }else{
            localDate = [localDate dateByAddingDays:1];
        }
        
    }
    [[NSUserDefaults standardUserDefaults]setObject:localDate forKey:kAlarmTimeValue];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[LocalNotificationManager sharedManager]cancelAllNotifications];
    UILocalNotification *noti = [[LocalNotificationManager sharedManager] scheduleNotificationOn:localDate body:@"您有一个起床闹铃" userInfo:nil options:@{@"soundName":@"alarmSound.wav"}];
    noti.repeatInterval = kCFCalendarUnitDay;
    [self.myTableView reloadData];
    DeBugLog(@"闹铃时间是%@",localDate);
}


#pragma mark 修改用户睡眠设定

- (void)changeUserSleepSettingInfo:(NSString *)info type:(SleepSettingButtonType)type
{
    NSString *key;
    NSString *notiString;
    switch (type) {
        case SleepSettingStartTime:{
            key = @"SleepStartTime";
            notiString = @"睡觉时间修改成功";
            break;
        }
        case SleepSettingEndTime:{
            key = @"SleepEndTime";
            notiString = @"起床时间修改成功";
            break;
        }
        case SleepSettingAlertTime:{
            key = @"SleepEndTime";
            notiString = @"闹铃时间修改成功";
            break;
        }
        case SleepSettingLongTime:{
            key = @"AlarmTimeSleepTooLong";
            notiString = @"久睡超时时间修改成功";
            break;
        }
        case SleepSettingSwitchLeaveBedTime:
        {
            key = @"IsTimeoutAlarmOutOfBed";
            if ([info isEqualToString:@"True"]) {
                notiString = @"离床警报开启";
            }else{
                notiString = @"离床警报关闭";
            }
            break;
        }
        case SleepSettingSwitchLongTime:{
            key = @"IsTimeoutAlarmSleepTooLong";
            if ([info isEqualToString:@"True"]) {
                notiString = @"久睡超时警报开启";
            }else{
                notiString = @"久睡超时警报关闭";
            }
            break;
        }
            
        default:
            break;
    }
    NSDictionary *dic3 = @{
                           @"UserID":kUserID,
                           key: info, //真实姓名
                           };
    ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
    [client requestChangeUserInfoParam:dic3 andBlock:^(BaseModel *resultModel, NSError *error) {
        [JDStatusBarNotification showWithStatus:notiString dismissAfter:2 styleName:JDStatusBarStyleDark];
        if (self.didSelectCellBlock) {
            self.didSelectCellBlock(nil,nil);
        }
    }];
}



#pragma mark picker delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.sleepLeaveBedTime.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%@",[self.sleepLeaveBedTime objectAtIndex:row]];
}

@end
