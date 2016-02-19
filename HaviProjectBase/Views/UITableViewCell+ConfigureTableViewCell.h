//
//  UITableViewCell+ConfigureTableViewCell.h
//  HaviProjectBase
//
//  Created by Havi on 16/2/4.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (ConfigureTableViewCell)

- (void)configure:(UITableViewCell *)cell customObj:(id)obj indexPath:(NSIndexPath *)indexPath;

- (void)configure:(UITableViewCell *)cell
        customObj:(id)obj
        indexPath:(NSIndexPath *)indexPath
    withOtherInfo:(id)objInfo;

+ (CGFloat)getCellHeightWithCustomObj:(id)obj indexPath:(NSIndexPath *)indexPath;

+ (CGFloat)getCellHeightWithCustomObj:(id)obj
                            indexPath:(NSIndexPath *)indexPath
                         withOtherObj:(id)otherObj;

@end
