//
//  DiagnoseReportViewController.h
//  SleepRecoding
//
//  Created by Havi_li on 15/4/6.
//  Copyright (c) 2015年 Havi. All rights reserved.
//

#import "BaseViewController.h"

@interface DiagnoseReportViewController : BaseViewController
@property (nonatomic,strong) NSString *dateTime;
@property (nonatomic,strong) NSString *reportTitleString;
@property (nonatomic,strong) SleepQualityModel *sleepDic;
@property (nonatomic,strong) SensorDataModel *exceptionDic;
@property (nonatomic,strong) NSString *sleeplevel;
@end
