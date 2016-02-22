//
//  AppSettingTableViewCell.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/21.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "AppSettingTableViewCell.h"

@implementation AppSettingTableViewCell

- (void)configure:(UITableViewCell *)cell
        customObj:(id)obj
        indexPath:(NSIndexPath *)indexPath
{
    // Rewrite this func in SubClass !
    if (indexPath.section == 2) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.text = obj;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor redColor];
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = obj;
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
}
@end
