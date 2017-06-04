//
//  HCUserTableTool.h
//  HomeCOO
//
//  Created by tgbus on 16/5/14.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HCUserTable;

@interface HCUserTableTool : NSObject

/**存放所有用户名和密码*/
+(NSArray *)userTable;
/**将每个用户名和密码添加到用户表中*/
+(void)addUser:(HCUserTable *)user;
+(void)deleteUser:(HCUserTable *)user;
@end
