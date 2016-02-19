//
//  IconImageView.h
//  HaviProjectBase
//
//  Created by Havi on 16/2/3.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IconImageView : UIView

@property (nonatomic, strong) NSString *userIconURL;

@property (nonatomic, strong) NSString *userName;

@property (nonatomic, copy) void (^tapIconBlock)(NSUInteger index);

@end
