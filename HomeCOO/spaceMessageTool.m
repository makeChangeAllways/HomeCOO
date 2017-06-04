//
//  spaceMessageTool.m
//  HomeCOO
//
//  Created by tgbus on 16/6/23.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "spaceMessageTool.h"
#import "spaceMessageModel.h"
#import "FMDB.h"
@implementation spaceMessageTool

static FMDatabasess *_db;

//首先需要有数据库
+(void)initialize
{
    
//    NSString *path =   [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"HomeCOO_IOS.sqlite"];
//    
    // 1.打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"HomeCOO_IOS.sqlite"];
    _db = [FMDatabasess databaseWithPath:path];
    [_db open];
    
    // 2.创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_spaceTbale ( GATEWAY_NO text, PHONE_NUM text, SPACE_ID text , SPACE_NAME text , SPACE_NO text);"];
}


/**
 *  添加新空间
 *
 *  @param space 空间
 */
+(void)addSpace:(spaceMessageModel *)space{

    //插入新的空间信息
    [_db executeUpdateWithFormat:@"INSERT INTO t_spaceTbale (GATEWAY_NO, PHONE_NUM,SPACE_ID,SPACE_NAME,SPACE_NO) VALUES (%@,%@,%@,%@,%@);", space.gateway_Num, space.phone_Num,space.space_ID,space.space_Name,space.space_Num];


}

/**
 *  在t_spaceTbale 表中查找已经添加的空间
 *
 *  @param NSArray 存取所有空间
 *
 *  @return 返回所有空间
 */
+(NSArray *)queryWithspaces:(spaceMessageModel *)space{
    
    //得到结果集
    FMResultSets *set = [_db executeQueryWithFormat:@"SELECT * FROM t_spaceTbale WHERE  PHONE_NUM = %@ ",space.phone_Num];
    
    NSMutableArray * spaces=[NSMutableArray array];
    
    // 不断往下取数据
    while (set.next) {//进行查询前的准备工作
        
        spaceMessageModel *space = [[spaceMessageModel  alloc]init];
        
        space.gateway_Num  = [set stringForColumn:@"GATEWAY_NO"];
        
        space.phone_Num = [set stringForColumn:@"PHONE_NUM"];
        
        space.space_ID = [set stringForColumn:@"SPACE_ID"];
        
        space.space_Name = [set  stringForColumn:@"SPACE_NAME"];
        
        space.space_Num = [set  stringForColumn:@"SPACE_NO"];
        
        [spaces addObject:space ];
        
    }
    
    
    return spaces;
}

/**
 *  在t_spaceTbale 表中查找已经添加的空间
 *
 *  @param NSArray 存取所有空间
 *
 *  @return 返回所有空间
 */
+(NSArray *)queryWithspacesNo:(spaceMessageModel *)space{
    
    //得到结果集
    FMResultSets *set = [_db executeQueryWithFormat:@"SELECT * FROM t_spaceTbale where SPACE_NAME = %@ and PHONE_NUM = %@ ",space.space_Name,space.phone_Num];
  
    NSMutableArray * spaces=[NSMutableArray array];
    
    // 不断往下取数据
    while (set.next) {//进行查询前的准备工作
        
        spaceMessageModel *space = [[spaceMessageModel  alloc]init];
        
        space.gateway_Num  = [set stringForColumn:@"GATEWAY_NO"];
        
        space.phone_Num = [set stringForColumn:@"PHONE_NUM"];
        
        space.space_ID = [set stringForColumn:@"SPACE_ID"];
        
        space.space_Name = [set  stringForColumn:@"SPACE_NAME"];
        
        space.space_Num = [set  stringForColumn:@"SPACE_NO"];
        
        [spaces addObject:space ];
        
    }
    
    return spaces;
}


/**
 *  根据空间编号查找设备的位置信息
 *
 *  @param space
 *
 *  @return
 */
+(NSArray *)queryWithspacesDevicePostion:(spaceMessageModel *)space{
    
    //得到结果集
    FMResultSets *set = [_db executeQueryWithFormat:@"SELECT * FROM t_spaceTbale where SPACE_NO = %@ ",space.space_Num];
    
    NSMutableArray * spaces=[NSMutableArray array];
    
    // 不断往下取数据
    while (set.next) {//进行查询前的准备工作
        
        spaceMessageModel *space = [[spaceMessageModel  alloc]init];
        
        space.gateway_Num  = [set stringForColumn:@"GATEWAY_NO"];
        
        space.phone_Num = [set stringForColumn:@"PHONE_NUM"];
        
        space.space_ID = [set stringForColumn:@"SPACE_ID"];
        
        space.space_Name = [set  stringForColumn:@"SPACE_NAME"];
        
        space.space_Num = [set  stringForColumn:@"SPACE_NO"];
        
        [spaces addObject:space ];
        
    }
    
    return spaces;
}


/**
 *  删除空间
 */
+(void)delete:(spaceMessageModel *)space{
    
    [_db executeUpdateWithFormat:@"DELETE FROM t_spaceTbale where SPACE_NO=%@ ;",space.space_Num];
    
}

/**
 *  更新空间信息，根据spaceno
 *
 *  @param deviceSpace
 */
+(void)updateSpaceMessage:(spaceMessageModel *)space{
    
    
    [_db   executeUpdateWithFormat:@"UPDATE t_spaceTbale SET  SPACE_NAME = %@ , PHONE_NUM = %@ , GATEWAY_NO = %@ ,SPACE_ID = %@ WHERE SPACE_NO = %@ ;",space.space_Name,space.phone_Num,space.gateway_Num,space.space_ID,space.space_Num];
    
}



@end
