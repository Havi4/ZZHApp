//
//  FriendDeviceDelegate.h
//  HaviProjectBase
//
//  Created by Havi on 16/2/17.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "BaseTableViewDataDelegate.h"

@interface FriendDeviceDelegate : BaseTableViewDataDelegate

@property (nonatomic, copy) void (^cellRightButtonTaped)(CellSelectType type, NSIndexPath *indexPath, id item, UITableViewCell *cell);

@end
