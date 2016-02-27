//
//  CirlcleView.m
//  Circle
//
//  Created by Havi on 15/8/6.
//  Copyright (c) 2015年 Havi. All rights reserved.
//

#import "CirlcleView.h"

#define CHKeyDefaultTrackTintColor [UIColor blackColor]
#define CHKeyDefaultGaugeTintColor [UIColor blackColor]
#define CHKeyDefaultTextColor [UIColor blackColor]

#define degreesToRadians(x) (M_PI*(x)/180.0) //把角度转换成PI的方式
#define  PROGREESS_WIDTH 200 //圆直径
#define PROGRESS_LINE_WIDTH 10 //弧线的宽度

@interface CirlcleView ()

@property (nonatomic, assign) CGRect viewRect;
@property (nonatomic, strong) CAShapeLayer *gaugeCircleLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) CAShapeLayer *trackLayer;
@property (nonatomic, strong) CALayer *gradientLayer;

@end

@implementation CirlcleView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.viewRect = frame;
        [self initSetup];
    }
    
    return self;
}

- (void)initSetup {
    [self createGauge];
}

- (void)createGauge {
    
    [self createnewGauge];
    
}

- (void)createnewGauge {
    
    _trackLayer = [CAShapeLayer layer];//创建一个track shape layer
    [self.layer addSublayer:_trackLayer];
    _trackLayer.fillColor = [[UIColor clearColor] CGColor];
    _trackLayer.strokeColor = [[UIColor lightGrayColor] CGColor];//指定path的渲染颜色
    _trackLayer.opacity = 0.1; //背景同学你就甘心做背景吧，不要太明显了，透明度小一点
    _trackLayer.lineCap = kCALineCapRound;//指定线的边缘是圆的
    _trackLayer.lineWidth = PROGRESS_LINE_WIDTH;//线的宽度
    CGPoint arcCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:arcCenter radius:(self.viewRect.size.width-PROGRESS_LINE_WIDTH)/2 startAngle:degreesToRadians(-173) endAngle:degreesToRadians(189) clockwise:YES];//上面说明过了用来构建圆形
    //    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.backView.frame cornerRadius:7];
    _trackLayer.path =[path CGPath]; //把path传递給layer，然后layer会处理相应的渲染，整个逻辑和CoreGraph是一致的。
    
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.fillColor =  [[UIColor clearColor] CGColor];
    _progressLayer.strokeColor  = [[UIColor whiteColor] CGColor];
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.lineWidth = PROGRESS_LINE_WIDTH;
    _progressLayer.path = [path CGPath];
    _progressLayer.strokeEnd = 100;
    
    _gradientLayer = [CALayer layer];
    self.gradientLayer1 =  [CAGradientLayer layer];
    _gradientLayer1.frame = CGRectMake((self.viewRect.size.width - self.viewRect.size.height)/2, 0, self.viewRect.size.height, self.viewRect.size.height/2);
    [_gradientLayer1 setColors:selectedThemeIndex ==0?[NSArray arrayWithObjects:(id)[[self colorWithHex:0x356E8B alpha:1]CGColor],[[self colorWithHex:0x3e608d alpha:1]CGColor ],(id)[[self colorWithHex:0x00C790 alpha:1]CGColor ],nil]:[NSArray arrayWithObjects:(id)[[self colorWithHex:0x1C7A59 alpha:1]CGColor],[[self colorWithHex:0x0F705C alpha:1]CGColor ],(id)[[self colorWithHex:0x51AD4A alpha:1]CGColor ],nil]];
//    0x318d8d
    [_gradientLayer1 setLocations:@[@0.3,@0.4,@1 ]];
    [_gradientLayer1 setStartPoint:CGPointMake(0, 1)];
    [_gradientLayer1 setEndPoint:CGPointMake(1,1)];
    [_gradientLayer addSublayer:_gradientLayer1];
    
    self.gradientLayer2 =  [CAGradientLayer layer];
    [_gradientLayer2 setLocations:@[@0.2,@0.3,@1]];
    _gradientLayer2.frame = CGRectMake((self.viewRect.size.width - self.viewRect.size.height)/2, self.viewRect.size.height/2, self.viewRect.size.height, self.viewRect.size.height/2);
    [_gradientLayer2 setColors:selectedThemeIndex==0?[NSArray arrayWithObjects:(id)[[self colorWithHex:0x1cd98d alpha:1]CGColor],(id)[[self colorWithHex:0x21c88d alpha:1]CGColor ],(id)[[self colorWithHex:0x00C790 alpha:1]CGColor ],nil]:[NSArray arrayWithObjects:(id)[[self colorWithHex:0x8DEC45 alpha:1]CGColor],(id)[[self colorWithHex:0x85E445 alpha:1]CGColor ],(id)[[self colorWithHex:0x51AD4A alpha:1]CGColor ],nil]];
    [_gradientLayer2 setStartPoint:CGPointMake(0, 0)];
    [_gradientLayer2 setEndPoint:CGPointMake(1, 0)];
    [_gradientLayer addSublayer:_gradientLayer2];
    
    
    
    [_gradientLayer setMask:_progressLayer]; //用progressLayer来截取渐变层
    [self.layer addSublayer:_gradientLayer];
    
}

- (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
}

-(void)setPercent:(NSInteger)percent animated:(BOOL)animated
{
    _progressLayer.strokeEnd = 100;
    _progressLayer.strokeStart = 0;
    [CATransaction begin];
    [CATransaction setDisableActions:!animated];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [CATransaction setAnimationDuration:0.5];
    _progressLayer.strokeEnd = percent/100.0;
    [CATransaction commit];
    
}

-(void)setPercent:(NSInteger)percent animated:(BOOL)animated withDuration:(int)duration
{
    [CATransaction begin];
    [CATransaction setDisableActions:!animated];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [CATransaction setAnimationDuration:duration];
    _progressLayer.strokeEnd = percent/100.0;
    [CATransaction commit];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
