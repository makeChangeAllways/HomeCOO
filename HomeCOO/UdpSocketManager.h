//
//  UdpSocketManager.h
//  HomeCOO
//
//  Created by 王立广 on 2016/11/9.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncUdpSocket.h"
@interface UdpSocketManager : NSObject

@property (nonatomic, strong)  GCDAsyncUdpSocket *udpSocket;


+ (instancetype)shareUdpSocketManager;


//发送信息
- (void)sendData:(NSData *)data host:(NSString *)host port:(uint16_t )port;

//开始接受信息
- (void)begingReceived:(u_int16_t)port;

//持续广播
- (void)runloopSendData:(NSData *)data host:(NSString *)host port:(uint16_t )port interval:(float)interval;


//停止持续广播
- (void)stopRunloopSendData;




@end
