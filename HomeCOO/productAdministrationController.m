//
//  productAdministrationController.m
//  HomeCOO
//
//  Created by tgbus on 16/6/27.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "productAdministrationController.h"
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
#import "spaceMessageModel.h"
#import "spaceMessageTool.h"
#import "deviceSpaceMessageModel.h"
#import "deviceSpaceMessageTool.h"
#import "spaceCollectionViewCell.h"
#import "gatewayMessageModel.h"
#import "gatewayMessageTool.h"
#import "NSString+Hash.h"
#import "lightCollectionViewCell.h"
#import "deviceMessage.h"
#import "deviceMessageTool.h"
#import "productCollectionViewCell.h"
#import "themeMessageTool.h"
#import "themMessageModel.h"
#import "getFromServerDevices.h"
#import "MJExtension.h"
#import "transCodingMethods.h"
#import "ControlMethods.h"
#import "LZXDataCenter.h"
#import "versionMessageModel.h"
#import "versionMessageTool.h"
#import "queryDeviceControlMethods.h"
#import "PacketMethods.h"
#import "JPUSHService.h"
#import "SocketManager.h"
#import "transCodingMethods.h"
#import "alarmMessages.h"
#import "alarmMessagesTool.h"
#import "alarmRinging.h"
#import "HCDaterView.h"
#import "HCProductView.h"
#import "HCSpaceView.h"
#import "HCThemeView.h"
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

@interface productAdministrationController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextFieldDelegate,HCDaterViewDelegate,HCProductViewDelegate,HCSpaceViewDelegate,HCThemeViewDelegate>

/**设置背景图片*/
@property(nonatomic,weak)  UIImageView  * fullscreenView;

/**设置导航栏*/
@property(nonatomic,weak)  UINavigationBar *navBar;

/**设置白色背景*/
@property(nonatomic,weak) UILabel  *WhiteBackgroundLable;

/**设置提示框背景*/
@property(nonatomic,weak)UILabel  *WhiteBackground;

@property(nonatomic,strong) HCDaterView *switchView;

@property(nonatomic,strong) HCDaterView *themeSwitchView;

@property(nonatomic,strong) HCProductView *proMsgView;

@property(nonatomic,strong) HCSpaceView *spacesView;

@property(nonatomic,strong) HCThemeView *themeNameView;

@property NSInteger remoteFlag;
/**设置蒙版*/
@property(nonatomic,weak) UIView  *backgroundView;

/**UICollectionView 容器*/
@property (weak, nonatomic)  UICollectionView *collectionView;

/**设备cell */
@property(nonatomic,weak) productCollectionViewCell *cell;

/**存放查询到的设备*/  //strong  强引用  （测试6s）
@property(nonatomic,strong)  NSMutableArray *devices;

/**设置所有的添加的新空间*/
@property(nonatomic,strong)  NSArray *spaces;

@property(nonatomic,weak)  UITextField *spaceNameField;

@property(nonatomic,weak) UITextField  *productPositionField;

@property(nonatomic,weak) UITextField  *productNameField;

@property(nonatomic,weak) UITableView *tableView;

@property(nonatomic,weak) UIButton  *positionBtn;

@property(nonatomic,weak) UITextField  *themeNameField_1;

@property(nonatomic,weak) UITextField  *themeNameField_2;

@property(nonatomic,weak) UITextField  *themeNameField_3;

@property(nonatomic,weak) UITextField  *themeNameField_4;


/**用来接收服务器返回的devicetable表中设备信息 */
@property(nonatomic,weak) NSArray *devicesMessages;

/**用来接收服务器返回的userDeviceSpaceList表中设备空间信息 */
@property(nonatomic,weak) NSArray * userDeviceSpaceList;

@property(nonatomic,weak) UIButton *button;

@property(nonatomic,weak) UIButton * indoorBtn;

@property(nonatomic,weak) UIButton * outdoorBtn;

@property(nonatomic,strong) UIAlertView * alert;

@property(nonatomic,copy) NSString * alarmString;

@property(nonatomic,copy) NSString *alertString;

@property(nonatomic,strong)  LZXDataCenter  *dataCenter;

@property(nonatomic,strong) deviceMessage *devicess;
@property(nonatomic,strong) deviceMessage *device;
@property(nonatomic,strong)  deviceSpaceMessageModel *deviceSpace;
@property(nonatomic,strong) deviceMessage * devcieMessage;
@property(nonatomic,strong) NSString *str;
@property(nonatomic,strong) deviceSpaceMessageModel * userDeviceSpace;
@property(nonatomic,strong) deviceSpaceMessageModel *space;

@property(nonatomic,strong) NSArray *deviceArray;

@end


static NSString *string = @"productCollectionViewCell";

static  NSInteger indexNum;

@implementation productAdministrationController


-(NSMutableArray *)devices{

    if (_devices==nil) {
        
    LZXDataCenter *gateway = [LZXDataCenter defaultDataCenter];
    
    if ([gateway.gatewayNo isEqualToString:@"0"] | !gateway.gatewayNo ) {
        
        [MBProgressHUD  showError:@"请先添加主机"];
        
    }else{
        
        deviceMessage *device = [[deviceMessage alloc]init];
        device.GATEWAY_NO = gateway.gatewayNo;
        
        _devices=[deviceMessageTool queryWithDevices:device];
      
        
    }
    
    [MBProgressHUD  hideHUD];
        
    }
    
    return _devices;
    
}

-(NSArray *)spaces{
    
    if (_spaces==nil) {
        
        LZXDataCenter *spaceCenter = [LZXDataCenter defaultDataCenter];
        
        if ([spaceCenter.gatewayNo isEqualToString:@"0"] | !spaceCenter.gatewayNo ) {
            
            [MBProgressHUD  showError:@"请先添加主机"];
            
        }else{
            
            spaceMessageModel *space = [[spaceMessageModel alloc]init];
            space.gateway_Num = spaceCenter.gatewayNo;
            space.phone_Num = spaceCenter.userPhoneNum;
            
            _spaces=[spaceMessageTool  queryWithspaces:space];
            
        }
        [MBProgressHUD  hideHUD];
        
    }
    
    return _spaces;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //设置背景
    [self setFullscreenView];
    
    //创建一个导航栏
    [self setNavBar];
    
    LZXDataCenter  *dataCenter = [LZXDataCenter  defaultDataCenter];
    
    self.dataCenter = dataCenter;
    //设置底片背景
    [self  setWhiteBackground];
    
    //添加UICollectionView
    //[self  addUICollectionView];
   
    [self  performSelector:@selector(addUICollectionView) withObject:nil afterDelay:0.5];
    
    //放在后台运行
   
    self.dataCenter = dataCenter;
    
    if (dataCenter.networkStateFlag == 0) {//内网
        //内网情况下 接受底层反馈消息
        [self   receivedFromGateway_deviceMessage];
        
    }else{
    
        //从服务器获取设备
        [self  getAllDevices];
        
        //注册通知
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        
        [defaultCenter addObserver:self
                          selector:@selector(networkDidReceiveMessage:)
                              name:kJPFNetworkDidReceiveMessageNotification
                            object:nil];
    }
   

}

/**
 *  接收到JPUSH自定义消息 调用此方法
 *
 *  @param notification
 */
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    
    //外网情况下  接收底层上报状态 刷新UI
    [_collectionView  reloadData];
    
    
}
-(NSString*)getAllDevicesFromLocal{
    
    NSString *header = @"41414444";//发送给服务器的报头
    
    NSString *stamp = @"00000000";//没有用到的字段
    
    NSString *gw_id = _dataCenter.gatewayNo;
    
    NSString *dev_id = @"3030303030303030";
    
    NSString *dev_type = @"3200";
    
    NSString *data_type = @"1b00";//情景删除18
    
    NSString *data_len = @"0001";
    
    NSString *data = @"30";
    
    //拼接发送报文
    NSString *packet = [PacketMethods  devicePacket:header getStamp:stamp getGw_id:gw_id getDev_id:dev_id getDev_type:dev_type getData_type:data_type getData_len:data_len getData:data];
    
    NSString *deviceControlPacketStr = [packet stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
    
    NSLog(@"    内网获取所有设备报文  %@",deviceControlPacketStr);
    
    return  deviceControlPacketStr;
}

/**
 *  内网情况下，接收底层设备手动出发报上来的信息（用于更新设备状态）
 *
 *  @return
 */
-(void)receivedFromGateway_deviceMessage{
    
    SocketManager  *socket = [SocketManager  shareSocketManager];
    
    NSString *head = @"4141444430303030";
    NSString *gatewayNo = _dataCenter.gatewayNo;
    NSString *otherData =@"000000000000000033001B00000000";
    NSString *data = [head stringByAppendingString:gatewayNo];
   
    //先删除设备表 设备信息表
    //[deviceMessageTool  deleteDeviceTable];
    
    [socket  sendMsg:[self  getAllDevicesFromLocal]];
    
    //内网情况下 获取风扇状态
    [socket  sendMsg:[data stringByAppendingString:otherData]];
   
    [socket receiveMsg:^(NSString *receiveInfo) {
        
        NSString *receiveMessage = receiveInfo;
        
        _str  =[NSString stringWithFormat:@"%@%@",_str,receiveInfo];

        NSString*  gw_id;//内网情况下 退网的时候 设备的id 全部是0
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
        
        dispatch_async(dispatch_get_main_queue(), ^{

            NSArray *deviceArray = [deviceMessageTool  queryWithDeviceNumDevices:dev];
            
            if([data_type isEqualToString:@"0100"]){//上行报文
                
                if (deviceArray.count == 0) {//添加新设备
                    
                    
                    [deviceMessageTool  addDevice:device];
                    
                }else{//更新设备状态
                    
                  
                    [deviceMessageTool  updateDeviceMessageOnlyLocal:device];
                    
                }
                
            }if([data_type isEqualToString:@"0c00"]){//退网报文
                
                if (deviceArray.count != 0){
                    
                    
                    [deviceMessageTool  deleteDevice:dev];

                }
                
            }
        
            //回到主线程 刷新UI
            [_collectionView  reloadData];
            
        });

        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2* NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       
                      
                       NSArray *array = [_str componentsSeparatedByString:@"41414444"];
                       
                       _deviceArray = array;

                       [self updateDeviceLocalTable];
                   });
}

/**
 *  更新设备表
 */
-(void)updateDeviceLocalTable{
    
    if (_devcieMessage==nil) {
        
        _devcieMessage = [[deviceMessage alloc]init];
    }
    NSInteger  count;
    NSString * deviceStateStr;
    NSString * temp;
    NSString * humi;
    NSString *devicePacket;
    NSInteger  deviceCategoryId = 0 ;
    NSString *deviceName;
    NSString *deviceStateCmd;
    NSString *spaceTypeId ;
    NSString *spaceNo;
    NSString *phoneNum;
    NSString *deviceNo;
    NSString *gatewayNo;
    NSString* data;
    NSInteger deviceTypeId;
    NSInteger  PM2_5H ;
    NSInteger  PM2_5L ;
    NSInteger  PM2_5;

    if (_deviceArray.count ==0) {
        
        count = 0;
        
    }else{
        
        count = _deviceArray.count;
    }
    

    for (int i = 1; i<count; i++) {//self.devicesMessages.count
        
        devicePacket = _deviceArray[i];

        spaceTypeId =@"0";
        spaceNo = @"0";
        deviceTypeId = strtoul([[devicePacket substringWithRange:NSMakeRange(40, 2)] UTF8String], 0, 16);
        phoneNum = _dataCenter.userPhoneNum;
        deviceNo =[devicePacket  substringWithRange:NSMakeRange(24, 16)];
        gatewayNo = _dataCenter.gatewayNo;
        data = [devicePacket  substringFromIndex:52];
        
        //NSLog(@" 设备报文 = %@",devicePacket);
//        NSLog(@"spaceTypeId = %@ spaceNo = %@ deviceTypeId = %ld phoneNum = %@ deviceNo =%@ gatewayNo = %@ data = %@",spaceTypeId,spaceNo,(long)deviceTypeId,phoneNum,deviceNo,gatewayNo,data);
//
        //在device表中查找是否有该设备
        deviceMessage *device = [[deviceMessage  alloc]init];
        device.DEVICE_NO =deviceNo;
        device.GATEWAY_NO = _dataCenter.gatewayNo;
        
        NSArray  * deviceArray= [deviceMessageTool  queryWithDeviceNumDevices:device];
        
        if (deviceArray.count == 0) {//没有此设备 则向设备表中查入该条设备
            
            switch (deviceTypeId ) {
                case 1:
                    
                    deviceCategoryId = 1;
                    deviceName = @"一路开关";
                    deviceStateCmd = [transCodingMethods  transCodingFromServer:data];
                    break;
                case 2:
                    
                    deviceCategoryId = 1;
                    deviceName = @"二路开关";
                    deviceStateCmd = [transCodingMethods  transCodingFromServer:data ];
                    break;
                case 3:
                    
                    deviceCategoryId = 1;
                    deviceName = @"三路开关";
                    deviceStateCmd = [transCodingMethods  transCodingFromServer:data ];
                    break;
                case 4:
                    
                    deviceCategoryId = 1;
                    deviceName = @"四路开关";
                    deviceStateCmd = [transCodingMethods  transCodingFromServer:data ];
                    break;
                case 5:
                    deviceCategoryId = 1;
                    deviceName = @"调光开关";
                    deviceStateCmd =[NSString  stringWithFormat:@"%lu",strtoul([[data substringWithRange:NSMakeRange(0, 2)] UTF8String], 0, 16)];
                    if ([deviceStateCmd isEqualToString:@"10"]) {
                        deviceStateCmd = @"9";
                    }
                    break;
                case 6:
                    deviceCategoryId = 3;
                    deviceName = @"窗帘";
                    deviceStateCmd = [transCodingMethods  transCodingFromServer:data ];
                    break;
                case 8:
                    deviceCategoryId = 5;
                    deviceName = @"插座";
                    deviceStateCmd = [transCodingMethods  transCodingFromServer:data ];
                    
                    break;
                case 11:
                    deviceCategoryId = 3;
                    deviceName = @"窗户";
                    deviceStateCmd = [transCodingMethods  transCodingFromServer:data ];
                    break;
                case 51:
                    deviceCategoryId = 2;
                    deviceName = @"空气净化器";
                    deviceStateCmd = [transCodingMethods  transCodingFromServer:data ];
                    
                    break;
                case 104:
                    
                    deviceCategoryId = 2;
                    deviceName = @"温湿度";
                    temp = [NSString stringWithFormat:@"%lu",strtoul([[data substringWithRange:NSMakeRange(2, 2)] UTF8String], 0, 16)];
                    humi = [NSString  stringWithFormat:@"%lu",strtoul([[data substringWithRange:NSMakeRange(6, 2)] UTF8String], 0, 16)];
                    deviceStateStr = [temp  stringByAppendingString:@"p" ];
                    deviceStateCmd = [deviceStateStr  stringByAppendingString:humi];
                    
                    break;
                case 105:
                    deviceName = @"红外转发器";
                    deviceStateCmd = data;
                    break;
                case 109:
                    deviceCategoryId = 2;
                    deviceName = @"PM2.5";
                    PM2_5H = strtoul([[data substringWithRange:NSMakeRange(0, 2)] UTF8String], 0, 16);
                    PM2_5L = strtoul([[data substringWithRange:NSMakeRange(2, 2)] UTF8String], 0, 16);
                    PM2_5 = PM2_5H *10 + PM2_5L/10;
                    deviceStateCmd  = [NSString  stringWithFormat:@"%ld",(long)PM2_5];
                    
                    break;
                case 110:
                    deviceCategoryId = 2;
                    deviceName = @"门磁";
                    deviceStateCmd = [transCodingMethods  transThemeCodingFromServer:data ];
                   
                    break;
                case 113:
                    deviceCategoryId = 2;
                    deviceName = @"红外感应";
                    deviceStateCmd = [transCodingMethods  transThemeCodingFromServer:data ];
                    
                    
                    break;
                case 115:
                    deviceCategoryId = 2;
                    deviceName = @"燃气";
                    deviceStateCmd = [transCodingMethods  transThemeCodingFromServer:data ];
                    
                    break;
                    
                case 118:
                    deviceCategoryId = 2;
                    deviceName = @"烟感";
                    deviceStateCmd = [transCodingMethods  transThemeCodingFromServer:data ];
                   
                    break;
                case 201:
                    deviceCategoryId = 6;
                    deviceName = @"双控";
                    deviceStateCmd = [transCodingMethods  transThemeCodingFromServer:data ];
                    break;
                case 202:
                    deviceCategoryId = 4;
                    deviceName = @"情景开关";
                    deviceStateCmd = [transCodingMethods  transThemeCodingFromServer:data];
                    break;
            }
            
            
            _devcieMessage.DEVICE_GATEGORY_ID = deviceCategoryId;
            //devcieMessage.DEVICE_GATEGORY_NAME = @"";
            _devcieMessage.DEVICE_NAME = deviceName;
            _devcieMessage.DEVICE_NO = deviceNo;
            _devcieMessage.DEVICE_STATE = deviceStateCmd;
            _devcieMessage.DEVICE_TYPE_ID = deviceTypeId ;
            //devcieMessage.DEVICE_TYPE_NAME = @"";
            _devcieMessage.GATEWAY_NO = gatewayNo;
            _devcieMessage.PHONE_NUM = phoneNum;
            _devcieMessage.SPACE_NO = spaceNo;
            _devcieMessage.SPACE_TYPE_ID = [spaceTypeId intValue];
            
            // NSLog(@"=======devcieMessage.DEVICE_GATEGORY_ID=%ld  devcieMessage.DEVICE_GATEGORY_NAME=%@  devcieMessage.DEVICE_NAME= %@    devcieMessage.DEVICE_NO=%@   devcieMessage.DEVICE_TYPE_ID=%ld   devcieMessage.DEVICE_TYPE_NAME=%@   devcieMessage.GATEWAY_NO=%@   devcieMessage.PHONE_NUM=%@   devcieMessage.SPACE_NO=%@   devcieMessage.SPACE_TYPE_ID=%ld",(long)devcieMessage.DEVICE_GATEGORY_ID,devcieMessage.DEVICE_GATEGORY_NAME,devcieMessage.DEVICE_NAME, devcieMessage.DEVICE_NO,(long)devcieMessage.DEVICE_TYPE_ID,devcieMessage.DEVICE_TYPE_NAME,devcieMessage.GATEWAY_NO,devcieMessage.PHONE_NUM,devcieMessage.SPACE_NO,(long)devcieMessage.SPACE_TYPE_ID);
           
            [deviceMessageTool  addDevice:_devcieMessage];
            
           
        }else{//有次设备则更新设备信息
            
            switch (deviceTypeId ) {
                case 1:
                    
                    deviceCategoryId = 1;
                    deviceName = @"一路开关";
                    deviceStateCmd = [transCodingMethods  transCodingFromServer:data];
                    break;
                case 2:
                    
                    deviceCategoryId = 1;
                    deviceName = @"二路开关";
                    deviceStateCmd = [transCodingMethods  transCodingFromServer:data ];
                    break;
                case 3:
                    
                    deviceCategoryId = 1;
                    deviceName = @"三路开关";
                    deviceStateCmd = [transCodingMethods  transCodingFromServer:data ];
                    break;
                case 4:
                    
                    deviceCategoryId = 1;
                    deviceName = @"四路开关";
                    deviceStateCmd = [transCodingMethods  transCodingFromServer:data ];
                    break;
                case 5:
                    deviceCategoryId = 1;
                    deviceName = @"调光开关";
                    deviceStateCmd =[NSString  stringWithFormat:@"%lu",strtoul([[data substringWithRange:NSMakeRange(0, 2)] UTF8String], 0, 16)];
                    if ([deviceStateCmd isEqualToString:@"10"]) {
                        deviceStateCmd = @"9";
                    }
                    break;
                case 6:
                    deviceCategoryId = 3;
                    deviceName = @"窗帘";
                    deviceStateCmd = [transCodingMethods  transCodingFromServer:data ];
                    break;
                case 8:
                    deviceCategoryId = 5;
                    deviceName = @"插座";
                    deviceStateCmd = [transCodingMethods  transCodingFromServer:data ];
                    
                    break;
                case 11:
                    deviceCategoryId = 3;
                    deviceName = @"窗户";
                    deviceStateCmd = [transCodingMethods  transCodingFromServer:data ];
                    break;
                case 51:
                    deviceCategoryId = 2;
                    deviceName = @"空气净化器";
                    deviceStateCmd = [transCodingMethods  transCodingFromServer:data ];
                    
                    break;
                case 104:
                    
                    deviceCategoryId = 2;
                    deviceName = @"温湿度";
                    temp = [NSString stringWithFormat:@"%lu",strtoul([[data substringWithRange:NSMakeRange(2, 2)] UTF8String], 0, 16)];
                    humi = [NSString  stringWithFormat:@"%lu",strtoul([[data substringWithRange:NSMakeRange(6, 2)] UTF8String], 0, 16)];
                    deviceStateStr = [temp  stringByAppendingString:@"p" ];
                    deviceStateCmd = [deviceStateStr  stringByAppendingString:humi];
                    
                    break;
                case 105:
                    deviceName = @"红外转发器";
                    deviceStateCmd = data;
                    break;
                case 109:
                    deviceCategoryId = 2;
                    deviceName = @"PM2.5";
                    PM2_5H = strtoul([[data substringWithRange:NSMakeRange(0, 2)] UTF8String], 0, 16);
                    PM2_5L = strtoul([[data substringWithRange:NSMakeRange(2, 2)] UTF8String], 0, 16);
                    PM2_5 = PM2_5H *10 + PM2_5L/10;
                    deviceStateCmd  = [NSString  stringWithFormat:@"%ld",(long)PM2_5];
                    
                    break;
                case 110:
                    deviceCategoryId = 2;
                    deviceName = @"门磁";
                    deviceStateCmd = [transCodingMethods  transThemeCodingFromServer:data ];
                    
                    break;
                case 113:
                    deviceCategoryId = 2;
                    deviceName = @"红外感应";
                    deviceStateCmd = [transCodingMethods  transThemeCodingFromServer:data ];
                    
                    
                    break;
                case 115:
                    deviceCategoryId = 2;
                    deviceName = @"燃气";
                    deviceStateCmd = [transCodingMethods  transThemeCodingFromServer:data ];
                    
                    break;
                    
                case 118:
                    deviceCategoryId = 2;
                    deviceName = @"烟感";
                    deviceStateCmd = [transCodingMethods  transThemeCodingFromServer:data ];
                    
                    break;
                case 201:
                    deviceCategoryId = 6;
                    deviceName = @"双控";
                    deviceStateCmd = [transCodingMethods  transThemeCodingFromServer:data ];
                    break;
                case 202:
                    deviceCategoryId = 4;
                    deviceName = @"情景开关";
                    deviceStateCmd = [transCodingMethods  transThemeCodingFromServer:data];
                    break;
            }
            
            
            _devcieMessage.DEVICE_GATEGORY_ID = deviceCategoryId;
            //devcieMessage.DEVICE_GATEGORY_NAME = @"";
            _devcieMessage.DEVICE_NAME = deviceName;
            _devcieMessage.DEVICE_NO = deviceNo;
            _devcieMessage.DEVICE_STATE = deviceStateCmd;
            _devcieMessage.DEVICE_TYPE_ID = deviceTypeId ;
            //devcieMessage.DEVICE_TYPE_NAME = @"";
            _devcieMessage.GATEWAY_NO = gatewayNo;
            _devcieMessage.PHONE_NUM = phoneNum;
            _devcieMessage.SPACE_NO = spaceNo;
            _devcieMessage.SPACE_TYPE_ID = [spaceTypeId integerValue] ;
            
             //NSLog(@"=======devcieMessage.DEVICE_GATEGORY_ID=%ld  devcieMessage.DEVICE_GATEGORY_NAME=%@  devcieMessage.DEVICE_NAME= %@    devcieMessage.DEVICE_NO=%@   devcieMessage.DEVICE_TYPE_ID=%ld   devcieMessage.DEVICE_TYPE_NAME=%@   devcieMessage.GATEWAY_NO=%@   devcieMessage.PHONE_NUM=%@   devcieMessage.SPACE_NO=%@   devcieMessage.SPACE_TYPE_ID=%ld",(long)devcieMessage.DEVICE_GATEGORY_ID,devcieMessage.DEVICE_GATEGORY_NAME,devcieMessage.DEVICE_NAME, devcieMessage.DEVICE_NO,(long)devcieMessage.DEVICE_TYPE_ID,devcieMessage.DEVICE_TYPE_NAME,devcieMessage.GATEWAY_NO,devcieMessage.PHONE_NUM,devcieMessage.SPACE_NO,(long)devcieMessage.SPACE_TYPE_ID);
            
            [deviceMessageTool  updateDeviceMessageOnlyLocal:_devcieMessage];
            
        }

    }
    
    deviceMessage *device = [[deviceMessage alloc]init];
    device.GATEWAY_NO = _dataCenter.gatewayNo;
    
    _devices=[deviceMessageTool queryWithDevices:device];
    
    [_collectionView  reloadData];
    
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
            
            //删除设备
            [self deleteDeviceToServer];
           
            
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
 *  获取当前网关下的所有设备
 */
-(void)getAllDevices{

   
    if ([_dataCenter.gatewayNo isEqualToString:@"0"] | !_dataCenter.gatewayNo ) {
        
        [MBProgressHUD  showError:@"请先添加主机"];
        
    }else{
        
        [self  performSelectorInBackground:@selector(getAllDeviceFromServer) withObject:nil];
        
    }
    [MBProgressHUD  hideHUD];

}

/**
 *  测试获取对应用户所有设备
 */
-(void)getAllDeviceFromServer{
   
    //创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager  manager];
    
    mgr.responseSerializer = [AFJSONResponseSerializers  serializer];
    
    //配置请求超时时间
    mgr.requestSerializer.timeoutInterval = 60;
  
    //设置请求参数
    NSMutableDictionary  *params = [NSMutableDictionary  dictionary];
    params[@"phonenum"] = _dataCenter.userPhoneNum;
    params[@"gatewayNo"] = _dataCenter.gatewayNo;
    NSString  *urlStr =[NSString  stringWithFormat:@"%@/appGetDeviceInfo" ,HomecooServiceURL];
    NSString *url = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
    
    [mgr  POST:url parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        //打印日志
        NSLog(@"请求成功--%@",responseObject);
        
        NSString  *result = [responseObject[@"result"]description];

        //服务器返回的设备表信息
        NSArray *devicesMessages = responseObject[@"deviceDtoAppList" ];
        
        //NSLog(@"服务器返回的设备信息 = %@",responseObject[@"deviceDtoAppList" ]);
        
        self.devicesMessages = devicesMessages;
       
        //服务器返回的用户空间配置表
        NSArray *userDeviceSpaceList = responseObject[@"userDeviceSpaceList" ];
        
        self.userDeviceSpaceList = userDeviceSpaceList;
        
        if ([result  isEqual:@"success"]) {
            //先删除设备表 设备信息表
            [deviceMessageTool  deleteDeviceTable];
            
            [deviceSpaceMessageTool  deleteDeviceMessageTable];
            
            [self  updateDeviceTable];
            
            [self updateDeviceSpaceList];
                            
        
        } if ([result  isEqual:@"failed"]) {
            
            [MBProgressHUD  showError:@"请求失败!"];
            
        }
        
        [MBProgressHUD  hideHUD];

    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        [MBProgressHUD  showError:@"网络繁忙，请稍后再试"];
    }];
    

}

/**
 *  更新设备表
 */
-(void)updateDeviceTable{

    deviceMessage * devcieMessage = [[deviceMessage alloc]init];
    
    NSInteger  count;
    NSString * deviceStateStr;
    NSString * temp;
    NSString * humi;
    NSInteger PM2_5H;
    NSInteger PM2_5L;
    NSInteger PM2_5;
    NSDictionary *deviceDit;
    NSString *deviceCategoryId;
    NSString *spaceTypeId;
    NSString *spaceNo;
    NSString *deviceTypeId;
    NSString *phoneNum;
    NSString *deviceName;
    NSString *deviceStateCmd;
    NSString *deviceNo;
    NSString *deviceId;
    NSString *gatewayNo;
    NSArray  * deviceArray;
    if (_device==nil) {
        _device = [[deviceMessage  alloc]init];
    }
    if (self.devicesMessages.count ==0) {
        
        count = 0;
        
    }else{
        
        count = self.devicesMessages.count;
    }

    NSLog(@"******外网设备个数 = %ld******",(long)count);
    
    for (int i = 0; i<count; i++) {//self.devicesMessages.count
        
       
        deviceDit = self.devicesMessages[i];

        deviceCategoryId = [deviceDit objectForKey:@"deviceCategoryId"];
        spaceTypeId = [deviceDit objectForKey:@"spaceTypeId"];
        spaceNo = [deviceDit objectForKey:@"spaceNo"];
        deviceTypeId = [deviceDit objectForKey:@"deviceTypeId"];
        phoneNum = [deviceDit objectForKey:@"phoneNum"];
        deviceName = [deviceDit objectForKey:@"deviceName"];
        deviceStateCmd = [deviceDit objectForKey:@"deviceStateCmd"];
        deviceNo = [deviceDit objectForKey:@"deviceNo"];
        deviceId = [deviceDit objectForKey:@"deviceId"];
        gatewayNo = [deviceDit objectForKey:@"gatewayNo"];
        
//      NSLog(@"========%@==%@==%@==%@==%@==%@==%@==%@==%@==%@==",deviceCategoryId,spaceTypeId,spaceNo,deviceTypeId,phoneNum,deviceName,deviceStateCmd,deviceNo,deviceId,gatewayNo);
        //在device表中查找是否有该设备
       
        _device.DEVICE_NO =deviceNo;
        _device.GATEWAY_NO = gatewayNo;
        
        deviceArray= [deviceMessageTool  queryWithDeviceNumDevices:_device];
        
        if (deviceArray.count == 0) {//没有此设备 则向设备表中查入该条设备
            
            switch ([deviceTypeId intValue]) {
                case 5://将16进制转换为10进制
                    devcieMessage.DEVICE_STATE = [NSString  stringWithFormat:@"%lu",strtoul([[deviceStateCmd  substringWithRange:NSMakeRange(0, 2)]UTF8String], 0, 16)];
  
                    break;
                case 104:
                   
                    temp = [NSString stringWithFormat:@"%lu",strtoul([[deviceStateCmd substringWithRange:NSMakeRange(2, 2)] UTF8String], 0, 16)];
                    
                    humi = [NSString  stringWithFormat:@"%lu",strtoul([[deviceStateCmd substringWithRange:NSMakeRange(6, 2)] UTF8String], 0, 16)];
                    deviceStateStr = [temp  stringByAppendingString:@"p" ];
                    devcieMessage.DEVICE_STATE = [deviceStateStr  stringByAppendingString:humi];
                
                    break;
                case 105:
                    devcieMessage.DEVICE_STATE =deviceStateCmd;
                   
                    break;
                case 109:
                    if ([deviceStateCmd isEqualToString:@""]) {
                        
                        devcieMessage.DEVICE_STATE =@"";
                        
                        
                    }else{
                        PM2_5H = strtoul([[deviceStateCmd substringWithRange:NSMakeRange(0, 2)] UTF8String], 0, 16);
                        PM2_5L = strtoul([[deviceStateCmd substringWithRange:NSMakeRange(2, 2)] UTF8String], 0, 16);
                        PM2_5 = PM2_5H *10 + PM2_5L/10;
                        
                        devcieMessage.DEVICE_STATE =[NSString  stringWithFormat:@"%ld",(long)PM2_5];
                        
                    }                    break;
                case 110:
                    devcieMessage.DEVICE_STATE =[transCodingMethods  transThemeCodingFromServer:deviceStateCmd];
                    break;
                case 113:
                    devcieMessage.DEVICE_STATE =[transCodingMethods  transThemeCodingFromServer:deviceStateCmd];
                    break;
                case 115:
                    devcieMessage.DEVICE_STATE =[transCodingMethods  transThemeCodingFromServer:deviceStateCmd];
                    break;
                case 118:
                    
                    devcieMessage.DEVICE_STATE =[transCodingMethods  transThemeCodingFromServer:deviceStateCmd];
                    
                    break;
                case 202:
                    
                    devcieMessage.DEVICE_STATE =[transCodingMethods  transThemeCodingFromServer:deviceStateCmd];
                    
                    break;
                default:
                    //普通设备的转码
                   
                     devcieMessage.DEVICE_STATE = [transCodingMethods  transCodingFromServer:deviceStateCmd];
                    
                    break;
                
            }
            
            devcieMessage.DEVICE_ID  = [deviceId integerValue];
            devcieMessage.DEVICE_GATEGORY_ID = [deviceCategoryId intValue];
            devcieMessage.DEVICE_GATEGORY_NAME = @"";
            devcieMessage.DEVICE_NAME = deviceName;
            devcieMessage.DEVICE_NO = deviceNo;
           
            devcieMessage.DEVICE_TYPE_ID = [deviceTypeId intValue];
            devcieMessage.DEVICE_TYPE_NAME = @"";
            devcieMessage.GATEWAY_NO = gatewayNo;
            devcieMessage.PHONE_NUM = phoneNum;
            devcieMessage.SPACE_NO = spaceNo;
            devcieMessage.SPACE_TYPE_ID = [spaceTypeId intValue];
            
//  NSLog(@"========%ld==%@==%@==%@==%@==%ld==%@==%@==%@==%ld==",(long)devcieMessage.DEVICE_ID,devcieMessage.DEVICE_NAME,devcieMessage.DEVICE_NAME,devcieMessage.DEVICE_NO,devcieMessage.DEVICE_STATE,(long)devcieMessage.DEVICE_TYPE_ID,devcieMessage.GATEWAY_NO,devcieMessage.PHONE_NUM ,devcieMessage.SPACE_NO,(long)devcieMessage.SPACE_TYPE_ID);
           
            [deviceMessageTool  addDevice:devcieMessage];
            
           // NSLog(@"====没有此设备=====");
            
        }else{//有次设备则更新设备信息
            //devcieMessage.DEVICE_ID = [deviceId intValue];
            switch ([deviceTypeId intValue]) {
                case 5:
                     devcieMessage.DEVICE_STATE = [NSString  stringWithFormat:@"%lu",strtoul([[deviceStateCmd  substringWithRange:NSMakeRange(0, 2)]UTF8String], 0, 16)];
                    
                    break;
                case 104:
                    temp = [NSString stringWithFormat:@"%lu",strtoul([[deviceStateCmd substringWithRange:NSMakeRange(2, 2)] UTF8String], 0, 16)];
                    
                    humi = [NSString  stringWithFormat:@"%lu",strtoul([[deviceStateCmd substringWithRange:NSMakeRange(6, 2)] UTF8String], 0, 16)];
                    deviceStateStr = [temp  stringByAppendingString:@"p" ];
                    devcieMessage.DEVICE_STATE = [deviceStateStr  stringByAppendingString:humi];
                    
                    break;
                case 105:
                    devcieMessage.DEVICE_STATE =deviceStateCmd;
                    break;
                case 109:
                    PM2_5H = strtoul([[deviceStateCmd substringWithRange:NSMakeRange(0, 2)] UTF8String], 0, 16);
                    PM2_5L = strtoul([[deviceStateCmd substringWithRange:NSMakeRange(2, 2)] UTF8String], 0, 16);
                    PM2_5 = PM2_5H *10 + PM2_5L/10;
                    
                    devcieMessage.DEVICE_STATE =[NSString  stringWithFormat:@"%ld",(long)PM2_5];
                    break;
                case 110:
                    devcieMessage.DEVICE_STATE =[transCodingMethods  transThemeCodingFromServer:deviceStateCmd];
                    break;
                case 113:
                    devcieMessage.DEVICE_STATE =[transCodingMethods  transThemeCodingFromServer:deviceStateCmd];
                    break;
                case 115:
                    devcieMessage.DEVICE_STATE =[transCodingMethods  transThemeCodingFromServer:deviceStateCmd];
                    break;
                case 118:
                    devcieMessage.DEVICE_STATE =[transCodingMethods  transThemeCodingFromServer:deviceStateCmd];
                    break;
                case 202:
                    devcieMessage.DEVICE_STATE =[transCodingMethods  transThemeCodingFromServer:deviceStateCmd];
                    break;
                default:
                    //普通设备的转码
                    devcieMessage.DEVICE_STATE = [transCodingMethods  transCodingFromServer:deviceStateCmd];
                    break;
            }
            
            devcieMessage.DEVICE_ID  = [deviceId integerValue];
            devcieMessage.DEVICE_GATEGORY_ID = [deviceCategoryId intValue];
            devcieMessage.DEVICE_GATEGORY_NAME = @"";
            devcieMessage.DEVICE_NAME = deviceName;
            devcieMessage.DEVICE_NO = deviceNo;
            devcieMessage.DEVICE_TYPE_ID = [deviceTypeId intValue];
            devcieMessage.DEVICE_TYPE_NAME = @"";
            devcieMessage.GATEWAY_NO = gatewayNo;
            devcieMessage.PHONE_NUM = phoneNum;
            devcieMessage.SPACE_NO = spaceNo;
            
            devcieMessage.SPACE_TYPE_ID = [spaceTypeId intValue];
        
            [deviceMessageTool  updateDeviceMessage:devcieMessage];
           
        }
        
    }
    
    deviceMessage *devicesss = [[deviceMessage alloc]init];
    devicesss.GATEWAY_NO = _dataCenter.gatewayNo;
    
    _devices=[deviceMessageTool queryWithDevices:devicesss];
    
    [_collectionView  reloadData];
        
    
}
/**
 *  刷新界面
 */
-(void)downloadFinshed{
    
    [_collectionView  reloadData];
  
}


/**
 *  更新用户设备空间信息
 */
-(void)updateDeviceSpaceList{
    NSDictionary *spaceDit;
    NSString *deviceName;
    NSString *deviceNo;
    NSString *spaceNo;
    NSString *phoneNum;
    NSArray  *spaces;
    
    if (_userDeviceSpace==nil) {
        _userDeviceSpace = [[deviceSpaceMessageModel alloc]init];
    }
    if (_space==nil) {
        _space = [[deviceSpaceMessageModel  alloc]init];

    }
   
    NSInteger  count;
    
    if (self.userDeviceSpaceList.count ==0) {
        count = 0;
    }else{
        
        count = self.userDeviceSpaceList.count;
    }

    for (int i = 0; i<count; i++) {
        
        spaceDit = self.userDeviceSpaceList[i];
        
        deviceName = [spaceDit objectForKey:@"deviceName"];
        deviceNo = [spaceDit objectForKey:@"deviceNo"];
        spaceNo = [spaceDit objectForKey:@"spaceNo"];
        phoneNum = [spaceDit objectForKey:@"phoneNum"];
        //NSString *spaceType_Id = [spaceDit  objectForKey:@"spaceType"];
       
        _space.device_no =deviceNo;
        _space.phone_num = _dataCenter.userPhoneNum;
        
        spaces = [deviceSpaceMessageTool queryWithspacesDeviceNoAndPhonenum:_space];
        
        if (spaces.count == 0) {//用户设备空间表中没有次设备的空间信息 ，则插入该条设备空间信息
       
            _userDeviceSpace.device_name =  deviceName;
            _userDeviceSpace.device_no = deviceNo;
            _userDeviceSpace.phone_num = phoneNum;
            _userDeviceSpace.space_no = spaceNo;
            //_userDeviceSpace.spaceType_Id = spaceType_Id;
            [deviceSpaceMessageTool addDeviceSpace:_userDeviceSpace];
        }else{
            _userDeviceSpace.device_name =  deviceName;
            _userDeviceSpace.device_no = deviceNo;
            _userDeviceSpace.phone_num = phoneNum;
            _userDeviceSpace.space_no = spaceNo;
           // _userDeviceSpace.spaceType_Id = spaceType_Id;
            [deviceSpaceMessageTool  updateDeviceSpaceMessage:_userDeviceSpace];
        }
    }
}

/**
 *  添加UICollectionView 空间
 */
-(void)addUICollectionView{
    
    CGFloat  collectionViewX = 20 ;
    CGFloat  collectionViewY = 60 ;
    CGFloat  collectionViewW = [UIScreen mainScreen].bounds.size.width - 40;
    CGFloat  collectionViewH = [UIScreen  mainScreen].bounds.size.height -95;
    //确定是水平滚动，还是垂直滚动
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    UICollectionView  *collectionView = [[UICollectionView  alloc]initWithFrame:CGRectMake(collectionViewX, collectionViewY, collectionViewW, collectionViewH) collectionViewLayout:flowLayout];
    
    collectionView.dataSource=self;
    collectionView.delegate=self;
    collectionView.backgroundColor = [UIColor  whiteColor];
    [collectionView registerClass:[productCollectionViewCell class] forCellWithReuseIdentifier:string];
    
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
    
    deviceMessage *device = [[deviceMessage alloc]init];
    device.GATEWAY_NO = _dataCenter.gatewayNo;
    NSInteger  count = [deviceMessageTool queryWithDevices:device].count;
    return  count;
    
}


//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    _cell = [collectionView dequeueReusableCellWithReuseIdentifier:string forIndexPath:indexPath];
    
    if (!_devicess) {
        _devicess = [[deviceMessage alloc]init];
    }
    _devicess.GATEWAY_NO = _dataCenter.gatewayNo;
    
    deviceMessage  *device = [deviceMessageTool queryWithDevices:_devicess][indexPath.row];
    
    if(!_deviceSpace){
        _deviceSpace = [[deviceSpaceMessageModel alloc]init];

    }
    _deviceSpace.device_no = device.DEVICE_NO;
    _deviceSpace.phone_num = _dataCenter.userPhoneNum;
    
    NSArray *deviceSpaceArry = [deviceSpaceMessageTool queryWithspacesDeviceNoAndPhonenum:_deviceSpace];
    
    if (deviceSpaceArry.count ==0) {
        
        _cell.deviceMessageLable.text =[NSString  stringWithFormat:@"  位置待定/%@",device.DEVICE_NAME];
    }else{
        
        deviceSpaceMessageModel *device_Name = deviceSpaceArry[0];
        
        spaceMessageModel *deviceNameModel = [[spaceMessageModel  alloc]init];
        
        deviceNameModel.space_Num = device_Name.space_no;
        
        NSArray *devicePostion = [spaceMessageTool queryWithspacesDevicePostion:deviceNameModel];
        
        spaceMessageModel *deviceName;
        
        if (devicePostion.count ==0) {
            
            _cell.deviceMessageLable.text =[NSString  stringWithFormat:@"  %@/%@",@"位置待定",device.DEVICE_NAME];
            
        }else{
         
            deviceName = devicePostion[0];
            //显示设备位置和设备名称
            _cell.deviceMessageLable.text =[NSString  stringWithFormat:@"  %@/%@",deviceName.space_Name,device_Name.device_name];
            
        }
        
    }
    
    [_cell.button  addTarget:self action:@selector(ClickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return _cell;
    
}
/**
 *  按钮监听事件
 *
 *  @param btn 点击的是哪个
 */
- (void)ClickButton:(UIButton *)btn{
    
    productCollectionViewCell *cell = (productCollectionViewCell *)[[[btn superview]superview]superview];//获取cell
    
    NSIndexPath *indexPathAll = [self.collectionView indexPathForCell:cell];//获取cell对应的section
    
    indexNum =indexPathAll.row;
    
    deviceMessage *devicess = [[deviceMessage alloc]init];
    devicess.GATEWAY_NO = _dataCenter.gatewayNo;
    
    deviceMessage *device = [deviceMessageTool queryWithDevices:devicess][indexNum];
   
    
    if (device.DEVICE_TYPE_ID == 202) {
        
        //显示情景设备的对话框
        NSArray *tempArray = @[@"更改",@"删除",@"设置情景名称"];
        
        self.themeSwitchView.titleArray = tempArray;
        
        self.themeSwitchView.title = @"产品设置";
        
        [self.themeSwitchView showInView:self.view animated:YES];
        
   
    }else{
    
        //显示普通设备的对话框
        NSArray *tempArray = @[@"更改",@"删除",];
        
        self.switchView.titleArray = tempArray;
        
        self.switchView.title = @"产品设置";
        
        [self.switchView showInView:self.view animated:YES];
       
    }
    
    
}

-(void)theme_no:(NSString *)theme_no theme_name_gateway_state_deviceNO:(NSString *)theme_name_gateway_state_deviceNO themeState:(NSString *)themeState themeTag:(NSString *)theme_no_tag mds:(NSString*)theme_no_md5 themeModel:(themMessageModel *)theme themeModel1:(themMessageModel *)theme1 themeModel2:(themMessageModel *)theme11 textField:(UITextField *)textField{
    
    deviceMessage *devicess = [[deviceMessage alloc]init];
    devicess.GATEWAY_NO = _dataCenter.gatewayNo;
    
    
    NSArray *gateway_No_Arry = [gatewayMessageTool queryWithgateways];
    
    if (gateway_No_Arry.count ==0) {
        
        [MBProgressHUD  showMessage:@"请先添加主机"];
        
    }else{
        
        gatewayMessageModel  *gateway_No = gateway_No_Arry[0];
        
        deviceMessage  *device =  [deviceMessageTool queryWithDevices:devicess][indexNum];
        
        themMessageModel *test_1 = [[themMessageModel alloc]init];
        
        test_1.device_No = device.DEVICE_NO;
        
        NSArray *test = [themeMessageTool  queryWiththeme:test_1];
  
        theme_no = [gateway_No.gatewayID  stringByAppendingString:device.DEVICE_NO];
    
        theme_name_gateway_state_deviceNO = [theme_no stringByAppendingString:themeState];
    
    
        theme_no_tag = [theme_name_gateway_state_deviceNO stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
    
   
        theme_no_md5 = [theme_no_tag md5String];
    
   
        //建立模型
        theme = [[themMessageModel  alloc]init];
    
    
        theme.theme_Name = textField.text;//self.themeNameField_3.text;
   
        theme.gateway_No = gateway_No.gatewayID;
   
        theme.device_No = device.DEVICE_NO;
 
        theme.theme_No = theme_no_md5;
   
        theme.theme_State = device.DEVICE_STATE;
  
        theme.theme_Type = 3;//表示是硬件情景
       
        if (test.count ==0) {//情景名称不存在
            
            if (![theme.theme_Name isEqualToString:@""]) {//空间信息不为空
                
                //向数据库中添加新增加的空间
                [themeMessageTool  addTheme:theme];
                //重新查询数据库中 共有多少个空间
                
            }
            
            
        }else if(test.count !=0){//已经存在
            if (![theme.theme_Name isEqualToString:@""]){
                
                theme1 = test[0];
                theme11 = [[themMessageModel  alloc]init];
                
                theme11.theme_Name = textField.text;
                
                theme11.theme_No = theme1.theme_No;
                
                //更新情景名称
                [themeMessageTool  updateThemeName:theme11];
                
            }
        
          }
       
        }
    
    //隐藏蒙版
    [MBProgressHUD hideHUD];

}

/**
 *  确定修改情景名称 添加对应的硬件情景到theme表中
 */
-(void)confirmSettingAction{
    
  
    deviceMessage *devicess = [[deviceMessage alloc]init];
    
    devicess.GATEWAY_NO = _dataCenter.gatewayNo;
    
    deviceMessage  *device =[deviceMessageTool queryWithDevices:devicess][indexNum];
    
    themMessageModel *test_1 = [[themMessageModel alloc]init];
    
    test_1.device_No = device.DEVICE_NO;
  
    NSArray *test = [themeMessageTool  queryWiththeme:test_1];
    
    //硬件情景theme_no = 网关id + 硬件情景号（DEVICE_NO）
    
    NSString  *theme_no = [_dataCenter.gatewayNo  stringByAppendingString:device.DEVICE_NO ];
    
    NSString *theme_gateway_state_deviceNO = [theme_no stringByAppendingString:@"10000000"];
    
    NSString *theme_no_tag = [theme_gateway_state_deviceNO stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
    
    NSString *theme_no_md5 = [theme_no_tag md5String];
    
    //建立模型
    themMessageModel *theme = [[themMessageModel  alloc]init];
    
    
    theme.theme_Name = _themeNameView.firstField.text;
    theme.gateway_No = _dataCenter.gatewayNo;
    theme.device_No = device.DEVICE_NO;
    theme.theme_No = theme_no_md5;
    theme.theme_State = @"10000000";
    theme.theme_Type = 1;
    
    NSLog(@"%@ %@",theme.device_No,theme.theme_Name);
    
    if (test.count ==0) {//情景名称不存在
        
        if (![theme.theme_Name isEqualToString:@""]) {//空间信息不为空
            
            //向数据库中添加新增加的空间
            [themeMessageTool  addTheme:theme];
            
        }
        
    }else if(test.count !=0){//已经存在
       
        if (![theme.theme_Name isEqualToString:@""]){
            
           
            themMessageModel *theme1 = test[0];
            themMessageModel *theme11 = [[themMessageModel  alloc]init];

            theme11.theme_Name = _themeNameView.firstField.text;
            
            theme11.theme_No = theme1.theme_No;
            
            NSLog(@"%@ %@",theme11.theme_Name,theme11.theme_No);
            
            [themeMessageTool  updateThemeName:theme11];
        
        }
    }

    NSString  *theme_no_1 = [_dataCenter.gatewayNo  stringByAppendingString:device.DEVICE_NO];
        
    NSString *theme_name_gateway_state_deviceNO_1 = [theme_no_1 stringByAppendingString:@"01000000"];
    
    NSString *theme_no_tag_1 = [theme_name_gateway_state_deviceNO_1 stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
    
    NSString *theme_no_md5_1 = [theme_no_tag_1 md5String];
    
    //建立模型
    themMessageModel *theme_1 = [[themMessageModel  alloc]init];
    
    
    theme_1.theme_Name = _themeNameView.secondaryField.text;
    theme_1.gateway_No = _dataCenter.gatewayNo;
    theme_1.device_No = device.DEVICE_NO;
    theme_1.theme_No = theme_no_md5_1;
    theme_1.theme_State = @"01000000";
    theme_1.theme_Type = 1;
    NSLog(@"%@ %@",theme_1.device_No,theme_1.theme_Name);
    
    if (test.count ==0) {//情景名称不存在
        
        if (![theme_1.theme_Name isEqualToString:@""]) {//空间信息不为空
            
            //向数据库中添加新增加的空间
            [themeMessageTool  addTheme:theme_1];
            
        }
        
    }else if(test.count !=0){//已经存在
        
        if (![theme_1.theme_Name isEqualToString:@""]){
            
            themMessageModel *theme2 = test[1];
            themMessageModel *theme22 = [[themMessageModel  alloc]init];
            
            theme22.theme_Name = _themeNameView.secondaryField.text;
            
            theme22.theme_No = theme2.theme_No;
            
            NSLog(@"%@ %@",theme22.theme_Name,theme22.theme_No);
            
            [themeMessageTool  updateThemeName:theme22];
        }
        
    }

    
  //生成情景NO
    NSString  *theme_no_2 = [_dataCenter.gatewayNo  stringByAppendingString:device.DEVICE_NO];

    NSString *theme_name_gateway_state_deviceNO_2 = [theme_no_2 stringByAppendingString:@"00100000"];
    
    NSString *theme_no_tag_2 = [theme_name_gateway_state_deviceNO_2 stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
    
    NSString *theme_no_md5_2 = [theme_no_tag_2 md5String];
    
    //建立模型
    themMessageModel *theme_2 = [[themMessageModel  alloc]init];
    
    
    theme_2.theme_Name = _themeNameView.thirdField.text;
    theme_2.gateway_No = _dataCenter.gatewayNo;
    theme_2.device_No = device.DEVICE_NO;
    theme_2.theme_No = theme_no_md5_2;
    theme_2.theme_State = @"00100000";
    theme_2.theme_Type = 1;
    NSLog(@"%@ %@",theme_2.device_No,theme_2.theme_Name);
    
    if (test.count ==0) {//情景名称不存在
        
        if (![theme_2.theme_Name isEqualToString:@""]) {//空间信息不为空
            
            //向数据库中添加新增加的空间
            [themeMessageTool  addTheme:theme_2];
            
            
        }

    }else if(test.count !=0){//已经存在
        if (![theme_2.theme_Name isEqualToString:@""]){
        
            themMessageModel *theme3 = test[2];
            themMessageModel *theme33 = [[themMessageModel  alloc]init];
            
            theme33.theme_Name = _themeNameView.thirdField.text;
            
            theme33.theme_No = theme3.theme_No;
            
            NSLog(@"%@ %@",theme33.theme_Name,theme33.theme_No);
            
            [themeMessageTool  updateThemeName:theme33];
       
        }
        
    }

  
   
    NSString  *theme_no_3 = [_dataCenter.gatewayNo  stringByAppendingString:device.DEVICE_NO];
    
    NSString *theme_name_gateway_state_deviceNO_3 = [theme_no_3 stringByAppendingString:@"00010000"];
    
    NSString *theme_no_tag_3 = [theme_name_gateway_state_deviceNO_3 stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
    
    NSString *theme_no_md5_3 = [theme_no_tag_3 md5String];
    
    //建立模型
    themMessageModel *theme_3 = [[themMessageModel  alloc]init];
    
    
    theme_3.theme_Name = _themeNameView.fourthField.text;
    theme_3.gateway_No = _dataCenter.gatewayNo;
    theme_3.device_No = device.DEVICE_NO;
    theme_3.theme_No = theme_no_md5_3;
    theme_3.theme_State = @"00010000";
    theme_3.theme_Type = 1;
    NSLog(@"%@ %@",theme_3.device_No,theme_3.theme_Name);
    
    if (test.count ==0) {//情景名称不存在
        
        if (![theme_3.theme_Name isEqualToString:@""]) {//空间信息不为空
            
            //向数据库中添加新增加的空间
            [themeMessageTool  addTheme:theme_3];
           

        }
        
    }else if(test.count !=0){//已经存在
        
        if (![theme_3.theme_Name isEqualToString:@""]){
            
       
            themMessageModel *theme4 = test[3];
            themMessageModel *theme44 = [[themMessageModel  alloc]init];
            
            theme44.theme_Name = _themeNameView.fourthField.text;
            
            theme44.theme_No = theme4.theme_No;
            
            NSLog(@"%@ %@",theme44.theme_Name,theme44.theme_No);
            
            [themeMessageTool  updateThemeName:theme44];
       
        }
        
  
    }

    [MBProgressHUD  hideHUD];
    
    //更新设备版本信息
    [self  updateDeviceVersionMessage];
    
   
}


/**
 *  更改产品设置信息
 */
-(void)changeProductSetting{

    deviceMessage *devicess = [[deviceMessage alloc]init];
    devicess.GATEWAY_NO = _dataCenter.gatewayNo;
    
    deviceMessage *devices = [deviceMessageTool queryWithDevices:devicess][indexNum];
   
    spaceMessageModel *space = [[spaceMessageModel  alloc]init];
    
    space.space_Name = _proMsgView.thirdButton.titleLabel.text;//self.positionBtn.titleLabel.text;
    space.phone_Num = _dataCenter.userPhoneNum;
   
    NSArray *spaceMessage = [spaceMessageTool  queryWithspacesNo:space];
    
    spaceMessageModel *spaceNo;
    
    if (spaceMessage.count == 0) {
        
        [MBProgressHUD  showError:@"请先添加空间"];
        
    }else{
    
       spaceNo = spaceMessage[0];
    
    }
    
    [MBProgressHUD  hideHUD];
    
    deviceSpaceMessageModel  *deviceSpace = [[deviceSpaceMessageModel  alloc]init];
    
    deviceSpace.device_name = _proMsgView.secondaryField.text;
    deviceSpace.phone_num = _dataCenter.userPhoneNum;
    deviceSpace.device_no = devices.DEVICE_NO;
    deviceSpace.space_no = spaceNo.space_Num;
    
    NSLog(@"%@ %@ %@ %@ %@",deviceSpace.device_name,deviceSpace.phone_num, deviceSpace.device_no,deviceSpace.space_no,space.space_Name);
    
    deviceSpaceMessageModel *deviceSpaceNo = [[deviceSpaceMessageModel alloc]init];
    
    deviceSpaceNo.device_no = devices.DEVICE_NO;
    deviceSpaceNo.phone_num = _dataCenter.userPhoneNum;
   
    NSArray *deviceSpaceArry = [deviceSpaceMessageTool queryWithspacesDeviceNoAndPhonenum:deviceSpaceNo];
    
    if (deviceSpaceArry.count ==0) {
        
        [deviceSpaceMessageTool  addDeviceSpace:deviceSpace];

    }else{
    
        [deviceSpaceMessageTool  updateDeviceSpaceMessage:deviceSpace];
        
    
    }
 
    
    if (devices.DEVICE_TYPE_ID == 110 | devices.DEVICE_TYPE_ID == 113 |devices.DEVICE_TYPE_ID == 115 | devices.DEVICE_TYPE_ID == 118 ) {
        deviceMessage *deviceUpdateSpaceTypeID = [[deviceMessage  alloc]init];
        
        deviceUpdateSpaceTypeID.DEVICE_NO = devices.DEVICE_NO;
        deviceUpdateSpaceTypeID.GATEWAY_NO = devices.GATEWAY_NO ;
        deviceUpdateSpaceTypeID.SPACE_TYPE_ID = _dataCenter.devcieSpaceTypeID;
        
        [deviceMessageTool  updateDeviceSPACE_TYPE_ID:deviceUpdateSpaceTypeID];
        
      //  NSLog(@"======%ld=====",(long)deviceUpdateSpaceTypeID.SPACE_TYPE_ID);
        

    }
    
    [_collectionView  reloadData];
    
    //同步设备版本信息
    [self updateDeviceVersionMessage];
    
   
}

/**
 *  同步设备版本信息
 */
-(void)updateDeviceVersionMessage{

    versionMessageModel *deviceVersion = [[versionMessageModel  alloc]init];
    
    deviceVersion.phoneNum = _dataCenter.userPhoneNum;
    deviceVersion.gatewayNum = _dataCenter.gatewayNo;
    deviceVersion.versionType = @"2";
    
    NSArray *deviceVersionArray =  [versionMessageTool  queryWithVersionType:deviceVersion];
    
    if (deviceVersionArray.count == 0) {//没有此网关的版本信息
        
        deviceVersion.updateTime = [ControlMethods getCurrentTime];
        
        [versionMessageTool  addVersionMessage:deviceVersion];
        
    }else{//有此网关的信息 则更新updatetime
        
        deviceVersion.updateTime = [ControlMethods  getCurrentTime];
        
        [versionMessageTool  updateVersionMessage:deviceVersion];
        
    }
    
}




- (HCDaterView *)switchView{
    
    if(_switchView == nil){
        
        _switchView = [[HCDaterView alloc]initWithFrame:CGRectZero];
        
        _switchView.sureBtn.hidden = YES;
        
        _switchView.cancleBtn.hidden = YES;
        
        _switchView.delegate = self;
    }
    
    return _switchView;
}

- (HCDaterView *)themeSwitchView{
    
    if(_themeSwitchView == nil){
        
        _themeSwitchView = [[HCDaterView alloc]initWithFrame:CGRectZero];
        
        _themeSwitchView.sureBtn.hidden = YES;
        
        _themeSwitchView.cancleBtn.hidden = YES;
        
        _themeSwitchView.delegate = self;
    }
    
    return _themeSwitchView;
}


- (void)daterViewClicked:(HCDaterView *)daterView{

    switch (daterView.currentIndexPath.row) {
            
        case 0:
            //点击 更改
            [_switchView  hiddenInView:self.view animated:YES];
            [_themeSwitchView hiddenInView:self.view animated:YES];
            [self.proMsgView showView:self.view animated:YES];

            break;
            
        case 1:
            //隐藏蒙版
            [_switchView  hiddenInView:self.view animated:YES];
            [_themeSwitchView hiddenInView:self.view animated:YES];
            [self deleteDevice];
            
            break;
        case 2:
           //设置情景名称
            [_switchView  hiddenInView:self.view animated:YES];
            [_themeSwitchView hiddenInView:self.view animated:YES];
            
            [self.themeNameView  showView:self.view animated:YES];
           
            break;
            
    }
    
}

- (HCThemeView *)themeNameView{

    _themeNameView = [[HCThemeView alloc]initWithFrame:CGRectZero];
    
    deviceMessage *devicess = [[deviceMessage alloc]init];
    devicess.GATEWAY_NO = _dataCenter.gatewayNo;
    deviceMessage  *device =  [deviceMessageTool queryWithDevices:devicess][indexNum];
    themMessageModel *test_1 = [[themMessageModel alloc]init];
    test_1.device_No = device.DEVICE_NO;
    NSArray *test = [themeMessageTool  queryWiththeme:test_1];
    
    //在对应的情景上显示情景名称
    if (test.count == 1) {
        themMessageModel *themeFieldName_1 = test[0];
        
        _themeNameView.firstField.text =themeFieldName_1.theme_Name;
    }
    
    if (test.count ==2) {
        themMessageModel *themeFieldName_1 = test[0];
        themMessageModel *themeFieldName_2 = test[1];
        _themeNameView.firstField.text = themeFieldName_1.theme_Name;
        _themeNameView.secondaryField.text = themeFieldName_2.theme_Name;
    }
    if (test.count ==3) {
        themMessageModel *themeFieldName_1 = test[0];
        themMessageModel *themeFieldName_2 = test[1];
        themMessageModel *themeFieldName_3 = test[2];
        
        _themeNameView.firstField.text = themeFieldName_1.theme_Name;
        _themeNameView.secondaryField.text = themeFieldName_2.theme_Name;
        _themeNameView.thirdField.text = themeFieldName_3.theme_Name;
    }
    if (test.count ==4) {
        themMessageModel *themeFieldName_1 = test[0];
        themMessageModel *themeFieldName_2 = test[1];
        themMessageModel *themeFieldName_3 = test[2];
        themMessageModel *themeFieldName_4 = test[3];
        
        _themeNameView.firstField.text = themeFieldName_1.theme_Name;
        _themeNameView.secondaryField.text = themeFieldName_2.theme_Name;
        _themeNameView.thirdField.text = themeFieldName_3.theme_Name;
        _themeNameView.fourthField.text = themeFieldName_4.theme_Name;
    }
    _themeNameView.mainTitle.text = @"情景名称设置";
    _themeNameView.firstField.placeholder = @"情景1";
    _themeNameView.secondaryField.placeholder = @"情景2";
    _themeNameView.thirdField.placeholder = @"情景3";
    _themeNameView.fourthField.placeholder = @"情景4";
    _themeNameView.delegate = self;

    return _themeNameView;
}

- (HCProductView *)proMsgView{
    
    _proMsgView = [[HCProductView alloc]initWithFrame:CGRectZero];
    
    deviceMessage *devicess = [[deviceMessage alloc]init];
    devicess.GATEWAY_NO = _dataCenter.gatewayNo;

    //建立模型
    deviceMessage *device = [deviceMessageTool queryWithDevices:devicess][indexNum];
    deviceSpaceMessageModel *deviceSpace = [[deviceSpaceMessageModel alloc]init];
    deviceSpace.device_no = device.DEVICE_NO;
    deviceSpace.phone_num = _dataCenter.userPhoneNum;
    NSArray *deviceSpaceArry = [deviceSpaceMessageTool queryWithspacesDeviceNoAndPhonenum:deviceSpace];
    
    if (deviceSpaceArry.count ==0) {
        //显示设备名称
        _proMsgView.secondaryField.text = [NSString  stringWithFormat:@"%@",device.DEVICE_NAME];
        
    }else{
        
        deviceSpaceMessageModel *device_Name = deviceSpaceArry[0];
        spaceMessageModel *deviceNameModel = [[spaceMessageModel  alloc]init];
        deviceNameModel.space_Num = device_Name.space_no;
        //显示设备名称
        _proMsgView.secondaryField.text = [NSString  stringWithFormat:@"%@",device_Name.device_name];
    }
    
    //显示产品位置信息 默认是位置待定
    if (deviceSpaceArry.count !=0) {
        
            deviceSpaceMessageModel *device_Name = deviceSpaceArry[0];
            
            spaceMessageModel *deviceNameModel = [[spaceMessageModel  alloc]init];
            
            deviceNameModel.space_Num = device_Name.space_no;
            
            spaceMessageModel *deviceName;
            
            NSArray * deviceArray = [spaceMessageTool queryWithspacesDevicePostion:deviceNameModel];
            
            if (deviceArray.count == 0) {
                
                [MBProgressHUD  showError:@"找不到对应的位置信息"];
                
            }else{
                
                deviceName = deviceArray[0];
                
            }
            [_proMsgView.thirdButton setTitle:[NSString  stringWithFormat:@"%@",deviceName.space_Name] forState:UIControlStateNormal];

    }
    if (device.DEVICE_TYPE_ID == 110 | device.DEVICE_TYPE_ID == 113|device.DEVICE_TYPE_ID == 115|device.DEVICE_TYPE_ID == 118)
    {
        
       
        //目前搞不定
        if (device.SPACE_TYPE_ID ==1) {
            
            _proMsgView.indoorBtn.enabled= NO;
            _dataCenter.devcieSpaceTypeID  = 1; //室内
        }if (device.SPACE_TYPE_ID==2) {
            _dataCenter.devcieSpaceTypeID  = 2;
            _proMsgView.outdoorBtn.enabled = NO;
            
        }
        _proMsgView.mainTitle.text = @"产品设置";
        _proMsgView.secondaryTitle.text = @"产品名称 :";
        _proMsgView.thirdTitle.text = @"产品位置 :";
        _proMsgView.fourthTitle.text = @"安防分类 :";
        _proMsgView.secondaryTitle.layer.borderWidth = 0;
        _proMsgView.thirdTitle.layer.borderWidth = 0;
        _proMsgView.outdoorTitle.text =@"室外";
        _proMsgView.indoorTitle.text = @"室内";
        _proMsgView.delegate = self;
        
    }else{
        _proMsgView.mainTitle.text = @"产品设置";
        _proMsgView.secondaryTitle.text = @"产品名称 :";
        _proMsgView.thirdTitle.text = @"产品位置 :";
        
        _proMsgView.secondaryTitle.layer.borderWidth = 0;
        _proMsgView.thirdTitle.layer.borderWidth = 0;
        _proMsgView.outdoorTitle.hidden = YES;
        _proMsgView.indoorTitle.hidden = YES;
        _proMsgView.indoorBtn.hidden = YES;
        _proMsgView.outdoorBtn.hidden = YES;
        _proMsgView.fourthTitle.hidden = YES;
        _proMsgView.delegate = self;
        
        

    }
   
    return _proMsgView;
}

#pragma delegate HCProductView

-(void)makeSureViewClicked:(HCProductView *)daterView{
    
    //确定产品的修改信息
    [self changeProductSetting];
   

}

-(void)makeSureThemeViewClicked:(HCThemeView *)daterView{

    [self confirmSettingAction];
  

}

-(void)postionViewClicked:(HCProductView *)daterView{

    if (self.spaces.count !=0) {
        
        NSMutableArray * spaces=[NSMutableArray array];
        
        for (int i = 0; i < self.spaces.count; i++) {

           spaceMessageModel *space = self.spaces[i];
        
            [spaces addObject:[NSString stringWithFormat:@"%@",space.space_Name] ];
        }
        
        self.spacesView.titleArray = spaces;
        
        self.spacesView.title = @"空间信息";
        
        [self.spacesView showInView:self.view animated:YES];
        
        
    }else{
    
        [MBProgressHUD  showError:@"请先添加空间信息"];
    
    
    }
}

-(void)spaceViewClicked:(HCSpaceView *)daterView{

    NSInteger    currentIndex =  daterView.currentIndexPath.row;
    
    spaceMessageModel *space = self.spaces[currentIndex];
    //NSLog(@" currentIndex =  %ld  space_Name = %@",(long)currentIndex,space.space_Name);
    [_proMsgView.thirdButton  setTitle:space.space_Name forState:UIControlStateNormal];
    [self.spacesView hiddenInView:self.view animated:YES];

}
- (HCSpaceView *)spacesView{
    
    if(_spacesView == nil){
        
        _spacesView = [[HCSpaceView alloc]initWithFrame:CGRectZero];
        
        _spacesView.sureBtn.hidden = YES;
        
        _spacesView.cancleBtn.hidden = YES;
        
        _spacesView.delegate = self;
    }
    
    return _spacesView;
}


/**
 *  提醒用户是否需要删除设备
 */
-(void)deleteDevice{
    
    UIAlertView * alert = [[UIAlertView  alloc]initWithTitle:@"温馨提示" message:@"确定要删除此设备吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    self.alert = alert;
    
    [alert show];
    
}


/**
 删除本地device表中的设备 同事服务器也要对应删除该设备
 */
-(void)deleteDeviceToServer{
    
    //查找数据库中所有存在的设备
    
    deviceMessage *devicess = [[deviceMessage alloc]init];
    devicess.GATEWAY_NO = _dataCenter.gatewayNo;
    
    NSArray  *devices = [deviceMessageTool queryWithDevices:devicess];//[deviceMessageTool  queryWithDevices];
   
    //建立模型
    deviceMessage *device = devices[indexNum];
    
    //创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager  manager];
    mgr.responseSerializer = [AFJSONResponseSerializers  serializer];
    
    //配置请求超时时间
    mgr.requestSerializer.timeoutInterval = 60;
    
    //设置请求参数
    NSMutableDictionary  *params = [NSMutableDictionary  dictionary];
    
    params[@"phonenum"] = device.DEVICE_NO;
    
    NSString  *urlStr =[NSString  stringWithFormat:@"%@/appDeleteDevice" ,HomecooServiceURL];
    NSString *url = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
    
    [mgr  POST:url parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        //打印日志
        //NSLog(@"请求成功--%@",responseObject);
        NSString  *result = [responseObject[@"result"]description];
        
        NSString *message = [responseObject[@"messageInfo"]description];
        
        if ([result  isEqual:@"success"]) {
            
            [MBProgressHUD  showSuccess:[NSString  stringWithFormat:@"%@",message]];
            
            //删除本地device表中 对应的设备
            [self deleteDevices];
            
            
        } if ([result  isEqual:@"failed"]) {
            
            [MBProgressHUD  showError:[NSString  stringWithFormat:@"%@",message]];
            
        }
        
        [MBProgressHUD  hideHUD];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        [MBProgressHUD  showError:@"网络繁忙，请稍后再试"];
    }];
    
    
    
    



}

/**
 *  点击删除当前选中的
 */
-(void)deleteDevices{
    
    //查找数据库中所有存在的设备
    deviceMessage *devicess = [[deviceMessage alloc]init];
    devicess.GATEWAY_NO = _dataCenter.gatewayNo;
   
    NSArray  *devices = [deviceMessageTool queryWithDevices:devicess];//[deviceMessageTool  queryWithDevices];
  
    //建立模型
    deviceMessage *device = devices[indexNum];
    
    //取出当前cell中的网关信息
    deviceMessage  *deviceIndex = [[deviceMessage  alloc]init];
    
    deviceIndex.DEVICE_NO = device.DEVICE_NO;
    deviceIndex.GATEWAY_NO = _dataCenter.gatewayNo;
   
    //删除当前设备
    [deviceMessageTool  deleteDevice:deviceIndex];
    
    deviceSpaceMessageModel *deviceSpace = [[deviceSpaceMessageModel  alloc]init];
    
    deviceSpace.device_no = device.DEVICE_NO;
    deviceSpace.phone_num = _dataCenter.userPhoneNum;
    
    [deviceSpaceMessageTool  deleteDeviceSpaceWithDeviceno_phonenum:deviceSpace];
    
    //更新cell中设备
    if ([_dataCenter.gatewayNo isEqualToString:@"0"] | !_dataCenter.gatewayNo ) {
        
        [MBProgressHUD  showError:@"请先添加主机"];
        
    }else{
        
        deviceMessage *device = [[deviceMessage alloc]init];
        device.GATEWAY_NO = _dataCenter.gatewayNo;
        _devices=[deviceMessageTool queryWithDevices:device];
        
    }
    [MBProgressHUD  hideHUD];
    //刷新collectionView
    [_collectionView  reloadData];
    
}

//点击界面 退出蒙版
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //点击界面 退出蒙版效果
    [_switchView hiddenInView:self.view animated:YES];
    [_themeSwitchView  hiddenInView:self.view animated:YES];
    [_spacesView  hiddenInView:self.view animated:YES];
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
    
    //WhiteBackgroundLable.clipsToBounds = YES;
   // WhiteBackgroundLable.layer.cornerRadius = 8.0;//设置边框圆角
    self.WhiteBackgroundLable = WhiteBackgroundLable;
    
    [self.fullscreenView addSubview:WhiteBackgroundLable];
    
}


/**
 *设置导航栏
 */
-(void)setNavBar{
    
    CGFloat navBarW = [UIScreen  mainScreen].bounds.size.width;
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0,navBarW, 40)];
    
    //创建一个导航栏集合
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"产品管理"];
    
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
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleDone target:self action:@selector(finshedAction)];
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

/**
 *  完成（同步设备信息）
 */
-(void)finshedAction{

    if (_dataCenter.networkStateFlag==0) {
        
        [MBProgressHUD  showError:@"请切换到外网再操作！"];
        
    }else{
        
        [self  asyncDeviceListInfoAction];
        
    }
}

/**
 *  同步手机端所有device信息到服务器
 */
-(void)asyncDeviceListInfoAction{

    //创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager  manager];
    mgr.responseSerializer = [AFJSONResponseSerializers  serializer];
    
    //配置请求超时时间
    mgr.requestSerializer.timeoutInterval = 60;
    
    //设置请求参数
    NSMutableDictionary  *params = [NSMutableDictionary  dictionary];
    
   //NSString *test = [self  allDeviceList];
    
    NSString *deviceString = [[queryDeviceControlMethods  allDeviceList] componentsJoinedByString:@","]; //修改20161023
    NSString *sapceString = [[queryDeviceControlMethods allUserDeviceSpaceList] componentsJoinedByString:@","];
   
    NSString *versionString = [queryDeviceControlMethods allDeviceVersionList:@"2"];
    
    NSString *string1 = [@"["  stringByAppendingString:sapceString];
    NSString *string = [@"["  stringByAppendingString:deviceString];//修改20161023
    
    
    NSString *deviceStringJson = [string  stringByAppendingString:@"]"];//修改20161023
    NSString *sapceStringJson = [string1  stringByAppendingString:@"]"];
   
    params[@"deviceJson"] = deviceStringJson;
    params[@"versionJson"] = versionString;
    params[@"deviceSpaceJson"] = sapceStringJson;
    
    //NSLog(@"deviceJson %@",params[@"deviceJson"]);
    
    
    NSString  *urlStr =[NSString  stringWithFormat:@"%@/appSyncDeviceInfo" ,HomecooServiceURL];
    NSString *url = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
    
    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        
        //打印日志
        // NSLog(@"请求成功--%@",responseObject);
        
        NSString  *result = [responseObject[@"result"]description];
        
        NSString *message = [responseObject[@"messageInfo"]description];
        
        if ([result  isEqual:@"success"]) {//同步成功
            
            //[MBProgressHUD  hideHUD];//隐藏蒙版
            [MBProgressHUD  showSuccess:[NSString  stringWithFormat:@"%@",message]];
        }
        if ([result  isEqual:@"failed"]) {
            
            // [MBProgressHUD  hideHUD];//隐藏蒙版
            
            [MBProgressHUD  showError:[NSString  stringWithFormat:@"%@",message]];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //[MBProgressHUD  hideHUD];//隐藏蒙版
        [MBProgressHUD  showError:@"网络繁忙，请稍后再试！"];
    }];
    
    
    [MBProgressHUD  hideHUD];


    NSLog(@"=====同步设备信息到服务器==设备表=====用户配置表======版本信息======");

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
//只允许 横屏切换
-(BOOL)shouldAutorotate{
    
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}
@end
