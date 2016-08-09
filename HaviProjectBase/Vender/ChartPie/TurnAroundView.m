//
//  TurnAroundView.m
//  HaviProjectBase
//
//  Created by Havi on 16/8/9.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "TurnAroundView.h"
#import "ReportViewDefine.h"

@interface TurnAroundView ()

@property (strong, nonatomic) NSDictionary   *textStyleDict;
@property (strong, nonatomic) NSMutableArray *xPoints;
@property (strong, nonatomic) NSMutableArray *funcPoints;
@property (nonatomic, strong) UIImageView *leftImage;
@property (nonatomic, strong) UIImageView *rightImage;

@end

@implementation TurnAroundView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self setUpCoordinateSystem];
        //        [self setBackImage];
        
    }
    return self;
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
    lineView.frame = CGRectMake(0, self.frame.size.height - bottomLineMargin, self.frame.size.width, 0.5);
    return lineView;
}



#pragma mark - 添加坐标轴的值

- (void)setDataValues:(NSMutableArray *)dataValues
{
    for (UIView *view in self.subviews) {
        if (view.tag == 9000) {
            [view removeFromSuperview];
        }
    }
    for (int i = 0; i<dataValues.count; i++) {
        int tx = [dataValues[i] intValue];
        float percent = self.frame.size.width/(24*60);
        float x = tx * percent;
        CGFloat cY = self.frame.size.height - bottomLineMargin;
        UIView *sub = [[UIView alloc]initWithFrame:(CGRect){x,0,1,cY}];
        sub.tag = 9000;
        sub.backgroundColor = [UIColor colorWithRed:0.784 green:0.753 blue:0.235 alpha:1.00];
        [self addSubview:sub];
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
            [self.xPoints addObject:[NSValue valueWithCGPoint:CGPointMake(labelLine.frame.origin.x, cY)]];
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

@end
