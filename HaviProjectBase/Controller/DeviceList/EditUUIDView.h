//
//  EditUUIDView.h
//  HaviProjectBase
//
//  Created by Havi on 16/2/19.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditUUIDView : UIView

@property (nonatomic, copy) void (^bindDeviceButtonTaped)(NSString *barUUID);

@property (nonatomic, copy) void (^scanBarButtonTaped)(NSInteger index);

@end
