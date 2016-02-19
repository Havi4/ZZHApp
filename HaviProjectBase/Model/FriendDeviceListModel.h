//
//  FriendDeviceListModel.h
//  HaviModel
//
//  Created by Havi on 15/12/26.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import "BaseModel.h"

@interface FriendDetailDeviceList : NSObject

@property (strong, nonatomic) NSString *detailUUID;
@property (strong, nonatomic) NSString *detailDescription;

@end

@interface FriendDeviceList : NSObject

@property (strong, nonatomic) NSString *friendUserID;
@property (strong, nonatomic) NSString *deviceUUID;
@property (strong, nonatomic) NSString *nDescription;
@property (strong, nonatomic) NSString *isActivated;
@property (strong, nonatomic) NSArray *detailDeviceList;

@end

@interface FriendDeviceListModel : BaseModel

@property (strong, nonatomic) NSArray *deviceList;

@end
