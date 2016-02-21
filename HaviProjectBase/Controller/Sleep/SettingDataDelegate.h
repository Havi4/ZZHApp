//
//  SettingDataDelegate.h
//  HaviProjectBase
//
//  Created by Havi on 16/2/20.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "BaseTableViewDataDelegate.h"

@interface SettingDataDelegate : BaseTableViewDataDelegate

@property (nonatomic, copy) void (^DidTapedButtonBlock)(SleepSettingButtonType type,NSIndexPath *indexPath,id item);

@end
