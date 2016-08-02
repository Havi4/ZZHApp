//
//  JTCalendarDayView.h
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import <UIKit/UIKit.h>

#import "JTCalendarDay.h"
#import "ZZHCalendarCircleView.h"

@interface JTCalendarDayView : UIView<JTCalendarDay>

@property (nonatomic, weak) JTCalendarManager *manager;

@property (nonatomic) NSDate *date;

@property (nonatomic, readonly) UIView *circleView;
@property (nonatomic, readonly) UIView *dotView;
@property (nonatomic, readonly) UILabel *textLabel;
@property (nonatomic, strong)   ZZHCalendarCircleView *bgCircleView;

@property (nonatomic) CGFloat circleRatio;
@property (nonatomic) CGFloat dotRatio;

@property (nonatomic) BOOL isFromAnotherMonth;

/*!
 * Must be call if override the class
 */
- (void)commonInit;

@end
