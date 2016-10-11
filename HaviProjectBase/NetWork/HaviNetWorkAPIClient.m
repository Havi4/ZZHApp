//
//  HaviNetWorkAPIClient.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/3.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "HaviNetWorkAPIClient.h"
#import "NSObject+Common.h"

#define kNetworkMethodName @[@"Get", @"Post", @"Put", @"Delete"]

static HaviNetWorkAPIClient *_netWorkClient;

@implementation HaviNetWorkAPIClient

+ (instancetype)sharedJSONClient
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _netWorkClient = [[HaviNetWorkAPIClient alloc]initWithBaseURL:[NSURL URLWithString:[self baseURLStr]]];
    });
    return _netWorkClient;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
#pragma tocken正式ok后注释掉下一行
//        [self.requestSerializer setValue:@"A29#XXFDs1-FDKSD-JGLjx2" forHTTPHeaderField:@"AccessToken"];
        [self.requestSerializer setValue:url.absoluteString forHTTPHeaderField:@"Referer"];
    }
    return self;
}

#pragma mark 切换url 具体什么需求可以在app中进行切换环境

+ (id)changedJSONClient
{
    _netWorkClient = [[HaviNetWorkAPIClient alloc]initWithBaseURL:[NSURL URLWithString:[self baseURLStr]]];
    return _netWorkClient;
}

#pragma mark 网络请求

- (void)requestJSONDataWithPath:(NSString *)requestPath
                     withParams:(NSDictionary *)requestParams
              withNetWorkMethod:(NetWorkMethod)requestMethod
                       andBlock:(void (^)(id data, NSError *error))block
{
    [self requestJSONDataWithPath:requestPath withParams:requestParams withMethodType:requestMethod withShowError:YES andBlock:block];
}

- (void)requestJSONDataWithPath:(NSString *)aPath withParams:(NSDictionary *)params withMethodType:(NetWorkMethod)method withShowError:(BOOL)autoShowError andBlock:(void (^)(id data, NSError *error))block
{
    if (aPath.length ==0 || !aPath) {
        return;
    }
    if (![netReachability isReachable] && netReachability) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [NSObject showHudTipStr:@"没有网络，请检查您的网络"];
        });
        block(nil,nil);
        return;
    }
    [[UIApplication sharedApplication]incrementNetworkActivityCount];
    DeBugLog(@"\n网络请求log========request=========\n%@\n%@:\n%@", kNetworkMethodName[method], aPath, params);
    aPath = [aPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    switch (method) {
        case Get:{
            //所有的get请求添加缓存机制
            [NSObject showHud];
            NSMutableString *localPath = [aPath mutableCopy];
            if (params) {
                [localPath appendString:params.description];
            }
            [self GET:aPath parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
                
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [NSObject hideHud];
                [[UIApplication sharedApplication]decrementNetworkActivityCount];
                DeBugLog(@"\n=====response=======\n\n%@:\n%@", aPath, responseObject);
                id error = [self handleResponse:responseObject autoShowError:autoShowError];
                if (error) {
                    responseObject = [NSObject loadResponseWithPath:localPath];
                    block(responseObject,error);
                }else{
                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
                        //判断数据是否符合预期，给出提示
                        [NSObject saveResponseData:responseObject toPath:localPath];
                    }
                    block(responseObject, nil);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [NSObject hideHud];
                [[UIApplication sharedApplication]decrementNetworkActivityCount];
                [NSObject showError:error];
                id responseObject = [NSObject loadResponseWithPath:localPath];
                block(responseObject, error);
                
            }];
            break;
        }
        case 1:{
            [NSObject showHud];
            [self POST:aPath parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [[UIApplication sharedApplication]decrementNetworkActivityCount];
                [NSObject hideHud];
                DeBugLog(@"\n===========response===========\n%@:\n%@", aPath, responseObject);
                id error = [self handleResponse:responseObject autoShowError:autoShowError];
                if (!error) {
                    block(responseObject, nil);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [NSObject hideHud];
                [[UIApplication sharedApplication]decrementNetworkActivityCount];
                !autoShowError || [NSObject showError:error];
//                block(nil, error);
            }];
            break;
        }
        case 2:{
            [NSObject showHud];
            [self PUT:aPath parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [NSObject hideHud];
                [[UIApplication sharedApplication]decrementNetworkActivityCount];
                DeBugLog(@"\n===========response===========\n%@:\n%@", aPath, responseObject);
                id error = [self handleResponse:responseObject autoShowError:autoShowError];
                if (!error) {
                    block(responseObject, nil);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [NSObject hideHud];
                [[UIApplication sharedApplication]decrementNetworkActivityCount];
                DeBugLog(@"\n===========response===========\n%@:\n%@", aPath, error);
                !autoShowError || [NSObject showError:error];
            }];
            break;
        }
        case 3:{
            [self DELETE:aPath parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [[UIApplication sharedApplication]decrementNetworkActivityCount];
                DeBugLog(@"\n===========response===========\n%@:\n%@", aPath, responseObject);
                id error = [self handleResponse:responseObject autoShowError:autoShowError];
                if (!error) {
                    block(responseObject, nil);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [[UIApplication sharedApplication]decrementNetworkActivityCount];
                DeBugLog(@"\n===========response===========\n%@:\n%@", aPath, error);
                !autoShowError || [NSObject showError:error];
            }];
            break;
        }
        default:
            break;
    }
}

- (void)uploadImage:(UIImage *)image path:(NSString *)path name:(NSString *)name
       successBlock:(void (^)(id responseObject))success
       failureBlock:(void (^)(NSError *error))failure
      progerssBlock:(void (^)(CGFloat progressValue))progress{
    
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    if ((float)data.length/1024 > 1000) {
        data = UIImageJPEGRepresentation(image, 1024*1000.0/(float)data.length);
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@_%@.jpg", @"LI", str];
    DeBugLog(@"\nuploadImageSize\n%@ : %.0f", fileName, (float)data.length/1024);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:accessTocken forHTTPHeaderField:@"AccessToken"];
    [manager POST:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:name fileName:fileName mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        CGFloat progressValue = (float)uploadProgress.completedUnitCount/(float)uploadProgress.totalUnitCount;
        if (progress) {
            progress(progressValue);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DeBugLog(@"Success: ***** %@", responseObject);
        id error ;
        if (error && failure) {
            failure(error);
        }else{
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DeBugLog(@"Error: ***** %@", error);
        if (failure) {
            failure( error);
        }

    }];
    
//    AFHTTPRequestOperation *operation = [self POST:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileData:data name:name fileName:fileName mimeType:@"image/jpeg"];
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        DeBugLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
//        id error ;
//        if (error && failure) {
//            failure(operation, error);
//        }else{
//            success(operation, responseObject);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        DeBugLog(@"Error: %@ ***** %@", operation.responseString, error);
//        if (failure) {
//            failure(operation, error);
//        }
//    }];
//    
//    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//        CGFloat progressValue = (float)totalBytesWritten/(float)totalBytesExpectedToWrite;
//        if (progress) {
//            progress(progressValue);
//        }
//    }];
//    [operation start];
}

#pragma mark 缓存作用

@end
