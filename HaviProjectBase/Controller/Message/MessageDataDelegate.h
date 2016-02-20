//
//  MessageDataDelegate.h
//  HaviProjectBase
//
//  Created by Havi on 16/2/19.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "BaseTableViewDataDelegate.h"

@interface MessageDataDelegate : BaseTableViewDataDelegate

@property (nonatomic, copy) void (^cellReplayButtonTaped)(MessageType type, NSIndexPath *indexPath, id item, UITableViewCell *cell);

@end
