//
//  microViewController.m
//  HomeCOO
//
//  Created by tgbus on 16/7/8.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "microViewController.h"
#import "AppDelegate.h"
#import "SystemViewController.h"
#import "SpaceViewController.h"
#import "ThemeViewController.h"
#import "SecurityViewController.h"
#import "SettingViewController.h"
#import "MethodClass.h"
#import "LZXDataCenter.h"
#import "ThemeAdministrationController.h"
#import "linkageController.h"
#import "themeMicroView.h"
#import "deviceMessage.h"
#import "deviceMessageTool.h"
#import "deviceSpaceMessageModel.h"
#import "deviceSpaceMessageTool.h"
#import "themeDeviceMessage.h"
#import "themeDeviceMessageTool.h"
#import "spaceMessageModel.h"
#import "spaceMessageTool.h"
#import "ControlMethods.h"
#import "PacketMethods.h"
#import "SocketManager.h"
#import "MBProgressHUD+MJ.h"
#import "PrefixHeader.pch"
#import "gatewayMessageModel.h"
#import "gatewayMessageTool.h"

//底部空间、情景模式等按钮的高度
#define HOMECOOSPACEBUTTONHEIGHT 60

//底部空间、情景模式等按钮的宽度
#define HOMECOOSPACEBUTTONWIDTH [UIScreen  mainScreen].bounds.size.width / 5

//底部空间、情景模式等按钮Y的大小
#define  HOMECOOSPACEBUTTON_Y  [UIScreen  mainScreen].bounds.size.height - 55

//底部空间、情景模式等按钮字体的大小
#define HOMESPACEFONT 13

@interface microViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

/**设置背景图片*/
@property(nonatomic,weak)  UIImageView  * fullscreenView;

/**设置导航栏*/
@property(nonatomic,weak)  UINavigationBar *navBar;

@property (weak, nonatomic)  UICollectionView *collectionView;

@property(nonatomic,strong)  NSArray *devices;

@property(nonatomic,weak) themeMicroView *cell;

@property(nonatomic,strong) NSString *arr;

@property(nonatomic,strong) LZXDataCenter *dataCenter;
@property(nonatomic,strong) themeDeviceMessage *fonudDevice;
@property(nonatomic,strong) deviceMessage *devicess;


@end

static NSString *string = @"themeMicroView";

static NSInteger   indexNum;

static char  arry[2] = {'0','0'};

@implementation microViewController
-(NSArray *)devices
{
    if (_devices==nil) {
        
        LZXDataCenter *gateway = [LZXDataCenter defaultDataCenter];
        
        if ([gateway.gatewayNo isEqualToString:@"0"] | !gateway.gatewayNo ) {
            
            
        }else{
            
            deviceMessage *device = [[deviceMessage alloc]init];
            device.GATEWAY_NO = gateway.gatewayNo;
            _devices=[deviceMessageTool queryWithSensorsDevices:device];
            
        }
              
        
    }
    
    return _devices;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //设置背景
    [self setFullscreenView];
    
    //设置背景底色
    [self  setWhiteBackground];
    
    LZXDataCenter *dataCenter = [LZXDataCenter defaultDataCenter];
    
    self.dataCenter = dataCenter;
    
    //添加aUICollectionView
    [self  addUICollectionView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

}

/**
 *  添加UICollectionView
 */
-(void)addUICollectionView{
    CGFloat  collectionViewX = 10 ;
    CGFloat  collectionViewY = 60 ;
    CGFloat  collectionViewW = [UIScreen mainScreen].bounds.size.width - 20;
    CGFloat  collectionViewH = [UIScreen  mainScreen].bounds.size.height -130;
    //确定是水平滚动，还是垂直滚动
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    UICollectionView  *collectionView = [[UICollectionView  alloc]initWithFrame:CGRectMake(collectionViewX, collectionViewY, collectionViewW, collectionViewH) collectionViewLayout:flowLayout];
    
    collectionView.bounces = NO;//没有效果
    
    collectionView.dataSource=self;
    collectionView.delegate=self;
    collectionView.backgroundColor = [UIColor  whiteColor];
    
    [collectionView registerClass:[themeMicroView class] forCellWithReuseIdentifier:string];
    
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
    
    
    
    return  self.devices.count;
    
}


/**
 *  代理
 *
 *  @param collectionView
 *  @param indexPath
 *
 *  @return
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    _cell = [collectionView dequeueReusableCellWithReuseIdentifier:string forIndexPath:indexPath];
    
    _cell.button4.hidden = NO;
    _cell.button5.hidden = NO;
    
    _cell.button4.selected = NO;
    _cell.button5.selected = NO;
    
    if (!_fonudDevice) {
       
        _fonudDevice = [[themeDeviceMessage  alloc]init];
        
    }
    
    _fonudDevice.theme_no = _dataCenter.theme_No;
    
    NSArray * foundDeviceArrar;
    
    if (!_devicess) {
        
        _devicess = [[deviceMessage alloc]init];
    }
    
    _devicess.GATEWAY_NO = _dataCenter.gatewayNo;
   
    deviceMessage *device = [deviceMessageTool queryWithSensorsDevices:_devicess][indexPath.row];
    
    deviceSpaceMessageModel *deviceSpace = [[deviceSpaceMessageModel alloc]init];
    
    deviceSpace.device_no = device.DEVICE_NO;
    deviceSpace.phone_num = _dataCenter.userPhoneNum;
    NSArray *deviceSpaceArry = [deviceSpaceMessageTool queryWithspacesDeviceNoAndPhonenum:deviceSpace];

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
        case 110:
            
            _fonudDevice.device_No = device.DEVICE_NO;
            
            foundDeviceArrar = [themeDeviceMessageTool queryWithThemeDevices:_fonudDevice];
            
            if (foundDeviceArrar.count ==0) {
                
                _cell.button5.selected = YES;
                
                if ([[device.DEVICE_STATE substringToIndex:2]  isEqualToString:@"00"]|[[device.DEVICE_STATE substringToIndex:2]  isEqualToString:@"10"]) {
                    
                    _cell.button4.selected = YES;
                    
                }
                
            }else{
                
                themeDeviceMessage  *themeDevice = foundDeviceArrar[0];
                
                if ([[themeDevice.device_state_cmd substringToIndex:2] isEqualToString:@"10"]|[[themeDevice.device_state_cmd substringToIndex:2] isEqualToString:@"00"]) {
                    
                     _cell.button4.selected = YES;
                }
                
            }

            break;
        case 113:
            
            _fonudDevice.device_No = device.DEVICE_NO;
            
            foundDeviceArrar = [themeDeviceMessageTool queryWithThemeDevices:_fonudDevice];
            if (foundDeviceArrar.count ==0) {
                
                 _cell.button5.selected = YES;
                
                if ([[device.DEVICE_STATE substringToIndex:2] isEqualToString:@"10"]|[[device.DEVICE_STATE substringToIndex:2] isEqualToString:@"00"]) {
                    
                    _cell.button4.selected = YES;
                    
                }
                
            }else{
                
                themeDeviceMessage  *themeDevice = foundDeviceArrar[0];
                
                if ([[themeDevice.device_state_cmd substringToIndex:2] isEqualToString:@"10"]|[[themeDevice.device_state_cmd substringToIndex:2] isEqualToString:@"00"]) {
                    
                    _cell.button4.selected = YES;
                    
                }
                
            }

            break;
            
        case 115:
            
            _fonudDevice.device_No = device.DEVICE_NO;
            
            foundDeviceArrar = [themeDeviceMessageTool queryWithThemeDevices:_fonudDevice];
            if (foundDeviceArrar.count ==0) {
                
                _cell.button5.selected = YES;
                
                if ([[device.DEVICE_STATE substringToIndex:2] isEqualToString:@"10"]|[[device.DEVICE_STATE substringToIndex:2] isEqualToString:@"00"]) {
                    
                    _cell.button4.selected = YES;
                    
                }
                
            }else{
                
                themeDeviceMessage  *themeDevice = foundDeviceArrar[0];
                
                if ([[themeDevice.device_state_cmd substringToIndex:2]  isEqualToString:@"10"]| [[themeDevice.device_state_cmd substringToIndex:2]  isEqualToString:@"00"]) {
                    
                   _cell.button4.selected = YES;
                    
                }
                
            }

            break;
            
        case 118:
            
            _fonudDevice.device_No = device.DEVICE_NO;
            
            foundDeviceArrar = [themeDeviceMessageTool queryWithThemeDevices:_fonudDevice];
            if (foundDeviceArrar.count ==0) {
                
                _cell.button5.selected = YES;
                
                if ([[device.DEVICE_STATE substringToIndex:2] isEqualToString:@"10"]|[[device.DEVICE_STATE substringToIndex:2] isEqualToString:@"00"]) {
                    
                    _cell.button4.selected = YES;
                    
                }
                
            }else{
            
                themeDeviceMessage  *themeDevice = foundDeviceArrar[0];
                
                if ([[themeDevice.device_state_cmd substringToIndex:2] isEqualToString:@"10"]|[[themeDevice.device_state_cmd substringToIndex:2] isEqualToString:@"00"]) {
                    
                    _cell.button4.selected = YES;
                }
                
            }

            break;
            
        case 51:
            
            _fonudDevice.device_No = device.DEVICE_NO;
            
            foundDeviceArrar = [themeDeviceMessageTool queryWithThemeDevices:_fonudDevice];
            if (foundDeviceArrar.count ==0) {
                
                 _cell.button5.selected = YES;
                
                if ([device.DEVICE_STATE  isEqualToString:@"0"]) {
                    
                    _cell.button4.selected = YES;
                    
                }
                
            }else{
                
                themeDeviceMessage  *themeDevice = foundDeviceArrar[0];
                
                if ([themeDevice.device_state_cmd  isEqualToString:@"0"]) {
                    
                    _cell.button4.selected = YES;
                    
                }
                
            }

        break;
    }
    //显示设备位置和设备名称
    //监听按钮点击事件
    [_cell.button4  addTarget:self action:@selector(enterChangeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_cell.button5  addTarget:self action:@selector(checkBox:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return _cell;
}

/**
 *  通过对号 查看是否在themedevice表中有次设备
 *
 *  @param btn
 */
- (void)checkBox:(UIButton *)btn {
    
    
    themeMicroView *cell = (themeMicroView *)[[[btn superview]superview]superview];//获取cell
    
    NSIndexPath *indexPathAll = [self.collectionView indexPathForCell:cell];//获取cell对应的section
    
    indexNum =indexPathAll.row;
    
    NSArray  *devices;
    
    deviceMessage *device = [[deviceMessage alloc]init];
    device.GATEWAY_NO = _dataCenter.gatewayNo;
    devices=[deviceMessageTool queryWithSensorsDevices:device];
        
   
    deviceMessage  *dev = devices[indexNum];
    
    //更新设备状态
    //themeDeviceMessage *states = [[themeDeviceMessage  alloc]init];
    //根据设备在themedevice表中查找，是否有次设备添加成功
    
    themeDeviceMessage *fonudDevice = [[themeDeviceMessage  alloc]init];
    
    fonudDevice.device_No = dev.DEVICE_NO;
    
    fonudDevice.theme_no = _dataCenter.theme_No;
    
    //NSLog(@"fonudDevice.theme_no = %@",fonudDevice.theme_no);
    
    themeDeviceMessage *deletDevice = [[themeDeviceMessage  alloc]init];
    
    deletDevice.device_No = dev.DEVICE_NO;
    
    deletDevice.theme_no = _dataCenter.theme_No;
    
    
    
    NSArray * foundDeviceArrar = [themeDeviceMessageTool queryWithThemeDevices:fonudDevice];
    //像themedevice表中插入新的设备
    themeDeviceMessage  *themeDevice = [[themeDeviceMessage  alloc]init];
    
    themeDevice.device_No = dev.DEVICE_NO;
    themeDevice.device_state_cmd =
    themeDevice.gateway_No = _dataCenter.gateway_No;
    themeDevice.theme_no = _dataCenter.theme_No;
    themeDevice.theme_device_No = _dataCenter.device_No;
    themeDevice.theme_state = _dataCenter.theme_State;
    themeDevice.theme_type = _dataCenter.theme_Type;
    themeDevice.device_state_cmd =dev.DEVICE_STATE ;
    //themeDevice.infra_type_ID = ;
    
    NSLog(@"%@ %@ %@ %@ %@ %ld ",themeDevice.device_No,themeDevice.gateway_No, themeDevice.theme_no,themeDevice.theme_device_No,themeDevice.theme_state,(long)themeDevice.theme_type);
    
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        
        if (foundDeviceArrar.count == 0) {//没有找到此设备
            
            //添加新设备
            
            [themeDeviceMessageTool  addThemeDevice:themeDevice];
            
        }else{//如果找到此设备
            
            [themeDeviceMessageTool  deleteThemeDevice:deletDevice];
            
        }
        
        NSLog(@"=======选中======");
        
    }else{
        
        if (foundDeviceArrar.count == 0) {
            
            //添加新设备
            [themeDeviceMessageTool  addThemeDevice:themeDevice];
        }else{
            
            
            [themeDeviceMessageTool  deleteThemeDevice:deletDevice];
        }
        
        NSLog(@"=======未选中======");
        
    }
    
    //刷新数据
    [_collectionView  reloadData];
    
}

/**
 *  按钮监听事件
 *
 *  @param btn 点击的是哪个
 */
- (void)enterChangeButton:(UIButton *)btn {
    
    themeMicroView *cell = (themeMicroView *)[[[btn superview]superview]superview];//获取cell
    
    NSIndexPath *indexPathAll = [self.collectionView indexPathForCell:cell];//获取cell对应的section
    
    indexNum =indexPathAll.row;
    
    NSArray  *devices ;
    
    deviceMessage *device = [[deviceMessage alloc]init];
    device.GATEWAY_NO = _dataCenter.gatewayNo;
    devices=[deviceMessageTool queryWithSensorsDevices:device];
        
    
   
    //取出当前cell的设备信息
    deviceMessage  *dev = devices[indexNum];
    
    //NSLog(@"%@",dev.DEVICE_NO);
    //根据设备在themedevice表中查找，是否有次设备添加成功
    themeDeviceMessage *fonudDevice = [[themeDeviceMessage  alloc]init];
    
    fonudDevice.device_No = dev.DEVICE_NO;
    
    fonudDevice.theme_no = _dataCenter.theme_No;
    
    //NSLog(@"fonudDevice.theme_no = %@",fonudDevice.theme_no);
    
    NSArray * foundDeviceArrar = [themeDeviceMessageTool queryWithThemeDevices:fonudDevice];
    
    
    
    //更新设备状态
    themeDeviceMessage *states = [[themeDeviceMessage  alloc]init];
    
    //像themedevice表中插入新的设备
    themeDeviceMessage  *themeDevice = [[themeDeviceMessage  alloc]init];
    
    themeDevice.device_No = dev.DEVICE_NO;
    themeDevice.device_state_cmd =
    themeDevice.gateway_No = _dataCenter.gateway_No;
    themeDevice.theme_no = _dataCenter.theme_No;
    themeDevice.theme_device_No = _dataCenter.device_No;
    themeDevice.theme_state = _dataCenter.theme_State;
    themeDevice.theme_type = _dataCenter.theme_Type;
    //themeDevice.infra_type_ID = ;
    
    NSLog(@"%@ %@ %@ %@ %@ %ld ",themeDevice.device_No,themeDevice.gateway_No, themeDevice.theme_no,themeDevice.theme_device_No,themeDevice.theme_state,(long)themeDevice.theme_type);
    
    
    //NSLog(@"%@",dev.DEVICE_STATE);
    
    btn.selected = !btn.selected;
    
    switch (dev.DEVICE_TYPE_ID) {
            case 51:
   
                if (btn.selected) {
               
            
                
                //获取数据库中最新的设备状态，将它赋值给当前数组
                if (foundDeviceArrar.count == 0) {
                    
                    memcpy(arry, [[dev.DEVICE_STATE substringToIndex:1] cStringUsingEncoding:NSASCIIStringEncoding],1);
                    
                }else{
                    
                    themeDeviceMessage *theme = foundDeviceArrar[0];
                    memcpy(arry, [[theme.device_state_cmd  substringToIndex:1] cStringUsingEncoding:NSASCIIStringEncoding],1);
                }
                
                
                if (arry[0] == '1') {
                    
                    arry[0] = '0';
                }
                else{
                    
                    arry[0] = '1';
                    
                }
                
                NSString *arr1 = [self  transArryToStr:arry];
                NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 1)];
                self.arr = arr;
                if (foundDeviceArrar.count == 0) {//没有找到此设备
                    
                    //添加新设备
                    themeDevice.device_state_cmd = arr;
                    [themeDeviceMessageTool  addThemeDevice:themeDevice];
                    
                }else{//已经有此设备 则更新设备状态
                    
                    themeDeviceMessage *theme = foundDeviceArrar[0];
                    
                    states.device_state_cmd = arr;
                    states.device_No = theme.device_No;
                    states.theme_no = _dataCenter.theme_No;
                    NSLog(@"selected =  %@",states.device_state_cmd);
                    
                    [themeDeviceMessageTool  updateThemeDeviceState:states];
                    
                    
                }
                
                    
            }else{
                
                if (foundDeviceArrar.count == 0) {
                    
                    memcpy(arry, [[dev.DEVICE_STATE  substringToIndex:1] cStringUsingEncoding:NSASCIIStringEncoding],1);
                    
                }else{
                    
                    themeDeviceMessage *theme = foundDeviceArrar[0];
                    memcpy(arry, [[theme.device_state_cmd substringToIndex:1] cStringUsingEncoding:NSASCIIStringEncoding],1);
                }
                
                
                if (arry[0] == '0') {
                    
                    arry[0] = '1';
                    
                }
                
                else{
                    
                    arry[0] = '0';
                    
                }
                
                NSString *arr1 = [self  transArryToStr:arry];
                NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 1)];
                self.arr = arr;
                
                if (foundDeviceArrar.count == 0) {//没有找到此设备
                    
                    //添加新设备
                    themeDevice.device_state_cmd = arr;
                    [themeDeviceMessageTool  addThemeDevice:themeDevice];
                    
                }else{//已经有此设备 则更新设备状态
                    
                    themeDeviceMessage *theme = foundDeviceArrar[0];
                    
                    states.device_state_cmd = arr;
                    states.device_No = theme.device_No;
                    states.theme_no = _dataCenter.theme_No;
                    NSLog(@"selected =  %@",states.device_state_cmd);
                    [themeDeviceMessageTool  updateThemeDeviceState:states];
                    
                }
                
            }
  
        break;
            
    case 110:
            if (btn.selected) {
                
                //获取数据库中最新的设备状态，将它赋值给当前数组
                if (foundDeviceArrar.count == 0) {
                    
                    memcpy(arry, [[dev.DEVICE_STATE substringToIndex:2] cStringUsingEncoding:NSASCIIStringEncoding],2);
                    
                }else{
                    
                    themeDeviceMessage *theme = foundDeviceArrar[0];
                    memcpy(arry, [[theme.device_state_cmd substringToIndex:2] cStringUsingEncoding:NSASCIIStringEncoding],2);
                }
 
                if (arry[0]=='0' & arry[1]=='0') {
                    arry[0] = '1';
                    arry[1] ='0';
                }else if (arry[0]=='0' & arry[1]=='1') {
                    arry[0] = '1';
                    arry[1] ='0';
                }else if (arry[0]=='1' & arry[1]=='1') {
                    arry[0] = '1';
                    arry[1] ='0';
                }else if (arry[0]=='1' & arry[1]=='0') {
                    arry[0] = '1';
                    arry[1] ='1';
                }
                
                NSString *arr1 = [self  transArryToStr:arry];
                NSString *arr = [arr1  stringByAppendingString:@"000000"];
                self.arr = arr;
                if (foundDeviceArrar.count == 0) {//没有找到此设备
                    
                    //添加新设备
                    themeDevice.device_state_cmd = arr;
                    [themeDeviceMessageTool  addThemeDevice:themeDevice];
                    
                }else{//已经有此设备 则更新设备状态
                    
                    themeDeviceMessage *theme = foundDeviceArrar[0];
                    
                    states.device_state_cmd = arr;
                    states.device_No = theme.device_No;
                    states.theme_no = _dataCenter.theme_No;
                    NSLog(@"selected =  %@",states.device_state_cmd);
                    
                    [themeDeviceMessageTool  updateThemeDeviceState:states];
                    
                    
                }
                
                
            }else{
                
                if (foundDeviceArrar.count == 0) {
                    
                    memcpy(arry, [[dev.DEVICE_STATE substringToIndex:2] cStringUsingEncoding:NSASCIIStringEncoding],2);
                    
                }else{
                    
                    themeDeviceMessage *theme = foundDeviceArrar[0];
                    memcpy(arry, [[theme.device_state_cmd substringToIndex:2] cStringUsingEncoding:NSASCIIStringEncoding],2);
                }
                
                if (arry[0]=='0' & arry[1]=='0') {
                    arry[0] = '1';
                    arry[1] ='0';
                }else if (arry[0]=='0' & arry[1]=='1') {
                    arry[0] = '1';
                    arry[1] ='0';
                }else if (arry[0]=='1' & arry[1]=='1') {
                    arry[0] = '1';
                    arry[1] ='0';
                }else if (arry[0]=='1' & arry[1]=='0') {
                    arry[0] = '1';
                    arry[1] ='1';
                }
                
                NSString *arr1 = [self  transArryToStr:arry];
                NSString *arr = [arr1  stringByAppendingString:@"000000"];
                self.arr = arr;
                
                if (foundDeviceArrar.count == 0) {//没有找到此设备
                    
                    //添加新设备
                    themeDevice.device_state_cmd = arr;
                    [themeDeviceMessageTool  addThemeDevice:themeDevice];
                    
                }else{//已经有此设备 则更新设备状态
                    
                    themeDeviceMessage *theme = foundDeviceArrar[0];
                    
                    states.device_state_cmd = arr;
                    states.device_No = theme.device_No;
                    states.theme_no = _dataCenter.theme_No;
                    NSLog(@"selected =  %@",states.device_state_cmd);
                    [themeDeviceMessageTool  updateThemeDeviceState:states];
                    
                    
                }
                
                
            }
            
            break;
            
        case 113:
            if (btn.selected) {
                
                //获取数据库中最新的设备状态，将它赋值给当前数组
                if (foundDeviceArrar.count == 0) {
                    
                    memcpy(arry, [[dev.DEVICE_STATE substringToIndex:2] cStringUsingEncoding:NSASCIIStringEncoding],2);
                    
                }else{
                    
                    themeDeviceMessage *theme = foundDeviceArrar[0];
                    memcpy(arry, [[theme.device_state_cmd substringToIndex:2] cStringUsingEncoding:NSASCIIStringEncoding],2);
                }
                
                if (arry[0]=='0' & arry[1]=='0') {
                    arry[0] = '1';
                    arry[1] ='0';
                }else if (arry[0]=='0' & arry[1]=='1') {
                    arry[0] = '1';
                    arry[1] ='0';
                }else if (arry[0]=='1' & arry[1]=='1') {
                    arry[0] = '1';
                    arry[1] ='0';
                }else if (arry[0]=='1' & arry[1]=='0') {
                    arry[0] = '1';
                    arry[1] ='1';
                }
                
                NSString *arr1 = [self  transArryToStr:arry];
                NSString *arr = [arr1  stringByAppendingString:@"000000"];
                self.arr = arr;
                if (foundDeviceArrar.count == 0) {//没有找到此设备
                    
                    //添加新设备
                    themeDevice.device_state_cmd = arr;
                    [themeDeviceMessageTool  addThemeDevice:themeDevice];
                    
                }else{//已经有此设备 则更新设备状态
                    
                    themeDeviceMessage *theme = foundDeviceArrar[0];
                    
                    states.device_state_cmd = arr;
                    states.device_No = theme.device_No;
                    states.theme_no = _dataCenter.theme_No;
                    NSLog(@"selected =  %@",states.device_state_cmd);
                    
                    [themeDeviceMessageTool  updateThemeDeviceState:states];
                    
                }
                
                
            }else{
                
                if (foundDeviceArrar.count == 0) {
                    
                    memcpy(arry, [[dev.DEVICE_STATE substringToIndex:2] cStringUsingEncoding:NSASCIIStringEncoding],2);
                    
                }else{
                    
                    themeDeviceMessage *theme = foundDeviceArrar[0];
                    memcpy(arry, [[theme.device_state_cmd substringToIndex:2] cStringUsingEncoding:NSASCIIStringEncoding],2);
                }

                if (arry[0]=='0' & arry[1]=='0') {
                    arry[0] = '1';
                    arry[1] ='0';
                }else if (arry[0]=='0' & arry[1]=='1') {
                    arry[0] = '1';
                    arry[1] ='0';
                }else if (arry[0]=='1' & arry[1]=='1') {
                    arry[0] = '1';
                    arry[1] ='0';
                }else if (arry[0]=='1' & arry[1]=='0') {
                    arry[0] = '1';
                    arry[1] ='1';
                }
                
                NSString *arr1 = [self  transArryToStr:arry];
                NSString *arr = [arr1  stringByAppendingString:@"000000"];
                self.arr = arr;
                
                if (foundDeviceArrar.count == 0) {//没有找到此设备
                    
                    //添加新设备
                    themeDevice.device_state_cmd = arr;
                    [themeDeviceMessageTool  addThemeDevice:themeDevice];
                    
                }else{//已经有此设备 则更新设备状态
                    
                    themeDeviceMessage *theme = foundDeviceArrar[0];
                    
                    states.device_state_cmd = arr;
                    states.device_No = theme.device_No;
                    states.theme_no = _dataCenter.theme_No;
                    NSLog(@"selected =  %@",states.device_state_cmd);
                    [themeDeviceMessageTool  updateThemeDeviceState:states];
                    
                    
                }
                
                
            }
            
            break;
        case 115:
            if (btn.selected) {
                
                
                
                //获取数据库中最新的设备状态，将它赋值给当前数组
                if (foundDeviceArrar.count == 0) {
                    // NSLog(@" selected情景表中不存在 需要从设备表中 获取状态");
                    memcpy(arry, [[dev.DEVICE_STATE substringToIndex:2] cStringUsingEncoding:NSASCIIStringEncoding],2);
                    
                }else{
                    
                   // NSLog(@"selected情景表中存在 直接从情景表中 获取状态");
                    themeDeviceMessage *theme = foundDeviceArrar[0];
                    memcpy(arry, [[theme.device_state_cmd substringToIndex:2] cStringUsingEncoding:NSASCIIStringEncoding],2);
                }
                

                if (arry[0]=='0' & arry[1]=='0') {
                    arry[0] = '1';
                    arry[1] ='0';
                }else if (arry[0]=='0' & arry[1]=='1') {
                    arry[0] = '1';
                    arry[1] ='0';
                }else if (arry[0]=='1' & arry[1]=='1') {
                    arry[0] = '1';
                    arry[1] ='0';
                }else if (arry[0]=='1' & arry[1]=='0') {
                    arry[0] = '1';
                    arry[1] ='1';
                }


                
                NSString *arr1 = [self  transArryToStr:arry];
                NSString *arr = [arr1  stringByAppendingString:@"000000"];
                self.arr = arr;
                if (foundDeviceArrar.count == 0) {//没有找到此设备
                    
                    //添加新设备
                    themeDevice.device_state_cmd = arr;
                    [themeDeviceMessageTool  addThemeDevice:themeDevice];
                    // NSLog(@"情景表中没有 添加 selected =  %@",states.device_state_cmd);
                }else{//已经有此设备 则更新设备状态
                    
                    themeDeviceMessage *theme = foundDeviceArrar[0];
                    
                    states.device_state_cmd = arr;
                    states.device_No = theme.device_No;
                    states.theme_no = _dataCenter.theme_No;
                   // NSLog(@"情景表中有 更新selected =  %@",states.device_state_cmd);
                    
                    [themeDeviceMessageTool  updateThemeDeviceState:states];
                    
                    
                }
                
                
            }else{
                
                if (foundDeviceArrar.count == 0) {
                    // NSLog(@" disselected情景表中不存在 需要从设备表中 获取状态");
                    memcpy(arry, [[dev.DEVICE_STATE substringToIndex:2] cStringUsingEncoding:NSASCIIStringEncoding],2);
                    
                }else{
                    // NSLog(@"selected情景表中存在 直接从情景表中 获取状态");
                    themeDeviceMessage *theme = foundDeviceArrar[0];
                    memcpy(arry, [[theme.device_state_cmd substringToIndex:2] cStringUsingEncoding:NSASCIIStringEncoding],2);
                }

                if (arry[0]=='0' & arry[1]=='0') {
                    arry[0] = '1';
                    arry[1] ='0';
                }else if (arry[0]=='0' & arry[1]=='1') {
                    arry[0] = '1';
                    arry[1] ='0';
                }else if (arry[0]=='1' & arry[1]=='1') {
                    arry[0] = '1';
                    arry[1] ='0';
                }else if (arry[0]=='1' & arry[1]=='0') {
                    arry[0] = '1';
                    arry[1] ='1';
                }
            

                NSString *arr1 = [self  transArryToStr:arry];
                NSString *arr = [arr1  stringByAppendingString:@"000000"];
                self.arr = arr;
                
                if (foundDeviceArrar.count == 0) {//没有找到此设备
                    
                    //添加新设备
                    themeDevice.device_state_cmd = arr;
                    [themeDeviceMessageTool  addThemeDevice:themeDevice];
                    // NSLog(@"情景表中没有 添加disselected =  %@",states.device_state_cmd);
                }else{//已经有此设备 则更新设备状态
                    
                    themeDeviceMessage *theme = foundDeviceArrar[0];
                    
                    states.device_state_cmd = arr;
                    states.device_No = theme.device_No;
                    states.theme_no = _dataCenter.theme_No;
                   // NSLog(@"情景表中有 更新disselected =  %@",states.device_state_cmd);
                    [themeDeviceMessageTool  updateThemeDeviceState:states];
                    
                    
                }
                
                
            }
            
            break;
        case 118:
            if (btn.selected) {
                
                
                
                //获取数据库中最新的设备状态，将它赋值给当前数组
                if (foundDeviceArrar.count == 0) {
                    
                    memcpy(arry, [[dev.DEVICE_STATE substringToIndex:2] cStringUsingEncoding:NSASCIIStringEncoding],2);
                    
                }else{
                    
                    themeDeviceMessage *theme = foundDeviceArrar[0];
                    memcpy(arry, [[theme.device_state_cmd substringToIndex:2] cStringUsingEncoding:NSASCIIStringEncoding],2);
                }
                
                if (arry[0]=='0' & arry[1]=='0') {
                    arry[0] = '1';
                    arry[1] ='0';
                }else if (arry[0]=='0' & arry[1]=='1') {
                    arry[0] = '1';
                    arry[1] ='0';
                }else if (arry[0]=='1' & arry[1]=='1') {
                    arry[0] = '1';
                    arry[1] ='0';
                }else if (arry[0]=='1' & arry[1]=='0') {
                    arry[0] = '1';
                    arry[1] ='1';
                }
                NSString *arr1 = [self  transArryToStr:arry];
                NSString *arr = [arr1  stringByAppendingString:@"000000"];
                self.arr = arr;
                if (foundDeviceArrar.count == 0) {//没有找到此设备
                    
                    //添加新设备
                    themeDevice.device_state_cmd = arr;
                    [themeDeviceMessageTool  addThemeDevice:themeDevice];
                    
                }else{//已经有此设备 则更新设备状态
                    
                    themeDeviceMessage *theme = foundDeviceArrar[0];
                    
                    states.device_state_cmd = arr;
                    states.device_No = theme.device_No;
                    states.theme_no = _dataCenter.theme_No;
                    NSLog(@"selected =  %@",states.device_state_cmd);
                    
                    [themeDeviceMessageTool  updateThemeDeviceState:states];
                    
                    
                }
                
                
            }else{
                
                if (foundDeviceArrar.count == 0) {
                    
                    memcpy(arry, [[dev.DEVICE_STATE substringToIndex:2] cStringUsingEncoding:NSASCIIStringEncoding],2);
                    
                }else{
                    
                    themeDeviceMessage *theme = foundDeviceArrar[0];
                    memcpy(arry, [[theme.device_state_cmd substringToIndex:2] cStringUsingEncoding:NSASCIIStringEncoding],2);
                }
                
                if (arry[0]=='0' & arry[1]=='0') {
                    arry[0] = '1';
                    arry[1] ='0';
                }else if (arry[0]=='0' & arry[1]=='1') {
                    arry[0] = '1';
                    arry[1] ='0';
                }else if (arry[0]=='1' & arry[1]=='1') {
                    arry[0] = '1';
                    arry[1] ='0';
                }else if (arry[0]=='1' & arry[1]=='0') {
                    arry[0] = '1';
                    arry[1] ='1';
                }
                
                NSString *arr1 = [self  transArryToStr:arry];
                NSString *arr = [arr1  stringByAppendingString:@"000000"];
                self.arr = arr;
                
                if (foundDeviceArrar.count == 0) {//没有找到此设备
                    
                    //添加新设备
                    themeDevice.device_state_cmd = arr;
                    [themeDeviceMessageTool  addThemeDevice:themeDevice];
                    
                }else{//已经有此设备 则更新设备状态
                    
                    themeDeviceMessage *theme = foundDeviceArrar[0];
                    
                    states.device_state_cmd = arr;
                    states.device_No = theme.device_No;
                    states.theme_no = _dataCenter.theme_No;
                    NSLog(@"selected =  %@",states.device_state_cmd);
                    [themeDeviceMessageTool  updateThemeDeviceState:states];
                    
                }
                
            }
            break;
    
    }
    
    //刷新数据
    //[self addUICollectionView];
    [_collectionView  reloadData];
    
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
 *  定义每个UICollectionView 的大小
 *
 *  @param CGSize 一个cell的宽度
 *
 *  @return 返回设置后的结果
 */

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat  collectionViewW= (CGRectGetMaxX(self.collectionView.frame) -CGRectGetMinX(self.collectionView.frame))/2;
    
    
    
    return CGSizeMake(collectionViewW-5, 40);
    
}


/**
 *  定义每个UICollectionView 的 margin
 *
 *  @param UIEdgeInsets 改变文本框的位置
 *
 *  @return 返回设置的结果
 */

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    
    
    return UIEdgeInsetsMake(10, 3, 10, 1);//改变文本框的位置（上左下右）
    
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
    
    
    [self.fullscreenView addSubview:WhiteBackgroundLable];
    
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
-(BOOL)shouldAutorotate{
    return YES;
}



-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}
@end
