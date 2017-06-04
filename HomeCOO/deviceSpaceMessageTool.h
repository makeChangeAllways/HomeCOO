//
//  deviceSpaceMessageTool.h
//  HomeCOO
//
//  Created by tgbus on 16/7/16.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import <Foundation/Foundation.h>
@class deviceSpaceMessageModel;

@interface deviceSpaceMessageTool : NSObject

/**像设备空间信息表中插入设备对应的空间信息*/
+(void)addDeviceSpace:(deviceSpaceMessageModel *)deviceSpace;

/**更新当前设备在设备表中的空间信息*/
+(void)updateDeviceSpaceMessage:(deviceSpaceMessageModel *)deviceSpace;

+(void)deleteDeviceMessageTable;
/**查找设备空间表里所有设备的*/
+(NSArray *)queryWithspacesDeviceNoAndPhonenum:(deviceSpaceMessageModel *)space;

+(NSArray *)queryWithspacesDevice:(deviceSpaceMessageModel *)deviceSpace;

/**
 *  根据spaceno + phonenum 删除spaceno  （在删除空间的时候 将对应的用户配置表中该空间也删除掉）
 *
 *  @param deviceSpace
 */

+(void)deleteDeviceSpace:(deviceSpaceMessageModel *)deviceSpace;
/**
 *  用户在产品管理中删除该设备时，应该根据该设备的deviceno 和 当前用户的手机号 到devicespace表中将该设备的空间信息删除掉
 */
+(void)deleteDeviceSpaceWithDeviceno_phonenum:(deviceSpaceMessageModel *)deviceSpace;
/**
 *  查找DEVICE_NO所有的设备空间信息
 *
 *  @param space
 *
 *  @return
 */
+(NSArray *)queryWithspacesDeviceNumbers:(deviceSpaceMessageModel *)space;


@end
