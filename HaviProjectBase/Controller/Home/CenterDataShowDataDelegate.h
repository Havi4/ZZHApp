//
//  DataShowDataDelegate.h
//  HaviProjectBase
//
//  Created by Havi on 16/2/23.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "BaseTableViewDataDelegate.h"

typedef enum {
    cellTapEndTime = 0,
    cellTapWantSleep,
} cellTapType;

@interface CenterDataShowDataDelegate : BaseTableViewDataDelegate

@property (nonatomic, copy) void (^cellSelectedTaped)(id callBackResult ,cellTapType type);

@end
