//
//  MonthTableViewCell.h
//  HaviProjectBase
//
//  Created by Havi on 16/8/1.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonthTableViewCell : UITableViewCell
- (void)configure:(UITableViewCell *)cell
        customObj:(id)obj
        indexPath:(NSIndexPath *)indexPath
    withOtherInfo:(id)objInfo;
@end
