//
//  NSObject+Common.m
//  HaviModel
//
//  Created by Havi on 15/12/28.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import "NSObject+Common.h"
//#import "NSString+Common.h"

#define kPath_ImageCache @"ImageCache"
#define kPath_ResponseCache @"ResponseCache"

#define kTestKey @"BaseURLIsTest"
#import "ZZHNetWorkAPIClient.h"


@implementation NSObject (Common)

#pragma mark baseUrl 处理url
//处理基本的BaseUrl
+ (NSString *)baseURLStr
{
    NSString *baseURLStr = nil;
    if ([self baseURLStrIsTest]) {
        baseURLStr = AppTestBaseURL;
    }else{
        baseURLStr = AppBaseURL;
    }
    return baseURLStr;
}

+ (BOOL)baseURLStrIsTest
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [[userDefault objectForKey:kTestKey] boolValue];
}

+ (void)changeBaseURLStrToTest:(BOOL)isTest
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:@(isTest) forKey:kTestKey];
    [userDefault synchronize];
    //将api中的client改变为测试环境
    [ZZHNetWorkAPIClient changedJSONClient];
    //我们可以在切换之后进行其他的操作，比如改变导航栏的颜色
    [[UINavigationBar appearance] setBackgroundImage: [UIImage imageWithColor:[UIColor colorWithHexString:isTest?@"0x3bbd79": @"0x28303b"]] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark 进行文件缓存
//首先获取文件的路径
+ (NSString *)pathInCacheDirectory:(NSString *)fileName
{
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cachePaths objectAtIndex:0];
    return [cachePath stringByAppendingPathComponent:fileName];
}

//创建缓存文件夹、、无论做什么缓存首先要做的看看这个文件夹是否存在
+ (BOOL) createDirInCache:(NSString *)dirName
{
    NSString *dirPath = [self pathInCacheDirectory:dirName];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //不存在创建文件夹
    BOOL existed = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    BOOL isCreated = NO;
    if ( !(isDir == YES && existed == YES) )
    {
        isCreated = [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (existed) {
        isCreated = YES;
    }
    return isCreated;
}

// 图片缓存到本地
+ (BOOL) saveImage:(UIImage *)image imageName:(NSString *)imageName inFolder:(NSString *)folderName
{
    if (!image) {
        return NO;
    }
    if (!folderName) {
        folderName = kPath_ImageCache;
    }
    if ([self createDirInCache:folderName]) {
        NSString * directoryPath = [self pathInCacheDirectory:folderName];
        BOOL isDir = NO;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL existed = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDir];
        bool isSaved = false;
        if ( isDir == YES && existed == YES )
        {
            isSaved = [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:imageName] options:NSAtomicWrite error:nil];
        }
        return isSaved;
    }else{
        return NO;
    }
}

// 获取缓存图片

+ (NSData*) loadImageDataWithName:( NSString *)imageName inFolder:(NSString *)folderName
{
    if (!folderName) {
        folderName = kPath_ImageCache;
    }
    //文件夹路径
    NSString * directoryPath = [self pathInCacheDirectory:folderName];
    BOOL isDir = NO;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL dirExisted = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDir];
    if ( isDir == YES && dirExisted == YES )
    {
        NSString *abslutePath = [NSString stringWithFormat:@"%@/%@", directoryPath, imageName];
        BOOL fileExisted = [fileManager fileExistsAtPath:abslutePath];
        if (!fileExisted) {
            return NULL;
        }
        NSData *imageData = [NSData dataWithContentsOfFile : abslutePath];
        return imageData;
    }
    else
    {
        return NULL;
    }
}

// 删除图片缓存

+ (BOOL) deleteImageCacheInFolder:(NSString *)folderName{
    if (!folderName) {
        folderName = kPath_ImageCache;
    }
    return [self deleteCacheWithPath:folderName];
}


//网络请求

+ (BOOL)saveResponseData:(NSDictionary *)data toPath:(NSString *)requestPath{
//    User *loginUser = [Login curLoginUser];
    //对于只有登录成功的才进行缓存
    BOOL loginUser = YES;
    if (!loginUser) {
        return NO;
    }else{
        requestPath = [NSString stringWithFormat:@"%@_%@", @"tocken", requestPath];
    }
    if ([self createDirInCache:kPath_ResponseCache]) {
        NSString *abslutePath = [NSString stringWithFormat:@"%@/%s.plist", [self pathInCacheDirectory:kPath_ResponseCache], [requestPath UTF8String]];
        return [data writeToFile:abslutePath atomically:YES];
    }else{
        return NO;
    }
}

+ (id) loadResponseWithPath:(NSString *)requestPath{//返回一个NSDictionary类型的json数据
//    User *loginUser = [Login curLoginUser];
    BOOL loginUser = NO;
    if (!loginUser) {
        return nil;
    }else{
        requestPath = [NSString stringWithFormat:@"%@_%@", @"tocken", requestPath];
    }
    NSString *abslutePath = [NSString stringWithFormat:@"%@/%s.plist", [self pathInCacheDirectory:kPath_ResponseCache], [requestPath UTF8String]];
    return [NSMutableDictionary dictionaryWithContentsOfFile:abslutePath];
}

+ (BOOL)deleteResponseCacheForPath:(NSString *)requestPath{
    BOOL loginUser = NO;
    if (!loginUser) {
        return NO;
    }else{
        requestPath = [NSString stringWithFormat:@"%@_%@", @"tocken", requestPath];
    }
    NSString *abslutePath = [NSString stringWithFormat:@"%@/%s.plist", [self pathInCacheDirectory:kPath_ResponseCache], [requestPath UTF8String]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:abslutePath]) {
        return [fileManager removeItemAtPath:abslutePath error:nil];
    }else{
        return NO;
    }
}

+ (BOOL) deleteResponseCache{
    return [self deleteCacheWithPath:kPath_ResponseCache];
}

+ (BOOL) deleteCacheWithPath:(NSString *)cachePath{
    NSString *dirPath = [self pathInCacheDirectory:cachePath];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    bool isDeleted = false;
    if ( isDir == YES && existed == YES )
    {
        isDeleted = [fileManager removeItemAtPath:dirPath error:nil];
    }
    return isDeleted;
}

//处理网络失败

@end
