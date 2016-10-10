//
//  AppSettingTableViewCell.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/21.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "AppSettingTableViewCell.h"

@interface AppSettingTableViewCell ()
@property (nonatomic, strong) UILabel *title;
@end

@implementation AppSettingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _title = [[UILabel alloc]init];
        _title.textColor = [UIColor colorWithRed:0.016 green:0.020 blue:0.024 alpha:1.00];
        _title.font = [UIFont systemFontOfSize:16];
        [self addSubview:_title];
        [_title makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(46);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    return self;
}

- (void)configure:(UITableViewCell *)cell
        customObj:(id)obj
        indexPath:(NSIndexPath *)indexPath
{
    // Rewrite this func in SubClass !
    if (indexPath.section == 2) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor whiteColor];
        self.title.hidden = YES;
        cell.textLabel.text = obj;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor colorWithRed:0.502 green:0.827 blue:1.000 alpha:1.00];
    }else if (indexPath.section == 1 && indexPath.row == 1){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.textLabel.text = obj;
        self.title.text = obj;
        self.title.hidden = NO;
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
        self.title.text = obj;
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.imageView.contentMode = UIViewContentModeScaleToFill;
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"toux1"];
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lightGrayColor];
        line.alpha = 0.3;
        [self addSubview:line];
        [line makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom).offset(0);
            make.height.equalTo(@0.5);
        }];
    }else if (indexPath.section == 0 && indexPath.row == 1){
        cell.imageView.image = [UIImage imageNamed:@"mim"];
    }else if (indexPath.section == 1 && indexPath.row == 0){
        cell.imageView.image = [UIImage imageNamed:@"xieyi"];
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lightGrayColor];
        line.alpha = 0.3;
        [self addSubview:line];
        [line makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom).offset(0);
            make.height.equalTo(@0.5);
        }];

    }else if (indexPath.section == 1 && indexPath.row == 1){
        cell.imageView.image = [UIImage imageNamed:@"guanyu"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
}
@end
