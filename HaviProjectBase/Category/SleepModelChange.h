//
//  SleepModelChange.h
//  HaviProjectBase
//
//  Created by Havi on 16/2/24.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SleepModelChange : NSObject

+ (void)changeSleepDuration:(id)obj callBack:(void(^)(id callBack))block;

+ (void)changeSleepValueDuration:(id)obj callBack:(void(^)(id callBack))block;
+ (void)changeSleepQualityModel:(id)obj callBack:(void(^)(id callBack))block;

+ (NSString *)chageDateFormatteToQueryString:(NSDate *)date;

@end
