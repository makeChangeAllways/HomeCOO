//
//  userMessageTool.h
//  HomeCOO
//
//  Created by tgbus on 16/6/26.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import <Foundation/Foundation.h>
@class userMessage;
@interface userMessageTool : NSObject

/**
 *  添加用户
 */

+(void)addUser:(userMessage*)user;



/**
 删除用户
 */
+(void)deleteUserTable;

/**
 *  更新用户密码
 */
+(void)updateUserPWD:(userMessage *)userPWD;

/**
 *  查询
 *
 *  @return 返回所有用户
 */
+(NSArray *)queryWithgUsers;

/**
 *  根据phoneNum查询用户
 *
 *  @return 返回所有用户
 */

+(NSArray *)queryWithgUsers:(userMessage *)user;
@end
