//
//  alarmMessagesTool.m
//  HomeCOO
//
//  Created by app on 16/8/28.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "alarmMessagesTool.h"
#import "alarmMessages.h"
#import "FMDB.h"
@implementation alarmMessagesTool

static FMDatabasess *_db;

//首先需要有数据库
+(void)initialize
{
    // 1.打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"HomeCOO_IOS.sqlite"];
    _db = [FMDatabasess databaseWithPath:path];
    [_db open];
    
    // 2.创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_messageTbale ( DEVICE_NO text  , GATEWAY_NO text ,NOTE text,ID integer PRIMARY KEY, TIME text);"];
    
}

//插入一条数据
+(void)addDevice:(alarmMessages *)message{
    
    //插入数据
    [_db executeUpdateWithFormat:@"INSERT INTO t_messageTbale(DEVICE_NO, GATEWAY_NO,TIME) VALUES (%@,%@,%@);",message.device_no,message.gateway_no,message.time];
    
}

/**
 *  查询报警信息
 *
 *  @param NSArray
 *
 *  @return
 */
+(NSArray *)queryWithAlarmMessage:(alarmMessages *)message{
    
    //得到结果集
    FMResultSets *set = [_db executeQueryWithFormat:@"SELECT * FROM t_messageTbale  WHERE  GATEWAY_NO =%@  ",message.gateway_no];
    
    NSMutableArray * messages=[NSMutableArray array];
    
    // NSLog(@"%d",set.next);
    
    // 不断往下取数据
    while (set.next) {//进行查询前的准备工作
        
        alarmMessages *message = [[alarmMessages  alloc]init];
        
        
        message.device_no = [set stringForColumn:@"DEVICE_NO"];
        
        message.gateway_no = [set stringForColumn:@"GATEWAY_NO"];
        
        message.note = [set stringForColumn:@"NOTE"];
        
        message.ID = [set intForColumn:@"ID"];
        
        message.time = [set stringForColumn:@"TIME"];
        
        [messages addObject:message ];
        
    }
    
    return messages;
}




@end
