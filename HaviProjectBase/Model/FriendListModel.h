//
//  FriendListModel.h
//  HaviModel
//
//  Created by Havi on 15/12/5.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserList : NSObject

//"UserID": "meddo99.com$Test-1",
//"UserValidationServer": "meddo99.com", //迈动、微信、腾信等
//"UserIdOriginal": "Test-1", //注册用户名
//"CellPhone": "13800000000", //手机
//"Email": "XX@126.com", //
//"Locked": "false", //是否该用户锁定
//"UserName": "张*" //真实姓名
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *userValidationServer;
@property (strong, nonatomic) NSString *userIdOriginal;
@property (strong, nonatomic) NSString *cellPhone;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *locked;
@property (strong, nonatomic) NSString *userName;

@end

@interface FriendListModel : BaseModel

@property (strong, nonatomic) NSArray *userList;

@end
