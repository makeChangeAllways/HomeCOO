//
//  SingleLightViewController.m
//  HomeCOO
//
//  Created by tgbus on 16/5/7.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "SingleLightViewController.h"
#import "AppDelegate.h"
#import "SystemViewController.h"
#import "SpaceViewController.h"
#import "ThemeViewController.h"
#import "SecurityViewController.h"
#import "SettingViewController.h"
#import "MethodClass.h"
#import "PrefixHeader.pch"
#import "MBProgressHUD+MJ.h"
#import "AFNetworking.h"
#import "lightCollectionViewCell.h"
#import "ControlMethods.h"
#import "PacketMethods.h"
#import "deviceMessage.h"
#import "deviceMessageTool.h"
#import "gatewayMessageModel.h"
#import "gatewayMessageTool.h"
#import "spaceMessageModel.h"
#import "spaceMessageTool.h"
#import "deviceSpaceMessageModel.h"
#import "deviceSpaceMessageTool.h"
#import "LZXDataCenter.h"
#import "SocketManager.h"
#import "transCodingMethods.h"
#import "alarmRinging.h"
#import "alarmMessages.h"
#import "alarmMessagesTool.h"
#import "JPUSHService.h"


//底部空间、情景模式等按钮的高度
#define HOMECOOSPACEBUTTONHEIGHT 60

//底部空间、情景模式等按钮的宽度
#define HOMECOOSPACEBUTTONWIDTH [UIScreen  mainScreen].bounds.size.width / 5

//底部空间、情景模式等按钮Y的大小
#define  HOMECOOSPACEBUTTON_Y  [UIScreen  mainScreen].bounds.size.height - 55

//底部空间、情景模式等按钮字体的大小
#define HOMESPACEFONT 13


@interface SingleLightViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,NSStreamDelegate>
{
    
    NSInputStream *_inputStream;
    
    NSOutputStream *_outputStream;

}
/**设置背景图片*/
@property(nonatomic,weak)  UIImageView  * fullscreenView;

/**设置导航栏*/
@property(nonatomic,weak)  UINavigationBar *navBar;

/**设置白色背景图片*/
@property(nonatomic,weak) UILabel  *WhiteBackgroundLable;

@property (strong, nonatomic)  UICollectionView *collectionView;

/**设置按钮*/
@property(nonatomic,copy) NSString *str2;

/**添加一个数组，用来保存device*/
@property(nonatomic,strong) NSArray *devices;

@property(nonatomic,strong) lightCollectionViewCell *cell;

@property(nonatomic,strong) deviceMessage *device;

@property(nonatomic,strong) NSString *arr;

@property(nonatomic,strong) deviceSpaceMessageModel *deviceSpace;

@property(nonatomic,strong) spaceMessageModel *deviceNameModel;

@property  NSInteger process;

@property(nonatomic,copy) NSString *alarmString;

@property(nonatomic,copy) NSString *alertString;

@property(nonatomic,strong) UIAlertView * alert;

@property(nonatomic,strong) LZXDataCenter *dataCenter;

@property(nonatomic,strong) deviceMessage *devicess;

@end

static NSString *const string = @"lightCollectionViewCell";

@implementation SingleLightViewController


static NSInteger   indexNum;

static char arry[4] = {'0','0','0','0'};

#pragma mark-懒加载 加载所有的照明设备的信息


-(deviceSpaceMessageModel*)deviceSpace{

    if (_deviceSpace==nil) {
        _deviceSpace = [[deviceSpaceMessageModel alloc]init];
    }
    return _deviceSpace;
}
-(spaceMessageModel*)deviceNameModel{
    
    if (_deviceNameModel==nil) {
        _deviceNameModel = [[spaceMessageModel alloc]init];
    }
    return _deviceNameModel;
}
-(NSArray *)devices
{
    if (_devices==nil) {
        
        LZXDataCenter *gateway = [LZXDataCenter defaultDataCenter];
        
        if ([gateway.gatewayNo isEqualToString:@"0"] | !gateway.gatewayNo ) {
            
            [MBProgressHUD  showError:@"请先添加主机"];
            
        }else{
            
            deviceMessage *device = [[deviceMessage alloc]init];
            device.GATEWAY_NO = gateway.gatewayNo;
       
            _devices=[deviceMessageTool queryWithLightDevices:device];
        
            
        }
        
        [MBProgressHUD  hideHUD];
    }
    
    return _devices;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //设置背景底色
    [self  setWhiteBackground];
    
    LZXDataCenter *dataCenter = [LZXDataCenter defaultDataCenter];
    
    //创建一个导航栏
    [self setNavBar];
    
    //添加aUICollectionView
    [self  addUICollectionView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.dataCenter =dataCenter;
    //socket接收
    [self   receivedFromGateway_deviceMessage];
    
    //jpush接收
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    

    [defaultCenter addObserver:self
                    selector:@selector(networkDidReceiveMessage:)
                            name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
}

/**
 *  接收到自定义消息 调用此方法
 *
 *  @param notification
 */

- (void)networkDidReceiveMessage:(NSNotification *)notification {

    //外网情况下  接收底层上报状态 刷新UI
    [_collectionView  reloadData];
}

-(void)receivedFromGateway_deviceMessage{
    
    SocketManager  *socket = [SocketManager  shareSocketManager];
    [socket  receiveMsg:^(NSString *receiveInfo) {
     
        NSString *receiveMessage = receiveInfo;
        
        NSLog(@"    receiveMessage= %@  ",receiveMessage);
        
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
        
        NSInteger deviceGategory_ID = 0;
        NSString *deviceName;
        NSString *deviceState;
        
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
        
        
//        NSLog(@"========%ld=====%@======%@======%@=====%ld====%@====%@=====%ld======",(long)device.DEVICE_GATEGORY_ID,device.DEVICE_NAME,device.DEVICE_STATE,device.DEVICE_NO,(long)device.DEVICE_TYPE_ID,device.GATEWAY_NO,device.SPACE_NO,(long)device.SPACE_TYPE_ID);
//        
        
//        NSLog(@"====deviceArray %lu======",(unsigned long)deviceArray.count);
    
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
            
           [self exitApplication ];
            
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
 *  添加UICollectionView 来显示所有的照明设备
 */
-(void)addUICollectionView{

    CGFloat  collectionViewX = 20 ;
    CGFloat  collectionViewY = 60 ;
    CGFloat  collectionViewW = [UIScreen mainScreen].bounds.size.width - 40;
    CGFloat  collectionViewH = [UIScreen  mainScreen].bounds.size.height -140;
    //确定是水平滚动，还是垂直滚动
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    UICollectionView  *collectionView = [[UICollectionView  alloc]initWithFrame:CGRectMake(collectionViewX, collectionViewY, collectionViewW, collectionViewH) collectionViewLayout:flowLayout];
    
  
    collectionView.bounces = NO;//没有效果
    collectionView.dataSource=self;
    collectionView.delegate=self;
    collectionView.backgroundColor = [UIColor  whiteColor];
    
    [collectionView registerClass:[lightCollectionViewCell class] forCellWithReuseIdentifier:string];
    
     self.collectionView = collectionView;
    
    [self.fullscreenView addSubview:collectionView];

}

//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSInteger  count = 0 ;
    
    if ([_dataCenter.gatewayNo isEqualToString:@"0"] | !_dataCenter.gatewayNo ) {
        
        [MBProgressHUD  showError:@"请先添加主机"];
       
    }else{
        
        deviceMessage *devicess = [[deviceMessage  alloc]init];
        devicess.GATEWAY_NO = _dataCenter.gatewayNo;

        count = [deviceMessageTool queryWithLightDevices:devicess].count;
      
    }
 
    return  count;
}

/**
 *  每个UICollectionView展示的内容 (每次滑动 都调用这个代理方法)
 *
 *  @param collectionView
 *  @param indexPath
 *
 *  @return
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  
    _cell = [collectionView dequeueReusableCellWithReuseIdentifier:string forIndexPath:indexPath];

    _cell.button1.hidden = NO;
    _cell.button2.hidden = NO;
    _cell.button3.hidden = NO;
    _cell.button4.hidden = NO;
    _cell.process.hidden = NO;
    
    _cell.button1.selected = NO;
    _cell.button2.selected = NO;
    _cell.button3.selected = NO;
    _cell.button4.selected = NO;
    
    //先取出模型里的数据

    if (!_devicess) {
        _devicess = [[deviceMessage  alloc]init];
        
    }
    _devicess.GATEWAY_NO = _dataCenter.gatewayNo;
    
    deviceMessage *device=[deviceMessageTool queryWithLightDevices:_devicess][indexPath.row];
    
    if (!_deviceSpace) {
        _deviceSpace = [[deviceSpaceMessageModel alloc]init];
   
    }
    
    _deviceSpace.device_no = device.DEVICE_NO;
    _deviceSpace.phone_num = _dataCenter.userPhoneNum;
    
    NSArray *deviceSpaceArry = [deviceSpaceMessageTool queryWithspacesDeviceNoAndPhonenum:_deviceSpace];
    
    if (deviceSpaceArry.count ==0) {
        
        _cell.messageLable.text =[NSString  stringWithFormat:@"  位置待定/%@",device.DEVICE_NAME];
        
    }else{

        deviceSpaceMessageModel *device_Name = deviceSpaceArry[0];
        
        spaceMessageModel *deviceNameModel = [[spaceMessageModel  alloc]init];
        
        deviceNameModel.space_Num = device_Name.space_no;
  
        NSArray *deviceArry =[spaceMessageTool queryWithspacesDevicePostion:deviceNameModel];
        
        if (deviceArry.count!=0) {
            
            spaceMessageModel *deviceName = deviceArry[0];
            
            //显示设备位置和设备名称
            _cell.messageLable.text =[NSString  stringWithFormat:@"  %@/%@",deviceName.space_Name,device_Name.device_name];
            
        }else{
        
            _cell.messageLable.text =[NSString  stringWithFormat:@"  位置待定/%@",device_Name.device_name];
        }
        
    }
    //根据DEVICE_TYPE_ID显示开关个数
    switch (device.DEVICE_TYPE_ID  ) {

        case 1:
            _cell.process.hidden = YES;
            _cell.button1.hidden = YES;
            _cell.button2.hidden = YES;
            _cell.button3.hidden = YES;
            
            if ([device.DEVICE_STATE  isEqualToString:@"0"]) {
                
                _cell.button4.selected = YES;

            }
            
             break;
            
        case 2:
            
            if ([device.DEVICE_STATE  isEqualToString:@"00"]) {
                
                 _cell.button4.selected = YES;
                 _cell.button3.selected = YES;

                
            }
            
            if ([device.DEVICE_STATE  isEqualToString:@"10"]) {
            
                _cell.button4.selected = YES;
                
            }
            
            if ([device.DEVICE_STATE  isEqualToString:@"01"]) {
                
              
                _cell.button3.selected = YES;
              
            }

            _cell.button1.hidden = YES;
            _cell.button2.hidden = YES;
             _cell.process.hidden = YES;
            break;
            
        case 3:
            
            if ([device.DEVICE_STATE  isEqualToString:@"100"]) {
                
             
                _cell.button3.selected = YES;
                 _cell.button4.selected = YES;
                
                
            }
            
            if ([device.DEVICE_STATE  isEqualToString:@"101"]) {

                _cell.button3.selected = YES;
               

                
            }
            
            if ([device.DEVICE_STATE  isEqualToString:@"110"]) {

             
                _cell.button4.selected = YES;

            }

            
            if ([device.DEVICE_STATE  isEqualToString:@"010"]) {
              
                _cell.button2.selected = YES;
               _cell.button4.selected = YES;
                
            }
            
            if ([device.DEVICE_STATE  isEqualToString:@"001"]) {
                
                _cell.button2.selected = YES;
                _cell.button3.selected = YES;
                
            }
            
            if ([device.DEVICE_STATE  isEqualToString:@"011"]) {

                _cell.button2.selected = YES;
                
            }
            if ([device.DEVICE_STATE  isEqualToString:@"000"]) {
                
                _cell.button3.selected = YES;
                _cell.button4.selected = YES;
                _cell.button2.selected = YES;
                
            }
            _cell.process.hidden = YES;
            _cell.button1.hidden = YES;
            
            break;
            
        case 4:
            
            if ([device.DEVICE_STATE  isEqualToString:@"1011"]) {
                
                _cell.button2.selected = YES;
               
            }

            if ([device.DEVICE_STATE  isEqualToString:@"1010"]) {

                _cell.button2.selected = YES;
               
                _cell.button4.selected = YES;
               
                
            }
            
            if ([device.DEVICE_STATE  isEqualToString:@"1001"]) {
                
                _cell.button2.selected = YES;
                

                _cell.button3.selected = YES;
                
            }
            if ([device.DEVICE_STATE  isEqualToString:@"1000"]) {
             
                _cell.button2.selected = YES;
                _cell.button3.selected = YES;
                _cell.button4.selected = YES;
              
                
            }
            
            if ([device.DEVICE_STATE  isEqualToString:@"0000"]) {
                _cell.button1.selected = YES;
                _cell.button2.selected = YES;
                _cell.button3.selected = YES;
                _cell.button4.selected = YES;
                
            }
            if ([device.DEVICE_STATE  isEqualToString:@"1110"]) {
               
                
                _cell.button4.selected = YES;
                
            }
           
            
            if ([device.DEVICE_STATE  isEqualToString:@"1101"]) {
                
               
              
                _cell.button3.selected = YES;
                
            }
            
            if ([device.DEVICE_STATE  isEqualToString:@"1100"]) {
                

                _cell.button3.selected = YES;
                _cell.button4.selected = YES;
                
            }
            if ([device.DEVICE_STATE  isEqualToString:@"0011"]) {
              
                _cell.button1.selected = YES;
                _cell.button2.selected = YES;
                
                
            }
            
            if ([device.DEVICE_STATE  isEqualToString:@"0010"]) {
                
                _cell.button1.selected = YES;
                _cell.button2.selected = YES;
                _cell.button4.selected = YES;
                
            }
            
            if ([device.DEVICE_STATE  isEqualToString:@"0001"]) {
           
                 _cell.button1.selected = YES;
                 _cell.button2.selected = YES;
                 _cell.button3.selected = YES;
                
            }
            
          
            if ([device.DEVICE_STATE  isEqualToString:@"0111"]) {
                
                _cell.button1.selected = YES;
                
                
            }
            
            if ([device.DEVICE_STATE  isEqualToString:@"0110"]) {
                
                _cell.button1.selected = YES;
                _cell.button4.selected = YES;
                
            }
            
            if ([device.DEVICE_STATE  isEqualToString:@"0101"]) {
                
                _cell.button1.selected = YES;
                
                _cell.button3.selected = YES;
                
            }
            
            if ([device.DEVICE_STATE  isEqualToString:@"0100"]) {
                
                _cell.button1.selected = YES;
                _cell.button3.selected = YES;
                _cell.button4.selected = YES;
               
                
            }
          _cell.process.hidden = YES;
            break;
       
        case 5:
            _cell.button1.hidden = YES;
            _cell.button2.hidden = YES;
            _cell.button3.hidden = YES;
            _cell.button4.hidden = YES;
            
            _cell.process.value = [device.DEVICE_STATE intValue];
            
            break;
    }

    //监听按钮点击事件
    [_cell.button4  addTarget:self action:@selector(enterChangeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_cell.button3  addTarget:self action:@selector(enterChangeButton:) forControlEvents:UIControlEventTouchUpInside];
   
    [_cell.button2  addTarget:self action:@selector(enterChangeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_cell.button1  addTarget:self action:@selector(enterChangeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_cell.process addTarget:self action:@selector(enterChangeProcess:) forControlEvents:UIControlEventValueChanged];
    return _cell;

}

/**
 *  调光开关
 *
 *  @param
 */
-(void)enterChangeProcess:(UISlider *)pro{
    
 
    lightCollectionViewCell *cell = (lightCollectionViewCell *)[[[pro superview]superview]superview];//获取cell
    
    NSIndexPath *indexPathAll = [self.collectionView indexPathForCell:cell];//获取cell对应的section
    
    indexNum =indexPathAll.row;
    
    NSArray  *devices;
    
    
    if ([_dataCenter.gatewayNo isEqualToString:@"0"] | !_dataCenter.gatewayNo ) {
        
        [MBProgressHUD  showError:@"请先添加主机"];
        
    }else{
        
        deviceMessage *device = [[deviceMessage alloc]init];
        device.GATEWAY_NO = _dataCenter.gatewayNo;
        devices=[deviceMessageTool queryWithLightDevices:device];
        
    }
    
    [MBProgressHUD  hideHUD];
 
    //取出当前cell的设备信息
    deviceMessage  *dev = devices[indexNum];

    NSInteger process = pro.value +0.5;
    
    //将整数值 重新赋值给UISlider
    [pro setValue:process animated:NO];
    
    self.process = process;
    
    deviceMessage *state = [[deviceMessage  alloc]init];
    state.DEVICE_STATE = [NSString stringWithFormat:@"%ld",(long)process];
    state.DEVICE_NO = dev.DEVICE_NO;
    state.GATEWAY_NO = _dataCenter.gatewayNo;
    [deviceMessageTool  updateDeviceState:state];
   
    [self  switchOnTiaoguangAction];
   

}

/**
 *  外网控制设备发送报文 调光
 */
-(void)switchOnTiaoguangAction {

    SocketManager *socket = [[SocketManager  alloc]init];
    NSArray  *devices;
    
    
    deviceMessage *device = [[deviceMessage alloc]init];
    device.GATEWAY_NO = _dataCenter.gatewayNo;
    devices=[deviceMessageTool queryWithLightDevices:device];
        
    
    //取出当前cell的设备信息
    deviceMessage  *dev = devices[indexNum];

    //拆报文
    NSString *head = @"42424141";
    
    NSString *stamp = @"00000000";
    
    NSString *gw_id = _dataCenter.gatewayNo;
    
    NSString *dev_id = dev.DEVICE_NO;
    
    NSString *dev_type = @"0500";

    NSString *data_type = @"0200";
    
    NSString *data_len = @"0001";
    
    NSString *data =[ControlMethods  ToHex:self.process];
    
    //拼接发送报文
    NSString *packet = [PacketMethods  devicePacket:head getStamp:stamp getGw_id:gw_id getDev_id:dev_id getDev_type:dev_type getData_type:data_type getData_len:data_len getData:data];
    
    
    NSString *deviceControlPacketStr = [packet stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
    
    if (_dataCenter.networkStateFlag == 0) {//内网
        
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
    
    [MBProgressHUD  hideHUD];
}


/**
 *  按钮监听事件
 *
 *  @param btn 点击的是哪个
 */
- (void)enterChangeButton:(UIButton *)btn {
    
    lightCollectionViewCell *cell = (lightCollectionViewCell *)[[[btn superview]superview]superview];//获取cell
    
    NSIndexPath *indexPathAll = [self.collectionView indexPathForCell:cell];//获取cell对应的section
   
    indexNum =indexPathAll.row;
   
    NSArray  *devices;

   
    deviceMessage *device = [[deviceMessage alloc]init];
    device.GATEWAY_NO = _dataCenter.gatewayNo;
    devices=[deviceMessageTool queryWithLightDevices:device];
        
    
    //取出当前cell的设备信息
    deviceMessage  *dev = devices[indexNum];
    
    deviceMessage *state = [[deviceMessage  alloc]init];
    
    btn.selected = !btn.selected;
    if (dev.DEVICE_TYPE_ID ==1) {
        switch (btn.tag) {
                
            case 400:
                
                if (btn.selected) {
                    
                   
                     memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    
                  
                    if (arry[0] == '1') {
                        arry[0] = '0';
                    }
                    else{
                        
                    arry[0] = '1';
                    
                    }
                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 1)];
                    self.arr = arr;
                    state.DEVICE_STATE = arr;
                    state.DEVICE_NO = dev.DEVICE_NO;
                    state.GATEWAY_NO = _dataCenter.gatewayNo;
                    [deviceMessageTool  updateDeviceState:state];
                    
                    //NSLog(@"%@",arr);

                }else{
                    
                    memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    
                    if (arry[0] == '0') {
                        arry[0] = '1';
                    }
                    else{
                        
                        arry[0] = '0';
                        
                    }

                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 1)];
                    self.arr = arr;
                    state.DEVICE_STATE = arr;
                    state.DEVICE_NO = dev.DEVICE_NO;
                    state.GATEWAY_NO = _dataCenter.gatewayNo;
                    [deviceMessageTool  updateDeviceState:state];
                    
                    //NSLog(@"%@",arr);

                }
                
                break;
                
        }
        
    }

    if (dev.DEVICE_TYPE_ID ==2) {
        switch (btn.tag) {
                
            case 400:
                
                if (btn.selected) {
                    memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    
                    if (arry[1] == '1') {
                        arry[1] = '0';
                    }
                    else{
                        
                        arry[1] = '1';
                        
                    }

                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 2)];
                    self.arr = arr;
                    state.DEVICE_STATE = arr;
                    state.DEVICE_NO = dev.DEVICE_NO;
                    state.GATEWAY_NO = _dataCenter.gatewayNo;
                    [deviceMessageTool  updateDeviceState:state];
                    
                    //NSLog(@"%@",arr);
 
                }else{
                    memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    
                    if (arry[1] == '0') {
                        arry[1] = '1';
                    }
                    else{
                        
                        arry[1] = '0';
                        
                    }

                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 2)];
                    self.arr = arr;
                    state.DEVICE_STATE = arr;
                    state.DEVICE_NO = dev.DEVICE_NO;
                    state.GATEWAY_NO = _dataCenter.gatewayNo;
                    [deviceMessageTool  updateDeviceState:state];
                    
                   // NSLog(@"%@",arr);
                   
                }
                
                break;
                
            case 300:
                if (btn.selected) {
                    
                    memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                  
                    if (arry[0] == '1') {
                        arry[0] = '0';
                    }
                    else{
                        
                        arry[0] = '1';
                        
                    }

                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 2)];
                    
                    self.arr = arr;
                    state.DEVICE_STATE = arr;
                    state.DEVICE_NO = dev.DEVICE_NO;
                    state.GATEWAY_NO = _dataCenter.gatewayNo;
                    [deviceMessageTool  updateDeviceState:state];
                    
                    //NSLog(@"%@",arr);
                   
                }else{
                    memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    
                    if (arry[0] == '0') {
                        
                        arry[0] = '1';
                        
                    }
                    else{
                        
                        arry[0] = '0';
                        
                    }

                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 2)];
                    self.arr = arr;
                    state.DEVICE_STATE = arr;
                    state.DEVICE_NO = dev.DEVICE_NO;
                    state.GATEWAY_NO = _dataCenter.gatewayNo;
                    [deviceMessageTool  updateDeviceState:state];
                    
                    //NSLog(@"%@",arr);
                }
                
              
                break;
                
        }
        
    }

    if (dev.DEVICE_TYPE_ID ==3) {
        
        switch (btn.tag) {
                
            case 400:
                
                if (btn.selected) {
                   
                    memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],4);
                    
                    if (arry[2] == '1') {
                        arry[2] = '0';
                    }
                    else{
                        
                        arry[2] = '1';
                        
                    }

                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 3)];
                    self.arr = arr;
                    state.DEVICE_STATE = arr;
                    state.DEVICE_NO = dev.DEVICE_NO;
                    state.GATEWAY_NO = _dataCenter.gatewayNo;
                    [deviceMessageTool  updateDeviceState:state];
                    
                    //NSLog(@"%@",arr);
                   
                }else{
                    
                    memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    
                    if (arry[2] == '0') {
                        arry[2] = '1';
                    }
                    else{
                        
                        arry[2] = '0';
                        
                    }

                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 3)];
                    self.arr = arr;
                    state.DEVICE_STATE = arr;
                    state.DEVICE_NO = dev.DEVICE_NO;
                    state.GATEWAY_NO = _dataCenter.gatewayNo;
                    [deviceMessageTool  updateDeviceState:state];
                    
                    //NSLog(@"%@",arr);
                    
                }
                
              
                
                break;
                
            case 300:
                
                if (btn.selected) {
                    memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    
                    if (arry[1] == '1') {
                        arry[1] = '0';
                    }
                    else{
                        
                        arry[1] = '1';
                        
                    }

                   
                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 3)];
                    
                    self.arr = arr;
                    state.DEVICE_STATE = arr;
                    state.DEVICE_NO = dev.DEVICE_NO;
                    state.GATEWAY_NO = _dataCenter.gatewayNo;
                    [deviceMessageTool  updateDeviceState:state];
                    
                   // NSLog(@"%@",arr);
                   
                }else{
                    
                    memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    
                    if (arry[1] == '0') {
                        arry[1] = '1';
                    }
                    else{
                        
                        arry[1] = '0';
                        
                    }

                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 3)];
                    self.arr = arr;
                    state.DEVICE_STATE = arr;
                    state.DEVICE_NO = dev.DEVICE_NO;
                    state.GATEWAY_NO = _dataCenter.gatewayNo;
                    [deviceMessageTool  updateDeviceState:state];
                    
                    //NSLog(@"%@",arr);
                    
                }
                
                break;
            case 200:
                if (btn.selected) {
                    
                    memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    
                    if (arry[0] == '1') {
                        arry[0] = '0';
                    }
                    else{
                        
                        arry[0] = '1';
                        
                    }

                   
                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 3)];
                    self.arr = arr;
                    state.DEVICE_STATE = arr;
                    state.DEVICE_NO = dev.DEVICE_NO;
                    state.GATEWAY_NO = _dataCenter.gatewayNo;
                    [deviceMessageTool  updateDeviceState:state];
                    
                    //NSLog(@"%@",arr);
                    
                }else{
                    memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    
                    if (arry[0] == '0') {
                        arry[0] = '1';
                    }
                    else{
                        
                        arry[0] = '0';
                        
                    }

                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 3)];
                    self.arr = arr;
                    
                    state.DEVICE_STATE = arr;
                    state.DEVICE_NO = dev.DEVICE_NO;
                    state.GATEWAY_NO = _dataCenter.gatewayNo;
                    [deviceMessageTool  updateDeviceState:state];
                    
                    //NSLog(@"%@",arr);
     
                }
                
                break;
                
        }

   
    }
    
    
    if (dev.DEVICE_TYPE_ID ==4) {
        
        switch (btn.tag) {
                
            case 400:
                
                if (btn.selected) {
                    
                     memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    
                    if (arry[3] == '1') {
                        arry[3] = '0';

                    }else{
                        
                        arry[3] = '1';

                    }
                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 4)];
                    self.arr = arr;
                    state.DEVICE_STATE = arr;
                    state.DEVICE_NO = dev.DEVICE_NO;
                    state.GATEWAY_NO = _dataCenter.gatewayNo;
                    [deviceMessageTool  updateDeviceState:state];
                    
                    //NSLog(@"%@",arr);
                  
                }else{
                    
                    memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                   
                    if (arry[3] == '0') {
                        
                        arry[3] = '1';
                        
                    }else{
                        
                        arry[3] = '0';
                        
                    }
                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 4)];
                    self.arr = arr;
                    state.DEVICE_STATE = arr;
                    state.DEVICE_NO = dev.DEVICE_NO;
                    state.GATEWAY_NO = _dataCenter.gatewayNo;
                    [deviceMessageTool  updateDeviceState:state];
                    
                   // NSLog(@"%@",arr);
                
                }
                
               
                
                break;
                
            case 300:
                if (btn.selected) {
                     memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);

                    if (arry[2] == '1') {
                        arry[2] = '0';
                        
                    }else{
                        
                        arry[2] = '1';
                        
                    }
                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 4)];
                    
                    self.arr = arr;
                    state.DEVICE_STATE = arr;
                    state.DEVICE_NO = dev.DEVICE_NO;
                    state.GATEWAY_NO = _dataCenter.gatewayNo;
                    [deviceMessageTool  updateDeviceState:state];
                    
                    //NSLog(@"%@",arr);
     
                }else{
                     memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);

                    if (arry[2] == '0') {
                        arry[2] = '1';
                        
                    }else{
                        
                        arry[2] = '0';
                        
                    }

                    
                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 4)];
                    self.arr = arr;
                    state.DEVICE_STATE = arr;
                    state.DEVICE_NO = dev.DEVICE_NO;
                    state.GATEWAY_NO = _dataCenter.gatewayNo;
                    [deviceMessageTool  updateDeviceState:state];
                    
                    //NSLog(@"%@",arr);
  
                }
                
               
                
                break;
            case 200:
                if (btn.selected) {
                     memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);

                    
                    if (arry[1] == '1') {
                        arry[1] = '0';
                        
                    }else{
                        
                        arry[1] = '1';
                        
                    }

                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 4)];
                    self.arr = arr;
                    state.DEVICE_STATE = arr;
                    state.DEVICE_NO = dev.DEVICE_NO;
                    state.GATEWAY_NO = _dataCenter.gatewayNo;
                    [deviceMessageTool  updateDeviceState:state];
                    
                    //NSLog(@"%@",arr);
 
                }else{
                     memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                   
                    if (arry[1] == '0') {
                        arry[1] = '1';
                        
                    }else{
                        
                        arry[1] = '0';
                        
                    }
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 4)];
                    self.arr = arr;
                    
                    state.DEVICE_STATE = arr;
                    state.DEVICE_NO = dev.DEVICE_NO;
                    state.GATEWAY_NO = _dataCenter.gatewayNo;
                    [deviceMessageTool  updateDeviceState:state];
                    
                    //NSLog(@"%@",arr);
 
                }
                
                break;
            case 100:
                if (btn.selected) {
                    memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);

                    
                    if (arry[0] == '1') {
                        arry[0] = '0';
                        
                    }else{
                        
                        arry[0] = '1';
                        
                    }
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 4)];
                    self.arr = arr;
                    state.DEVICE_STATE = arr;
                    state.DEVICE_NO = dev.DEVICE_NO;
                    state.GATEWAY_NO = _dataCenter.gatewayNo;
                    [deviceMessageTool  updateDeviceState:state];
                    
                    //NSLog(@"%@",arr);

                    
                }else{
                    memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);

                    
                    if (arry[0] == '0') {
                        arry[0] = '1';
                        
                    }else{
                        
                        arry[0] = '0';
                        
                    }
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 4)];
                    self.arr = arr;
                    state.DEVICE_STATE = arr;
                    state.DEVICE_NO = dev.DEVICE_NO;
                    state.GATEWAY_NO = _dataCenter.gatewayNo;
                    [deviceMessageTool  updateDeviceState:state];
                    
                    //NSLog(@"%@",arr);
                    
                }
               
                break;
                
        }
        
    }
 
   
     [self   switchOnAction];
   
}


/**
 *  将字符串数组转换成NSStiring型
 *
 *  @param string 字符串型数组
 *
 *  @return 返回NSString型
 */
-(NSString *)transArryToStr:(char *)string{
    
    NSString *str = [NSString stringWithCString:string encoding:NSASCIIStringEncoding];

    return str;
}

/**
 *  控制设备发送报文
 */
-(void)switchOnAction {

    SocketManager *socket = [SocketManager  shareSocketManager];
    NSString *hex16;
    NSString *devType;
    NSString *datalen;
    NSArray  *devices;

    
    if ([_dataCenter.gatewayNo isEqualToString:@"0"] | !_dataCenter.gatewayNo ) {
        [MBProgressHUD  showError:@"请先添加主机"];
    }else{
        deviceMessage *device = [[deviceMessage alloc]init];
        device.GATEWAY_NO = _dataCenter.gatewayNo;
        devices=[deviceMessageTool queryWithLightDevices:device];
        
    }
  
    
    //取出当前cell的设备信息
    deviceMessage  *dev = devices[indexNum];
    
    //将int 型转换为byte型
    if (dev.DEVICE_TYPE_ID <16) {
       
        hex16 = [self  ToHex:dev.DEVICE_TYPE_ID];
        
        devType = [NSString  stringWithFormat:@"0%@00",hex16];
        datalen = [NSString  stringWithFormat:@"000%@",hex16];

    }else{
        
        hex16 = [self  ToHex:dev.DEVICE_TYPE_ID];
        devType = [NSString  stringWithFormat:@"%@00",hex16];
    
    }
    
    //获取设备报文
    // NSString *devicePacket = @"42424141000000003030414130304444bcbc3706004b1200030002000003";
    
    //拆报文
    NSString *head = @"42424141";
    
    NSString *stamp = @"00000000";
    
    
    NSString *gw_id = _dataCenter.gatewayNo;
   
    NSString *dev_id = dev.DEVICE_NO;
        
    NSString *dev_type = devType;
        
    NSString *data_type = @"0200";
        
    NSString *data_len = datalen;
        
    NSString *data =[ControlMethods  transCoding: self.arr];
        
        //拼接发送报文
    NSString *packet = [PacketMethods  devicePacket:head getStamp:stamp getGw_id:gw_id getDev_id:dev_id getDev_type:dev_type getData_type:data_type getData_len:data_len getData:data];
        
        
    NSString *deviceControlPacketStr = [packet stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
        //打印报文
    
    if (_dataCenter.networkStateFlag == 0) {//内网
        
        NSString *localControlMessage = [deviceControlPacketStr  stringByReplacingCharactersInRange:NSMakeRange(0, 8) withString:@"41414444"];
        
         NSLog(@"===localControlMessage is %@==",localControlMessage);
        
        [socket  sendMsg:localControlMessage];
        
    }else{
        
        //发送报文到对应设备
        [ControlMethods  controlDeviceHTTPmethods:deviceControlPacketStr ];
        

        NSLog(@"==deviceControlPacketStr is %@ ==",deviceControlPacketStr);
        
    }
    [MBProgressHUD  hideHUD];
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
 *设置导航栏
 */
-(void)setNavBar{
    
    
    CGFloat navBarW = [UIScreen  mainScreen].bounds.size.width;
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0,navBarW, 40)];
    
    //创建一个导航栏集合
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"照明"];
    
    //设置字体大小
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
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleDone target:self action:@selector(exitAction)];
    rightButton.title = @"退出";
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
    
    SystemViewController *vc = [[SystemViewController  alloc]init];
    
    [self  presentViewController:vc animated:YES completion:nil];
    
}


/**
 *退出系统
 */
-(void)exitAction{
    UIAlertView * alert = [[UIAlertView  alloc]initWithTitle:@"温馨提示" message:@"确定要退出HomeCOO系统吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    self.alert =alert;
    
    [alert show];
    
}
/**
 *退出应用
 */
- (void)exitApplication {
    
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
 *  10进制转换为16进制
 */
- (NSString *)ToHex:(uint16_t)tmpid
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
    return str;
}

-(BOOL)shouldAutorotate{
    return YES;
}



-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

@end

