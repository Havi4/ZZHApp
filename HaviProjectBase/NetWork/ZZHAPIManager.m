//
//  ZZHAPIManager.m
//  HaviModel
//
//  Created by Havi on 15/12/25.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import "ZZHAPIManager.h"
static ZZHAPIManager *_apiManager = nil;
@implementation ZZHAPIManager

+ (id)sharedAPIManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _apiManager = [[ZZHAPIManager alloc]init];
    });
    return _apiManager;
}
//
- (void)requestServerTimeWithBlock:(void (^)(ServerTimeModel *serVerTime , NSError *error))block
{
    NSString *aPath = @"v1/app/GetServerTime";
    [[HaviNetWorkAPIClient sharedJSONClient]requestJSONDataWithPath:aPath withParams:nil withNetWorkMethod:Get andBlock:^(id data, NSError *error) {
        NSDictionary *dic = (NSDictionary *)data;
        ServerTimeModel *serverModel = [ServerTimeModel modelWithDictionary:dic];
        block(serverModel,error);
    }];
}

//获取专家建议表

- (void)requestAssessmentListWithBlock:(void (^)(AssessmentListModel *assessList , NSError *error))blcok
{
    NSString *aPath = @"v1/app/AssessmentList";
    [[HaviNetWorkAPIClient sharedJSONClient]requestJSONDataWithPath:aPath withParams:nil withNetWorkMethod:Get andBlock:^(id data, NSError *error) {
        NSDictionary *dic = (NSDictionary *)data;
        NSArray *arrList = [dic objectForKey:@"Assessments"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (int i = 0; i<arrList.count; i++) {
                NSDictionary *dic = [arrList objectAtIndex:i];
                [[NSUserDefaults standardUserDefaults]setObject:dic forKey:[NSString stringWithFormat:@"%@",[dic objectForKey:@"Code"]]];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
        });
        //不需要回调
//        AssessmentListModel *serverModel = [AssessmentListModel modelWithDictionary:dic];
//        blcok(serverModel,error);
    }];
}

- (void)requestAddUserWithParams:(NSDictionary *)params andBlock:(void (^)(AddUserModel *userModel, NSError *error))block
{
    NSString *aPath = @"v1/user/UserRegister";
    [[HaviNetWorkAPIClient sharedJSONClient]requestJSONDataWithPath:aPath withParams:params withNetWorkMethod:Post andBlock:^(id data, NSError *error) {
        NSDictionary *dic = (NSDictionary *)data;
        AddUserModel *userModel = [AddUserModel modelWithDictionary:dic];
        block(userModel,error);
    }];
}

- (void)requestUserLoginWithParam:(NSDictionary *)params andBlock:(void(^)(AddUserModel *loginModel, NSError *error))block
{
    NSString *aPath = [NSString stringWithFormat:@"v1/user/UserLogin?UserIDOrigianal=%@&Password=%@",[params objectForKey:@"UserIDOrigianal"],[params objectForKey:@"Password"]];
    [[HaviNetWorkAPIClient sharedJSONClient]requestJSONDataWithPath:aPath withParams:params withNetWorkMethod:Get andBlock:^(id data, NSError *error) {
        NSDictionary *dic = (NSDictionary *)data;
        AddUserModel *loginModel = [AddUserModel modelWithDictionary:dic];
        block(loginModel,error);
    }];
}

- (void)requestUserInfoWithParam:(NSDictionary *)params andBlock:(void (^)(UserInfoDetailModel *userInfo,NSError *error))block
{
    NSString *aPath = @"v1/user/UserInfo";
    [[HaviNetWorkAPIClient sharedJSONClient]requestJSONDataWithPath:aPath withParams:params withNetWorkMethod:Get andBlock:^(id data, NSError *error) {
        NSDictionary *dic = (NSDictionary *)data;
        UserInfoDetailModel *userInfoModel = [UserInfoDetailModel modelWithDictionary:dic];
        block(userInfoModel,error);
    }];
}

//常看异常数据
- (void)requestCheckSensorDataIrregularInfoParams:(NSDictionary *)params andBlcok:(void (^)(SensorDataModel *sensorModel,NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"v1/app/SensorDataIrregular?UUID=%@&DataProperty=%d&FromDate=%@&EndDate=%@&FromTime=18:00&EndTime=18:00",[params objectForKey:@"UUID"],[[params objectForKey:@"DataProperty"]intValue],[params objectForKey:@"FromDate"],[params objectForKey:@"EndDate"]];
    [[HaviNetWorkAPIClient sharedJSONClient]requestJSONDataWithPath:urlString withParams:params withNetWorkMethod:Get andBlock:^(id data, NSError *error) {
        NSDictionary *dic = (NSDictionary *)data;
        SensorDataModel *loginModel = [SensorDataModel modelWithDictionary:dic];
        block(loginModel,error);
    }];
}

- (void)requestChangeUserInfoParam:(NSDictionary *)params andBlock:(void (^)(BaseModel *resultModel, NSError *error))block
{
    NSString *aPath = @"v1/user/ModifyUserInfo";
    [[HaviNetWorkAPIClient sharedJSONClient]requestJSONDataWithPath:aPath withParams:params withNetWorkMethod:Put andBlock:^(id data, NSError *error) {
        NSDictionary *dic = (NSDictionary *)data;
        BaseModel *resultModel = [BaseModel modelWithDictionary:dic];
        block(resultModel,error);
    }];
}

- (void)requestSearchFriendParam:(NSDictionary *)params andBlock:(void (^)(FriendListModel *friendModel, NSError *error))block
{
    NSString *aPath = @"v1/user/FindUsers";
    [[HaviNetWorkAPIClient sharedJSONClient]requestJSONDataWithPath:aPath withParams:params withNetWorkMethod:Get andBlock:^(id data, NSError *error) {
        NSDictionary *dic = (NSDictionary *)data;
        FriendListModel *friendListModel = [FriendListModel modelWithDictionary:dic];
        block(friendListModel,error);
    }];
}

- (void)requestBeingRequestFriendParam:(NSDictionary *)params andBlock:(void (^)(BeingRequestModel *beingModel, NSError *error))block
{
    NSString *aPath = @"v1/user/BeingRequestedUsers";
    [[HaviNetWorkAPIClient sharedJSONClient]requestJSONDataWithPath:aPath withParams:params withNetWorkMethod:Get andBlock:^(id data, NSError *error) {
        NSDictionary *dic = (NSDictionary *)data;
        BeingRequestModel *beingListModel = [BeingRequestModel modelWithDictionary:dic];
        block(beingListModel,error);
    }];
}

- (void)requestRequestToAddFriendParam:(NSDictionary *)params andBlock:(void (^)(BaseModel *resultModel,NSError *error))block
{
    NSString *aPath = @"v1/user/RequestToAddFriend";
    [[HaviNetWorkAPIClient sharedJSONClient]requestJSONDataWithPath:aPath withParams:params withNetWorkMethod:Post andBlock:^(id data, NSError *error) {
        NSDictionary *dic = (NSDictionary *)data;
        BaseModel *resultModel = [BaseModel modelWithDictionary:dic];
        block(resultModel,error);
    }];
}

- (void)requestChangeFriendRequestStatus:(NSDictionary *)params andBlock:(void (^)(BaseModel *resultModel,NSError *error))block
{
    NSString *aPath = @"v1/user/GrantToAddFriend";
    [[HaviNetWorkAPIClient sharedJSONClient]requestJSONDataWithPath:aPath withParams:params withNetWorkMethod:Put andBlock:^(id data, NSError *error) {
        NSDictionary *dic = (NSDictionary *)data;
        BaseModel *resultModel = [BaseModel modelWithDictionary:dic];
        block(resultModel,error);
    }];
}

- (void)requestRemoveFriendParam:(NSDictionary *)params andBlock:(void (^)(BaseModel *resultModel,NSError *error))block
{
    NSString *aPath = @"v1/user/RemoveFriend";
    [[HaviNetWorkAPIClient sharedJSONClient]requestJSONDataWithPath:aPath withParams:params withNetWorkMethod:Put andBlock:^(id data, NSError *error) {
        NSDictionary *dic = (NSDictionary *)data;
        BaseModel *resultModel = [BaseModel modelWithDictionary:dic];
        block(resultModel,error);
    }];
}

- (void)requestAddUserTagsParams:(NSDictionary *)params andBlock:(void (^)(BaseModel *resultModel,NSError *error))block
{
    NSString *aPath = @"v1/user/UpdateUserTag";
    [[HaviNetWorkAPIClient sharedJSONClient]requestJSONDataWithPath:aPath withParams:params withNetWorkMethod:Post andBlock:^(id data, NSError *error) {
        NSDictionary *dic = (NSDictionary *)data;
        BaseModel *resultModel = [BaseModel modelWithDictionary:dic];
        block(resultModel,error);
    }];
}

- (void)requestCheckUserTagsParams:(NSDictionary *)params andBlock:(void (^)(TagListModel *tagListModel,NSError *error))block
{
    NSString *aPath = [NSString stringWithFormat:@"v1/user/UserTags?UserId=%@&FromDate=%@&EndDate=%@&FromTime=18:00&EndTime=18:00",thirdPartyLoginUserId,[params objectForKey:@"FromDate"],[params objectForKey:@"EndDate"]];
    [[HaviNetWorkAPIClient sharedJSONClient]requestJSONDataWithPath:aPath withParams:params withNetWorkMethod:Get andBlock:^(id data, NSError *error) {
        NSDictionary *dic = (NSDictionary *)data;
        TagListModel *tagModel = [TagListModel modelWithDictionary:dic];
        block(tagModel,error);
    }];
}

- (void)requestCheckSensorInfoParams:(NSDictionary *)params andBlcok:(void (^)(SensorInfoModel *sensorModel,NSError *error))block
{
    NSString *aPath = @"v1/app/SensorInfo";
    [[HaviNetWorkAPIClient sharedJSONClient]requestJSONDataWithPath:aPath withParams:params withNetWorkMethod:Get andBlock:^(id data, NSError *error) {
        NSDictionary *dic = (NSDictionary *)data;
        SensorInfoModel *sensorModel = [SensorInfoModel modelWithDictionary:dic];
        block(sensorModel,error);
    }];
}

- (void)requestCheckAllDeviceListParams:(NSDictionary *)params andBlock:(void (^)(AllDeviceModel *myDeviceList,NSError *error))block
{
    NSString *aPath = @"v1/user/UserAndFriendDevices";
    [[HaviNetWorkAPIClient sharedJSONClient]requestJSONDataWithPath:aPath withParams:params withNetWorkMethod:Get andBlock:^(id data, NSError *error) {
        NSDictionary *dic = (NSDictionary *)data;
        AllDeviceModel *myDeviceModel = [AllDeviceModel modelWithDictionary:dic];
        block(myDeviceModel,error);
    }];
}

- (void)requestCheckMyDeviceListParams:(NSDictionary *)params andBlock:(void (^)(MyDeviceListModel *myDeviceList,NSError *error))block
{
    NSString *aPath = @"v1/user/UserDeviceList";
    [[HaviNetWorkAPIClient sharedJSONClient]requestJSONDataWithPath:aPath withParams:params withNetWorkMethod:Get andBlock:^(id data, NSError *error) {
        NSDictionary *dic = (NSDictionary *)data;
        MyDeviceListModel *myDeviceModel = [MyDeviceListModel modelWithDictionary:dic];
        block(myDeviceModel,error);
    }];
}

//查看朋友列表

- (void)requestCheckFriendDeviceListParams:(NSDictionary *)params andBlock:(void (^)(MyDeviceListModel *friendDevice,NSError *error))block
{
    NSString *aPath = @"v1/user/FriendDeviceList";
    [[HaviNetWorkAPIClient sharedJSONClient]requestJSONDataWithPath:aPath withParams:params withNetWorkMethod:Get andBlock:^(id data, NSError *error) {
        NSDictionary *dic = (NSDictionary *)data;
        MyDeviceListModel *myDeviceModel = [MyDeviceListModel modelWithDictionary:dic];
        block(myDeviceModel,error);
    }];
}

- (void)requestUserBindingDeviceParams:(NSDictionary *)params andBlock:(void (^)(BaseModel *resultModel,NSError *error))block
{
    NSString *aPath = @"v1/user/RegisterUserDevice";
    [[HaviNetWorkAPIClient sharedJSONClient]requestJSONDataWithPath:aPath withParams:params withNetWorkMethod:Post andBlock:^(id data, NSError *error) {
        NSDictionary *dic = (NSDictionary *)data;
        BaseModel *resultModel = [BaseModel modelWithDictionary:dic];
        block(resultModel,error);
    }];
}

- (void)requestActiveMyDeviceParams:(NSDictionary*)params andBlock:(void (^)(BaseModel *resultModel,NSError *error))block
{
    NSString *aPath = @"v1/user/ActivateUserDevice";
    [[HaviNetWorkAPIClient sharedJSONClient]requestJSONDataWithPath:aPath withParams:params withNetWorkMethod:Put andBlock:^(id data, NSError *error) {
        NSDictionary *dic = (NSDictionary *)data;
        BaseModel *resultModel = [BaseModel modelWithDictionary:dic];
        block(resultModel,error);
    }];
}
//激活朋友
- (void)requestActiveFriendDeviceParams:(NSDictionary*)params andBlock:(void (^)(BaseModel *resultModel,NSError *error))block
{
    NSString *aPath = @"v1/user/ActivateFriendDevice";
    [[HaviNetWorkAPIClient sharedJSONClient]requestJSONDataWithPath:aPath withParams:params withNetWorkMethod:Put andBlock:^(id data, NSError *error) {
        NSDictionary *dic = (NSDictionary *)data;
        BaseModel *resultModel = [BaseModel modelWithDictionary:dic];
        block(resultModel,error);
    }];
}

- (void)requestRenameMyDeviceParams:(NSDictionary*)params andBlock:(void (^)(BaseModel *resultModel,NSError *error))block
{
    NSString *aPath = @"v1/user/RenameUserDevice";
    [[HaviNetWorkAPIClient sharedJSONClient]requestJSONDataWithPath:aPath withParams:params withNetWorkMethod:Put andBlock:^(id data, NSError *error) {
        NSDictionary *dic = (NSDictionary *)data;
        BaseModel *resultModel = [BaseModel modelWithDictionary:dic];
        block(resultModel,error);
    }];
}

//重命名他人设备

- (void)requestRenameFriendDeviceParams:(NSDictionary*)params andBlock:(void (^)(BaseModel *resultModel,NSError *error))block
{
    NSString *aPath = @"v1/user/RenameFriendDevice";
    [[HaviNetWorkAPIClient sharedJSONClient]requestJSONDataWithPath:aPath withParams:params withNetWorkMethod:Put andBlock:^(id data, NSError *error) {
        NSDictionary *dic = (NSDictionary *)data;
        BaseModel *resultModel = [BaseModel modelWithDictionary:dic];
        block(resultModel,error);
    }];
}

- (void)requestRemoveDeviceParams:(NSDictionary*)params andBlock:(void (^)(BaseModel *resultModel,NSError *error))block
{
    NSString *aPath = @"v1/user/DeleteUserDevice";
    [[HaviNetWorkAPIClient sharedJSONClient]requestJSONDataWithPath:aPath withParams:params withNetWorkMethod:Put andBlock:^(id data, NSError *error) {
        NSDictionary *dic = (NSDictionary *)data;
        BaseModel *resultModel = [BaseModel modelWithDictionary:dic];
        block(resultModel,error);
    }];
}

//推送id
- (void)requestRegisterUserIdForPush:(NSDictionary *)params andBlock:(void (^)(BaseModel *baseModel,NSError *error))block
{
    NSString *aPath = @"v1/user/UpdateLoginInfo";
    [[HaviNetWorkAPIClient sharedJSONClient]requestJSONDataWithPath:aPath withParams:params withNetWorkMethod:Post andBlock:^(id data, NSError *error) {
        NSDictionary *dic = (NSDictionary *)data;
        BaseModel *globalModel = [BaseModel modelWithDictionary:dic];
        block(globalModel,error);
    }];
}

- (void)requestGetGlobalParamtersParams:(NSDictionary *)params andBlock:(void (^)(GlobalModel *globalModel,NSError *error))block
{
    NSString *aPath = @"v1/app/GlobalParameter";
    [[HaviNetWorkAPIClient sharedJSONClient]requestJSONDataWithPath:aPath withParams:params withNetWorkMethod:Get andBlock:^(id data, NSError *error) {
        NSDictionary *dic = (NSDictionary *)data;
        GlobalModel *globalModel = [GlobalModel modelWithDictionary:dic];
        block(globalModel,error);
    }];
}

- (void)requestGetSensorDataParams:(NSDictionary *)params andBlock:(void (^)(SensorDataModel *sensorModel,NSError *error))block
{
    NSString *aPath = [NSString stringWithFormat:@"v1/app/SensorDataHistory?UUID=%@&DataProperty=%@&FromDate=%@&EndDate=%@&FromTime=18:00&EndTime=18:00",[params objectForKey:@"UUID"],[params objectForKey:@"DataProperty"],[params objectForKey:@"FromDate"],[params objectForKey:@"EndDate"]];
    [[HaviNetWorkAPIClient sharedJSONClient]requestJSONDataWithPath:aPath withParams:nil withNetWorkMethod:Get andBlock:^(id data, NSError *error) {
        NSDictionary *dic = (NSDictionary *)data;
        SensorDataModel *sensorModel = [SensorDataModel modelWithDictionary:dic];
        block(sensorModel,error);
    }];
}

- (void)requestGetSleepQualityParams:(NSDictionary *)params andBlock:(void (^)(SleepQualityModel *qualityModel,NSError *error))block
{
    
    NSString *aPath = [NSString stringWithFormat:@"v1/app/SleepQuality?UUID=%@&UserId=%@&FromDate=%@&EndDate=%@&FromTime=18:00&EndTime=18:00",[params objectForKey:@"UUID"],thirdPartyLoginUserId,[params objectForKey:@"FromDate"],[params objectForKey:@"EndDate"]];
    [[HaviNetWorkAPIClient sharedJSONClient]requestJSONDataWithPath:aPath withParams:params withNetWorkMethod:Get andBlock:^(id data, NSError *error) {
        NSDictionary *dic = (NSDictionary *)data;
        SleepQualityModel *sleepModel = [SleepQualityModel modelWithDictionary:dic];
        block(sleepModel,error);
    }];
}

- (void)uploadImage:(UIImage *)image path:(NSString *)path name:(NSString *)name successBlock:(void (^)(id))success failureBlock:(void (^)(NSError *))failure progerssBlock:(void (^)(CGFloat))progress
{
    [[HaviNetWorkAPIClient sharedJSONClient]uploadImage:image path:path name:name successBlock:success failureBlock:failure progerssBlock:progress];
}

@end
