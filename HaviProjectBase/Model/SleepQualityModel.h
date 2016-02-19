//
//  SleepQualityModel.h
//  HaviModel
//
//  Created by Havi on 15/12/27.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import "BaseModel.h"

@interface QualityDetailModel : NSObject

@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *sleepQuality;
@property (strong, nonatomic) NSString *sleepStartTime;
@property (strong, nonatomic) NSString *sleepEndTime;
@property (strong, nonatomic) NSString *sleepDuration;
@property (strong, nonatomic) NSString *tagsBeforeSleep;
@property (strong, nonatomic) NSString *tagsAfterSleep;
@property (strong, nonatomic) NSString *tagFlag;

@end

@interface SleepQualityModel : BaseModel

@property (strong, nonatomic) NSString *sleepQuality;
@property (strong, nonatomic) NSString *assessmentCode;
@property (strong, nonatomic) NSString *averageHeartRate;
@property (strong, nonatomic) NSString *averageRespiratoryRate;
@property (strong, nonatomic) NSString *slowHeartRateTimes;
@property (strong, nonatomic) NSString *fastHeartRateTimes;
@property (strong, nonatomic) NSString *slowRespiratoryRateTimes;
@property (strong, nonatomic) NSString *fastRespiratoryRateTimes;
@property (strong, nonatomic) NSString *abnormalHeartRatePercent;
@property (strong, nonatomic) NSString *abnormalRespiratoryRatePercent;
@property (strong, nonatomic) NSString *bodyMovementTimes;
@property (strong, nonatomic) NSString *outOfBedTimes;
@property (strong, nonatomic) NSString *averageSleepDuration;
@property (strong, nonatomic) NSArray *data;

@end
