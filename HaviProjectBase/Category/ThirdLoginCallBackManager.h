//
//  ThirdLoginCallBackManager.h
//  HaviProjectBase
//
//  Created by Havi on 16/2/28.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThirdLoginCallBackManager : NSObject

+ (instancetype)sharedInstance;

- (BOOL)weixinCallBackHandleOpenURL:(NSURL *)url;

- (BOOL)weiboCallBackHandleOpenURL:(NSURL *)url;

- (BOOL)tencentCallBackHandleOpenURL:(NSURL *)url;

@end
