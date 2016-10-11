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
    NSString *tockenUrl = [NSString stringWithFormat:@"%@v1/app/GetWeather?City=%@&Province=%@",kAppBaseURL,[parameters objectForKey:@"city"],[parameters objectForKey:@"province"]];
    [WTRequestCenter getWithURL:tockenUrl headers:@{@"AccessToken":accessTocken} parameters:nil option:WTRequestCenterCachePolicyNormal finished:finished failed:failed];
//    [WTRequestCenter getWithURL:tockenUrl parameters:nil finished:finished failed:failed];
    return nil;
    
}
@end
