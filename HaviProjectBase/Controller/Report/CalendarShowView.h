//
//  CalendarShowView.h
//  HaviProjectBase
//
//  Created by Havi on 16/2/26.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarShowView : UIView


@property (nonatomic, copy) void (^selectDateBlock)(NSString *fromDate,NSString *endDate);

- (instancetype)initWithFrame:(CGRect)frame withReportType:(ReportViewType)type;

@end
