//
//  gatewayMessageTool.h
//  HomeCOO
//
//  Created by tgbus on 16/6/18.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@class gatewayMessageModel;
@interface gatewayMessageTool : NSObject

/**
 *  添加新网关
 */

+ (void)addGateway:( gatewayMessageModel*)gateway;


/**
 *  查找网关
 *
 *  @return 返回所有网关
 */

+(NSArray *)queryWithgateways;

/**
 *  删除网关
 *
 *  @param gateway 网关
 */
+(void)delete:(gatewayMessageModel *)gateway;

/**
 删除网关表
 */
+(void)deleteGatewayTable;

/**
 *  更新网关ip
 *
 *  @param gateway 网关
 */

+(void)updateGatewayIP:(gatewayMessageModel *)gateway;

/**
 *  更改网关密码
 *
 *  @param gateway 网关
 */
+(void)updateGatewayPWD:(gatewayMessageModel *)gateway;


/**
 *  根据网关id 查找该网关的信息
 *
 *  @param gateway
 *
 *  @return 
 */
+(NSArray *)queryWithgatewaysBygatewayNo:(gatewayMessageModel *)gateway;

/**
 *  根据网关的id 更新网关的ip 和pwd
 *
 *  @param gateway
 */
+(void)updateGatewayMessage:(gatewayMessageModel *)gateway;


@end
