//
//  DataAnTableViewCell.h
//  HaviProjectBase
//
//  Created by Havi on 16/7/27.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataAnTableViewCell : UITableViewCell
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *badge;
@property (nonatomic, strong) UIButton    *weekButton;
@property (nonatomic, strong) UIButton    *monthButton;
@property (nonatomic, strong) UIButton    *quaterButton;


+ (CGFloat)getCellHeight;

- (void)resetCell;
@end
