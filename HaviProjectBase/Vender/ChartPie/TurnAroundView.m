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
        [self setDashLine];
        
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
        if (tx != 0) {
            float cX = ((xCoordinateWidth-25) / (24)) * i;
            CGFloat cY = 0;
            if (tx > 24) {
                cY = self.frame.size.height-bottomLineMargin-(self.frame.size.height - bottomLineMargin)/24 * 24;
            }else{
                cY = self.frame.size.height-bottomLineMargin-5-(self.frame.size.height - bottomLineMargin-15)/24 * tx;
            }
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = 9000;
            button.frame = (CGRect){cX,cY,15,15};
            [button setTitle:[NSString stringWithFormat:@"%d",tx] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:9];
            [self addSubview:button];
            button.backgroundColor = [UIColor grayColor];
            if (tx < 6 || tx == 6) {
                button.backgroundColor = [UIColor colorWithRed:0.369 green:0.757 blue:0.451 alpha:1.00];
                button.layer.cornerRadius = 7.5;
            }else if (tx > 6 && (tx < 7 || tx == 7)){
                button.frame = (CGRect){cX,cY,20,20};
                button.backgroundColor = [UIColor colorWithRed:0.561 green:0.906 blue:0.980 alpha:1.00];
                button.layer.cornerRadius = 10;
            }else if (tx > 7){
                button.frame = (CGRect){cX,cY,25,25};
                button.backgroundColor = [UIColor colorWithRed:0.800 green:0.729 blue:0.184 alpha:1.00];
                button.layer.cornerRadius = 12.5;

            }
        }
    }
    
}

- (void)setDashLine
{
    CGFloat cY = (200 - bottomLineMargin-16)/7;
    for (int i = 0; i<6; i++) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.5];
        lineView.alpha = 0.5;
        lineView.frame = CGRectMake(2, 16 + cY*i+10, self.frame.size.width-2, 0.5);
        [self addSubview:lineView];
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
            cX = ((xCoordinateWidth-25) / (count-1)) * i;
            
            CGFloat cY = self.frame.size.height - bottomLineMargin;
            // 收集坐标点
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(cX-15, cY+3, ((xCoordinateWidth)/(count)), 10)];
            label.backgroundColor = [UIColor clearColor];
            label.text = xValue;
            label.tag = 1001;
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            [self addSubview:label];
            if (i==0) {
                label.frame = CGRectMake(cX-6, cY+3, ((xCoordinateWidth)/(count)), 10);
            }
            //
//            UILabel *labelLine = [[UILabel alloc]initWithFrame:CGRectMake(cX+(xCoordinateWidth)/(count)/2, 0, 0.5, cY)];
            UILabel *labelLine = [[UILabel alloc]initWithFrame:CGRectMake(cX +5, 0, 0.5, cY)];
            if (i==0) {
                labelLine.frame = CGRectMake(cX, 0, 0.5, cY);
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

@end
