//
//  musicModelDBTools.m
//  HomeCOO
//
//  Created by app on 2016/12/9.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "musicModelDBTools.h"
#import "musicModelDB.h"
#import "FMDB.h"

static FMDatabasess *_db;

@implementation musicModelDBTools
//首先需要有数据库
+(void)initialize
{
    //1.打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"HomeCOO_IOS.sqlite"];
    _db = [FMDatabasess databaseWithPath:path];
    
    [_db open];

    //2.创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_musicTable ( BZ text, DEVICE_NO text, DEVICE_STATE text ,GATEWAY_NO text,SONG_NAME text,SPACE text,STYLE text,THEME_NAME text,THEME_NO text);"];
    
}

+(void)addMusicList:(musicModelDB *)music{
    
    //插入数据
    [_db executeUpdateWithFormat:@"INSERT INTO t_musicTable(BZ, DEVICE_NO,DEVICE_STATE,GATEWAY_NO,SONG_NAME,SPACE,STYLE,THEME_NAME,THEME_NO) VALUES (%@,%@,%@,%@,%@,%@,%@,%@,%@);",music.bz,music.deviceNo,music.deviceState,music.gatewayNo,music.songName,music.space,music.style,music.themeName,music.themeNo];
    
}

+(void)updateMusicList:(musicModelDB *)music{

 [_db   executeUpdateWithFormat:@"UPDATE t_musicTable SET  BZ = %@ , DEVICE_NO = %@ , DEVICE_STATE = %@, GATEWAY_NO = %@, SONG_NAME = %@, SPACE = %@, STYLE = %@ , THEME_NAME = %@ WHERE THEME_NO = %@ ;",music.bz,music.deviceNo,music.deviceState,music.gatewayNo,music.songName,music.space,music.style,music.themeName,music.themeNo];


}

+(NSArray *)queryWithDeviceNumDevices{
    
    
    FMResultSets *set = [_db executeQueryWithFormat:@"SELECT * FROM t_musicTable "];
    
    NSMutableArray * musics=[NSMutableArray array];
    
    // 不断往下取数据
    while (set.next) {//进行查询前的准备工作
        
        musicModelDB *music = [[musicModelDB  alloc]init];
        
        music.bz  = [set stringForColumn:@"BZ"];
        
        music.deviceNo = [set stringForColumn:@"DEVICE_NO"];
        
        music.deviceState = [set stringForColumn:@"DEVICE_STATE"];
        
        music.gatewayNo = [set stringForColumn:@"GATEWAY_NO"];
        
        music.songName = [set stringForColumn:@"SONG_NAME"];
        
        music.space = [set stringForColumn:@"SPACE"];
        
        music.style = [set stringForColumn:@"STYLE"];
        
        music.themeName = [set stringForColumn:@"THEME_NAME"];
        
        music.themeNo = [set stringForColumn:@"THEME_NO"];
        
        [musics addObject:music];
        
    }
    
    return musics;
}

+(NSArray *)querWithThemeNoMusic:(musicModelDB*)music{
    FMResultSets *set = [_db executeQueryWithFormat:@"SELECT * FROM t_musicTable  WHERE THEME_NO =%@ ",music.themeNo];
    
    NSMutableArray * musics=[NSMutableArray array];
    
    // 不断往下取数据
    while (set.next) {//进行查询前的准备工作
        
        musicModelDB *music = [[musicModelDB  alloc]init];
        
        music.bz  = [set stringForColumn:@"BZ"];
        
        music.deviceNo = [set stringForColumn:@"DEVICE_NO"];
        
        music.deviceState = [set stringForColumn:@"DEVICE_STATE"];
        
        music.gatewayNo = [set stringForColumn:@"GATEWAY_NO"];
        
        music.songName = [set stringForColumn:@"SONG_NAME"];
        
        music.space = [set stringForColumn:@"SPACE"];
        
        music.style = [set stringForColumn:@"STYLE"];
        
        music.themeName = [set stringForColumn:@"THEME_NAME"];
        
        music.themeNo = [set stringForColumn:@"THEME_NO"];
        
        [musics addObject:music];
        
    }
    
    return musics;


}

+(void)deleteMusicTable{
    [_db executeUpdateWithFormat:@"DELETE FROM t_musicTable;"];
    

}

@end
