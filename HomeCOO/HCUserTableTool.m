//
//  HCUserTableTool.m
//  HomeCOO
//
//  Created by tgbus on 16/5/14.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "HCUserTableTool.h"
#import "FMDB.h"
#import "HCUserTable.h"

@implementation HCUserTableTool
static  FMDatabasess *_db;
/**
 *  打开数据库并且创表
 */
+ (void)initialize
{
    // 1.打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"userTable.sqlite"];
    _db = [FMDatabasess databaseWithPath:path];
    [_db open];
    
    // 2.创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_userTbale (id integer PRIMARY KEY, userName text NOT NULL, userPwd text);"];
}

/**
 *  往表中增加用户
 *
 *  @param user 用户
 */
+(void)addUser:(HCUserTable *)user{
   
 [_db executeUpdateWithFormat:@"INSERT INTO t_userTbale(userName, userPwd) VALUES (%@, %@);", user.userName, user.userPwd];

}
/**
 *  删除所有用户
 *
 *  @param user <#user description#>
 */
+(void)deleteUser:(HCUserTable *)user{
    
    [_db executeUpdateWithFormat:@"DELETE FROM t_userTbale;"];

}

/**
 *  查询用户表里面所有的用户
 *
 *  @return 返回所有用户
 */
+(NSArray *)userTable{

    // 得到结果集
    FMResultSets *set = [_db executeQuery:@"SELECT * FROM t_userTbale;"];
    
    // 不断往下取数据
    NSMutableArray *users = [NSMutableArray array];
    while (set.next) {
        // 获得当前所指向的数据
        HCUserTable *user = [[HCUserTable alloc] init];
        user.userName = [set stringForColumn:@"userName"];
        user.userPwd = [set stringForColumn:@"userPwd"];
        [users addObject:user];
    }
    return users;

}


@end
