//
//  SpaceViewController.m
//  HomeCOO
//
//  Created by tgbus on 16/5/3.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "SpaceViewController.h"
#import "AppDelegate.h"
#import "SystemViewController.h"
#import "ThemeViewController.h"
#import "SecurityViewController.h"
#import "SettingViewController.h"
#import "MethodClass.h"
#import "UIView+Extension.h"
#import "spaceMessageModel.h"
#import "spaceMessageTool.h"
#import "LZXDataCenter.h"
#import "MBProgressHUD+MJ.h"
#import "deviceMessage.h"
#import "deviceMessageTool.h"
#import "deviceSpaceMessageModel.h"
#import "deviceSpaceMessageTool.h"
#import "spaceDeviceCollectionViewCell.h"
#import "ControlMethods.h"
#import "PacketMethods.h"
#import "SocketManager.h"
#import "transCodingMethods.h"
#import "alarmRinging.h"
#import "alarmMessages.h"
#import "alarmMessagesTool.h"
#import "JPUSHService.h"

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width

//底部空间、情景模式等按钮的高度
#define HOMECOOSPACEBUTTONHEIGHT 60

//底部空间、情景模式等按钮的宽度
#define HOMECOOSPACEBUTTONWIDTH [UIScreen  mainScreen].bounds.size.width / 5

//底部空间、情景模式等按钮Y的大小
#define  HOMECOOSPACEBUTTON_Y  [UIScreen  mainScreen].bounds.size.height - 55

//底部空间、情景模式等按钮字体的大小
#define HOMESPACEFONT 13

@interface SpaceViewController ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

/**设置背景图片*/
@property(nonatomic,weak)  UIImageView  * fullscreenView;

/**设置导航栏*/
@property(nonatomic,weak)  UINavigationBar *navBar;

/**设置背景底色*/
@property(nonatomic,weak) UILabel  *WhiteBackgroundLable;

@property(nonatomic,strong)  UIPageControl  *pageControl;

@property(nonatomic,strong)  UIScrollView *scrollView;

@property(nonatomic,strong) NSArray *spaces;

@property(nonatomic,strong) spaceDeviceCollectionViewCell *cell;

@property(nonatomic,strong) NSArray *devices;

@property(nonatomic,strong) UICollectionView* collectionView;

@property  NSInteger count;

@property(nonatomic,strong) UINavigationItem *navItem;

@property(nonatomic,strong) NSArray *deviceSpaceArray;

@property NSInteger  deviceNumbers;

@property(nonatomic,strong) NSString *arr;

@property  NSInteger process;

@property int   pages;

@property NSInteger flag;

@property(nonatomic,copy) NSString *alarmString;

@property(nonatomic,copy) NSString *alertString;

@property(nonatomic,strong) UIAlertView * alert;

@property(nonatomic,strong) LZXDataCenter *dataCenter;

@end

static NSString *string = @"spaceDeviceCollectionViewCell";
static NSInteger   indexNum;
static char arry[4] = {'0','0','0','0'};

@implementation SpaceViewController

-(NSArray *)devices
{
    if (_devices==nil) {
        
        LZXDataCenter *gateway = [LZXDataCenter defaultDataCenter];
        
        if ([gateway.gatewayNo isEqualToString:@"0"] | !gateway.gatewayNo ) {
            
            [MBProgressHUD  showError:@"请先添加主机"];
            
        }else{
        
            deviceMessage *device = [[deviceMessage alloc]init];
            device.GATEWAY_NO = gateway.gatewayNo;
            _devices=[deviceMessageTool queryWithSpaceDevices:device];
            
        }
        [MBProgressHUD  hideHUD];
    }
    
    return _devices;
    
}

-(NSArray *)spaces{

    if (_spaces == nil) {
        
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
    
    
    //创建一个导航栏
    [self setNavBar];
    
    LZXDataCenter *dataCenter = [LZXDataCenter  defaultDataCenter];
    
    self.dataCenter = dataCenter;
    
    //设置底片背景
    [self  setWhiteBackground];
   

    //添加scrollview
    [self  performSelector:@selector(addUIScrollView) withObject:nil afterDelay:0.5];
  
    [self  lodingDevices];
   
    //socket接收
    [self   receivedFromGateway_deviceMessage];
        
  
    //注册通知 jpush接收
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter addObserver:self
                          selector:@selector(networkDidReceiveMessage:)
                              name:kJPFNetworkDidReceiveMessageNotification
                            object:nil];
    
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



/**
 *  进入控制器后 加载第一页空间中的设备
 */
-(void)lodingDevices{

    if (self.spaces.count != 0) {
        
        spaceMessageModel *space = self.spaces[0];
        
        deviceSpaceMessageModel  *deviceSpace = [[deviceSpaceMessageModel   alloc]init];
        
        deviceSpace.space_no = space.space_Num;
        
        NSArray *deviceSpaceArray = [deviceSpaceMessageTool queryWithspacesDeviceNumbers:deviceSpace ];
        
        NSInteger deviceNumbers = 0;
        
        for (int i = 0; i < deviceSpaceArray.count; i ++) {
            
            deviceSpaceMessageModel  *devicespaceModel = deviceSpaceArray[i];
            deviceMessage *device = [[deviceMessage  alloc]init];
            device.DEVICE_NO = devicespaceModel.device_no;
            device.GATEWAY_NO = space.gateway_Num;
            
            NSArray *deviceArray = [deviceMessageTool  queryWithDeviceNumDevices:device];
            
            if (deviceArray.count!= 0 ) {
                
                deviceMessage *deviceMessage = deviceArray[0];
                
                if ((deviceMessage.DEVICE_GATEGORY_ID ==1)|(deviceMessage.DEVICE_GATEGORY_ID ==3)|(deviceMessage.DEVICE_GATEGORY_ID ==5)) {
                    
                    deviceNumbers ++;
                    
                }
            }
            
            
        }
        
        self.deviceNumbers = deviceNumbers;
        
        self.deviceSpaceArray = deviceSpaceArray;
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
        
//        
//        NSLog(@"========%ld=====%@======%@======%@=====%ld====%@====%@=====%ld======",(long)device.DEVICE_GATEGORY_ID,device.DEVICE_NAME,device.DEVICE_STATE,device.DEVICE_NO,(long)device.DEVICE_TYPE_ID,device.GATEWAY_NO,device.SPACE_NO,(long)device.SPACE_TYPE_ID);
        
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
 *  添加 UIScrollView
 */

-(void)addUIScrollView{

    UIScrollView   *scrollView = [[UIScrollView alloc]init];
    
    CGFloat  scrollViewX = 20 ;
    CGFloat  scrollViewY = 70 ;
    CGFloat  scrollViewW = [UIScreen mainScreen].bounds.size.width - 40;
    CGFloat  scrollViewH = [UIScreen  mainScreen].bounds.size.height -130;
    scrollView.frame = CGRectMake(scrollViewX, scrollViewY, scrollViewW, scrollViewH);
    scrollView.backgroundColor = [UIColor  whiteColor];// [self  randomColor];
    self.scrollView = scrollView;
    
    NSInteger count = self.spaces.count;//实际的空间个数
    self.count = count;
    scrollView.contentSize = CGSizeMake(count *scrollView.width, 0);
    
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;//水平
    scrollView.delegate = self;
    scrollView.userInteractionEnabled = YES;
    self.scrollView = scrollView;
    scrollView.alwaysBounceVertical =NO;
    
    [self  addUICollectionView];
   
    self.automaticallyAdjustsScrollViewInsets = NO;
    //添加pageControl
    UIPageControl *pageControl = [[UIPageControl  alloc]init];
    
    pageControl.numberOfPages = count;
    
    pageControl.width = 200 ;
    pageControl.height = 10 ;
    //pageControl.backgroundColor = [UIColor  redColor];
    pageControl.centerX = scrollView.width * 0.5 + 25;
    pageControl.centerY = 60;//scrollView.height - 50 ;
    
    pageControl.currentPageIndicatorTintColor = [UIColor  redColor];
    pageControl.pageIndicatorTintColor = [UIColor  blackColor];
    pageControl.userInteractionEnabled = YES;
    
    [self.fullscreenView  addSubview:scrollView];
    [self.fullscreenView  addSubview:pageControl];
   
    self.pageControl = pageControl;
    
}

/**
 *  添加UICollectionView 控制器
 */
-(void)addUICollectionView{
  
    //添加布局方式
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    CGFloat  collectionViewX = 20 ;
    CGFloat  collectionViewY = 70 ;
    CGFloat  collectionViewW = [UIScreen mainScreen].bounds.size.width - 40;
    CGFloat  collectionViewH = [UIScreen  mainScreen].bounds.size.height -130;
    
    UICollectionView  *collectionView = [[UICollectionView  alloc]initWithFrame:CGRectMake(collectionViewX, collectionViewY, collectionViewW, collectionViewH) collectionViewLayout:flowLayout];
    collectionView.y = 0;
    collectionView.x = self.pageControl.currentPage * collectionView.width;
    collectionView.bounces = NO;//没有效果
    collectionView.dataSource=self;
    collectionView.delegate=self;
    collectionView.backgroundColor = [UIColor   whiteColor];
    collectionView.userInteractionEnabled = YES;
    
    [collectionView registerClass:[spaceDeviceCollectionViewCell class] forCellWithReuseIdentifier:string];
    
    self.collectionView = collectionView;
   
    [self.scrollView  addSubview:collectionView];
  
}
/**
 *  添加随机颜色
 *
 *  @return
 */
- (UIColor *) randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    
}

/**
 *  uiscrollview 的代理方法
 *
 *  @param scrollView
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
  
    
    double page = self.scrollView.contentOffset.x / scrollView.width;
    
    //四舍五入 计算页面
    self.pageControl.currentPage = (int)(page + 0.5);
    
    
    if (self.spaces.count == 0) {
        
        [MBProgressHUD  showMessage:@"请先添加空间"];
        
    }else {
    
        spaceMessageModel *space = self.spaces[self.pageControl.currentPage];
        self.navItem.title = [NSString   stringWithFormat:@"%@",space.space_Name];
        
        deviceSpaceMessageModel  *deviceSpace = [[deviceSpaceMessageModel   alloc]init];
        deviceSpace.space_no = space.space_Num;
        
        //计算当前加载的 页面有多少设备
        NSArray *deviceSpaceArray = [deviceSpaceMessageTool queryWithspacesDeviceNumbers:deviceSpace ];
        
        //从查出的设备中 选择出 只含门窗和开关、插座的的设备
        NSInteger deviceNumbers = 0;
        
        for (int i = 0; i < deviceSpaceArray.count; i ++) {
            
            deviceSpaceMessageModel  *devicespaceModel = deviceSpaceArray[i];
            
            deviceMessage *device = [[deviceMessage  alloc]init];
            
            device.DEVICE_NO = devicespaceModel.device_no;
            device.GATEWAY_NO = space.gateway_Num;
            
            NSArray *deviceArray = [deviceMessageTool  queryWithDeviceNumDevices:device];
            
            if (deviceArray.count!= 0 ) {
                
                deviceMessage *deviceMessage = deviceArray[0];
                
                if ((deviceMessage.DEVICE_GATEGORY_ID ==1)|(deviceMessage.DEVICE_GATEGORY_ID ==3)|(deviceMessage.DEVICE_GATEGORY_ID ==5)) {
                    
                    deviceNumbers ++;
                    
                }
            }
            
        }
        
        //此时计算出来的 deviceNumbers 就是当前页面 有包含的门窗插座 开关设备的个数
        self.deviceNumbers = deviceNumbers;
        self.deviceSpaceArray = deviceSpaceArray;
      

    }
   
    [MBProgressHUD  hideHUD];
   
}

/**
 *  停止滑动的时候 刷新 UICollectionView
 *
 *  @param scrollView
 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
   
    
    
    //self.scrollView.contentOffset.y  始终为0
    // self.scrollView.contentOffset.x 可能为0 也可能不为0
    
    [self  addUICollectionView];//这个地方有一个bug 待修复
    
}



//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   
 
    return [self  spacesDeviceList].count;
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    _cell = [collectionView dequeueReusableCellWithReuseIdentifier:string forIndexPath:indexPath];
   
    _cell.button1.hidden = NO;
    _cell.button2.hidden = NO;
    _cell.button3.hidden = NO;
    _cell.button4.hidden = NO;
    _cell.button5.hidden = NO;
    _cell.button6.hidden = NO;
    _cell.button7.hidden = NO;
    _cell.button8.hidden = NO;
    _cell.process.hidden = NO;
    _cell.button9.hidden = YES;
    _cell.button1.selected = NO;
    _cell.button2.selected = NO;
    _cell.button3.selected = NO;
    _cell.button4.selected = NO;
    _cell.button5.enabled = YES;
    _cell.button6.enabled = YES;
    _cell.button7.enabled = YES;
    _cell.button8.selected = NO;

    //先取出模型里的数据
     deviceMessage *device = [self  spacesDeviceList][indexPath.row];
  
    deviceSpaceMessageModel *deviceSpace = [[deviceSpaceMessageModel alloc]init];
    
    deviceSpace.device_no = device.DEVICE_NO;
    deviceSpace.phone_num = _dataCenter.userPhoneNum;
    
    NSArray *deviceSpaceAry = [deviceSpaceMessageTool queryWithspacesDeviceNoAndPhonenum:deviceSpace];
    
    if (deviceSpaceAry.count ==0) {
        
        _cell.messageLable.text =[NSString  stringWithFormat:@"  位置待定/%@",device.DEVICE_NAME];
        
    }else{
        
        deviceSpaceMessageModel *device_Name = deviceSpaceAry[0];
        
        spaceMessageModel *deviceNameModel = [[spaceMessageModel  alloc]init];
        
        deviceNameModel.space_Num = device_Name.space_no;
        
        spaceMessageModel *deviceName = [spaceMessageTool queryWithspacesDevicePostion:deviceNameModel][0];
        //显示设备位置和设备名称
        _cell.messageLable.text =[NSString  stringWithFormat:@"  %@/%@",deviceName.space_Name,device_Name.device_name];
        
    }
    
    //根据DEVICE_TYPE_ID显示开关个数
    switch (device.DEVICE_TYPE_ID  ) {
            
        case 1:
            _cell.process.hidden = YES;
            _cell.button1.hidden = YES;
            _cell.button2.hidden = YES;
            _cell.button3.hidden = YES;
            _cell.button5.hidden = YES;
            _cell.button6.hidden = YES;
            _cell.button7.hidden = YES;
            _cell.button8.hidden = YES;
            if ([device.DEVICE_STATE  isEqualToString:@"0"]) {
                
                _cell.button4.selected = YES;
                
            }
            
            break;
            
        case 2:
            
            if ([device.DEVICE_STATE  isEqualToString:@"00"]) {
                
                _cell.button3.selected = YES;
                _cell.button4.selected = YES;
                
                
            }
            
            if ([device.DEVICE_STATE  isEqualToString:@"10"]) {
                _cell.button4.selected = YES;
                
            }
            
            if ([device.DEVICE_STATE  isEqualToString:@"01"]) {
                _cell.button3.selected = YES;
                
            }
            
            _cell.button1.hidden = YES;
            _cell.button2.hidden = YES;
            _cell.button5.hidden = YES;
            _cell.button6.hidden = YES;
            _cell.button7.hidden = YES;
            _cell.button8.hidden = YES;
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
            
            if ([device.DEVICE_STATE  isEqualToString:@"000"]) {
                
                _cell.button2.selected = YES;
                _cell.button3.selected = YES;
                _cell.button4.selected = YES;
                
                
            }
            
            if ([device.DEVICE_STATE  isEqualToString:@"010"]) {
                _cell.button2.selected = YES;
                _cell.button4.selected = YES;
                
            }
            
            if ([device.DEVICE_STATE  isEqualToString:@"001"]) {
                _cell.button2.selected =YES;
                _cell.button3.selected = YES;
                
            }
            
            if ([device.DEVICE_STATE  isEqualToString:@"011"]) {
                
                _cell.button2.selected = YES;
                
                
            }
            _cell.process.hidden = YES;
            _cell.button1.hidden = YES;
            _cell.button5.hidden = YES;
            _cell.button6.hidden = YES;
            _cell.button7.hidden = YES;
            _cell.button8.hidden = YES;
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
            _cell.button5.hidden = YES;
            _cell.button6.hidden = YES;
            _cell.button7.hidden = YES;
            _cell.button8.hidden = YES;
            break;
            
        case 5:
            _cell.button1.hidden = YES;
            _cell.button2.hidden = YES;
            _cell.button3.hidden = YES;
            _cell.button4.hidden = YES;
            _cell.button5.hidden = YES;
            _cell.button6.hidden = YES;
            _cell.button7.hidden = YES;
            _cell.button8.hidden = YES;
            
            _cell.process.value = [device.DEVICE_STATE intValue];
            
            break;
        case 6:
            
            _cell.button1.hidden = YES;
            _cell.button2.hidden = YES;
            _cell.button3.hidden = YES;
            _cell.button4.hidden = YES;
            _cell.button8.hidden = YES;
            _cell.process.hidden = YES;

            if ([device.DEVICE_STATE  isEqualToString:@"00"]) {//暂停
                
                _cell.button6.enabled = NO;
                
            }
            if ([device.DEVICE_STATE  isEqualToString:@"01"]) {//关
                
                _cell.button7.enabled = NO;
                
                
            }
            
            if ([device.DEVICE_STATE  isEqualToString:@"10"]) {//开
                
                _cell.button5.enabled = NO;
                
            }
            
            break;
        case 11:
            
            _cell.button1.hidden = YES;
            _cell.button2.hidden = YES;
            _cell.button3.hidden = YES;
            _cell.button4.hidden = YES;
            _cell.button8.hidden = YES;
            _cell.process.hidden = YES;

            if ([device.DEVICE_STATE  isEqualToString:@"00"]) {//暂停
                
                _cell.button6.enabled = NO;
                
            }
            if ([device.DEVICE_STATE  isEqualToString:@"01"]) {//关
                
                _cell.button7.enabled = NO;
                
            }
            
            if ([device.DEVICE_STATE  isEqualToString:@"10"]) {//开
                
                _cell.button5.enabled = NO;
                
                
            }

            break;
        case 8:
             _cell.button1.hidden = YES;
             _cell.button2.hidden = YES;
             _cell.button3.hidden = YES;
             _cell.button4.hidden = YES;
             _cell.button5.hidden = YES;
             _cell.button6.hidden = YES;
             _cell.button7.hidden = YES;
             _cell.process.hidden = YES;

            if ([device.DEVICE_STATE  isEqualToString:@"0"]) {
                
                _cell.button8.selected = YES;
                
            }
            break;
    }
    
    //调用按钮监听方法
    [self  ListeningButtonMethod];

    return _cell;
    
}

/**
 *  监听按钮点击事件方法
 */
-(void)ListeningButtonMethod{
    
    //监听按钮点击事件
    [_cell.button1  addTarget:self action:@selector(enterChangeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_cell.button2  addTarget:self action:@selector(enterChangeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_cell.button3  addTarget:self action:@selector(enterChangeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_cell.button4  addTarget:self action:@selector(enterChangeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_cell.button5  addTarget:self action:@selector(enterChangeWindowsButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_cell.button6  addTarget:self action:@selector(enterChangeWindowsButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_cell.button7  addTarget:self action:@selector(enterChangeWindowsButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_cell.button8  addTarget:self action:@selector(enterChangeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_cell.process addTarget:self action:@selector(enterChangeProcess:) forControlEvents:UIControlEventValueChanged];
    
}
/**
 *  调光开关
 *
 *  @param
 */
-(void)enterChangeProcess:(UISlider *)pro{
    
    spaceDeviceCollectionViewCell *cell = (spaceDeviceCollectionViewCell *)[[[pro superview]superview]superview];//获取cell
    
    NSIndexPath *indexPathAll = [self.collectionView indexPathForCell:cell];//获取cell对应的section
    
    indexNum =indexPathAll.row;
    
    //取出当前cell的设备信息
    deviceMessage  *dev = [self  spacesDeviceList][indexNum];
    
    NSInteger process = pro.value;
    
    self.process = process;
    
    deviceMessage *state = [[deviceMessage  alloc]init];
    state.DEVICE_STATE = [NSString stringWithFormat:@"%ld",(long)process];
    state.DEVICE_NO = dev.DEVICE_NO;
    state.GATEWAY_NO = _dataCenter.gatewayNo;
  
    [deviceMessageTool  updateDeviceState:state];

    [self  switchOnTiaoguangAction];
   
    
}

/**
 *  外网控制设备发送报文 单独为调光
 */
-(void)switchOnTiaoguangAction {
    
    SocketManager *socket = [SocketManager  shareSocketManager];
    
    //取出当前cell的设备信息
    deviceMessage  *dev = [self  spacesDeviceList][indexNum];
    
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
   
    
    if (_dataCenter.networkStateFlag == 0) { //内网
        
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

/**
 *  按钮监听事件
 *
 *  @param btn
 */
-(void)enterChangeButton:(UIButton *)btn{
    
    spaceDeviceCollectionViewCell *cell = (spaceDeviceCollectionViewCell *)[[[btn superview]superview]superview];//获取cell

    NSIndexPath *indexPathAll = [self.collectionView indexPathForCell:cell];//获取cell对应的section

    indexNum =indexPathAll.row;
   
    //取出当前cell的设备信息
    deviceMessage  *dev = [self  spacesDeviceList][indexNum];
    
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
                    
                  
                    
                }
               
                break;
            case 100:
                if (btn.selected) {
                    
                    memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    
                   // NSLog(@"==设备状态表中的arry==%s====",arry);
                    
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
                    
                   // NSLog(@"%@",arr);
                    
                    
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
  
                   // NSLog(@"%@",arr);
                }
                
                break;
                
        }
        
    }
    
    if (dev.DEVICE_TYPE_ID == 8) {
        
        if (btn.selected) {
            
            //获取数据库中最新的设备状态，将它赋值给当前数组
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
            //将最新的设备状态更新到数据库
            [deviceMessageTool  updateDeviceState:state];
            
            
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
            
        }
        
    }

    
    [self   remoteSwitchOnAction];

    
  
}


/**
 *  门窗类开关
 *
 *  @param btn 
 */
- (void)enterChangeWindowsButton:(UIButton *)btn {
    
    spaceDeviceCollectionViewCell *cell = (spaceDeviceCollectionViewCell *)[[[btn superview]superview]superview];//获取cell
    
    NSIndexPath *indexPathAll = [self.collectionView indexPathForCell:cell];//获取cell对应的section
    
    indexNum =indexPathAll.row;
    
    //取出当前cell的设备信息
    deviceMessage  *dev = [self  spacesDeviceList][indexNum];
    //NSLog(@"%@",dev.DEVICE_NO);
    
    deviceMessage *state = [[deviceMessage  alloc]init];
    
    
    btn.enabled = !btn.enabled;
    if (dev.DEVICE_TYPE_ID ==6) {
        switch (btn.tag) {
                
            case 500:
                
                if (!btn.enabled) {
                    
                    
                    arry[0]='1';
                    arry[1]='0';
                    
                    UIButton *myButton1 = (UIButton *)[cell  viewWithTag:600];
                    
                    myButton1.enabled = YES;
                    UIButton *myButton2 = (UIButton *)[cell viewWithTag:700];
                    
                    
                    myButton2.enabled = YES;
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
                
            case 600:
                if (!btn.enabled) {
                    
                    arry[0]='0';
                    arry[1]='0';
                    UIButton *myButton1 = (UIButton *)[cell viewWithTag:500];
                    
                    myButton1.enabled = YES;
                    
                    
                    UIButton *myButton2 = (UIButton *)[cell viewWithTag:700];
                    myButton2.enabled = YES;
                    
                    NSString *arr1 =[self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 2)];
                    
                    self.arr = arr;
                    state.DEVICE_STATE = arr;
                    state.DEVICE_NO = dev.DEVICE_NO;
                    state.GATEWAY_NO = _dataCenter.gatewayNo;
                    [deviceMessageTool  updateDeviceState:state];
                    
                    //NSLog(@"%@",arr);
                    
                }
                
               
                break;
            case 700:
                if (!btn.enabled) {
                    
                    arry[0]='0';
                    arry[1]='1';
                    UIButton *myButton1 = (UIButton *)[cell viewWithTag:600];
                    
                    myButton1.enabled = YES;
                    
                    UIButton *myButton2 = (UIButton *)[cell viewWithTag:500];
                    
                    myButton2.enabled = YES;
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 2)];
                    
                    self.arr = arr;
                    state.DEVICE_STATE = arr;
                    state.DEVICE_NO = dev.DEVICE_NO;
                    state.GATEWAY_NO = _dataCenter.gatewayNo;
                    [deviceMessageTool  updateDeviceState:state];
                    
                }
               
                break;
                
        }
        
    }
    
    if (dev.DEVICE_TYPE_ID ==11) {
        switch (btn.tag) {
                
            case 500:
                
                if (!btn.enabled) {
                    
                    arry[0]='1';
                    arry[1]='0';
                    UIButton *myButton1 = (UIButton *)[cell  viewWithTag:600];
                    
                    myButton1.enabled = YES;
                    
                    UIButton *myButton2 = (UIButton *)[cell viewWithTag:700];
                    
                    
                    myButton2.enabled = YES;
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
                
            case 600:
                if (!btn.enabled) {
                    
                    arry[0]='0';
                    arry[1]='0';
                    UIButton *myButton1 = (UIButton *)[cell viewWithTag:500];
                    myButton1.enabled = YES;
                    UIButton *myButton2 = (UIButton *)[cell viewWithTag:700];
                    myButton2.enabled = YES;
                    NSString *arr1 =[self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 2)];
                    
                    self.arr = arr;
                    state.DEVICE_STATE = arr;
                    state.DEVICE_NO = dev.DEVICE_NO;
                    state.GATEWAY_NO = _dataCenter.gatewayNo;
                    [deviceMessageTool  updateDeviceState:state];
                    
                    //NSLog(@"%@",arr);
                    
                }
                
                break;
            case 700:
                if (!btn.enabled) {
                    
                    arry[0]='0';
                    arry[1]='1';
                    UIButton *myButton1 = (UIButton *)[cell viewWithTag:600];
                    
                    myButton1.enabled = YES;
                    UIButton *myButton2 = (UIButton *)[cell viewWithTag:500];
                    
                    myButton2.enabled = YES;
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 2)];
                    
                    self.arr = arr;
                    state.DEVICE_STATE = arr;
                    state.DEVICE_NO = dev.DEVICE_NO;
                    state.GATEWAY_NO = _dataCenter.gatewayNo;
                    [deviceMessageTool  updateDeviceState:state];
                    
                }
                
                break;
                
        }
        
    }
    
    
    [self   remoteSwitchOnAction];
        
   

}

/**
 *  控制设备发送报文
 */
-(void)remoteSwitchOnAction {
    
    SocketManager  *socket = [SocketManager  shareSocketManager];
    
    NSString *hex16;
    NSString *devType;
    NSString *datalen;

    //取出当前cell的设备信息
    deviceMessage  *dev = [self  spacesDeviceList][indexNum];
    
    //将int 型转换为byte型
    
    switch (dev.DEVICE_TYPE_ID) {
            
        case 6:
            
            hex16 = [ControlMethods  ToHex:dev.DEVICE_TYPE_ID];
            devType = [NSString  stringWithFormat:@"%@00",hex16];
            datalen = @"0002";
            
            break;
           
        case 8:
            hex16 = [ControlMethods  ToHex:dev.DEVICE_TYPE_ID];
            devType = [NSString  stringWithFormat:@"%@00",hex16];
            datalen = @"0001";
            break;
        case 11:
            hex16 = [ControlMethods  ToHex:dev.DEVICE_TYPE_ID];
            devType = [NSString  stringWithFormat:@"%@00",hex16];
            datalen = @"0002";
            break;
        default:
            
            hex16 = [ControlMethods  ToHex:dev.DEVICE_TYPE_ID];
            devType = [NSString  stringWithFormat:@"%@00",hex16];
            datalen = [NSString  stringWithFormat:@"00%@",hex16];
            break;
    }
    
    //拆报文
    NSString *head = @"42424141";
    
    NSString *stamp = @"00000000";
    
    NSString *gw_id = _dataCenter.gatewayNo;
    
    NSString *dev_id = dev.DEVICE_NO;
    
    NSString *dev_type = devType;
    
    NSString *data_type = @"0200";
    
    NSString *data_len = datalen;
    
    NSString *data =[ControlMethods  transCoding:self.arr];
    
    //拼接发送报文
    NSString *packet = [PacketMethods  devicePacket:head getStamp:stamp getGw_id:gw_id getDev_id:dev_id getDev_type:dev_type getData_type:data_type getData_len:data_len getData:data];
    
    
    NSString *deviceControlPacketStr = [packet stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
    
    if (_dataCenter.networkStateFlag == 0) {//内网
        
        NSString *localControlMessage = [deviceControlPacketStr  stringByReplacingCharactersInRange:NSMakeRange(0, 8) withString:@"41414444"];
        //打印报文
        NSLog(@"==内网localControlMessage is %@==",localControlMessage);
        
        [socket  sendMsg:localControlMessage];
        
    }else{
    
        //打印报文
        NSLog(@"==外网deviceControlPacketStr is %@==",deviceControlPacketStr);
        
        //发送报文到对应设备
        [ControlMethods  controlDeviceHTTPmethods:deviceControlPacketStr];
        
    }
    
   
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
 *  返回当前空间设备的 所有信息
 *
 *  @return
 */

-(NSArray *)spacesDeviceList{
    
    deviceMessage *device = [[deviceMessage alloc]init];
    device.GATEWAY_NO = _dataCenter.gatewayNo;
    NSArray* devicess;
    devicess=[deviceMessageTool queryWithSpaceDevices:device];
    NSLog(@" = %lu",(unsigned long)self.deviceSpaceArray.count);
    NSMutableArray  *deviceArray = [NSMutableArray  array];
    
    for (int  i = 0; i < self.deviceSpaceArray.count; i ++) {
      
        deviceSpaceMessageModel  *devicespaceModel = self.deviceSpaceArray[i];
        
        for (int j = 0; j < devicess.count; j ++) {//self.devices.count
            
            deviceMessage *devices =devicess[j];
            
            if (([devicespaceModel.device_no isEqualToString:devices.DEVICE_NO])&(devices.DEVICE_TYPE_ID !=105)) {
                
                deviceMessage *dev = [[deviceMessage  alloc]init];
                
                dev.DEVICE_GATEGORY_ID  = devices.DEVICE_GATEGORY_ID;
                
                dev.DEVICE_GATEGORY_NAME = devices.DEVICE_GATEGORY_NAME;
                
                dev.DEVICE_NAME = devices.DEVICE_NAME;
                
                dev.DEVICE_STATE = devices.DEVICE_STATE;
                
                dev.DEVICE_NO = devices.DEVICE_NO;
                
                dev.DEVICE_TYPE_ID = devices.DEVICE_TYPE_ID;
                
                dev.DEVICE_TYPE_NAME = devices.DEVICE_TYPE_NAME;
                
                dev.GATEWAY_NO = devices.GATEWAY_NO;
                
                dev.PHONE_NUM = devices.PHONE_NUM;
                
                dev.SPACE_NO = devices.SPACE_NO;
                
                dev.SPACE_TYPE_ID = devices.SPACE_TYPE_ID;
                
                [deviceArray   addObject:dev];
            }
        }
        
    }
    for (int i =0; i<deviceArray.count; i++) {
        deviceMessage *device = deviceArray[i];
        NSLog(@"%@ %@ %ld",device.DEVICE_NAME,device.DEVICE_NO,(long)device.DEVICE_TYPE_ID);
        
    }
    return deviceArray;

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
    CGFloat  WhiteBackgroundLableY = 50 ;
    CGFloat  WhiteBackgroundLableW = [UIScreen mainScreen].bounds.size.width - 40;
    CGFloat  WhiteBackgroundLableH = [UIScreen  mainScreen].bounds.size.height -110;
    WhiteBackgroundLable.frame = CGRectMake(WhiteBackgroundLableX, WhiteBackgroundLableY, WhiteBackgroundLableW, WhiteBackgroundLableH);
 
    WhiteBackgroundLable.backgroundColor = [UIColor  whiteColor];
   
    //WhiteBackgroundLable.backgroundColor = [UIColor redColor];
    //WhiteBackgroundLable.clipsToBounds = YES;
   // WhiteBackgroundLable.layer.cornerRadius = 8.0;//设置边框圆角
    self.WhiteBackgroundLable = WhiteBackgroundLable;

    [self.fullscreenView addSubview:WhiteBackgroundLable];
    
}


/**
 *设置导航栏
 */
-(void)setNavBar{

    NSString *title;
    CGFloat navBarW = [UIScreen  mainScreen].bounds.size.width;
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0,navBarW, 40)];
 
    if (self.spaces.count == 0) {
        
        title = [NSString  stringWithFormat:@"空间"];
        
    }else{
    
        spaceMessageModel  *spaces = self.spaces[0];
        title = [NSString  stringWithFormat:@"%@",spaces.space_Name];
        
    }
    
    //创建一个导航栏集合
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:title];
    
    self.navItem= navItem;
    
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
    self.alert = alert;
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

-(BOOL)shouldAutorotate{
    return YES;
}



-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}


@end
