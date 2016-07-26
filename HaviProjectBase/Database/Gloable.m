//
//  Gloable.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/18.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "Gloable.h"

int selectedThemeIndex = 1;

NSDictionary *returnErrorMessage = nil;

NSString *thirdPartyLoginUserId = @"";
NSString *thirdPartyLoginToken = @"";
NSString *thirdPartyLoginOriginalId = @"";
NSString *thirdPartyLoginIcon = @"";
NSString *thirdPartyLoginPlatform = @"";
NSString *thirdPartyLoginNickName = @"";
NSString *thirdHardDeviceUUID = @"";
NSString *thirdHardDeviceName = @"";
NSString *thirdMeddoPhone = @"";
NSString *thirdMeddoPassWord = @"";
NSString *thirdLeftDeviceUUID = @"";
NSString *thirdRightDeviceUUID = @"";
NSString *thirdLeftDeviceName = @"";
NSString *thirdRightDeviceName = @"";
NSString *langaueChoice = @"";
NSString *isMineDevice = @"NO";
NSString *registeredID = @"";

NSDate *selectedDateToUse = nil;
NSInteger selectPageIndex = 0;
BOOL isDoubleDevice = NO;
DeviceList *gloableActiveDevice = nil;

YYReachability *netReachability = nil;

