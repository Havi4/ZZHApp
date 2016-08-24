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
    if (indexPath.section == 3) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.text = obj;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor colorWithRed:0.502 green:0.827 blue:1.000 alpha:1.00];
    }else if (indexPath.section == 1 && indexPath.row == 1){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = obj;
        cell.backgroundColor = [UIColor whiteColor];
        UILabel *versionLabel = [[UILabel alloc]init];
        versionLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        versionLabel.textColor = [UIColor grayColor];
        versionLabel.font= [UIFont systemFontOfSize:15];
        [self addSubview:versionLabel];
        [versionLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right).offset(-24);
        }];
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = obj;
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
}
@end
