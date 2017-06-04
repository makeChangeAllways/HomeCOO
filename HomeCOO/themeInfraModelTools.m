//
//  themeInfraModelTools.m
//  HomeCOO
//
//  Created by app on 2016/10/19.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "themeInfraModelTools.h"
#import "themeInfraModel.h"
#import "FMDB.h"

static FMDatabasess *_db;

@implementation themeInfraModelTools


//首先需要有数据库
+(void)initialize
{
    // 1.打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"HomeCOO_IOS.sqlite"];
    _db = [FMDatabasess databaseWithPath:path];
    
    [_db open];
    
    // 2.创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_themeInfra ( DEVICE_NO text, DEVICE_STATE_CMD text, GATEWAY_NO text ,INFRA_CRL_NAME text,INFRA_TYPE_ID integer,THEME_NO text);"];

}

//插入一条数据
+(void)addThemeInfraDevice:(themeInfraModel *)device{
    
    //插入数据
    [_db executeUpdateWithFormat:@"INSERT INTO t_themeInfra(DEVICE_NO, DEVICE_STATE_CMD,GATEWAY_NO,INFRA_CRL_NAME,INFRA_TYPE_ID,THEME_NO) VALUES (%@,%@,%@,%@,%ld,%@);",device.deviceNo,device.deviceState_Cmd,device.gatewayNo,device.infraControlName,(long)device.infraType_ID,device.themeNo];
    
}

+(NSArray *)querWithInfraDevices:(themeInfraModel*)device{
    FMResultSets *set = [_db executeQueryWithFormat:@"SELECT * FROM t_themeInfra  WHERE THEME_NO =%@ and DEVICE_NO = %@ and INFRA_TYPE_ID = %ld ",device.themeNo,device.deviceNo,(long)device.infraType_ID];
    
    NSMutableArray * devices=[NSMutableArray array];
    
    // 不断往下取数据
    while (set.next) {//进行查询前的准备工作
        
        themeInfraModel *dev = [[themeInfraModel  alloc]init];
        
        dev.deviceNo  = [set stringForColumn:@"DEVICE_NO"];
        
        dev.deviceState_Cmd = [set stringForColumn:@"DEVICE_STATE_CMD"];
        
        dev.themeNo = [set stringForColumn:@"THEME_NO"];
        
        dev.gatewayNo = [set stringForColumn:@"GATEWAY_NO"];
        
        dev.infraType_ID = [set intForColumn:@"INFRA_TYPE_ID"];
        
        dev.infraControlName = [set stringForColumn:@"INFRA_CRL_NAME"];
        
        [devices addObject:dev];
        
    }
    
    return devices;
    
    
}

+(NSArray *)querWithInfraThemes:(themeInfraModel*)device{
    FMResultSets *set = [_db executeQueryWithFormat:@"SELECT * FROM t_themeInfra  WHERE THEME_NO =%@ and GATEWAY_NO = %@ ",device.themeNo,device.gatewayNo];
    
    NSMutableArray * devices=[NSMutableArray array];
    
    // 不断往下取数据
    while (set.next) {//进行查询前的准备工作
        
        themeInfraModel *dev = [[themeInfraModel  alloc]init];
        
        dev.deviceNo  = [set stringForColumn:@"DEVICE_NO"];
        
        dev.deviceState_Cmd = [set stringForColumn:@"DEVICE_STATE_CMD"];
        
        dev.themeNo = [set stringForColumn:@"THEME_NO"];
        
        dev.gatewayNo = [set stringForColumn:@"GATEWAY_NO"];
        
        dev.infraType_ID = [set intForColumn:@"INFRA_TYPE_ID"];
        
        dev.infraControlName = [set stringForColumn:@"INFRA_CRL_NAME"];
        
        [devices addObject:dev];
        
    }
    
    return devices;
    
    
}

+(NSArray *)querWithInfraThemesByGW:(themeInfraModel*)device{
    FMResultSets *set = [_db executeQueryWithFormat:@"SELECT * FROM t_themeInfra  WHERE  GATEWAY_NO = %@ ",device.gatewayNo];
    
    NSMutableArray * devices=[NSMutableArray array];
    
    // 不断往下取数据
    while (set.next) {//进行查询前的准备工作
        
        themeInfraModel *dev = [[themeInfraModel  alloc]init];
        
        dev.deviceNo  = [set stringForColumn:@"DEVICE_NO"];
        
        dev.deviceState_Cmd = [set stringForColumn:@"DEVICE_STATE_CMD"];
        
        dev.themeNo = [set stringForColumn:@"THEME_NO"];
        
        dev.gatewayNo = [set stringForColumn:@"GATEWAY_NO"];
        
        dev.infraType_ID = [set intForColumn:@"INFRA_TYPE_ID"];
        
        dev.infraControlName = [set stringForColumn:@"INFRA_CRL_NAME"];
        
        [devices addObject:dev];
        
    }
    
    return devices;
    
    
}



+(void)updateInfraDeviceState:(themeInfraModel *)device{
    
    
    [_db   executeUpdateWithFormat:@"UPDATE t_themeInfra SET DEVICE_NO = %@, INFRA_CRL_NAME = %@ ,DEVICE_STATE_CMD = %@  WHERE THEME_NO =%@ and DEVICE_NO = %@ and INFRA_TYPE_ID = %ld ;",device.deviceNo,device.infraControlName,device.deviceState_Cmd,device.themeNo,device.deviceNo,(long)device.infraType_ID];
    
    
}


+(void)deleteThemeInfraDevice:(themeInfraModel*)device{
    
    
    [_db executeUpdateWithFormat:@"DELETE FROM t_themeInfra where INFRA_TYPE_ID =%ld and DEVICE_NO = %@ and THEME_NO = %@;",(long)device.infraType_ID,device.deviceNo,device.themeNo];
    
}

//删除整张表
+(void)deleteAllThemeInfraDevice:(themeInfraModel*)device{
    
    
    [_db executeUpdateWithFormat:@"DELETE FROM t_themeInfra;"];
    
}


@end
