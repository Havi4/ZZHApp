//
//  ThirdLoginCallBackManager.h
//  HaviProjectBase
//
//  Created by Havi on 16/2/28.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface ThirdLoginCallBackManager : NSObject

@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) NSString *wbCurrentUserID;
@property (strong, nonatomic) TencentOAuth *tencentOAuth;

+ (instancetype)sharedInstance;

- (void)initTencentCallBackHandle;

- (BOOL)weixinCallBackHandleOpenURL:(NSURL *)url;

- (BOOL)weiboCallBackHandleOpenURL:(NSURL *)url;

- (BOOL)tencentCallBackHandleOpenURL:(NSURL *)url;

@end
