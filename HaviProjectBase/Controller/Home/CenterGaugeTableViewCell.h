//
//  CenterGaugeTableViewCell.h
//  HaviProjectBase
//
//  Created by Havi on 16/2/24.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "HaviBaseTableViewCell.h"

@interface CenterGaugeTableViewCell : HaviBaseTableViewCell

@property (nonatomic, copy) void (^cellClockTaped)(id callBackResult);

@end
