//
//  CYdeviceMessageTool.m
//  HomeCOO
//
//  Created by app on 2017/1/3.
//  Copyright © 2017年 Jiaoda. All rights reserved.
//

#import "CYdeviceMessageTool.h"
#import "FMDB.h"
#import "CYdeviceMessage.h"
@implementation CYdeviceMessageTool

static FMDatabasess *_db;
//首先需要有数据库
+(void)initialize
{
    // 1.打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"HomeCOO_IOS.sqlite"];
    _db = [FMDatabasess databaseWithPath:path];
    
    [_db open];
    
    // 2.创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_CYdeviceTbale (NAME text,TYPE text,SET_CODE blob,CURRENT_TYPE text,CURRENT_DEVICENO text);"];
    
}

//插入一条数据
+(void)addDevice:(CYdeviceMessage *)device{
    
    //插入数据
    [_db executeUpdateWithFormat:@"INSERT INTO t_CYdeviceTbale(NAME,TYPE,SET_CODE,CURRENT_TYPE,CURRENT_DEVICENO) VALUES (%@,%@,%@,%@,%@);",device.name,device.type,device.setCode,device.currentType,device.currentDeviceNo];
    
}
+(NSArray *)queryWithSocksDevices:(CYdeviceMessage *)device{
    
    //得到结果集
    FMResultSets *set = [_db executeQueryWithFormat:@"SELECT * FROM t_CYdeviceTbale where CURRENT_DEVICENO = %@",device.currentDeviceNo];
    
    NSMutableArray * devices=[NSMutableArray array];
    
    // 不断往下取数据
    while (set.next) {//进行查询前的准备工作
        
        CYdeviceMessage *dev = [[CYdeviceMessage  alloc]init];
        
        dev.name  = [set stringForColumn:@"NAME"];
        
        dev.type = [set stringForColumn:@"TYPE"];
       
        dev.setCode = [set dataForColumn:@"SET_CODE"];
        
        dev.currentType = [set stringForColumn:@"CURRENT_TYPE"];
        
        dev.currentDeviceNo = [set stringForColumn:@"CURRENT_DEVICENO"];
        

        [devices addObject:dev ];
        
        
    }
    
    return devices;
}

+(void)deleteDevice:(CYdeviceMessage*)device{
    
    
    [_db executeUpdateWithFormat:@"DELETE FROM t_CYdeviceTbale where SET_CODE=%@  ;",device.setCode];
    
}


@end
