//
//  themeInfraModel.h
//  HomeCOO
//
//  Created by app on 2016/10/19.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface themeInfraModel : NSObject

//红外转发器设备id
@property(nonatomic,strong)  NSString *deviceNo;
//红外码
@property(nonatomic,strong)  NSString *deviceState_Cmd;
//网关编号
@property(nonatomic,strong)  NSString *gatewayNo;
//控制设备名称：devName+INFRA_MODE（例如：空调+制冷26）
@property(nonatomic,strong)  NSString *infraControlName;
/**
 * 0:投影仪
 * 1:电扇"
 * 2:机顶盒"
 * 3:电视"
 * 4:网络机顶盒
 * 5:DVD"
 * 6:空调"
 * 7:热水器"
 * 8:空气净化器"
 * 9:相机"
 **/
@property   NSInteger infraType_ID;
//情景编号
@property(nonatomic,strong)  NSString *themeNo;

@end
