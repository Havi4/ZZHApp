//
//  AllDeviceModel.h
//  HaviProjectBase
//
//  Created by Havi on 16/2/23.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "BaseModel.h"
#import "MyDeviceListModel.h"

@interface AllDeviceModel : BaseModel

@property (strong, nonatomic) NSArray *myDeviceList;

@property (strong, nonatomic) NSArray *friendDeviceList;

@end
