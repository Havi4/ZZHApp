//
//  EditInfoCellTableViewCell.h
//  HaviProjectBase
//
//  Created by Havi on 16/2/13.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HaviBaseTableViewCell.h"

@interface EditInfoCellTableViewCell : HaviBaseTableViewCell

@property (nonatomic, copy) void (^tapTextSaveBlock)(NSString *textValue);

@property (nonatomic, copy) void (^textChanageBlock)(NSString *textValue);

@end
