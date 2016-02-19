//
//  GlobalModel.h
//  HaviModel
//
//  Created by Havi on 15/12/27.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import "BaseModel.h"

@interface GlobalDetailModel : NSObject

@property (strong, nonatomic) NSString *serviceHotline;
@property (strong, nonatomic) NSString *isTimeoutAlarmOutOfBed;
@property (strong, nonatomic) NSString *alarmTimeOutOfBed;
@property (strong, nonatomic) NSString *isTimeoutAlarmSleepTooLong;
@property (strong, nonatomic) NSString *alarmTimeSleepTooLong;
@property (strong, nonatomic) NSString *fromTimeShowData;
@property (strong, nonatomic) NSString *toTimeShowData;
@property (strong, nonatomic) NSString *sleepStartTime;
@property (strong, nonatomic) NSString *sleepEndTime;

@end

@interface GlobalModel : BaseModel

@property (strong, nonatomic) GlobalDetailModel *parameterList;

@end
