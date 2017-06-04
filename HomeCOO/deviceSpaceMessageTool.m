//
//  deviceSpaceMessageTool.m
//  HomeCOO
//
//  Created by tgbus on 16/7/16.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "deviceSpaceMessageTool.h"
#import "deviceSpaceMessageModel.h"
#import "FMDB.h"

@implementation deviceSpaceMessageTool

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
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_deviceSpaceTbale ( DEVICE_NAME text, DEVICE_NO text, PHONENUM text , SPACE_NO text);"];
}

/**
 *  插入设备空间信息
 *
 *  @param deviceSpace
 */
+(void)addDeviceSpace:(deviceSpaceMessageModel *)deviceSpace{
    
    //插入新的空间信息
    [_db executeUpdateWithFormat:@"INSERT INTO t_deviceSpaceTbale (DEVICE_NAME, DEVICE_NO,PHONENUM,SPACE_NO) VALUES (%@,%@,%@,%@);", deviceSpace.device_name, deviceSpace.device_no,deviceSpace.phone_num,deviceSpace.space_no];//,deviceSpace.spaceType_Id
    
    
}

/**
 删除设备信息表
 */
+(void)deleteDeviceMessageTable{
    
    [_db executeUpdateWithFormat:@"DELETE FROM t_deviceSpaceTbale ;"];
    
}
/**
 *  更新设备空间信息，根据deviceno
 *
 *  @param deviceSpace
 */
+(void)updateDeviceSpaceMessage:(deviceSpaceMessageModel *)deviceSpace{

    
 [_db   executeUpdateWithFormat:@"UPDATE t_deviceSpaceTbale SET  DEVICE_NAME = %@ , SPACE_NO = %@  WHERE DEVICE_NO = %@ and PHONENUM = %@ ;",deviceSpace.device_name,deviceSpace.space_no,deviceSpace.device_no,deviceSpace.phone_num];//,deviceSpace.spaceType_Id

}

/**
 *  根据查找所有的设备空间配置信息
 *
 *  @param space
 *
 *  @return
 */
+(NSArray *)queryWithspacesDevice:(deviceSpaceMessageModel *)deviceSpace{
    
    //得到结果集
    FMResultSets *set = [_db executeQueryWithFormat:@"SELECT * FROM t_deviceSpaceTbale WHERE PHONENUM = %@ ",deviceSpace.phone_num];
    
    NSMutableArray * spaces=[NSMutableArray array];
    
    // 不断往下取数据
    while (set.next) {//进行查询前的准备工作
        
        deviceSpaceMessageModel *space = [[deviceSpaceMessageModel  alloc]init];
        
        space.device_name  = [set stringForColumn:@"DEVICE_NAME"];
        
        space.device_no = [set stringForColumn:@"DEVICE_NO"];
        
        space.phone_num = [set stringForColumn:@"PHONENUM"];
        
        space.space_no = [set  stringForColumn:@"SPACE_NO"];
        
        //space.spaceType_Id = [set  stringForColumn:@"SPACE_TYPE_ID"];
        
        [spaces addObject:space ];
        
    }
    
    return spaces;
}

/**
 *  查找DEVICE_NO所有的设备空间信息
 *
 *  @param space
 *
 *  @return
 */
+(NSArray *)queryWithspacesDeviceNoAndPhonenum:(deviceSpaceMessageModel *)space{
    
    //得到结果集
    FMResultSets *set = [_db executeQueryWithFormat:@"SELECT * FROM t_deviceSpaceTbale where DEVICE_NO = %@ and PHONENUM = %@ ",space.device_no,space.phone_num];
    
    NSMutableArray * spaces=[NSMutableArray array];
    
    // 不断往下取数据
    while (set.next) {//进行查询前的准备工作
        
        deviceSpaceMessageModel *space = [[deviceSpaceMessageModel  alloc]init];
        
        space.device_name  = [set stringForColumn:@"DEVICE_NAME"];
        
        space.device_no = [set stringForColumn:@"DEVICE_NO"];
        
        space.phone_num = [set stringForColumn:@"PHONENUM"];
        
        space.space_no = [set  stringForColumn:@"SPACE_NO"];
        
        //space.spaceType_Id = [set  stringForColumn:@"SPACE_TYPE_ID"];
        
        [spaces addObject:space ];
        
    }
    
    return spaces;
}
/**
 *  根据SPACE_NO 查找当前空间内所有设备
 *
 *  @param space
 *
 *  @return
 */
+(NSArray *)queryWithspacesDeviceNumbers:(deviceSpaceMessageModel *)space{
    
    //得到结果集
    FMResultSets *set = [_db executeQueryWithFormat:@"SELECT * FROM t_deviceSpaceTbale where SPACE_NO = %@  ",space.space_no];
    
    NSMutableArray * spaces=[NSMutableArray array];
    
    // 不断往下取数据
    while (set.next) {//进行查询前的准备工作
        
        deviceSpaceMessageModel *space = [[deviceSpaceMessageModel  alloc]init];
        
        space.device_name  = [set stringForColumn:@"DEVICE_NAME"];
        
        space.device_no = [set stringForColumn:@"DEVICE_NO"];
        
        space.phone_num = [set stringForColumn:@"PHONENUM"];
        
        space.space_no = [set  stringForColumn:@"SPACE_NO"];
        
       //space.spaceType_Id = [set  stringForColumn:@"SPACE_TYPE_ID"];
        
        [spaces addObject:space ];
        
    }
    
    return spaces;
}

/**
 *  根据spaceno + phonenum 删除spaceno  （在删除空间的时候 将对应的用户配置表中该空间也删除掉）
 *
 *  @param deviceSpace
 */
+(void)deleteDeviceSpace:(deviceSpaceMessageModel *)deviceSpace{

    [_db  executeUpdateWithFormat:@"DELETE FROM t_deviceSpaceTbale where SPACE_NO=%@ and PHONENUM = %@ ;",deviceSpace.space_no,deviceSpace.phone_num];
    
}

/**
 *  用户在产品管理中删除该设备时，应该根据该设备的deviceno 和 当前用户的手机号 到devicespace表中将该设备的空间信息删除掉
 */

+(void)deleteDeviceSpaceWithDeviceno_phonenum:(deviceSpaceMessageModel *)deviceSpace{

    [_db  executeUpdateWithFormat:@"DELETE FROM t_deviceSpaceTbale where DEVICE_NO=%@ and PHONENUM = %@ ;",deviceSpace.device_no,deviceSpace.phone_num];
    

}
@end
