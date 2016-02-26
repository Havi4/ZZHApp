//
//  HeartDataViewController.h
//  HaviProjectBase
//
//  Created by Havi on 16/2/25.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "BaseViewController.h"

@interface HeartDataViewController : BaseViewController

@property (nonatomic, strong) NSString *deviceUUID;

@property (nonatomic, assign) SensorDataType sensorType;

@end
