//
//  queryDeviceControlMethods.m
//  HomeCOO
//
//  Created by tgbus on 16/7/26.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "queryDeviceControlMethods.h"
#import "LZXDataCenter.h"
#import "versionMessageModel.h"
#import "versionMessageTool.h"
#import "MBProgressHUD+MJ.h"
#import "deviceSpaceMessageModel.h"
#import "deviceSpaceMessageTool.h"
#import "deviceMessage.h"
#import "deviceMessageTool.h"
#import "ControlMethods.h"
#import "gatewayMessageModel.h"
#import "gatewayMessageTool.h"

@implementation queryDeviceControlMethods

/**
 *  将version表中设备更新信息封装成一个数组 发送给服务器
 *
 *  @return
 */
+(NSString *)allDeviceVersionList:(NSString *)versionType{
    
    LZXDataCenter *dataCenter = [LZXDataCenter defaultDataCenter];
    
    versionMessageModel *deviceVersion = [[versionMessageModel  alloc]init];
    
    deviceVersion.phoneNum = dataCenter.userPhoneNum;
    deviceVersion.gatewayNum = dataCenter.gatewayNo;//要先添加网关
    deviceVersion.versionType = versionType;
    
    NSArray  *deviceVersionArray = [versionMessageTool  queryWithVersions:deviceVersion];
    NSString *deviceVersionJson = @"";
    
    if (deviceVersionArray.count == 0) {
        
        [MBProgressHUD  showError:@"没有设备设备更新信息"];
        
    }else{
        
        versionMessageModel *version = deviceVersionArray[0];
            
        NSDictionary  *dict = @{@"phoneNum":version.phoneNum,
                                @"gatewayNo":version.gatewayNum,
                                @"versionType":version.versionType,
                                @"versionCode":@"",
                                @"versionDescription":@"",
                                @"updateTime":version.updateTime
                                };
        //将字典转换成json串
        NSData  *jsonData = [NSJSONSerialization  dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
            
        deviceVersionJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
 
    }
    
    return deviceVersionJson;
    
}

/**
 *  将deviceSpace(用户配置表)表中该用户下所有设备的配置信息封装成一个数组 发送给服务器
 *
 *  @return
 */
+(NSArray *)allUserDeviceSpaceList{
    
    LZXDataCenter *dataCenter = [LZXDataCenter defaultDataCenter];
    
    deviceSpaceMessageModel *deviceSpace = [[deviceSpaceMessageModel  alloc]init];
    
    deviceSpace.phone_num = dataCenter.userPhoneNum;
    
    NSArray  *devicesSpaceArray = [deviceSpaceMessageTool  queryWithspacesDevice:deviceSpace];
    
    NSMutableArray  *deviceSpaceArray =[[NSMutableArray  alloc]init];
    
    NSString *deviceSpaceJson = @"";
    
    if (devicesSpaceArray.count == 0) {
        
        [MBProgressHUD  showError:@"没有设备空间"];
        
    }else{
        
        for (int i = 0; i<devicesSpaceArray.count; i++) {
            
            deviceSpaceMessageModel *deviceSpace = devicesSpaceArray[i];
            
            NSDictionary  *dict = @{@"deviceName":deviceSpace.device_name,
                                    @"spaceNo":deviceSpace.space_no,
                                    @"deviceNo":deviceSpace.device_no,
                                    @"phoneNum":deviceSpace.phone_num
                                    };
            //将字典转换成json串
            NSData  *jsonData = [NSJSONSerialization  dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
            
            deviceSpaceJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            deviceSpaceArray[i] = deviceSpaceJson;
            
        }
        
    }
    
    return deviceSpaceArray;
    
}


/**
 *  将device表中所有设备封装成一个数组 发送给服务器
 *
 *  @return
 */

+(NSArray *)allDeviceList{
    
    NSArray  *devicesArray;// = [deviceMessageTool  queryWithDevices];
    
    LZXDataCenter *gateway = [LZXDataCenter defaultDataCenter];
    
    deviceMessage *device = [[deviceMessage alloc]init];
    
    device.GATEWAY_NO = gateway.gatewayNo;//当前网关下的 所有设备
    
    devicesArray=[deviceMessageTool queryWithDevices:device];
        
    
    NSMutableArray  *deviceArray =[[NSMutableArray  alloc]init];
    NSString *deviceJson = @"";
    
    if (devicesArray.count == 0) {
        
        [MBProgressHUD  showError:@"没有设备"];
        
    }else{
        
        for (int i = 0; i<devicesArray.count; i++) {
            
            deviceMessage *device = devicesArray[i];
            
            
            NSDictionary  *dict = @{@"spaceTypeId":[NSString stringWithFormat:@"%ld",(long)device.SPACE_TYPE_ID],
                                    @"deviceId":[NSString stringWithFormat:@"%ld",(long)device.DEVICE_ID],
                                    @"deviceCategoryId":[NSString stringWithFormat:@"%ld",(long)device.DEVICE_GATEGORY_ID],
                                    @"deviceName":device.DEVICE_NAME,
                                    @"deviceNo":device.DEVICE_NO,
                                    @"deviceStateCmd":@"",
                                    @"deviceTypeId":[NSString stringWithFormat:@"%ld",(long)device.DEVICE_TYPE_ID],
                                    @"gatewayNo":device.GATEWAY_NO,
                                    @"phoneNum":@"",
                                    @"spaceNo":device.SPACE_NO
                                    };
            //将字典转换成json串
            NSData  *jsonData = [NSJSONSerialization  dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil  ];
            
            deviceJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            deviceArray[i] = deviceJson;
            
        }
        
        
    }
    
    return deviceArray;
    
    
}

/**
 *  将gateway 表中所有网关信息封装成一个数组 发送给服务器
 *
 *  @return
 */
+(NSArray *)allUserGatewayList{
    
  
    NSArray  *gatewayArray = [gatewayMessageTool  queryWithgateways];
    
    NSMutableArray  *userGatewayArray =[[NSMutableArray  alloc]init];
    
    NSString *userGateway = @"";
    
    if (gatewayArray.count == 0) {
        
        [MBProgressHUD  showError:@"没有网关"];
        
    }else{
        
        for (int i = 0; i<gatewayArray.count; i++) {
            
            gatewayMessageModel *gatewayModel = gatewayArray[i];
            
            NSDictionary  *dict = @{@"gatewayNo":gatewayModel.gatewayID,
                                    @"gatewayIp":gatewayModel.gatewyIP,
                                    @"gatewayPwd":gatewayModel.gatewayPWD
                                    };
            //将字典转换成json串
            NSData  *jsonData = [NSJSONSerialization  dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
            
            userGateway = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

            userGatewayArray[i] = userGateway;
            
        }
        
    }
    
    return userGatewayArray;
    
}



@end
