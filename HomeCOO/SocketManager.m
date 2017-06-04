//
//  SocketManager.m
//  Socket客户端
//
//  Created by 王立广 on 16/9/6.
//  Copyright © 2016年 GG. All rights reserved.
//

#import "SocketManager.h"
#import "GCDAsyncSocket.h"
#import "PrefixHeader.pch"
#import "MBProgressHUD+MJ.h"
#import "LZXDataCenter.h"
static SocketManager *socketManager = nil;

@interface SocketManager ()<GCDAsyncSocketDelegate>
{
    NSString *_host;
    uint16_t _port;
    
}

@property (nonatomic,strong) GCDAsyncSocket *socket;

@property  BOOL statues;

@end

@implementation SocketManager


- (instancetype)init
{
    self = [super init];
    if (self) {
        
       self.socket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
      
        
    }
    return self;
}


+ (instancetype)shareSocketManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        socketManager = [[SocketManager alloc]init];
        
    });
    

       
    return socketManager;
}

/**
 *  连接网关
 *
 *  @param host
 *  @param port 
 */
- (void)startConnectHost:(NSString *)host WithPort:(uint16_t)port
{
    _host = host;
    _port = port;
    self.socketStatus = 1;
    self.socketConnectNum = 0;
    [socketManager.socket connectToHost:host onPort:port error:nil];

}

/**
 *  向网关发送消息
 *
 *  @param message
 */
- (void)sendMsg:(NSString *)message{
    
    NSData *data = [self  hexToBytes:message];

    [socketManager.socket writeData:data withTimeout:-1 tag:0];
    
}


/**
 *  接收来自网关反馈的消息
 *
 *  @param receiveInfoBlock 
 */
-(void)receiveMsg:(ReceiveInfoBlock)receiveInfoBlock{
    
    self.receiveInfoBlock = receiveInfoBlock;
}

/**
 *  断开连接
 */
-(void)closeSocket{
    
    self.connectStatus =  GACSocketConnectStatusDisconnected;
    
    [socketManager.socket disconnect];
    
}

/**
 *  字节转换成string类型的字节
 *
 *  @param str
 *
 *  @return
 */
-(NSData*) hexToBytes:(NSString *)str {
    
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= str.length; idx+=2) {
        
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [str  substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
        
    }
    
    return data;
    
}

-(NSInteger)sockeConnectStatus{

    NSInteger  ststatus = self.socketStatus;
    
    return ststatus;

}

-(NSInteger)CorrectGatewayIP{

    NSInteger  ststatus = self.gatewayIP;
    
    return ststatus;
}

#pragma mark GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    
    //连接到服务端时同样要设置监听，否则收不到服务器发来的消息
    [sock readDataWithTimeout:-1 tag:0];
    self.gatewayIP = 1;
    [LZXDataCenter defaultDataCenter].loginStateFlag=2;
    NSLog(@"socket连接成功");
    
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
   
   
//    if (self.connectStatus == GACSocketConnectStatusDisconnected) {//主动断开
//       
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//           // [MBProgressHUD  showError:@"远程连接成功！！！"];
//            
//        });
//        NSLog(@"用户主动断开连接");
//        
//    }else{//网关掉线
        //断开连接以后再自动重连
        if (self.socketConnectNum < 1) {
            
            if ( [LZXDataCenter defaultDataCenter].loginStateFlag==1) {
            }else{
            
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [MBProgressHUD  showError:@"本地连接失败！！！"];
                
            });}
            
            [sock connectToHost:_host onPort:_port error:nil];
            
        }
    
    [LZXDataCenter defaultDataCenter].loginStateFlag=2;
    self.socketConnectNum ++;
    self.socketStatus = 0;
    NSLog(@"与网关断开连接");
    
   // }
    
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{

    //当接受到服务器发来的消息时，同样设置监听，否则只会收到一次
    [sock readDataWithTimeout:-1 tag:0];
    NSString *readDataStr = [self  NSdataToString:data];
    
    if([[readDataStr  substringFromIndex:readDataStr.length -2] isEqualToString:@"ff"]){//网关认证未通过
    
       self.socketStatus = 0;

    }
    
    self.receiveInfoBlock(readDataStr);
    
}
#pragma mark 编解码
-(NSString *)NSdataToString:(NSData*)data{
    
        NSString *str = @"";
        NSUInteger len = [data length];
        Byte *byteData = (Byte*)malloc(len);
        memcpy(byteData, [data bytes], len);
        for (int i = 0; i<len; i++) {
            NSString *test=   [self  ToHex:byteData[i]];
            str  =[NSString stringWithFormat:@"%@%@",str,test];
        }
        
        return  str;
    }

-(NSString *)ToHex:(uint16_t)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    uint16_t ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"a";break;
            case 11:
                nLetterValue =@"b";break;
            case 12:
                nLetterValue =@"c";break;
            case 13:
                nLetterValue =@"d";break;
            case 14:
                nLetterValue =@"e";break;
            case 15:
                nLetterValue =@"f";break;
            default:
                nLetterValue = [NSString stringWithFormat:@"%u",ttmpig];

        }

        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {

            break;
        }

    }

    if ([str length] == 2) {
        return str;
    }else{

        NSString *string = [@"0" stringByAppendingString: str];

        return string;
    }

}

@end


