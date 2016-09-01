//
//  GetWeatherAPI.m
//  HaviProjectBase
//
//  Created by Havi on 16/9/1.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "GetWeatherAPI.h"
#import "WTRequestCenter.h"

@implementation GetWeatherAPI

+(NSURLRequest*)getWeatherInfoWith:(NSDictionary*)parameters
                          finished:(WeatherFinishedBlock)finished
                            failed:(WeatherFailedBlock)failed;
{
    NSString *tockenUrl = [NSString stringWithFormat:@"http://testzzhapi.meddo99.com:8088/v1/app/GetWeather?City=%@&Province=%@",[parameters objectForKey:@"city"],[parameters objectForKey:@"province"]];
    [WTRequestCenter getWithURL:tockenUrl headers:@{@"AccessToken":@"A29#XXFDs1-FDKSD-JGLjx2"} parameters:nil option:WTRequestCenterCachePolicyNormal finished:finished failed:failed];
//    [WTRequestCenter getWithURL:tockenUrl parameters:nil finished:finished failed:failed];
    return nil;
    
}
@end
