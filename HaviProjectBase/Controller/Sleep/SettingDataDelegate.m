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
#import "CalendarDateCaculate.h"

@interface SettingDataDelegate ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSArray *sleepLeaveBedTime;
@property (nonatomic, strong) NSArray *hourArr;
@property (nonatomic, strong) NSArray *minuteArr;
@property (nonatomic, assign) NSInteger zeroLastRow;
@property (nonatomic, assign) NSInteger oneLastRow;
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
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    NSString *title = [self.items objectAtIndex:section];
//    return title;
//}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc]init];
    footerView.frame = (CGRect){0,0,kScreenSize.width,20};
    UILabel *title = [[UILabel alloc]init];
    title.font = [UIFont systemFontOfSize:13];
    title.textColor = [UIColor grayColor];
    title.frame = (CGRect){16,0,200,20};
    
    title.text = [self.items objectAtIndex:section];
    [footerView addSubview:title];
    UIView *line = [[UIView alloc]init];
    line.frame = (CGRect){0,19.5,kScreenSize.width,0.5};
    line.backgroundColor = [UIColor grayColor];
    [footerView addSubview:line];
    return footerView;
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
        case 4:{
            type = SleepSettingSwitchAlertTime;
            [self controlLocalNotiOpen:(cellSwitch.on ? @"True" : @"False") type:type];
            break;
        }
        case 2:{
            type = SleepSettingSwitchLongTime;
//            [self changeUserSleepSettingInfo:(cellSwitch.on ? @"True" : @"False") type:type];
            if (cellSwitch.on) {
                [self openPickerController:SleepSettingLongTime];
            }else{
                [self changeUserSleepSettingInfo:(cellSwitch.on ? @"True" : @"False") type:type];
            }
            break;
        }
        case 3:{
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
            [self openDateSelectionController:type withSwitch:nil];
            break;
        }
        case 1:{
            type = SleepSettingEndTime;
            [self openDateSelectionController:type withSwitch:nil];
            break;
        }
        case 4:{
            type = SleepSettingAlertTime;
            [self openDateSelectionController:type withSwitch:nil];
            break;
        }
        case 2:{
            type = SleepSettingLongTime;
//            [self openDateSelectionController:SleepSettingLongTime withSwitch:nil];
            [self openPickerController:SleepSettingLongTime];
            break;
        }
        case 3:{
            type = SleepSettingLeaveBedTime;
            [self openPickerController:SleepSettingLeaveBedTime];
            break;
        }
            
        default:
            break;
    }
}

- (void)openDateSelectionController:(SleepSettingButtonType)type withSwitch:(UISwitch *)fswitch {
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
                NSString *startTime = [NSString stringWithFormat:@"%@:%@",(date.hour > 10?[NSString stringWithFormat:@"%d",(int)date.hour]:[NSString stringWithFormat:@"0%d",(int)date.hour]),(date.minute > 10?[NSString stringWithFormat:@"%d",(int)date.minute]:[NSString stringWithFormat:@"0%d",(int)date.minute])];
                [self changeUserSleepSettingInfo:startTime type:SleepSettingStartTime];
                [[NSUserDefaults standardUserDefaults]setObject:date forKey:@"userSleepStart"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                break;
            }
            case SleepSettingEndTime:{
                NSString *endTime = [NSString stringWithFormat:@"%@:%@",(date.hour > 10?[NSString stringWithFormat:@"%d",(int)date.hour]:[NSString stringWithFormat:@"0%d",(int)date.hour]),(date.minute > 10?[NSString stringWithFormat:@"%d",(int)date.minute]:[NSString stringWithFormat:@"0%d",(int)date.minute])];
                [self changeUserSleepSettingInfo:endTime type:SleepSettingEndTime];
                [[NSUserDefaults standardUserDefaults]setObject:date forKey:@"userSleepEnd"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                break;
            }
            case SleepSettingLongTime:{
                NSString *endTime = [NSString stringWithFormat:@"%ld",date.hour*60 + date.minute];
                [self changeUserLongSettingInfo:@"True" type:type];
                [self changeUserSleepSettingInfo:endTime type:SleepSettingLongTime];
                [[NSUserDefaults standardUserDefaults]setObject:date forKey:@"userLongDate"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                break;
            }
            case SleepSettingAlertTime:{
                [[NSUserDefaults standardUserDefaults]setObject:date forKey:@"userAlert"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [self changeUserAlarm:date];
                break;
            }
                
            default:
                break;
        }
    }];
    
    //Create cancel action
    RMAction *cancelAction = [RMAction actionWithTitle:@"取消" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
        NSString *time = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@:time",thirdPartyLoginUserId]];
        if ([time isEqualToString:@"0分钟"]) {
            fswitch.on = NO;
            [self changeUserLongSettingInfo:@"False" type:type];
            [NSObject showHudTipStr:@"请选择正确的防护时间"];
//            [self changeUserSleepSettingInfo:(cellSwitch.on ? @"True" : @"False") type:type];
//            [self openDateSelectionController:SleepSettingLongTime];
        }
    }];
    
    [dateSelectionController addAction:selectAction];
    [dateSelectionController addAction:cancelAction];
    //Create date selection view controller
    if (type == SleepSettingLongTime) {
        dateSelectionController.datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userLongDate"]) {
            dateSelectionController.datePicker.date = [[NSUserDefaults standardUserDefaults]objectForKey:@"userLongDate"];
        }
    }else if(type == SleepSettingStartTime){
        dateSelectionController.datePicker.datePickerMode = UIDatePickerModeTime;
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userSleepStart"]) {
            dateSelectionController.datePicker.date = [[NSUserDefaults standardUserDefaults]objectForKey:@"userSleepStart"];
        }
    }else if(type == SleepSettingEndTime){
        dateSelectionController.datePicker.datePickerMode = UIDatePickerModeTime;
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userSleepEnd"]) {
            dateSelectionController.datePicker.date = [[NSUserDefaults standardUserDefaults]objectForKey:@"userSleepEnd"];
        }
    }else if(type == SleepSettingAlertTime){
        dateSelectionController.datePicker.datePickerMode = UIDatePickerModeTime;
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userAlert"]) {
            dateSelectionController.datePicker.date = [[NSUserDefaults standardUserDefaults]objectForKey:@"userAlert"];
        }
    }
    //Now just present the date selection controller using the standard iOS presentation method
    [[NSObject appNaviRootViewController] presentViewController:dateSelectionController animated:YES completion:nil];
}

- (void)openPickerController:(SleepSettingButtonType)type {
    //Create select action
    if (type == SleepSettingLeaveBedTime) {
        
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
        pickerController.picker.tag = 0;
        pickerController.picker.delegate = self;
        pickerController.picker.dataSource = self;
        self.sleepLeaveBedTime = @[@"5秒",@"15秒",@"30秒",@"1分钟",@"5分钟",@"10分钟",@"15分钟"];
        int time = [self.userInfo.nUserInfo.alarmTimeOutOfBed intValue];
        NSString *cellString = @"";
        if (time > 60 || time == 60) {
            cellString = [NSString stringWithFormat:@"%d分钟",time/60];
            
        }else{
            cellString = [NSString stringWithFormat:@"%d秒",time];
        }
        if ([self.sleepLeaveBedTime containsObject:cellString]) {
            NSUInteger index = [self.sleepLeaveBedTime indexOfObject:cellString];
            [pickerController.picker selectRow:index inComponent:0 animated:NO];
        }
        
        //Now just present the picker controller using the standard iOS presentation method
        [[NSObject appNaviRootViewController] presentViewController:pickerController animated:YES completion:nil];
    }else{//防护警告
        RMAction *selectAction = [RMAction actionWithTitle:@"确认" style:RMActionStyleDone andHandler:^(RMActionController *controller) {
            UIPickerView *picker = ((RMPickerViewController *)controller).picker;
            NSMutableArray *selectedRows = [NSMutableArray array];
            for(NSInteger i=0 ; i<[picker numberOfComponents] ; i++) {
                [selectedRows addObject:@([picker selectedRowInComponent:i])];
            }
            NSInteger leftindex = [[selectedRows objectAtIndex:0] integerValue];
            NSString *lefttime = [self.hourArr objectAtIndex:leftindex];
            NSInteger rightindex = [[selectedRows objectAtIndex:1] integerValue];
            NSString *righttime = [self.minuteArr objectAtIndex:rightindex];
            NSRange rangeMinute = [lefttime rangeOfString:@"小时"];
            int num=0;
            if (rangeMinute.length>0) {
                num = [[lefttime substringToIndex:rangeMinute.location] intValue];
                num = num*60;
            }
             NSRange rangeMinute1 = [righttime rangeOfString:@"分钟"];
            num += [[righttime substringToIndex:rangeMinute1.location] intValue];
            
            [self changeUserLongSettingInfo:@"True" type:type];
            [self changeUserSleepSettingInfo:[NSString stringWithFormat:@"%d",num] type:SleepSettingLongTime];
        }];
        
        
        RMAction *cancelAction = [RMAction actionWithTitle:@"取消" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
            NSLog(@"Row selection was canceled");
            NSString *time = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@:time",thirdPartyLoginUserId]];
            if ([time isEqualToString:@"0分钟"]) {
                [self changeUserLongSettingInfo:@"False" type:type];
                [NSObject showHudTipStr:@"请选择正确的防护时间"];
                //            [self changeUserSleepSettingInfo:(cellSwitch.on ? @"True" : @"False") type:type];
                //            [self openDateSelectionController:SleepSettingLongTime];
            }
        }];
        
        //Create picker view controller
        RMPickerViewController *pickerController = [RMPickerViewController actionControllerWithStyle:RMActionControllerStyleWhite];
        [pickerController addAction:cancelAction];
        [pickerController addAction:selectAction];
        pickerController.picker.tag = 1;
        pickerController.picker.delegate = self;
        pickerController.picker.dataSource = self;
        self.hourArr = @[@"0小时",@"1小时",@"2小时",@"3小时",@"4小时",@"5小时",@"6小时",@"7小时",@"8小时",@"9小时",@"10小时",@"11小时",@"12小时",@"13小时",@"14小时",@"15小时",@"16小时",@"17小时",@"18小时",@"19小时",@"20小时",@"21小时",@"22小时",@"23小时"];
        self.minuteArr = @[@"0分钟",@"15分钟",@"30分钟",@"45分钟"];
//        int time = [self.userInfo.nUserInfo.alarmTimeSleepTooLong intValue];
//        NSString *cellString = @"";
//        if (time > 60 || time == 60) {
//            cellString = [NSString stringWithFormat:@"%d分钟",time/60];
//            
//        }else{
//            cellString = [NSString stringWithFormat:@"%d秒",time];
//        }
//        if ([self.sleepLeaveBedTime containsObject:cellString]) {
//            NSUInteger index = [self.sleepLeaveBedTime indexOfObject:cellString];
//        }
        [pickerController.picker selectRow:1 inComponent:0 animated:NO];
        
        //Now just present the picker controller using the standard iOS presentation method
        [[NSObject appNaviRootViewController] presentViewController:pickerController animated:YES completion:nil];
    }
}

#pragma mark 控制本地通知

- (void)controlLocalNotiOpen:(NSString*)status type:(SleepSettingButtonType)type
{
    [[NSUserDefaults standardUserDefaults]setObject:status forKey:kAlarmStatusValue];
    if ([status isEqualToString:@"True"]) {
        id date = [[NSUserDefaults standardUserDefaults]objectForKey:kAlarmTimeValue];
        if ([date isKindOfClass:[NSDate class]]) {
            [self changeUserAlarm:date];
        }else{
            NSString *dateString = [NSString stringWithFormat:@"%@",[NSDate date]];
            NSString *new = [NSString stringWithFormat:@"%@ %@",[dateString substringToIndex:10],date];
            NSDate *dat = [[[CalendarDateCaculate sharedInstance] dateFormmatterOne]dateFromString:new];
            [self changeUserAlarm:dat];
        }
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

- (void)changeUserLongSettingInfo:(NSString *)info type:(SleepSettingButtonType)type{
    NSDictionary *dic3 = @{
                           @"UserID":thirdPartyLoginUserId,
                           @"IsTimeoutAlarmSleepTooLong": info, //真实姓名
                           };
    ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
    [client requestChangeUserInfoParam:dic3 andBlock:^(BaseModel *resultModel, NSError *error) {
//        [JDStatusBarNotification showWithStatus:@"褥疮防护提醒开启" dismissAfter:2 styleName:JDStatusBarStyleDark];
        if (self.didSelectCellBlock) {
            self.didSelectCellBlock(nil,nil);
        }
    }];

}

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
            notiString = @"褥疮防护提醒修改成功";
            break;
        }
        case SleepSettingLeaveBedTime:{
            key = @"AlarmTimeOutOfBed";
            notiString = @"离床超时提醒修改成功";
            break;
        }
        case SleepSettingSwitchLeaveBedTime:
        {
            key = @"IsTimeoutAlarmOutOfBed";
            if ([info isEqualToString:@"True"]) {
                notiString = @"离床超时提醒开启";
                [self openPickerController:SleepSettingLeaveBedTime];
            }else{
                notiString = @"离床超时提醒关闭";
            }
            break;
        }
        case SleepSettingSwitchLongTime:{
            key = @"IsTimeoutAlarmSleepTooLong";
            if ([info isEqualToString:@"True"]) {
                notiString = @"褥疮防护提醒开启";
                [self openPickerController:SleepSettingLongTime];
//                [self openDateSelectionController:SleepSettingLongTime withSwitch:nil];
            }else{
                notiString = @"褥疮防护提醒关闭";
            }
            break;
        }
            
        default:
            break;
    }
    NSDictionary *dic3 = @{
                           @"UserID":thirdPartyLoginUserId,
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
    if (pickerView.tag == 0) {
        return 1;
    }else{
        return 2;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 0) {
        return self.sleepLeaveBedTime.count;
    }else{
        if (component == 0) {
            return self.hourArr.count;
        }else{
            return self.minuteArr.count;
        }
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 0) {
    
        return [NSString stringWithFormat:@"%@",[self.sleepLeaveBedTime objectAtIndex:row]];
    }else{
        if (component ==0) {
            return [NSString stringWithFormat:@"%@",[self.hourArr objectAtIndex:row]];
        }else{
            return [NSString stringWithFormat:@"%@",[self.minuteArr objectAtIndex:row]];
        }
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 1) {
    
        if (component == 0) {
            if (row == 0 && self.oneLastRow==0) {
                [pickerView selectRow:1 inComponent:1 animated:YES];
            }
            
            self.zeroLastRow = row;
        }else if (component == 1){
            if (row == 0 && self.zeroLastRow == 0) {
                [pickerView selectRow:1 inComponent:0 animated:YES];
            }
            self.oneLastRow = row;
        }
    }
}



@end
