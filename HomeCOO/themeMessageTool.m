//
//  themeMessageTool.m
//  HomeCOO
//
//  Created by tgbus on 16/7/4.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "themeMessageTool.h"
#import "themMessageModel.h"
#import "FMDB.h"


@implementation themeMessageTool

static  FMDatabasess *_db;
/**
 *  初始化数据库
 */
+(void)initialize{

    // 1.打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"HomeCOO_IOS.sqlite"];
    _db = [FMDatabasess databaseWithPath:path];
    [_db open];
    
    // 2.创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_themeTbale (DEVICE_NO text, GATEWAY_NO text,  THEME_ID text , THEME_NAME text , THEME_NO text, THEME_STATE text,  THEME_TYPE text);"];
}


/**
 *  添加情景
 *
 *  @param
 */

+(void)addTheme:(themMessageModel *)theme{

    //插入新的空间信息
    [_db executeUpdateWithFormat:@"INSERT INTO t_themeTbale (GATEWAY_NO, THEME_NAME,THEME_NO,DEVICE_NO,THEME_STATE,THEME_TYPE) VALUES (%@,%@,%@,%@,%@,%ld);", theme.gateway_No, theme.theme_Name,theme.theme_No,theme.device_No,theme.theme_State,(long)theme.theme_Type];
    
    
}
/**
 删除情景表
 */
+(void)deleteThemeTable{
 
    [_db executeUpdateWithFormat:@"DELETE FROM t_themeTbale WHERE THEME_TYPE !=%d ;",1];
    
}

/**
 *  在t_themeTbale 表中查找已经添加的情景
 *
 *  @param NSArray 存取所有情景
 *
 *  @return 返回所有情景
 */
+(NSArray *)queryWiththemes:(themMessageModel *)theme{
    
    //得到结果集
    FMResultSets *set = [_db executeQueryWithFormat:@"SELECT * FROM t_themeTbale WHERE GATEWAY_NO = %@ and THEME_TYPE !=%d",theme.gateway_No,3];
    
    NSMutableArray * themes=[NSMutableArray array];
    
    // 不断往下取数据
    while (set.next) {//进行查询前的准备工作
        
        themMessageModel *theme = [[themMessageModel  alloc]init];
        
        theme.device_No  = [set stringForColumn:@"DEVICE_NO"];
        
        theme.gateway_No = [set stringForColumn:@"GATEWAY_NO"];
        
        theme.theme_ID = [set stringForColumn:@"THEME_ID"];
        
        theme.theme_Name = [set  stringForColumn:@"THEME_NAME"];
        
        theme.theme_No = [set  stringForColumn:@"THEME_NO"];
        
        theme.theme_State = [set  stringForColumn:@"THEME_STATE"];
        
        theme.theme_Type = [set  intForColumn:@"THEME_TYPE"];
        
        [themes addObject:theme ];
        
    }
    
    return themes;
}


/**
 *  根据deviceno 在theme表中查是否有对应的情景名称
 *
 *  @return
 */
+(NSArray *)queryWiththeme:(themMessageModel *)theme{
    

    FMResultSets *set = [_db executeQueryWithFormat:@"SELECT * FROM t_themeTbale where DEVICE_NO = %@ ",theme.device_No];
    
    NSMutableArray * themes=[NSMutableArray array];
    
    // 不断往下取数据
    while (set.next) {//进行查询前的准备工作
        
        themMessageModel *theme = [[themMessageModel  alloc]init];
        
        theme.device_No  = [set stringForColumn:@"DEVICE_NO"];
        
        theme.gateway_No = [set stringForColumn:@"GATEWAY_NO"];
        
        theme.theme_ID = [set stringForColumn:@"THEME_ID"];
        
        theme.theme_Name = [set  stringForColumn:@"THEME_NAME"];
        
        theme.theme_No = [set  stringForColumn:@"THEME_NO"];
        
        theme.theme_State = [set  stringForColumn:@"THEME_STATE"];
        
        theme.theme_Type = [set  intForColumn:@"THEME_TYPE"];
        
        [themes addObject:theme ];
        
    }
    
    return themes;
}

/**
 *  根据themeNo 在theme表中查是否有对应的情景名称
 *
 *  @return
 */
+(NSArray *)queryThemeWithThemeNum:(themMessageModel *)theme{
    
    
    FMResultSets *set = [_db executeQueryWithFormat:@"SELECT * FROM t_themeTbale where THEME_NO = %@ ",theme.theme_No];
    
    NSMutableArray * themes=[NSMutableArray array];
    
    // 不断往下取数据
    while (set.next) {//进行查询前的准备工作
        
        themMessageModel *theme = [[themMessageModel  alloc]init];
        
        theme.device_No  = [set stringForColumn:@"DEVICE_NO"];
        
        theme.gateway_No = [set stringForColumn:@"GATEWAY_NO"];
        
        theme.theme_ID = [set stringForColumn:@"THEME_ID"];
        
        theme.theme_Name = [set  stringForColumn:@"THEME_NAME"];
        
        theme.theme_No = [set  stringForColumn:@"THEME_NO"];
        
        theme.theme_State = [set  stringForColumn:@"THEME_STATE"];
        
        theme.theme_Type = [set  intForColumn:@"THEME_TYPE"];
        
        [themes addObject:theme ];
        
    }
    
    return themes;
}



/**
 *  根据themeno 在theme表中查是否已经存在该themeno的情景
 *
 *  @return
 */
+(NSArray *)queryWiththemeNo:(themMessageModel *)theme{
    
    
    FMResultSets *set = [_db executeQueryWithFormat:@"SELECT * FROM t_themeTbale where DEVICE_NO = %@ and GATEWAY_NO = %@ ",theme.device_No,theme.gateway_No];
    
    NSMutableArray * themes=[NSMutableArray array];
    
    // 不断往下取数据
    while (set.next) {//进行查询前的准备工作
        
        themMessageModel *theme = [[themMessageModel  alloc]init];
        
        theme.device_No  = [set stringForColumn:@"DEVICE_NO"];
        
        theme.gateway_No = [set stringForColumn:@"GATEWAY_NO"];
        
        theme.theme_ID = [set stringForColumn:@"THEME_ID"];
        
        theme.theme_Name = [set  stringForColumn:@"THEME_NAME"];
        
        theme.theme_No = [set  stringForColumn:@"THEME_NO"];
        
        theme.theme_State = [set  stringForColumn:@"THEME_STATE"];
        
        theme.theme_Type = [set  intForColumn:@"THEME_TYPE"];
        
        [themes addObject:theme ];
        
    }
    
    return themes;
}

/**
 *  删除情景
 */
+(void)delete:(themMessageModel *)theme{
    
    [_db executeUpdateWithFormat:@"DELETE FROM t_themeTbale where THEME_NO=%@ ;",theme.theme_No];
    
}


/**
 *  更换情景名称
 *
 *  @param
 */
+(void)updateThemeName:(themMessageModel *)theme{
    
    
    [_db   executeUpdateWithFormat:@"UPDATE t_themeTbale  SET  THEME_NAME = %@   WHERE THEME_NO = %@ ;",theme.theme_Name,theme.theme_No];
    
    
}


/**
 *  更换安防类情景的themeno （仅限于安防类情景  themetype = 3）
 *
 *  @param
 */
+(void)updateSensorThemeNo:(themMessageModel *)theme{
    
    
    [_db   executeUpdateWithFormat:@"UPDATE t_themeTbale  SET  THEME_NO = %@   WHERE DEVICE_NO = %@ and GATEWAY_NO = %@ ;",theme.theme_No,theme.device_No,theme.gateway_No];
    
    
}

@end
