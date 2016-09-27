//
//  HeartViewController.h
//  HaviProjectBase
//
//  Created by Havi on 16/2/23.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "BaseViewController.h"

@interface CenterDataShowViewController : BaseViewController

@property (nonatomic, strong) NSString *deviceUUID;

@property (nonatomic, strong) SensorInfoModel *sensorInfoDetail;

- (void)getSleepDataWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;

@end
