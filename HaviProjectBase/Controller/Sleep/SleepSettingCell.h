//
//  SleepSettingCell.h
//  HaviProjectBase
//
//  Created by Havi on 16/2/20.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "HaviBaseTableViewCell.h"

@interface SleepSettingCell : HaviBaseTableViewCell

@property (nonatomic, copy) void (^cellInfoButtonTaped)(UITableViewCell *cell,id item);

@property (nonatomic, copy) void (^cellInfoSwitchTaped)(UITableViewCell *cell,id item);

@end
