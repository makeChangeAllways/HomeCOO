//
//  themeDeviceMessageTool.m
//  HomeCOO
//
//  Created by tgbus on 16/7/8.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "themeDeviceMessageTool.h"
#import "themeDeviceMessage.h"
#import "FMDB.h"
@implementation themeDeviceMessageTool

static FMDatabasess *_db;

//首先需要有数据库
+(void)initialize
{
    // 1.打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"HomeCOO_IOS.sqlite"];
    _db = [FMDatabasess databaseWithPath:path];
    [_db open];
    
    // 2.建立themeDevice表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_themeDeviceTbale ( DEVICE_NO text ,DEVICE_STATE_CMD text  , GATEWAY_NO text, INFRA_TYPE_ID integer ,THEME_DEVICE_NO text  ,THEME_NO text,THEME_STATE  text ,THEME_TYPE integer);"];
    
}

/**
 *  往情景设备表中插入设备；
 *
 *  @param themeDevice
 */

+(void)addThemeDevice:(themeDeviceMessage *)themeDevice{
    
    //插入数据
    [_db executeUpdateWithFormat:@"INSERT INTO t_themeDeviceTbale(DEVICE_NO, DEVICE_STATE_CMD,GATEWAY_NO,INFRA_TYPE_ID,THEME_DEVICE_NO,THEME_NO,THEME_STATE,THEME_TYPE) VALUES (%@,%@,%@,%ld,%@,%@,%@,%ld);",themeDevice.device_No, themeDevice.device_state_cmd,themeDevice.gateway_No,(long)themeDevice.infra_type_ID,themeDevice.theme_device_No,themeDevice.theme_no,themeDevice.theme_state,(long)themeDevice.theme_type];
}

/**
 删除情景配置表
 */
+(void)deleteThemeDeviceTable{
    
    [_db executeUpdateWithFormat:@"DELETE FROM t_themeDeviceTbale ;"];
    
}
/**
 *  更新设备状态信息
 *
 *  @param device 更新的设备
 */
+(void)updateThemeDeviceState:(themeDeviceMessage *)themeDevice{
    
    
    [_db   executeUpdateWithFormat:@"UPDATE t_themeDeviceTbale SET  DEVICE_STATE_CMD = %@ WHERE DEVICE_NO = %@ and THEME_NO = %@;",themeDevice.device_state_cmd,themeDevice.device_No,themeDevice.theme_no];
    
    
}


/**
 *  查询情景表中的设备
 *
 *  @return 返回所有设备
 */

+(NSArray *)queryWithThemeDevices{
    
    //得到结果集
    FMResultSets *set = [_db executeQuery:@"SELECT * FROM t_themeDeviceTbale "];
    
   
    NSMutableArray * ThemeDevices=[NSMutableArray array];
    
    // NSLog(@"%d",set.next);
    
    // 不断往下取数据
    while (set.next) {//进行查询前的准备工作
        
        themeDeviceMessage *themeDevice = [[themeDeviceMessage  alloc]init];
        
        themeDevice.device_No  = [set stringForColumn:@"DEVICE_NO"];
        
        themeDevice.device_state_cmd = [set stringForColumn:@"DEVICE_STATE_CMD"];
        
        themeDevice.gateway_No = [set stringForColumn:@"GATEWAY_NO"];
        
        themeDevice.infra_type_ID = [set intForColumn:@"INFRA_TYPE_ID"];
        
        themeDevice.theme_device_No = [set stringForColumn:@"THEME_DEVICE_NO"];
        
        themeDevice.theme_no = [set stringForColumn:@"THEME_NO"];
        
        themeDevice.theme_state = [set stringForColumn:@"THEME_STATE"];
        
        themeDevice.theme_type = [set intForColumn:@"THEME_TYPE"];
        
        
        [ThemeDevices addObject:themeDevice ];
        
    }
    
    return ThemeDevices;
    
}

/**
 *  根据设备id 情景id查找是否在情景表中 存在此设备
 *
 *  @return 返回所有设备
 */

+(NSArray *)queryWithThemeDevices:(themeDeviceMessage *)themeDevice{
    
   
    FMResultSets *set = [_db executeQueryWithFormat:@"SELECT * FROM t_themeDeviceTbale  WHERE DEVICE_NO= %@ and THEME_NO =%@ ",themeDevice.device_No,themeDevice.theme_no];
    
    NSMutableArray * ThemeDevices=[NSMutableArray array];

    // 不断往下取数据
    while (set.next) {//进行查询前的准备工作
        
        themeDeviceMessage *themeDevice = [[themeDeviceMessage  alloc]init];
        
        themeDevice.device_No  = [set stringForColumn:@"DEVICE_NO"];
        
        themeDevice.device_state_cmd = [set stringForColumn:@"DEVICE_STATE_CMD"];
        
        themeDevice.gateway_No = [set stringForColumn:@"GATEWAY_NO"];
        
        themeDevice.infra_type_ID = [set intForColumn:@"INFRA_TYPE_ID"];
        
        themeDevice.theme_device_No = [set stringForColumn:@"THEME_DEVICE_NO"];
        
        themeDevice.theme_no = [set stringForColumn:@"THEME_NO"];
        
        themeDevice.theme_state = [set stringForColumn:@"THEME_STATE"];
        
        themeDevice.theme_type = [set intForColumn:@"THEME_TYPE"];
        
        
        [ThemeDevices addObject:themeDevice ];
        
    }
    
    return ThemeDevices;
    
}


/**
 *  根据情景id  在情景表中 查找此情景 下关联的设备
 *
 *  @param themeDevice
 *
 *  @return
 */

+(NSArray *)queryWithThemeNoDevices:(themeDeviceMessage *)themeDevice{
    
    FMResultSets *set = [_db executeQueryWithFormat:@"SELECT * FROM t_themeDeviceTbale  WHERE THEME_NO =%@ ",themeDevice.theme_no];
    
    
    NSMutableArray * ThemeDevices=[NSMutableArray array];
    

    // 不断往下取数据
    while (set.next) {//进行查询前的准备工作
        
        themeDeviceMessage *themeDevice = [[themeDeviceMessage  alloc]init];
        
        themeDevice.device_No  = [set stringForColumn:@"DEVICE_NO"];
        
        themeDevice.device_state_cmd = [set stringForColumn:@"DEVICE_STATE_CMD"];
        
        themeDevice.gateway_No = [set stringForColumn:@"GATEWAY_NO"];
        
        themeDevice.infra_type_ID = [set intForColumn:@"INFRA_TYPE_ID"];
        
        themeDevice.theme_device_No = [set stringForColumn:@"THEME_DEVICE_NO"];
        
        themeDevice.theme_no = [set stringForColumn:@"THEME_NO"];
        
        themeDevice.theme_state = [set stringForColumn:@"THEME_STATE"];
        
        themeDevice.theme_type = [set intForColumn:@"THEME_TYPE"];
        
        
        [ThemeDevices addObject:themeDevice ];
        
    }
    
    return ThemeDevices;
    
}
/**
 *  删除情景
 */
+(void)delete:(themeDeviceMessage *)theme{
    
    [_db executeUpdateWithFormat:@"DELETE FROM t_themeDeviceTbale where THEME_NO=%@ ;",theme.theme_no];
    
}


/**
 *  根据情节id和设备id删除此情景下的设备
 *
 *  @param theme
 */
+(void)deleteThemeDevice:(themeDeviceMessage *)theme{
    
    [_db executeUpdateWithFormat:@"DELETE FROM t_themeDeviceTbale where THEME_NO=%@ and DEVICE_NO=%@ ;",theme.theme_no,theme.device_No];
    
}







//单独为红外遥控准备的方法
+(NSArray *)queryWithThemeDevicesOnlyForInfra:(themeDeviceMessage *)themeDevice{
    
    
    FMResultSets *set = [_db executeQueryWithFormat:@"SELECT * FROM t_themeDeviceTbale  WHERE DEVICE_NO= %@ and THEME_NO =%@ and INFRA_TYPE_ID = %ld ",themeDevice.device_No,themeDevice.theme_no,(long)themeDevice.infra_type_ID];
    
    NSMutableArray * ThemeDevices=[NSMutableArray array];
    
    while (set.next) {
        
        themeDeviceMessage *themeDevice = [[themeDeviceMessage  alloc]init];
        
        themeDevice.device_No  = [set stringForColumn:@"DEVICE_NO"];
        
        themeDevice.device_state_cmd = [set stringForColumn:@"DEVICE_STATE_CMD"];
        
        themeDevice.gateway_No = [set stringForColumn:@"GATEWAY_NO"];
        
        themeDevice.infra_type_ID = [set intForColumn:@"INFRA_TYPE_ID"];
        
        themeDevice.theme_device_No = [set stringForColumn:@"THEME_DEVICE_NO"];
        
        themeDevice.theme_no = [set stringForColumn:@"THEME_NO"];
        
        themeDevice.theme_state = [set stringForColumn:@"THEME_STATE"];
        
        themeDevice.theme_type = [set intForColumn:@"THEME_TYPE"];
        
        
        [ThemeDevices addObject:themeDevice ];
        
    }
    
    return ThemeDevices;
    
}
+(void)updateThemeDeviceStateOnlyForInfra:(themeDeviceMessage *)themeDevice{
    
    
    [_db   executeUpdateWithFormat:@"UPDATE t_themeDeviceTbale SET  DEVICE_STATE_CMD = %@ WHERE DEVICE_NO = %@ and THEME_NO = %@ and INFRA_TYPE_ID = %ld;",themeDevice.device_state_cmd,themeDevice.device_No,themeDevice.theme_no,(long)themeDevice.infra_type_ID];

}

+(void)deleteThemeDeviceOnlyForInfra:(themeDeviceMessage *)theme{
    
    [_db executeUpdateWithFormat:@"DELETE FROM t_themeDeviceTbale where THEME_NO=%@ and DEVICE_NO=%@ and INFRA_TYPE_ID = %ld;",theme.theme_no,theme.device_No,(long)theme.infra_type_ID];
    
}

@end
