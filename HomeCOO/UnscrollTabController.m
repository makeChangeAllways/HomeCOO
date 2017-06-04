//
//  UnscrollTabController.m
//  YPTabBarController
//
//  Created by 喻平 on 16/5/25.
//  Copyright © 2016年 YPTabBarController. All rights reserved.
//

#import "UnscrollTabController.h"
#import "sockViewController.h"
#import "windowsViewController.h"
#import "microViewController.h"
#import "musicViewController.h"
#import "lightViewController.h"
#import "remoteViewController.h"
#import "LZXDataCenter.h"
#import "SocketManager.h"
#import "deviceMessage.h"
#import "deviceMessageTool.h"
#import "deviceSpaceMessageModel.h"
#import "themMessageModel.h"
#import "themeMessageTool.h"
#import "themeDeviceMessage.h"
#import "themeDeviceMessageTool.h"
#import "MBProgressHUD+MJ.h"
#import "ControlMethods.h"
#import "PacketMethods.h"
#import "gatewayMessageModel.h"
#import "gatewayMessageTool.h"
#import "PrefixHeader.pch"
#import "AFNetworkings.h"
#import "themeInfraModel.h"
#import "themeInfraModelTools.h"
@interface UnscrollTabController ()

@property(nonatomic,weak)  UIImageView  *fullscreenView;
@property NSInteger clickFlag;
@end

@implementation UnscrollTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建一个导航栏
    [self setNavBar];

    //初始化子控制器
    [self initViewControllers];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.contentViewFrame = CGRectMake(0, 0, screenSize.width, screenSize.height - 44 );//screenSize.height - 64 - 50
    self.tabBar.frame = CGRectMake(0, screenSize.height-54, screenSize.width, 54);
    self.tabBar.backgroundColor =  [UIColor colorWithRed:229/255.0 green:237/255.0 blue:234/255.0 alpha:1];
    
    self.tabBar.itemTitleColor = [UIColor blackColor];
    self.tabBar.itemTitleSelectedColor = [UIColor orangeColor];
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:18];
    
    [self setContentScrollEnabledAndTapSwitchAnimated:YES];
    self.tabBar.itemSelectedBgScrollFollowContent = YES;
    self.tabBar.itemColorChangeFollowContentScroll = NO;
    
    //self.tabBar.itemSelectedBgColor = [UIColor redColor];
    
    [self.tabBar setItemSelectedBgInsets:UIEdgeInsetsZero tapSwitchAnimated:YES];
    
}

/**
 *设置导航栏
 */
-(void)setNavBar{
    
    CGFloat navBarW = [UIScreen  mainScreen].bounds.size.width;
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0,navBarW, 40)];
    
    LZXDataCenter *dataCenter = [LZXDataCenter defaultDataCenter];
    
    NSString *title = [NSString  stringWithFormat:@"%@情景联动配置",dataCenter.theme_Name];
    //创建一个导航栏集合
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:title];
    
    [[UINavigationBar appearance]setTitleTextAttributes:
     @{ NSFontAttributeName: [UIFont systemFontOfSize:16.0]}];
    
    //创建一个左边按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backAction)];
    
    leftButton.tintColor = [UIColor  blackColor];
    
    //设置字体大小
    [[UIBarButtonItem appearance] setTitleTextAttributes:
     @{ NSFontAttributeName: [UIFont systemFontOfSize:15.0],} forState:UIControlStateNormal];
    
    //创建一个右边按钮
    UIBarButtonItem *rightButton= [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(finshAction)];
    
    rightButton.tintColor = [UIColor  blackColor];
    //把导航栏集合添加到导航栏中，设置动画关闭
    [navBar pushNavigationItem:navItem animated:NO];
    
    //把左右两个按钮添加到导航栏集合中去
    [navItem setLeftBarButtonItem:leftButton];
    [navItem setRightBarButtonItem:rightButton];
    
    //将标题栏中的内容全部添加到主视图当中
    [self.view addSubview:navBar];
    
    
}


/**返回到上一个systemView*/
-(void)backAction{
    
    if (self.clickFlag==1) {//说明被点击了
        [self  dismissViewControllerAnimated:YES completion:nil];
        
    }else{
        [MBProgressHUD showError:@"请点击完成，保存设置！"];
    }
    
}


/**
 *  发送情景设置到服务器（外网）
 */
-(void)finshAction{
    
    self.clickFlag = 1;
    
    LZXDataCenter  *dataCenter = [LZXDataCenter defaultDataCenter];
    
    themeDeviceMessage *themeNo = [[themeDeviceMessage alloc]init];
    
    themeNo.theme_no = dataCenter.theme_No;
    
    NSArray *themeDevice = [themeDeviceMessageTool  queryWithThemeNoDevices:themeNo];
    
    if (themeDevice.count == 0) {
        
        LZXDataCenter  *dataCenter = [LZXDataCenter defaultDataCenter];
        
        themMessageModel  *themeModel= [[themMessageModel alloc]init]
        ;
        
        themeModel.theme_No = dataCenter.theme_No;
        
        NSArray *themeArrayList =  [themeMessageTool queryThemeWithThemeNum:themeModel];
       
        SocketManager *socket = [SocketManager shareSocketManager];
        
        themMessageModel  *theme = themeArrayList[0];
        
        NSString *dev_type;
        
        if ([theme.theme_State  isEqualToString:@"00000000"]) {//如果是自定义情景
            
            dev_type = @"0100";//自定义情景 任意填 硬件情景就是202 CA00
            
        }else{//如果是硬件情景
            
            dev_type = @"CA00";//自定义情景 任意填 硬件情景就是202 CA00
            
        }
        
        NSString *header = @"42424141";//发送给服务器的报头
        
        NSString *stamp = @"30303030";//没有用到的字段
        
        NSString *gw_id = theme.gateway_No;
        
        NSString *dev_id = theme.device_No;
        
        NSString *data_type = @"0f00";//控制情景 13
        
        NSString *theme_no = theme.theme_No;
        
        deviceMessage *sensorDevice = [[deviceMessage  alloc]init];
        
        sensorDevice.GATEWAY_NO = theme.gateway_No;
        sensorDevice.DEVICE_NO = theme.device_No;
        NSArray *sensorDeviceArray = [deviceMessageTool queryWithDeviceNumDevices:sensorDevice];
        
        NSString *theme_state;
        NSString *item_trigger_stateused ;
        
        NSString *item_triggerDevice_Type;
        if ([theme.theme_State  isEqualToString:@"00000000"]) {//如果是自定义情景
            
            item_triggerDevice_Type = @"01000000";//自定义情景 任意填 硬件情景就是202 CA00
            
        }else{//如果是硬件情景
            
            item_triggerDevice_Type = @"ca000000";//自定义情景 任意填 硬件情景就是202 CA00
            
        }
        
        if (sensorDeviceArray.count ==0 ) {//没有安防类设备 或者是软件情景
            
            theme_state= [ControlMethods  transThemeCoding:theme.theme_State];
            item_trigger_stateused = @"04000000";
            item_triggerDevice_Type = @"01000000";
        }else{//有此安防类设备  则查出devicetypeid  110 113 115 118 四报警类设备 或者有风扇
            deviceMessage *sensorDevice = sensorDeviceArray[0];
            switch (sensorDevice.DEVICE_TYPE_ID) {
                case 110:
                    
                    theme_state= [ControlMethods  transThemeCoding:@"01000000"];
                    item_trigger_stateused = @"08000000";
                    
                    break;
                    
                case 113:
                    
                    theme_state= [ControlMethods  transThemeCoding:@"01000000"];
                    item_trigger_stateused = @"08000000";
                    
                    break;
                case 115:
                    
                    theme_state= [ControlMethods  transThemeCoding:@"01000000"];
                    item_trigger_stateused = @"08000000";
                    
                    break;
                case 118:
                    
                    theme_state= [ControlMethods  transThemeCoding:@"01000000"];
                    item_trigger_stateused = @"08000000";
                    
                    break;
                default:
                    theme_state= [ControlMethods  transThemeCoding:theme.theme_State];
                    item_trigger_stateused = @"04000000";
                    break;
                    
            }
            
            if (sensorDevice.DEVICE_TYPE_ID !=51) {
                
                item_triggerDevice_Type = [[ControlMethods ToHex:sensorDevice.DEVICE_TYPE_ID]  stringByAppendingString:@"000000"];
                
            }else{
                
            }
        
        }
     
        NSString *theme_mac = theme.device_No;
        
        NSString *stringInt = [NSString stringWithFormat:@"%ld",(long)theme.theme_Type];
        
        NSString *theme_type_appding = [@"0" stringByAppendingString:stringInt];
        
        NSString *theme_type = [theme_type_appding stringByAppendingString:@"000000"];
        
        NSString *Appending1 = [theme_no stringByAppendingString:theme_state];
        
        NSString *Appending2 = [Appending1 stringByAppendingString:theme_mac];
        
        NSString *Appending3 = [Appending2 stringByAppendingString:theme_type];
        
        NSString *themeNameStirngToByte = [ControlMethods  chineseWithHexString:dataCenter.theme_Name];
        
        //情景名称转码后
        NSString *themeNameToByte;
        if ([themeNameStirngToByte length] >56) {
            
            [MBProgressHUD  showError:@"情景名称过长，请重新设置"];
            
            
        }else{
            
            themeNameToByte = [ControlMethods  chineseStringToByte:themeNameStirngToByte];
            
            
            //情景名称长度 4个字节
            NSString *themeNameLegthIntToByte =  [ControlMethods  intToByte:(int)[themeNameStirngToByte length]];
            
            NSString *Appending4 = [Appending3 stringByAppendingString:themeNameLegthIntToByte];
            
            //硬件情景开关数量
            NSString *trigger_num;// = @"01000000";
            if ([theme.theme_State  isEqualToString:@"00000000"]) {//如果是自定义情景
                
                trigger_num = @"00000000";
                
            }else{//如果是硬件情景
                
                trigger_num = @"01000000";
                
            }
            
            //联动设备数量 int 型 占4个字节
            NSString *item_numIntToHex = [ControlMethods ToHex:themeDevice.count];
            
            NSString *item_num = [item_numIntToHex stringByAppendingString:@"000000"];
            
            //NSLog(@"item_num == %@",item_num);
            
            //硬件情景的mac地址，软件情景的话 这个字段不管 可以任意填
            NSString *item_trigger_mac = theme.device_No;

            NSString *stateAdded = @"";
           
            for (int i = 0; i<24; i ++) {
                NSString *test = [ControlMethods ToHex:0];
                
                stateAdded = [NSString  stringWithFormat:@"%@%@",stateAdded,test];
                
            }
 
            //情景状态为32个字节 将不够的用00 补充
            NSString *theme_stateAdded = [theme_state stringByAppendingString:stateAdded]
            ;
            
            //被联动所有设备的信息
            NSString *Appending5 = [Appending4 stringByAppendingString:themeNameToByte];
            
            NSString *Appending6 = [Appending5 stringByAppendingString:trigger_num];
            
            NSString *Appending7 = [Appending6 stringByAppendingString:item_num];
            
            NSString *Appending8 = [Appending7 stringByAppendingString:item_trigger_mac];
            
            NSString *Appending9 = [Appending8 stringByAppendingString:theme_stateAdded];
            
            NSString *Appending10 = [Appending9 stringByAppendingString:item_trigger_stateused];
            
            NSString *Appending11 = [Appending10 stringByAppendingString:item_triggerDevice_Type];
            
            
            NSString *data;
            
            if ([theme.theme_State  isEqualToString:@"00000000"]) {//如果是自定义情景
                data = Appending7 ;
                
            }else{//如果是硬件情景
            
                 data = Appending11;//软件
                
            }
            
            NSString *data_lenStr = [@"00" stringByAppendingString:[ControlMethods  ToHex:[data  length]/2]];
            
            NSString *data_len;
            
            if ([data_lenStr length] ==6) {
                
                data_len = [data_lenStr  substringFromIndex:2];
                
            }else{
                
                data_len = data_lenStr;
                
            }
        
            //拼接发送报文
            NSString *packet = [PacketMethods  devicePacket:header getStamp:stamp getGw_id:gw_id getDev_id:dev_id getDev_type:dev_type getData_type:data_type getData_len:data_len getData:data];
            
            NSString *deviceControlPacketStr = [packet stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
        
            if (dataCenter.networkStateFlag == 0) {//内网
                
                NSString *themeSetting = [deviceControlPacketStr  stringByReplacingCharactersInRange:NSMakeRange(0, 8) withString:@"41414444"];
                
                NSLog(@"=====内网情景 音乐 设置报文 %@=====",themeSetting);
                
                [socket sendMsg:themeSetting];
                
                [socket receiveMsg:^(NSString *receiveInfo) {
                    
                    NSLog(@"==== %@== ",receiveInfo);
                    
                    NSString *receiveStr = receiveInfo;
                    
                    if ([[receiveStr  substringFromIndex:[receiveStr length]-10] isEqualToString:@"1100000000"]) {
                        
                        //主动断开socket连接
                        [socket  closeSocket];
                        
                        //重新建立socket连接
                        [self  connectToSocket];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MBProgressHUD  showSuccess:@"情景设置完成"];
                            
                        });
                        
                        
                    }
                    
                    if ([[receiveStr  substringFromIndex:[receiveStr length]-10] isEqualToString:@"0f00000000"]) {
                        
                        [self musicThemePackets];
                        
                        
                    }
                    
                }];
                
            }else{
                
                //发送报文到对应设备
                //打印报文
                NSLog(@"====外网情景 音乐 设置报文 == %@====",deviceControlPacketStr);
                
                
                [ControlMethods  controlDeviceHTTPmethods:deviceControlPacketStr ];
                
                [self musicThemePackets];
                [MBProgressHUD  showSuccess:@"情景设置完成"];
                
                
            }
            
            
        }

        
    }else{
        
        [self setThemeAction:themeDevice];
        
    }
    
    [MBProgressHUD  hideHUD];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)),
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                       
                       [self  asyncThemeInfraListToServer];
                   });
    
}
-(void)setThemeAction:(NSArray *)themeDevice{
    
    LZXDataCenter  *dataCenter = [LZXDataCenter defaultDataCenter];
    
    SocketManager *socket = [SocketManager shareSocketManager];
    
    themeDeviceMessage  *theme = themeDevice[0];
    
    // NSLog(@"theme.theme_no %@",theme.theme_no);
    
    NSString *dev_type;
    
    if ([theme.theme_state  isEqualToString:@"00000000"]) {//如果是自定义情景
        
        dev_type = @"0100";//自定义情景 任意填 硬件情景就是202 CA00
        
    }else{//如果是硬件情景
        
        dev_type = @"CA00";//自定义情景 任意填 硬件情景就是202 CA00
        
    }
    
    NSString *header = @"42424141";//发送给服务器的报头
    
    NSString *stamp = @"30303030";//没有用到的字段
    
    NSString *gw_id = theme.gateway_No;
    
    NSString *dev_id = theme.theme_device_No;
    
    NSString *data_type = @"0f00";//控制情景 13
    
    NSString *theme_no = theme.theme_no;
    
    deviceMessage *sensorDevice = [[deviceMessage  alloc]init];
    
    sensorDevice.GATEWAY_NO = theme.gateway_No;
    sensorDevice.DEVICE_NO = theme.theme_device_No;
    NSArray *sensorDeviceArray = [deviceMessageTool queryWithDeviceNumDevices:sensorDevice];
    //
    //        NSLog(@"======%@======%@====",sensorDevice.GATEWAY_NO,sensorDevice.DEVICE_NO);
    //
    //        NSLog(@"==sensorDeviceArray.count=%lu===",(unsigned long)sensorDeviceArray.count);
    
    NSString *theme_state;
    NSString *item_trigger_stateused ;
    
    NSString *item_triggerDevice_Type;
    if ([theme.theme_state  isEqualToString:@"00000000"]) {//如果是自定义情景
        
        item_triggerDevice_Type = @"01000000";//自定义情景 任意填 硬件情景就是202 CA00
        
    }else{//如果是硬件情景
        
        item_triggerDevice_Type = @"ca000000";//自定义情景 任意填 硬件情景就是202 CA00
        
    }
    
    if (sensorDeviceArray.count ==0 ) {//没有安防类设备 或者是软件情景
        
        theme_state= [ControlMethods  transThemeCoding:theme.theme_state];
        item_trigger_stateused = @"04000000";
        item_triggerDevice_Type = @"01000000";
    }else{//有此安防类设备  则查出devicetypeid  110 113 115 118 四报警类设备 或者有风扇
        
        deviceMessage *sensorDevice = sensorDeviceArray[0];
        switch (sensorDevice.DEVICE_TYPE_ID) {
            case 110:
                
                theme_state= [ControlMethods  transThemeCoding:@"01000000"];
                item_trigger_stateused = @"08000000";
                
                break;
                
            case 113:
                
                theme_state= [ControlMethods  transThemeCoding:@"01000000"];
                item_trigger_stateused = @"08000000";
                
                break;
            case 115:
                
                theme_state= [ControlMethods  transThemeCoding:@"01000000"];
                item_trigger_stateused = @"08000000";
                
                break;
            case 118:
                
                theme_state= [ControlMethods  transThemeCoding:@"01000000"];
                item_trigger_stateused = @"08000000";
                
                break;
            default:
                theme_state= [ControlMethods  transThemeCoding:theme.theme_state];
                item_trigger_stateused = @"04000000";
                break;
                
        }
        
        if (sensorDevice.DEVICE_TYPE_ID !=51) {
            
            item_triggerDevice_Type = [[ControlMethods ToHex:sensorDevice.DEVICE_TYPE_ID]  stringByAppendingString:@"000000"];
            
        }else{
            
        }
        
        
    }
    
    
    NSString *theme_mac = theme.theme_device_No;
    
    NSString *stringInt = [NSString stringWithFormat:@"%ld",(long)theme.theme_type];
    
    NSString *theme_type_appding = [@"0" stringByAppendingString:stringInt];
    
    NSString *theme_type = [theme_type_appding stringByAppendingString:@"000000"];
    
    NSString *Appending1 = [theme_no stringByAppendingString:theme_state];
    
    NSString *Appending2 = [Appending1 stringByAppendingString:theme_mac];
    
    NSString *Appending3 = [Appending2 stringByAppendingString:theme_type];
    
    NSString *themeNameStirngToByte = [ControlMethods  chineseWithHexString:dataCenter.theme_Name];
    
    //情景名称转码后
    NSString *themeNameToByte;
    if ([themeNameStirngToByte length] >56) {
        
        [MBProgressHUD  showError:@"情景名称过长，请重新设置"];
        
        
    }else{
        
        themeNameToByte = [ControlMethods  chineseStringToByte:themeNameStirngToByte];
        
        
        //情景名称长度 4个字节
        NSString *themeNameLegthIntToByte =  [ControlMethods  intToByte:(int)[themeNameStirngToByte length]];
        
        NSString *Appending4 = [Appending3 stringByAppendingString:themeNameLegthIntToByte];
        
        //硬件情景开关数量
        NSString *trigger_num;// = @"01000000";
        if ([theme.theme_state  isEqualToString:@"00000000"]) {//如果是自定义情景
            
            trigger_num = @"00000000";
            
        }else{//如果是硬件情景
            
            trigger_num = @"01000000";
            
        }
        
        //联动设备数量 int 型 占4个字节
        NSString *item_numIntToHex = [ControlMethods ToHex:themeDevice.count];
        
        NSString *item_num = [item_numIntToHex stringByAppendingString:@"000000"];
        
        //NSLog(@"item_num == %@",item_num);
        
        //硬件情景的mac地址，软件情景的话 这个字段不管 可以任意填
        NSString *item_trigger_mac = theme.theme_device_No;
        
        //NSLog(@"item_trigger_mac == %@",item_trigger_mac);
        
        //硬件情景的设备状态 软件情景不管
        //NSString *item_trigger_state = [ControlMethods  transThemeCoding:theme.theme_state]; 2016年9月7日晚注释掉
        
        NSString *stateAdded = @"";
        for (int i = 0; i<24; i ++) {
            NSString *test = [ControlMethods ToHex:0];
            
            stateAdded = [NSString  stringWithFormat:@"%@%@",stateAdded,test];
            
        }
        
        
        //情景状态为32个字节 将不够的用00 补充
        NSString *theme_stateAdded = [theme_state stringByAppendingString:stateAdded]
        ;
        
        
        //被联动所有设备的信息
        NSString *itme_itme = [self itemDeviceMseeage];
        
        NSString *Appending5 = [Appending4 stringByAppendingString:themeNameToByte];
        
        NSString *Appending6 = [Appending5 stringByAppendingString:trigger_num];
        
        NSString *Appending7 = [Appending6 stringByAppendingString:item_num];
        
        NSString *Appending8 = [Appending7 stringByAppendingString:item_trigger_mac];
        
        NSString *Appending9 = [Appending8 stringByAppendingString:theme_stateAdded];
        
        NSString *Appending10 = [Appending9 stringByAppendingString:item_trigger_stateused];
        
        NSString *Appending11 = [Appending10 stringByAppendingString:item_triggerDevice_Type];
        
        
        NSString *data;
        
        if ([theme.theme_state  isEqualToString:@"00000000"]) {//如果是自定义情景
            
            data = [Appending7 stringByAppendingString:itme_itme];
            
        }else{//如果是硬件情景
            
            data = [Appending11 stringByAppendingString:itme_itme];//软件
        }
        
        NSString *data_lenStr = [@"00" stringByAppendingString:[ControlMethods  ToHex:[data  length]/2]];
        
        NSString *data_len;
        
        if ([data_lenStr length] ==6) {
            
            data_len = [data_lenStr  substringFromIndex:2];
            
        }else{
            
            data_len = data_lenStr;
            
        }
        //拼接发送报文
        NSString *packet = [PacketMethods  devicePacket:header getStamp:stamp getGw_id:gw_id getDev_id:dev_id getDev_type:dev_type getData_type:data_type getData_len:data_len getData:data];
        
        NSString *deviceControlPacketStr = [packet stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
        
        
        if (dataCenter.networkStateFlag == 0) {//内网
            
            NSString *themeSetting = [deviceControlPacketStr  stringByReplacingCharactersInRange:NSMakeRange(0, 8) withString:@"41414444"];
            
            NSLog(@"=====内网情景设置报文 %@=====",themeSetting);
            
            [socket sendMsg:themeSetting];
            
            [socket receiveMsg:^(NSString *receiveInfo) {
                
                NSLog(@"==== %@== ",receiveInfo);
                
                NSString *receiveStr = receiveInfo;
                
                if ([[receiveStr  substringFromIndex:[receiveStr length]-10] isEqualToString:@"1100000000"]) {
                    
                    //主动断开socket连接
                    [socket  closeSocket];
                    
                    //重新建立socket连接
                    [self  connectToSocket];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD  showSuccess:@"情景设置完成"];
                        
                    });
                    
                    
                }
                
                if ([[receiveStr  substringFromIndex:[receiveStr length]-10] isEqualToString:@"0f00000000"]) {
                    
                    [self themeSettingFinsh];
                    
                    
                }
                
            }];
            
        }else{
            
            //发送报文到对应设备
            //打印报文
            NSLog(@"====外网情景设置报文 == %@====",deviceControlPacketStr);
            [ControlMethods  controlDeviceHTTPmethods:deviceControlPacketStr ];
            [self themeSettingFinsh];
            [MBProgressHUD  showSuccess:@"情景设置完成"];
       
        }
    }

}

-(void)connectToSocket{
    
    NSArray * gateways=[gatewayMessageTool   queryWithgateways];
    NSString * gatewayNo;
    NSString * gatewayPwd;
    NSString *gatewayIP;
    
    if (gateways.count!=0) {
        
        gatewayMessageModel *gatewayModel = gateways[0];//业务逻辑中 只有一个网关
        gatewayNo = gatewayModel.gatewayID;
        gatewayPwd = gatewayModel.gatewayPWD;
        gatewayIP = gatewayModel.gatewyIP;
        
    }
    
    SocketManager *socket = [SocketManager  shareSocketManager];
    
    NSString *head = @"4141444430303030";
    
    NSString *datas = [@"000000000000000032001C000008"  stringByAppendingString:[ControlMethods stringToByte:gatewayPwd]];
    
    NSString *gatewayConnectStr1 = [head  stringByAppendingString:gatewayNo];
    
    NSString *gatewayConnectStr = [gatewayConnectStr1 stringByAppendingString:datas];
    
    [socket startConnectHost:gatewayIP WithPort:9091];
    
    [socket sendMsg:gatewayConnectStr];
    
}

/**
 *  发送情景设置报文 给网关
 */
-(void)themeSettingFinsh{
    
    SocketManager *socket = [SocketManager  shareSocketManager];
    
    LZXDataCenter  *dataCenter = [LZXDataCenter defaultDataCenter];
    
    themeDeviceMessage *themeNo = [[themeDeviceMessage alloc]init];
    
    themeNo.theme_no = dataCenter.theme_No;
    
    NSArray *themeDevice = [themeDeviceMessageTool  queryWithThemeNoDevices:themeNo];
    
    themeDeviceMessage  *theme = themeDevice[0];

    NSString *header = @"42424141";//发送给服务器的报头
    
    NSString *stamp = @"00000000";//没有用到的字段
    
    NSString *gw_id = theme.gateway_No;
    
    NSString *dev_id = theme.theme_device_No;
    
    NSString *dev_type = @"3200";
    
    NSString *data_type = @"1100";//控制情景 13
    
    NSString *data_len = @"0001";
    
    NSString *data = @"30";
    
    //拼接发送报文
    NSString *packet = [PacketMethods  devicePacket:header getStamp:stamp getGw_id:gw_id getDev_id:dev_id getDev_type:dev_type getData_type:data_type getData_len:data_len getData:data];
    
    NSString *deviceControlPacketStr = [packet stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
    
    //打印报文
    
    if (dataCenter.networkStateFlag ==0) {//内网
        
        NSString *themeSetting = [deviceControlPacketStr  stringByReplacingCharactersInRange:NSMakeRange(0, 8) withString:@"41414444"];
        
        [socket  sendMsg:themeSetting];
        
        NSLog(@"=====内网 情景 设置报文===%@======",themeSetting);
        
    }else{
        
        NSLog(@"====外网 情景 设置报文==%@====",deviceControlPacketStr);
        //发送报文到对应设备
        [ControlMethods  controlDeviceHTTPmethods:deviceControlPacketStr ];
        
    }
    
}

-(void)musicThemePackets{
    
    SocketManager *socket = [SocketManager  shareSocketManager];
    
    LZXDataCenter  *dataCenter = [LZXDataCenter defaultDataCenter];
    
    themMessageModel  *themeModel= [[themMessageModel alloc]init]
    ;
    
    themeModel.theme_No = dataCenter.theme_No;
    
    themMessageModel  *theme = [themeMessageTool queryThemeWithThemeNum:themeModel][0];
    
    NSString *header = @"42424141";//发送给服务器的报头
    
    NSString *stamp = @"00000000";//没有用到的字段
    
    NSString *gw_id = theme.gateway_No;
    
    NSString *dev_id = theme.device_No;
    
    NSString *dev_type = @"3200";
    
    NSString *data_type = @"1100";//控制情景 13
    
    NSString *data_len = @"0001";
    
    NSString *data = @"30";
    
    //拼接发送报文
    NSString *packet = [PacketMethods  devicePacket:header getStamp:stamp getGw_id:gw_id getDev_id:dev_id getDev_type:dev_type getData_type:data_type getData_len:data_len getData:data];
    
    NSString *deviceControlPacketStr = [packet stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
    //打印报文
    
    if (dataCenter.networkStateFlag ==0) {//内网
        
        NSString *themeSetting = [deviceControlPacketStr  stringByReplacingCharactersInRange:NSMakeRange(0, 8) withString:@"41414444"];
        
        [socket  sendMsg:themeSetting];
        NSLog(@"=====内网情景 音乐 设置保存报文===%@======",themeSetting);
        
    }else{
        NSLog(@"====外网情景 音乐 设置保存报文==%@====",deviceControlPacketStr);
        //发送报文到对应设备
        [ControlMethods  controlDeviceHTTPmethods:deviceControlPacketStr ];
        
    }
    

}


/**
 *  硬件情景下联动的设备信息 deviceNo[8] deviceState[32] dataLegth[4]  deviceType[4]
 */
-(NSString *)itemDeviceMseeage{
    
    NSString *str;
    NSInteger count;
    LZXDataCenter  *dataCenter = [LZXDataCenter defaultDataCenter];
    
    themeDeviceMessage *themeNo = [[themeDeviceMessage alloc]init];
    
    themeNo.theme_no = dataCenter.theme_No;
    
    NSArray *themeDeviceArray = [themeDeviceMessageTool  queryWithThemeNoDevices:themeNo];
    
    //    NSLog(@"  themeDeviceArray = %lu  themeNo.theme_no %@ ",(unsigned long)themeDeviceArray.count,themeNo.theme_no);
    
    if (themeDeviceArray.count == 0) {
        
        [MBProgressHUD  showError:@"请添加设备"];
       
    }else{
        
        NSString *allDeviceMseeage = @"";
        
        for (int j = 0; j<themeDeviceArray.count; j++) {
            
            themeDeviceMessage *themeDevice = themeDeviceArray[j];
            if (themeDevice.device_state_cmd.length <=64) {
                
                
                //联动设备的mac地址
                NSString *deviceNo = [NSString  stringWithFormat:@"%@",themeDevice.device_No];
                
                deviceMessage  *deviceModel = [[deviceMessage  alloc]init];
                
                deviceModel.DEVICE_NO = themeDevice.device_No;
                deviceModel.GATEWAY_NO = dataCenter.gatewayNo;
                
                NSArray *device_Array =  [deviceMessageTool  queryWithDeviceNumDevices:deviceModel];
                
                //           NSLog(@"  device_Array = %lu  deviceModel.DEVICE_NO %@  deviceModel.GATEWAY_NO %@      ",(unsigned long)device_Array.count,deviceModel.DEVICE_NO,deviceModel.GATEWAY_NO);
                if (device_Array.count !=0) {
                    deviceMessage  *deviceMessages = device_Array[0];
                    
                    NSString *deviceState;
                    
                    if((deviceMessages.DEVICE_TYPE_ID == 5)|((deviceMessages.DEVICE_TYPE_ID == 105))|(deviceMessages.DEVICE_TYPE_ID == 110) | (deviceMessages.DEVICE_TYPE_ID == 113)|(deviceMessages.DEVICE_TYPE_ID == 115)|(deviceMessages.DEVICE_TYPE_ID == 118)){
                        if (deviceMessages.DEVICE_TYPE_ID == 5) {
                            
                            //联动设备的状态
                            deviceState = [NSString  stringWithFormat:@"%@",[ControlMethods  ToHex:[themeDevice.device_state_cmd intValue]]];
                            count = [deviceState length]/2;
                            
                        }else if(deviceMessages.DEVICE_TYPE_ID == 105){
                            //联动设备的状态
                            deviceState = themeDevice.device_state_cmd;
                             count = [deviceState length]/2;
                        }else{
                            
                            //联动设备的状态
                            deviceState = [NSString  stringWithFormat:@"%@",[ControlMethods  transThemeCoding:themeDevice.device_state_cmd]];
                             count = [deviceState length]/2;
                        }
                        
                    }else{
                        
                        //联动设备的状态
                        deviceState = [NSString  stringWithFormat:@"%@",[ControlMethods  transCoding:themeDevice.device_state_cmd]];
                         count = [deviceState length]/2;
                    }
                    
                    
                    NSString *stateAdded = @"";
                    
                    for (int i = 0; i<32-count; i ++) {
                        
                        NSString *test = [ControlMethods ToHex:0];
                        
                        stateAdded = [NSString  stringWithFormat:@"%@%@",stateAdded,test];
                        
                    }
                    
                    //联动设备的状态为32个字节 其余的补0  补充完之后 完整的设备状态报文
                    NSString *deviceStateWithAdded = [deviceState  stringByAppendingString:stateAdded];
                    
                    
                    
                    
                    NSString *item_numInt =[ControlMethods  ToHex:count];
                    
                    //将有效的字节数 封装成4个字节的nsstring格式
                    NSString *item_num = [item_numInt stringByAppendingString:@"000000"];
                    
                    //根据联动设备的mac地址 在devicetable表中 找的此设备的信息
                    deviceMessage  *device = [[deviceMessage  alloc]init];
                    device.DEVICE_NO = themeDevice.device_No;
                    
                    device.GATEWAY_NO = dataCenter.gatewayNo;
                    NSArray *deviceArray =  [deviceMessageTool  queryWithDeviceNumDevices:device];
                    
                    deviceMessage  *deviceMessage = deviceArray[0];
                    
                    NSString *item_deviceTypeInt = [ControlMethods  ToHex:deviceMessage.DEVICE_TYPE_ID];
                    //在devicetable 表中找到设备的DEVICE_TYPE_ID  并且封装成4个字节的nsstriing 格式
                    NSString *item_deviceType = [item_deviceTypeInt  stringByAppendingString:@"000000"];
                    
                    //将联动设备的 mac地址 设备状态 设备状态的有效字节数 设备类型 封装成一条完整的报文
                    NSString *appending = [deviceNo stringByAppendingString:deviceStateWithAdded];
                    NSString *appending1 = [appending  stringByAppendingString:item_num];
                    NSString *item_device_message = [appending1  stringByAppendingString:item_deviceType];
                    
                    allDeviceMseeage = [NSString  stringWithFormat:@"%@%@",allDeviceMseeage,item_device_message];
                    
                }

            }
            str =  allDeviceMseeage;
        }
        // NSLog(@"联动设备的信息 == %@",allDeviceMseeage);
    }
    
    [MBProgressHUD  hideHUD];
    
    return str;
}

//同步themeInfra表给服务器
-(void)asyncThemeInfraListToServer{
    
    //创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager  manager];
    mgr.responseSerializer = [AFJSONResponseSerializers  serializer];
    
    //配置请求超时时间
    mgr.requestSerializer.timeoutInterval = 60;
    
    //设置请求参数
    NSMutableDictionary  *params = [NSMutableDictionary  dictionary];
    
    NSString *deviceString = [[self allThemeInfraDeviceList]componentsJoinedByString:@","];
    
    NSString *string = [@"["  stringByAppendingString:deviceString];
    
    NSString *deviceStringJson = [string  stringByAppendingString:@"]"];//修改20161023
   
    params[@"infraJson"] = deviceStringJson;
    
    //NSLog(@"infraJson %@",params[@"infraJson"]);
    
    
    NSString  *urlStr =[NSString  stringWithFormat:@"%@/appSendInfrared" ,HomecooServiceURL];
    NSString *url = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
    
    if ([deviceStringJson isEqualToString:@"[]"]) {//没有任何数据
      
    }else{
    
        [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            
            NSString  *result = [responseObject[@"result"]description];
            
            if ([result  isEqual:@"success"]) {//同步成功
                
            }
            if ([result  isEqual:@"failed"]) {
                
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];

    
    }
    
}

-(NSArray *)allThemeInfraDeviceList{
    
    NSArray  *devicesArray;
    
    LZXDataCenter *gateway = [LZXDataCenter defaultDataCenter];
    
    themeInfraModel *device = [[themeInfraModel alloc]init];
    
    device.gatewayNo = gateway.gatewayNo;//当前网关下的 所有设备
    
    devicesArray=[themeInfraModelTools querWithInfraThemesByGW:device];
    
    
    NSMutableArray  *deviceArray =[[NSMutableArray  alloc]init];
    NSString *deviceJson = @"";
    
    if (devicesArray.count == 0) {
        
    }else{
        
        for (int i = 0; i<devicesArray.count; i++) {
            themeInfraModel *device = devicesArray[i];
            
            NSDictionary  *dict = @{@"deviceNo":device.deviceNo,
                                    @"deviceStateCmd":device.deviceState_Cmd,
                                    @"gatewayNo":device.gatewayNo,
                                    @"infraCrlName":device.infraControlName,
                                    @"infraTypeId":[NSString stringWithFormat:@"%ld",(long)device.infraType_ID],
                                    @"themeNo":device.themeNo
                                   
                                    };
            //将字典转换成json串
            NSData  *jsonData = [NSJSONSerialization  dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil  ];
            
            deviceJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            deviceArray[i] = deviceJson;
            
        }
    }
    return deviceArray;
}


- (void)initViewControllers {
  
    remoteViewController *controller1 = [[remoteViewController alloc] init];
    controller1.yp_tabItemTitle = @"遥控";
    
    lightViewController *controller2 = [[lightViewController alloc] init];
    controller2.yp_tabItemTitle = @"照明";
    
    sockViewController *controller3 = [[sockViewController alloc] init];
    controller3.yp_tabItemTitle = @"插座";
    
    windowsViewController *controller4 = [[windowsViewController alloc] init];
    controller4.yp_tabItemTitle = @"门窗";
    
    microViewController *controller5 = [[microViewController alloc] init];
    controller5.yp_tabItemTitle = @"微控";
    
    musicViewController *controller6 = [[musicViewController alloc] init];
    controller6.yp_tabItemTitle = @"音乐";
    
    self.viewControllers = [NSMutableArray arrayWithObjects:controller1, controller2, controller3, controller4, controller5, controller6, nil];
    
}
-(BOOL)shouldAutorotate{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskLandscape;
    
}
@end
