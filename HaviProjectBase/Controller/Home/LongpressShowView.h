//
//  LongpressShowView.h
//  HaviProjectBase
//
//  Created by Havi on 16/4/20.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPGraphView.h"

@interface LongpressShowView : UIView

@property (nonatomic,strong) MPGraphView *heartViewLeft;
/**
 *  x轴的坐标值
 */
@property (strong, nonatomic) NSArray *xValues;

@property (strong, nonatomic) NSMutableArray *dataValues;

- (void)removeLine;

- (void)addlineView;

@end
