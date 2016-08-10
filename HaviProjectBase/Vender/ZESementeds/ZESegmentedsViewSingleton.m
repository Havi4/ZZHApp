//
//  ZESegmentedsViewSingleton.m
//  
//
//  Created by wzm on 16/4/8.
//  Copyright © 2016年 wzm. All rights reserved.
//

#import "ZESegmentedsViewSingleton.h"

#import "ZESegmentedsView.h"

@interface ZESegmentedsViewSingleton ()

@property (nonatomic, strong) ZESegmentedsView * semtsView;

@end


@implementation ZESegmentedsViewSingleton


/**
 *  创建单例
 */
+ (ZESegmentedsViewSingleton *)shareManager {
    static ZESegmentedsViewSingleton *_sementedMenuSingleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sementedMenuSingleton = [[ZESegmentedsViewSingleton alloc]init];
    });
    return _sementedMenuSingleton;
    
}

- (void)showSementedViewWithTarget:(UIViewController *)target
                             frame:(CGRect)frame
                     sementedCount:(NSInteger)sementedCount
                    sementedTitles:(NSArray *)titleArr {
    
    self.semtsView = [[ZESegmentedsView alloc] initWithFrame:frame segmentedCount:sementedCount segmentedTitles:titleArr];
    
    self.semtsView.delegate = target;
    
    self.semtsView.backgroundColor = [UIColor whiteColor];
   
      [target.view addSubview:self.semtsView];
    
    
}

- (void)setSelectIndex:(int)index
{
    [self.semtsView setSelectIndex:index];
}


@end
