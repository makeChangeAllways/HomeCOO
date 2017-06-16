//
//  gatewaySettingController.m
//  HomeCOO
//
//  Created by tgbus on 16/5/15.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "gatewaySettingController.h"
#import "AppDelegate.h"
#import "SystemViewController.h"
#import "SpaceViewController.h"
#import "ThemeViewController.h"
#import "SecurityViewController.h"
#import "SettingViewController.h"
#import "MethodClass.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworkings.h"
#import "PrefixHeader.pch"
#import "alertViewModel.h"
#import "gatewayMessageModel.h"
#import "gatewayMessageTool.h"
#import "gatewayCollectionViewCell.h"
#import "ControlMethods.h"
#import "LZXDataCenter.h"
#import "versionMessageModel.h"
#import "versionMessageTool.h"
#import "queryDeviceControlMethods.h"
#import "JPUSHService.h"
#import "transCodingMethods.h"
#import "SocketManager.h"
#import "alarmMessages.h"
#import "alarmMessagesTool.h"
#import "deviceMessage.h"
#import "deviceMessageTool.h"
#import "alarmRinging.h"
#import "ScanLAN.h"
#import "Device.h"
#import "SocketManager.h"
#import "ControlMethods.h"
#import "HCDaterView.h"
#import "HCGatewayView.h"
#import "scanerSocketManger.h"
#import "UdpSocketManager.h"
#import  "GGSocketManager.h"
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

@interface gatewaySettingController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,HCDaterViewDelegate,HCGatewayViewDelegate>


/**设置背景图片*/
@property(nonatomic,weak)  UIImageView  * fullscreenView;

/**设置导航栏*/
@property(nonatomic,weak)  UINavigationBar *navBar;

/**设置白色背景*/
@property(nonatomic,weak) UILabel  *WhiteBackgroundLable;

/**设置提示框背景*/
@property(nonatomic,weak)UILabel  *WhiteBackground;

/**设置蒙版*/

@property(nonatomic,strong) HCDaterView *showView;

@property(nonatomic,strong) HCGatewayView *showGatewayIPView;

@property(nonatomic,strong) HCGatewayView *showGatewayPWDView;

@property(nonatomic,strong) HCGatewayView *addNewGatewayView;

/**UICollectionView 容器*/
@property (weak, nonatomic)  UICollectionView *collectionView;

/**网关cell */
@property(nonatomic,strong) gatewayCollectionViewCell *cell;

/**存放所有网关*/
@property(nonatomic,strong)  NSArray *gateways;

@property(nonatomic,strong) LZXDataCenter  *dataCenter;
/**用来接收服务器返回的网关的信息*/
@property(nonatomic,weak) NSArray * gatewayList;

@property(nonatomic,strong) UIAlertView * alert;

@property(nonatomic,copy) NSString * alarmString;

@property(nonatomic,copy) NSString *alertString;

@property NSMutableArray *connctedDevices;

@property ScanLAN *lanScanner;

@property(nonatomic,copy) NSString * gatewayIP;

@property NSTimer *timers;

@property NSInteger currentHosts;

@property NSInteger gatewayAlterViewFlag;

@property NSInteger currentIndex;

@property NSInteger lastIndex;

@property(nonatomic,strong) NSArray  *arr1;

@property(nonatomic,strong) UdpSocketManager *udpSocket;

@property (nonatomic,strong)  GGSocketManager *socketManger ;


@end

static NSString *string = @"gatewayCollectionViewCell";

static  NSInteger indexNum;

@implementation gatewaySettingController


-(NSArray *)gateways{
    
    if (_gateways==nil) {
        
        _gateways=[gatewayMessageTool   queryWithgateways];
        
    }
    
    return _gateways;

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //创建一个导航栏
    [self setNavBar];
    
    //设置底片背景
    [self  setWhiteBackground];
    
    //添加新网关
    [self  setupGateway];
    
    //创立UICollectionView控件
    [self  addUICollectionView];
    
    LZXDataCenter  *dataCenter = [LZXDataCenter  defaultDataCenter];
    
    self.dataCenter = dataCenter;
    
    if (dataCenter.networkStateFlag == 0) {//内网

        //[self  receivedFromGateway_deviceMessage];
        
    }else{
        
        //放在后台运行 获取该用户下绑定的网关
        [self  performSelectorInBackground:@selector(getGatewayFromServer) withObject:nil];
    
    }
    
}

/**
 *  启动搜索
 */
- (void)startScanningLAN {
    
    NSArray * gateways=[gatewayMessageTool   queryWithgateways];
    
    self.gatewayAlterViewFlag = 1;
    
    if (gateways.count!=0){
        
        [self.lanScanner stopScan];
        
        self.lanScanner = [[ScanLAN alloc] initWithDelegate:self];
        
        self.connctedDevices = [[NSMutableArray alloc] init];
        
        [self.lanScanner startScan];
        
        [MBProgressHUD  showMessage:@"正在搜索主机IP,请等待……" toView:self.fullscreenView];
        
    }else{
        
        [MBProgressHUD  showError:@"请先添加主机"];
        
    }
    
   
    
}

#pragma mark LAN Scanner delegate method

- (void)scanLANDidFindNewAdrress:(NSString *)address havingHostName:(NSString *)hostName {

    Device *device = [[Device alloc] init];
    
    device.name = hostName;
    
    device.address = address;
    
    [self.connctedDevices addObject:device];
    
}

- (void)scanLANDidFinishScanning {
   
    self.currentHosts = 0;

    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        
        self.timers = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(connectToSocket) userInfo:nil repeats:YES];
        
        [[NSRunLoop  mainRunLoop]addTimer:self.timers forMode:NSRunLoopCommonModes];
        
    });

    
}

-(void)connectToSocket{
 
    self.currentHosts++;
    
    NSArray * gateways=[gatewayMessageTool   queryWithgateways];
   
    NSString * gatewayNo;
    NSString * gatewayPwd;
   
    if (gateways.count!=0) {
        
        gatewayMessageModel *gatewayModel = gateways[0];//业务逻辑中 只有一个网关
        gatewayNo = gatewayModel.gatewayID;
        gatewayPwd = gatewayModel.gatewayPWD;
        
    }
    
    scanerSocketManger *socket = [scanerSocketManger  shareSocketManager];
  
    NSString *head = @"4141444430303030";
   
    NSString *datas = [@"000000000000000032001C000008"  stringByAppendingString:[ControlMethods stringToByte:gatewayPwd]];
   
    NSString *gatewayConnectStr1 = [head  stringByAppendingString:gatewayNo];
    
    NSString *gatewayConnectStr = [gatewayConnectStr1 stringByAppendingString:datas];
   
    Device *device = self.connctedDevices[self.currentHosts];
    
    [socket startConnectHost:device.address WithPort:9091];

    [socket sendMsg:gatewayConnectStr];
 
    [socket  receiveMsg:^(NSString *receiveInfo) {
        
        if ([[receiveInfo  substringFromIndex:receiveInfo.length -10] isEqualToString:@"4300000100"]) {
           
            self.lastIndex = 1;
            [self.timers  invalidate];
            
            if (self.gatewayAlterViewFlag ==1) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [MBProgressHUD  hideAllHUDsForView:self.fullscreenView animated:YES];
                    
                    [[[UIAlertView alloc] initWithTitle:@"主机IP匹配成功" message:[NSString  stringWithFormat:@"%@", device.address] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
                    
                });
                
            }
            self.gatewayAlterViewFlag =0;
            gatewayMessageModel  *gatewayip = [[gatewayMessageModel alloc]init];
            
            gatewayip.gatewayID = gatewayNo;
            gatewayip.gatewyIP = device.address;
            
            //将搜索到的网关IP插入网关表
            [gatewayMessageTool   updateGatewayIP:gatewayip];
            
           
          
        }
        
    }];
    
   
    if (self.currentHosts>self.connctedDevices.count-2) {//这地方可能有问题 20161027晚
        
        [self.timers  invalidate];
        
        [MBProgressHUD  hideAllHUDsForView:self.fullscreenView animated:YES];
        if (self.lastIndex !=1) {
            
//            [[[UIAlertView alloc] initWithTitle:@"未能成功匹配到主机IP" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        }
    }
  
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
            
            if (_dataCenter.networkStateFlag == 0) {
                
                [MBProgressHUD showError:@"请先切换到远程网络 !"];
            }else{
           
                //删除网关告诉服务器当前手机号与该网关解绑
                [self appUnbindingGatewayNo];

            }
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
 *  根据当前用户，从服务器获取网关信息
 */
-(void)getGatewayFromServer{

    LZXDataCenter *dataCenter = [LZXDataCenter defaultDataCenter];
    //创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager  manager];
    mgr.responseSerializer = [AFJSONResponseSerializers  serializer];
    
    //配置请求超时时间
    mgr.requestSerializer.timeoutInterval = 60;
    
    //设置请求参数
    NSMutableDictionary  *params = [NSMutableDictionary  dictionary];
    params[@"phoneNum"] = dataCenter.userPhoneNum;
    
    NSString *urlStr =[NSString  stringWithFormat:@"%@/appGetGatewayInfo" ,HomecooServiceURL];
    NSString *url = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
    
    
    [mgr  POST:url parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        //打印日志
        //NSLog(@"请求成功--%@",responseObject);
        
        NSString  *result = [responseObject[@"result"]description];
        
        //服务器返回的设备表信息
        NSArray *gatewayList = responseObject[@"gatewayList" ];
        self.gatewayList = gatewayList;
      
        if ([result  isEqual:@"success"]) {
            
            
            [self updateGatewayList];
                              
            
        } if ([result  isEqual:@"failed"]) {
            
            [MBProgressHUD  showError:@"请求失败!"];
            
        }
        
        [MBProgressHUD  hideHUD];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD  showError:@"网络繁忙，请稍后再试"];
        
    }];
    
  
}


/**
 *  更新本地数据库的网关表
 */
-(void)updateGatewayList{

    //删除网关表
    [gatewayMessageTool  deleteGatewayTable];
    
    gatewayMessageModel * gatewayList = [[gatewayMessageModel alloc]init];
    
    LZXDataCenter *gatewayno = [LZXDataCenter defaultDataCenter];
    
    NSInteger  count;
    
    if (self.gatewayList.count ==0) {
        
        count = 0;
        
    }else{
        
        count = self.gatewayList.count;
    }
    
    for (int i = 0; i<count; i++) {
        
        NSDictionary *gatewayDit = self.gatewayList[i];
        
        NSString *gatewayNo = [gatewayDit  objectForKey:@"gatewayNo"];
        NSString *gatewayPwd = [gatewayDit  objectForKey:@"gatewayPwd"];
        NSString *gatewayIp = [gatewayDit  objectForKey:@"gatewayIp"];
       
       
        gatewayno.gatewayNo = gatewayNo;
        gatewayno.gatewayIP = gatewayIp;
        gatewayno.gatewayPwd = gatewayPwd;

        
        gatewayMessageModel *gateway = [[gatewayMessageModel  alloc]init];
        gateway.gatewayID = gatewayNo;
        
        NSArray *gatewayArray = [gatewayMessageTool queryWithgatewaysBygatewayNo:gateway];
        
        if (gatewayArray.count == 0) {//该网关不存在  则插入新的网关
           
            gatewayList.gatewayID = gatewayNo;
            gatewayList.gatewayPWD = gatewayPwd;
            gatewayList.gatewyIP = gatewayIp;

            //极光注册别名
            [JPUSHService setAlias:gatewayList.gatewayID callbackSelector:nil object:nil];
            [gatewayMessageTool  addGateway:gatewayList];
      
        }else{//该网关存在 则更新该网关的信息
        
            gatewayList.gatewayID = gatewayNo;
            gatewayList.gatewayPWD = gatewayPwd;
            gatewayList.gatewyIP = gatewayIp;
            
            [gatewayMessageTool  updateGatewayMessage:gatewayList];
            
        }
        
        [self addNewGatewayVersion:gatewayNo];

    }
    
     _gateways=[gatewayMessageTool   queryWithgateways];
    
    [_collectionView  reloadData];
   
}


/**
 *  添加UICollectionView控件
 */

-(void)addUICollectionView{
    
    CGFloat  collectionViewX = 20 ;
    CGFloat  collectionViewY = 90 ;
    CGFloat  collectionViewW = [UIScreen mainScreen].bounds.size.width - 40;
    CGFloat  collectionViewH = [UIScreen  mainScreen].bounds.size.height -175;
    //确定是水平滚动，还是垂直滚动
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    UICollectionView  *collectionView = [[UICollectionView  alloc]initWithFrame:CGRectMake(collectionViewX, collectionViewY, collectionViewW, collectionViewH) collectionViewLayout:flowLayout];
    
    collectionView.dataSource=self;
    collectionView.delegate=self;
    collectionView.backgroundColor = [UIColor  whiteColor];
    [collectionView registerClass:[gatewayCollectionViewCell class] forCellWithReuseIdentifier:string];
   
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
    
    return  self.gateways.count;
    
}



/**
 *  每个UICollectionView展示的内容
 *
 *  @param collectionView
 *  @param indexPath
 *
 *  @return
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
   _cell = [collectionView dequeueReusableCellWithReuseIdentifier:string forIndexPath:indexPath];
    
    LZXDataCenter *gatewayno = [LZXDataCenter  defaultDataCenter];
   
    gatewayMessageModel *gateway = self.gateways[indexPath.row];
    
    if ([gatewayno.gatewayNo isEqualToString:gateway.gatewayID]) {
       
        [self changeBtn];
        
    }else{
    
        [self  changeBtn1];
    
    }

    _cell.gatewayMessageLable.text = [NSString  stringWithFormat:@" 主机ID:%@",[ControlMethods  stringFromHexString:gateway.gatewayID]];
    
    [_cell.button  addTarget:self action:@selector(enterChangeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_cell.button1  addTarget:self action:@selector(changeBox:) forControlEvents:UIControlEventTouchUpInside];
    
    return _cell;
    
}

-(void)changeBtn{

    [_cell.button1  setImage:[UIImage   imageNamed:@"0ff.png"] forState:UIControlStateSelected];
    [_cell.button1  setImage:[UIImage  imageNamed:@"on.png"] forState:UIControlStateNormal];

}
-(void)changeBtn1{
    
    [_cell.button1  setImage:[UIImage   imageNamed:@"on.png"] forState:UIControlStateSelected];//@"on.png"
    [_cell.button1  setImage:[UIImage  imageNamed:@"0ff.png"] forState:UIControlStateNormal];
    
}

-(void)changeBox:(UIButton *)btn{

   
    gatewayCollectionViewCell *cell = (gatewayCollectionViewCell *)[[[btn superview]superview]superview];//获取cell
    
    NSIndexPath *indexPathAll = [self.collectionView indexPathForCell:cell];//获取cell对应的section
    
    indexNum =indexPathAll.row;
    
    btn.selected = !btn.selected;
    
    //查找数据库中所有存在的网关设备
    NSArray  *gateways = [gatewayMessageTool  queryWithgateways];
    //建立模型
    gatewayMessageModel *gateway = gateways[indexNum];
    
    LZXDataCenter *gatewayno = [LZXDataCenter defaultDataCenter];
    
    if (btn.selected) {
        
        if ([gatewayno.gatewayNo isEqualToString:gateway.gatewayID]) {
           
            gatewayno.gatewayNo =@"0";
            gatewayno.gatewayIP = @"0";
            gatewayno.gatewayPwd = @"0";
            
        }else{
        
        
            gatewayno.gatewayNo = gateway.gatewayID;
            gatewayno.gatewayIP = gateway.gatewyIP;
            gatewayno.gatewayPwd = gateway.gatewayPWD;
            
            
        }
    
        NSLog(@"=====gatewayno.gatewayNo ==%@",gatewayno.gatewayNo);
        //重新设置新的别名
        [JPUSHService setAlias:gatewayno.gatewayNo callbackSelector:nil object:nil];

    }else{
    
        if ([gatewayno.gatewayNo isEqualToString:gateway.gatewayID]){
           
            gatewayno.gatewayNo =@"0";
            gatewayno.gatewayIP = @"0";
            gatewayno.gatewayPwd = @"0";

        
        }else{
            
            gatewayno.gatewayNo = gateway.gatewayID;
            gatewayno.gatewayIP = gateway.gatewyIP;
            gatewayno.gatewayPwd = gateway.gatewayPWD;
            
        }
        
         NSLog(@"====gatewayno.gatewayNo =%@",gatewayno.gatewayNo);
        [JPUSHService setAlias:gatewayno.gatewayNo callbackSelector:nil object:nil];

    }

   

}


/**
 *  按钮监听事件
 *
 *  @param btn 点击的是哪个
 */
- (void)enterChangeButton:(UIButton *)btn{
    
    gatewayCollectionViewCell *cell = (gatewayCollectionViewCell *)[[[btn superview]superview]superview];//获取cell
    
    NSIndexPath *indexPathAll = [self.collectionView indexPathForCell:cell];//获取cell对应的section
    
    indexNum =indexPathAll.row;
    
    NSArray *tempArray = @[@"更改主机IP",@"更改主机密码",@"删除",];
    
    self.showView.titleArray = tempArray;
    
    self.showView.title = @"主机设置";
    
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
    
    self.currentIndex = daterView.currentIndexPath.row;
    switch (daterView.currentIndexPath.row) {
            
        case 0:
            
            //更新主机IP
            [_showView  hiddenInView:self.view animated:YES];
            self.showGatewayIPView.mainTitle.text = @"更新主机IP";
            self.showGatewayIPView.secondaryTitle.text = @"主机ID :";
            self.showGatewayIPView.thirdTitle.text = @"主机IP :";
            //点击确定更新主机IP
            [self.showGatewayIPView showGatewayView:self.view animated:YES];

            break;
            
        case 1:
            //更改主机密码
            [_showView  hiddenInView:self.view animated:YES];
          
            self.showGatewayPWDView.mainTitle.text = @"密码重置";
            self.showGatewayPWDView.secondaryTitle.text = @"主机ID :";
            self.showGatewayPWDView.thirdTitle.text = @"旧密码 :";
            self.showGatewayPWDView.thirdField.secureTextEntry = YES;
            self.showGatewayPWDView.fourthTitle.text = @"新密码 :";
            self.showGatewayPWDView.fourthField.secureTextEntry = YES;
            [self.showGatewayPWDView  showGatewayView:self.view animated:YES];
            
            
            break;
        case 2:
            //删除主机
            [self  deleteGateway];
            
            break;
            
    }
    
}

-(void)makeSureViewClicked:(HCGatewayView *)daterView{

    switch (self.currentIndex) {
            
        case 0:
            
            NSLog(@"更改主机ip确定");
            [self updateGatewayip];
            self.currentIndex = 2;
            break;
            
        case 1:
            
            NSLog(@"更改主机密码确定");
            [self  updateGatewayPWD];
            self.currentIndex = 2;
            
            break;
            
       case 2:
            
            NSLog(@"添加新主机确定");
            [self addgatewayAction];
            self.currentIndex = 2;
            break;
            
    }


    

}

-(HCGatewayView *)showGatewayPWDView{
   
    NSArray  *gateways = [gatewayMessageTool  queryWithgateways];
   
    gatewayMessageModel *gateway = gateways[indexNum];
    
    if(_showGatewayPWDView == nil){
        
        _showGatewayPWDView = [[HCGatewayView alloc]initWithFrame:CGRectZero];
        _showGatewayPWDView.secondaryField.placeholder = @"请输入主机ID";
        _showGatewayPWDView.secondaryField.text =  [NSString  stringWithFormat:@"%@",gateway.gatewayID];
        _showGatewayPWDView.thirdField.placeholder = @"请输入旧密码";
        _showGatewayPWDView.fourthField.placeholder = @"请输入新密码";
        
        _showGatewayPWDView.delegate = self;
        
    }
    
    return _showGatewayPWDView;
    
}

-(HCGatewayView *)showGatewayIPView{
    
    NSArray  *gateways = [gatewayMessageTool  queryWithgateways];
    
     gatewayMessageModel *gateway = gateways[indexNum];
    if(_showGatewayIPView == nil){
        
        _showGatewayIPView = [[HCGatewayView alloc]initWithFrame:CGRectZero];
        _showGatewayIPView.secondaryField.placeholder = @"请输入主机ID";
        _showGatewayIPView.secondaryField.text =  [NSString  stringWithFormat:@"%@",gateway.gatewayID];
        _showGatewayIPView.thirdField.placeholder = @"请输入主机IP";
        _showGatewayIPView.fourthTitle.hidden = YES;
        _showGatewayIPView.fourthField.hidden = YES;
        _showGatewayIPView.delegate = self;
        
    }
    
    return _showGatewayIPView;
    
}
/**
 *  重置网关密码
 */

-(void)updateGatewayPWD{

    NSArray  *gateways = [gatewayMessageTool  queryWithgateways];
   
    LZXDataCenter *gatewayno = [LZXDataCenter defaultDataCenter];
   
    //建立模型
    gatewayMessageModel *gateway = gateways[indexNum];

    gatewayno.gatewayNo = @"0";//更改网关的时候将 网关全局变量赋值为原始值（任意）
    //更改网关密码
    gatewayMessageModel  *gatewayPwd = [[gatewayMessageModel alloc]init];
    
    gatewayPwd.gatewayID = gateway.gatewayID;
    gatewayPwd.gatewayPWD = _showGatewayPWDView.fourthField.text;
    
    NSLog(@"gatewayID = %@ gatewayPWD = %@ gatewayPWD = %@", gatewayPwd.gatewayID,gatewayPwd.gatewayPWD,gateway.gatewayPWD);
    
    //判断是否为合法用户
    if ([_showGatewayPWDView.thirdField.text  isEqual:gateway.gatewayPWD]) {
        
        //如果旧密码输入正确，则判断为合法用户，重置密码成功
        [gatewayMessageTool   updateGatewayPWD:gatewayPwd];
        
        SocketManager *socket = [SocketManager  shareSocketManager];
        
        NSString *head = @"41414444";
        NSString *stamp = @"30303030";
        NSString *gatewayID = gateway.gatewayID;
        NSString *devMac = @"3030303030303030";
        NSString *devType = @"320066000010";
        NSString *OldPWDtext = [ControlMethods  stringToByte:_showGatewayPWDView.thirdField.text];
        NSString *NewPWD = [ControlMethods  stringToByte:_showGatewayPWDView.fourthField.text];
        
        NSString *string1 = [head  stringByAppendingString:stamp];
        NSString *string2 = [string1 stringByAppendingString:gatewayID];
        NSString *string3 = [string2  stringByAppendingString:devMac];
        NSString *string4 = [string3  stringByAppendingString:devType];
        NSString *string5 = [string4  stringByAppendingString:OldPWDtext];
        NSString *string6 = [string5  stringByAppendingString:NewPWD];
        
        [socket sendMsg:string6];

    }else{
    
        //提醒用户旧密码输入不正确
        [MBProgressHUD  showError:@"旧密码不正确,请重新输入"];
    
    }
    
    LZXDataCenter *dataCenter = [LZXDataCenter  defaultDataCenter];
    
    versionMessageModel *gatewayVersion = [[versionMessageModel  alloc]init];
    
    gatewayVersion.phoneNum = dataCenter.userPhoneNum;
    gatewayVersion.gatewayNum = gateway.gatewayID;
    gatewayVersion.versionType = @"6";
    
    NSArray *gatewayVersionArray =  [versionMessageTool  queryWithVersionType:gatewayVersion];
    
    if (gatewayVersionArray.count == 0) {//没有此网关的版本信息
        
        gatewayVersion.updateTime = [ControlMethods getCurrentTime];
        
        [versionMessageTool  addVersionMessage:gatewayVersion];
        
    }else{//有此网关的信息 则更新updatetime
        
        gatewayVersion.updateTime = [ControlMethods  getCurrentTime];
        
        [versionMessageTool  updateVersionMessage:gatewayVersion];
        
    }

   
    [_collectionView  reloadData];

    
}

//点击界面 退出蒙版
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    //停止搜索网关IP
    [self.lanScanner stopScan];
    [self.timers  invalidate];
    [MBProgressHUD  hideAllHUDsForView:self.fullscreenView animated:YES];
    
    //点击界面 退出蒙版效果
    [_showView  hiddenInView:self.view animated:YES];
   
}

/**
 *  点击确定 更新网关ip
 */
-(void)updateGatewayip{
    
    //查找数据库中所有存在的网关设备
    NSArray  *gateways = [gatewayMessageTool  queryWithgateways];
    //建立模型
    gatewayMessageModel *gateway = gateways[indexNum];
    gatewayMessageModel  *gatewayip = [[gatewayMessageModel alloc]init];
    
    gatewayip.gatewayID = _showGatewayIPView.secondaryField.text;
    gatewayip.gatewyIP = _showGatewayIPView.thirdField.text;
  
    NSLog(@"gatewyIP = %@ gatewayID = %@", gatewayip.gatewyIP,gatewayip.gatewayID);
    
    if ([gatewayip.gatewayID isEqualToString:@" "] && [gatewayip.gatewyIP isEqualToString:@" "]) {
        
  
        [MBProgressHUD  showError:@"请输入主机IP"];
        
    }else{
    
        [gatewayMessageTool   updateGatewayIP:gatewayip];


    }
    
    [MBProgressHUD  hideHUD];
    
    LZXDataCenter *dataCenter = [LZXDataCenter  defaultDataCenter];
    
    versionMessageModel *gatewayVersion = [[versionMessageModel  alloc]init];
    
    gatewayVersion.phoneNum = dataCenter.userPhoneNum;
    gatewayVersion.gatewayNum = gateway.gatewayID;
    gatewayVersion.versionType = @"6";
    
    NSArray *gatewayVersionArray =  [versionMessageTool  queryWithVersionType:gatewayVersion];
    
    if (gatewayVersionArray.count == 0) {//没有此网关的版本信息
        
        gatewayVersion.updateTime = [ControlMethods getCurrentTime];
        
        [versionMessageTool  addVersionMessage:gatewayVersion];
        
    }else{//有此网关的信息 则更新updatetime
        
        gatewayVersion.updateTime = [ControlMethods  getCurrentTime];
        
        [versionMessageTool  updateVersionMessage:gatewayVersion];
        
    }
    
    [_collectionView  reloadData];

}


/**
 *  提醒用户是否需要删除主机设备 （是否要发删除报文给 服务器）
 */
-(void)deleteGateway{
    
    [_showView  hiddenInView:self.view animated:YES];

    UIAlertView * alert = [[UIAlertView  alloc]initWithTitle:@"温馨提示" message:@"确定要删除主机吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    self.alert = alert;
    
    [alert show];
    
}


/**
 *  删除网关
 */
-(void)deleteGateways{

    //删除的时候，设置别名为空
    [JPUSHService setAlias:@"" callbackSelector:nil object:nil];
    
    //查找数据库中所有存在的网关设备
    NSArray  *gateways = [gatewayMessageTool  queryWithgateways];
    
    //建立模型
    gatewayMessageModel *gateway = gateways[indexNum];
    
    //取出当前cell中的网关信息
    gatewayMessageModel  *gatewayIndex = [[gatewayMessageModel  alloc]init];
    
    gatewayIndex.gatewayID = gateway.gatewayID;
    
   // NSLog(@"%@",gatewayIndex.gatewayID);
    
    //删除当前网关
    [gatewayMessageTool  delete:gatewayIndex];
    
    //更新cell中网关设备
    _gateways=[gatewayMessageTool   queryWithgateways];

    //刷新collectionView
    [_collectionView  reloadData];
    

}

/**
 *
 *解除当前手机号下 绑定的网关
 */

-(void)appUnbindingGatewayNo{

   //创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager  manager];
    
    mgr.responseSerializer = [AFJSONResponseSerializers  serializer];
    
    //配置请求超时时间
    mgr.requestSerializer.timeoutInterval = 60;
    
    NSString *gatewayVersion = [queryDeviceControlMethods  allDeviceVersionList:@"6"] ;
    
    //设置请求参数
    NSMutableDictionary  *params = [NSMutableDictionary  dictionary];
    
    params[@"versionJson"] = gatewayVersion;
    params[@"phoneNum"] = _dataCenter.userPhoneNum;;
    
    //NSLog(@"%@",params);
    
    NSString  *urlStr =[NSString  stringWithFormat:@"%@/appUnbindGatewayNo" ,HomecooServiceURL];
    NSString *url = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
    
    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        //打印日志
         NSLog(@"请求成功--%@",responseObject);
        NSString  *result = [responseObject[@"result"]description];
        
        NSString *message = [responseObject[@"messageInfo"]description];
        
        if ([result  isEqual:@"success"]) {//同步成功
            
            [MBProgressHUD  showSuccess:[NSString  stringWithFormat:@"%@",message]];
            //删除网关 清除本地的网关表
            [self deleteGateways ];
            
        }
        if ([result  isEqual:@"failed"]) {
            
            [MBProgressHUD  showError:[NSString  stringWithFormat:@"%@",message]];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD  showError:@"网络繁忙，请稍后再试"];
    }];


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
    CGFloat  WhiteBackgroundLableH = [UIScreen  mainScreen].bounds.size.height -140;
    WhiteBackgroundLable.frame = CGRectMake(WhiteBackgroundLableX, WhiteBackgroundLableY, WhiteBackgroundLableW, WhiteBackgroundLableH);
    
    WhiteBackgroundLable.backgroundColor = [UIColor  whiteColor];
    
    WhiteBackgroundLable.clipsToBounds = YES;
    WhiteBackgroundLable.layer.cornerRadius = 8.0;//设置边框圆角
    self.WhiteBackgroundLable = WhiteBackgroundLable;
    
    [self.fullscreenView addSubview:WhiteBackgroundLable];
    
}

/**
 *  点击按钮添加新网关
 */
-(void)setupGateway{

    UIButton  *setupGatewayBtn = [[UIButton  alloc]init];
    
    CGFloat setupGatewayBtnX =20;
    CGFloat setupGatewayBtnY =60;
    CGFloat setupGatewayBtnW =130;
    CGFloat setupGatewayBtnH =30;
    
    setupGatewayBtn.frame = CGRectMake(setupGatewayBtnX, setupGatewayBtnY, setupGatewayBtnW, setupGatewayBtnH);
    [setupGatewayBtn  setTitle:@"+请按此处添加新主机" forState:UIControlStateNormal];
    [setupGatewayBtn  setTitle:@"+请按此处添加新主机" forState:UIControlStateHighlighted];
    [setupGatewayBtn  setTitleColor:[UIColor  blackColor] forState:UIControlStateNormal];
    [setupGatewayBtn  setTitleColor:[UIColor  blackColor] forState:UIControlStateHighlighted];
    //setupGatewayBtn.backgroundColor = [UIColor  redColor];
    //[setupGatewayBtn  setFont:[UIFont  systemFontOfSize:13]];
    setupGatewayBtn.titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:13];
    
    
    
    [setupGatewayBtn  addTarget:self action:@selector(setupGatewayAction) forControlEvents:UIControlEventTouchUpInside];
        
    
    UIButton *refreshBtn = [[UIButton  alloc]init];
    
    CGFloat refreshBtnX =CGRectGetMaxX(self.WhiteBackgroundLable.frame)-100;//WhiteBackgroundLable
    CGFloat refreshBtnY =65;
    CGFloat refreshBtnW =85;
    CGFloat refreshBtnH =22;

    refreshBtn.frame = CGRectMake(refreshBtnX, refreshBtnY, refreshBtnW, refreshBtnH);
    [refreshBtn  setTitle:@"搜索主机IP" forState:UIControlStateNormal];
    [refreshBtn  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [refreshBtn  setTitle:@"搜索主机IP" forState:UIControlStateHighlighted];
    [refreshBtn  setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];

    [refreshBtn  setImage:[UIImage  imageNamed:@"refresh.png"] forState:UIControlStateNormal];
    [refreshBtn  setImage:[UIImage  imageNamed:@"refresh.png"] forState:UIControlStateHighlighted];
    refreshBtn.imageEdgeInsets = UIEdgeInsetsMake(1, 100, 1, 0);
    
    refreshBtn.titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:13];
    refreshBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
   
    refreshBtn.contentEdgeInsets = UIEdgeInsetsMake(0,-35, 0, 0);
//    [refreshBtn  addTarget:self action:@selector(startScanningLAN) forControlEvents:UIControlEventTouchUpInside];
    [refreshBtn  addTarget:self action:@selector(receiveUdpBordcastFromWG) forControlEvents:UIControlEventTouchUpInside];
    UILabel *searchGatewayIPLable = [[UILabel  alloc]initWithFrame:CGRectMake(CGRectGetMinX(refreshBtn.frame)-70, 60, 70, 30)];
    searchGatewayIPLable.text = @"搜索主机IP";
    searchGatewayIPLable.textAlignment = NSTextAlignmentCenter;
    searchGatewayIPLable.font = [UIFont  systemFontOfSize:13];
    
    [self.fullscreenView  addSubview:setupGatewayBtn];
    
    [self.fullscreenView  addSubview:refreshBtn];
    
    //[self.fullscreenView   addSubview:searchGatewayIPLable];

}

//主动接收网关的IP地址
-(void)receiveUdpBordcastFromWG{
    
     [MBProgressHUD  showMessage:@"正在搜索主机IP,请等待……" toView:self.fullscreenView];
    
    _udpSocket= [UdpSocketManager shareUdpSocketManager];
    
    _udpSocket.udpSocket.delegate = self;
    NSError *error;
    
    if([_udpSocket.udpSocket enableBroadcast:YES error:&error]){
        NSLog(@"udpSocket = %@",error);
    }
    
    [_udpSocket stopRunloopSendData];
    
    [_udpSocket runloopSendData:NULL host:@"255.255.255.255" port:9005 interval:1];
    
    [_udpSocket begingReceived:9005];
}


/**
 *  点击添加网关按钮 调用此方法 加载添加新网关界面
 */
-(void)setupGatewayAction{
    
    self.currentIndex = 2;
    
    self.addNewGatewayView.mainTitle.text = @"添加新主机";
    self.addNewGatewayView.secondaryTitle.text = @"主机ID :";
    self.addNewGatewayView.thirdTitle.text = @"主机IP :";
    self.addNewGatewayView.fourthTitle.text = @"主机密码:";
    self.addNewGatewayView.fourthField.secureTextEntry = YES;
    
    gatewayMessageModel *gateway = [[gatewayMessageModel  alloc]init];
    gateway.gatewayID = _dataCenter.gatewayNo;
    
    NSArray *gatewayArray = [gatewayMessageTool queryWithgatewaysBygatewayNo:gateway];
    if (gatewayArray.count!=0) {
        
        [MBProgressHUD showError:@"主机已存在,请勿重复添加!"];
        
    }else{
    
        [self.addNewGatewayView showGatewayView:self.view animated:YES];
        
    }
}

-(HCGatewayView *)addNewGatewayView{
    
    if(_addNewGatewayView == nil){
        
        _addNewGatewayView = [[HCGatewayView alloc]initWithFrame:CGRectZero];
        _addNewGatewayView.secondaryField.placeholder = @"请输入主机ID";
        _addNewGatewayView.thirdField.placeholder = @"请输入主机IP";
        _addNewGatewayView.fourthField.placeholder = @"请输入主机密码";
        
        _addNewGatewayView.delegate = self;
        
    }
    
    return _addNewGatewayView;
    
}



/**
 *  点击添加按钮 添加新的网关
 */

-(void)addgatewayAction{

    gatewayMessageModel *gateway = [[gatewayMessageModel  alloc]init];
    
    gateway.gatewayID = [ControlMethods stringToByte:_addNewGatewayView.secondaryField.text];
    
    gateway.gatewyIP = _addNewGatewayView.thirdField.text;
    
    gateway.gatewayPWD = _addNewGatewayView.fourthField.text;;
   
    //NSLog(@" %@ %@ %@",gateway.gatewayID ,gateway.gatewyIP ,gateway.gatewayPWD );
    
    if ([gateway.gatewayID isEqualToString:@""] && [gateway.gatewayPWD  isEqualToString:@""] &&[gateway.gatewyIP isEqualToString:@""]) {//判断新加入的网关设备信息完整
       
        [MBProgressHUD  showError:@"请输入完整的主机信息!"];
        
       
    }else{
       
        [gatewayMessageTool  addGateway:gateway];
        
        _gateways=[gatewayMessageTool   queryWithgateways];
        
        [_collectionView reloadData];
       
        //添加新网关版本信息
        [self  addNewGatewayVersion:[ControlMethods stringToByte:_addNewGatewayView.secondaryField.text]];
        
       
    }
    
    [MBProgressHUD  hideHUD];

}

/**
 *  添加新网关版本信息
 */
-(void)addNewGatewayVersion:(NSString*)gatewayNum{

    LZXDataCenter *dataCenter = [LZXDataCenter  defaultDataCenter];
    
    versionMessageModel *gatewayVersion = [[versionMessageModel  alloc]init];
    
    gatewayVersion.phoneNum = dataCenter.userPhoneNum;
    gatewayVersion.gatewayNum = gatewayNum;;
    gatewayVersion.versionType = @"6";
    
    NSArray *gatewayVersionArray =  [versionMessageTool  queryWithVersionType:gatewayVersion];
    
    if (gatewayVersionArray.count == 0) {//没有此网关的版本信息
        
        gatewayVersion.updateTime = [ControlMethods getCurrentTime];
        
        [versionMessageTool  addVersionMessage:gatewayVersion];
        
    }else{//有此网关的信息 则更新updatetime
        
        gatewayVersion.updateTime = [ControlMethods  getCurrentTime];
        
        [versionMessageTool  updateVersionMessage:gatewayVersion];

    }
    

}

/**
 *  手机客户端同步网关信息到服务器
 */
//-(void)asyncGatewayInfo{
//
//    UIButton *asyncGatewayInfoBtn = [[UIButton  alloc]init];
//    
//    CGFloat asyncGatewayInfoBtnX =[UIScreen  mainScreen].bounds.size.width-80;
//    CGFloat asyncGatewayInfoBtnY =60;
//    CGFloat asyncGatewayInfoBtnW =60;
//    CGFloat asyncGatewayInfoBtnH =30;
//
//    asyncGatewayInfoBtn.frame =CGRectMake(asyncGatewayInfoBtnX, asyncGatewayInfoBtnY, asyncGatewayInfoBtnW, asyncGatewayInfoBtnH);
//    
//    [asyncGatewayInfoBtn  setTitle:@"同步网关" forState:UIControlStateNormal];
//    [asyncGatewayInfoBtn  setTitle:@"同步网关" forState:UIControlStateHighlighted];
//    [asyncGatewayInfoBtn  setTitleColor:[UIColor  blackColor] forState:UIControlStateNormal];
//    [asyncGatewayInfoBtn  setTitleColor:[UIColor  orangeColor] forState:UIControlStateHighlighted];
//    [asyncGatewayInfoBtn  setFont:[UIFont  systemFontOfSize:13]];
//    [asyncGatewayInfoBtn  addTarget:self action:@selector(asyncGatewayInfoAction) forControlEvents:UIControlEventTouchUpInside];
//    //asyncGatewayInfoBtn.backgroundColor = [UIColor  redColor];
//    
//    [self.fullscreenView  addSubview:asyncGatewayInfoBtn];
//
//
//}

/**
 *   手机客户端同步网关信息到服务器方法
 */
-(void)asyncGatewayInfoAction{
    
    LZXDataCenter *dataCenter = [LZXDataCenter  defaultDataCenter];
    
    //创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager  manager];
    
    mgr.responseSerializer = [AFJSONResponseSerializers  serializer];
    
    //配置请求超时时间
    mgr.requestSerializer.timeoutInterval = 60;
    
    NSString *gatewayMessage = [[queryDeviceControlMethods  allUserGatewayList] componentsJoinedByString:@","];
    
    NSString *gatewayMessageAppding = [@"[" stringByAppendingString:gatewayMessage];
    
    NSString *gatewayJson = [gatewayMessageAppding  stringByAppendingString:@"]"];
    
    NSString *gatewayVersion = [queryDeviceControlMethods  allDeviceVersionList:@"6"] ;
    
    //设置请求参数
    NSMutableDictionary  *params = [NSMutableDictionary  dictionary];
    
    params[@"gatewayJson"] = gatewayJson;
    params[@"versionJson"] = gatewayVersion;
    params[@"phonenum"] = dataCenter.userPhoneNum;;

    //NSLog(@"%@",params);
    
    NSString  *urlStr =[NSString  stringWithFormat:@"%@/appSyncGatewayInfo" ,HomecooServiceURL];
    NSString *url = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
    
    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        //打印日志
        // NSLog(@"请求成功--%@",responseObject);
        NSString  *result = [responseObject[@"result"]description];
        
        NSString *message = [responseObject[@"messageInfo"]description];
        
        if ([result  isEqual:@"success"]) {//同步成功
            
            [MBProgressHUD  showSuccess:[NSString  stringWithFormat:@"%@",message]];
        }
        if ([result  isEqual:@"failed"]) {
            
            [MBProgressHUD  showError:[NSString  stringWithFormat:@"%@",message]];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD  showError:@"网络繁忙，请稍后再试"];
    }];
    
}


/**
 *设置导航栏
 */
-(void)setNavBar{
    
    
    CGFloat navBarW = [UIScreen  mainScreen].bounds.size.width;
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0,navBarW, 40)];
    
    //创建一个导航栏集合
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"主机设置"];
    
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
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleDone target:self action:@selector(asyncGatewayInfoAction)];
    rightButton.title = @"完成";
    rightButton.tintColor = [UIColor  blackColor];
    //把导航栏集合添加到导航栏中，设置动画关闭
    [navBar pushNavigationItem:navItem animated:NO];
    
    //把左右两个按钮添加到导航栏集合中去
    [navItem setLeftBarButtonItem:leftButton];
    [navItem setRightBarButtonItem:rightButton];
    
    //将标题栏中的内容全部添加到主视图当中
    [self.fullscreenView addSubview:navBar];
    
}
/**返回到上一个systemView*/
-(void)backAction{
    
    SettingViewController  *vc = [[SettingViewController  alloc]init];
    [self  presentViewController:vc animated:YES completion:nil];
    
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

#pragma mark *******************************************
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext{
    
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if([str isEqualToString:@"TWRT-IP-BROADCAST"]){
        
        [_udpSocket stopRunloopSendData];
        
        NSString *Address = [[NSString stringWithFormat:@"%@",address] substringWithRange:NSMakeRange(10, 8)];
        
        
        NSString *IpAdded = @"";
        
        for (int i = 0; i<[Address length]/2; i++) {
            
            NSString * temp10 = [NSString stringWithFormat:@"%lu",strtoul([[Address substringWithRange:NSMakeRange(2*i, 2)]UTF8String],0,16)];
            IpAdded  =[NSString stringWithFormat:@"%@.%@",IpAdded,temp10];
        }
        
        NSString *GateqayIp =[IpAdded substringFromIndex:1 ];
        
        [MBProgressHUD  hideAllHUDsForView:self.fullscreenView animated:YES];
        [[[UIAlertView alloc] initWithTitle:@"主机IP匹配成功" message:GateqayIp delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        
        NSArray * gateways=[gatewayMessageTool   queryWithgateways];
        
        NSString * gatewayNo;
        NSString * gatewayPwd;
        
        if (gateways.count!=0) {
            gatewayMessageModel *gatewayModel = gateways[0];//业务逻辑中 只有一个网关
            gatewayNo = gatewayModel.gatewayID;
            gatewayPwd = gatewayModel.gatewayPWD;
            
        }
        gatewayMessageModel  *gatewayip = [[gatewayMessageModel alloc]init];
        
        gatewayip.gatewayID =gatewayNo;
        
        gatewayip.gatewyIP = GateqayIp;
        
        //将搜索到的网关IP插入网关表
        [gatewayMessageTool   updateGatewayIP:gatewayip];
        
        
        
    }
    
    
}



-(BOOL)shouldAutorotate{
    return YES;
}



-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}
@end
