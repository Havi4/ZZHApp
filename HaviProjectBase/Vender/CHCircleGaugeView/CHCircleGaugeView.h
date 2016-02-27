//
//  CHCircleGaugeView.h
//
//  Copyright (c) 2014 ChaiOne <http://www.chaione.com/>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

// 版权属于原作者
// http://code4app.com(cn) http://code4app.net(en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <UIKit/UIKit.h>
#import "CirlcleView.h"


/**
 Enumeration with the possible state of the circle gauge view.
 */
typedef NS_ENUM(NSInteger, CHCircleGaugeViewState) {
    /**
     "n/a" is displayed.
     */
    CHCircleGaugeViewStateNA,
    /**
     "%" is displayed.
     */
    CHCircleGaugeViewStatePercentSign,
    /**
     A whole number is displayed.
     */
    CHCircleGaugeViewStateScore,
    CHCircleGaugeViewStateTitle,
    CHCircleGaugeViewStateStatus
};

/**
 Enumeration with the possible gauge styles.
 */
typedef NS_ENUM(NSInteger, CHCircleGaugeStyle) {
    /**
     Draws the gauge inside and in the center of the track.
     */
    CHCircleGaugeStyleInside,
    /**
     Draws the gauge outside along the perimeter of the track.
     */
    CHCircleGaugeStyleOutside
};

/**
 A circle gauge is used to depict the value of a measurement.
 If gauge state is CHCircleGaugeViewStateNA, "n/a" is shown instead of a value.
 If gauge state is CHCircleGaugeViewStateScore, "%" is shown instead of a value.
 */
@interface CHCircleGaugeView : UIView


- (void)changeSleepQualityValue:(CGFloat)value;

- (void)changeSleepTimeValue:(CGFloat)value;

- (void)changeSleepLevelValue:(NSString *)valueString;

- (void)changeSleepTimeValue:(CGFloat)value andDuration:(int)duration;


@property (nonatomic, strong) CirlcleView *cView;
@property (nonatomic, strong) UILabel *valueTitleLabel;//havi
@property (nonatomic, strong) UILabel *valueTextLabel;


/** @name Managing the gauge */

/**
 The state of the gauge.
 */
@property (nonatomic, assign) CHCircleGaugeViewState state;

/**
 Contains the current value. Setting this property will change the state of the control to `CHCircleGaugeViewStateScore`.
 */
@property (nonatomic, assign) CGFloat value;
@property (nonatomic, assign) CGFloat startValue;
@property (nonatomic, assign) CGFloat endValue;

/**
 Sets the value the gauge should represent, with optional animation of the change.
 
 The current progress is represented by a floating-point value between 0.0 and 1.0, 
 inclusive, where 1.0 indicates the completion of the task. The default value is 0.0. 
 Values less than 0.0 and greater than 1.0 are pinned to those limits.
 
 Calling this will change the state of the control to `CHCircleGaugeViewStateScore`.
 
 @param value The new gauge value.
 @param animated `YES` if the change should be animated, `NO` if the change should happen immediately.
 */
- (void)setValue:(CGFloat)value animated:(BOOL)animated;

/** @name Configuring the gauge */

/**
 The color shown for the portion of the gauge that is always filled.
 */
@property (nonatomic, strong) UIColor *trackTintColor;

/**
 The color shown on top of `trackTintColor` for the portion of the gauge that varies based on the `value` property.
 */
@property (nonatomic, strong) UIColor *gaugeTintColor;

/**
 The color of the text.
 
 The default value for this property is a black color (set through the blackColor class method of UIColor). The value for the property 
 can only be set to a non-nil value; setting this property to nil raises an exception.
 */
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *responseColor;
@property (nonatomic, assign) CGFloat rotationValue;

/**
 The font of the text.
 
 The default value for this property is the system font at a size of 32 points (using the systemFontOfSize: class method of UIFont). 
 The value for the property can only be set to a non-nil value; setting this property to nil raises an exception.
 */
@property (nonatomic, strong) UIFont *font;

/**
 The width for the portion of the gauge that is always filled. Defaults to a value of 0.5.
 */
@property (nonatomic, assign) CGFloat trackWidth;

/**
 The width for the portion of the gauge that varies based on the `value` property. Defaults to a value of 2.
*/
@property (nonatomic, assign) CGFloat gaugeWidth;

/**
 String that is a suffix on the `value`. This string is meant to be just a few characters long. Defaults to `nil`.
 
 @warning The label backing the string does not auto-shrink, set a smaller font if the text gets truncated.
 
 @see font
 */
@property (nonatomic, copy) NSString *unitsString;

/**
 The text shown when the state of the gauge is `CHCircleGaugeViewStateNA`. Defaults to "n/a".
 */
@property (nonatomic, copy) NSString *notApplicableString;

/**
 The text shown when the state of the gauge is `CHCircleGaugeViewStatePercentSign`. Defaults to "%".
 */
@property (nonatomic, copy) NSString *noDataString;

/**
 Determines how the gauge is drawn relative to the track. Defaults to `CHCircleGaugeStyleInside`.
 */
@property (nonatomic, assign) CHCircleGaugeStyle gaugeStyle;

@end
