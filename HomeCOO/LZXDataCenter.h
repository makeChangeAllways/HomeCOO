//
//  LZXDataCenter.h
//  Demo_反向传值
//
//  Created by LZXuan on 15-3-23.
//  Copyright (c) 2015年 LZXuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZXDataCenter : NSObject

+ (LZXDataCenter *)defaultDataCenter;
@property (nonatomic,copy) NSString *textStr;

//情景管理
@property(nonatomic,copy)  NSString *device_No;

@property(nonatomic,copy)  NSString *gateway_No;

@property(nonatomic,copy)  NSString *theme_ID;

@property(nonatomic,copy)  NSString *theme_Name;

@property(nonatomic,copy)  NSString  *theme_No;

@property(nonatomic,copy)  NSString *theme_State;

@property  NSInteger theme_Type;

//用户手机号 全局变量
@property(nonatomic,copy)  NSString *userPhoneNum;

//当前网关编号 全局变量
@property(nonatomic,copy)  NSString *gatewayNo;
//当前网关PWD 全局变量
@property(nonatomic,copy)  NSString *gatewayPwd;
//当前网关ID 全局变量
@property(nonatomic,copy)  NSString *gatewayIP;

//传感器情景

@property(nonatomic,copy) NSString *sensorDevice_No;

@property(nonatomic,copy) NSString *sensorGateway_No;

@property(nonatomic,copy)  NSString *sensorTheme_ID;

@property(nonatomic,copy) NSString *sensorTheme_Name;

@property(nonatomic,copy) NSString *sensorTheme_No;

@property(nonatomic,copy) NSString *sensorTheme_State;

@property NSInteger sensorTheme_Type;

@property(nonatomic,copy) NSString *remoteIEEAddress;

//用于传递安防产品的SpaceTypeID 1 :室内 2 ：室外
@property NSInteger devcieSpaceTypeID;

// 1 代表远程 0代表本地
@property  NSInteger  networkStateFlag;

//定时管理 定时设备id
@property(nonatomic,strong) NSString *scheduleDeviceId;
//定时设备的状态
@property(copy,nonatomic) NSString *scheduleDeviceState;
//定时音乐 歌曲名称
@property(nonatomic,copy) NSString *songName;

//0 播放 1 暂停
@property NSInteger musicType;

//国家区号
@property (nonatomic,copy) NSString *countyrCode;

@property(nonatomic,copy) NSString *QICUNPINGIP;

@property(nonatomic,copy) NSString *CYDeviceName;

@property  NSInteger  loginStateFlag;



//红外遥控的一些全局变量

@property(nonatomic,strong) NSString *scheduleName;

@property(nonatomic,copy)  NSString *remoteDeviceNum;
//智能匹配标志
@property  NSInteger  intellectMatchFlag;
//选择是控制设备还是情景设置设备标志
@property  NSInteger  controlFlag;
//设备名称是空调还是电视等
@property(nonatomic,copy)  NSString * DeviceName;

@property(nonatomic,copy)  NSString * btnName;

@property NSInteger  DeviceTypeID;

//
@property(nonatomic,strong) NSString *infraCode;

@property(nonatomic,strong) NSString *infraPacket;


@end




