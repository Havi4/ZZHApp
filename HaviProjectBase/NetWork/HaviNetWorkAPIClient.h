//
//  HaviNetWorkAPIClient.h
//  HaviProjectBase
//
//  Created by Havi on 16/2/3.
//  Copyright © 2016年 Havi. All rights reserved.
//
#import <CoreFoundation/CoreFoundation.h>
#import <AFNetworking/AFNetworking.h>

#define requestBlock void (^)(id data,NSError *error)

/**
 *  定义网络请求类型
 */
typedef enum {
    Get = 0,
    Post,
    Put,
    Delete,
} NetWorkMethod;

@interface HaviNetWorkAPIClient : AFHTTPSessionManager

/**
 *  网路请求单例
 *
 *  @return 单例对象
 */

+ (instancetype)sharedJSONClient;

/**
 *  切换网络请求单例
 *
 *  @return 单例对象
 */

+ (instancetype)changedJSONClient;

/**
 *  http client
 *
 *  @param requestPath   http path to requst source
 *  @param requestParams request params
 *  @param requestMethod request type
 *  @param block         completion blcok
 */

- (void)requestJSONDataWithPath:(NSString *)requestPath
                     withParams:(NSDictionary *)requestParams
              withNetWorkMethod:(NetWorkMethod)requestMethod
                       andBlock:(void (^)(id data, NSError *error))block;

- (void)uploadImage:(UIImage *)image path:(NSString *)path name:(NSString *)name
       successBlock:(void (^)(id responseObject))success
       failureBlock:(void (^)(NSError *error))failure
      progerssBlock:(void (^)(CGFloat progressValue))progress;

@end
