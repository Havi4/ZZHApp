//
//  MyDeviceListModel.h
//  HaviModel
//
//  Created by Havi on 15/12/26.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import "BaseModel.h"

@interface DetailDeviceList : NSObject

@property (strong, nonatomic) NSString *detailUUID;
@property (strong, nonatomic) NSString *detailDescription;

@end

@interface DeviceList : NSObject

@property (strong, nonatomic) NSString *deviceUUID;
@property (strong, nonatomic) NSString *nDescription;
@property (strong, nonatomic) NSString *isActivated;
@property (strong, nonatomic) NSArray *detailDeviceList;

@end

@interface MyDeviceListModel : BaseModel

@property (strong, nonatomic) NSArray *deviceList;

@end
