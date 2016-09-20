//
//  ConversationListTableViewCell.h
//  HaviProjectBase
//
//  Created by Havi on 16/9/12.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JASwipeCell.h"

@interface ConversationListTableViewCell : JASwipeCell

- (void)configCellWithDic:(id)para;
@property (nonatomic, copy) void (^didSelectedAssessmentButton)(NSString *problemID);

@end
