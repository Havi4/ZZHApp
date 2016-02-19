//
//  BeingRequestModel.h
//  HaviModel
//
//  Created by Havi on 15/12/5.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestUserInfo : NSObject
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *userValidationServer;
@property (strong, nonatomic) NSString *userIdOriginal;
@property (strong, nonatomic) NSString *cellPhone;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *comment;
@property (strong, nonatomic) NSString *requestDate;
@property (assign, nonatomic) int statusCode;

@end

@interface BeingRequestModel : BaseModel

@property (strong, nonatomic) NSArray *beingRequestUserList;

@end
