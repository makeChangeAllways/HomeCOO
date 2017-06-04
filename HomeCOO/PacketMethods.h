//
//  PacketMethods.h
//  HomeCOO
//
//  Created by tgbus on 16/5/19.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PacketMethods : NSObject

/**报头*/
@property(nonatomic,copy)  NSString *Head;

/**时间戳*/
@property(nonatomic,copy)  NSString *Stamp;

/**网关id*/
@property(nonatomic,copy)  NSString *GW_id;

/**设备id*/
@property(nonatomic,copy)  NSString *Dev_id;

/**设备类型*/
@property  NSInteger Dev_type;

/**数据类型*/
@property(nonatomic,copy)  NSString *Data_type;

/**数据长度*/
@property(nonatomic,copy)  NSString *Data_len;

/**数据体*/
@property(nonatomic,copy)  NSString *Data;


+(NSString * )devicePacket:(NSString *)head getStamp:(NSString*)stamp getGw_id:(NSString *)gw_id getDev_id:(NSString *)dev_id  getDev_type:(NSString * )dev_type getData_type:(NSString *)data_type getData_len:(NSString *)data_len getData:(NSString *)data;

@end
