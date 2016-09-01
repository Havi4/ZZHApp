//
//  WeatherModel.h
//  HaviProjectBase
//
//  Created by Havi on 16/9/1.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "BaseModel.h"

@interface WeatherDataModel : NSObject

@property (strong, nonatomic) NSString *airCondition;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *temp;
@property (strong, nonatomic) NSString *humidity;
@property (strong, nonatomic) NSString *weather;
@property (strong, nonatomic) NSString *weatherCode;
@property (strong, nonatomic) NSString *exerciseIndex;
@property (strong, nonatomic) NSString *coldIndex;
@property (strong, nonatomic) NSString *dressingIndex;
@property (strong, nonatomic) NSString *updateTime;

@end

@interface WeatherModel : BaseModel

@property (nonatomic, strong) WeatherDataModel *weatherData;

@end
