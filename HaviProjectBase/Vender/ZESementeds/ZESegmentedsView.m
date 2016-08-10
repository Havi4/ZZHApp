//
//  ZESegmentedsView.m
//  
//
//  Created by wzm on 16/4/8.
//  Copyright © 2016年 wzm. All rights reserved.
//

#import "ZESegmentedsView.h"

@implementation ZESegmentedsView

- (instancetype)initWithFrame:(CGRect)frame
               segmentedCount:(NSInteger)segmentedCount
              segmentedTitles:(NSArray *)titleArr {
    
    NSInteger semtViewWidth  = frame.size.width - ((NSInteger)frame.size.width%segmentedCount);
    NSInteger semtViewHeight = frame.size.height;
    
    if (self == [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, semtViewWidth, semtViewHeight)]) {
        
  
        

        NSInteger itemsWidth = semtViewWidth/segmentedCount;
        NSInteger itemsHeight = semtViewHeight;
        
        int j;
        
        for (int i = 0; i < segmentedCount; i++) {
            
            //NSLog(@"添加了%d个btn",i);
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            CGFloat x = i * itemsWidth;
            CGFloat y = 0;
            
            btn.frame = CGRectMake(x, y, itemsWidth, itemsHeight);
            btn.backgroundColor = [UIColor clearColor];
            btn.tag = 1000 + i;
            btn.layer.masksToBounds = YES;
        
            [btn setTitle:titleArr[i] forState:UIControlStateNormal];
            [btn setTitleColor:kReportCellColor forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
            
            [self addSubview:btn];
            
            j = i;
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake( x+ itemsWidth, y, 1, itemsHeight)];
            lineView.backgroundColor = kReportCellColor;
                
            [self addSubview:lineView];
    
            
    
            
            [btn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
            
            
            
        }
        
        
    }
    
    self.layer.borderColor = kReportCellColor.CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = self.frame.size.height/2;
    self.layer.masksToBounds = YES;
    

    
    return self;
}


#pragma mark - 按钮点击事件


- (void)clickItem:(UIButton *)btn {
    if (_delegate && [_delegate respondsToSelector:@selector(selectedZESegmentedsViewItemAtIndex:)]) {
        
        [_delegate selectedZESegmentedsViewItemAtIndex:btn.tag - 1000];
        
    }
    /*
    //NSLog(@"点击了btn");
    UIButton *btn1 = [self viewWithTag:1000];
    UIButton *btn2 = [self viewWithTag:1001];
    UIButton *btn3 = [self viewWithTag:1002];
    btn.backgroundColor = kReportCellColor;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    switch (btn.tag) {
        case 1000:
            btn2.backgroundColor = [UIColor clearColor];
            [btn2 setTitleColor:kReportCellColor forState:UIControlStateNormal];
            btn3.backgroundColor = [UIColor clearColor];
            [btn3 setTitleColor:kReportCellColor forState:UIControlStateNormal];
            if (_delegate && [_delegate respondsToSelector:@selector(selectedZESegmentedsViewItemAtIndex:)]) {
                
                [_delegate selectedZESegmentedsViewItemAtIndex:btn.tag - 1000];
                
            }
            break;
        case 1001:
            btn1.backgroundColor = [UIColor clearColor];
            [btn1 setTitleColor:kReportCellColor forState:UIControlStateNormal];
            btn3.backgroundColor = [UIColor clearColor];
            [btn3 setTitleColor:kReportCellColor forState:UIControlStateNormal];
            if (_delegate && [_delegate respondsToSelector:@selector(selectedZESegmentedsViewItemAtIndex:)]) {
                
                [_delegate selectedZESegmentedsViewItemAtIndex:btn.tag - 1000];
                
            }
            break;
        case 1002:
            btn2.backgroundColor = [UIColor clearColor];
            [btn2 setTitleColor:kReportCellColor forState:UIControlStateNormal];
            btn1.backgroundColor = [UIColor clearColor];
            [btn1 setTitleColor:kReportCellColor forState:UIControlStateNormal];
            if (_delegate && [_delegate respondsToSelector:@selector(selectedZESegmentedsViewItemAtIndex:)]) {
                
                [_delegate selectedZESegmentedsViewItemAtIndex:btn.tag - 1000];
                
            }
            break;
            
        default:
            break;
    }
    */
//        btn.backgroundColor = kReportCellColor;
//        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)setSelectIndex:(int)index
{
    UIButton *btn = [self viewWithTag:1000+index];
    btn.backgroundColor = kReportCellColor;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

@end
