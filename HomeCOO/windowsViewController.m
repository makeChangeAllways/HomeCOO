//
//  windowsViewController.m
//  HomeCOO
//
//  Created by tgbus on 16/7/8.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "windowsViewController.h"
#import "deviceMessage.h"
#import "deviceMessageTool.h"
#import "themeWindowView.h"
#import "ThemeAdministrationController.h"
#import "LZXDataCenter.h"
#import "themeDeviceMessage.h"
#import "themeDeviceMessageTool.h"
#import "ControlMethods.h"
#import "MBProgressHUD+MJ.h"
#import "PacketMethods.h"
#import "deviceSpaceMessageModel.h"
#import "deviceSpaceMessageTool.h"
#import "spaceMessageModel.h"
#import "spaceMessageTool.h"
#import "linkageController.h"
#import "SocketManager.h"
#import "PrefixHeader.pch"
#import "gatewayMessageTool.h"
#import "gatewayMessageModel.h"

@interface windowsViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)  NSArray *devices;
@property(nonatomic,weak) themeWindowView *cell;
/**设置背景图片*/
@property(nonatomic,weak)  UIImageView  * fullscreenView;

/**设置导航栏*/
@property(nonatomic,weak)  UINavigationBar *navBar;

@property (weak, nonatomic)  UICollectionView *collectionView;

@property(nonatomic,strong) NSString *arr;

@property(nonatomic,strong)  LZXDataCenter *dataCenter;

@property(nonatomic,strong) deviceMessage *devicess;

@property(nonatomic,strong) themeDeviceMessage *fonudDevice;

@end

@implementation windowsViewController

-(NSArray *)devices
{
    if (_devices==nil) {
        
        LZXDataCenter *gateway = [LZXDataCenter defaultDataCenter];
        
        if ([gateway.gatewayNo isEqualToString:@"0"] | !gateway.gatewayNo ) {
            [MBProgressHUD  showError:@"请先添加网关"];
        }else{
            
            deviceMessage *device = [[deviceMessage alloc]init];
            device.GATEWAY_NO = gateway.gatewayNo;
            _devices=[deviceMessageTool queryWithWindowsDevices:device];
            
        }
        [MBProgressHUD  hideHUD];
    
        
    }
    
    return _devices;
    
}

static NSString *string = @"themeWindowView";
static NSInteger   indexNum;

static char arry[2] = {'0','0'};


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
    
    [collectionView registerClass:[themeWindowView class] forCellWithReuseIdentifier:string];
    
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
   
    _cell.button2.enabled = YES;
    _cell.button3.enabled = YES;
    _cell.button4.enabled = YES;
    
    _cell.button5.hidden = NO;
    _cell.button5.selected = NO;

    if (!_devicess) {
        
        _devicess = [[deviceMessage alloc]init];

    }
    
    _devicess.GATEWAY_NO = _dataCenter.gatewayNo;
    
    deviceMessage *device = [deviceMessageTool queryWithWindowsDevices:_devicess][indexPath.row];
    
    if (!_fonudDevice) {
        
        _fonudDevice = [[themeDeviceMessage  alloc]init];
        
    }
    
    _fonudDevice.theme_no = _dataCenter.theme_No;
    NSArray * foundDeviceArrar;
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

    
    // NSLog(@"%@",device.DEVICE_STATE);
    switch (device.DEVICE_TYPE_ID  ) {
            
        case 6:
            
            _fonudDevice.device_No = device.DEVICE_NO;
            
            foundDeviceArrar = [themeDeviceMessageTool queryWithThemeDevices:_fonudDevice];
            
             if (foundDeviceArrar.count ==0) {
                 
                 _cell.button5.selected = YES;
                 
                if ([device.DEVICE_STATE  isEqualToString:@"00"]) {//暂停
                    _cell.button3.enabled = NO;
                    
                }
                if ([device.DEVICE_STATE  isEqualToString:@"01"]) {//关
                    
                    _cell.button2.enabled = NO;
                    
                }
                
                if ([device.DEVICE_STATE  isEqualToString:@"10"]) {//开
                    _cell.button4.enabled = NO;
                }
             }else {
             
                 themeDeviceMessage  *themeDevice = foundDeviceArrar[0];
                 
                 if ([themeDevice.device_state_cmd  isEqualToString:@"00"]) {//暂停
                     _cell.button3.enabled = NO;
                     
                 }
                 if ([themeDevice.device_state_cmd  isEqualToString:@"01"]) {//关
                     
                     _cell.button2.enabled = NO;
                     
                 }
                 
                 if ([themeDevice.device_state_cmd  isEqualToString:@"10"]) {//开
                     _cell.button4.enabled = NO;
                 }

             
             }
            
            break;
        case 11:
            
            _fonudDevice.device_No = device.DEVICE_NO;
            
            foundDeviceArrar = [themeDeviceMessageTool queryWithThemeDevices:_fonudDevice];
            if (foundDeviceArrar.count ==0) {
             
                _cell.button5.selected = YES;
                if ([device.DEVICE_STATE  isEqualToString:@"00"]) {//暂停
                    _cell.button3.enabled = NO;
                    
                }
                if ([device.DEVICE_STATE  isEqualToString:@"01"]) {//关
                    _cell.button2.enabled = NO;
                }
                
                if ([device.DEVICE_STATE  isEqualToString:@"10"]) {//开
                    _cell.button4.enabled = NO;
                    
                }
            }else{
              
                themeDeviceMessage  *themeDevice = foundDeviceArrar[0];
                if ([themeDevice.device_state_cmd  isEqualToString:@"00"]) {//暂停
                    _cell.button3.enabled = NO;
                    
                }
                if ([themeDevice.device_state_cmd  isEqualToString:@"01"]) {//关
                    _cell.button2.enabled = NO;
                }
                
                if ([themeDevice.device_state_cmd  isEqualToString:@"10"]) {//开
                    _cell.button4.enabled = NO;
                    
                }

            }
            
            break;
            
    }
    
    //显示设备位置和设备名称
    //监听按钮点击事件
    [_cell.button5  addTarget:self action:@selector(checkBox:) forControlEvents:UIControlEventTouchUpInside];
    [_cell.button4  addTarget:self action:@selector(enterChangeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_cell.button3  addTarget:self action:@selector(enterChangeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_cell.button2  addTarget:self action:@selector(enterChangeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return _cell;
}
/**
 *  通过对号 查看是否在themedevice表中有次设备
 *
 *  @param btn
 */
- (void)checkBox:(UIButton *)btn {
   
    themeWindowView *cell = (themeWindowView *)[[[btn superview]superview]superview];//获取cell
    
    NSIndexPath *indexPathAll = [self.collectionView indexPathForCell:cell];//获取cell对应的section
    
    indexNum =indexPathAll.row;
    
    NSArray  *devices ;
    
    if ([_dataCenter.gatewayNo isEqualToString:@"0"] | !_dataCenter.gatewayNo ) {
        [MBProgressHUD  showError:@"请先添加网关"];
    }else{
        deviceMessage *device = [[deviceMessage alloc]init];
        device.GATEWAY_NO = _dataCenter.gatewayNo;
        devices=[deviceMessageTool queryWithWindowsDevices:device];
        
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
    
    [_collectionView  reloadData];

}

/**
 *  按钮监听事件
 *
 *  @param btn 点击的是哪个
 */
- (void)enterChangeButton:(UIButton *)btn {
    
    themeWindowView *cell = (themeWindowView *)[[[btn superview]superview]superview];//获取cell
    
    NSIndexPath *indexPathAll = [self.collectionView indexPathForCell:cell];//获取cell对应的section
    
    indexNum =indexPathAll.row;
   
    NSArray  *devices ;//=[deviceMessageTool  queryWithWindowsDevices];
    if ([_dataCenter.gatewayNo isEqualToString:@"0"] | !_dataCenter.gatewayNo ) {
        [MBProgressHUD  showError:@"请先添加网关"];
    }else{
        deviceMessage *device = [[deviceMessage alloc]init];
        device.GATEWAY_NO = _dataCenter.gatewayNo;
        devices=[deviceMessageTool queryWithWindowsDevices:device];
        
    }
    [MBProgressHUD  hideHUD];
    
    
    //取出当前cell的设备信息
    deviceMessage  *dev = devices[indexNum];
    
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
    
 
    btn.enabled = !btn.enabled;
    
    if (dev.DEVICE_TYPE_ID ==6) {
        switch (btn.tag) {
                
            case 400:
                
                if (!btn.enabled) {
                    
                    arry[0]='1';
                    arry[1]='0';
                    
                    UIButton *myButton1 = (UIButton *)[cell  viewWithTag:300];
                    
                    myButton1.enabled = YES;
                    UIButton *myButton2 = (UIButton *)[cell viewWithTag:200];
                    
                    
                    myButton2.enabled = YES;
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
                        
                        [themeDeviceMessageTool  updateThemeDeviceState:states];
                                   
                    }
                    
                }

                break;
                
            case 300:
                
                if (!btn.enabled) {
                    
                    arry[0]='0';
                    arry[1]='0';
                    UIButton *myButton1 = (UIButton *)[cell viewWithTag:400];
                    
                    myButton1.enabled = YES;
                    
                    
                    UIButton *myButton2 = (UIButton *)[cell viewWithTag:200];
                    myButton2.enabled = YES;
                    
                    NSString *arr1 =[self  transArryToStr:arry];
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
                    
                }
                
                break;
            case 200:
                if (!btn.enabled) {
                    
                    arry[0]='0';
                    arry[1]='1';
                    UIButton *myButton1 = (UIButton *)[cell viewWithTag:300];
                    
                    myButton1.enabled = YES;
                    
                    UIButton *myButton2 = (UIButton *)[cell viewWithTag:400];
                    
                    myButton2.enabled = YES;
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
                }
              
                break;
        }
        
    }
    
    if (dev.DEVICE_TYPE_ID ==11) {
        switch (btn.tag) {
                
            case 400:
                
                if (!btn.enabled) {
                    
                    arry[0]='1';
                    arry[1]='0';
                    UIButton *myButton1 = (UIButton *)[cell  viewWithTag:300];
                    
                    myButton1.enabled = YES;
                    
                    UIButton *myButton2 = (UIButton *)[cell viewWithTag:200];
                    myButton2.enabled = YES;
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
                }

                break;
                
            case 300:
                if (!btn.enabled) {
                    
                    arry[0]='0';
                    arry[1]='0';
                    UIButton *myButton1 = (UIButton *)[cell viewWithTag:400];
                    myButton1.enabled = YES;
                    UIButton *myButton2 = (UIButton *)[cell viewWithTag:200];
                    myButton2.enabled = YES;
                    NSString *arr1 =[self  transArryToStr:arry];
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
                    
                }

                break;
            case 200:
                if (!btn.enabled) {
                    
                    arry[0]='0';
                    arry[1]='1';
                    UIButton *myButton1 = (UIButton *)[cell viewWithTag:300];
                    
                    myButton1.enabled = YES;
                    UIButton *myButton2 = (UIButton *)[cell viewWithTag:400];
                    
                    myButton2.enabled = YES;
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
                }
               
                break;
        }
        
    }
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

-(BOOL)shouldAutorotate{
    return YES;
}



-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

@end
