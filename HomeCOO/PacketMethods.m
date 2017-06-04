//
//  PacketMethods.m
//  HomeCOO
//
//  Created by tgbus on 16/5/19.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "PacketMethods.h"

@implementation PacketMethods


/**
 *  /
 *
 *  @param head      报头
 *  @param stamp     时间戳
 *  @param gw_id     网关id
 *  @param dev_id    设备id
 *  @param dev_type  设备类型
 *  @param data_type 数据类型
 *  @param data_len  数据长度
 *  @param data      数据体
 *
 *  @return 报文packet
 */
+(NSString *)devicePacket:(NSString *)head getStamp:(NSString *)stamp getGw_id:(NSString *)gw_id getDev_id:(NSString *)dev_id getDev_type:(NSString * )dev_type getData_type:(NSString *)data_type getData_len:(NSString *)data_len getData:(NSString *)data{

    
    NSString *Head = head;
    NSString *Stamp = stamp;
    NSString *GW_id = gw_id;
    NSString *Dev_id = dev_id;
    NSString *Dev_type = dev_type;
    NSString *Data_type = data_type;
    NSString *Data_len = data_len;
    NSString *Data = data;
    
    NSString *packets = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@ %@ %@",Head,Stamp,GW_id,Dev_id,Dev_type,Data_type,Data_len,Data];

    
//    PacketMethods *packets = [[self  alloc]init];
//    
//    packets.Head = head;
//    packets.Stamp = stamp;
//    packets.GW_id = gw_id;
//    packets.Dev_id = dev_id;
//    packets.Dev_type = dev_type;
//    packets.Data_type = data_type;
//    packets.Data_len = data_len;
//    packets.Data = data;

    return packets;
    


}





@end
