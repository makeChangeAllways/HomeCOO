//
//  alarmMessagesTool.h
//  HomeCOO
//
//  Created by app on 16/8/28.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import <Foundation/Foundation.h>
@class alarmMessages;
@interface alarmMessagesTool : NSObject

//插入一条报警消息
+(void)addDevice:(alarmMessages *)message;

/**
 *  查询报警信息
 *
 *  @param NSArray
 *
 *  @return
 */
+(NSArray *)queryWithAlarmMessage:(alarmMessages *)message;


@end
