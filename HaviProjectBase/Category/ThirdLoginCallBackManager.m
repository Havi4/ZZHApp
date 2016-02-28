//
//  ThirdLoginCallBackManager.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/28.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "ThirdLoginCallBackManager.h"
#import "LoginViewController.h"
#import "RegisterPhoneViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "WeiXinAPI.h"
#import "WeiBoAPI.h"
#import "AppDelegate.h"

static ThirdLoginCallBackManager *shareInstance = nil;

@interface ThirdLoginCallBackManager ()<WXApiDelegate,WeiboSDKDelegate,TencentSessionDelegate>

@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) NSString *wbCurrentUserID;
@property (nonatomic,strong) NSDictionary *ThirdPlatformInfoDic;
@property (nonatomic,strong) NSString *thirdPlatform;
@property (nonatomic,strong) NSString *tencentID;


@end

@implementation ThirdLoginCallBackManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[ThirdLoginCallBackManager alloc]init];
    });
    return shareInstance;
}

- (BOOL)weixinCallBackHandleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)weiboCallBackHandleOpenURL:(NSURL *)url
{
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)tencentCallBackHandleOpenURL:(NSURL *)url
{
    return [TencentOAuth HandleOpenURL:url];
}

#pragma mark 微信回调函数

-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        /*
         GetMessageFromWXReq *temp = (GetMessageFromWXReq *)req;
         */
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        
        
        
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        /*
         ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
         WXMediaMessage *msg = temp.message;
         
         //显示微信传过来的内容
         WXAppExtendObject *obj = msg.mediaObject;
         
         NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
         NSString *strMsg = [NSString stringWithFormat:@"openID: %@, 标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%lu bytes\n附加消息:%@\n", temp.openID, msg.title, msg.description, obj.extInfo, (unsigned long)msg.thumbData.length, msg.messageExt];
         */
        
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        /*
         
         LaunchFromWXReq *temp = (LaunchFromWXReq *)req;
         WXMediaMessage *msg = temp.message;
         //从微信启动App
         NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
         NSString *strMsg = [NSString stringWithFormat:@"openID: %@, messageExt:%@", temp.openID, msg.messageExt];
         */
        
    }
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        if (resp.errCode == 0) {
            [NSObject showHudTipStr:@"分享成功"];
        }else{
            [NSObject showHudTipStr:@"取消分享"];
        }
        
    }
    else if([resp isKindOfClass:[SendAuthResp class]])
    {
        SendAuthResp *temp = (SendAuthResp*)resp;
        if (temp.code) {
            [WeiXinAPI getWeiXinInfoWith:temp.code parameters:nil finished:^(NSURLResponse *response, NSData *data) {
                NSDictionary *obj = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                //第三方登录
                self.ThirdPlatformInfoDic = obj;
                [self checkUseridIsRegister:obj andPlatform:kWXPlatform];
                NSLog(@"用户信息是%@",obj);
            } failed:^(NSURLResponse *response, NSError *error) {
                
            }];
        }else{
            [NSObject showHudTipStr:@"取消登录"];
        }
        
    }
    else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]])
    {
        AddCardToWXCardPackageResp* temp = (AddCardToWXCardPackageResp*)resp;
        NSMutableString* cardStr = [[NSMutableString alloc] init];
        for (WXCardItem* cardItem in temp.cardAry) {
            [cardStr appendString:[NSString stringWithFormat:@"cardid:%@ cardext:%@ cardstate:%u\n",cardItem.cardId,cardItem.extMsg,(unsigned int)cardItem.cardState]];
        }
        
    }
}

#pragma mark 新浪回调

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        if ((int)response.statusCode ==0) {
            [NSObject showHudTipStr:@"分享成功"];
        }else{
            [NSObject showHudTipStr:@"取消分享"];
        }
        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
        if (accessToken)
        {
            self.wbtoken = accessToken;
        }
        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
        if (userID) {
            self.wbCurrentUserID = userID;
        }
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
        if (self.wbtoken) {
            self.wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
            NSDictionary *dic = @{
                                  @"access_token" : self.wbtoken,
                                  @"uid" : self.wbCurrentUserID,
                                  };
            [WeiBoAPI getWeiBoInfoWith:nil parameters:dic finished:^(NSURLResponse *response, NSData *data) {
                NSDictionary *obj = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                self.ThirdPlatformInfoDic = obj;
                [self checkUseridIsRegister:obj andPlatform:kSinaPlatform];
                NSLog(@"获取到微博个人信息%@",obj);
                
            } failed:^(NSURLResponse *response, NSError *error) {
                
            }];
        }else{
            [NSObject showHudTipStr:@"取消登录"];
        }
    }
    else if ([response isKindOfClass:WBPaymentResponse.class])
    {
        /*
         NSString *title = NSLocalizedString(@"支付结果", nil);
         NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.payStatusCode: %@\nresponse.payStatusMessage: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBPaymentResponse *)response payStatusCode], [(WBPaymentResponse *)response payStatusMessage], NSLocalizedString(@"响应UserInfo数据", nil),response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
         */
    }
}

#pragma mark qq回调

- (void)tencentDidLogin
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    if (app.tencentOAuth.accessToken && 0 != [app.tencentOAuth.accessToken length])
    {
        //  记录登录用户的OpenID、Token以及过期时间
        if ([app.tencentOAuth getUserInfo]) {
            //检测帐号
            self.tencentID = app.tencentOAuth.openId;
            DeBugLog(@"用户的信息是%@",app.tencentOAuth.passData);
            
        }
    }
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled)
    {
        [NSObject showHudTipStr:@"登录取消"];
    }
    else
    {
        [NSObject showHudTipStr:@"登录失败"];
    }
    
}

- (void)tencentDidNotNetWork
{
    DeBugLog(@"网络出错");
    [NSObject showHudTipStr:@"网络错误"];
}

- (void)getUserInfoResponse:(APIResponse *)response
{
    DeBugLog(@"用户回调%@",response.jsonResponse);
    self.ThirdPlatformInfoDic = response.jsonResponse;
    [self checkUseridIsRegister:response.jsonResponse andPlatform:kTXPlatform];
}

#pragma mark 自身帐号注册检查

- (void)checkUseridIsRegister:(NSDictionary *)infoDic andPlatform:(NSString *)platfrom
{
    NSString *thirdID;
    NSString *thirdName;
    if ([platfrom isEqualToString:kWXPlatform]) {
        thirdName = [infoDic objectForKey:@"nickname"];
    }else if ([platfrom isEqualToString:kSinaPlatform]){
        thirdName = [infoDic objectForKey:@"name"];
    }else{
        thirdName = [infoDic objectForKey:@"nickname"];
    }
    if ([platfrom isEqualToString:kWXPlatform]) {
        thirdID = [infoDic objectForKey:@"unionid"];
    }else if ([platfrom isEqualToString:kSinaPlatform]){
        thirdID = [infoDic objectForKey:@"id"];
    }else{
        thirdID = self.tencentID;
    }
    NSDictionary *dic = @{
                          @"UserID": [NSString stringWithFormat:@"%@$%@",platfrom,thirdID], //手机号码
                          };
    ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
    [client requestUserInfoWithParam:dic andBlock:^(UserInfoDetailModel *userInfo, NSError *error) {
        if ([userInfo.returnCode intValue]==200) {
            UserInfo *infoDetail = userInfo.nUserInfo;
            NSString *startString = infoDetail.sleepStartTime;
            NSString *endString = infoDetail.sleepEndTime;
            if (startString.length!=0&&endString.length!=0) {
                
            }
            
            thirdPartyLoginPlatform = platfrom;
            thirdPartyLoginUserId = infoDetail.userID;
            thirdPartyLoginNickName = thirdName;
            if ([platfrom isEqualToString:kWXPlatform]) {
                thirdPartyLoginIcon = [self.ThirdPlatformInfoDic objectForKey:@"headimgurl"];
            }else if ([platfrom isEqualToString:kSinaPlatform]){
                thirdPartyLoginIcon = [self.ThirdPlatformInfoDic objectForKey:@"profile_image_url"];
            }else {
                thirdPartyLoginIcon = [self.ThirdPlatformInfoDic objectForKey:@"figureurl_qq_2"];
            }
            thirdPartyLoginToken = @"";
            [UserManager setGlobalOauth];
            AppDelegate *app = [UIApplication sharedApplication].delegate;
            [app setRootViewController];
            DeBugLog(@"注册过");
            //发现第三方帐号没有注册过
        }else if ([userInfo.returnCode intValue]==10029){
            UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
            RegisterPhoneViewController *getPhone = [[RegisterPhoneViewController alloc]init];
            getPhone.thirdPlatformInfoDic = self.ThirdPlatformInfoDic;
            getPhone.platform = platfrom;
            getPhone.tencentId = self.tencentID;
            [(UINavigationController *)appRootVC pushViewController:getPhone animated:YES];
            DeBugLog(@"新用户");
        }
    }];
}


@end
