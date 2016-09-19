//
//  ConsultGenderTableViewCell.h
//  HaviProjectBase
//
//  Created by Havi on 16/9/11.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConsultGenderTableViewCell : UITableViewCell

@property (nonatomic, copy) void (^selectGenderBlock)(NSInteger genderIndex);

@end
