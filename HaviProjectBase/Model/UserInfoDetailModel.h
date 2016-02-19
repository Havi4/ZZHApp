//
//  NestModel.h
//  HaviModel
//
//  Created by Havi on 15/12/5.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *userValidationServer;
@property (strong, nonatomic) NSString *userIdOriginal;
@property (strong, nonatomic) NSString *cellPhone;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *locked;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *birthday;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *height;
@property (strong, nonatomic) NSString *weight;
@property (strong, nonatomic) NSString *telephone;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *emergencyContact;
@property (strong, nonatomic) NSString *isTimeoutAlarmOutOfBed;
@property (strong, nonatomic) NSString *alarmTimeOutOfBed;
@property (strong, nonatomic) NSString *isTimeoutAlarmSleepTooLong;
@property (strong, nonatomic) NSString *alarmTimeSleepTooLong;
@property (strong, nonatomic) NSString *sleepStartTime;
@property (strong, nonatomic) NSString *sleepEndTime;


@end



@interface UserInfoDetailModel : BaseModel

@property (strong, nonatomic) UserInfo *nUserInfo;

@end
