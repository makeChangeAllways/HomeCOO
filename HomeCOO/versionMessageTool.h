//
//  versionMessageTool.h
//  HomeCOO
//
//  Created by tgbus on 16/7/21.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import <Foundation/Foundation.h>
@class versionMessageModel;


@interface versionMessageTool : NSObject

/**添加版本信息 */
+(void)addVersionMessage:(versionMessageModel *)version;

/**
 *  跟新版本时间信息
 *
 *  @param version 版本
 */
+(void)updateVersionMessage:(versionMessageModel *)version;


/**
 *  查找是否存在当前类型的版本
 */

+(NSArray *)queryWithVersionType:(versionMessageModel *)version;

/**
 *  根据phonenum + gatewayno 查找version表中所有设备的更新信息
 */
+(NSArray *)queryWithVersions:(versionMessageModel *)version;
@end




















