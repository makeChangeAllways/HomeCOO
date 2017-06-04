//
//  scanerSocketManger.h
//  HomeCOO
//
//  Created by app on 2016/12/15.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ReceiveInfoBlock)(NSString *receiveInfo);

@interface scanerSocketManger : NSObject

/**
 *  socket 连接状态
 */
typedef NS_ENUM(NSInteger, SSGACSocketConnectStatus) {
    SSGACSocketConnectStatusDisconnected = -1,  // 未连接
    
};

@property (nonatomic,copy) ReceiveInfoBlock receiveInfoBlock;


// 连接状态
@property (nonatomic, assign) SSGACSocketConnectStatus connectStatus;

@property NSInteger socketStatus;

@property NSInteger gatewayIP;

@property NSInteger socketConnectNum;

+ (instancetype)shareSocketManager;


//连接网关
- (void)startConnectHost:(NSString *)host WithPort:(uint16_t)port;

//发送信息
- (void)sendMsg:(NSString *)message;

//接收消息
-(void)receiveMsg:(ReceiveInfoBlock)receiveInfoBlock;

//断开socket
-(void)closeSocket;
-(NSInteger)sockeConnectStatus;
-(NSInteger)CorrectGatewayIP;


@end
