//
//  Gloable.h
//  HaviProjectBase
//
//  Created by Havi on 16/2/18.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import <Foundation/Foundation.h>
//主题
extern int selectedThemeIndex;
//返回值对象
extern NSDictionary *returnErrorMessage;
//userInfo
extern NSString *thirdPartyLoginUserId;
extern NSString *thirdPartyLoginToken;
extern NSString *thirdPartyLoginIcon;
extern NSString *thirdPartyLoginOriginalId;
extern NSString *thirdPartyLoginPlatform;
extern NSString *thirdPartyLoginNickName;
extern NSString *thirdHardDeviceUUID;
extern NSString *thirdHardDeviceName;
extern NSString *thirdMeddoPhone;
extern NSString *thirdMeddoPassWord;
extern NSString *thirdLeftDeviceUUID;
extern NSString *thirdRightDeviceUUID;
extern NSString *thirdLeftDeviceName;
extern NSString *thirdRightDeviceName;
extern NSString *isMineDevice;
extern NSString *registeredID;

extern NSDate *selectedDateToUse;
extern BOOL isDoubleDevice;
extern DeviceList *gloableActiveDevice;

extern YYReachability *netReachability;



