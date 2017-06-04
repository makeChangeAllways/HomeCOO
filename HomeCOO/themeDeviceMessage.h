//
//  themeDeviceMessage.h
//  HomeCOO
//
//  Created by tgbus on 16/7/8.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface themeDeviceMessage : NSObject

/**被联动设备mac地址*/
@property(nonatomic,strong) NSString  *device_No;

/**被联动设备设定状态*/
@property(nonatomic,strong) NSString  *device_state_cmd;

/**网关number*/
@property(nonatomic,strong) NSString  *gateway_No;

/**红外控制爱设备类型*/
@property  NSInteger infra_type_ID;

/**情景设备识别码*/
@property(nonatomic,strong) NSString  *theme_device_No;

/**情景识别码*/
@property(nonatomic,strong) NSString  *theme_no;

/**情景设备状态*/
@property(nonatomic,strong) NSString  *theme_state;

/**情景类型*/
@property  NSInteger theme_type;

@end
