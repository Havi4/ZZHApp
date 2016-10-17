//
//  LongpressShowView.m
//  HaviProjectBase
//
//  Created by Havi on 16/4/20.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "LongpressShowView.h"
#import "ReportViewDefine.h"


@interface LongpressShowView ()

@property (strong, nonatomic) NSDictionary   *textStyleDict;
@property (strong, nonatomic) NSMutableArray *xPoints;
@property (strong, nonatomic) NSMutableArray *funcPoints;

@end

@implementation LongpressShowView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        imageView.image = [UIImage imageNamed:@"background"];
//        [self addSubview:imageView];
        self.backgroundColor = [UIColor clearColor];
        [self setUpCoordinateSystem];
//        [self setBackImage];
        
        [self addSubview:self.heartViewLeft];
        self.heartViewLeft.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setBackImage
{
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, self.bounds.size.width, yCoordinateHeight);
    
    //设置渐变颜色方向
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    
    //设定颜色组
    gradientLayer.colors = selectedThemeIndex==0? @[(__bridge id)[UIColor colorWithRed:0.122f green:0.180f blue:0.478f alpha:0.250f].CGColor,(__bridge id)[UIColor colorWithRed:0.796f green:0.816f blue:0.565f alpha:0.250f].CGColor]:@[(__bridge id)[UIColor colorWithRed:0.216f green:0.400f blue:0.580f alpha:0.250f].CGColor,(__bridge id)[UIColor colorWithRed:0.780f green:0.808f blue:0.455f alpha:0.2500f].CGColor];
    
    //设定颜色分割点
    gradientLayer.locations = @[@(0.5f) ,@(1.0f)];
    gradientLayer.cornerRadius = 0;
    [self.layer addSublayer:gradientLayer];
}
#pragma mark setter meathod



/**
 *  创建x轴坐标
 */
-(void)setUpCoordinateSystem // 利用UIView作为坐标轴动态画出坐标系
{
    UIView *xCoordinate = [self getLineCoor];
    [self addSubview:xCoordinate];
    
}
/**
 *  创建x轴
 *
 *  @return UIView
 */
-(UIView *)getLineCoor
{
    UIView *lineView = [[UIView alloc] init];
    lineView.dk_backgroundColorPicker = kTextColorPicker;
    lineView.alpha = 0.3;
    lineView.frame = CGRectMake(0, self.frame.size.height - bottomLineMargin, self.frame.size.width, 0.5);
    return lineView;
}



#pragma mark - 添加坐标轴的值

- (void)setDataValues:(NSMutableArray *)dataValues
{
    if (!_funcPoints) {
        _funcPoints = [[NSMutableArray alloc]init];
    }
    if (_funcPoints.count>0) {
        [_funcPoints removeAllObjects];
    }
    for (int i = 0; i<dataValues.count; i++) {
        [_funcPoints addObject:[dataValues objectAtIndex:i]];
    }
}

-(void)setXValues:(NSArray *)values
{
    
    for (UIView *view in self.subviews) {
        if (view.tag == 1001||view.tag==1002) {
            [view removeFromSuperview];
        }
    }
    if (values.count){
        NSUInteger count = 61;
        for (int i = 0; i < count; i++) {
            CGFloat cX = 0;
            cX = ((xCoordinateWidth) / (count)) * i;
            CGFloat cY = self.frame.size.height - bottomLineMargin;
            //
            UILabel *labelLine;
            if (i%4==0) {
                labelLine = [[UILabel alloc]initWithFrame:CGRectMake(cX+(xCoordinateWidth)/(count)/2, 10, 0.5, cY-10)];
                CGFloat cY = self.frame.size.height - bottomLineMargin;
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(cX+(xCoordinateWidth)/(count)/2-20, cY+3, 40, 10)];
                if (i==0) {
                    label.frame = CGRectMake(cX+(xCoordinateWidth)/(count)/2-10, cY+3, 40, 10);
                }else if (i/4==15){
                    label.frame = CGRectMake(cX+(xCoordinateWidth)/(count)/2-30, cY+3, 40, 10);
                }
                label.backgroundColor = [UIColor clearColor];
                
                label.text = [NSString stringWithFormat:@"%@",[values objectAtIndex:(i/4)]];
                label.tag = 1001;
                label.dk_textColorPicker = kTextColorPicker;
                label.font = [UIFont systemFontOfSize:10];
                label.textAlignment = NSTextAlignmentCenter;
                [self addSubview:label];
                labelLine.backgroundColor = [UIColor whiteColor];
                labelLine.alpha = 0.3;
                labelLine.tag = 1002;
            }else{
                labelLine = [[UILabel alloc]initWithFrame:CGRectMake(cX+(xCoordinateWidth)/(count)/2, cY-1.5, 0.5, 1.5)];
                labelLine.backgroundColor = [UIColor whiteColor];
                labelLine.alpha = 0.7;
                labelLine.tag = 1002;
            }
            
            //
            [self.xPoints addObject:[NSValue valueWithCGPoint:CGPointMake(labelLine.frame.origin.x, cY)]];
            [self addSubview:labelLine];
        }
        //设置分割线
    }
    
    /*
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, cY+3, 40, 10)];
    label.backgroundColor = [UIColor clearColor];
    label.text = [values objectAtIndex:0];
    label.tag = 1001;
    label.dk_textColorPicker = kTextColorPicker;
    label.font = [UIFont systemFontOfSize:11];
    label.textAlignment = NSTextAlignmentLeft;
    [self addSubview:label];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width-45, cY+3, 40, 10)];
    label1.backgroundColor = [UIColor clearColor];
    label1.text = [values objectAtIndex:0];
    label1.tag = 1001;
    label1.dk_textColorPicker = kTextColorPicker;
    label1.font = [UIFont systemFontOfSize:11];
    label1.textAlignment = NSTextAlignmentRight;
    [self addSubview:label1];
     */
}


-(NSDictionary *)textStyleDict
{
    if (!_textStyleDict) {
        UIFont *font = [UIFont systemFontOfSize:13];
        NSMutableParagraphStyle *style=[[NSMutableParagraphStyle alloc]init]; // 段落样式
        style.alignment = NSTextAlignmentCenter;
        _textStyleDict = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:selectedThemeIndex==0?kDefaultColor:[UIColor whiteColor],};
    }
    return _textStyleDict;
}

#pragma mark setter

- (MPGraphView *)heartViewLeft
{
    if (_heartViewLeft==nil) {
        _heartViewLeft=[[MPGraphView alloc] initWithFrame:CGRectMake(0, 5, xCoordinateWidth, yCoordinateHeight)];
        _heartViewLeft.waitToUpdate=NO;
        _heartViewLeft.lineWidth = 0.5;
        _heartViewLeft.backgroundColor = [UIColor clearColor];
    }
    return _heartViewLeft;
}
- (void)removeLine
{
    [_heartViewLeft removeFromSuperview];
    _heartViewLeft = nil;
}

- (void)addlineView
{
    [self addSubview:self.heartViewLeft];
    self.heartViewLeft.userInteractionEnabled = YES;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
