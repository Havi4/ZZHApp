//
//  MessageShowTableViewCell.h
//  SleepRecoding
//
//  Created by Havi on 15/11/11.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewDataDelegate.h"
#import "HaviBaseTableViewCell.h"

@interface MessageShowTableViewCell : HaviBaseTableViewCell

@property (nonatomic, copy) void (^tapMessageButton)(MessageType type,UITableViewCell *cell,NSIndexPath *index);

@end
