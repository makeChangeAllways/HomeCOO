//
//  ThemeAdministrationController.m
//  HomeCOO
//
//  Created by tgbus on 16/6/30.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "ThemeAdministrationController.h"
#import "AppDelegate.h"
#import "SystemViewController.h"
#import "SpaceViewController.h"
#import "ThemeViewController.h"
#import "SecurityViewController.h"
#import "SettingViewController.h"
#import "mainViewViewController.h"
#import "MethodClass.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworkings.h"
#import "PrefixHeader.pch"
#import "alertViewModel.h"
#import "spaceMessageModel.h"
#import "spaceMessageTool.h"
#import "spaceCollectionViewCell.h"
#import "gatewayMessageModel.h"
#import "gatewayMessageTool.h"
#import "NSString+Hash.h"
#import "ThemeCollectionViewCell.h"
#import "themMessageModel.h"
#import "themeMessageTool.h"
#import "themeDeviceMessage.h"
#import "themeDeviceMessageTool.h"
#import "externValue.h"
#import "LZXDataCenter.h"
#import "ControlMethods.h"
#import "PacketMethods.h"
#import "transCodingMethods.h"
#import "SocketManager.h"
#import "alarmMessages.h"
#import "alarmMessagesTool.h"
#import "deviceMessage.h"
#import "deviceMessageTool.h"
#import "alarmRinging.h"
#import "deviceSpaceMessageModel.h"
#import "deviceSpaceMessageTool.h"
#import "UnscrollTabController.h"
#import "HCDaterView.h"
#import "HSAddspaceDaterView.h"
#import "themeInfraModel.h"
#import "themeInfraModelTools.h"

//底部空间、情景模式等按钮的高度
#define HOMECOOSPACEBUTTONHEIGHT 60

//底部空间、情景模式等按钮的宽度
#define HOMECOOSPACEBUTTONWIDTH [UIScreen  mainScreen].bounds.size.width / 5

//底部空间、情景模式等按钮Y的大小
#define  HOMECOOSPACEBUTTON_Y  [UIScreen  mainScreen].bounds.size.height - 55

//底部空间、情景模式等按钮字体的大小
#define HOMESPACEFONT 13

//网关标签距离左边的距离
#define   HOMECOOLEFTEDGE [UIScreen  mainScreen].bounds.size.width /4

//网关标签距离上边的距离
#define   HOMECOOTOPEDGE   [UIScreen  mainScreen].bounds.size.height / 4

//网关标签的宽度
#define   HOMECOOLABLEWIDTH  [UIScreen  mainScreen].bounds.size.width /7

//网关输入框的宽度
#define   HOMECOOFIELDWIDTH  [UIScreen  mainScreen].bounds.size.width /3

@interface ThemeAdministrationController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextFieldDelegate,HCDaterViewDelegate,HSAddspaceDaterViewDelegate>


/**设置背景图片*/
@property(nonatomic,weak)  UIImageView  * fullscreenView;

/**设置导航栏*/
@property(nonatomic,weak)  UINavigationBar *navBar;

/**设置白色背景*/
@property(nonatomic,weak) UILabel  *WhiteBackgroundLable;

/**设置提示框背景*/
@property(nonatomic,weak)UILabel  *WhiteBackground;

/**设置蒙版*/
@property(nonatomic,weak) UIView  *backgroundView;

@property(nonatomic,strong) HCDaterView *showView;

@property(nonatomic,strong) HSAddspaceDaterView *showThemeView;

/**UICollectionView 容器*/
@property (weak, nonatomic)  UICollectionView *collectionView;

/**网关cell */
@property(nonatomic,weak) ThemeCollectionViewCell *cell;

@property(nonatomic,weak)  UITextField *themeNameField;

@property(nonatomic,strong)  NSArray  *theme;
@property(nonatomic,strong) themeInfraModel *InfraDevices;
@property(nonatomic,strong) themeInfraModel *updataInfraDevices;
/**用来接收服务器返回的空间信息*/
@property(nonatomic,weak)  NSArray * themeListArray;

@property(nonatomic,strong) UIAlertView * alert;

@property(nonatomic,copy) NSString * alarmString;

@property(nonatomic,copy) NSString *alertString;

@property(nonatomic,strong) LZXDataCenter *dataCenter;

@property(nonatomic,strong) NSString *str;

@property(nonatomic,strong) NSArray *themeArray;

@property(nonatomic,strong)  deviceSpaceMessageModel *deviceSpace;
@property(nonatomic,strong) NSArray *InfraDeviceListArray;
@end


static NSString *string = @"ThemeCollectionViewCell";

static  NSInteger indexNum;

@implementation ThemeAdministrationController

-(NSArray*)theme{

    if (_theme==nil) {
        
        
        LZXDataCenter *themeDevice = [LZXDataCenter defaultDataCenter];
        
        if ([themeDevice.gatewayNo isEqualToString:@"0"] | !themeDevice.gatewayNo ) {
            
            [MBProgressHUD  showError:@"请先添加主机"];
            
        }else{
            
            themMessageModel *theme = [[themMessageModel alloc]init];
            
            theme.gateway_No = themeDevice.gatewayNo;
            
            _theme=[themeMessageTool queryWiththemes:theme];
            
           
        }
        
        [MBProgressHUD  hideHUD];
      
        
    }
    
    return _theme;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //设置背景
    [self setFullscreenView];
    
    //创建一个导航栏
    [self setNavBar];
    
    LZXDataCenter *dataCenter = [LZXDataCenter  defaultDataCenter];
    
    self.dataCenter = dataCenter;
    
    //设置底片背景
    [self  setWhiteBackground];
    
    
    //添加情景
    [self  setupNewTheme];
    
    //添加UICollectionView
    [self  addUICollectionView];
    
    if (dataCenter.networkStateFlag == 0) {//内网
        //删除情景表
        [themeDeviceMessageTool  deleteThemeDeviceTable];
        
        [themeMessageTool deleteThemeTable];
        [self  receivedFromGateway_deviceMessage];
        
    }else{
       
        //外网获取所有情景
        [self getAllThemes];
    
    }
    
    
}

-(NSString*)getAllThemesFromLocal{
    
    NSString *header = @"41414444";//发送给服务器的报头
    
    NSString *stamp = @"00000000";//没有用到的字段
    
    NSString *gw_id = _dataCenter.gatewayNo;
    
    NSString *dev_id = @"3030303030303030";
    
    NSString *dev_type = @"3200";
    
    NSString *data_type = @"0e00";//情景删除18
    
    NSString *data_len = @"0008";
    
    NSString *data = @"5457525432303135";
    
    //拼接发送报文
    NSString *packet = [PacketMethods  devicePacket:header getStamp:stamp getGw_id:gw_id getDev_id:dev_id getDev_type:dev_type getData_type:data_type getData_len:data_len getData:data];
    
    NSString *deviceControlPacketStr = [packet stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
    
    NSLog(@"    内网获取所有情景报文  %@",deviceControlPacketStr);
   
    return  deviceControlPacketStr;

}

/**
 *  内网情况下，接收底层设备手动出发报上来的信息（用于更新设备状态）
 *
 *  @return
 */

-(void)receivedFromGateway_deviceMessage{
    
    SocketManager  *socket = [SocketManager  shareSocketManager];
     
    [socket sendMsg:[self  getAllThemesFromLocal]];
    
    [socket receiveMsg:^(NSString *receiveInfo) {
        

        NSString *receiveMessage = receiveInfo;
        
        _str  =[NSString stringWithFormat:@"%@%@",_str,receiveInfo];
 
        NSString*  gw_id;//内网情况下 退网的时候 设备的id 全部是0
        
        if (receiveMessage.length>31) {
            gw_id= [receiveMessage  substringWithRange:NSMakeRange(16, 16)];
        
        
        if ([gw_id  isEqualToString:@"0000000000000000"]) {
            
            
            gw_id = _dataCenter.gatewayNo;
            
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
        
    
    }
     }];
   
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2* NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       
                       NSArray *array = [_str componentsSeparatedByString:@"41414444"];
                       
                       _themeArray = array;
                       
                       [self  updateThemeList];
                       
                   });
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
            
            [alterView  show];
            
        });
    }
    
    
}

/**
 *  判断是否是确定按键被点击
 *
 *  @param alertView   提醒view
 *  @param buttonIndex 确定哪个按钮被点击
 */

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
    SocketManager *socket = [SocketManager shareSocketManager];
    
    if (self.alert != nil) {
        
        if(buttonIndex ==1){//点击的是确定按键
            
            //删除网关
            [self deleteThemes];
            
        }
        
        self.alert = nil;
        
    }
    
    else {
        if(buttonIndex ==1){//点击的是确定按键
            //清除BadgeNumber为0
     
            self.alertString = @"1";
            
            [socket  sendMsg:self.alarmString];
            
            
        }if (buttonIndex == 0) {//点击的是取消按键
            //清除BadgeNumber为0
            
            self.alertString = @"1";
            
        }
    
    }
    
}

/**
 *  从服务器获取所有情景是通过jpush 推送过来的
 */
-(void)getAllThemes{

    [themeMessageTool  deleteThemeTable];
    
    //创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager  manager];
    mgr.responseSerializer = [AFJSONResponseSerializers  serializer];
    //配置请求超时时间
    mgr.requestSerializer.timeoutInterval = 60;

    //设置请求参数
    NSMutableDictionary  *params = [NSMutableDictionary  dictionary];
    params[@"gatewayNo"] = _dataCenter.gatewayNo;

    
    NSString  *urlStr =[NSString  stringWithFormat:@"%@/appGetAllTheme" ,HomecooServiceURL];
    NSString *url = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
    [mgr  POST:url parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        //打印日志
        //NSLog(@"请求成功--%@",responseObject);
        
        NSString  *result = [responseObject[@"result"]description];
        
        //服务器返回的设备表信息
        NSArray *themeListArray = responseObject[@"packetList" ];
        
        self.themeListArray = themeListArray;
        
        if ([result  isEqual:@"success"]) {
            
            
            [self updatePacketList];
           
            //外网获取情景成功后 调用服务器appGetInfraredByGatewayNo 接口 获取
            //themeInfra信息
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)),
                           dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                              
                               [self  getAllInfraDevicesFormServer];
                           });
           
        } if ([result  isEqual:@"failed"]) {
            
            [MBProgressHUD  showError:@"请求失败!"];
            
        }
        
        [MBProgressHUD  hideHUD];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        [MBProgressHUD  showError:@"网络繁忙，请稍后再试"];
    }];
    
}

#pragma mark updatePacketList 外网插入themeDeviceList
/**
 *  在本地数据库中插入 拉回来的服务器中设备的空间信息
 */
-(void)updatePacketList{

    NSInteger  count;
    
    if (self.themeListArray.count ==0) {
        
        count = 0;
        
    }else{
        
        count = self.themeListArray.count;
        
    }
    
  
    NSDictionary *themeDit;
    
    themMessageModel *theme = [[themMessageModel  alloc]init];
    themeDeviceMessage  *themeDevice = [[themeDeviceMessage  alloc]init];
    themeDeviceMessage *fonudDevice = [[themeDeviceMessage  alloc]init];
    //更新设备状态
    themeDeviceMessage *states = [[themeDeviceMessage  alloc]init];

    for (int i = 0; i < count; i ++) {
    
        themeDit = self.themeListArray[i];
        
        NSString *themePacket = [themeDit  objectForKey:@"packet"];
        //NSLog(@"==themePacket=%@====",themePacket);
        
        int dataLen =  strtoul([[[themePacket substringWithRange:NSMakeRange(56, 4)] substringWithRange:NSMakeRange(0, 4)] UTF8String],0,16);
        
        int  realDataLen =  [[themePacket substringFromIndex:60] length]/2;
        //判断报文的是否是合法的报文
        if ((dataLen==realDataLen) & (realDataLen>96)) {
        
            //情景名称长度
            int themeNameLen =strtoul([[[themePacket  substringWithRange:NSMakeRange(116, 2)] substringWithRange:NSMakeRange(0, 2)] UTF8String],0,16);
            
            if (themeNameLen==0) {
                
            }else{
                //将新加入的空间名称，添加到模型中
                theme.theme_Name =[ControlMethods  chineseTostring:[ControlMethods  stringFromHexString:[themePacket  substringWithRange:NSMakeRange(124, themeNameLen*2 )]] ];//
                theme.gateway_No =  [themePacket  substringWithRange:NSMakeRange(16, 16)];
                theme.device_No = [themePacket  substringWithRange:NSMakeRange(92, 16)];
                theme.theme_No = [themePacket  substringWithRange:NSMakeRange(60, 16)];
                theme.theme_State =[transCodingMethods   transThemeCodingFromServer:[themePacket  substringWithRange:NSMakeRange(76, 16)]] ;
                theme.theme_Type = [[themePacket  substringWithRange:NSMakeRange(109, 1)] intValue];
                
               
            //NSLog(@"=====theme_Name=%@===gateway_No=%@===device_No=%@==theme_No=%@==theme_State=%@==theme_Type=%ld==themeNameLen=%d=",theme.theme_Name,theme.gateway_No,theme.device_No,theme.theme_No,theme.theme_State,(long)theme.theme_Type,themeNameLen);
             
                themMessageModel *themes = [[themMessageModel  alloc]init];
                
                themes.theme_No = theme.theme_No;
                
                NSArray *themesArray = [themeMessageTool  queryThemeWithThemeNum:themes];
                
                if (themesArray.count == 0) {//没有此情景
                   
                    if(theme.theme_Type==4){
                        
                        theme.device_No = @"3030303030303030";
                        //添加情景
                        [themeMessageTool  addTheme:theme];
                        
                    }else{
                        //添加情景
                        [themeMessageTool  addTheme:theme];
                    }
                    
                    
                }
                
                //向themedevice表中插入新的设备
                NSString *themeDevicesMessage;
                    
                if (theme.theme_Type==1 |theme.theme_Type==3) {//硬件情景 和 安防类情景
                    
                    themeDevicesMessage =[themePacket  substringFromIndex:348];
                    
                    NSInteger devicesNum = [themeDevicesMessage length] /96;
                    
                    for (int i = 0; i < devicesNum; i++) {
                        
                        NSString *deviesMessage = [themeDevicesMessage  substringWithRange:NSMakeRange(i*96, 96)];
                        NSInteger deviceStateLen = strtoul([[deviesMessage  substringWithRange:NSMakeRange(80, 2)]  UTF8String], 0, 16);
                        NSInteger devType = strtoul([[deviesMessage  substringWithRange:NSMakeRange(88, 2)]  UTF8String], 0, 16);

                        if (devType ==5) {
                            
                            themeDevice.device_state_cmd =  [NSString  stringWithFormat:@"%lu",strtoul([[deviesMessage  substringWithRange:NSMakeRange(16, deviceStateLen*2)]UTF8String], 0, 16)];
                            
                        }else if(devType ==105){
                        
                            themeDevice.device_state_cmd = [deviesMessage substringWithRange:NSMakeRange(16, deviceStateLen*2)];
                            
                        }else{
                            
                            themeDevice.device_state_cmd =[transCodingMethods  transCodingFromServer:[deviesMessage substringWithRange:NSMakeRange(16, deviceStateLen*2)]];
                            
                        }
                        
                        themeDevice.device_No = [deviesMessage substringWithRange:NSMakeRange(0, 16)];
                        themeDevice.gateway_No = theme.gateway_No;
                        themeDevice.theme_no = theme.theme_No;
                        themeDevice.theme_device_No = theme.device_No;
                        themeDevice.theme_state =theme.theme_State;
                        themeDevice.theme_type = theme.theme_Type;
                        
                        fonudDevice.device_No = themeDevice.device_No;
                        fonudDevice.theme_no = theme.theme_No;
                        NSArray * foundDeviceArrar = [themeDeviceMessageTool queryWithThemeDevices:fonudDevice];
                        
                        if (foundDeviceArrar.count == 0) { //没有此设备 则插入新设备
                            
                            if(themeDevice.device_state_cmd !=nil){
                            
                                //向情景列表中插入联动的设备
                                
                                [themeDeviceMessageTool  addThemeDevice:themeDevice];
                            }
                            
                        }else{//更新设备状态
                            
                            states.device_state_cmd = themeDevice.device_state_cmd;
                            states.device_No =  themeDevice.device_No;
                            states.theme_no = theme.theme_No;
                            
                            if(themeDevice.device_state_cmd !=nil){
                                
                                //更新情景列表中设备的状态
                                [themeDeviceMessageTool  updateThemeDeviceState:states];
                            }
                        }
                       // NSLog(@"====themeDevice.device_No=%@====themeDevice.device_state_cmd=%@=====themeDevice.gateway_No=%@====themeDevice.theme_no=%@=====themeDevice.theme_device_No=%@=====themeDevice.theme_state=%@===themeDevice.theme_type=%ld===deviceStateLen=%ld===",themeDevice.device_No,themeDevice.device_state_cmd,themeDevice.gateway_No,themeDevice.theme_no,themeDevice.theme_device_No,themeDevice.theme_state,(long)themeDevice.theme_type,(long)deviceStateLen);
                    }
                    
                    
                }else{//软件类情景
                
                     themeDevicesMessage =[themePacket  substringFromIndex:252];
                     NSInteger devicesNum = [themeDevicesMessage length] /96;
                    
                     //NSLog(@"======%@=====",themeDevicesMessage);
                    
                     for (int i = 0; i < devicesNum; i++) {
                    
                        NSString *deviesMessage = [themeDevicesMessage  substringWithRange:NSMakeRange(i*96, 96)];
                        NSInteger deviceStateLen = strtoul([[deviesMessage  substringWithRange:NSMakeRange(80, 2)]  UTF8String], 0, 16);
                        NSInteger devType = strtoul([[deviesMessage  substringWithRange:NSMakeRange(88, 2)]  UTF8String], 0, 16);
                        
                         if (devType ==5) {
                             
                             themeDevice.device_state_cmd =  [NSString  stringWithFormat:@"%lu",strtoul([[deviesMessage  substringWithRange:NSMakeRange(16, deviceStateLen*2)]UTF8String], 0, 16)];
                             
                         }else if(devType ==105){
                             
                             themeDevice.device_state_cmd = [deviesMessage substringWithRange:NSMakeRange(16, deviceStateLen*2)];
                             
                         }else{
                             
                             themeDevice.device_state_cmd =[transCodingMethods  transCodingFromServer:[deviesMessage substringWithRange:NSMakeRange(16, deviceStateLen*2)]] ;
                             
                         }

                        themeDevice.device_No = [deviesMessage substringWithRange:NSMakeRange(0, 16)];
                        
                        themeDevice.gateway_No = theme.gateway_No;
                        themeDevice.theme_no = theme.theme_No;
                        themeDevice.theme_device_No = theme.device_No;
                        themeDevice.theme_state =theme.theme_State;
                        themeDevice.theme_type = theme.theme_Type;
                         
                         fonudDevice.device_No = themeDevice.device_No;
                         fonudDevice.theme_no = theme.theme_No;
                         NSArray * foundDeviceArrar = [themeDeviceMessageTool queryWithThemeDevices:fonudDevice];
                         
                         
                         if (foundDeviceArrar.count == 0) { //没有此设备 则插入新设备
                             if(themeDevice.device_state_cmd !=nil){
                                 
                                 //向情景列表中插入联动的设备
                                  [themeDeviceMessageTool  addThemeDevice:themeDevice];
                             }
                         }else{//更新设备状态
                             states.device_state_cmd = themeDevice.device_state_cmd;
                             states.device_No =  themeDevice.device_No;
                             states.theme_no = theme.theme_No;
                             
                             if(themeDevice.device_state_cmd !=nil){
                                 
                                 //更新情景列表中设备的状态
                                 [themeDeviceMessageTool  updateThemeDeviceState:states];
                             }
                        
                         }

    //                NSLog(@"====themeDevice.device_No=%@====themeDevice.device_state_cmd=%@=====themeDevice.gateway_No=%@====themeDevice.theme_no=%@=====themeDevice.theme_device_No=%@=====themeDevice.theme_state=%@===themeDevice.theme_type=%ld===deviceStateLen=%ld===",themeDevice.device_No,themeDevice.device_state_cmd,themeDevice.gateway_No,themeDevice.theme_no,themeDevice.theme_device_No,themeDevice.theme_state,(long)themeDevice.theme_type,(long)deviceStateLen);
                  
                 
                 }
            }
            
            }
               
        }
        

    }
    
    themMessageModel *themess = [[themMessageModel alloc]init];
    themess.gateway_No =_dataCenter.gatewayNo;
    _theme=[themeMessageTool queryWiththemes:themess];//如果情景 显示不出来 就说明是 从服务器拉的网关不对

    //刷新表格
    [_collectionView reloadData];
    
}

/**
 *  调用服务器接口
 *
 *  @param packets
 */
-(void)controlDeviceHTTPmethods:(NSString *)packets{
    
    //创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager  manager];
    mgr.responseSerializer = [AFJSONResponseSerializers  serializer];
    
    //配置请求超时时间
    mgr.requestSerializer.timeoutInterval = 60;
    
    
    //设置请求参数
    NSMutableDictionary  *params = [NSMutableDictionary  dictionary];
    params[@"devicePacketJson"] = packets;
    
    NSString  *urlStr =[NSString  stringWithFormat:@"%@/appGetThemeDevice" ,HomecooServiceURL];
    NSString *url = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
    
    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        //打印日志
        
        NSString  *result = [responseObject[@"result"]description];
        
        //NSString *message = [responseObject[@"messageInfo"]description]; 2016年9月7日晚注释掉
        
        if ([result  isEqual:@"success"]) {//成功获取验证码
            
            //[MBProgressHUD  showSuccess:[NSString  stringWithFormat:@"%@",message]];
            
            NSLog(@"=======发送命令成功=======");
            
            
        }
        if ([result  isEqual:@"failed"]) {
            
            [MBProgressHUD  hideHUD];//隐藏蒙版
            
            //[MBProgressHUD  showError:[NSString  stringWithFormat:@"%@",message]];
            NSLog(@"=======发送命令失败失败=======");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD  hideHUD];//隐藏蒙版
        [MBProgressHUD  showError:@"网络繁忙，请稍后再试"];
    }];
    
    
}


/**
 *  设置UICollectionView控件
 */
-(void)addUICollectionView{
    
    CGFloat  collectionViewX = 20 ;
    CGFloat  collectionViewY = 90 ;
    CGFloat  collectionViewW = [UIScreen mainScreen].bounds.size.width - 40;
    CGFloat  collectionViewH = [UIScreen  mainScreen].bounds.size.height -125;
    //确定是水平滚动，还是垂直滚动
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    UICollectionView  *collectionView = [[UICollectionView  alloc]initWithFrame:CGRectMake(collectionViewX, collectionViewY, collectionViewW, collectionViewH) collectionViewLayout:flowLayout];
    
    collectionView.dataSource=self;
    collectionView.delegate=self;
    collectionView.backgroundColor = [UIColor  whiteColor];
    [collectionView registerClass:[ThemeCollectionViewCell class] forCellWithReuseIdentifier:string];
    
    self.collectionView = collectionView;
    
    [self.fullscreenView addSubview:collectionView];
    
}

/**
 *  决定cell的个数
 *
 *  @param collectionView 容器
 *  @param section        章节
 *
 *  @return cell
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return  self.theme.count;
    
}


//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    _cell = [collectionView dequeueReusableCellWithReuseIdentifier:string forIndexPath:indexPath];
   
    themMessageModel  * theme = self.theme[indexPath.row];
    
    if (!_deviceSpace) {
        
        _deviceSpace = [[deviceSpaceMessageModel alloc]init];
        

    }
    
    if ([theme.device_No isEqualToString:@"3030303030303030"]) {
        _deviceSpace.device_no = @"";
        
    }else{
  
        _deviceSpace.device_no = theme.device_No;
        _deviceSpace.phone_num = _dataCenter.userPhoneNum;
   
    }
   
        NSArray *deviceSpaceArry = [deviceSpaceMessageTool queryWithspacesDeviceNoAndPhonenum:_deviceSpace];

    if (deviceSpaceArry.count == 0) {
    
        _cell.themeMessageLable.text = [NSString stringWithFormat:@"%@",theme.theme_Name];
       
    }else{
      
        deviceSpaceMessageModel *device_Name = deviceSpaceArry[0];
        
        spaceMessageModel *deviceNameModel = [[spaceMessageModel  alloc]init];
        
        deviceNameModel.space_Num = device_Name.space_no;
        
        NSArray *devicePostion = [spaceMessageTool queryWithspacesDevicePostion:deviceNameModel];
       
        spaceMessageModel *deviceName;
        
        if (devicePostion.count ==0) {
            
            _cell.themeMessageLable.text = [NSString stringWithFormat:@"%@",theme.theme_Name];
            
        }else{
            
            deviceName = devicePostion[0];
            //显示设备位置和设备名称
            _cell.themeMessageLable.text = [NSString stringWithFormat:@" %@/%@",deviceName.space_Name,theme.theme_Name];
            
            
        }

    }
   
    
    [_cell.button  addTarget:self action:@selector(enterChangeButton:) forControlEvents:UIControlEventTouchUpInside];
    return _cell;
    
}


/**
 *  按钮监听事件
 *
 *  @param btn 点击的是哪个
 */
- (void)enterChangeButton:(UIButton *)btn{
    
    ThemeCollectionViewCell *cell = (ThemeCollectionViewCell *)[[[btn superview]superview]superview];//获取cell
    
    NSIndexPath *indexPathAll = [self.collectionView indexPathForCell:cell];//获取cell对应的section
    
    indexNum =indexPathAll.row;
    
    //查找数据库中所有存在的情景
    NSArray  *themes = self.theme;
    
    //建立模型
    themMessageModel *theme = themes[indexNum];
    
    //保存在单例对象中,顺传
    _dataCenter.device_No = theme.device_No;
    _dataCenter.gateway_No = theme.gateway_No;
    _dataCenter.theme_ID = theme.theme_ID;
    _dataCenter.theme_Name = theme.theme_Name;
    _dataCenter.theme_No = theme.theme_No;
    _dataCenter.theme_State = theme.theme_State;
    _dataCenter.theme_Type = theme.theme_Type;
    
    
    NSArray *tempArray = @[@"情景配置",@"情景删除",];
    
    self.showView.titleArray = tempArray;
    
    self.showView.title = @"情景管理";
    
    [self.showView showInView:self.view animated:YES];

    
}
- (HCDaterView *)showView{
    
    if(_showView == nil){
        
        _showView = [[HCDaterView alloc]initWithFrame:CGRectZero];
        
        _showView.sureBtn.hidden = YES;
        
        _showView.cancleBtn.hidden = YES;
        
        _showView.delegate = self;
    }
    
    return _showView;
}

- (void)daterViewClicked:(HCDaterView *)daterView{
    
        switch (daterView.currentIndexPath.row) {
                
            case 0:
                //情景配置
                [self themeConfigure];
                
                break;
                
            case 1:
                //删除情景
                [self deleteTheme];
            break;
                
        }
    
}
    




/**
 *  提醒用户是否需要删除网关设备
 */
-(void)deleteTheme{
    
    
    [_showView  hiddenInView:self.view animated:YES];
    
    UIAlertView * alert = [[UIAlertView  alloc]initWithTitle:@"温馨提示" message:@"确定要删除此情景吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    self.alert = alert;
    
    [alert show];
    
}

/**
 *  切换到情景配置控制器
 */
-(void)themeConfigure{

    [_showView  hiddenInView:self.view animated:YES];
   
    UnscrollTabController *nextVC = [[UnscrollTabController  alloc]init];
        
    [self  presentViewController:nextVC animated:YES completion:nil];
    
}


/**
 *  监听键盘
 *
 *  @param textField
 *
 *  @return
 */
-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    
    [textField resignFirstResponder];
    
    return YES;
    
}

/**
 *  点击删除当前选中的情景
 */
-(void)deleteThemes{
    
    //查找数据库中所有存在的情景
    NSArray  *themes = self.theme;
    
    //建立模型
    themMessageModel *theme;
    
    if (themes.count!=0) {
        
        theme = themes[indexNum];
    }
  
    //发送情景删除报文给网关
    [self  sendMesageToGatewayDeleteTheme];
    
    
    //取出当前cell中的网关信息
    themMessageModel  *themeIndex = [[themMessageModel  alloc]init];
    
    themeIndex.theme_No = theme.theme_No;
    
    //NSLog(@"%@",themeIndex.theme_No );
    
    //删除当前情景
    [themeMessageTool  delete:themeIndex];
    
    //在情景设备表中 删除当前情景下联动的所有设备
    themeDeviceMessage *themeDelet = [[themeDeviceMessage  alloc]init];
    
    themeDelet.theme_no = theme.theme_No;
    
    [themeDeviceMessageTool  delete:themeDelet];
    
    //更新cell中网关设备
    themMessageModel *Theme = [[themMessageModel alloc]init];
    Theme.gateway_No = _dataCenter.gatewayNo;
    _theme=[themeMessageTool queryWiththemes:Theme];

   
    //刷新collectionView
    [_collectionView  reloadData];
    
       //移除蒙版
    [self.backgroundView  removeFromSuperview];
    
    
}

/**
 *  封装情景删除报文 发送给网关
 */
-(void)sendMesageToGatewayDeleteTheme{

    SocketManager *soceket = [SocketManager  shareSocketManager];
    //查找数据库中所有存在的情景
    NSArray  *themes = self.theme;
    //建立模型
    themMessageModel *theme;
    
    if (themes.count!=0) {
        
        theme = themes[indexNum];
        
    }
    
//    NSLog(@"======%@======%@====%@=====%@====",theme.gateway_No,theme.device_No,theme.theme_No,theme.theme_State);
//    
    
    
    NSString *header = @"42424141";//发送给服务器的报头
    
    NSString *stamp = @"00000000";//没有用到的字段
    
    NSString *gw_id = theme.gateway_No;
    
    NSString *dev_id = theme.device_No;
    
    NSString *dev_type = @"3200";
    
    NSString *data_type = @"1200";//情景删除18
    
    NSString *data_len = @"0010";
    
    NSString *data = [theme.theme_No  stringByAppendingString:[ControlMethods transThemeCoding: theme.theme_State]];
    
    //拼接发送报文
    NSString *packet = [PacketMethods  devicePacket:header getStamp:stamp getGw_id:gw_id getDev_id:dev_id getDev_type:dev_type getData_type:data_type getData_len:data_len getData:data];
    
    NSString *deviceControlPacketStr = [packet stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
    
    if (_dataCenter.networkStateFlag ==0) {//内网
        
        NSString *themeDelete = [deviceControlPacketStr  stringByReplacingCharactersInRange:NSMakeRange(0, 8) withString:@"41414444"];
        //打印报文
        NSLog(@"===内网情景删除 == %@",themeDelete);
        [soceket  sendMsg:themeDelete];
        
       
    }else{
        //打印报文
        NSLog(@"===外网情景删除 == %@==",deviceControlPacketStr);
        
        //发送报文到对应设备
        [ControlMethods  controlDeviceHTTPmethods:deviceControlPacketStr ];
    
    }
    

}


//点击界面 退出蒙版
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    [_showView  hiddenInView:self.view animated:YES];
    
}

#pragma mark updateThemeList 本地插入themeDeviceList
-(void)updateThemeList{

    NSInteger  count;
    
    if (_themeArray.count ==0) {
        
        count = 0;
        
    }else{
        
        count = _themeArray.count;
        
    }
    
    themMessageModel *theme = [[themMessageModel  alloc]init];
    themeDeviceMessage  *themeDevice = [[themeDeviceMessage  alloc]init];
    themeDeviceMessage *fonudDevice = [[themeDeviceMessage  alloc]init];
    //更新设备状态
    themeDeviceMessage *states = [[themeDeviceMessage  alloc]init];
    
    for (int i = 1; i < count; i ++) {
        
        NSString *themePacket =_themeArray[i];
        
        int dataLen =  strtoul([[[themePacket substringWithRange:NSMakeRange(48, 4)] substringWithRange:NSMakeRange(0, 4)] UTF8String],0,16);
        
        int  realDataLen =  [[themePacket substringFromIndex:52] length]/2;
        //判断报文的是否是合法的报文
        
        if (dataLen==realDataLen) {
            
            if(dataLen>100){
                int themeNameLen =strtoul([[[themePacket  substringWithRange:NSMakeRange(108, 2)] substringWithRange:NSMakeRange(0, 2)] UTF8String],0,16);
                    
                
                if (themeNameLen==0) {
                       
                    }else{
                        //将新加入的空间名称，添加到模型中
                        theme.theme_Name =[ControlMethods  chineseTostring:[ControlMethods  stringFromHexString:[themePacket  substringWithRange:NSMakeRange(116, themeNameLen*2 )]] ];//
                        theme.gateway_No =  [themePacket  substringWithRange:NSMakeRange(8, 16)];
                        theme.device_No = [themePacket  substringWithRange:NSMakeRange(84, 16)];
                        theme.theme_No = [themePacket  substringWithRange:NSMakeRange(52, 16)];
                        theme.theme_State =[transCodingMethods   transThemeCodingFromServer:[themePacket  substringWithRange:NSMakeRange(68, 16)]] ;
                        theme.theme_Type = [[themePacket  substringWithRange:NSMakeRange(101, 1)] intValue];
                        
    //                            NSLog(@"===themePacket = %@==theme_Name=%@===gateway_No=%@===device_No=%@==theme_No=%@==theme_State=%@==theme_Type=%ld==themeNameLen=%d=",themePacket,theme.theme_Name,theme.gateway_No,theme.device_No,theme.theme_No,theme.theme_State,(long)theme.theme_Type,themeNameLen);
                        
                        themMessageModel *themes = [[themMessageModel  alloc]init];
                        
                        themes.theme_No = theme.theme_No;
                        
                        NSArray *themesArray = [themeMessageTool  queryThemeWithThemeNum:themes];
                        
                        if (themesArray.count == 0) {//没有此情景
                            
                            if (theme.theme_Type==1 |theme.theme_Type==3)
                            {
                                
                            }else{
                                theme.device_No = @"3030303030303030";
                            }
                            //添加情景
                            [themeMessageTool  addTheme:theme];
                            
                        }
                        //向themedevice表中插入新的设备
                        NSString *themeDevicesMessage;
                        
                        if (theme.theme_Type==1 |theme.theme_Type==3) {//硬件情景 和 安防类情景
                            
                            themeDevicesMessage =[themePacket  substringFromIndex:340];
                            
                            NSInteger devicesNum = [themeDevicesMessage length] /96;
                            
                            for (int i = 0; i < devicesNum; i++) {
                                
                                NSString *deviesMessage = [themeDevicesMessage  substringWithRange:NSMakeRange(i*96, 96)];
                                NSInteger deviceStateLen = strtoul([[deviesMessage  substringWithRange:NSMakeRange(80, 2)]  UTF8String], 0, 16);
                                NSInteger devType = strtoul([[deviesMessage  substringWithRange:NSMakeRange(88, 2)]  UTF8String], 0, 16);
                                
                                if (devType ==5) {
                                    
                                    themeDevice.device_state_cmd =  [NSString  stringWithFormat:@"%lu",strtoul([[deviesMessage  substringWithRange:NSMakeRange(16, deviceStateLen*2)]UTF8String], 0, 16)];
                                    
                                }else if(devType ==105){
                                    
                                    themeDevice.device_state_cmd = [deviesMessage substringWithRange:NSMakeRange(16, deviceStateLen*2)];
                                    
                                }else{
                                    
                                    if(deviceStateLen ==8){
                                        themeDevice.device_state_cmd =[transCodingMethods  transThemeCodingFromServer:[deviesMessage substringWithRange:NSMakeRange(16, deviceStateLen*2)]];
                                        
                                        
                                    }else{
                                        if(deviceStateLen<=4){
                                            themeDevice.device_state_cmd =[transCodingMethods  transCodingFromServer:[deviesMessage substringWithRange:NSMakeRange(16, deviceStateLen*2)]];
                                        }
                                        
                                    }
                                }
                                
                                themeDevice.device_No = [deviesMessage substringWithRange:NSMakeRange(0, 16)];
                                themeDevice.gateway_No = theme.gateway_No;
                                themeDevice.theme_no = theme.theme_No;
                                themeDevice.theme_device_No = theme.device_No;
                                themeDevice.theme_state =theme.theme_State;
                                themeDevice.theme_type = theme.theme_Type;
                                
                                fonudDevice.device_No = themeDevice.device_No;
                                fonudDevice.theme_no = theme.theme_No;
                                NSArray * foundDeviceArrar = [themeDeviceMessageTool queryWithThemeDevices:fonudDevice];
                                
                                if (foundDeviceArrar.count == 0) { //没有此设备 则插入新设备
                                    if(themeDevice.device_state_cmd !=nil){
                                        
                                        //向情景列表中插入联动的设备
                                        [themeDeviceMessageTool  addThemeDevice:themeDevice];
                                    }
                                }else{//更新设备状态
                                    
                                    states.device_state_cmd = themeDevice.device_state_cmd;
                                    states.device_No =  themeDevice.device_No;
                                    states.theme_no = theme.theme_No;
                                    if(themeDevice.device_state_cmd !=nil){
                                        
                                        //更新情景列表中设备的状态
                                        [themeDeviceMessageTool  updateThemeDeviceState:states];
                                    }
                                }
                //                 NSLog(@"====themeDevice.device_No=%@====themeDevice.device_state_cmd=%@=====themeDevice.gateway_No=%@====themeDevice.theme_no=%@=====themeDevice.theme_device_No=%@=====themeDevice.theme_state=%@===themeDevice.theme_type=%ld===deviceStateLen=%ld===",themeDevice.device_No,themeDevice.device_state_cmd,themeDevice.gateway_No,themeDevice.theme_no,themeDevice.theme_device_No,themeDevice.theme_state,(long)themeDevice.theme_type,(long)deviceStateLen);
                            }
           
                        }else{//软件类情景
                            
                            themeDevicesMessage =[themePacket  substringFromIndex:244];
                            NSInteger devicesNum = [themeDevicesMessage length] /96;
                            
                            //NSLog(@"======%@=====",themeDevicesMessage);
                            
                            for (int i = 0; i < devicesNum; i++) {
                                
                                NSString *deviesMessage = [themeDevicesMessage  substringWithRange:NSMakeRange(i*96, 96)];
                                NSInteger deviceStateLen = strtoul([[deviesMessage  substringWithRange:NSMakeRange(80, 2)]  UTF8String], 0, 16);
                                NSInteger devType = strtoul([[deviesMessage  substringWithRange:NSMakeRange(88, 2)]  UTF8String], 0, 16);
                                
                                if (devType ==5) {
                                    
                                    themeDevice.device_state_cmd =  [NSString  stringWithFormat:@"%lu",strtoul([[deviesMessage  substringWithRange:NSMakeRange(16, deviceStateLen*2)]UTF8String], 0, 16)];
                                    
                                }else if(devType ==105){
                                    
                                    themeDevice.device_state_cmd = [deviesMessage substringWithRange:NSMakeRange(16, deviceStateLen*2)];
                                    
                                }else{
                                    
                                    if(deviceStateLen ==8){
                                        themeDevice.device_state_cmd =[transCodingMethods  transThemeCodingFromServer:[deviesMessage substringWithRange:NSMakeRange(16, deviceStateLen*2)]];
                                        
                                        
                                    }else{
                                        themeDevice.device_state_cmd =[transCodingMethods  transCodingFromServer:[deviesMessage substringWithRange:NSMakeRange(16, deviceStateLen*2)]];
                                        
                                        
                                    }

                                    
                                }
                                
                                themeDevice.device_No = [deviesMessage substringWithRange:NSMakeRange(0, 16)];
                                
                                themeDevice.gateway_No = theme.gateway_No;
                                themeDevice.theme_no = theme.theme_No;
                                themeDevice.theme_device_No = theme.device_No;
                                themeDevice.theme_state =theme.theme_State;
                                themeDevice.theme_type = theme.theme_Type;
                                
                                fonudDevice.device_No = themeDevice.device_No;
                                fonudDevice.theme_no = theme.theme_No;
                                NSArray * foundDeviceArrar = [themeDeviceMessageTool queryWithThemeDevices:fonudDevice];
                                
                                if (foundDeviceArrar.count == 0) { //没有此设备 则插入新设备
                                    
                                    if(themeDevice.device_state_cmd !=nil){
                                        
                                        //向情景列表中插入联动的设备
                                        [themeDeviceMessageTool  addThemeDevice:themeDevice];
                                    }
                                }else{//更新设备状态
                                    states.device_state_cmd = themeDevice.device_state_cmd;
                                    states.device_No =  themeDevice.device_No;
                                    states.theme_no = theme.theme_No;
                                    if(themeDevice.device_state_cmd !=nil){
                                        
                                        //更新情景列表中设备的状态
                                        [themeDeviceMessageTool  updateThemeDeviceState:states];
                                        
                                    }
                                }
                                
                                                //NSLog(@"====themeDevice.device_No=%@====themeDevice.device_state_cmd=%@=====themeDevice.gateway_No=%@====themeDevice.theme_no=%@=====themeDevice.theme_device_No=%@=====themeDevice.theme_state=%@===themeDevice.theme_type=%ld===deviceStateLen=%ld===",themeDevice.device_No,themeDevice.device_state_cmd,themeDevice.gateway_No,themeDevice.theme_no,themeDevice.theme_device_No,themeDevice.theme_state,(long)themeDevice.theme_type,(long)deviceStateLen);
                                
                            }
                            
                        }
                    }
                        
                }
    
        }
    }
    
    themMessageModel *themess = [[themMessageModel alloc]init];
    themess.gateway_No =_dataCenter.gatewayNo;
    _theme=[themeMessageTool queryWiththemes:themess];//如果情景 显示不出来 就说明是 从服务器拉的网关不对
    
    //刷新表格
    [_collectionView reloadData];
    
}



/**
 *  定义每个UICollectionView 的大小
 *
 *  @param CGSize 一个cell的宽度
 *
 *  @return 返回设置后的结果
 */

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat  collectionViewW= (CGRectGetMaxX(self.collectionView.frame) -CGRectGetMinX(self.collectionView.frame))/2;
    
    
    
    return CGSizeMake(collectionViewW-20, 40);
    
}


/**
 *  定义每个UICollectionView 的 margin
 *
 *  @param UIEdgeInsets 改变文本框的位置
 *
 *  @return 返回设置的结果
 */

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    
    
    return UIEdgeInsetsMake(10, 10, 10, 10);//改变文本框的位置（上左下右）
    
}


/**
 *  调整section
 *
 *  @param collectionView       容器
 *  @param collectionViewLayout 布局方式
 *  @param section              显示多少
 *
 *  @return 返回section
 */
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    
    return 1;
    
}


/**
 *  调整两个cell之间的高度
 *
 *  @param CGFloat 高度
 *
 *  @return 返回设置的高度
 */

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 10.0f;
}


/**
 *设置纯白背景底色
 */
-(void)setWhiteBackground{
    
    
    UILabel  *WhiteBackgroundLable= [[UILabel  alloc]init];
    
    CGFloat  WhiteBackgroundLableX = 20 ;
    CGFloat  WhiteBackgroundLableY = 60 ;
    CGFloat  WhiteBackgroundLableW = [UIScreen mainScreen].bounds.size.width - 40;
    CGFloat  WhiteBackgroundLableH = [UIScreen  mainScreen].bounds.size.height -90;
    WhiteBackgroundLable.frame = CGRectMake(WhiteBackgroundLableX, WhiteBackgroundLableY, WhiteBackgroundLableW, WhiteBackgroundLableH);
    
    WhiteBackgroundLable.backgroundColor = [UIColor  whiteColor];
    
    WhiteBackgroundLable.clipsToBounds = YES;
    WhiteBackgroundLable.layer.cornerRadius = 8.0;//设置边框圆角
    self.WhiteBackgroundLable = WhiteBackgroundLable;
    
    [self.fullscreenView addSubview:WhiteBackgroundLable];
    
}

/**
 *  点击按钮添加新情景
 */
-(void)setupNewTheme{
    
    UIButton  *setupNewThemeBtn = [[UIButton  alloc]init];
    
    CGFloat setupNewThemeX =20;
    CGFloat setupNewThemeY =60;
    CGFloat setupNewThemeW =130;
    CGFloat setupNewThemeH =30;
    
    setupNewThemeBtn.frame = CGRectMake(setupNewThemeX, setupNewThemeY, setupNewThemeW, setupNewThemeH);
    [setupNewThemeBtn  setTitle:@"+请按此处添加新情景" forState:UIControlStateNormal];
    [setupNewThemeBtn  setTitle:@"+请按此处添加新情景" forState:UIControlStateHighlighted];
    [setupNewThemeBtn  setTitleColor:[UIColor  blackColor] forState:UIControlStateNormal];
    [setupNewThemeBtn  setTitleColor:[UIColor  blackColor] forState:UIControlStateHighlighted];
    
    setupNewThemeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    setupNewThemeBtn.contentEdgeInsets = UIEdgeInsetsMake(0,2, 0, 0);
    //setupNewSpaceBtn.backgroundColor = [UIColor  redColor];
    
    //[setupNewThemeBtn  setFont:[UIFont  systemFontOfSize:13]];
     setupNewThemeBtn.titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:13];
    [setupNewThemeBtn  addTarget:self action:@selector(setupNewThemeAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.fullscreenView  addSubview:setupNewThemeBtn];
    
    
    
}

/**
 *  点击添加情景按钮 调用此方法
 */
-(void)setupNewThemeAction{
    
    if ([_dataCenter.gatewayNo isEqualToString:@"0"] | !_dataCenter.gatewayNo ) {
        
        [MBProgressHUD  showError:@"请先添加主机"];
        
    }else{
        
       
        self.showThemeView.mainTitle.text = @"添加情景";
        self.showThemeView.secondaryTitle.text = @"情景名称 :";
        [self.showThemeView  showGatewayView:self.view animated:YES];
        
    }
    
    
}

-(HSAddspaceDaterView*)showThemeView{

    if(_showThemeView == nil){
        
        _showThemeView = [[HSAddspaceDaterView alloc]initWithFrame:CGRectZero];
        _showThemeView.secondaryField.placeholder = @"请输入情景名称";
        _showThemeView.delegate = self;
        
    }
    
    return _showThemeView;


}
-(void)makeSureViewClicked:(HSAddspaceDaterView *)daterView{

    [self addThemeAction];

}





/**
 *  点击添加按钮  自定义情景
 */
-(void)addThemeAction{
    
    NSString *gatewayNum;
    
    if ([_dataCenter.gatewayNo isEqualToString:@"0"] | !_dataCenter.gatewayNo) {
    
        [MBProgressHUD showError:@"请先添加主机"];
        
    }else{
    
        gatewayNum = _dataCenter.gatewayNo;
    
        //自定义情景的时候 theme_no = 网关id + 情景名称 +md5加密
        NSString *themeName = _showThemeView.secondaryField.text;
        
        NSString  *theme_no = [gatewayNum  stringByAppendingString:themeName];
        
        NSString *theme_no_tag = [theme_no stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
        
        NSString *theme_no_md5 = [theme_no_tag md5String];
        
        //建立模型
        themMessageModel *theme = [[themMessageModel  alloc]init];
        
        //将新加入的空间名称，添加到模型中
        theme.theme_Name = _showThemeView.secondaryField.text;
        theme.gateway_No = gatewayNum;
        theme.device_No = @"3030303030303030";
        theme.theme_No = theme_no_md5;
        theme.theme_State = @"00000000";
        theme.theme_Type = 4;
        NSLog(@"theme_Name = %@",theme.theme_Name);
        NSString *themeNameStirngToByte = [ControlMethods  chineseWithHexString:theme.theme_Name];
        
        if ([theme.theme_Name isEqualToString:@""]) {//空

            [MBProgressHUD  showError:@"请重新输入情景名称"];
            
        }else{
            if(themeNameStirngToByte.length>56){
                
                [MBProgressHUD  showError:@"请重新输入情景名称"];
            }else{
                //向数据库中添加新增加情景
                [themeMessageTool  addTheme:theme];
                themMessageModel *theme = [[themMessageModel alloc]init];
                theme.gateway_No = _dataCenter.gatewayNo;
                _theme=[themeMessageTool queryWiththemes:theme];
                
                //刷新表格
                [_collectionView reloadData];
            }
          }
       
       }
    
    [MBProgressHUD  hideHUD];
    
 }

/**
 *设置导航栏
 */
-(void)setNavBar{
    
    
    CGFloat navBarW = [UIScreen  mainScreen].bounds.size.width;
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0,navBarW, 40)];
    
    //创建一个导航栏集合
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"情景管理"];
    
    [[UINavigationBar appearance]setTitleTextAttributes:
     @{ NSFontAttributeName: [UIFont systemFontOfSize:16.0]}];
    
    //创建一个左边按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleBordered target:self action:@selector(backAction)];
    //给按钮添加图片
    
    leftButton.title = @"返回";
    leftButton.tintColor = [UIColor  blackColor];
    
    //设置字体大小
    [[UIBarButtonItem appearance] setTitleTextAttributes:
     @{ NSFontAttributeName: [UIFont systemFontOfSize:15.0],} forState:UIControlStateNormal];
    
    
    //创建一个右边按钮
    //    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleDone target:self action:@selector(asyncGatewayInfoAction)];
    //    rightButton.title = @"完成";
    //    rightButton.tintColor = [UIColor  blackColor];
    //把导航栏集合添加到导航栏中，设置动画关闭
    [navBar pushNavigationItem:navItem animated:NO];
    
    //把左右两个按钮添加到导航栏集合中去
    [navItem setLeftBarButtonItem:leftButton];
    //[navItem setRightBarButtonItem:rightButton];
    
    //将标题栏中的内容全部添加到主视图当中
    [self.fullscreenView addSubview:navBar];
    
    
}
/**返回到上一个systemView*/
-(void)backAction{
    
    [self  dismissViewControllerAnimated:YES completion:nil];
    
}


/**
 *设置导背景图片
 */
-(void)setFullscreenView{
    
    UIImageView  *fullscreenView = [[UIImageView  alloc]init];
    UIImage  *image = [UIImage imageNamed:@"bg_title.jpg"];
    
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

-(void)getAllInfraDevicesFormServer{
    
    //创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager  manager];
    mgr.responseSerializer = [AFJSONResponseSerializers  serializer];
    
    //配置请求超时时间
    mgr.requestSerializer.timeoutInterval = 60;
    
    //设置请求参数
    NSMutableDictionary  *params = [NSMutableDictionary  dictionary];
    params[@"gatewayNo"] = _dataCenter.gatewayNo;
    
    
    NSString  *urlStr =[NSString  stringWithFormat:@"%@/appGetInfraredByGatewayNo" ,HomecooServiceURL];
    NSString *url = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
    
    
    [mgr  POST:url parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        //打印日志
        NSString  *result = [responseObject[@"result"]description];
        
        //服务器返回的设备表信息
        NSArray *InfraDeviceListArray = responseObject[@"infraredList" ];
        
        self.InfraDeviceListArray = InfraDeviceListArray;
        
        if ([result  isEqual:@"success"]) {
            
            
            [self updateInnfraDeviceList];
            
            
        } if ([result  isEqual:@"failed"]) {
            
            [MBProgressHUD  showError:@"请求失败!"];

        }
        
        [MBProgressHUD  hideHUD];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
/**
 *  更新用户设备空间信息
 */
-(void)updateInnfraDeviceList{
    NSDictionary *spaceDit;
    NSString *deviceNo;
    NSString *deviceStateCmd;
    NSString *gatewayNo;
    NSString *infraCrlName;
    NSString *infraTypeId;
    NSString *themeNo;
    NSArray  *devices;
    if (_InfraDevices==nil) {
        _InfraDevices = [[themeInfraModel alloc]init];
    }
    if (_updataInfraDevices==nil) {
        _updataInfraDevices = [[themeInfraModel  alloc]init];

    }
  
    NSInteger  count;
    
    if (self.InfraDeviceListArray.count ==0) {
        count = 0;
    }else{
        
        count = self.InfraDeviceListArray.count;
    }
    
    for (int i = 0; i<count; i++) {
        
        spaceDit = self.InfraDeviceListArray[i];
        
        deviceNo = [spaceDit objectForKey:@"deviceNo"];
        deviceStateCmd = [spaceDit objectForKey:@"deviceStateCmd"];
        gatewayNo = [spaceDit objectForKey:@"gatewayNo"];
        infraCrlName = [spaceDit objectForKey:@"infraCrlName"];
        infraTypeId = [spaceDit  objectForKey:@"infraTypeId"] ;
        themeNo = [spaceDit  objectForKey:@"themeNo"];
        
        
        _updataInfraDevices.themeNo =themeNo;
        _updataInfraDevices.infraType_ID = [infraTypeId integerValue];
        _updataInfraDevices.deviceNo = deviceNo;
        
        devices = [themeInfraModelTools querWithInfraDevices:_updataInfraDevices];
        
        _InfraDevices.deviceNo =  deviceNo;
        _InfraDevices.deviceState_Cmd = deviceStateCmd;
        _InfraDevices.gatewayNo = gatewayNo;
        _InfraDevices.infraControlName = infraCrlName;
        _InfraDevices.infraType_ID = [infraTypeId integerValue];
        _InfraDevices.themeNo = themeNo;
        if (devices.count == 0) {//则插入红外遥控信息

            [themeInfraModelTools addThemeInfraDevice:_InfraDevices];
        }else{
            
            [themeInfraModelTools  updateInfraDeviceState:_InfraDevices];
        }
    }
}

-(BOOL)shouldAutorotate{
    return YES;
}



-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}
@end
