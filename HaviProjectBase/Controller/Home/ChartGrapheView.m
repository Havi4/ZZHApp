//
//  NewHeartGrapheView.m
//  SleepRecoding
//
//  Created by Havi on 15/9/17.
//  Copyright (c) 2015年 Havi. All rights reserved.
//

#import "ChartGrapheView.h"
#import "ReportViewDefine.h"
@interface ChartGrapheView ()

@property (strong, nonatomic) NSDictionary   *textStyleDict;
@property (strong, nonatomic) NSMutableArray *xPoints;
@property (strong, nonatomic) NSMutableArray *funcPoints;
@property (nonatomic, strong) UIImageView *leftImage;
@property (nonatomic, strong) UIImageView *rightImage;


@end

@implementation ChartGrapheView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
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
    [self addSubview:self.leftImage];
    
    [self addSubview:self.rightImage];
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
    lineView.backgroundColor = [UIColor whiteColor];
    lineView.alpha = 0.3;
    lineView.frame = CGRectMake(0, self.frame.size.height - bottomLineMargin, self.frame.size.width, 1);
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
        NSUInteger count = values.count;
        for (int i = 0; i < count; i++) {
            NSString *xValue = values[i];
            
            CGFloat cX = 0;
            cX = ((xCoordinateWidth) / (count)) * i;
            
            CGFloat cY = self.frame.size.height - bottomLineMargin;
            // 收集坐标点
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(cX, cY+3, ((xCoordinateWidth)/(count)), 10)];
            label.backgroundColor = [UIColor clearColor];
            label.text = xValue;
            label.tag = 1001;
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:13];
            label.textAlignment = NSTextAlignmentCenter;
            [self addSubview:label];
            //
            UILabel *labelLine = [[UILabel alloc]initWithFrame:CGRectMake(cX+(xCoordinateWidth)/(count)/2, 0, 0.5, cY)];
            if (i==0) {
                labelLine.frame = CGRectMake(cX+10, 0, 0.5, cY);
            }
            labelLine.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.5];
            labelLine.tag = 1002;
            //
            [self.xPoints addObject:[NSValue valueWithCGPoint:CGPointMake(labelLine.frame.origin.x, cY)]];
            [self addSubview:labelLine];
        }
        //设置分割线
    }
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

- (UIImageView *)leftImage
{
    if (_leftImage == nil) {
        _leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, xCoordinateWidth/2+0.5, yCoordinateHeight)];
        _leftImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"pic_moon"]];
        _leftImage.tag = 2001;
    }
    return _leftImage;
}

- (UIImageView *)rightImage
{
    if (_rightImage == nil) {
        _rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(xCoordinateWidth/2, 0, xCoordinateWidth/2, yCoordinateHeight)];
        _rightImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"pic_sun"]];
        _rightImage.tag = 2001;
    }
    return _rightImage;
}
- (MPGraphView *)heartViewLeft
{
    if (_heartViewLeft==nil) {
        _heartViewLeft=[[MPGraphView alloc] initWithFrame:CGRectMake(0, 5, xCoordinateWidth, yCoordinateHeight)];
        _heartViewLeft.waitToUpdate=NO;
        _heartViewLeft.lineWidth = 0.5;
        _heartViewLeft.curved = YES;
        _heartViewLeft.backgroundColor = [UIColor clearColor];
    }
    return _heartViewLeft;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
