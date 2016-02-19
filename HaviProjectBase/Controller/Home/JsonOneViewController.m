//
//  JsonOneViewController.m
//  HaviModel
//
//  Created by Havi on 15/12/5.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import "JsonOneViewController.h"
#import "ServerTimeModelTwo.h"
#import "ZZHAPIManager.h"
//nsession测试

@interface JsonOneViewController ()

@property (strong, nonatomic) UITextView *txShowJsonView;
@property (strong, nonatomic) UILabel *llShowMutbleJsonView;
@property (strong, nonatomic) NSMutableString *showString;

@end

@implementation JsonOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initControllerData];
    [self getServerTime];
}
#pragma mark init controller data

- (void)initControllerData
{
    [self.view addSubview:self.txShowJsonView];
//    [self.view addSubview:self.llShowMutbleJsonView];
    _showString = [[NSMutableString alloc]init];
}

#pragma mark setter meathod

- (UITextView *)txShowJsonView
{
    if (!_txShowJsonView) {
        _txShowJsonView = [[UITextView alloc]initWithFrame:self.view.bounds];
        _txShowJsonView.backgroundColor = [UIColor lightGrayColor];
        
    }
    return _txShowJsonView;
}

- (UILabel *)llShowMutbleJsonView
{
    if (!_llShowMutbleJsonView) {
        _llShowMutbleJsonView = [[UILabel alloc]init];
        _llShowMutbleJsonView.frame = CGRectMake(0, 210, self.view.frame.size.width, 40);
        _llShowMutbleJsonView.backgroundColor = [UIColor lightGrayColor];
        _llShowMutbleJsonView.font = [UIFont systemFontOfSize:12];
        
    }
    return _llShowMutbleJsonView;
}

#pragma mark queryData from sever

- (void)getServerTime
{
    
    //
    ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
    /*
    [client requestServerTimeWithBlock:^(ServerTimeModel *serVerTime, NSError *error) {
        NSString *_strModelChange = [NSString stringWithFormat:@"获取服务器时间：返回值Key:%@,返回错误信息是%@ 时间是%@\n",serVerTime.returnCode,serVerTime.errorMessage,serVerTime.date];
        [_showString appendString:_strModelChange];
            _txShowJsonView.text = _showString;
    }];
    //
    
    NSDictionary *dic = @{
                          @"CellPhone": @"13122785595", //手机号码
                          @"Email": @"", //邮箱地址，可留空，扩展注册用
                          @"Password": @"li" ,//传递明文，服务器端做加密存储
                          @"UserValidationServer" : @"meddo99.com",
                          @"UserIdOriginal":@""
                          };
    [client requestAddUserWithParams:dic andBlock:^(AddUserModel *userModel, NSError *error) {
        NSString *_strModelChange = [NSString stringWithFormat:@"注册新用户：返回值Key:%@,返回错误信息是%@ 时间是%@,用户id:%@\n",userModel.returnCode,userModel.errorMessage,userModel.date,userModel.userId];
        [_showString appendString:_strModelChange];
        _txShowJsonView.text = _showString;
    }];
    //登录
    NSDictionary *dic1 = @{
                           @"UserIDOrigianal":@"13122785292",
                           @"Password": @"1" ,//传递明文，服务器端做加密存储
                           };
    [client requestUserLoginWithParam:dic1 andBlock:^(AddUserModel *loginModel, NSError *error) {
        NSString *_strModelChange = [NSString stringWithFormat:@"登录：返回值Key:%@,返回错误信息是%@ 时间是%@,用户id:%@\n",loginModel.returnCode,loginModel.errorMessage,loginModel.date,loginModel.userId];
        [_showString appendString:_strModelChange];
        _txShowJsonView.text = _showString;
    }];
    //用户信息
    NSDictionary *dic2 = @{
                           @"UserID":UserID,
                           };
    [client requestUserInfoWithParam:dic2 andBlock:^(UserInfoDetailModel *userInfo, NSError *error) {
        NSString *_strModelChange = [NSString stringWithFormat:@"用户信息：返回值Key:%@,返回错误信息是%@ 时间是%@,用户id:%@,%@,%@\n",userInfo.returnCode,userInfo.errorMessage,userInfo.date,userInfo.nUserInfo.description,userInfo.nUserInfo.cellPhone,userInfo.nUserInfo.emergencyContact];
        [_showString appendString:_strModelChange];
        _txShowJsonView.text = _showString;
    }];
    //修改用户信息
    NSDictionary *dic3 = @{
                           @"UserID":UserID,
                           @"UserName": @"李四", //真实姓名
                           };
    [client requestChangeUserInfoParam:dic3 andBlock:^(BaseModel *resultModel, NSError *error) {
        NSString *_strModelChange = [NSString stringWithFormat:@"修改用户信息：返回值Key:%@,返回错误信息是%@ 时间是%@,用户id:\n",resultModel.returnCode,resultModel.errorMessage,resultModel.date];
        [_showString appendString:_strModelChange];
        _txShowJsonView.text = _showString;
    }];
    //搜索好友列表
    NSDictionary *dic4 = @{
                           @"SelectionCriteria":@"13122785292",
                           };
    [client requestSearchFriendParam:dic4 andBlock:^(FriendListModel *friendModel, NSError *error) {
        NSString *_strModelChange = [NSString stringWithFormat:@"搜索用户信息：返回值Key:%@,返回错误信息是%@ 时间是%@,用户id:\n",friendModel.returnCode,friendModel.errorMessage,friendModel.date];
        [_showString appendString:_strModelChange];
        UserList *userName = [friendModel.userList objectAtIndex:0];
        [_showString appendString:[NSString stringWithFormat:@"%@",userName.userName]];
        
        _txShowJsonView.text = _showString;
    }];
    //请求的好友列表
    NSDictionary *dic5 = @{
                           @"UserId":UserID,
                           };
    [client requestBeingRequestFriendParam:dic5 andBlock:^(BeingRequestModel *beingModel, NSError *error) {
        NSString *_strModelChange = [NSString stringWithFormat:@"好友请求：返回值Key:%@,返回错误信息是%@ 时间是%@,用户id:\n",beingModel.returnCode,beingModel.errorMessage,beingModel.date];
        [_showString appendString:_strModelChange];
        UserList *userName = [beingModel.beingRequestUserList objectAtIndex:0];
        [_showString appendString:[NSString stringWithFormat:@"%@",userName.userName]];
        
        _txShowJsonView.text = _showString;
    }];
    //申请为好友
    NSDictionary *dic6 = @{
                           @"RequestUserId": @"meddo99.com$13122785295", //申请加好友的人
                           @"ResponseUserId": @"meddo99.com$13122785292", //被请求的用户
                           @"Comment": @"我是***，请加我好友" //备注
                           };
    [client requestRequestToAddFriendParam:dic6 andBlock:^(BaseModel *resultModel, NSError *error) {
        NSString *_strModelChange = [NSString stringWithFormat:@"发出好友请求：返回值Key:%@,返回错误信息是%@ 时间是%@,用户id:\n",resultModel.returnCode,resultModel.errorMessage,resultModel.date];
        [_showString appendString:_strModelChange];
        
        _txShowJsonView.text = _showString;
    }];
    //同意拒绝
    NSDictionary *dic7 = @{
                           @"RequestUserId": @"meddo99.com$13122785295", //申请加好友的人
                           @"ResponseUserId": @"meddo99.com$13122785292", //被请求的用户
                           @"StatusCode": @"1" //备注
                           };
    [client requestChangeFriendRequestStatus:dic7 andBlock:^(BaseModel *resultModel, NSError *error) {
        NSString *_strModelChange = [NSString stringWithFormat:@"好友请求状态改变：返回值Key:%@,返回错误信息是%@ 时间是%@,用户id:\n",resultModel.returnCode,resultModel.errorMessage,resultModel.date];
        [_showString appendString:_strModelChange];
        
        _txShowJsonView.text = _showString;
    }];
    //删除好友
    NSDictionary *dic8 = @{
                           @"RequestUserId": @"meddo99.com$13122785295", //申请加好友的人
                           @"ResponseUserId": @"meddo99.com$13122785292", //被请求的用户
                           };
    [client requestRemoveFriendParam:dic8 andBlock:^(BaseModel *resultModel, NSError *error) {
        NSString *_strModelChange = [NSString stringWithFormat:@"删除好友：返回值Key:%@,返回错误信息是%@ 时间是%@,用户id:\n",resultModel.returnCode,resultModel.errorMessage,resultModel.date];
        [_showString appendString:_strModelChange];
        
        _txShowJsonView.text = _showString;
    }];
    
    //添加标签
    NSDictionary *dic9 = @{
        @"UserID": UserID, //供以后数据统计提供支持
        @"Tags":  @[
                  @{
                      @"Tag": @"运动健身",
                      @"TagType": @"-1",  //-1:睡前，1:睡眠
                      @"UserTagDate": @"2015-03-15 23:54:49"
                  },
                  @{
                      @"Tag": @"失眠",
                      @"TagType": @"1",
                      @"UserTagDate": @"2015-03-15 23:54:49"
                  }
                  ],
        };
    [client requestAddUserTagsParams:dic9 andBlock:^(BaseModel *resultModel, NSError *error) {
        NSString *_strModelChange = [NSString stringWithFormat:@"添加用户标签：返回值Key:%@,返回错误信息是%@ 时间是%@,用户id:\n",resultModel.returnCode,resultModel.errorMessage,resultModel.date];
        [_showString appendString:_strModelChange];
        
        _txShowJsonView.text = _showString;
    }];
    //常看标签
    NSDictionary *dic10 = @{
                           @"FromDate": @"20150314", //申请加好友的人
                           @"EndDate": @"2015015", //被请求的用户
                           };
    [client requestCheckUserTagsParams:dic10 andBlock:^(TagListModel *tagListModel, NSError *error) {
        NSString *_strModelChange = [NSString stringWithFormat:@"查看用户标签：返回值Key:%@,返回错误信息是%@ 时间是%@,用户id:\n",tagListModel.returnCode,tagListModel.errorMessage,tagListModel.date];
        [_showString appendString:_strModelChange];
        
        _txShowJsonView.text = _showString;
    }];
    //查看sensor信息
    NSDictionary *dic11 = @{
                            @"UUID": @"161b63e838d1",
                            };
    [client requestCheckSensorInfoParams:dic11 andBlcok:^(SensorInfoModel *sensorModel, NSError *error) {
        NSString *_strModelChange = [NSString stringWithFormat:@"传感器信息：返回值Key:%@,返回错误信息是%@ 时间是%@\n",sensorModel.returnCode,sensorModel.sensorDetail.isAnybodyOnBed,sensorModel.sensorDetail.factoryCode];
        [_showString appendString:_strModelChange];
        
        _txShowJsonView.text = _showString;
    }];
    //查看我的设备
    NSDictionary *dic12 = @{
                            @"UserID":UserID,
                            };
    [client requestCheckMyDeviceListParams:dic12 andBlock:^(MyDeviceListModel *myDeviceList, NSError *error) {
        NSString *_strModelChange = [NSString stringWithFormat:@"我的设备列表：返回值Key:%@,返回错误信息是%@ 时间是%@\n",myDeviceList.returnCode,[myDeviceList.deviceList objectAtIndex:0],myDeviceList.deviceList];
        [_showString appendString:_strModelChange];
        
        _txShowJsonView.text = _showString;
    }];
    
    [client requestCheckFriendDeviceListParams:dic12 andBlock:^(FriendDeviceListModel *friendDevice, NSError *error) {
        NSString *_strModelChange = [NSString stringWithFormat:@"朋友设备列表：返回值Key:%@,返回错误信息是%@ 时间是%@\n",friendDevice.returnCode,[friendDevice.deviceList objectAtIndex:0],friendDevice.deviceList];
        [_showString appendString:_strModelChange];
        
        _txShowJsonView.text = _showString;
    }];
    //
    NSDictionary *dic13 = @{
                            @"UserID": UserID,
                            @"UUID": @"Test6",
                            @"Description": @"Anything"
                            };
    [client requestUserBindingDeviceParams:dic13 andBlock:^(BaseModel *resultModel, NSError *error) {
        NSString *_strModelChange = [NSString stringWithFormat:@"绑定信息：返回值Key:%@,返回错误信息是%@ 时间是%@\n",resultModel.returnCode,resultModel.errorMessage,resultModel];
        [_showString appendString:_strModelChange];
        
        _txShowJsonView.text = _showString;
    }];
     */

    //激活我的
    NSDictionary *dic14 = @{
                            @"UserID": kUserID,
                            @"UUID": @"Test6",
                            };
    [client requestActiveMyDeviceParams:dic14 andBlock:^(BaseModel *resultModel, NSError *error) {
        NSString *_strModelChange = [NSString stringWithFormat:@"激活我的设备信息：返回值Key:%@,返回错误信息是%@ 时间是%@\n",resultModel.returnCode,resultModel.errorMessage,resultModel];
        [_showString appendString:_strModelChange];
        
        _txShowJsonView.text = _showString;
    }];
    //激活他人的
    NSDictionary *dic15 = @{
                            @"UserID": kUserID,
                            @"UUID": @"Test6",
                            @"FriendUserID" : kUserID,
                            };
    [client requestActiveFriendDeviceParams:dic15 andBlock:^(BaseModel *resultModel, NSError *error) {
        NSString *_strModelChange = [NSString stringWithFormat:@"激活他人设备信息：返回值Key:%@,返回错误信息是%@ 时间是%@\n",resultModel.returnCode,resultModel.errorMessage,resultModel];
        [_showString appendString:_strModelChange];
        
        _txShowJsonView.text = _showString;
    }];
    //重命名我的
    NSDictionary *dic16 = @{
                            @"UserID": kUserID,
                            @"DeviceList": @[
    @{@"UUID": @"Test", @"Description": @"我的设备1"},
    @{@"UUID": @"Test", @"Description": @"我的设备2"},
    @{@"UUID": @"Test", @"Description": @"我的设备3"}
                                           ]
                            };
    [client requestRenameMyDeviceParams:dic16 andBlock:^(BaseModel *resultModel, NSError *error) {
        NSString *_strModelChange = [NSString stringWithFormat:@"重命名我的设备信息：返回值Key:%@,返回错误信息是%@ 时间是%@\n",resultModel.returnCode,resultModel.errorMessage,resultModel];
        [_showString appendString:_strModelChange];
        
        _txShowJsonView.text = _showString;

    }];
    //重命名他人设备
    NSDictionary *dic17 = @{
                            @"UserID": kUserID,
                            @"FriendUserID":kUserID,
                            @"DeviceList": @[
                                    @{@"UUID": @"Test", @"Description": @"我的设备1"},
                                    @{@"UUID": @"Test", @"Description": @"我的设备2"},
                                    @{@"UUID": @"Test", @"Description": @"我的设备3"}
                                    ]
                            };
    [client requestRenameFriendDeviceParams:dic17 andBlock:^(BaseModel *resultModel, NSError *error) {
        NSString *_strModelChange = [NSString stringWithFormat:@"重命名他人设备信息：返回值Key:%@,返回错误信息是%@ 时间是%@\n",resultModel.returnCode,resultModel.errorMessage,resultModel];
        [_showString appendString:_strModelChange];
        
        _txShowJsonView.text = _showString;
    }];
    
    [client requestRemoveDeviceParams:dic14 andBlock:^(BaseModel *resultModel, NSError *error) {
        NSString *_strModelChange = [NSString stringWithFormat:@"删除他人设备信息：返回值Key:%@,返回错误信息是%@ 时间是%@\n",resultModel.returnCode,resultModel.errorMessage,resultModel];
        [_showString appendString:_strModelChange];
        
        _txShowJsonView.text = _showString;
    }];
//    获取全局参数
    [client requestGetGlobalParamtersParams:nil andBlock:^(GlobalModel *globalModel, NSError *error) {
        NSString *_strModelChange = [NSString stringWithFormat:@"删除他人设备信息：返回值Key:%@,返回错误信息是%@ 时间是%@\n",globalModel.returnCode,globalModel.errorMessage,globalModel.parameterList.description];
        [_showString appendString:_strModelChange];
        
        _txShowJsonView.text = _showString;
    }];
    //传感器数据
    NSDictionary *dic18 = @{
                            @"UUID" : @"",
                            @"DataProperty":@"3",
                            @"FromDate": @"20151221", //申请加好友的人
                            @"EndDate": @"20151222", //被请求的用户
                            };
    [client requestGetSensorDataParams:dic18 andBlock:^(SensorDataModel *sensorModel, NSError *error) {
        NSString *_strModelChange = [NSString stringWithFormat:@"传感器数据设备信息：返回值Key:%@,返回错误信息是%@ 时间是%@\n",sensorModel.returnCode,sensorModel.errorMessage,sensorModel.sensorDataList];
        [_showString appendString:_strModelChange];
        
        _txShowJsonView.text = _showString;
    }];
    //
    NSDictionary *dic19 = @{
                            @"UUID" : @"",
                            @"FromDate": @"20151221", //申请加好友的人
                            @"EndDate": @"20151222", //被请求的用户
                            };
    [client requestGetSleepQualityParams:dic19 andBlock:^(SleepQualityModel *qualityModel, NSError *error) {
        NSString *_strModelChange = [NSString stringWithFormat:@"睡眠质量：返回值Key:%@,返回错误信息是%@ 时间是%@,%@,%@\n",qualityModel.returnCode,qualityModel.errorMessage,qualityModel.assessmentCode,qualityModel.data,qualityModel.slowHeartRateTimes];
        [_showString appendString:_strModelChange];
        
        _txShowJsonView.text = _showString;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
