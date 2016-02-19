//
//  BaseModel.h
//  HaviModel
//
//  Created by Havi on 15/12/5.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

@property (strong, nonatomic) NSString *serverTime;
@property (strong, nonatomic) NSString *returnCode;
@property (strong, nonatomic) NSString *errorMessage;
@property (strong, nonatomic) NSString *date;

@end
