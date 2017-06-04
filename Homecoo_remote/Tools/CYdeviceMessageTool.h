//
//  CYdeviceMessageTool.h
//  HomeCOO
//
//  Created by app on 2017/1/3.
//  Copyright © 2017年 Jiaoda. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CYdeviceMessage;
@interface CYdeviceMessageTool : NSObject
/**
 *  保存一个设备的信息
 */
+ (void)addDevice:( CYdeviceMessage*)device;
+(NSArray *)queryWithSocksDevices:(CYdeviceMessage *)device;
+(void)deleteDevice:(CYdeviceMessage*)device;
@end
