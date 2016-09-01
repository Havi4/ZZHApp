//
//  GetWeatherAPI.h
//  HaviProjectBase
//
//  Created by Havi on 16/9/1.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^WeatherFinishedBlock)(NSURLResponse *response,NSData *data);
typedef void (^WeatherFailedBlock)(NSURLResponse *response,NSError *error);
@interface GetWeatherAPI : NSObject
+(NSURLRequest*)getWeatherInfoWith:(NSDictionary*)parameters
                        finished:(WeatherFinishedBlock)finished
                          failed:(WeatherFailedBlock)failed;
@end
