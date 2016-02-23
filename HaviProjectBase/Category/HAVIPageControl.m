//
//  HAVIPageControl.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/23.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "HAVIPageControl.h"

@implementation HAVIPageControl


- (void)setCurrentPage:(NSInteger)page {
    [super setCurrentPage:page];
    [self updateDots];
}

-(void) updateDots

{
    for (int i=0; i<[self.subviews count]; i++) {
        
        UIImageView* dot = [self.subviews objectAtIndex:i];
        
        CGSize size;
        
        size.height = 4;     //自定义圆点的大小
        
        size.width = 4;      //自定义圆点的大小
        [dot setFrame:CGRectMake(dot.frame.origin.x+2, dot.frame.origin.y, size.width, size.width)];
        dot.layer.cornerRadius = 2;
        dot.layer.masksToBounds = YES;
    }
    
}

@end
