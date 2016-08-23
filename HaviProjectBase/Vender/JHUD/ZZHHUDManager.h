//
//  ZZHHUDManager.h
//  HaviProjectBase
//
//  Created by Havi on 16/8/23.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZHHUDManager : JHUD

+ (instancetype)shareHUDInstance;

- (void)showHUDWithView:(UIView *)view;

- (void)hideHUD;


@end
