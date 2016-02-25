//
//  UITableViewCell+ConfigureTableViewCell.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/4.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "UITableViewCell+ConfigureTableViewCell.h"

@implementation UITableViewCell (ConfigureTableViewCell)

#pragma mark - Rewrite these func in SubClass !
- (void)configure:(UITableViewCell *)cell
        customObj:(id)obj
        indexPath:(NSIndexPath *)indexPath
{
    // Rewrite this func in SubClass !
    
}

- (void)configure:(UITableViewCell *)cell
        customObj:(id)obj
        indexPath:(NSIndexPath *)indexPath
    withOtherInfo:(id)objInfo
{
    // Rewrite this func in SubClass !
    
}

+ (CGFloat)getCellHeightWithCustomObj:(id)obj
                            indexPath:(NSIndexPath *)indexPath
{
    // Rewrite this func in SubClass if necessary
    if (!obj) {
        return 0.0f ; // if obj is null .
    }
    return 49.0f ; // default cell height
}

+ (CGFloat)getCellHeightWithCustomObj:(id)obj
                            indexPath:(NSIndexPath *)indexPath
                         withOtherObj:(id)otherObj
{
    // Rewrite this func in SubClass if necessary
    if (!obj) {
        return 0.0f ; // if obj is null .
    }
    return 44.0f ; // default cell height
}

@end
