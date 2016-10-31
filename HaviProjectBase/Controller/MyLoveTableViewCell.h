//
//  MyLoveTableViewCell.h
//  HaviProjectBase
//
//  Created by HaviLee on 2016/10/31.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JASwipeCell.h"

@interface MyLoveTableViewCell : JASwipeCell

- (void)cellConfigWithItem:(id)item andIndex:(NSIndexPath *)indexPath;

@end
