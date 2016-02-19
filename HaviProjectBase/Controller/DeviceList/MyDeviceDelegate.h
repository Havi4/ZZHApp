//
//  MyDeviceDelegate.h
//  HaviProjectBase
//
//  Created by Havi on 16/2/14.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "BaseTableViewDataDelegate.h"

@interface MyDeviceDelegate : BaseTableViewDataDelegate

@property (nonatomic, copy) void (^cellRightButtonTaped)(CellSelectType type, NSIndexPath *indexPath, id item, UITableViewCell *cell);

@end
