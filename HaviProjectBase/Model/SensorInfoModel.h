//
//  SensorInfoModel.h
//  HaviModel
//
//  Created by Havi on 15/12/26.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import "BaseModel.h"

@interface SensorDetail : NSObject


@property (strong, nonatomic) NSString *deviceUUID;
@property (strong, nonatomic) NSString *masterUUID;
@property (strong, nonatomic) NSString *factoryCode;
@property (strong, nonatomic) NSString *deviceCategory;
@property (strong, nonatomic) NSString *macAddress;
@property (strong, nonatomic) NSString *firmwareVersion;
@property (assign, nonatomic) int activationStatusCode;
@property (assign, nonatomic) int heartRate;
@property (assign, nonatomic) int respirationRate;
@property (strong, nonatomic) NSString *lastBodyMovingDateTime;
@property (strong, nonatomic) NSString *isAnybodyOnBed;

@end

@interface SensorList : NSObject

@property (strong, nonatomic) NSString *subDeviceUUID;

@end

@interface SensorInfoModel : BaseModel

@property (nonatomic, strong) SensorDetail *sensorDetail;
@property (nonatomic, strong) NSArray *detailSensorInfoList;

@end
