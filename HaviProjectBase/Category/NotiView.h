//
//  NotiView.h
//  HaviProjectBase
//
//  Created by Havi on 2016/9/27.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotiView : UIView

- (void)configNotiView:(NSDictionary *)dic;

@property (nonatomic, copy) void (^buttonClockTaped)(NSInteger callBackResult);


@end