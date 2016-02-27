//
//  SleepTimeTagView.h
//  SleepRecoding
//
//  Created by Havi on 15/8/9.
//  Copyright (c) 2015年 Havi. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SleepTimeTagView : UIView

@property (nonatomic,strong) NSString *sleepNightCategoryString;
@property (nonatomic,strong) NSString *sleepYearMonthDayString;
@property (nonatomic,strong) NSString *sleepTimeLongString;
@property (nonatomic,assign) CGFloat grade;//百分比和24小时的
@property (nonatomic,strong) NSArray *lineColorArr;

@end
