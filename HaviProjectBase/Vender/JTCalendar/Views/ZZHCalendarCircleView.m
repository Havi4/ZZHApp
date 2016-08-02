//
//  ZZHCalendarCircleView.m
//  Example
//
//  Created by Havi on 16/7/29.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "ZZHCalendarCircleView.h"
#import "UIColor+Extensions.h"
#define SCREEN_WIDTH       self.frame.size.width
#define SCREEN_HEIGHT     self.frame.size.height
#define  CENTER   CGPointMake(SCREEN_WIDTH *.5, SCREEN_HEIGHT *.5)

#define  ConversionRadian(degrees)    (( M_PI* degrees)/ 180)
#define  percentageToRadian(percentage)      (( M_PI* percentage)/ 240)

@interface ZZHCalendarCircleView ()
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayerCircle;
@property (nonatomic, strong) CALayer *bgLayer;

@property (nonatomic, strong) NSMutableArray *colors;
@property (nonatomic, strong) NSMutableArray *colors1;

@property (nonatomic, strong) CAShapeLayer *progressLayer;
@end

@implementation ZZHCalendarCircleView

- (void)drawRect:(CGRect)rect {
    // Drawing code
    //    [self.layer addSublayer:self.gradientLayer];
    [self.layer addSublayer:self.gradientLayerCircle];
    [self.layer addSublayer:self.bgLayer];
    
    [self.bgLayer addSublayer:self.gradientLayer];
    int radius = MIN(SCREEN_WIDTH, SCREEN_HEIGHT)/2-5.5;
    
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.fillColor =  [[UIColor clearColor] CGColor];
    _progressLayer.strokeColor  = [[UIColor whiteColor] CGColor];
    _progressLayer.lineCap = kCALineCapSquare;
    _progressLayer.lineWidth = 5;
    _progressLayer.path = [UIBezierPath bezierPathWithArcCenter:CENTER radius:radius startAngle:ConversionRadian(-86)  endAngle:ConversionRadian(274) clockwise:YES].CGPath;
    _progressLayer.strokeStart = 0.0f;
    _progressLayer.strokeEnd = 0.0f;
    [self.bgLayer setMask:_progressLayer];
}

- (CALayer*)bgLayer
{
    if (!_bgLayer) {
        _bgLayer = [CALayer layer];
    }
    return _bgLayer;
}

- (NSMutableArray *)colors1{
    if (!_colors1){
        _colors1 = [NSMutableArray array];
        NSArray *hexs = @[@0xffff0000,@0xffffff00, @0xff00ff00,@0xff00ffff,@0xff0000ff,@0xffff00ff];
        for (int i = 0; i < hexs.count; i++) {
            UIColor *hexColor = [UIColor orangeColor];
            [_colors1 addObject:(__bridge id)hexColor.CGColor];
        }
    }
    return _colors1;
}

- (NSMutableArray *)colors{
    if (!_colors){
        _colors = [NSMutableArray array];
        for (int i = 0; i < 3; i++) {
            UIColor *hexColor = [UIColor lightGrayColor];
//            [UIColor colorWithRed:0.863 green:0.863 blue:0.863 alpha:1.00];
            [_colors addObject:(__bridge id)hexColor.CGColor];
        }
    }
    return _colors;
}


- (CAGradientLayer *)gradientLayer{
    if (!_gradientLayer) {
        int radius = MIN(SCREEN_WIDTH, SCREEN_HEIGHT)/2-5.5;
        CAShapeLayer *arc = [CAShapeLayer layer];
        arc.path = [UIBezierPath bezierPathWithArcCenter:CENTER radius:radius startAngle:ConversionRadian(0)  endAngle:ConversionRadian(360) clockwise:YES].CGPath;
        arc.fillColor = [UIColor clearColor].CGColor;
        arc.strokeColor = [UIColor blackColor].CGColor;
        arc.lineWidth = 5;
        [arc setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInteger:1],[NSNumber numberWithInteger:1],nil]];
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.bounds;
        _gradientLayer.colors = self.colors1;
        _gradientLayer.startPoint = CGPointMake(0,0.5);
        _gradientLayer.endPoint = CGPointMake(1,0.5);
        _gradientLayer.mask = arc;
    }
    return _gradientLayer;
}

- (CAGradientLayer *)gradientLayerCircle{
    if (!_gradientLayerCircle) {
        int radius = MIN(SCREEN_WIDTH, SCREEN_HEIGHT)/2-5.5;
        CAShapeLayer *arc = [CAShapeLayer layer];
        arc.path = [UIBezierPath bezierPathWithArcCenter:CENTER radius:radius startAngle:ConversionRadian(0)  endAngle:ConversionRadian(360) clockwise:YES].CGPath;
        arc.fillColor = [UIColor clearColor].CGColor;
        arc.strokeColor = [UIColor blackColor].CGColor;
        arc.lineWidth = 5;
        [arc setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInteger:1],[NSNumber numberWithInteger:1],nil]];
        _gradientLayerCircle = [CAGradientLayer layer];
        _gradientLayerCircle.frame = self.bounds;
        _gradientLayerCircle.colors = self.colors;
        _gradientLayerCircle.startPoint = CGPointMake(0,0.5);
        _gradientLayerCircle.endPoint = CGPointMake(1,0.5);
        _gradientLayerCircle.mask = arc;
    }
    return _gradientLayerCircle;
}


-(void)setPercentage:(double)percentage{
    _progressLayer.strokeStart = 0.0;
    _progressLayer.strokeEnd = percentage;
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration            = 1.0;
    drawAnimation.removedOnCompletion = YES;
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    drawAnimation.toValue = [NSNumber numberWithFloat:percentage];
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [_progressLayer addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
    
}


@end
