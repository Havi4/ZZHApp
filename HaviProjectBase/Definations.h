//
//  Definations.h
//  HaviModel
//
//  Created by Havi on 15/12/5.
//  Copyright © 2015年 Havi. All rights reserved.
//

#ifndef Definations_h
#define Definations_h


#endif /* Definations_h */
#define kAppBaseURL @"http://testzzhapi.meddo99.com:8088/"
//#define kAppBaseURL @"http://webservice.meddo99.com:9000/"
#define kAppTestBaseURL @"http://testzzhapi.meddo99.com:8088/"
#define kKeyWindow [UIApplication sharedApplication].keyWindow

#define kWXPlatform @"12wx.com"
#define kSinaPlatform @"sina.com"
#define kTXPlatform @"qq.com"
#define kMeddoPlatform @"meddo99.com"

#define kWXAPPKey @"wx7be2e0c9ebd9e161"
#define kWXAPPSecret @"8fc579120ceceae54cb43dc2a17f1d54"
//
#define kWBAPPKey @"2199355574"
#define kWBRedirectURL @"http://www.meddo.com"

#define kBadgeKey [NSString stringWithFormat:@"badge%@",thirdPartyLoginUserId]

//new-start
//font
#define StatusbarSize 20
#define kDefaultWordFont      [UIFont systemFontOfSize:17]
#define kTextPlaceHolderFont [UIFont systemFontOfSize:15]
#define kTextFieldWordFont [UIFont systemFontOfSize:15]
#define kTextNormalWordFont [UIFont systemFontOfSize:17]
#define kTextTitleWordFont [UIFont systemFontOfSize:19]
//color
#define kTextPlaceHolderColor [UIColor lightGrayColor]
#define kTextFieldWordColor [UIColor lightGrayColor]
#define kTextDefaultWordColor [UIColor grayColor]
//time
#define kCodeValideTime 10*60
#define kNumberFont(_font) [UIFont fontWithName:@"Roboto-Light" size:_font]
//new-end

#define kDefaultColor [UIColor whiteColor]
#define kLightColor [UIColor whiteColor]

#define kTextColorPicker DKColorWithColors(kDefaultColor, kLightColor)
#define kViewTintColorPicker DKColorWithColors(kDefaultColor, kLightColor)

#if DEBUG
#define DeBugLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DeBugLog(tmt, ...)
#endif

#define kWhiteBackTextColor   [UIColor colorWithRed:0.467 green:0.467 blue:0.467 alpha:1.00]
//cell 滑动效果

#define kReportCellColor        [UIColor colorWithRed:0.027 green:0.322 blue:0.400 alpha:1.00]
#define kFlagButtonColor        [UIColor colorWithRed:255.0/255.0 green:150.0/255.0 blue:0/255.0 alpha:1]
#define kMoreButtonColor        [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1]
#define kArchiveButtonColor     [UIColor colorWithRed:60.0/255.0 green:112.0/255.0 blue:168/255.0 alpha:1]
#define kUnreadButtonColor      [UIColor colorWithRed:0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1]
#define KTableViewBackGroundColor [UIColor colorWithRed:0.937 green:0.937 blue:0.957 alpha:1.00]
#define kTableViewCellBackGroundColor [UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1.00]


#define kButtonViewWidth [UIScreen mainScreen].bounds.size.width - 40
#define kScreen_Bounds [UIScreen mainScreen].bounds
#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#define kScreen_Width [UIScreen mainScreen].bounds.size.width

#define ISIPHON4 [UIScreen mainScreen].bounds.size.height==480 ? YES:NO
#define ISIPHON6S [UIScreen mainScreen].bounds.size.height>568 ? YES:NO

#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)


//睡眠设置中


#define kAlarmStatusValue @"kAlarmStatusValue"
#define kAlarmTimeValue @"kAlarmTimeValue"

#define kPostEmergencyNoti @"PostEmergencyNoti"

#define kUserBedStatusChanged @"kUserBedStatusChanged"

//换肤
#define kReloadAppTheme @"kReloadAppTheme"

#define kAppPassWordKeyNoti      @"appPassWordKey"
#define kAppPassWorkSetOkNoti    @"AppPassWorkSetOkNoti"
#define kAppPassWordCancelNoti   @"AppPassWordCancelNoti"

#define kAppIntroduceViewKey   @"kAppIntroduceViewKey"

#define kUserChangeUUIDInCenterView @"kUserChangeUUIDInCenterView"
#define kUserTapedDataReportButton @"kUserTapedDataReportButton"
#define kReportTagSelected         @"kReportTagSelected"
#define kGetWeatherData         @"kGetWeatherData"
#define kGetCurrentCity         @"kGetCurrentCity"
#define kJPushNotification         @"kJPushNotification"
#define kRefreshDeviceList         @"kRefreshDeviceList"

#define RGBA(R/*红*/, G/*绿*/, B/*蓝*/, A/*透明*/) \
[UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:A]
#define kNaviBackGroundColor [UIColor colorWithRed:0.176 green:0.173 blue:0.196 alpha:1.00]
//chartValue
#define kCharDataIntervalTime 5
#define kChartDataCount (24*60/kCharDataIntervalTime)
#define kHeartMinAlarmValue 50
#define kHeartMaxAlarmValue 100
#define kHeartHorizonbleAlarmValue 140
#define kBreathHorizonbleAlarmValue 40
#define kBreathMinAlarmValue 5
#define kBreathMaxAlarmValue 20
