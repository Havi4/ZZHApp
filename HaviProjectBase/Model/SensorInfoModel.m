//
//  SensorInfoModel.m
//  HaviModel
//
//  Created by Havi on 15/12/26.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import "SensorInfoModel.h"
//"ProductIdentificationCode": "XFDSFGSFDSF",  //用UUID代替，将会删除
//"UUID": "XFDSFGSFDSF",  //和请求参数一致
//"MasterProductIdentificationCode": "",  //用MasterUUID代替，将会删除
//"MasterUUID": "",  //双人床设备才有
//"FactoryCode": "ABCD",   //厂商
//"DeviceCategory": "123",  //设备分组，可作为界面显示的判断依据
//"MacAddress": "FF-FF-FF-FF-FF",  //MAC地址
//"FirmwareVersion": ""  //设备固件版本,
//"ActivationStatus": "激活",  //激活状态，将会删除
//"ActivationStatusCode": "1",  //1:表示已在线，0:离线
//"HeartRate": "65",  //心率，呼吸率，<=0时表示无效值
//"RespirationRate": "12",  //心率，呼吸率，<=0时表示无效值
//"LastBodyMovingDateTime": "2015-10-08 12:56:42", //最后一次体动时间
//"IsAnybodyOnBed": "False"  //是否有人在床上，False表示离床

@implementation SensorDetail

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"deviceUUID" : @"UUID",
             @"masterUUID" : @"MasterUUID",
             @"factoryCode"        :@"FactoryCode",
             @"deviceCategory" : @"DeviceCategory",
             @"macAddress" : @"MacAddress",
             @"firmwareVersion" : @"FirmwareVersion",
             @"activationStatusCode"        :@"ActivationStatusCode",
             @"heartRate" : @"HeartRate",
             @"respirationRate" : @"RespirationRate",
             @"lastBodyMovingDateTime" : @"LastBodyMovingDateTime",
             @"isAnybodyOnBed" : @"IsAnybodyOnBed",
             @"detailSensorInfoList" : @"DetailSensorInfo",
             };
}

//属性的类型说明数组中对象是什么
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"detailSensorInfoList" : SensorList.class,
             };
}

@end

@implementation SensorList

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"subDeviceUUID" : @"UUID",
             };
}

@end

@implementation SensorInfoModel
//这个方法是将属性和json中的key进行关联
+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"returnCode" : @"ReturnCode",
             @"errorMessage" : @"ErrorMessage",
             @"date"        :@"Date",
             @"sensorDetail" : @"SensorInfo",
             
             };
}

@end
