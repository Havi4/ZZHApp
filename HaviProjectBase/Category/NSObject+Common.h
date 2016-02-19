//
//  NSObject+Common.h
//  HaviModel
//
//  Created by Havi on 15/12/28.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Common)

#pragma mark BaseURL

+ (NSString *)baseURLStr;
+ (BOOL)baseURLStrIsTest;
+ (void)changeBaseURLStrToTest:(BOOL)isTest;

@end
