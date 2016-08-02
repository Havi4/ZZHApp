//
//  ZZHCircleView.m
//  CreditScore
//
//  Created by Havi on 16/7/28.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "ZZHCircleView.h"
#import "UIImage+Tint.h"
#define SCREEN_WIDTH       self.frame.size.width
#define SCREEN_HEIGHT     self.frame.size.height
#define  CENTER   CGPointMake(SCREEN_WIDTH *.5, SCREEN_HEIGHT *.5)

#define  ConversionRadian(degrees)    (( M_PI* degrees)/ 180)
#define  percentageToRadian(percentage)      (( M_PI* percentage)/ 240)
#import "JTNumberScrollAnimatedView.h"

@interface ZZHCircleView ()

@property (nonatomic, strong) CAGradientLayer *bigCircleBackground;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayerCircle;
@property (nonatomic, strong) CALayer *bgLayer;

@property (nonatomic, strong) NSMutableArray *colors;
@property (nonatomic, strong) NSMutableArray *colors1;

@property (nonatomic, strong) UIImageView *nightImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subLabel;
@property (nonatomic, strong) UILabel *sleepNumber;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) JTNumberScrollAnimatedView *animationView;

@end

@implementation ZZHCircleView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
//    [self.layer addSublayer:self.gradientLayer];
    [self.layer addSublayer:self.bigCircleBackground];
    [self.layer addSublayer:self.gradientLayerCircle];
    [self.layer addSublayer:self.bgLayer];
    
    [self.bgLayer addSublayer:self.gradientLayer];
    [self addSubview:self.nightImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.subLabel];
    [self addSubview:self.animationView];
    [self.animationView setValue:[NSNumber numberWithInt:0]];
    int radius = MIN(SCREEN_WIDTH, SCREEN_HEIGHT)/2-30;
    
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.fillColor =  [[UIColor clearColor] CGColor];
    _progressLayer.strokeColor  = [[UIColor whiteColor] CGColor];
    _progressLayer.lineCap = kCALineCapSquare;
    _progressLayer.lineWidth = 15;
    _progressLayer.path = [UIBezierPath bezierPathWithArcCenter:CENTER radius:radius startAngle:ConversionRadian(-86)  endAngle:ConversionRadian(274) clockwise:YES].CGPath;
    _progressLayer.strokeStart = 0.0f;
    _progressLayer.strokeEnd = 0.0f;
    [self.bgLayer setMask:_progressLayer];
}

- (JTNumberScrollAnimatedView *)animationView
{
    if (!_animationView) {
        _animationView = [[JTNumberScrollAnimatedView alloc]init];
        _animationView.textColor = [UIColor whiteColor];
        _animationView.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:50];
        _animationView.frame = (CGRect){self.frame.size.width/2-30,self.frame.size.height/2-25,60,50};
        _animationView.minLength = 1;
    }
    return _animationView;
}

- (CALayer*)bgLayer
{
    if (!_bgLayer) {
        _bgLayer = [CALayer layer];
    }
    return _bgLayer;
}

- (UILabel*)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"睡眠评分";
        _titleLabel.frame = (CGRect){self.frame.size.width/2-50,50,100,40};
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)subLabel
{
    if (!_subLabel) {
        _subLabel = [[UILabel alloc]init];
        _subLabel.text = @"超过80%的用户";
        _subLabel.frame = (CGRect){self.frame.size.width/2-75,150,150,40};
        _subLabel.textAlignment = NSTextAlignmentCenter;
        _subLabel.textColor = [UIColor whiteColor];
    }
    return _subLabel;
}

- (UILabel *)sleepNumber
{
    if (!_sleepNumber) {
        _sleepNumber = [[UILabel alloc]init];
        _sleepNumber.textAlignment = NSTextAlignmentCenter;
        _sleepNumber.textColor = [UIColor whiteColor];
        _sleepNumber.text = @"90";
        _sleepNumber.font = [UIFont systemFontOfSize:60];
        _sleepNumber.frame = (CGRect){self.frame.size.width/2-50,self.frame.size.height/2-50,100,100};
    }
    return _sleepNumber;
}

- (UIImageView *)nightImageView
{
    if (!_nightImageView) {
        _nightImageView = [[UIImageView alloc]init];
        _nightImageView.image = [[UIImage imageNamed:@"chang@3x"]imageWithTintColor:[UIColor whiteColor]];
        _nightImageView.frame = (CGRect){self.frame.size.width/2-7.5,0,15,15};
    }
    return _nightImageView;
}

- (NSMutableArray *)colors{
    if (!_colors){
        _colors = [NSMutableArray array];
        for (int i = 0; i < 3; i++) {
            UIColor *hexColor = [UIColor colorWithWhite:0.7 alpha:0.9];
            [_colors addObject:(__bridge id)hexColor.CGColor];
        }
    }
    return _colors;
}

- (NSMutableArray *)colors1{
    if (!_colors1){
        _colors1 = [NSMutableArray array];
        for (int i = 0; i < 3; i++) {
            UIColor *hexColor = [UIColor whiteColor];
            [_colors1 addObject:(__bridge id)hexColor.CGColor];
        }
    }
    return _colors1;
}


- (CAGradientLayer *)gradientLayer{
    if (!_gradientLayer) {
        int radius = MIN(SCREEN_WIDTH, SCREEN_HEIGHT)/2-30;
        CAShapeLayer *arc = [CAShapeLayer layer];
        arc.path = [UIBezierPath bezierPathWithArcCenter:CENTER radius:radius startAngle:ConversionRadian(0)  endAngle:ConversionRadian(360) clockwise:YES].CGPath;
        arc.fillColor = [UIColor clearColor].CGColor;
        arc.strokeColor = [UIColor blackColor].CGColor;
        arc.lineWidth = 15;
        [arc setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInteger:1],[NSNumber numberWithInteger:2.8],nil]];
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
        int radius = MIN(SCREEN_WIDTH, SCREEN_HEIGHT)/2-30;
        CAShapeLayer *arc = [CAShapeLayer layer];
        arc.path = [UIBezierPath bezierPathWithArcCenter:CENTER radius:radius startAngle:ConversionRadian(0)  endAngle:ConversionRadian(360) clockwise:YES].CGPath;
        arc.fillColor = [UIColor clearColor].CGColor;
        arc.strokeColor = [UIColor blackColor].CGColor;
        arc.lineWidth = 15;
        [arc setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInteger:1],[NSNumber numberWithInteger:2.8],nil]];
        _gradientLayerCircle = [CAGradientLayer layer];
        _gradientLayerCircle.frame = self.bounds;
        _gradientLayerCircle.colors = self.colors;
        _gradientLayerCircle.startPoint = CGPointMake(0,0.5);
        _gradientLayerCircle.endPoint = CGPointMake(1,0.5);
        _gradientLayerCircle.mask = arc;
    }
    return _gradientLayerCircle;
}

- (CAGradientLayer *)bigCircleBackground
{
    if (!_bigCircleBackground) {
        
        int radius = MIN(SCREEN_WIDTH, SCREEN_HEIGHT)/2-5;
        CAShapeLayer *arc = [CAShapeLayer layer];
        arc.path = [UIBezierPath bezierPathWithArcCenter:CENTER radius:radius startAngle:ConversionRadian(-80)  endAngle:ConversionRadian(260) clockwise:YES].CGPath;
        arc.fillColor = [UIColor clearColor].CGColor;
        arc.strokeColor = [UIColor blackColor].CGColor;
        arc.lineWidth = 1;
        _bigCircleBackground = [CAGradientLayer layer];
        _bigCircleBackground.frame = self.bounds;
        _bigCircleBackground.colors = self.colors;
        _bigCircleBackground.startPoint = CGPointMake(0,0.5);
        _bigCircleBackground.endPoint = CGPointMake(1,0.5);
        _bigCircleBackground.mask = arc;
        
    }
    return _bigCircleBackground;
}

-(void)setPercentage:(double)percentage{
    _progressLayer.strokeStart = 0.0;
    [self.animationView setValue:[NSNumber numberWithInt:percentage*20]];
    [self.animationView startAnimation];
    _progressLayer.strokeEnd = (percentage*20)/100;
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration            = 1.0;
    drawAnimation.removedOnCompletion = YES;
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    drawAnimation.toValue = [NSNumber numberWithFloat:(percentage*20)/100];
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [_progressLayer addAnimation:drawAnimation forKey:@"drawCircleAnimation"];

}

- (void)setPeoplePer:(int)peoplePer
{
    self.subLabel.text = [NSString stringWithFormat:@"超过%d%@的用户",peoplePer,@"%"];
}

@end
