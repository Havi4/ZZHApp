//
//  ZESegmentedsViewSingleton.h
//  
//
//  Created by wzm on 16/4/8.
//  Copyright © 2016年 wzm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>




@interface ZESegmentedsViewSingleton : NSObject



/**
 *  创建单例
 */
+ (ZESegmentedsViewSingleton *)shareManager;

- (void)showSementedViewWithTarget:(UIViewController *)target
                             frame:(CGRect)frame
                     sementedCount:(NSInteger)sementedCount
                    sementedTitles:(NSArray *)titleArr;

- (void)setSelectIndex:(int)index;


@end
