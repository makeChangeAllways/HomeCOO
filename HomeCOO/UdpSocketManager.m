//
//  UdpSocketManager.m
//  HomeCOO
//
//  Created by 王立广 on 2016/11/9.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "UdpSocketManager.h"

#define kUDP_PORT 8004

@interface UdpSocketManager ()<GCDAsyncUdpSocketDelegate>

{
    NSTimer *timer;
}

@end

static UdpSocketManager *udpSocketManager = nil;

@implementation UdpSocketManager



- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
        self.udpSocket = [[GCDAsyncUdpSocket alloc]init];
        
        
        //支持IPv4的连接
        //        [self.udpSocket setIPv4Enabled:YES];
        //不支持IPv6的连接，如果两种都支持每次发送一次信息，接受信息的代理方法会执行两次
        [self.udpSocket setIPv6Enabled:NO];
        
        self.udpSocket.delegateQueue = dispatch_get_main_queue();
        
        
        //挂代理之前千万要使用enableBroadcast开启广播
        //        NSError *error;
        //        if([udpManager.udpSocket enableBroadcast:YES error:&error]){
        //            NSLog(@"udpSocket = %@",error);
        //        }
        
        
    }
    return self;
}


+ (instancetype)shareUdpSocketManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        udpSocketManager = [[UdpSocketManager alloc]init];
        
    });
    
    return udpSocketManager;
}


//连接发送信息
- (void)sendData:(NSData *)data host:(NSString *)host port:(uint16_t )port{
    
    [self.udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:0];
    
}

//开始接收
- (void)begingReceived:(u_int16_t)port {
    
    NSError *error = nil;
    
    if(![self.udpSocket bindToPort :port error:&error])
    {
        NSLog(@"error in bindToPort");
    }
    //只接受一次
    //    [self.udpSocket receiveOnce:nil];
    
    //可接受多次
    [self.udpSocket beginReceiving:&error];
    
    
}

- (void)runloopSendData:(NSData *)data host:(NSString *)host port:(uint16_t )port interval:(float)interval{
    
    timer = [NSTimer scheduledTimerWithTimeInterval:interval repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        [self.udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:0];
        
    }];
    
}

- (void)stopRunloopSendData{
    [self.udpSocket close];
    [timer invalidate];
    timer = nil;
}



#pragma mark *************updSccket代理方法*************


///**
//   连接成功或被唤醒时调用
// **/
//- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address;
//
///**
//   连接失败时调用
// **/
//- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error;
//
/**
 *  数据发送成功
 **/
//- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag;

/**
 没有发送成功
 **/
//- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error;
///**
// * 收到信息时调用
// **/
//- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext;
///**
// * 链接关闭时调用
// **/
//- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error;



@end
