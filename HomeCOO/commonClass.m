//
//  commonClass.m
//  HomeCOO
//
//  Created by app on 16/9/12.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "commonClass.h"
#import "LZXDataCenter.h"
#import "MethodClass.h"
#import "spaceAdministrationController.h"
#import "SpaceViewController.h"
#import "ThemeViewController.h"
#import "SettingViewController.h"
#import "SecurityViewController.h"
#import "SocketManager.h"
#import "MBProgressHUD+MJ.h"
#import "transCodingMethods.h"
#import "alarmMessages.h"
#import "alarmMessagesTool.h"
#import "deviceMessage.h"
#import "deviceMessageTool.h"
#import "ControlMethods.h"
#import "AppDelegate.h"
#import "alarmRinging.h"
#import "JPUSHService.h"
#import "gatewayMessageTool.h"
#import "gatewayMessageModel.h"
#import "UdpSocketManager.h"
#import "GGSocketManager.h"
#import "PrefixHeader.pch"
#import "AFNetworkings.h"
#import "musicModelDB.h"
#import "musicModelDBTools.h"
//底部空间、情景模式等按钮的高度
#define HOMECOOSPACEBUTTONHEIGHT 60

//底部空间、情景模式等按钮的宽度
#define HOMECOOSPACEBUTTONWIDTH [UIScreen  mainScreen].bounds.size.width / 5

//底部空间、情景模式等按钮Y的大小
#define  HOMECOOSPACEBUTTON_Y  [UIScreen  mainScreen].bounds.size.height - 55

//底部空间、情景模式等按钮字体的大小
#define HOMESPACEFONT 13
@interface commonClass ()

@property(nonatomic,strong) UIImageView  *fullscreenView;

@property(nonatomic,strong) UIButton  *localAndRemoteChangesBtn;

@property(nonatomic,strong) NSString *alarmString;
//定义一个全局变量 接受报警通知
@property(nonatomic,copy) NSString *alertString;

@property(nonatomic,strong) UIAlertView *alterView;

@property (nonatomic,strong) UdpSocketManager *udpManager;

@property (nonatomic,strong)  GGSocketManager *socketManger ;


@end

@implementation commonClass

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置背景
    [self setFullscreenView];

    //添加转换到空间的按钮
    [self  convertToSpaceBtn];
    
    //添加转换到情景模式的按钮
    [self convertToThemeBtn];
    
    //本地和远程的自动切换
    [self  localAndRemoteChangesBtnAction];
    
    //添加防区管理按钮
    [self  convertToSecurityBtn];
    
    //添加设置按钮
    [self  convertToSettingBtn];
    
    //接收来自网关的消息
    [self   receivedFromGateway_deviceMessage];
   
}




/**
 *  内网情况下，接收底层设备手动出发报上来的信息（用于更新设备状态）
 *
 *  @return
 */
-(void)receivedFromGateway_deviceMessage{

    SocketManager  *socket = [SocketManager  shareSocketManager];
    
    [socket receiveMsg:^(NSString *receiveInfo) {
        
        NSString *receiveMessage = receiveInfo;
       
        
        NSLog(@"=====receiveMessage = %@ ======",receiveMessage);
        
        NSString*  gw_id;//内网情况下 退网的时候 设备的id 全部是0
       
        gw_id= [receiveMessage  substringWithRange:NSMakeRange(16, 16)];
     
        if ([gw_id  isEqualToString:@"0000000000000000"]) {
            
            LZXDataCenter *dataCenter = [LZXDataCenter  defaultDataCenter];
            gw_id = dataCenter.gatewayNo;
            
        }
        NSString* dev_id = [receiveMessage  substringWithRange:NSMakeRange(32, 16)];
        NSString* dev_type = [receiveMessage  substringWithRange:NSMakeRange(48, 2)];
        NSString*  data_type = [receiveMessage  substringWithRange:NSMakeRange(52, 4)];
        NSString*  data = [receiveMessage  substringFromIndex:60];
        
        NSInteger deviceType_ID = strtoul([[dev_type substringWithRange:NSMakeRange(0, 2)] UTF8String], 0, 16);
        
        NSInteger deviceGategory_ID;
        NSString *deviceName;
        NSString *deviceState;
        NSString * temp;
        NSString *humi;
        NSString *deviceStateStr;
        NSInteger  PM2_5H ;
        NSInteger  PM2_5L ;
        NSInteger  PM2_5;
        
        alarmMessages *alarmMessage = [[alarmMessages  alloc]init];
        
        switch (deviceType_ID) {
            case 1:
                
                deviceGategory_ID = 1;
                deviceName = @"一路开关";
                deviceState = [transCodingMethods  transCodingFromServer:data ];
                break;
            case 2:
                
                deviceGategory_ID = 1;
                deviceName = @"二路开关";
                deviceState = [transCodingMethods  transCodingFromServer:data ];
                break;
            case 3:
                
                deviceGategory_ID = 1;
                deviceName = @"三路开关";
                deviceState = [transCodingMethods  transCodingFromServer:data ];
                break;
            case 4:
                
                deviceGategory_ID = 1;
                deviceName = @"四路开关";
                deviceState = [transCodingMethods  transCodingFromServer:data ];
                break;
                
            case 5:
                
                deviceGategory_ID = 1;
                deviceName = @"调光开关";
                deviceState =[NSString  stringWithFormat:@"%lu",strtoul([[data substringWithRange:NSMakeRange(0, 2)] UTF8String], 0, 16)];
                if ([deviceState isEqualToString:@"10"]) {
                    deviceState = @"9";
                }
                break;
                
            case 6:
                
                deviceGategory_ID = 3;
                deviceName = @"窗帘";
                deviceState = [transCodingMethods  transCodingFromServer:data ];
                break;
                
            case 8:
                deviceGategory_ID = 5;
                deviceName = @"插座";
                deviceState = [transCodingMethods  transCodingFromServer:data ];
                
                break;
            case 11:
                deviceGategory_ID = 3;
                deviceName = @"窗户";
                deviceState = [transCodingMethods  transCodingFromServer:data ];
                break;
                
            case 51:
                
                deviceGategory_ID = 2;
                deviceName = @"空气净化器";
                deviceState = [transCodingMethods  transCodingFromServer:data ];
                
                break;
            case 104:
                
                deviceGategory_ID = 2;
                deviceName = @"温湿度";
                temp = [NSString stringWithFormat:@"%lu",strtoul([[data substringWithRange:NSMakeRange(2, 2)] UTF8String], 0, 16)];
                humi = [NSString  stringWithFormat:@"%lu",strtoul([[data substringWithRange:NSMakeRange(6, 2)] UTF8String], 0, 16)];
                deviceStateStr = [temp  stringByAppendingString:@"p" ];
                deviceState = [deviceStateStr  stringByAppendingString:humi];
                
                break;
            case 105:
                deviceName = @"红外转发器";
                deviceState = data;
                break;
            case 109:
                deviceGategory_ID = 2;
                deviceName = @"PM2.5";
                PM2_5H = strtoul([[data substringWithRange:NSMakeRange(0, 2)] UTF8String], 0, 16);
                PM2_5L = strtoul([[data substringWithRange:NSMakeRange(2, 2)] UTF8String], 0, 16);
                PM2_5 = PM2_5H *10 + PM2_5L/10;
                deviceState  = [NSString  stringWithFormat:@"%ld",(long)PM2_5];
                
                break;
            case 110:
                
                deviceGategory_ID = 2;
                deviceName = @"门磁";
                deviceState = [transCodingMethods  transThemeCodingFromServer:data ];
                
                if ([[deviceState substringToIndex:2] isEqualToString:@"01"]  ) {
                    
                    NSString *string1 =[receiveMessage  substringToIndex:52];
                    NSString *string2 = @"020000026400";
                    self.alarmString = [string1  stringByAppendingString:string2];
                    
                    alarmMessage.device_no = dev_id;
                    alarmMessage.gateway_no = gw_id;
                    alarmMessage.time = [ControlMethods  getCurrentTime];
                    [alarmMessagesTool  addDevice:alarmMessage];
                    [self  alarmMessageAlterView:deviceName];
                }
                
                break;
            case 113:
                deviceGategory_ID = 2;
                deviceName = @"红外感应";
                deviceState = [transCodingMethods  transThemeCodingFromServer:data ];
                if ([[deviceState substringToIndex:2] isEqualToString:@"01"]  ) {
                    
                    NSString *string1 =[receiveMessage  substringToIndex:52];
                    NSString *string2 = @"020000026400";
                    self.alarmString = [string1  stringByAppendingString:string2];
                    
                    alarmMessage.device_no = dev_id;
                    alarmMessage.gateway_no = gw_id;
                    alarmMessage.time = [ControlMethods  getCurrentTime];
                    
                    [alarmMessagesTool  addDevice:alarmMessage];
                     [self  alarmMessageAlterView:deviceName];
                    
                }
                
                break;
            case 115:
                deviceGategory_ID = 2;
                deviceName = @"燃气";
                deviceState = [transCodingMethods  transThemeCodingFromServer:data ];
                if ([[deviceState substringToIndex:2] isEqualToString:@"01"]  ) {
                    
                    NSString *string1 =[receiveMessage  substringToIndex:52];
                    NSString *string2 = @"020000026400";
                    self.alarmString = [string1  stringByAppendingString:string2];
                    
                    alarmMessage.device_no = dev_id;
                    alarmMessage.gateway_no = gw_id;
                    alarmMessage.time = [ControlMethods  getCurrentTime];
                    [alarmMessagesTool  addDevice:alarmMessage];
                     [self  alarmMessageAlterView:deviceName];
                    
                }
                
                break;
                
            case 118:
                deviceGategory_ID = 2;
                deviceName = @"烟感";
                deviceState = [transCodingMethods  transThemeCodingFromServer:data ];
                if ([[deviceState substringToIndex:2] isEqualToString:@"01"]  ) {
                    
                    NSString *string1 =[receiveMessage  substringToIndex:52];
                    NSString *string2 = @"020000026400";
                    self.alarmString = [string1  stringByAppendingString:string2];
                    
                    alarmMessage.device_no = dev_id;
                    alarmMessage.gateway_no = gw_id;
                    alarmMessage.time = [ControlMethods  getCurrentTime];
                    [alarmMessagesTool  addDevice:alarmMessage];
                     [self  alarmMessageAlterView:deviceName];
                }
                break;
            case 201:
                deviceGategory_ID = 6;
                deviceName = @"双控";
                deviceState = [transCodingMethods  transThemeCodingFromServer:data ];
                break;
            case 202:
                deviceGategory_ID = 4;
                deviceName = @"情景开关";
                deviceState = [transCodingMethods  transThemeCodingFromServer:data];
                break;
        }
        
        
        deviceMessage *device = [[deviceMessage  alloc]init];
        
        device.DEVICE_GATEGORY_ID  = deviceGategory_ID;
        device.DEVICE_NAME = deviceName;
        device.DEVICE_STATE = deviceState;
        device.DEVICE_NO = dev_id;
        device.DEVICE_TYPE_ID = deviceType_ID;
        device.GATEWAY_NO = gw_id;
        device.SPACE_NO = @"0";
        device.SPACE_TYPE_ID = 0;
        
        deviceMessage *dev = [[deviceMessage  alloc]init];
        
        dev.DEVICE_NO = dev_id;
        dev.GATEWAY_NO = gw_id;
        
        

        //NSLog(@"========%ld=====%@======%@======%@=====%ld====%@====%@=====%ld======",(long)device.DEVICE_GATEGORY_ID,device.DEVICE_NAME,device.DEVICE_STATE,device.DEVICE_NO,(long)device.DEVICE_TYPE_ID,device.GATEWAY_NO,device.SPACE_NO,(long)device.SPACE_TYPE_ID);
     
          dispatch_async(dispatch_get_main_queue(), ^{
       
              NSArray *deviceArray = [deviceMessageTool  queryWithDeviceNumDevices:dev];
      
       
            if([data_type isEqualToString:@"0100"]){//上行报文
                
                if (deviceArray.count == 0) {//添加新设备
                    
                    // NSLog(@"    插入新设备！！！   ");
                    
                    [deviceMessageTool  addDevice:device];
                    
                }else{//更新设备状态
                    
                    //  NSLog(@"    更新设备！！！   ");
                    [deviceMessageTool  updateDeviceMessageOnlyLocal:device];
                    
                }
                
            }if([data_type isEqualToString:@"0c00"]){//退网报文
                
                if (deviceArray.count != 0){
                    
                   // NSLog(@"    删除设备成功！！！   ");
                    [deviceMessageTool  deleteDevice:dev];
                    
                }
                
            }
            
        });
        
    }];

}

/**
 *  报警弹出对话框
 */
-(void)alarmMessageAlterView:(NSString *)deviceName{

    //调用系统铃声
    [alarmRinging  alarmMessageBells];
    if (![deviceName isEqualToString:self.alertString]) {
        
        self.alertString = deviceName;
   
        //回到主线程 刷新UI
   
        dispatch_queue_t queue = dispatch_get_main_queue();
   
        dispatch_async(queue, ^{
        
            NSString *alarmMessage = [NSString  stringWithFormat: @"检测到%@发生报警，系统正在为您处理！",deviceName];
        
            UIAlertView *alterView = [[UIAlertView  alloc]initWithTitle:@"报警通知" message:alarmMessage delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"撤防", nil];
       
            self.alterView = alterView;
            
            [alterView  show];
  
        });
    }
    
  
}


/**
 *  UIAlertview 代理方法
 *
 *  @param alertView
 *  @param buttonIndex
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
    
    //回到主线程 刷新UI
    
        SocketManager *socket = [SocketManager  shareSocketManager];
    
    if (self.alterView !=nil) {
        
        if(buttonIndex ==1){//点击的是确定按键
           
            
            self.alertString = @"1";
            
             [socket  sendMsg:self.alarmString];
            
            
        }if (buttonIndex == 0) {//点击的是取消按键
            //清除BadgeNumber为0
            
            self.alertString = @"1";
          
        }
        self.alterView = nil;
        
    }else{
        
        if(buttonIndex ==1){//点击的是确定按键
        
           
            [self exitApplication ];
        
        }
        if (buttonIndex == 0) {//点击的是取消按键
            
        
        }
    }

    
   
    
}
-(void)exitApplication{

    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    UIWindow *window = app.window;
    
    [UIView animateWithDuration:0.5 animations:^{//1.0f
        window.alpha = 0.5;//透明度似乎没有发挥作用
        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];
    


}





/**
 *设置导背景图片
 */
-(void)setFullscreenView{
    
    
    UIImageView  *fullscreenView = [[UIImageView  alloc]init];
    UIImage  *image = [UIImage imageNamed:@"界面背景.jpg"];
    /**设置背景图片的大小*/
    fullscreenView.image = image;
    fullscreenView.userInteractionEnabled = YES;
    fullscreenView.contentMode = UIViewContentModeScaleToFill;
    CGFloat fullscreenViewW = [UIScreen  mainScreen].bounds.size.width;
    CGFloat fullscreenViewH = [UIScreen  mainScreen].bounds.size.height;
    fullscreenView.frame = CGRectMake(0, 0, fullscreenViewW, fullscreenViewH);
    self.fullscreenView = fullscreenView;
    [self.view  addSubview:fullscreenView];
    
    
    
}

/**
 *转换到空间模块 button
 */

-(void)convertToSpaceBtn{
    
    
    UIButton  *convertToSpaceBtn = [[UIButton  alloc]init];
    
    CGFloat convertToSpaceBtnX = 0;
    CGFloat convertToSpaceBtnY = HOMECOOSPACEBUTTON_Y;
    CGFloat convertToSpaceBtnW = HOMECOOSPACEBUTTONWIDTH;
    CGFloat convertToSpaceBtnH = HOMECOOSPACEBUTTONHEIGHT;
    
    
    convertToSpaceBtn.frame = CGRectMake(convertToSpaceBtnX, convertToSpaceBtnY, convertToSpaceBtnW, convertToSpaceBtnH);
    
    //设置按钮的一些基本属性
    [MethodClass  setButton:convertToSpaceBtn setNormalImage:@"icon_space" setHighlightedImage:@"icon_space_highlight" setNormalTitle:@"空间" setHightedTitle:@"空间"];
    
    [convertToSpaceBtn  addTarget:self action:@selector(convertToSpaceAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.fullscreenView  addSubview:convertToSpaceBtn];
    
}

/**
 *切换到空间模块
 */


-(void)convertToSpaceAction{
    
    
    SpaceViewController  *convertToSpaceVC = [[SpaceViewController  alloc]init];
    
    [self  presentViewController:convertToSpaceVC animated:YES completion:nil];
    
    
}

/**
 *转换到情景模式 button
 */

-(void)convertToThemeBtn{
    
    
    UIButton  *convertToThemeBtnBtn = [[UIButton  alloc]init];
    
    CGFloat convertToThemeBtnX = HOMECOOSPACEBUTTONWIDTH;
    CGFloat convertToThemeBtnY = HOMECOOSPACEBUTTON_Y;
    CGFloat convertToThemeBtnW = HOMECOOSPACEBUTTONWIDTH;
    CGFloat convertToThemeBtnH = HOMECOOSPACEBUTTONHEIGHT;
    convertToThemeBtnBtn.frame = CGRectMake(convertToThemeBtnX, convertToThemeBtnY, convertToThemeBtnW, convertToThemeBtnH);
    
    //设置按钮的一些基本属性
    [MethodClass  setButton:convertToThemeBtnBtn setNormalImage:@"icon_scene" setHighlightedImage:@"icon_scene_highlight" setNormalTitle:@"情景模式" setHightedTitle:@"情景模式"];
    
    [convertToThemeBtnBtn  addTarget:self action:@selector(convertToThemeAction) forControlEvents:UIControlEventTouchUpInside];
   
    [self.fullscreenView  addSubview:convertToThemeBtnBtn];
    
}

/**
 *切换到情景模块
 */

-(void)convertToThemeAction{
    
    ThemeViewController  *convertToThemeVC = [[ThemeViewController  alloc]init];
    [self  presentViewController:convertToThemeVC animated:YES completion:nil];
    
}

/**
 *本地和远程的切换
 */

-(void)localAndRemoteChangesBtnAction{
    
    LZXDataCenter  *dataCenter = [LZXDataCenter  defaultDataCenter];
    
    UIButton  *localAndRemoteChangesBtn = [[UIButton  alloc]init];
    
    CGFloat localAndRemoteChangesBtnX = 2 * HOMECOOSPACEBUTTONWIDTH;
    CGFloat localAndRemoteChangesBtnY = HOMECOOSPACEBUTTON_Y;
    CGFloat localAndRemoteChangesBtnW = HOMECOOSPACEBUTTONWIDTH;
    CGFloat localAndRemoteChangesBtnH = HOMECOOSPACEBUTTONHEIGHT;
    localAndRemoteChangesBtn.frame = CGRectMake(localAndRemoteChangesBtnX, localAndRemoteChangesBtnY, localAndRemoteChangesBtnW, localAndRemoteChangesBtnH);
    //设置按钮的一些基本属性
    
    if (dataCenter.networkStateFlag ==0) {//本地
        
        [MethodClass  setButton:localAndRemoteChangesBtn setNormalImage:@"icons本地" setSelectedImage:@"icon_internet" setNormalTitle:@"本地" setSelectedTitle:@"远程" ];
       
    }
    
    if (dataCenter.networkStateFlag ==1) {
        
        [MethodClass  setButton1:localAndRemoteChangesBtn setNormalImage:@"icon_internet" setSelectedImage:@"icons本地" setNormalTitle:@"远程" setSelectedTitle:@"本地" ];
       
    }
    
    [localAndRemoteChangesBtn  addTarget:self action:@selector(networkStateChange:) forControlEvents:UIControlEventTouchUpInside];
    self.localAndRemoteChangesBtn = localAndRemoteChangesBtn;
    
    [self.fullscreenView  addSubview:localAndRemoteChangesBtn];
    
}

/**
 *  内外网切换
 *
 *  @param btn
 */
-(void)networkStateChange:(UIButton *)btn{
    
    SocketManager *socket = [SocketManager shareSocketManager];
    UdpSocketManager *udpSocket = [UdpSocketManager shareUdpSocketManager];
    LZXDataCenter *dataCenter = [LZXDataCenter defaultDataCenter];

    NSString *head;
    NSString *datas;
    NSString *gatewayConnectStr1;
    NSString *gatewayConnectStr;
    NSString *gatewayIP;
    NSArray *gatewayArray = [gatewayMessageTool queryWithgateways];
    
    if (gatewayArray.count == 0)  {
        
        [MBProgressHUD  showError:@"请先添加网关"];
        
    }else{
        
        gatewayMessageModel *gateway = gatewayArray[0];

        head = @"4141444430303030";
        datas = [@"000000000000000032001C000008" stringByAppendingString:[ControlMethods   stringToByte: gateway.gatewayPWD]];
        gatewayIP = gateway.gatewyIP;
        gatewayConnectStr1 = [head  stringByAppendingString:gateway.gatewayID];
        gatewayConnectStr = [gatewayConnectStr1 stringByAppendingString:datas];

        btn.selected = !btn.selected;
        
        if (btn.selected) {
            
            if (dataCenter.networkStateFlag==1) {//如果是远程 则切换到 本地
                
                //开始广播
                [self receivedUdpGB];
                
                [socket startConnectHost:gatewayIP WithPort:9091];
                
                [socket  sendMsg:gatewayConnectStr];
                
                dataCenter.networkStateFlag= 0;
                //每次调用之前清空之前的别名
                [JPUSHService setAlias:@"" callbackSelector:nil object:nil];
                
                [socket  receiveMsg:^(NSString *receiveInfo) {
                    
                    //NSLog(@" 内外网切换 = %@",receiveInfo);
                    
                    if ([[receiveInfo  substringFromIndex:receiveInfo.length -10] isEqualToString:@"4300000100"]) {
                        
                         dispatch_async(dispatch_get_main_queue(), ^{
                       
                             [MBProgressHUD  showSuccess:@"本地连接成功！！！"];
                              [self   receivedFromGateway_deviceMessage];
                         });
                        
                    }
                }];
                 
            }else{
                //停止广播
                [udpSocket stopRunloopSendData];
                [self.socketManger closeSocket];
                
                [self syncThemeMusic];
                dataCenter.networkStateFlag= 1;
                //每次注册别名
                [JPUSHService setAlias:gateway.gatewayID callbackSelector:nil object:nil];
               
    
               
            }

        }else{
            if (dataCenter.networkStateFlag==1){
                
                
                [self receivedUdpGB];
                
                dataCenter.networkStateFlag= 0;
                [socket startConnectHost:gatewayIP WithPort:9091];
                [socket  sendMsg:gatewayConnectStr];
                [socket  receiveMsg:^(NSString *receiveInfo) {
                   
                    if ([[receiveInfo  substringFromIndex:receiveInfo.length -10] isEqualToString:@"4300000100"]) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                        
                            [MBProgressHUD  showSuccess:@"本地连接成功！！！"];
                            
                            [self   receivedFromGateway_deviceMessage];
                        });
                        
                    }
                   
                }];
                
                //每次调用之前清空之前的别名
                [JPUSHService setAlias:@"" callbackSelector:nil object:nil];
                
            }else{
               
                dataCenter.networkStateFlag= 1;
                [udpSocket stopRunloopSendData];
                [self.socketManger closeSocket];
               
                [self syncThemeMusic];
                //每次注册别名
                [JPUSHService setAlias:gateway.gatewayID callbackSelector:nil object:nil];
            }
        }
    }

}

/**
 *添加防区按钮
 */

-(void)convertToSecurityBtn{
    
    UIButton  *convertToSecurityBtn = [[UIButton  alloc]init];
    
    CGFloat convertToSecurityBtnX = 3 * HOMECOOSPACEBUTTONWIDTH;
    CGFloat convertToSecurityBtnY = HOMECOOSPACEBUTTON_Y;
    CGFloat convertToSecurityBtnW = HOMECOOSPACEBUTTONWIDTH;
    CGFloat convertToSecurityBtnH = HOMECOOSPACEBUTTONHEIGHT;
    convertToSecurityBtn.frame = CGRectMake(convertToSecurityBtnX, convertToSecurityBtnY, convertToSecurityBtnW, convertToSecurityBtnH);
    
    //设置按钮的一些基本属性
    [MethodClass  setButton:convertToSecurityBtn setNormalImage:@"icon_alert" setHighlightedImage:@"icon_alert_highlight" setNormalTitle:@"防区管理" setHightedTitle:@"防区管理"];
    
    [convertToSecurityBtn  addTarget:self action:@selector(convertTosecurityAction) forControlEvents:UIControlEventTouchUpInside];
    //convertToSpaceBtn.backgroundColor = [UIColor  whiteColor];
    
    [self.fullscreenView  addSubview:convertToSecurityBtn];
    
}


/**
 *切换到防区模块
 */
-(void)convertTosecurityAction{
    
    SecurityViewController  *convertTosecurityVC = [[SecurityViewController  alloc]init];
    
    [self  presentViewController:convertTosecurityVC animated:YES completion:nil];
}

/**
 *添加设置按钮
 */
-(void)convertToSettingBtn{
    
    UIButton  *convertToSettingBtn = [[UIButton  alloc]init];
    
    CGFloat convertToSettingBtnX = 4 * HOMECOOSPACEBUTTONWIDTH;
    CGFloat convertToSettingBtnY = HOMECOOSPACEBUTTON_Y;
    CGFloat convertToSettingBtnW = HOMECOOSPACEBUTTONWIDTH;
    CGFloat convertToSettingBtnH = HOMECOOSPACEBUTTONHEIGHT;
    convertToSettingBtn.frame = CGRectMake(convertToSettingBtnX, convertToSettingBtnY, convertToSettingBtnW, convertToSettingBtnH);
    
    //设置按钮的一些基本属性
    [MethodClass  setButton:convertToSettingBtn setNormalImage:@"icon_set" setHighlightedImage:@"icon_set_highlight" setNormalTitle:@"设置" setHightedTitle:@"设置"];
    
    //convertToSettingBtn.backgroundColor = [UIColor  whiteColor];
    [convertToSettingBtn  addTarget:self action:@selector(convertToSettingAction) forControlEvents:UIControlEventTouchUpInside];
    [self.fullscreenView  addSubview:convertToSettingBtn];
    
}

/**
 *切换到设置模块
 */

-(void)convertToSettingAction{
    
    SettingViewController  *convertToSettingVC = [[SettingViewController  alloc]init];
    [self  presentViewController:convertToSettingVC animated:YES completion:nil];
    
}

- (void)receivedUdpGB{
    
    _udpManager= [UdpSocketManager shareUdpSocketManager];
    
    _udpManager.udpSocket.delegate = self;
    
    NSError *error;
    if([_udpManager.udpSocket enableBroadcast:YES error:&error]){
        NSLog(@"udpSocket = %@",error);
    }
    
    NSString *test = @"S";
    
    test = [test stringByAppendingString:[LZXDataCenter defaultDataCenter].gatewayNo];
    
    NSData *data = [test dataUsingEncoding:NSUTF8StringEncoding];
    
    [_udpManager runloopSendData:data host:@"255.255.255.255" port:8004 interval:1];
    
    [_udpManager begingReceived:8004];
    
}

-(void)syncThemeMusic{

    //创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager  manager];
    
    mgr.responseSerializer = [AFJSONResponseSerializers  serializer];
    
    //配置请求超时时间
    mgr.requestSerializer.timeoutInterval = 5;
    
    //设置请求参数
    NSMutableDictionary  *params = [NSMutableDictionary  dictionary];
    
    NSString *musicString = [[self allThemeMusicList] componentsJoinedByString:@","];
    
    NSString *string1 = [@"["  stringByAppendingString:musicString];
    
    NSString *musicStringJson = [string1  stringByAppendingString:@"]"];
    
    params[@"appthemeMusicJson"] = musicStringJson;

    NSString  *urlStr =[NSString  stringWithFormat:@"%@/appSendThemeMusicList" ,HomecooServiceURL];
    NSString *url = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
    
    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        [MBProgressHUD  showSuccess:@"远程连接成功！！！"];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD  showError:@"远程连接失败，请检查网络！"];
        
        
    }];
    
}

-(NSArray *)allThemeMusicList{
    
    
    NSArray  *musicListArray = [musicModelDBTools  queryWithDeviceNumDevices];
    
    NSMutableArray  *themeMusicArray =[[NSMutableArray  alloc]init];
    
    NSString *musicListJson = @"";
    
    if (musicListArray.count != 0) {
        
        for (int i = 0; i<musicListArray.count; i++) {
            
            musicModelDB *musicModel = musicListArray[i];
            NSDictionary  *dict;
            if ((musicModel.bz !=nil)&(musicModel.deviceNo !=nil)&(musicModel.deviceState !=nil)&(musicModel.gatewayNo !=nil)&(musicModel.songName !=nil)&(musicModel.space !=nil)&(musicModel.style !=nil)&(musicModel.themeName !=nil)&(musicModel.themeNo !=nil)) {
     
                dict = @{@"bz":musicModel.bz,
                         @"deviceNo":musicModel.deviceNo,
                         @"deviceState":musicModel.deviceState,
                         @"gatewayNo":musicModel.gatewayNo,
                         @"songName":musicModel.songName,
                         @"space":musicModel.space,
                         @"style":musicModel.style,
                         @"themeName":musicModel.themeName,
                         @"themeNo":musicModel.themeNo
                         
                         };
            }
            //将字典转换成json串
            NSData  *jsonData = [NSJSONSerialization  dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
            
            musicListJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            themeMusicArray[i] = musicListJson;
            
        }
        
    }
    
    return themeMusicArray;
    
}


#pragma mark *******************************************

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext{
    
    
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSString *subStr = [str substringToIndex:1];
    
    
    if([subStr isEqualToString:@"C"]){
        
        
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog(@"接受成功 ==============%@  ",str);
        
        if ([[LZXDataCenter defaultDataCenter].QICUNPINGIP isEqualToString:str]) {
            
        }else{
            
            [LZXDataCenter defaultDataCenter].QICUNPINGIP = str;
        }
        self.socketManger = [GGSocketManager shareGGSocketManager];
        
        [self.socketManger startConnectHost:[str substringFromIndex:1] WithPort:8000];
        
        self.socketManger.socket.delegate = self;
        
        NSDictionary *paramDict = @{@"order":@23,@"wgid":[LZXDataCenter defaultDataCenter].gatewayNo};
        
        NSData *tempData = [NSJSONSerialization dataWithJSONObject:paramDict options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *json = [[NSString alloc]initWithData:tempData encoding:NSUTF8StringEncoding];
        
        json = [json stringByAppendingString:@"\0"];
        
        
        [self.socketManger sendMsg:json];
        
        
    }
    
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error{
    
    NSLog(@"广播失败");
}

//- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
//    
//    NSLog(@"发送成功");
//    
//}


#pragma mark *********TCP socket*********

#pragma mark GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    
    //连接到服务端时同样要设置监听，否则收不到服务器发来的消息
    [sock readDataWithTimeout:-1 tag:0];
    self.socketManger.gatewayIP = 1;
    NSLog(@"socket连接成功");
    
    
}


- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    
    if (self.socketManger.connectStatus == GACSocketConnectStatusDisconnected) {//主动断开
        
    }else{//网关掉线
        
        //断开连接以后再自动重连
        
        
        if (self.socketManger.socketConnectNum < 1) {
            
            [sock connectToHost:self.socketManger.host onPort:self.socketManger.port error:nil];
        }
        self.socketManger.socketConnectNum ++;
        
        self.socketManger.socketStatus = 0;
        NSLog(@"与网关断开连接");
    }
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    //当接受到服务器发来的消息时，同样设置监听，否则只会收到一次
    [sock readDataWithTimeout:-1 tag:0];
    NSString *readDataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    if([[readDataStr  substringFromIndex:readDataStr.length -2] isEqualToString:@"ff"]){//网关认证未通过
        
        self.socketManger.socketStatus = 0;
        
    }
    
    readDataStr = [readDataStr substringToIndex:readDataStr.length-1];
    
    NSData *tempData = [readDataStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:tempData options:NSJSONReadingMutableContainers error:nil];
    
    NSLog(@"收到的内容=%@",dict);
    
    
    if([dict[@"order"] isEqualToString:@"24"]){
        
        
        [_udpManager stopRunloopSendData];
        
        NSLog(@"停止广播");
        
        [self.socketManger closeSocket];
        
    }
    
    
}


@end
