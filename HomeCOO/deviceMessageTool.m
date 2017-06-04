//
//  deviceMessageTool.m
//  HomeCOO
//
//  Created by tgbus on 16/5/31.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "deviceMessageTool.h"
#import "deviceMessage.h"
#import "FMDB.h"


@implementation deviceMessageTool

static FMDatabasess *_db;

//首先需要有数据库
+(void)initialize
{
    // 1.打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"HomeCOO_IOS.sqlite"];
    _db = [FMDatabasess databaseWithPath:path];
    
    [_db open];
    
    // 2.创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_deviceTbale (DEVICE_ID integer ,DEVICE_GATEGORY_ID integer  , DEVICE_GATEGORY_NAME text, DEVICE_NAME text ,DEVICE_NO text  ,DEVICE_STATE text,DEVICE_TYPE_ID  integer ,DEVICE_TYPE_NAME text,GATEWAY_NO text ,PHONE_NUM text,SPACE_NO text,SPACE_TYPE_ID integer);"];
   
}

//插入一条数据
+(void)addDevice:(deviceMessage *)device{
    
    //插入数据
    [_db executeUpdateWithFormat:@"INSERT INTO t_deviceTbale(DEVICE_ID,DEVICE_GATEGORY_ID, DEVICE_GATEGORY_NAME,DEVICE_NAME,DEVICE_NO,DEVICE_STATE,DEVICE_TYPE_ID,DEVICE_TYPE_NAME,GATEWAY_NO,PHONE_NUM,SPACE_NO,SPACE_TYPE_ID) VALUES (%ld,%ld,%@,%@,%@,%@,%ld,%@,%@,%@,%@,%ld);",(long)device.DEVICE_ID,(long)device.DEVICE_GATEGORY_ID, device.DEVICE_GATEGORY_NAME,device.DEVICE_NAME,device.DEVICE_NO,device.DEVICE_STATE,(long)device.DEVICE_TYPE_ID,device.DEVICE_TYPE_NAME,device.GATEWAY_NO,device.PHONE_NUM,device.SPACE_NO,(long)device.SPACE_TYPE_ID];
    
}

/**
 删除设备表
 */
+(void)deleteDeviceTable{
    
    [_db executeUpdateWithFormat:@"DELETE FROM t_deviceTbale ;"];
    
}

/**
 *  更新设备状态信息
 *
 *  @param device 更新的设备
 */
+(void)updateDeviceState:(deviceMessage *)device{
  
    
    [_db   executeUpdateWithFormat:@"UPDATE t_deviceTbale SET  DEVICE_STATE = %@ WHERE DEVICE_NO = %@ and GATEWAY_NO = %@ ;",device.DEVICE_STATE,device.DEVICE_NO,device.GATEWAY_NO];
    

}


/**
 *  删除设备记录
 */
+(void)deleteDevice:(deviceMessage*)device{
    
   
        [_db executeUpdateWithFormat:@"DELETE FROM t_deviceTbale where DEVICE_NO=%@ and GATEWAY_NO = %@ ;",device.DEVICE_NO,device.GATEWAY_NO];
    
}


/**
 *  查询照明设备信息
 *
 *  @param NSArray 存取照明设备信息
 *
 *  @return 返回所有照明设备的信息
 */
+(NSArray *)queryWithLightDevices:(deviceMessage *)device{
    
    //得到结果集
    FMResultSets *set = [_db executeQueryWithFormat:@"SELECT * FROM t_deviceTbale  WHERE DEVICE_GATEGORY_ID =%d and GATEWAY_NO =%@  ",1,device.GATEWAY_NO];

    NSMutableArray * devices=[NSMutableArray array];

   // NSLog(@"%d",set.next);
    
    // 不断往下取数据
    while (set.next) {//进行查询前的准备工作
        
        deviceMessage *dev = [[deviceMessage  alloc]init];

        
            
            dev.DEVICE_GATEGORY_ID  = [set intForColumn:@"DEVICE_GATEGORY_ID"];

            dev.DEVICE_GATEGORY_NAME = [set stringForColumn:@"DEVICE_GATEGORY_NAME"];

            dev.DEVICE_NAME = [set stringForColumn:@"DEVICE_NAME"];

            dev.DEVICE_STATE = [set stringForColumn:@"DEVICE_STATE"];
            
            dev.DEVICE_NO = [set stringForColumn:@"DEVICE_NO"];

            dev.DEVICE_TYPE_ID = [set intForColumn:@"DEVICE_TYPE_ID"];

            dev.DEVICE_TYPE_NAME = [set stringForColumn:@"DEVICE_TYPE_NAME"];

            dev.GATEWAY_NO = [set stringForColumn:@"GATEWAY_NO"];

            dev.PHONE_NUM = [set stringForColumn:@"PHONE_NUM"];

            dev.SPACE_NO = [set stringForColumn:@"SPACE_NO"];
            
            dev.SPACE_TYPE_ID = [set intForColumn:@"SPACE_TYPE_ID"];
        
        if (dev.DEVICE_TYPE_ID !=105) {
            
            [devices addObject:dev ];
            
        }
        
        
       
    }
    
     return devices;
}
/**
 *  查询温湿度
 *
 *  @param NSArray 
 *
 *  @return 
 */
+(NSArray *)queryTempSensorDevices:(deviceMessage *)device{
    
    //得到结果集
    FMResultSets *set = [_db executeQueryWithFormat:@"SELECT * FROM t_deviceTbale  WHERE DEVICE_TYPE_ID =%d and GATEWAY_NO =%@  ",104,device.GATEWAY_NO];
    
    NSMutableArray * devices=[NSMutableArray array];
    
    // NSLog(@"%d",set.next);
    
    // 不断往下取数据
    while (set.next) {//进行查询前的准备工作
        
        deviceMessage *dev = [[deviceMessage  alloc]init];
        
        dev.DEVICE_GATEGORY_ID  = [set intForColumn:@"DEVICE_GATEGORY_ID"];
        
        dev.DEVICE_GATEGORY_NAME = [set stringForColumn:@"DEVICE_GATEGORY_NAME"];
        
        dev.DEVICE_NAME = [set stringForColumn:@"DEVICE_NAME"];
        
        dev.DEVICE_STATE = [set stringForColumn:@"DEVICE_STATE"];
        
        dev.DEVICE_NO = [set stringForColumn:@"DEVICE_NO"];
        
        dev.DEVICE_TYPE_ID = [set intForColumn:@"DEVICE_TYPE_ID"];
        
        dev.DEVICE_TYPE_NAME = [set stringForColumn:@"DEVICE_TYPE_NAME"];
        
        dev.GATEWAY_NO = [set stringForColumn:@"GATEWAY_NO"];
        
        dev.PHONE_NUM = [set stringForColumn:@"PHONE_NUM"];
        
        dev.SPACE_NO = [set stringForColumn:@"SPACE_NO"];
        
        dev.SPACE_TYPE_ID = [set intForColumn:@"SPACE_TYPE_ID"];
        
        [devices addObject:dev ];
        
        
    }
    
    return devices;
}
/**
 *  查询PM2_5
 *
 *  @param NSArray
 *
 *  @return
 */
+(NSArray *)queryPM2_5SensorDevices:(deviceMessage *)device{
    
    //得到结果集
    FMResultSets *set = [_db executeQueryWithFormat:@"SELECT * FROM t_deviceTbale  WHERE DEVICE_TYPE_ID =%d and GATEWAY_NO =%@  ",109,device.GATEWAY_NO];
    
    NSMutableArray * devices=[NSMutableArray array];
    
    // NSLog(@"%d",set.next);
    
    // 不断往下取数据
    while (set.next) {//进行查询前的准备工作
        
        deviceMessage *dev = [[deviceMessage  alloc]init];
        
        dev.DEVICE_GATEGORY_ID  = [set intForColumn:@"DEVICE_GATEGORY_ID"];
        
        dev.DEVICE_GATEGORY_NAME = [set stringForColumn:@"DEVICE_GATEGORY_NAME"];
        
        dev.DEVICE_NAME = [set stringForColumn:@"DEVICE_NAME"];
        
        dev.DEVICE_STATE = [set stringForColumn:@"DEVICE_STATE"];
        
        dev.DEVICE_NO = [set stringForColumn:@"DEVICE_NO"];
        
        dev.DEVICE_TYPE_ID = [set intForColumn:@"DEVICE_TYPE_ID"];
        
        dev.DEVICE_TYPE_NAME = [set stringForColumn:@"DEVICE_TYPE_NAME"];
        
        dev.GATEWAY_NO = [set stringForColumn:@"GATEWAY_NO"];
        
        dev.PHONE_NUM = [set stringForColumn:@"PHONE_NUM"];
        
        dev.SPACE_NO = [set stringForColumn:@"SPACE_NO"];
        
        dev.SPACE_TYPE_ID = [set intForColumn:@"SPACE_TYPE_ID"];
        
        [devices addObject:dev ];
        
        
    }
    
    return devices;
}


/**
 *  查询在空间显示的设备 只显示三大类（照明  门窗  插座）
 *
 *  @param NSArray 存取照明设备信息
 *
 *  @return 返回所有照明设备的信息
 */
+(NSArray *)queryWithSpaceDevices:(deviceMessage *)device{
    
    //得到结果集
    FMResultSets *set = [_db executeQueryWithFormat:@"SELECT * FROM t_deviceTbale  WHERE DEVICE_GATEGORY_ID = %d or DEVICE_GATEGORY_ID =%d or DEVICE_GATEGORY_ID = %d and GATEWAY_NO = %@ ",1,3,5,device.GATEWAY_NO];
    
    NSMutableArray * devices=[NSMutableArray array];
    
    // NSLog(@"%d",set.next);
    
    // 不断往下取数据
    while (set.next) {//进行查询前的准备工作
        
        deviceMessage *dev = [[deviceMessage  alloc]init];
        
        dev.DEVICE_GATEGORY_ID  = [set intForColumn:@"DEVICE_GATEGORY_ID"];
        
        dev.DEVICE_GATEGORY_NAME = [set stringForColumn:@"DEVICE_GATEGORY_NAME"];
        
        dev.DEVICE_NAME = [set stringForColumn:@"DEVICE_NAME"];
        
        dev.DEVICE_STATE = [set stringForColumn:@"DEVICE_STATE"];
        
        dev.DEVICE_NO = [set stringForColumn:@"DEVICE_NO"];
        
        dev.DEVICE_TYPE_ID = [set intForColumn:@"DEVICE_TYPE_ID"];
        
        dev.DEVICE_TYPE_NAME = [set stringForColumn:@"DEVICE_TYPE_NAME"];
        
        dev.GATEWAY_NO = [set stringForColumn:@"GATEWAY_NO"];
        
        dev.PHONE_NUM = [set stringForColumn:@"PHONE_NUM"];
        
        dev.SPACE_NO = [set stringForColumn:@"SPACE_NO"];
        
        dev.SPACE_TYPE_ID = [set intForColumn:@"SPACE_TYPE_ID"];
        
        [devices addObject:dev ];
        
        
    }
    
    return devices;
}


/**
 *  查询门窗设备信息
 *
 *  @param NSArray 存取门窗设备信息
 *
 *  @return 返回所有照明设备的信息
 */
+(NSArray *)queryWithWindowsDevices:(deviceMessage *)device{
    
    //得到结果集
    FMResultSets *set = [_db executeQueryWithFormat:@"SELECT * FROM t_deviceTbale  WHERE DEVICE_GATEGORY_ID =%d and GATEWAY_NO = %@ ",3,device.GATEWAY_NO];
    
    NSMutableArray * devices=[NSMutableArray array];
    
    // NSLog(@"%d",set.next);
    
    // 不断往下取数据
    while (set.next) {//进行查询前的准备工作
        
        deviceMessage *dev = [[deviceMessage  alloc]init];
        
        dev.DEVICE_GATEGORY_ID  = [set intForColumn:@"DEVICE_GATEGORY_ID"];
        
        dev.DEVICE_GATEGORY_NAME = [set stringForColumn:@"DEVICE_GATEGORY_NAME"];
        
        dev.DEVICE_NAME = [set stringForColumn:@"DEVICE_NAME"];
        
        dev.DEVICE_STATE = [set stringForColumn:@"DEVICE_STATE"];
        
        dev.DEVICE_NO = [set stringForColumn:@"DEVICE_NO"];
        
        dev.DEVICE_TYPE_ID = [set intForColumn:@"DEVICE_TYPE_ID"];
        
        dev.DEVICE_TYPE_NAME = [set stringForColumn:@"DEVICE_TYPE_NAME"];
        
        dev.GATEWAY_NO = [set stringForColumn:@"GATEWAY_NO"];
        
        dev.PHONE_NUM = [set stringForColumn:@"PHONE_NUM"];
        
        dev.SPACE_NO = [set stringForColumn:@"SPACE_NO"];
        
        dev.SPACE_TYPE_ID = [set intForColumn:@"SPACE_TYPE_ID"];
        
        [devices addObject:dev ];
        
        
    }
    
    return devices;
}

/**
 *  查询插座设备信息
 *
 *  @param NSArray 存取插座设备信息
 *
 *  @return 返回所有插座设备的信息
 */
+(NSArray *)queryWithSocksDevices:(deviceMessage *)device{
    
    //得到结果集
    FMResultSets *set = [_db executeQueryWithFormat:@"SELECT * FROM t_deviceTbale  WHERE DEVICE_TYPE_ID = %d and GATEWAY_NO = %@ ",8,device.GATEWAY_NO];
    
    NSMutableArray * devices=[NSMutableArray array];
 
    // 不断往下取数据
    while (set.next) {//进行查询前的准备工作
        
        deviceMessage *dev = [[deviceMessage  alloc]init];
        
        dev.DEVICE_GATEGORY_ID  = [set intForColumn:@"DEVICE_GATEGORY_ID"];
        
        dev.DEVICE_GATEGORY_NAME = [set stringForColumn:@"DEVICE_GATEGORY_NAME"];
        
        dev.DEVICE_NAME = [set stringForColumn:@"DEVICE_NAME"];
        
        dev.DEVICE_STATE = [set stringForColumn:@"DEVICE_STATE"];
        
        dev.DEVICE_NO = [set stringForColumn:@"DEVICE_NO"];
        
        dev.DEVICE_TYPE_ID = [set intForColumn:@"DEVICE_TYPE_ID"];
        
        dev.DEVICE_TYPE_NAME = [set stringForColumn:@"DEVICE_TYPE_NAME"];
        
        dev.GATEWAY_NO = [set stringForColumn:@"GATEWAY_NO"];
        
        dev.PHONE_NUM = [set stringForColumn:@"PHONE_NUM"];
        
        dev.SPACE_NO = [set stringForColumn:@"SPACE_NO"];
        
        dev.SPACE_TYPE_ID = [set intForColumn:@"SPACE_TYPE_ID"];
        
        [devices addObject:dev ];
        
        
    }
    
    return devices;
}

/**
 *  查询所有设备信息
 *
 *  @return 返回所有设备
 */

+(NSMutableArray *)queryWithDevices:(deviceMessage *)device{
    
    //得到结果集
    FMResultSets *set = [_db executeQueryWithFormat:@"SELECT * FROM t_deviceTbale WHERE GATEWAY_NO = %@ ",device.GATEWAY_NO];
    
    NSMutableArray * devices=[[NSMutableArray alloc]init];
    deviceMessage *dev;
    
    // 不断往下取数据
    while (set.next) {//进行查询前的准备工作
        
        dev = [[deviceMessage  alloc]init];
        
        dev.DEVICE_ID = [set intForColumn:@"DEVICE_ID"];
        
        dev.DEVICE_GATEGORY_ID  = [set intForColumn:@"DEVICE_GATEGORY_ID"];
        
        dev.DEVICE_GATEGORY_NAME = [set stringForColumn:@"DEVICE_GATEGORY_NAME"];
        
        dev.DEVICE_NAME = [set stringForColumn:@"DEVICE_NAME"];
        
        dev.DEVICE_STATE = [set stringForColumn:@"DEVICE_STATE"];
        
        dev.DEVICE_NO = [set stringForColumn:@"DEVICE_NO"];
        
        dev.DEVICE_TYPE_ID = [set intForColumn:@"DEVICE_TYPE_ID"];
        
        dev.DEVICE_TYPE_NAME = [set stringForColumn:@"DEVICE_TYPE_NAME"];
        
        dev.GATEWAY_NO = [set stringForColumn:@"GATEWAY_NO"];
        
        dev.PHONE_NUM = [set stringForColumn:@"PHONE_NUM"];
        
        dev.SPACE_NO = [set stringForColumn:@"SPACE_NO"];
        
        dev.SPACE_TYPE_ID = [set intForColumn:@"SPACE_TYPE_ID"];
        
        [devices addObject:dev ];
        
    }
  
//    deviceMessage  *test = devices[3];
//    
//    NSLog(@"=====%@====%ld===%@",test.DEVICE_NO,(long)test.DEVICE_TYPE_ID,test.DEVICE_NAME);
//    NSLog(@"%lu",(unsigned long)devices.count);

    return devices;
    
 

}
/**
 *  查询红外转发器信息
 *
 *  @return 返回所有设备
 */

+(NSMutableArray *)queryWithRemoteDevices:(deviceMessage *)device{
    
    //得到结果集
    FMResultSets *set = [_db executeQueryWithFormat:@"SELECT * FROM t_deviceTbale WHERE GATEWAY_NO = %@ and  DEVICE_TYPE_ID =%d",device.GATEWAY_NO,105];
    
    NSMutableArray * devices=[[NSMutableArray alloc]init];
    deviceMessage *dev;
    
    // 不断往下取数据
    while (set.next) {//进行查询前的准备工作
        
        dev = [[deviceMessage  alloc]init];
        
        dev.DEVICE_GATEGORY_ID  = [set intForColumn:@"DEVICE_GATEGORY_ID"];
        
        dev.DEVICE_GATEGORY_NAME = [set stringForColumn:@"DEVICE_GATEGORY_NAME"];
        
        dev.DEVICE_NAME = [set stringForColumn:@"DEVICE_NAME"];
        
        dev.DEVICE_STATE = [set stringForColumn:@"DEVICE_STATE"];
        
        dev.DEVICE_NO = [set stringForColumn:@"DEVICE_NO"];
        
        dev.DEVICE_TYPE_ID = [set intForColumn:@"DEVICE_TYPE_ID"];
        
        dev.DEVICE_TYPE_NAME = [set stringForColumn:@"DEVICE_TYPE_NAME"];
        
        dev.GATEWAY_NO = [set stringForColumn:@"GATEWAY_NO"];
        
        dev.PHONE_NUM = [set stringForColumn:@"PHONE_NUM"];
        
        dev.SPACE_NO = [set stringForColumn:@"SPACE_NO"];
        
        dev.SPACE_TYPE_ID = [set intForColumn:@"SPACE_TYPE_ID"];
        
        [devices addObject:dev ];
        
    }
    
    //    deviceMessage  *test = devices[3];
    //
    //    NSLog(@"=====%@====%ld===%@",test.DEVICE_NO,(long)test.DEVICE_TYPE_ID,test.DEVICE_NAME);
    //    NSLog(@"%lu",(unsigned long)devices.count);
    
    return devices;
    
    
    
}


/**
 *  查询传感器类设备(应用在 联动设置里)
 *
 *  @return 返回所有设备
 */

+(NSArray *)queryWithSensorDevices:(deviceMessage *)device{
    
    
    //得到结果集
    FMResultSets *set = [_db executeQueryWithFormat:@"SELECT * FROM t_deviceTbale WHERE GATEWAY_NO = %@ and DEVICE_GATEGORY_ID = %d and DEVICE_TYPE_ID > %d ",device.GATEWAY_NO,2,109];
    
    NSMutableArray * devices=[NSMutableArray array];
    
    
    // 不断往下取数据
    while (set.next) {//进行查询前的准备工作
        
        deviceMessage *dev = [[deviceMessage  alloc]init];
        
        dev.DEVICE_GATEGORY_ID  = [set intForColumn:@"DEVICE_GATEGORY_ID"];
        
        dev.DEVICE_GATEGORY_NAME = [set stringForColumn:@"DEVICE_GATEGORY_NAME"];
        
        dev.DEVICE_NAME = [set stringForColumn:@"DEVICE_NAME"];
        
        dev.DEVICE_STATE = [set stringForColumn:@"DEVICE_STATE"];
        
        dev.DEVICE_NO = [set stringForColumn:@"DEVICE_NO"];
        
        dev.DEVICE_TYPE_ID = [set intForColumn:@"DEVICE_TYPE_ID"];
        
        dev.DEVICE_TYPE_NAME = [set stringForColumn:@"DEVICE_TYPE_NAME"];
        
        dev.GATEWAY_NO = [set stringForColumn:@"GATEWAY_NO"];
        
        dev.PHONE_NUM = [set stringForColumn:@"PHONE_NUM"];
        
        dev.SPACE_NO = [set stringForColumn:@"SPACE_NO"];
        
        dev.SPACE_TYPE_ID = [set intForColumn:@"SPACE_TYPE_ID"];
        
        [devices addObject:dev ];
        
    }
    
    return devices;
    
}

/**
 *  根据设备的mac地址  查找当前设备的所有信息
 *
 *  @param Device
 *
 *  @return
 */
+(NSArray *)queryWithDeviceNumDevices:(deviceMessage *)Device{
    
    
    FMResultSets *set = [_db executeQueryWithFormat:@"SELECT * FROM t_deviceTbale  WHERE DEVICE_NO =%@ and  GATEWAY_NO = %@",Device.DEVICE_NO,Device.GATEWAY_NO];
   
    NSMutableArray * devices=[NSMutableArray array];
    
    // 不断往下取数据
    while (set.next) {//进行查询前的准备工作
        
        deviceMessage *dev = [[deviceMessage  alloc]init];
        
        dev.DEVICE_ID = [set  intForColumn:@"DEVICE_ID"];
        
        dev.DEVICE_GATEGORY_ID  = [set intForColumn:@"DEVICE_GATEGORY_ID"];
        
        dev.DEVICE_GATEGORY_NAME = [set stringForColumn:@"DEVICE_GATEGORY_NAME"];
        
        dev.DEVICE_NAME = [set stringForColumn:@"DEVICE_NAME"];
        
        dev.DEVICE_STATE = [set stringForColumn:@"DEVICE_STATE"];
        
        dev.DEVICE_NO = [set stringForColumn:@"DEVICE_NO"];
        
        dev.DEVICE_TYPE_ID = [set intForColumn:@"DEVICE_TYPE_ID"];
        
        dev.DEVICE_TYPE_NAME = [set stringForColumn:@"DEVICE_TYPE_NAME"];
        
        dev.GATEWAY_NO = [set stringForColumn:@"GATEWAY_NO"];
        
        dev.PHONE_NUM = [set stringForColumn:@"PHONE_NUM"];
        
        dev.SPACE_NO = [set stringForColumn:@"SPACE_NO"];
        
        dev.SPACE_TYPE_ID = [set intForColumn:@"SPACE_TYPE_ID"];
        
        [devices addObject:dev ];
        
    }
    
    return devices;
}

/**
 *  更新设备名称和位置
 *
 *  @param device 更新的设备
 */
+(void)updateDevicePostionAndName:(deviceMessage *)device{
    
    [_db   executeUpdateWithFormat:@"UPDATE t_deviceTbale  SET  DEVICE_TYPE_NAME = %@   , DEVICE_NAME = %@  WHERE DEVICE_NO = %@ ;",device.DEVICE_TYPE_NAME,device.DEVICE_NAME,device.DEVICE_NO];
    
}


/**
 *  根据设备id 更新设备的名称 （当前的方法未用到）
 *
 *  @param device
 */
+(void)updateDeviceName:(deviceMessage *)device{


    [_db   executeUpdateWithFormat:@"UPDATE t_deviceTbale  SET  DEVICE_NAME = %@  WHERE DEVICE_NO = %@ and PHONE_NUM = %@ ;",device.DEVICE_NAME,device.DEVICE_NO,device.PHONE_NUM];

}

/**
 *  根据设备id 和网关编号 更新设备的 SPACE_TYPE_ID
 *
 *  @param device
 */
+(void)updateDeviceSPACE_TYPE_ID:(deviceMessage *)device{
    
    [_db   executeUpdateWithFormat:@"UPDATE t_deviceTbale  SET  SPACE_TYPE_ID = %ld  WHERE DEVICE_NO = %@ and GATEWAY_NO = %@ ;",(long)device.SPACE_TYPE_ID,device.DEVICE_NO,device.GATEWAY_NO];
    
}


/**
 *  根据设备的mac地址 更新设备的信息
 *
 *  @param device
 */

+(void)updateDeviceMessage:(deviceMessage *)device{
    
  
    [_db   executeUpdateWithFormat:@"UPDATE t_deviceTbale  SET  DEVICE_ID= %ld, DEVICE_GATEGORY_ID =%ld, DEVICE_NAME = %@, DEVICE_STATE = %@,DEVICE_TYPE_ID = %ld, GATEWAY_NO = %@,PHONE_NUM =%@, SPACE_NO =%@, SPACE_TYPE_ID =%ld WHERE DEVICE_NO = %@ ;",(long)device.DEVICE_ID,(long)device.DEVICE_GATEGORY_ID,device.DEVICE_NAME,device.DEVICE_STATE,(long)device.DEVICE_TYPE_ID,device.GATEWAY_NO,device.PHONE_NUM,device.SPACE_NO,(long)device.SPACE_TYPE_ID,device.DEVICE_NO];
 
}

/**
 *  查询报警类传感器设备信息和空气传感器信息
 *
 *  @param NSArray 存取插座设备信息
 *
 *  @return 返回所有插座设备的信息
 */
+(NSArray *)queryWithSensorsDevices:(deviceMessage *)device{
    
    //得到结果集
    FMResultSets *set = [_db executeQueryWithFormat:@"SELECT * FROM t_deviceTbale  WHERE DEVICE_GATEGORY_ID = %d and DEVICE_TYPE_ID != %d and DEVICE_TYPE_ID != %d and GATEWAY_NO = %@ ",2,104,109,device.GATEWAY_NO];
    
    NSMutableArray * devices=[NSMutableArray array];
    
    // NSLog(@"%d",set.next);
    
    // 不断往下取数据
    while (set.next) {//进行查询前的准备工作
        
        deviceMessage *dev = [[deviceMessage  alloc]init];
        
        dev.DEVICE_GATEGORY_ID  = [set intForColumn:@"DEVICE_GATEGORY_ID"];
        
        dev.DEVICE_GATEGORY_NAME = [set stringForColumn:@"DEVICE_GATEGORY_NAME"];
        
        dev.DEVICE_NAME = [set stringForColumn:@"DEVICE_NAME"];
        
        dev.DEVICE_STATE = [set stringForColumn:@"DEVICE_STATE"];
        
        dev.DEVICE_NO = [set stringForColumn:@"DEVICE_NO"];
        
        dev.DEVICE_TYPE_ID = [set intForColumn:@"DEVICE_TYPE_ID"];
        
        dev.DEVICE_TYPE_NAME = [set stringForColumn:@"DEVICE_TYPE_NAME"];
        
        dev.GATEWAY_NO = [set stringForColumn:@"GATEWAY_NO"];
        
        dev.PHONE_NUM = [set stringForColumn:@"PHONE_NUM"];
        
        dev.SPACE_NO = [set stringForColumn:@"SPACE_NO"];
        
        dev.SPACE_TYPE_ID = [set intForColumn:@"SPACE_TYPE_ID"];
        
        [devices addObject:dev ];
        
        
    }
   
    return devices;
}

/**
 *  查询所有防区管理中 属于室内的设备（spacetypeid = 1）
 *
 *  @return 返回所有设备
 */

+(NSArray *)queryWithSecurityDevices:(deviceMessage *)device{
    
    //得到结果集
    FMResultSets *set = [_db executeQueryWithFormat:@"SELECT * FROM t_deviceTbale WHERE GATEWAY_NO = %@ and SPACE_TYPE_ID = %d ",device.GATEWAY_NO,1];
    
    NSMutableArray * devices=[NSMutableArray array];
    deviceMessage *dev;
    
    // 不断往下取数据
    while (set.next) {//进行查询前的准备工作
        
        dev = [[deviceMessage  alloc]init];
        
        dev.DEVICE_GATEGORY_ID  = [set intForColumn:@"DEVICE_GATEGORY_ID"];
        
        dev.DEVICE_GATEGORY_NAME = [set stringForColumn:@"DEVICE_GATEGORY_NAME"];
        
        dev.DEVICE_NAME = [set stringForColumn:@"DEVICE_NAME"];
        
        dev.DEVICE_STATE = [set stringForColumn:@"DEVICE_STATE"];
        
        dev.DEVICE_NO = [set stringForColumn:@"DEVICE_NO"];
        
        dev.DEVICE_TYPE_ID = [set intForColumn:@"DEVICE_TYPE_ID"];
        
        dev.DEVICE_TYPE_NAME = [set stringForColumn:@"DEVICE_TYPE_NAME"];
        
        dev.GATEWAY_NO = [set stringForColumn:@"GATEWAY_NO"];
        
        dev.PHONE_NUM = [set stringForColumn:@"PHONE_NUM"];
        
        dev.SPACE_NO = [set stringForColumn:@"SPACE_NO"];
        
        dev.SPACE_TYPE_ID = [set intForColumn:@"SPACE_TYPE_ID"];
        
        [devices addObject:dev ];
        
    }
    
      return devices;
    
    
    
}


/**
 *  查询所有防区管理中 属于室外的设备（spacetypeid = 2）
 *
 *  @return 返回所有设备
 */

+(NSArray *)queryWithOutdoorSecurityDevices:(deviceMessage *)device{
    
    //得到结果集
    FMResultSets *set = [_db executeQueryWithFormat:@"SELECT * FROM t_deviceTbale WHERE GATEWAY_NO = %@ and SPACE_TYPE_ID = %d ",device.GATEWAY_NO,2];
    
    NSMutableArray * devices=[NSMutableArray array];
    deviceMessage *dev;
    
    // 不断往下取数据
    while (set.next) {//进行查询前的准备工作
        
        dev = [[deviceMessage  alloc]init];
        
        dev.DEVICE_GATEGORY_ID  = [set intForColumn:@"DEVICE_GATEGORY_ID"];
        
        dev.DEVICE_GATEGORY_NAME = [set stringForColumn:@"DEVICE_GATEGORY_NAME"];
        
        dev.DEVICE_NAME = [set stringForColumn:@"DEVICE_NAME"];
        
        dev.DEVICE_STATE = [set stringForColumn:@"DEVICE_STATE"];
        
        dev.DEVICE_NO = [set stringForColumn:@"DEVICE_NO"];
        
        dev.DEVICE_TYPE_ID = [set intForColumn:@"DEVICE_TYPE_ID"];
        
        dev.DEVICE_TYPE_NAME = [set stringForColumn:@"DEVICE_TYPE_NAME"];
        
        dev.GATEWAY_NO = [set stringForColumn:@"GATEWAY_NO"];
        
        dev.PHONE_NUM = [set stringForColumn:@"PHONE_NUM"];
        
        dev.SPACE_NO = [set stringForColumn:@"SPACE_NO"];
        
        dev.SPACE_TYPE_ID = [set intForColumn:@"SPACE_TYPE_ID"];
        
        [devices addObject:dev ];
        
    }
    
    return devices;
    
    
    
}

+(void)updateDeviceMessageOnlyLocal:(deviceMessage *)device{
    
    [_db   executeUpdateWithFormat:@"UPDATE t_deviceTbale  SET  DEVICE_GATEGORY_ID =%ld,  DEVICE_STATE = %@,DEVICE_TYPE_ID = %ld, GATEWAY_NO = %@, SPACE_NO =%@ WHERE DEVICE_NO = %@ ;",(long)device.DEVICE_GATEGORY_ID,device.DEVICE_STATE,(long)device.DEVICE_TYPE_ID,device.GATEWAY_NO,device.SPACE_NO,device.DEVICE_NO];
    
}
@end
