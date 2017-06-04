//
//  themeDeviceMessageTool.h
//  HomeCOO
//
//  Created by tgbus on 16/7/8.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@class themeDeviceMessage;

@interface themeDeviceMessageTool : NSObject


/**
 *  往情景设备表中添加设备
 *
 *  @param themeDevice
 */
+(void)addThemeDevice:(themeDeviceMessage *)themeDevice;

+(void)deleteThemeDeviceTable;
    
/**
 *  更新设备当前的状态
 *
 *  @param themeDevice
 */
+(void)updateThemeDeviceState:(themeDeviceMessage *)themeDevice;


/**
 *  查询情景表中所有的设备
 *
 *  @return
 */
+(NSArray *)queryWithThemeDevices;

+(NSArray *)queryWithThemeDevices:(themeDeviceMessage *)themeDevice;

+(NSArray *)queryWithThemeNoDevices:(themeDeviceMessage *)themeDevice;

+(void)delete:(themeDeviceMessage *)theme;
+(void)deleteThemeDevice:(themeDeviceMessage *)theme;



+(NSArray *)queryWithThemeDevicesOnlyForInfra:(themeDeviceMessage *)themeDevice;
+(void)updateThemeDeviceStateOnlyForInfra:(themeDeviceMessage *)themeDevice;
+(void)deleteThemeDeviceOnlyForInfra:(themeDeviceMessage *)theme;
@end
