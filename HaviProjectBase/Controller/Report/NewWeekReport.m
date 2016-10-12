//
//  NewWeekReport.m
//  SleepRecoding
//
//  Created by Havi on 15/9/11.
//  Copyright (c) 2015年 Havi. All rights reserved.
//

#import "NewWeekReport.h"
#import "SleepQualityBar.h"
#import "SleepTimeLongBar.h"

@interface NewWeekReport ()
//自定义字体
@property (strong, nonatomic) NSDictionary   *textStyleDict;
@property (strong, nonatomic) NSMutableArray *xPoints;
@property (strong, nonatomic) NSArray *sleepQualityArr;
@property (strong, nonatomic) NSArray *sleepDurationArr;

@end

@implementation NewWeekReport

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self setUpCoordinateSystem];
        [self setDashLine];
        [self drawFuncLine];
    }
    return self;
}

#pragma mark setter

- (NSMutableArray*)xPoints
{
    if (!_xPoints) {
        _xPoints = [[NSMutableArray alloc]init];
    }
    return _xPoints;
}

- (void)setDashLine
{
    CGFloat cY = (self.frame.size.height - bottomLineMargin-16-5)/5;
    for (int i = 0; i<6; i++) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithRed:0.784 green:0.788 blue:0.792 alpha:1.00];
        lineView.alpha = 0.5;
        lineView.frame = CGRectMake(2, 16 + cY*i, self.frame.size.width-2, 1);
        if (i==0 || i==5) {
            lineView.backgroundColor = [UIColor colorWithRed:0.820 green:0.592 blue:0.714 alpha:1.00];
        }
        [self addSubview:lineView];
    }
}

//- (void )setSleepQulityDataValues:(NSMutableArray *)sleepQulityDataValues
//{
//    if (self.sleepQualityArr.count > 0) {
//        self.sleepQualityArr = nil;
//    }
//    self.sleepQualityArr = sleepQulityDataValues;
//}
/**
 *  创建x轴坐标
 */
-(void)setUpCoordinateSystem // 利用UIView作为坐标轴动态画出坐标系
{
    UIView *xCoordinate = [self getLineCoor];
    [self addSubview:xCoordinate];
    
    UILabel *labelLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 1, self.frame.size.height - bottomLineMargin)];
    labelLine.alpha = 0.5;
    labelLine.backgroundColor = [UIColor whiteColor];
    [self addSubview:labelLine];
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
    lineView.alpha = 0.5;
    lineView.frame = CGRectMake(0, self.frame.size.height - bottomLineMargin, self.frame.size.width, 1);
    return lineView;
}

#pragma mark - 添加坐标轴的值
-(void)setXValues:(NSArray *)values
{
    for (UIView *view in self.subviews) {
        if (view.tag == 1001||view.tag==1002) {
            [view removeFromSuperview];
        }
    }
    if (self.xPoints.count > 0) {
        [self.xPoints removeAllObjects];
    }
    if (values.count){
        NSUInteger count = values.count;
        for (int i = 0; i < count; i++) {
            NSString *xValue = values[i];
            
            CGFloat cX = 0;
            cX = ((xCoordinateWidth) / (count)) * i;
            
            CGFloat cY = self.frame.size.height - bottomLineMargin;
            // 收集坐标点
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(cX, cY+5, ((xCoordinateWidth)/(count)), 10)];
            label.backgroundColor = [UIColor clearColor];
            label.text = xValue;
            label.tag = 1001;
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            [self addSubview:label];
            //
            UILabel *labelLine = [[UILabel alloc]initWithFrame:CGRectMake(cX+(xCoordinateWidth)/(count)/2, 0, 0.5, cY-5)];
            labelLine.backgroundColor = [UIColor colorWithRed:0.784 green:0.788 blue:0.792 alpha:1.00];
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


- (void)drawFuncLine
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[SleepQualityBar class]]) {
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:[SleepTimeLongBar class]]) {
            [view removeFromSuperview];
        }
        if (view.tag == 999) {
            [view removeFromSuperview];
        }
    }
    
    //睡眠质量
    for (int i=0; i<_sleepQulityDataValues.count; i++) {
        float gradePercent = [[_sleepQulityDataValues objectAtIndex:i] floatValue];
        CGPoint xPoint = [[self.xPoints objectAtIndex:i]CGPointValue];
        CGFloat height = (yCoordinateHeight-15-20)/100*gradePercent*20;
        float test = [[_sleepTimeDataValues objectAtIndex:i] floatValue];
        if (height == 0 && test) {
            height = 3;
        }
        __block SleepQualityBar *bar = [[SleepQualityBar alloc] initWithFrame:CGRectMake(xPoint.x+5, 15+(yCoordinateHeight-15)-height-5, 5,height) andGrade:(int)gradePercent];
        bar.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{
            bar.alpha = 1;
        } completion:^(BOOL finished) {
            if (gradePercent!=0) {
//                UILabel *label = [self getTopLabelWithLevel:gradePercent andColor:[self returnColorWithSleepLevel:gradePercent] andFrame:CGRectMake(xPoint.x-7, 15+(yCoordinateHeight-15)-height- 20-12, 40, 20)];
//                label.tag = 999;
//                [self addSubview:label];
//                CGAffineTransform transform = label.transform;
//                transform = CGAffineTransformRotate(transform, -1.2);
//                label.transform = transform;
            }
        }];
        [self addSubview:bar];
    }
    //睡眠时长
    for (int i=0; i<_sleepTimeDataValues.count; i++) {
        float gradePercent = [[_sleepTimeDataValues objectAtIndex:i] floatValue];
        CGPoint xPoint = [[self.xPoints objectAtIndex:i]CGPointValue];
        CGFloat height = (yCoordinateHeight-15-20)/24*gradePercent;
        __block SleepTimeLongBar *bar = [[SleepTimeLongBar alloc] initWithFrame:CGRectMake(xPoint.x-9, 15+(yCoordinateHeight-15)-height-5, 5,height)];
        bar.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{
            bar.alpha = 1;
        } completion:^(BOOL finished) {
            /*
            if (gradePercent!=0) {
                UILabel *label = [self getTopLabelWithTime:gradePercent andColor:[self returnColorWithSleepLevel:gradePercent] andFrame:CGRectMake(xPoint.x, 15+(yCoordinateHeight-15)-height- 20-8, 36, 12)];
                label.tag = 999;
                label.textAlignment = NSTextAlignmentLeft;
                label.backgroundColor = [UIColor clearColor];
                [self addSubview:label];
                CGAffineTransform transform = label.transform;
                transform = CGAffineTransformRotate(transform, -1.2);
                label.transform = transform;
            }
             */
        }];
        [self addSubview:bar];
    }

    
}

- (UIColor *)returnColorWithSleepLevel:(int)colorIndex
{
    switch (colorIndex) {
        case 1:{
            return [self colorWithHex:0x3D4E5E alpha:1.0];
            break;
        }
        case 2:{
            return [self colorWithHex:0x8AB8E2 alpha:1.0];
            break;
        }
        case 3:{
            return [self colorWithHex:0xFCAE3C alpha:1.0];
            break;
        }
        case 4:{
            return [self colorWithHex:0x23A7E4 alpha:1.0];
            break;
        }
        case 5:{
            return [self colorWithHex:0x30C704 alpha:1.0];
            break;
        }
            
        default:
            return [UIColor clearColor];
            break;
    }
}

- (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
}

- (UILabel *)getTopLabelWithLevel:(float)level andColor:(UIColor*)scolor andFrame:(CGRect )frame
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = [self changeNumToWord:level];
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = scolor;
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}

- (UILabel *)getTopLabelWithTime:(float)level andColor:(UIColor*)scolor andFrame:(CGRect )frame
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = [NSString stringWithFormat:@"%.2fh",level];
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = selectedThemeIndex==0?[UIColor colorWithRed:0.000f green:0.855f blue:0.573f alpha:1.00f]:[UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (NSString *)changeNumToWord:(int)level
{
    switch (level) {
        case 1:{
            return @"非常差";
            break;
        }
        case 2:{
            return @"差";
            break;
        }
        case 3:{
            return @"一般";
            break;
        }
        case 4:{
            return @"好";
            break;
        }
        case 5:{
            return @"非常好";
            break;
        }
            
        default:
            return @"";
            break;
    }
}


- (void)reloadChartView
{
    [self drawFuncLine];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
