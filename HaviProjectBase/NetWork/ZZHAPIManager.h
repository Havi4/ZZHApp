//
//  ZZHAPIManager.h
//  HaviModel
//
//  Created by Havi on 15/12/25.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HaviNetWorkAPIClient.h"
#import "ServerTimeModel.h"
#import "AddUserModel.h"
#import "UserInfoDetailModel.h"
#import "FriendListModel.h"
#import "BeingRequestModel.h"
#import "TagListModel.h"
#import "SensorInfoModel.h"
#import "MyDeviceListModel.h"
#import "GlobalModel.h"
#import "SensorDataModel.h"
#import "SleepQualityModel.h"

@interface ZZHAPIManager : NSObject

+ (id)sharedAPIManager;

//获取服务器时间

- (void)requestServerTimeWithBlock:(void (^)(ServerTimeModel *serVerTime , NSError *error))blcok;

//添加用户

- (void)requestAddUserWithParams:(NSDictionary *)params andBlock:(void (^)(AddUserModel *userModel, NSError *error))block;

//用户登录

- (void)requestUserLoginWithParam:(NSDictionary *)params andBlock:(void(^)(AddUserModel *loginModel, NSError *error))block;
//获取用户信息

- (void)requestUserInfoWithParam:(NSDictionary *)params andBlock:(void (^)(UserInfoDetailModel *userInfo,NSError *error))block;

//修改用户信息

- (void)requestChangeUserInfoParam:(NSDictionary *)params andBlock:(void (^)(BaseModel *resultModel, NSError *error))block;

//搜索好友

- (void)requestSearchFriendParam:(NSDictionary *)params andBlock:(void (^)(FriendListModel *friendModel, NSError *error))block;

//请求好友列表

- (void)requestBeingRequestFriendParam:(NSDictionary *)params andBlock:(void (^)(BeingRequestModel *beingModel, NSError *error))block;

//申请添加为好友

- (void)requestRequestToAddFriendParam:(NSDictionary *)params andBlock:(void (^)(BaseModel *resultModel,NSError *error))block;

//同意，拒绝

- (void)requestChangeFriendRequestStatus:(NSDictionary *)params andBlock:(void (^)(BaseModel *resultModel,NSError *error))block;

//删除好友

- (void)requestRemoveFriendParam:(NSDictionary *)params andBlock:(void (^)(BaseModel *resultModel,NSError *error))block;

//添加用户标签

- (void)requestAddUserTagsParams:(NSDictionary *)params andBlock:(void (^)(BaseModel *resultModel,NSError *error))block;

//查看用户标签

- (void)requestCheckUserTagsParams:(NSDictionary *)params andBlock:(void (^)(TagListModel *tagListModel,NSError *error))block;

//查看sensorinfo

- (void)requestCheckSensorInfoParams:(NSDictionary *)params andBlcok:(void (^)(SensorInfoModel *sensorModel,NSError *error))block;

//查看我的设备列表

- (void)requestCheckMyDeviceListParams:(NSDictionary *)params andBlock:(void (^)(MyDeviceListModel *myDeviceList,NSError *error))block;

//查看朋友列表

- (void)requestCheckFriendDeviceListParams:(NSDictionary *)params andBlock:(void (^)(MyDeviceListModel *friendDevice,NSError *error))block;

//用户关联设备

- (void)requestUserBindingDeviceParams:(NSDictionary *)params andBlock:(void (^)(BaseModel *resultModel,NSError *error))block;

//激活我的设备

- (void)requestActiveMyDeviceParams:(NSDictionary*)params andBlock:(void (^)(BaseModel *resultModel,NSError *error))block;
//激活朋友
- (void)requestActiveFriendDeviceParams:(NSDictionary*)params andBlock:(void (^)(BaseModel *resultModel,NSError *error))block;

//重命名我的设备

- (void)requestRenameMyDeviceParams:(NSDictionary*)params andBlock:(void (^)(BaseModel *resultModel,NSError *error))block;

//重命名他人设备

- (void)requestRenameFriendDeviceParams:(NSDictionary*)params andBlock:(void (^)(BaseModel *resultModel,NSError *error))block;

//删除设备

- (void)requestRemoveDeviceParams:(NSDictionary*)params andBlock:(void (^)(BaseModel *resultModel,NSError *error))block;

//获取全局参数

- (void)requestGetGlobalParamtersParams:(NSDictionary *)params andBlock:(void (^)(GlobalModel *globalModel,NSError *error))block;
//查看传感器数据

- (void)requestGetSensorDataParams:(NSDictionary *)params andBlock:(void (^)(SensorDataModel *sensorModel,NSError *error))block;

//睡眠质量

- (void)requestGetSleepQualityParams:(NSDictionary *)params andBlock:(void (^)(SleepQualityModel *qualityModel,NSError *error))block;

- (void)uploadImage:(UIImage *)image path:(NSString *)path name:(NSString *)name
       successBlock:(void (^)(id responseObject))success
       failureBlock:(void (^)(NSError *error))failure
      progerssBlock:(void (^)(CGFloat progressValue))progress;


@end
