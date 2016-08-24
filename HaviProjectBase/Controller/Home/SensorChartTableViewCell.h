//
//  SensorChartTableViewCell.h
//  HaviProjectBase
//
//  Created by Havi on 16/2/25.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "HaviBaseTableViewCell.h"

@interface SensorChartTableViewCell : HaviBaseTableViewCell

@property (strong, nonatomic) NSString *UUID;
@property (strong, nonatomic) SleepQualityModel *sleepModel;

@end
