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

#define kAppBaseURL @"http://webservice.meddo99.com:9000/"
#define kAppTestBaseURL @"http://webservice.meddo99.com:9001/"
#define kKeyWindow [UIApplication sharedApplication].keyWindow

#define kWXPlatform @"wx.com2"
#define kSinaPlatform @"sina.com1"
#define kTXPlatform @"qq.com1"
#define kMeddoPlatform @"meddo99.com1"

#define kWXAPPKey @"wx7be2e0c9ebd9e161"
#define kWXAPPSecret @"8fc579120ceceae54cb43dc2a17f1d54"
//
#define kWBAPPKey @"2199355574"
#define kWBRedirectURL @"http://www.meddo.com"

#define kBadgeKey [NSString stringWithFormat:@"badge%@",thirdPartyLoginUserId]


#define StatusbarSize 20
#define kDefaultWordFont      [UIFont systemFontOfSize:17]
#define kDefaultColor [UIColor colorWithRed:0.145f green:0.733f blue:0.957f alpha:1.00f]
#define kLightColor [UIColor whiteColor]

#define kTextColorPicker DKColorWithColors(kDefaultColor, kLightColor)
#define kViewTintColorPicker DKColorWithColors(kDefaultColor, kLightColor)

#if DEBUG
#define DeBugLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DeBugLog(tmt, ...)
#endif

//cell 滑动效果
#define kFlagButtonColor        [UIColor colorWithRed:255.0/255.0 green:150.0/255.0 blue:0/255.0 alpha:1]
#define kMoreButtonColor        [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1]
#define kArchiveButtonColor     [UIColor colorWithRed:60.0/255.0 green:112.0/255.0 blue:168/255.0 alpha:1]
#define kUnreadButtonColor      [UIColor colorWithRed:0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1]
#define KTableViewBackGroundColor [UIColor colorWithRed:0.937 green:0.937 blue:0.957 alpha:1.00]
#define kTableViewCellBackGroundColor [UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1.00]

#define kTextNormalWordFont [UIFont systemFontOfSize:17]
#define kTextTitleWordFont [UIFont systemFontOfSize:19]

#define kButtonViewWidth [UIScreen mainScreen].bounds.size.width - 40
#define kScreen_Bounds [UIScreen mainScreen].bounds
#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#define kScreen_Width [UIScreen mainScreen].bounds.size.width

#define ISIPHON4 [UIScreen mainScreen].bounds.size.height==480 ? YES:NO
#define ISIPHON6 [UIScreen mainScreen].bounds.size.height>568 ? YES:NO

//睡眠设置中

#define kAlarmStatusValue @"kAlarmStatusValue"
#define kAlarmTimeValue @"kAlarmTimeValue"

#define kPostEmergencyNoti @"PostEmergencyNoti"


//换肤
#define kReloadAppTheme @"kReloadAppTheme"

#define kAppPassWordKeyNoti      @"appPassWordKey"
#define kAppPassWorkSetOkNoti    @"AppPassWorkSetOkNoti"
#define kAppPassWordCancelNoti   @"AppPassWordCancelNoti"

#define kAppIntroduceViewKey   @"kAppIntroduceViewKey"

#define kUserChangeUUIDInCenterView @"kUserChangeUUIDInCenterView"

#define RGBA(R/*红*/, G/*绿*/, B/*蓝*/, A/*透明*/) \
[UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:A]

//chartValue
#define kCharDataIntervalTime 2
#define kChartDataCount (24*60/kCharDataIntervalTime)
#define kHeartMinAlarmValue 50
#define kHeartMaxAlarmValue 60
#define kHeartHorizonbleAlarmValue 140
#define kBreathHorizonbleAlarmValue 40
#define kBreathMinAlarmValue 5
#define kBreathMaxAlarmValue 20
