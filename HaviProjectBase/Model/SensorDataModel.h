//
//  SensorDataModel.h
//  HaviModel
//
//  Created by Havi on 15/12/5.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import "BaseModel.h"

@interface PropertyData : NSObject

@property (strong, nonatomic) NSString *propertyDate;
@property (strong, nonatomic) NSString *propertyValue;
@property (strong, nonatomic) NSString *assessmentCode;

@end

@interface SensorDataInfo : NSObject

@property (assign, nonatomic) int properyType;
@property (strong, nonatomic) NSArray *propertyDataList;

@end

@interface SensorDataModel : BaseModel

@property (strong, nonatomic) NSArray *sensorDataList;

@end
