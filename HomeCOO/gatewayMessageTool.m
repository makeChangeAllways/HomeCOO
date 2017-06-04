//
//  gatewayMessageTool.m
//  HomeCOO
//
//  Created by tgbus on 16/6/18.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "gatewayMessageTool.h"
#import "gatewayMessageModel.h"
#import "FMDB.h"
@implementation gatewayMessageTool

static FMDatabasess *_db;

//首先需要有数据库
+(void)initialize
{
    // 1.打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"HomeCOO_IOS.sqlite"];
    _db = [FMDatabasess databaseWithPath:path];
    [_db open];
    
    // 2.创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_gatewayTbale ( gatewayID text  NOT NULL , gatewayIP text, gatewayPwd text);"];
}


/**
 *  添加一个新网关
 *
 *  @param gateway 网关
 */
+(void)addGateway:(gatewayMessageModel *)gateway{
    
 [_db executeUpdateWithFormat:@"INSERT INTO t_gatewayTbale(gatewayID, gatewayIP,gatewayPwd) VALUES (%@, %@,%@);", gateway.gatewayID, gateway.gatewyIP,gateway.gatewayPWD];


}
/**
 *  查找网关
 *
 *  @param NSArray 存取网关
 *
 *  @return 返回所有网关设备
 */
+(NSArray *)queryWithgateways{
    //得到结果集
    FMResultSets *set = [_db executeQuery:@"SELECT * FROM t_gatewayTbale  "];
    
    NSMutableArray * gatewayDevices=[NSMutableArray array];
    
    // 不断往下取数据
    while (set.next) {//进行查询前的准备工作
        
        gatewayMessageModel *gateway = [[gatewayMessageModel  alloc]init];
        
        gateway.gatewayID  = [set stringForColumn:@"gatewayID"];
        
        gateway.gatewayPWD = [set stringForColumn:@"gatewayPwd"];
        
        gateway.gatewyIP = [set stringForColumn:@"gatewayIP"];
        
       
        [gatewayDevices addObject:gateway ];
        
    }
    
   
    return gatewayDevices;
   
}


/**
 *  查找网关
 *
 *  @param NSArray 存取网关
 *
 *  @return 返回所有网关设备
 */
+(NSArray *)queryWithgatewaysBygatewayNo:(gatewayMessageModel *)gateway{
    
    //得到结果集
    FMResultSets *set = [_db executeQueryWithFormat:@"SELECT * FROM t_gatewayTbale where  gatewayID = %@",gateway.gatewayID];
    
    NSMutableArray * gatewayDevices=[NSMutableArray array];
    
    // 不断往下取数据
    while (set.next) {//进行查询前的准备工作
        
        gatewayMessageModel *gateway = [[gatewayMessageModel  alloc]init];
        
        gateway.gatewayID  = [set stringForColumn:@"gatewayID"];
        
        gateway.gatewayPWD = [set stringForColumn:@"gatewayPwd"];
        
        gateway.gatewyIP = [set stringForColumn:@"gatewayIP"];
        
        
        [gatewayDevices addObject:gateway ];
        
    }
    
    return gatewayDevices;
}

/**
 *  删除网关
 */
+(void)delete:(gatewayMessageModel *)gateway{
 
    [_db executeUpdateWithFormat:@"DELETE FROM t_gatewayTbale where gatewayID=%@ ;",gateway.gatewayID];
    
}


/**
 删除网关表
 */
+(void)deleteGatewayTable{
    
    [_db executeUpdateWithFormat:@"DELETE FROM t_gatewayTbale ;"];
    
}

/**
 *  更新网关ip
 *
 *  @param gateway 网关
 */
+(void)updateGatewayIP:(gatewayMessageModel *)gateway{
    
    
    [_db   executeUpdateWithFormat:@"UPDATE t_gatewayTbale SET gatewayIP = %@ WHERE gatewayID = %@ ;",gateway.gatewyIP,gateway.gatewayID];
    
    
}

/**
 *  根据网关的id 更新网关的ip 和pwd
 *
 *  @param gateway
 */
+(void)updateGatewayMessage:(gatewayMessageModel *)gateway{


    [_db  executeUpdateWithFormat:@"UPDATE t_gatewayTbale SET gatewayIP = %@ , gatewayPwd = %@ WHERE gatewayID = %@;",gateway.gatewyIP,gateway.gatewayPWD,gateway.gatewyIP];

    
}



/**
 *  更改网关密码
 *
 *  @param gateway 网关
 */
+(void)updateGatewayPWD:(gatewayMessageModel *)gateway{
    
    [_db   executeUpdateWithFormat:@"UPDATE t_gatewayTbale SET  gatewayPwd = %@ WHERE gatewayID = %@ ;",gateway.gatewayPWD,gateway.gatewayID];
    
    
}


@end
