//
//  GGSocketManager.h
//  Socket客户端
//
//  Created by 王立广 on 16/9/6.
//  Copyright © 2016年 GG. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCDAsyncSocket.h"
typedef void(^kReceiveInfoBlock)(NSDictionary *receiveInfo);

@interface GGSocketManager : NSObject

/**
 *  socket 连接状态
 */
typedef NS_ENUM(NSInteger, kGACSocketConnectStatus) {
    kGACSocketConnectStatusDisconnected = -1,  // 未连接
    
};

@property (nonatomic,copy) kReceiveInfoBlock receiveInfoBlock;

@property (nonatomic,strong) GCDAsyncSocket *socket;

@property (nonatomic,copy) NSString *host;
@property (nonatomic,assign) uint16_t port;




// 连接状态
@property (nonatomic, assign) kGACSocketConnectStatus connectStatus;

@property NSInteger socketStatus;
@property NSInteger gatewayIP;
@property NSInteger socketConnectNum;
+ (instancetype)shareGGSocketManager;


//连接网关
- (void)startConnectHost:(NSString *)host WithPort:(uint16_t)port;

//发送信息
- (void)sendMsg:(NSString *)message;

//接收消息
-(void)receiveMsg:(kReceiveInfoBlock)receiveInfoBlock;

//断开socket
-(void)closeSocket;
-(NSInteger)sockeConnectStatus;
-(NSInteger)CorrectGatewayIP;


-(NSString *)NSdataToString:(NSData*)data;

@end


