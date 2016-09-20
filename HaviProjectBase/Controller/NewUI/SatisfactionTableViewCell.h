//
//  SatisfactionTableViewCell.h
//  HaviProjectBase
//
//  Created by Havi on 16/9/20.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SatisfactionTableViewCell : UITableViewCell

@property (nonatomic, copy) void (^selectAssementView)(NSInteger assementNum);

@end
