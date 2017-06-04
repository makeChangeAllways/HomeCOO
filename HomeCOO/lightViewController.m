//
//  lightViewController.m
//  HomeCOO
//
//  Created by tgbus on 16/7/8.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "lightViewController.h"
#import "deviceMessage.h"
#import "deviceMessageTool.h"
#import "themeLightView.h"
#import "ThemeAdministrationController.h"
#import "PrefixHeader.pch"
#import "externValue.h"
#import "gatewayMessageModel.h"
#import "gatewayMessageTool.h"
#import "themeDeviceMessage.h"
#import "themeDeviceMessageTool.h"
#import "MBProgressHUD+MJ.h"
#import "LZXDataCenter.h"
#import "themeDeviceMessage.h"
#import "themeDeviceMessageTool.h"
#import "ControlMethods.h"
#import "PacketMethods.h"
#import "deviceMessage.h"
#import "deviceMessageTool.h"
#import "spaceMessageModel.h"
#import "spaceMessageTool.h"
#import "deviceSpaceMessageModel.h"
#import "deviceSpaceMessageTool.h"
#import "linkageController.h"
#import "SocketManager.h"
#import "PrefixHeader.pch"

@interface lightViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)  NSArray *devices;
@property(nonatomic,weak) themeLightView *cell;
/**设置背景图片*/
@property(nonatomic,weak)  UIImageView  * fullscreenView;

/**设置导航栏*/
@property(nonatomic,weak)  UINavigationBar *navBar;

@property (weak, nonatomic)  UICollectionView *collectionView;

@property(nonatomic,strong) NSString *arr;

@property(nonatomic,strong)LZXDataCenter *dataCenter;
@property(nonatomic,strong) deviceMessage *devicess;
@property(nonatomic,strong) themeDeviceMessage *fonudDevice;
@property(nonatomic,strong) deviceSpaceMessageModel *deviceSpace;

@end

@implementation lightViewController

-(NSArray *)devices
{
    if (_devices==nil) {
        
        LZXDataCenter *gateway = [LZXDataCenter defaultDataCenter];
        
        if ([gateway.gatewayNo isEqualToString:@"0"] | !gateway.gatewayNo ) {
            [MBProgressHUD  showError:@"请先添加网关"];
        }else{
            deviceMessage *device = [[deviceMessage alloc]init];
            device.GATEWAY_NO = gateway.gatewayNo;
            _devices=[deviceMessageTool queryWithLightDevices:device];
            
        }
        [MBProgressHUD  hideHUD];
        
    }
    
    return _devices;
    
}

static NSString *string = @"themeLightView";
static NSInteger   indexNum;

static char arry[4] = {'0','0','0','0'};



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置背景
    [self setFullscreenView];
    
    LZXDataCenter *dataCenter = [LZXDataCenter defaultDataCenter];
    
    self.dataCenter = dataCenter;
    //添加aUICollectionView
    [self  addUICollectionView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}
/**
 *  添加UICollectionView 来显示所有的照明设备
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
    
    [collectionView registerClass:[themeLightView class] forCellWithReuseIdentifier:string];
    
    self.collectionView = collectionView;
    
    
    [self.fullscreenView addSubview:collectionView];
    
}
#pragma mark <UICollectionViewDataSource>

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



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
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
    _cell.button5.selected = NO;
    
    //先取出模型里的数据
    if (!_devicess) {
        
        _devicess = [[deviceMessage  alloc]init];
        
    }
    
    _devicess.GATEWAY_NO = _dataCenter.gatewayNo;
    
    deviceMessage *device=[deviceMessageTool queryWithLightDevices:_devicess][indexPath.row];
 
    if (!_fonudDevice) {
        _fonudDevice = [[themeDeviceMessage  alloc]init];

    }
   
    _fonudDevice.theme_no = _dataCenter.theme_No;
    
    NSArray * foundDeviceArrar;
    
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

            _cell.button1.hidden = YES;
            _cell.button2.hidden = YES;
            _cell.button3.hidden = YES;
            _cell.process.hidden = YES;
            
            break;
            
        case 2:
            
            _fonudDevice.device_No = device.DEVICE_NO;
            
            foundDeviceArrar = [themeDeviceMessageTool queryWithThemeDevices:_fonudDevice];
            if (foundDeviceArrar.count ==0) {
                
                _cell.button5.selected = YES;
            
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
             }
            
            else{
           
               
                themeDeviceMessage  *themeDevice = foundDeviceArrar[0];
                if ([themeDevice.device_state_cmd  isEqualToString:@"00"]) {
                    
                    _cell.button3.selected = YES;
                    _cell.button4.selected = YES;
                }
                
                if ([themeDevice.device_state_cmd  isEqualToString:@"10"]) {
                   
                    _cell.button4.selected = YES;
                }
                
                if ([themeDevice.device_state_cmd  isEqualToString:@"01"]) {
                    _cell.button3.selected = YES;
                  
                }

            }
            _cell.button1.hidden = YES;
            _cell.button2.hidden = YES;
            _cell.process.hidden = YES;
            
            break;
            
        case 3:
            
            
            _fonudDevice.device_No = device.DEVICE_NO;
            
            foundDeviceArrar = [themeDeviceMessageTool queryWithThemeDevices:_fonudDevice];
            if (foundDeviceArrar.count ==0) {
                
                _cell.button5.selected = YES;
                
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
                    _cell.button2.selected = YES;
                    _cell.button3.selected = YES;
                    
                    
                }
                
                if ([device.DEVICE_STATE  isEqualToString:@"011"]) {
                    
                    _cell.button2.selected = YES;
                   
                    
                }
             
            }else{
            
               
                themeDeviceMessage  *themeDevice = foundDeviceArrar[0];
                
                if ([themeDevice.device_state_cmd  isEqualToString:@"100"]) {
                    
                    _cell.button3.selected = YES;
                    _cell.button4.selected = YES;
                    
                    
                }
                
                if ([themeDevice.device_state_cmd  isEqualToString:@"101"]) {
                   
                    _cell.button3.selected = YES;
                    
                    
                }
                
                if ([themeDevice.device_state_cmd  isEqualToString:@"110"]) {
                    
                    _cell.button4.selected = YES;
                    
                }
                
                if ([themeDevice.device_state_cmd  isEqualToString:@"000"]) {
                    
                    _cell.button2.selected = YES;
                    _cell.button3.selected = YES;
                    _cell.button4.selected = YES;
                    
                }
                
                if ([themeDevice.device_state_cmd  isEqualToString:@"010"]) {
                    _cell.button2.selected = YES;
                   
                    _cell.button4.selected = YES;
                    
                }
                
                if ([themeDevice.device_state_cmd  isEqualToString:@"001"]) {
                    _cell.button2.selected = YES;
                    _cell.button3.selected = YES;
                   
                    
                }
                
                if ([themeDevice.device_state_cmd  isEqualToString:@"011"]) {
                    
                    _cell.button2.selected = YES;
                    
                    
                }

            
            
            }
            _cell.button1.hidden = YES;
            _cell.process.hidden = YES;
            break;
            
        case 4:
            
            _fonudDevice.device_No = device.DEVICE_NO;
            
            foundDeviceArrar = [themeDeviceMessageTool queryWithThemeDevices:_fonudDevice];
            if (foundDeviceArrar.count ==0) {

                _cell.button5.selected = YES;
            
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
                
            }else{
            
               
                themeDeviceMessage  *themeDevice = foundDeviceArrar[0];
                
                if ([themeDevice.device_state_cmd  isEqualToString:@"1011"]) {
                    
                   
                    _cell.button2.selected = YES;
                  
                }
                
                if ([themeDevice.device_state_cmd  isEqualToString:@"1010"]) {
                    
                    
                    _cell.button2.selected = YES;
                   
                    _cell.button4.selected = YES;
                    
                }
                
                if ([themeDevice.device_state_cmd  isEqualToString:@"1001"]) {
                   
                    _cell.button2.selected = YES;
                    _cell.button3.selected = YES;
                   
                    
                    
                }
                if ([themeDevice.device_state_cmd  isEqualToString:@"1000"]) {
                    
                    _cell.button2.selected = YES;
                    _cell.button3.selected = YES;
                    _cell.button4.selected = YES;
                    
                }
                
                if ([themeDevice.device_state_cmd  isEqualToString:@"0000"]) {
                    _cell.button1.selected = YES;
                    _cell.button2.selected = YES;
                    _cell.button3.selected = YES;
                    _cell.button4.selected = YES;
                }
                if ([themeDevice.device_state_cmd  isEqualToString:@"1110"]) {
                  
                    _cell.button4.selected = YES;
                }
                
                
                if ([themeDevice.device_state_cmd  isEqualToString:@"1101"]) {
                    
                   
                    _cell.button3.selected = YES;
                    
                }
                
                if ([themeDevice.device_state_cmd  isEqualToString:@"1100"]) {
                    
                   
                    _cell.button3.selected = YES;
                    _cell.button4.selected = YES;
                    
                    
                }
                if ([themeDevice.device_state_cmd  isEqualToString:@"0011"]) {
                    _cell.button1.selected = YES;
                    _cell.button2.selected = YES;
                    
                    
                }
                
                if ([themeDevice.device_state_cmd  isEqualToString:@"0010"]) {
                    
                    _cell.button1.selected = YES;
                    _cell.button2.selected = YES;
                    
                    _cell.button4.selected = YES;
                    
                }
                
                if ([themeDevice.device_state_cmd  isEqualToString:@"0001"]) {
                    
                    _cell.button1.selected = YES;
                    _cell.button2.selected = YES;
                    _cell.button3.selected = YES;
                   
                    
                }
                
                
                if ([themeDevice.device_state_cmd  isEqualToString:@"0111"]) {
                    
                    _cell.button1.selected = YES;
                    
                }
                
                if ([themeDevice.device_state_cmd  isEqualToString:@"0110"]) {
                    
                    _cell.button1.selected = YES;
                   
                    _cell.button4.selected = YES;
                }
                
                if ([themeDevice.device_state_cmd  isEqualToString:@"0101"]) {
                    
                    _cell.button1.selected = YES;
                   
                    _cell.button3.selected = YES;
                  
                    
                }
                
                if ([themeDevice.device_state_cmd  isEqualToString:@"0100"]) {
                    
                    _cell.button1.selected = YES;
                    
                    _cell.button3.selected = YES;
                    _cell.button4.selected = YES;
                    
                }

            
            
            }
             _cell.process.hidden = YES;
            break;
        case 5:
            
            _fonudDevice.device_No = device.DEVICE_NO;
            
            foundDeviceArrar = [themeDeviceMessageTool queryWithThemeDevices:_fonudDevice];
            
            if (foundDeviceArrar.count ==0){
             
                _cell.button5.selected = YES;
                _cell.process.value = [device.DEVICE_STATE intValue];
               
           
            }else{
            
                themeDeviceMessage  *themeDevice = foundDeviceArrar[0];
                
                _cell.process.value = [themeDevice.device_state_cmd  intValue];
              
           
            }
        
            _cell.button1.hidden = YES;
            _cell.button2.hidden = YES;
            _cell.button3.hidden = YES;
            _cell.button4.hidden = YES;
            break;
    }
    
    //监听按钮点击事件
    [_cell.button4  addTarget:self action:@selector(enterChangeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_cell.button3  addTarget:self action:@selector(enterChangeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_cell.button2  addTarget:self action:@selector(enterChangeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_cell.button1  addTarget:self action:@selector(enterChangeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_cell.button5  addTarget:self action:@selector(checkBox:) forControlEvents:UIControlEventTouchUpInside];
   
    [_cell.process addTarget:self action:@selector(enterChangeProcess:) forControlEvents:UIControlEventValueChanged];
   
    return _cell;
}

-(void)enterChangeProcess:(UISlider *)pro{
    
    themeLightView *cell = (themeLightView *)[[[pro superview]superview]superview];//获取cell
    
    NSIndexPath *indexPathAll = [self.collectionView indexPathForCell:cell];//获取cell对应的section
    
    indexNum =indexPathAll.row;
    
    
    deviceMessage *device = [[deviceMessage alloc]init];
    device.GATEWAY_NO = _dataCenter.gatewayNo;
    NSArray  *devices =[deviceMessageTool queryWithLightDevices:device];
    
    //取出当前cell的设备信息
    deviceMessage  *dev = devices[indexNum];
    
    NSInteger process = pro.value;
    
    themeDeviceMessage *fonudDevice = [[themeDeviceMessage  alloc]init];
    
    fonudDevice.device_No = dev.DEVICE_NO;
    
    fonudDevice.theme_no = _dataCenter.theme_No;
   
    themeDeviceMessage *deletDevice = [[themeDeviceMessage  alloc]init];
    
    deletDevice.device_No = dev.DEVICE_NO;
    
    deletDevice.theme_no = _dataCenter.theme_No;
    
    
    //更新设备状态
    themeDeviceMessage *states = [[themeDeviceMessage  alloc]init];

    NSArray * foundDeviceArrar = [themeDeviceMessageTool queryWithThemeDevices:fonudDevice];
    
    //像themedevice表中插入新的设备
    themeDeviceMessage  *themeDevice = [[themeDeviceMessage  alloc]init];
    
    themeDevice.device_No = dev.DEVICE_NO;
    themeDevice.gateway_No = _dataCenter.gateway_No;
    themeDevice.theme_no = _dataCenter.theme_No;
    themeDevice.theme_device_No = _dataCenter.device_No;
    themeDevice.theme_state = _dataCenter.theme_State;
    themeDevice.theme_type = _dataCenter.theme_Type;
    themeDevice.device_state_cmd =dev.DEVICE_STATE ;
    //themeDevice.infra_type_ID = ;
    
    if (foundDeviceArrar.count == 0) {//没有找到此设备
        
        //添加新设备
        themeDevice.device_state_cmd = [NSString stringWithFormat:@"%ld",(long)process];
        [themeDeviceMessageTool  addThemeDevice:themeDevice];
       
        [self  addUICollectionView];
    }else{//已经有此设备 则更新设备状态
        
        themeDeviceMessage *theme = foundDeviceArrar[0];
        
        states.device_state_cmd = [NSString stringWithFormat:@"%ld",(long)process];
        states.device_No = theme.device_No;
        states.theme_no = _dataCenter.theme_No;
      
        [themeDeviceMessageTool  updateThemeDeviceState:states];

    }
   
    [_collectionView  reloadData];

}
/**
 *  通过对号 查看是否在themedevice表中有次设备
 *
 *  @param btn
 */
- (void)checkBox:(UIButton *)btn {
    themeLightView *cell = (themeLightView *)[[[btn superview]superview]superview];//获取cell
    
    NSIndexPath *indexPathAll = [self.collectionView indexPathForCell:cell];//获取cell对应的section
    
    indexNum =indexPathAll.row;
 
    NSArray  *devices ;//= [deviceMessageTool  queryWithLightDevices];
    
    if ([_dataCenter.gatewayNo isEqualToString:@"0"] | !_dataCenter.gatewayNo ) {
        
        [MBProgressHUD  showError:@"请先添加网关"];
        
    }else{
        deviceMessage *device = [[deviceMessage alloc]init];
        device.GATEWAY_NO = _dataCenter.gatewayNo;
        devices=[deviceMessageTool queryWithLightDevices:device];
        
    }
    [MBProgressHUD  hideHUD];
    
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
   
    [_collectionView reloadData];

}
/**
 *  按钮监听事件
 *
 *  @param btn 点击的是哪个
 */
- (void)enterChangeButton:(UIButton *)btn {
    
    themeLightView *cell = (themeLightView *)[[[btn superview]superview]superview];//获取cell
    
    NSIndexPath *indexPathAll = [self.collectionView indexPathForCell:cell];//获取cell对应的section
    
    indexNum =indexPathAll.row;
    

    NSArray  *devices ;//= [deviceMessageTool  queryWithLightDevices];
    
   
    deviceMessage *device = [[deviceMessage alloc]init];
    device.GATEWAY_NO = _dataCenter.gatewayNo;
    devices=[deviceMessageTool queryWithLightDevices:device];
    
    //取出当前cell的设备信息
    deviceMessage  *dev = devices[indexNum];
    
   // deviceMessage *state = [[deviceMessage  alloc]init];
    
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

    btn.selected = !btn.selected;
    
    if (dev.DEVICE_TYPE_ID ==1) {
        switch (btn.tag) {
                
            case 400:
                
               
                
                if (btn.selected) {
            
                    if (foundDeviceArrar.count == 0) {
                        
                         memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                        
                    }else{
                   
                       themeDeviceMessage *theme = foundDeviceArrar[0];
                        memcpy(arry, [theme.device_state_cmd cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
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
                        
                    }else{//已经有次设备 则更新设备状态
                    
                        themeDeviceMessage *theme = foundDeviceArrar[0];
                        
                        states.device_state_cmd = arr;
                        states.device_No = theme.device_No;
                        states.theme_no = _dataCenter.theme_No;
                        NSLog(@"selected =  %@",states.device_state_cmd);
                        
                        [themeDeviceMessageTool  updateThemeDeviceState:states];
                        
                    
                    }
                    
                }else{
                    
   
                    if (foundDeviceArrar.count == 0) {
                        
                        memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                        
                    }else{
                        
                        themeDeviceMessage *theme = foundDeviceArrar[0];
                        memcpy(arry, [theme.device_state_cmd cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
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
                
        }
        
    }
    
    if (dev.DEVICE_TYPE_ID ==2) {
        switch (btn.tag) {
                
            case 400:
                
                if (btn.selected) {
                    
                    if (foundDeviceArrar.count == 0) {
                        
                         memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                        
                    }else{
                        
                        themeDeviceMessage *theme = foundDeviceArrar[0];

                        
                        memcpy(arry, [theme.device_state_cmd cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    
                    }
                    
                    if (arry[1] == '1') {
                        arry[1] = '0';
                    }
                    else{
                    
                        arry[1] = '1';
                        
                    }
                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 2)];
                    self.arr = arr;
                    
                    if (foundDeviceArrar.count == 0) {//没有找到此设备
                        
                        //添加新设备
                        themeDevice.device_state_cmd = arr;
                        [themeDeviceMessageTool  addThemeDevice:themeDevice];
                        
                    }else{//已经有次设备 则更新设备状态
                        
                        themeDeviceMessage *theme = foundDeviceArrar[0];
                        
                        states.device_state_cmd = arr;
                        states.device_No = theme.device_No;
                        states.theme_no = _dataCenter.theme_No;
                        
                        NSLog(@"selected =  %@",states.device_state_cmd);
                        
                        [themeDeviceMessageTool  updateThemeDeviceState:states];
                        
                        
                    }
                    
                    
                }else{
                    
                    if (foundDeviceArrar.count == 0) {
                        memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    }else{
                        
                        themeDeviceMessage *theme = foundDeviceArrar[0];
                        
                        
                        memcpy(arry, [theme.device_state_cmd cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                        
                    }
                    
                    if (arry[1] == '0') {
                        arry[1] = '1';
                    }
                    else{
                    
                        arry[1] = '0';
                        
                    }
                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 2)];
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
                        NSLog(@"noselected =  %@",states.device_state_cmd);
                        [themeDeviceMessageTool  updateThemeDeviceState:states];
                        
                    }
      
                }
                
                break;
                
            case 300:
                if (btn.selected) {
                    
                    if (foundDeviceArrar.count == 0) {
                        memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    }else{
                        
                        themeDeviceMessage *theme = foundDeviceArrar[0];
                        
                        
                        memcpy(arry, [theme.device_state_cmd cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                        
                    }

                    
                    if (arry[0] == '1') {
                        arry[0] = '0';
                    }
                    else{
                    
                        arry[0] = '1';
                        
                    }
                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 2)];
                    
                    self.arr = arr;
                    
                    if (foundDeviceArrar.count == 0) {//没有找到此设备
                        
                        //添加新设备
                        themeDevice.device_state_cmd = arr;
                        [themeDeviceMessageTool  addThemeDevice:themeDevice];
                        
                    }else{//已经有次设备 则更新设备状态
                        
                        themeDeviceMessage *theme = foundDeviceArrar[0];
                        
                        states.device_state_cmd = arr;
                        states.device_No = theme.device_No;
                        states.theme_no = _dataCenter.theme_No;
                        NSLog(@"selected =  %@",states.device_state_cmd);
                        
                        [themeDeviceMessageTool  updateThemeDeviceState:states];
                        
                        
                        
                    }
                    

                    
                }else{
                    if (foundDeviceArrar.count == 0) {
                        memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    }else{
                        
                        themeDeviceMessage *theme = foundDeviceArrar[0];
                        
                        
                        memcpy(arry, [theme.device_state_cmd cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                        
                    }
                    
                   
                    if (arry[0] == '0') {
                        
                        arry[0] = '1';
                        
                    }
                    else{
                    
                        arry[0] = '0';
                        
                    }
                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 2)];
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
                        NSLog(@"noselected =  %@",states.device_state_cmd);
                        [themeDeviceMessageTool  updateThemeDeviceState:states];
                        
                        
                    }

                }
                
             
                break;
                
        }
        
    }
    
    if (dev.DEVICE_TYPE_ID ==3) {
        
        switch (btn.tag) {
                
            case 400:
                
                if (btn.selected) {
                    
                    if (foundDeviceArrar.count == 0) {
                        memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    }else{
                        
                        themeDeviceMessage *theme = foundDeviceArrar[0];
                        
                        
                        memcpy(arry, [theme.device_state_cmd cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                        
                    }

                    if (arry[2] == '1') {
                        arry[2] = '0';
                    }
                    else{
                    
                        arry[2] = '1';
                        
                    }
                    
                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 3)];
                    self.arr = arr;
                    
                    if (foundDeviceArrar.count == 0) {//没有找到此设备
                        
                        //添加新设备
                        themeDevice.device_state_cmd = arr;
                        [themeDeviceMessageTool  addThemeDevice:themeDevice];
                        
                    }else{//已经有次设备 则更新设备状态
                        
                        themeDeviceMessage *theme = foundDeviceArrar[0];
                        
                        states.device_state_cmd = arr;
                        states.device_No = theme.device_No;
                        states.theme_no = _dataCenter.theme_No;
                        NSLog(@"selected =  %@",states.device_state_cmd);
                        
                        [themeDeviceMessageTool  updateThemeDeviceState:states];
                        
                        
                        
                    }

                    
                }else{
                    
                    if (foundDeviceArrar.count == 0) {
                        memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    }else{
                        
                        themeDeviceMessage *theme = foundDeviceArrar[0];
                        
                        
                        memcpy(arry, [theme.device_state_cmd cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                        
                    }

                    
                    if (arry[2] == '0') {
                        arry[2] = '1';
                    }
                    else{
                    
                        arry[2] = '0';
                        
                    }
                    
                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 3)];
                    self.arr = arr;
                    if (foundDeviceArrar.count == 0) {//没有找到此设备
                        
                        //添加新设备
                        themeDevice.device_state_cmd = arr;
                        [themeDeviceMessageTool  addThemeDevice:themeDevice];
                        
                    }else{//已经有次设备 则更新设备状态
                        
                        themeDeviceMessage *theme = foundDeviceArrar[0];
                        
                        states.device_state_cmd = arr;
                        states.device_No = theme.device_No;
                        states.theme_no = _dataCenter.theme_No;
                        NSLog(@"selected =  %@",states.device_state_cmd);
                        
                        [themeDeviceMessageTool  updateThemeDeviceState:states];
                        
                        
                    }

                    
                }
                
                //刷新数据
                //[self addUICollectionView];
                
                break;
                
            case 300:
                
                if (btn.selected) {
                    if (foundDeviceArrar.count == 0) {
                        memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    }else{
                        
                        themeDeviceMessage *theme = foundDeviceArrar[0];
                        
                        
                        memcpy(arry, [theme.device_state_cmd cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                        
                    }

                    
                    if (arry[1] == '1') {
                        arry[1] = '0';
                    }
                    else{
                    
                        arry[1] = '1';
                        
                    }
                    
                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 3)];
                    
                    self.arr = arr;
                    if (foundDeviceArrar.count == 0) {//没有找到此设备
                        
                        //添加新设备
                        themeDevice.device_state_cmd = arr;
                        [themeDeviceMessageTool  addThemeDevice:themeDevice];
                        
                    }else{//已经有次设备 则更新设备状态
                        
                        themeDeviceMessage *theme = foundDeviceArrar[0];
                        
                        states.device_state_cmd = arr;
                        states.device_No = theme.device_No;
                        states.theme_no = _dataCenter.theme_No;
                        NSLog(@"selected =  %@",states.device_state_cmd);
                        
                        [themeDeviceMessageTool  updateThemeDeviceState:states];
                        
                        
                        
                    }

                    
                }else{
                    
                    if (foundDeviceArrar.count == 0) {
                        memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    }else{
                        
                        themeDeviceMessage *theme = foundDeviceArrar[0];
                        
                        
                        memcpy(arry, [theme.device_state_cmd cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                        
                    }

                    
                    if (arry[1] == '0') {
                        arry[1] = '1';
                    }
                    else{
                    
                        arry[1] = '0';
                        
                    }
                    
                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 3)];
                    self.arr = arr;
                    if (foundDeviceArrar.count == 0) {//没有找到此设备
                        
                        //添加新设备
                        themeDevice.device_state_cmd = arr;
                        [themeDeviceMessageTool  addThemeDevice:themeDevice];
                        
                    }else{//已经有次设备 则更新设备状态
                        
                        themeDeviceMessage *theme = foundDeviceArrar[0];
                        
                        states.device_state_cmd = arr;
                        states.device_No = theme.device_No;
                        states.theme_no = _dataCenter.theme_No;
                        NSLog(@"selected =  %@",states.device_state_cmd);
                        
                        [themeDeviceMessageTool  updateThemeDeviceState:states];
                        
                        
                        
                    }

                    
                }
               
                //刷新数据
               // [self addUICollectionView];
                
                break;
            case 200:
                if (btn.selected) {
                    
                    if (foundDeviceArrar.count == 0) {
                        memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    }else{
                        
                        themeDeviceMessage *theme = foundDeviceArrar[0];
                        
                        
                        memcpy(arry, [theme.device_state_cmd cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                        
                    }
                    if (arry[0] == '1') {
                        arry[0] = '0';
                    }
                    else{
                    
                        arry[0] = '1';
                        
                    }
                    
                    
                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 3)];
                    self.arr = arr;
                    if (foundDeviceArrar.count == 0) {//没有找到此设备
                        
                        //添加新设备
                        themeDevice.device_state_cmd = arr;
                        [themeDeviceMessageTool  addThemeDevice:themeDevice];
                        
                    }else{//已经有次设备 则更新设备状态
                        
                        themeDeviceMessage *theme = foundDeviceArrar[0];
                        
                        states.device_state_cmd = arr;
                        states.device_No = theme.device_No;
                        states.theme_no = _dataCenter.theme_No;
                        NSLog(@"selected =  %@",states.device_state_cmd);
                        
                        [themeDeviceMessageTool  updateThemeDeviceState:states];
                        
                        
                        
                    }

                    
                }else{
                    if (foundDeviceArrar.count == 0) {
                        memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    }else{
                        
                        themeDeviceMessage *theme = foundDeviceArrar[0];
                        
                        
                        memcpy(arry, [theme.device_state_cmd cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                        
                    }

                    
                    if (arry[0] == '0') {
                        arry[0] = '1';
                    }
                    else{
                    
                        arry[0] = '0';
                        
                    }
                    
                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 3)];
                    self.arr = arr;
                    
                    if (foundDeviceArrar.count == 0) {//没有找到此设备
                        
                        //添加新设备
                        themeDevice.device_state_cmd = arr;
                        [themeDeviceMessageTool  addThemeDevice:themeDevice];
                        
                    }else{//已经有次设备 则更新设备状态
                        
                        themeDeviceMessage *theme = foundDeviceArrar[0];
                        
                        states.device_state_cmd = arr;
                        states.device_No = theme.device_No;
                        states.theme_no = _dataCenter.theme_No;
                        NSLog(@"selected =  %@",states.device_state_cmd);
                        
                        [themeDeviceMessageTool  updateThemeDeviceState:states];
                        
                        
                        
                    }

                    
                }
                
                //刷新数据
                //[self addUICollectionView];
              
                break;
                
        }
        
        
    }
    
    
    if (dev.DEVICE_TYPE_ID ==4) {
        
        switch (btn.tag) {
                
            case 400:
                
                if (btn.selected) {
                    
                    if (foundDeviceArrar.count == 0) {
                        memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    }else{
                        
                        themeDeviceMessage *theme = foundDeviceArrar[0];
                        
                        
                        memcpy(arry, [theme.device_state_cmd cStringUsingEncoding:NSASCIIStringEncoding],[theme.device_state_cmd length]);
                        
                    }

                    
                    if (arry[3] == '1') {
                        arry[3] = '0';
                        
                    }else{
                    
                        arry[3] = '1';
                        
                    }
                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 4)];
                    self.arr = arr;
                    if (foundDeviceArrar.count == 0) {//没有找到此设备
                        
                        //添加新设备
                        themeDevice.device_state_cmd = arr;
                        [themeDeviceMessageTool  addThemeDevice:themeDevice];
                        
                    }else{//已经有次设备 则更新设备状态
                        
                        themeDeviceMessage *theme = foundDeviceArrar[0];
                        
                        states.device_state_cmd = arr;
                        states.device_No = theme.device_No;
                        states.theme_no = _dataCenter.theme_No;
                        NSLog(@"selected =  %@",states.device_state_cmd);
                        
                        [themeDeviceMessageTool  updateThemeDeviceState:states];
                        
                        
                        
                    }
                    
                    
                }else{
                    
                    if (foundDeviceArrar.count == 0) {
                        memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    }else{
                        
                        themeDeviceMessage *theme = foundDeviceArrar[0];
                        
                        
                        memcpy(arry, [theme.device_state_cmd cStringUsingEncoding:NSASCIIStringEncoding],[theme.device_state_cmd length]);
                        
                    }

                    
                    if (arry[3] == '0') {
                        
                        arry[3] = '1';
                        
                    }else{
                    
                        arry[3] = '0';
                        
                    }
                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 4)];
                    self.arr = arr;
                    if (foundDeviceArrar.count == 0) {//没有找到此设备
                        
                        //添加新设备
                        themeDevice.device_state_cmd = arr;
                        [themeDeviceMessageTool  addThemeDevice:themeDevice];
                        
                    }else{//已经有次设备 则更新设备状态
                        
                        themeDeviceMessage *theme = foundDeviceArrar[0];
                        
                        states.device_state_cmd = arr;
                        states.device_No = theme.device_No;
                        states.theme_no = _dataCenter.theme_No;
                        NSLog(@"selected =  %@",states.device_state_cmd);
                        
                        [themeDeviceMessageTool  updateThemeDeviceState:states];
                        
                        
                    }
                    
                    
                }
                
                
                //刷新数据
               // [self addUICollectionView];
                
                break;
                
            case 300:
                if (btn.selected) {
                    if (foundDeviceArrar.count == 0) {
                        memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    }else{
                        
                        themeDeviceMessage *theme = foundDeviceArrar[0];
                        
                        
                        memcpy(arry, [theme.device_state_cmd cStringUsingEncoding:NSASCIIStringEncoding],[theme.device_state_cmd length]);
                        
                    }

                    
                    if (arry[2] == '1') {
                        arry[2] = '0';
                        
                    }else{
                        
                        arry[2] = '1';
                        
                    }
                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 4)];
                    
                    self.arr = arr;
                    if (foundDeviceArrar.count == 0) {//没有找到此设备
                        
                        //添加新设备
                        themeDevice.device_state_cmd = arr;
                        [themeDeviceMessageTool  addThemeDevice:themeDevice];
                        
                    }else{//已经有次设备 则更新设备状态
                        
                        themeDeviceMessage *theme = foundDeviceArrar[0];
                        
                        states.device_state_cmd = arr;
                        states.device_No = theme.device_No;
                        states.theme_no = _dataCenter.theme_No;
                        NSLog(@"selected =  %@",states.device_state_cmd);
                        
                        [themeDeviceMessageTool  updateThemeDeviceState:states];
                        
                        
                        
                    }

                    
                }else{
                    if (foundDeviceArrar.count == 0) {
                        memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    }else{
                        
                        themeDeviceMessage *theme = foundDeviceArrar[0];
                        
                        
                        memcpy(arry, [theme.device_state_cmd cStringUsingEncoding:NSASCIIStringEncoding],[theme.device_state_cmd length]);
                        
                    }

                    
                    if (arry[2] == '0') {
                        arry[2] = '1';
                        
                    }else{
                    
                        arry[2] = '0';
                        
                    }
                    
                    
                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 4)];
                    self.arr = arr;
                    if (foundDeviceArrar.count == 0) {//没有找到此设备
                        
                        //添加新设备
                        themeDevice.device_state_cmd = arr;
                        [themeDeviceMessageTool  addThemeDevice:themeDevice];
                        
                    }else{//已经有次设备 则更新设备状态
                        
                        themeDeviceMessage *theme = foundDeviceArrar[0];
                        
                        states.device_state_cmd = arr;
                        states.device_No = theme.device_No;
                        states.theme_no = _dataCenter.theme_No;
                        NSLog(@"selected =  %@",states.device_state_cmd);
                        
                        [themeDeviceMessageTool  updateThemeDeviceState:states];
                        
                        
                        
                    }

                    
                }
                
               
                //刷新数据
               // [self addUICollectionView];
                
                break;
            case 200:
                if (btn.selected) {
                    if (foundDeviceArrar.count == 0) {
                        memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    }else{
                        
                        themeDeviceMessage *theme = foundDeviceArrar[0];
                        
                        
                        memcpy(arry, [theme.device_state_cmd cStringUsingEncoding:NSASCIIStringEncoding],[theme.device_state_cmd length]);
                        
                    }

                    
                    
                    if (arry[1] == '1') {
                        arry[1] = '0';
                        
                    }else{
                    
                        arry[1] = '1';
                        
                    }
                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 4)];
                    self.arr = arr;
                    if (foundDeviceArrar.count == 0) {//没有找到此设备
                        
                        //添加新设备
                        themeDevice.device_state_cmd = arr;
                        [themeDeviceMessageTool  addThemeDevice:themeDevice];
                        
                    }else{//已经有次设备 则更新设备状态
                        
                        themeDeviceMessage *theme = foundDeviceArrar[0];
                        
                        states.device_state_cmd = arr;
                        states.device_No = theme.device_No;
                        states.theme_no = _dataCenter.theme_No;
                        NSLog(@"selected =  %@",states.device_state_cmd);
                        
                        [themeDeviceMessageTool  updateThemeDeviceState:states];
                        
                    }

                    
                }else{
                    
                    if (foundDeviceArrar.count == 0) {
                        memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    }else{
                        
                        themeDeviceMessage *theme = foundDeviceArrar[0];
                        
                        
                        memcpy(arry, [theme.device_state_cmd cStringUsingEncoding:NSASCIIStringEncoding],[theme.device_state_cmd length]);
                        
                    }

                    
                    if (arry[1] == '0') {
                        arry[1] = '1';
                        
                    }else{
                    
                        arry[1] = '0';
                        
                    }
                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 4)];
                    self.arr = arr;
                    
                    if (foundDeviceArrar.count == 0) {//没有找到此设备
                        
                        //添加新设备
                        themeDevice.device_state_cmd = arr;
                        [themeDeviceMessageTool  addThemeDevice:themeDevice];
                        
                    }else{//已经有次设备 则更新设备状态
                        
                        themeDeviceMessage *theme = foundDeviceArrar[0];
                        
                        states.device_state_cmd = arr;
                        states.device_No = theme.device_No;
                        states.theme_no = _dataCenter.theme_No;
                        NSLog(@"selected =  %@",states.device_state_cmd);
                        
                        [themeDeviceMessageTool  updateThemeDeviceState:states];
                        
                        
                        
                    }

                    
                }
                
                
                //刷新数据
               // [self addUICollectionView];
                
                break;
            case 100:
                if (btn.selected) {
                    
                    if (foundDeviceArrar.count == 0) {
                        memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    }else{
                        
                        themeDeviceMessage *theme = foundDeviceArrar[0];
                        
                        
                        memcpy(arry, [theme.device_state_cmd cStringUsingEncoding:NSASCIIStringEncoding],[theme.device_state_cmd length]);
                        
                    }

                    
                    
                    if (arry[0] == '1') {
                        arry[0] = '0';
                        
                    }else{
                    
                        arry[0] = '1';
                        
                    }
                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 4)];
                    self.arr = arr;
                    if (foundDeviceArrar.count == 0) {//没有找到此设备
                        
                        //添加新设备
                        themeDevice.device_state_cmd = arr;
                        [themeDeviceMessageTool  addThemeDevice:themeDevice];
                        
                    }else{//已经有次设备 则更新设备状态
                        
                        themeDeviceMessage *theme = foundDeviceArrar[0];
                        
                        states.device_state_cmd = arr;
                        states.device_No = theme.device_No;
                        states.theme_no = _dataCenter.theme_No;
                        NSLog(@"selected =  %@",states.device_state_cmd);
                        
                        [themeDeviceMessageTool  updateThemeDeviceState:states];
                        
                        
                        
                    }
                    
                    
                }else{
                   
                    if (foundDeviceArrar.count == 0) {
                       
                        memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                        
                    }else{
                        
                        themeDeviceMessage *theme = foundDeviceArrar[0];
                        
                        
                        memcpy(arry, [theme.device_state_cmd cStringUsingEncoding:NSASCIIStringEncoding],[theme.device_state_cmd length]);
                        
                    }

                    
                    
                    if (arry[0] == '0') {
                        arry[0] = '1';
                        
                    }else{
                    
                        arry[0] = '0';
                        
                    }
                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 4)];
                    self.arr = arr;
                    if (foundDeviceArrar.count == 0) {//没有找到此设备
                        
                        //添加新设备
                        themeDevice.device_state_cmd = arr;
                        [themeDeviceMessageTool  addThemeDevice:themeDevice];
                        
                    }else{//已经有次设备 则更新设备状态
                        
                        themeDeviceMessage *theme = foundDeviceArrar[0];
                        
                        states.device_state_cmd = arr;
                        states.device_No = theme.device_No;
                        states.theme_no = _dataCenter.theme_No;
                        NSLog(@"selected =  %@",states.device_state_cmd);
                        
                        [themeDeviceMessageTool  updateThemeDeviceState:states];
                        
                        
                    }

                    
                }
                //刷新数据
                //[self addUICollectionView];
                
                break;
                
        }
        
    }
    [_collectionView  reloadData];
    
}

-(void)changeBox:(UIButton *)btn{
    
    [btn  setImage:[UIImage   imageNamed:@"right.png"] forState:UIControlStateNormal];
    [btn  setImage:[UIImage  imageNamed:@"false.png"] forState:UIControlStateSelected];
    
}

/**
 *  改变按钮初始化状态
 *
 *  @param btn 按钮
 */
-(void)changeBtn:(UIButton *)btn{
    
    [btn  setImage:[UIImage   imageNamed:@"button_on_s.png"] forState:UIControlStateNormal];
    [btn  setImage:[UIImage  imageNamed:@"button_off_s.png"] forState:UIControlStateSelected];
    
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



#pragma mark <UICollectionViewDelegate>

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
    
    themeDeviceMessage *themeNo = [[themeDeviceMessage alloc]init];
    
    themeNo.theme_no = _dataCenter.theme_No;
    
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
   
    if (_dataCenter.networkStateFlag ==0) {//内网
        
        NSString *themeSetting = [deviceControlPacketStr  stringByReplacingCharactersInRange:NSMakeRange(0, 8) withString:@"41414444"];
        
        [socket  sendMsg:themeSetting];
        NSLog(@"=====内网情景设置报文===%@======",themeSetting);
        
    }else{
        NSLog(@"====外网情景设置报文==%@====",deviceControlPacketStr);
        //发送报文到对应设备
        [ControlMethods  controlDeviceHTTPmethods:deviceControlPacketStr ];
        
    }
    
   

}
/**
 *  硬件情景下联动的设备信息 deviceNo[8] deviceState[32] dataLegth[4]  deviceType[4]
 */
-(NSString *)itemDeviceMseeage{
    
    NSString *str;
    
    themeDeviceMessage *themeNo = [[themeDeviceMessage alloc]init];
    
    themeNo.theme_no = _dataCenter.theme_No;
    
    NSArray *themeDeviceArray = [themeDeviceMessageTool  queryWithThemeNoDevices:themeNo];
    
//    NSLog(@"  themeDeviceArray = %lu  themeNo.theme_no %@ ",(unsigned long)themeDeviceArray.count,themeNo.theme_no);
    
    if (themeDeviceArray.count == 0) {
        
        [MBProgressHUD  showError:@"请添加设备"];
        
    }else{
    
        NSString *allDeviceMseeage = @"";
        
        for (int j = 0; j<themeDeviceArray.count; j++) {
           
            themeDeviceMessage *themeDevice = themeDeviceArray[j];
            
            //联动设备的mac地址
            NSString *deviceNo = [NSString  stringWithFormat:@"%@",themeDevice.device_No];
           
            deviceMessage  *deviceModel = [[deviceMessage  alloc]init];
           
            deviceModel.DEVICE_NO = themeDevice.device_No;
            deviceModel.GATEWAY_NO = _dataCenter.gatewayNo;
            
            NSArray *device_Array =  [deviceMessageTool  queryWithDeviceNumDevices:deviceModel];
            
//           NSLog(@"  device_Array = %lu  deviceModel.DEVICE_NO %@  deviceModel.GATEWAY_NO %@      ",(unsigned long)device_Array.count,deviceModel.DEVICE_NO,deviceModel.GATEWAY_NO);
            
            deviceMessage  *deviceMessages = device_Array[0];
            
            NSString *deviceState;

            if((deviceMessages.DEVICE_TYPE_ID == 5)|(deviceMessages.DEVICE_TYPE_ID == 110) | (deviceMessages.DEVICE_TYPE_ID == 113)|(deviceMessages.DEVICE_TYPE_ID == 115)|(deviceMessages.DEVICE_TYPE_ID == 118)){
                if (deviceMessages.DEVICE_TYPE_ID == 5) {
                    
                    //联动设备的状态
                    deviceState = [NSString  stringWithFormat:@"%@",[ControlMethods  ToHex:[themeDevice.device_state_cmd intValue]]];
                    
                    NSLog(@" deviceState %@   themeDevice.device_state_cmd %@ ",deviceState,themeDevice.device_state_cmd);
                    
                }else{
                
                    //联动设备的状态
               
                    deviceState = [NSString  stringWithFormat:@"%@",[ControlMethods  transThemeCoding:themeDevice.device_state_cmd]];
                }
                
            }else{
 
                //联动设备的状态
                deviceState = [NSString  stringWithFormat:@"%@",[ControlMethods  transCoding:themeDevice.device_state_cmd]];
            }
            
            
            NSString *stateAdded = @"";
            
                for (int i = 0; i<32-[themeDevice.device_state_cmd  length]; i ++) {
                    
                    NSString *test = [ControlMethods ToHex:0];
                    
                    stateAdded = [NSString  stringWithFormat:@"%@%@",stateAdded,test];
                    
                }
            
            //联动设备的状态为32个字节 其余的补0  补充完之后 完整的设备状态报文
            NSString *deviceStateWithAdded = [deviceState  stringByAppendingString:stateAdded];
            
            
        
            
            NSString *item_numInt =[ControlMethods  ToHex:[themeDevice.device_state_cmd length]];
            
            //将有效的字节数 封装成4个字节的nsstring格式
            NSString *item_num = [item_numInt stringByAppendingString:@"000000"];
            
            //根据联动设备的mac地址 在devicetable表中 找的此设备的信息
            deviceMessage  *device = [[deviceMessage  alloc]init];
            device.DEVICE_NO = themeDevice.device_No;
        
            device.GATEWAY_NO = _dataCenter.gatewayNo;
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
        

        str =  allDeviceMseeage;
        // NSLog(@"联动设备的信息 == %@",allDeviceMseeage);
        
    }
    
    [MBProgressHUD  hideHUD];
    return str;

}
-(BOOL)shouldAutorotate{
    return YES;
}



-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}


@end
