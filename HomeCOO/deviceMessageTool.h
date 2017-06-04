//
//  deviceMessageTool.h
//  HomeCOO
//
//  Created by tgbus on 16/5/31.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import <Foundation/Foundation.h>


@class deviceMessage;
@interface deviceMessageTool : NSObject

/**
 *  保存一个设备的信息
 */
+ (void)addDevice:( deviceMessage*)device;


/**
 *  更新设备状态信息
 */
+ (void)updateDeviceState:( deviceMessage*)device;


/**
 *  查询所有照明设备
 */

+(NSArray *)queryWithLightDevices:(deviceMessage *)device;

/**
 *  查询所有门窗类设备信息
 *
 *  @return 所有门窗设备
 */
+(NSArray *)queryWithWindowsDevices:(deviceMessage *)device;

/**
 *  查询所有插座设备信息
 *
 *  @return 所有插座设备
 */

+(NSArray *)queryWithSocksDevices:(deviceMessage *)device;
/**
 *  删除所有设备信息
 */
+(void)deleteDevice:(deviceMessage*)device;


/**
 删除设备表
 */
+(void)deleteDeviceTable;

/**
 *  查询所有设备
 *
 *  @return 返回所有设备
 */
+(NSMutableArray *)queryWithDevices:(deviceMessage *)device;

/**
 *  更新设备名称和位置
 *
 *  @param device 设备
 */
+(void)updateDevicePostionAndName:(deviceMessage *)device;

/**
 *  根据设备的mac地址 查找当前设备的所有信息
 *
 *  @param Device
 *
 *  @return
 */
+(NSArray *)queryWithDeviceNumDevices:(deviceMessage *)Device;

/**
 *  根据设备的mac地址，更新设备的名称
 *
 *  @param device 
 */
+(void)updateDeviceName:(deviceMessage *)device;


/**
 *  根据设备的mac地址 更新设备的信息
 *
 *  @param device
 */

+(void)updateDeviceMessage:(deviceMessage *)device;

/**
 *  查询传感器类设备
 *
 *  @return 返回所有设备
 */

+(NSArray *)queryWithSensorDevices:(deviceMessage *)device;
/**
 *  查询报警类传感器设备信息和空气传感器信息
 *
 *  @param NSArray 存取插座设备信息
 *
 *  @return 返回所有插座设备的信息
 */
+(NSArray *)queryWithSensorsDevices:(deviceMessage *)device;

/**
 *  根据设备id 和网关编号 更新设备的 SPACE_TYPE_ID
 *
 *  @param device
 */
+(void)updateDeviceSPACE_TYPE_ID:(deviceMessage *)device;


/**
 *  查询所有防区管理中 属于室内的设备（spacetypeid = 1）
 *
 *  @return 返回所有设备
 */

+(NSArray *)queryWithSecurityDevices:(deviceMessage *)device;
/**
 *  查询所有防区管理中 属于室外的设备（spacetypeid = 2）
 *
 *  @return 返回所有设备
 */

+(NSArray *)queryWithOutdoorSecurityDevices:(deviceMessage *)device;
/**
 *  查询在空间显示的设备 只显示三大类（照明  门窗  插座）
 *
 *  @param NSArray 存取照明设备信息
 *
 *  @return 返回所有照明设备的信息
 */
+(NSArray *)queryWithSpaceDevices:(deviceMessage *)device;
/**
 *  查询温湿度
 *
 *  @param NSArray
 *
 *  @return
 */
+(NSArray *)queryTempSensorDevices:(deviceMessage *)device;
/**
 *  查询PM2_5
 *
 *  @param NSArray
 *
 *  @return
 */
+(NSArray *)queryPM2_5SensorDevices:(deviceMessage *)device;

+(NSMutableArray *)queryWithRemoteDevices:(deviceMessage *)device;

+(void)updateDeviceMessageOnlyLocal:(deviceMessage *)device;
    
@end
