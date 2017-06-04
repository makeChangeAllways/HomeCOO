//
//  versionMessageTool.m
//  HomeCOO
//
//  Created by tgbus on 16/7/21.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "versionMessageTool.h"
#import "versionMessageModel.h"
#import "FMDB.h"
@implementation versionMessageTool

static FMDatabasess *_db;

//首先需要有数据库
+(void)initialize
{
    // 1.打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"HomeCOO_IOS.sqlite"];
    _db = [FMDatabasess databaseWithPath:path];
    [_db open];
    
    // 2.创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_versionTbale ( GATEWAY_NUM text  , PHONENUM text, VERSION_DESCRIPTION text, VERSION_CODE text, UPDATE_TIME text,VERSION_TYPE text);"];
}


/**
 *  添加版本信息
 *
 *  @param
 */
+(void)addVersionMessage:(versionMessageModel *)version{
    
    [_db executeUpdateWithFormat:@"INSERT INTO t_versionTbale(GATEWAY_NUM, PHONENUM,VERSION_DESCRIPTION,VERSION_CODE,UPDATE_TIME,VERSION_TYPE) VALUES (%@, %@,%@,%@,%@,%@);", version.gatewayNum, version.phoneNum,version.versionDescription,version.versionCode,version.updateTime,version.versionType];
    
    
}

/**
 *  跟新版本时间信息
 *
 *  @param version 版本
 */
+(void)updateVersionMessage:(versionMessageModel *)version{

    [_db  executeUpdateWithFormat:@"UPDATE t_versionTbale SET UPDATE_TIME = %@ WHERE GATEWAY_NUM = %@ and PHONENUM = %@ and VERSION_TYPE = %@; ",version.updateTime,version.gatewayNum,version.phoneNum,version.versionType];

}

/**
 *  查找是否存在当前类型的版本
 */
+(NSArray *)queryWithVersionType:(versionMessageModel *)version{
    
    //得到结果集
    FMResultSets *set = [_db executeQueryWithFormat:@"SELECT * FROM t_versionTbale where GATEWAY_NUM = %@ and PHONENUM = %@ and VERSION_TYPE = %@ ",version.gatewayNum,version.phoneNum,version.versionType];
   
    NSMutableArray * versions=[NSMutableArray array];
    
    // 不断往下取数据
    while (set.next) {//进行查询前的准备工作
        
        versionMessageModel *versionType = [[versionMessageModel  alloc]init];
        
        versionType.gatewayNum  = [set stringForColumn:@"GATEWAY_NUM"];
        
        versionType.phoneNum = [set stringForColumn:@"PHONENUM"];
        
        versionType.versionCode = [set stringForColumn:@"VERSION_CODE"];
        
        versionType.versionDescription = [set  stringForColumn:@"VERSION_DESCRIPTION"];
        
        versionType.updateTime = [set stringForColumn:@"UPDATE_TIME"];
        
        versionType.versionType = [set  stringForColumn:@"VERSION_TYPE"];
        
        [versions addObject:versionType ];
        
    }
    
    return versions;
}


/**
 *  根据phonenum + gatewayno 查找version表中所有设备的更新信息
 */
+(NSArray *)queryWithVersions:(versionMessageModel *)version{
    
    //得到结果集
    FMResultSets *set = [_db executeQueryWithFormat:@"SELECT * FROM t_versionTbale where GATEWAY_NUM = %@ and PHONENUM = %@ and VERSION_TYPE = %@ ",version.gatewayNum,version.phoneNum,version.versionType];
    
    NSMutableArray * versions=[NSMutableArray array];
    
    // 不断往下取数据
    while (set.next) {//进行查询前的准备工作
        
        versionMessageModel *versionType = [[versionMessageModel  alloc]init];
        
        versionType.gatewayNum  = [set stringForColumn:@"GATEWAY_NUM"];
        
        versionType.phoneNum = [set stringForColumn:@"PHONENUM"];
        
        versionType.versionCode = [set stringForColumn:@"VERSION_CODE"];
        
        versionType.versionDescription = [set  stringForColumn:@"VERSION_DESCRIPTION"];
        
        versionType.updateTime = [set stringForColumn:@"UPDATE_TIME"];
        
        versionType.versionType = [set  stringForColumn:@"VERSION_TYPE"];
        
        [versions addObject:versionType ];
        
    }
    
    return versions;
}



@end
