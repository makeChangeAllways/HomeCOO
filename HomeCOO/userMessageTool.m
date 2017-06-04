//
//  userMessageTool.m
//  HomeCOO
//
//  Created by tgbus on 16/6/26.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//  未测

#import "userMessageTool.h"
#import "userMessage.h"
#import "FMDB.h"

@implementation userMessageTool

static FMDatabasess *_db;

//首先需要有数据库
+(void)initialize
{
    // 1.打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"HomeCOO_IOS.sqlite"];
    _db = [FMDatabasess databaseWithPath:path];
    [_db open];
    
    // 2.创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_userTbale ( USER_ID int  , PHONENUM text, PASSWORD text, REALNAME text ,EMAIL text,GATEWAY_NO text,ADDRESS text,IS_ONLINE text,CREATE_TIME text);"];
    
}

/**
 *  添加用户
 *
 *  @param user 用户
 */
+(void)addUser:(userMessage *)user{

    //插入新新用户信息
    [_db executeUpdateWithFormat:@"INSERT INTO t_userTbale (PHONENUM, PASSWORD) VALUES (%@,%@);", user.phone_Num,user.password];
    
   
}

/**
 *  更新用户密码
 *
 *  @param user 用户
 */
+(void)updateUserPWD:(userMessage *)userPWD{

    [_db  executeUpdateWithFormat:@"UPDATE t_userTbale SET  PASSWORD = %@ WHERE PHONENUM = %@ ;",userPWD.password,userPWD.phone_Num];


}

/**
 *  查询用户
 *
 *  @return 返回所有用户
 */

+(NSArray *)queryWithgUsers{
    
    //得到结果集
    FMResultSets *set = [_db executeQuery:@"SELECT * FROM t_userTbale"];
    
    NSMutableArray * users=[NSMutableArray array];
    
    // 不断往下取数据
    while (set.next) {//进行查询前的准备工作
        
        userMessage *user = [[userMessage  alloc]init];
        
        user.phone_Num  = [set stringForColumn:@"PHONENUM"];
        
        user.password = [set stringForColumn:@"PASSWORD"];
    
        [users addObject:user ];
        
    }
    
    return users;
}

/**
 *  根据phoneNum查询用户
 *
 *  @return 返回所有用户
 */

+(NSArray *)queryWithgUsers:(userMessage *)user{
    
    //得到结果集
    FMResultSets *set = [_db executeQueryWithFormat:@"SELECT * FROM t_userTbale  WHERE PHONENUM = %@ ",user.phone_Num];
    
    NSMutableArray * users=[NSMutableArray array];
    
    // 不断往下取数据
    while (set.next) {//进行查询前的准备工作
        
        userMessage *user = [[userMessage  alloc]init];
        
        user.phone_Num  = [set stringForColumn:@"PHONENUM"];
        
        user.password = [set stringForColumn:@"PASSWORD"];
        
        [users addObject:user ];
        
    }
    
    return users;
}

/**
 *  删除用户表
 */
+(void)deleteUserTable{
    
    
    [_db executeUpdateWithFormat:@"DELETE FROM t_userTbale;"];
    
}
























@end
