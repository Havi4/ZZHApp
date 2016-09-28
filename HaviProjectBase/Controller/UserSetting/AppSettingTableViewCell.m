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
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"toux1"];
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line];
        [line makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom).offset(0);
            make.height.equalTo(@1);
        }];
    }else if (indexPath.section == 0 && indexPath.row == 1){
        cell.imageView.image = [UIImage imageNamed:@"mim"];
    }else if (indexPath.section == 1 && indexPath.row == 0){
        cell.imageView.image = [UIImage imageNamed:@"xieyi"];
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line];
        [line makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom).offset(0);
            make.height.equalTo(@1);
        }];

    }else if (indexPath.section == 1 && indexPath.row == 1){
        cell.imageView.image = [UIImage imageNamed:@"guanyu"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
}
@end
