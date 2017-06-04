//
//  queryDeviceControlMethods.h
//  HomeCOO
//
//  Created by tgbus on 16/7/26.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface queryDeviceControlMethods : NSObject
/**
 *  将version表中设备更新信息封装成一个数组 发送给服务器
 *
 *  @return
 */
+(NSString *)allDeviceVersionList:(NSString *)versionType;
/**
 *  将deviceSpace(用户配置表)表中该用户下所有设备的配置信息封装成一个数组 发送给服务器
 *
 *  @return
 */
+(NSArray *)allUserDeviceSpaceList;
/**
 *  将device表中所有设备封装成一个数组 发送给服务器
 *
 *  @return
 */

+(NSArray *)allDeviceList;

/**
 *  将gateway 表中所有网关信息封装成一个数组 发送给服务器
 *
 *  @return
 */
+(NSArray *)allUserGatewayList;
@end
