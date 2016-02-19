//
//  SearchUserTableViewCell.h
//  SleepRecoding
//
//  Created by Havi on 15/11/12.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HaviBaseTableViewCell.h"
@class SearchUserTableViewCell;

@interface SearchUserTableViewCell : HaviBaseTableViewCell

@property (nonatomic, copy) void (^sendMessageTaped) (UITableViewCell *cell ,NSString *commendString);

@end
