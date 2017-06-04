//
//  BLTManager.m
//  IRBT
//
//  Created by wsz on 16/9/26.
//  Copyright © 2016年 wsz. All rights reserved.
//

#import "BLTManager.h"

#import "PrefixHeader.pch"
#import "LZXDataCenter.h"
#import "SocketManager.h"
#import "ControlMethods.h"
#import "PacketMethods.h"
#import "themeInfraModel.h"
#import "themeInfraModelTools.h"
#import "themeDeviceMessage.h"
#import "themeDeviceMessageTool.h"
@interface BLTManager ()
{
    BideOrderType bideType;
    NSString *devieNo;
    NSString *themeNo;
    NSString *infraControlName;
    NSString *deviceState;
    NSInteger typeId;
    NSString *gatewayNo;
}

@property (nonatomic,strong)NSTimer *timer;

@property (nonatomic,strong)NSMutableData *container;

@end

@implementation BLTManager

+ (BLTManager *)shareInstance
{
    static dispatch_once_t once;
    static BLTManager *instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
        instance.isconnected = YES;
    });
    return instance;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        
       
    }
    return self;
}


- (NSTimer *)timer
{
    if(!_timer)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCount) userInfo:nil repeats:YES];
        [_timer setFireDate:[NSDate distantFuture]];
    }
    return _timer;
}

- (void)destryTimer
{
    if(_timer)
    {
        if([_timer isValid])
        {
            [_timer invalidate];
        }
        _timer = nil;
    }
    [SVProgressHUD dismiss];
}

- (NSMutableData *)container
{
    if(!_container)
    {
        _container = [NSMutableData new];
    }
    return _container;
}

- (ARCStateCtr *)arcCtr
{
    if(!_arcCtr)
    {
        _arcCtr = [[ARCStateCtr alloc] init];
        [_arcCtr resetState];
    }
    return _arcCtr;
}

static NSInteger counter = 0;
- (void)timerCount
{
    counter--;
    if(counter<1)
    {
        [SVProgressHUD showErrorWithStatus:@"搜索超时,请重试"];
        [self.timer setFireDate:[NSDate distantFuture]];
    }
}



- (void)sendData:(NSData *)data;
{
    NSMutableData *muti = [NSMutableData new];
    uint8_t h[] = {0x30,0x00};
    [muti appendBytes:h length:2];
    [muti appendData:data];
    
    //校验位
    uint8_t j = 0;
    for(int i=0;i<muti.length;i++)
    {
        uint8_t tmp = 0;
        [muti getBytes:&tmp range:NSMakeRange(i, 1)];
        j+=tmp;
    }
    
    [muti appendBytes:&j length:1];
    if([LZXDataCenter defaultDataCenter].controlFlag==1)
    {//表示控制设备
       
        [self   controlRemote:muti];
        
    }else if([LZXDataCenter defaultDataCenter].controlFlag==3){//红外遥控定时设置
        [self controlInfraScheduleTask:muti];
        [LZXDataCenter defaultDataCenter].scheduleName = [[LZXDataCenter defaultDataCenter].DeviceName stringByAppendingString:[LZXDataCenter defaultDataCenter].btnName];
    }else{
        
        if([LZXDataCenter defaultDataCenter].DeviceTypeID ==6){//空调
            
            [LZXDataCenter defaultDataCenter].infraCode = [self NSdataToString:muti];
        }else{//非空调
        
            [self insertThemeInfraDevice:muti];
        }
    }
   
    uint8_t a[] = {0x56,0x78};
    [muti appendBytes:a length:2];
    
    NSInteger f = [muti length]/20;
    NSInteger n = [muti length]%20;
    if(muti.length<=20)
    {
       
    }
    else
    {
        for(int i=0;i<f;i++)
        {
           
        }
        if(n!=0)
        {
          
        }
    }
}


-(void)insertThemeInfraDevice:(NSData*)cmd{

    
    devieNo = [LZXDataCenter defaultDataCenter].remoteDeviceNum;//红外转发器的deviceNo
    ;
    themeNo =  [LZXDataCenter defaultDataCenter].theme_No;
    infraControlName = [[LZXDataCenter defaultDataCenter].DeviceName stringByAppendingString:[LZXDataCenter defaultDataCenter].btnName];
    deviceState = [self NSdataToString:cmd];
    typeId = [LZXDataCenter defaultDataCenter].DeviceTypeID;
    
    gatewayNo =[LZXDataCenter defaultDataCenter].gateway_No;
    
    
    
    themeInfraModel *infraDevice = [[themeInfraModel alloc]init];
    
    infraDevice.deviceNo = devieNo;
    infraDevice.themeNo = themeNo;
    infraDevice.infraType_ID = typeId;
    
    themeInfraModel *infraModel = [[themeInfraModel alloc]init];
    
    infraModel.deviceNo = devieNo;
    infraModel.deviceState_Cmd = deviceState;
    infraModel.gatewayNo = gatewayNo;
    infraModel.infraControlName= infraControlName;
    infraModel.infraType_ID= typeId;
    infraModel.themeNo = themeNo;
    if ([themeInfraModelTools querWithInfraDevices:infraDevice].count!=0) {//有值 更新
        if ([deviceState length]<=64) {
       
            [themeInfraModelTools updateInfraDeviceState:infraModel];
        }
    }else{
        if ([deviceState length]<=64) {
        
            [themeInfraModelTools addThemeInfraDevice:infraModel];
        }
    }
    
//    NSLog(@"infraModel.deviceNo = %@ infraModel.deviceState_Cmd = %@ infraModel.gatewayNo= %@ infraModel.infraControlName = %@ infraModel.infraType_ID = %ld infraModel.themeNo = %@",infraModel.deviceNo,infraModel.deviceState_Cmd,infraModel.gatewayNo,infraModel.infraControlName,(long)infraModel.infraType_ID,infraModel.themeNo);
    [self insertToThemeDeviceTabel];
    
}
-(void)insertToThemeDeviceTabel{
    
    //增加
    themeDeviceMessage *themeDevice= [[themeDeviceMessage alloc]init];
    
    themeDevice.device_No = devieNo;
    themeDevice.device_state_cmd =deviceState;
    themeDevice.gateway_No = gatewayNo;
    themeDevice.infra_type_ID = typeId;
    themeDevice.theme_device_No = [LZXDataCenter defaultDataCenter].device_No;
    themeDevice.theme_no = themeNo ;
    themeDevice.theme_type = [LZXDataCenter defaultDataCenter].theme_Type;
    themeDevice.theme_state =[LZXDataCenter defaultDataCenter].theme_State;
    
    //查询
    themeDeviceMessage *foundThemeDevice = [[themeDeviceMessage alloc]init];
    
    foundThemeDevice.device_No =devieNo;
    
    foundThemeDevice.theme_no = themeNo;
    foundThemeDevice.infra_type_ID = typeId;
    
    NSArray *foundThemeDeviceArray =   [themeDeviceMessageTool queryWithThemeDevicesOnlyForInfra:foundThemeDevice];
    
    //更新
    themeDeviceMessage *updataThemeDeviceState = [[themeDeviceMessage alloc]init];
    
    updataThemeDeviceState.device_state_cmd = deviceState;
    updataThemeDeviceState.theme_no = themeNo;
    updataThemeDeviceState.infra_type_ID = typeId;
    updataThemeDeviceState.device_No = devieNo;
    
    if (foundThemeDeviceArray.count !=0) {//更新
        if ([deviceState length]<=64) {
        
            [themeDeviceMessageTool updateThemeDeviceStateOnlyForInfra:updataThemeDeviceState];
        }
    }else{//增加
        if ([deviceState length]<=64) {
        
            [themeDeviceMessageTool addThemeDevice:themeDevice];
        }
    }
    
    
}

- (void)sendLearnedData:(NSData *)data;
{
    NSMutableData *muti = [NSMutableData dataWithData:data];
    uint8_t a[] = {0x56,0x78};
    [muti appendBytes:a length:2];
    
    NSInteger f = [muti length]/20;
    NSInteger n = [muti length]%20;
    if(muti.length<=20)
    {
    }    else
    {
        for(int i=0;i<f;i++)
        {
        }
        if(n!=0)
        {
        }
    }
}

- (void)sendARCData:(NSData *)data withTag:(NSInteger)tag
{

    //head
    NSMutableData *muti = [NSMutableData new];
    uint8_t h[] = {0x30,0x01};
    [muti appendBytes:h length:2];
    
    //2B
    [muti appendData:[data subdataWithRange:NSMakeRange(0, 2)]];
    
    //7B
    [muti appendData:[self.arcCtr get7B_DataWithTag:tag]];
    
    //1B
    [muti appendData:[data subdataWithRange:NSMakeRange(9, 1)]];
    
    //arc_table+0xFF
    [muti appendData:[data subdataWithRange:NSMakeRange(10, data.length-10)]];
    
    //校验位
    
    uint8_t j = 0;
    for(int i=0;i<muti.length;i++)
    {
        uint8_t tmp = 0;
        [muti getBytes:&tmp range:NSMakeRange(i, 1)];
        j+=tmp;
    }
    [muti appendBytes:&j length:1];
    
    if([LZXDataCenter defaultDataCenter].controlFlag==1)
    {//表示控制设备
    
        [self   controlRemote:muti];
    }else if([LZXDataCenter defaultDataCenter].controlFlag==3){//红外遥控定时设置
        [self controlInfraScheduleTask:muti];
     
        [LZXDataCenter defaultDataCenter].scheduleName = [[LZXDataCenter defaultDataCenter].DeviceName stringByAppendingString:[LZXDataCenter defaultDataCenter].btnName];
    }else{
    
        if([LZXDataCenter defaultDataCenter].DeviceTypeID ==6){//空调
            [LZXDataCenter defaultDataCenter].infraCode = [self NSdataToString:muti];
        }else{//非空调
            
            [self insertThemeInfraDevice:muti];
        }

    }
    
    //tail
    uint8_t a[] = {0x56,0x78};
    [muti appendBytes:a length:2];
    
    NSInteger f = [muti length]/20;
    NSInteger n = [muti length]%20;
    if(muti.length<=20)
    {
        
    }
    else
    {
        for(int i=0;i<f;i++)
        {
        }
        if(n!=0)
        {
        }
    }
    
   
}

/**
 *  控制红外要控制
 *
 *  @param nsdata
 */
-(void)controlRemote:(NSData*)nsdata{
    
    LZXDataCenter *dataCenter = [LZXDataCenter  defaultDataCenter];
    
    //拆报文
    NSString *head = @"42424141";
    
    NSString *stamp = @"00000000";
    
    NSString *gw_id = dataCenter.gatewayNo;
    
    NSString *dev_id = dataCenter.remoteDeviceNum;
    
    NSString *dev_type = @"6900";
    
    NSString *data_type = @"0200";
    
    NSString *data =[self NSdataToString:nsdata];
    
    NSString *data_len = [@"00"  stringByAppendingString:[self  ToHex:[data length]/2]];
    //拼接发送报文
    NSString *packet = [PacketMethods  devicePacket:head getStamp:stamp getGw_id:gw_id getDev_id:dev_id getDev_type:dev_type getData_type:data_type getData_len:data_len getData:data];
    
    
    NSString *deviceControlPacketStr = [packet stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
    
    if (dataCenter.networkStateFlag == 0) {//内网
        
        SocketManager *socket = [SocketManager shareSocketManager];
        
        NSString *localControlMessage = [deviceControlPacketStr  stringByReplacingCharactersInRange:NSMakeRange(0, 8) withString:@"41414444"];
        //打印报文
        NSLog(@"===内网localControlMessage is %@==",localControlMessage);
        [socket  sendMsg:localControlMessage];
    }else{
        
        //打印报文
        NSLog(@"===外网deviceControlPacketStr is %@==",deviceControlPacketStr);
        
        //发送报文到对应设备
        [ControlMethods  controlDeviceHTTPmethods:deviceControlPacketStr ];
        
    }
    

}
-(void)controlInfraScheduleTask:(NSData*)nsdata{
    
    LZXDataCenter *dataCenter = [LZXDataCenter  defaultDataCenter];
    
    //拆报文
    NSString *head = @"42424141";
    
    NSString *stamp = @"00000000";
    
    NSString *gw_id = dataCenter.gatewayNo;
    
    NSString *dev_id = dataCenter.remoteDeviceNum;
    
    NSString *dev_type = @"6900";
    
    NSString *data_type = @"0200";
    
    NSString *data =[self NSdataToString:nsdata];
    
    NSString *data_len = [@"00"  stringByAppendingString:[self  ToHex:[data length]/2]];
    //拼接发送报文
    NSString *packet = [PacketMethods  devicePacket:head getStamp:stamp getGw_id:gw_id getDev_id:dev_id getDev_type:dev_type getData_type:data_type getData_len:data_len getData:data];
    
    
    NSString *deviceControlPacketStr = [packet stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
    dataCenter.infraPacket = deviceControlPacketStr;
    
}



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


static bool splicDelay = NO;
- (void)serialGATTCharValueUpdated:(NSString *)UUID value:(NSData *)data
{
    
    if(!data.length)
    {
        return;
    }
    
    if(!splicDelay)
    {
        splicDelay = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
            splicDelay = NO;
            if(bideType==BideOrderTypeLearn)
            {
                if(self.learnCB)
                {
                    self.learnCB([self.container mutableCopy]);
                }
            }
            else
            {
                if(self.matchCB)
                {
                    self.matchCB([self.container mutableCopy]);
                }
            }
            self.container = nil;
        });
    }
    
    [self.container appendData:data];
}

#pragma mark -
#pragma mark - others

- (void)setConnect
{
//    [SVProgressHUD showSuccessWithStatus:@"连接成功"];
//    if(self.didConn)
//    {
//        _isconnected = YES;
//        self.didConn();
//    }
}

- (void)setDisconnect
{
    _isconnected = NO;
    [SVProgressHUD showErrorWithStatus:@"连接丢失"];
}

@end
