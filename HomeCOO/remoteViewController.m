//
//  remoteViewController.m
//  HomeCOO
//
//  Created by tgbus on 16/7/8.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "remoteViewController.h"
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
#import "PrefixHeader.pch"
#import "productCollectionViewCell.h"
#import "deviceMessage.h"
#import "deviceMessageTool.h"
#import "deviceSpaceMessageModel.h"
#import "deviceSpaceMessageTool.h"
#import "MBProgressHUD+MJ.h"
#import "spaceMessageModel.h"
#import "spaceMessageTool.h"
#import "MainHomeVC.h"
#import "CustomVC.h"
#import "HCDaterView.h"
#import "CYMainHomeVC.h"
#import "themeInfraModel.h"
#import "themeInfraModelTools.h"
#import "themeDeviceMessageTool.h"
#import "themeDeviceMessage.h"
//底部空间、情景模式等按钮的高度
#define HOMECOOSPACEBUTTONHEIGHT 60

//底部空间、情景模式等按钮的宽度
#define HOMECOOSPACEBUTTONWIDTH [UIScreen  mainScreen].bounds.size.width / 5

//底部空间、情景模式等按钮Y的大小
#define  HOMECOOSPACEBUTTON_Y  [UIScreen  mainScreen].bounds.size.height - 55

//底部空间、情景模式等按钮字体的大小
#define HOMESPACEFONT 13

@interface remoteViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,HCDaterViewDelegate,UIAlertViewDelegate>

/**设置背景图片*/
@property(nonatomic,weak)  UIImageView  * fullscreenView;

/**设置导航栏*/
@property(nonatomic,weak)  UINavigationBar *navBar;

/**设置导航栏*/
@property(nonatomic,strong)  HCDaterView *showView;



/**UICollectionView 容器*/
@property (strong, nonatomic)  UICollectionView *collectionView;

/**设备cell */
@property(nonatomic,strong) productCollectionViewCell *cell;

@property(nonatomic,strong) LZXDataCenter *dataCenter;
@property(nonatomic,strong) deviceSpaceMessageModel *deviceSpace;
@property(nonatomic,strong) spaceMessageModel *deviceNameModel;
@property(nonatomic,strong) themeInfraModel *delThemeInfra;
@property(nonatomic,strong) themeDeviceMessage *foundThemeDevice;
@property(nonatomic,strong) themeDeviceMessage *delThemeDevice;
@property(nonatomic,strong) NSArray * devices;
@end

@implementation remoteViewController
static  NSInteger indexNum;
static NSString *string = @"productCollectionViewCell";
-(NSArray *)devices
{
    //if (_devices==nil) {
        
        themeInfraModel *device = [[themeInfraModel alloc]init];
        
        LZXDataCenter *dataCenter = [LZXDataCenter defaultDataCenter];
        
        device.themeNo = dataCenter.theme_No;
        device.gatewayNo = dataCenter.gatewayNo;
        
        _devices = [themeInfraModelTools querWithInfraThemes:device];

        
    //}
    
    return _devices;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    LZXDataCenter *dataCenter = [LZXDataCenter defaultDataCenter];
    self.dataCenter = dataCenter;
    //设置背景
    [self setFullscreenView];
    
    [self  setWhiteBackground];
    
    [self setupNewRemote];
    
    //添加aUICollectionView
    [self  addUICollectionView];
   
}
/**
 *  点击按钮添加新网关
 */
-(void)setupNewRemote{
    
    UIButton  *setupGatewayBtn = [[UIButton  alloc]init];
    
    CGFloat setupGatewayBtnX =20;
    CGFloat setupGatewayBtnY =55;
    CGFloat setupGatewayBtnW =130;
    CGFloat setupGatewayBtnH =30;
    
    setupGatewayBtn.frame = CGRectMake(setupGatewayBtnX, setupGatewayBtnY, setupGatewayBtnW, setupGatewayBtnH);
    [setupGatewayBtn  setTitle:@"+请按此处添加遥控" forState:UIControlStateNormal];
    [setupGatewayBtn  setTitle:@"+请按此处添加遥控" forState:UIControlStateHighlighted];
    [setupGatewayBtn  setTitleColor:[UIColor  blackColor] forState:UIControlStateNormal];
    [setupGatewayBtn  setTitleColor:[UIColor  orangeColor] forState:UIControlStateHighlighted];
    //setupGatewayBtn.backgroundColor = [UIColor  redColor];
    //[setupGatewayBtn  setFont:[UIFont  systemFontOfSize:13]];
    setupGatewayBtn.titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:13];
    
    [setupGatewayBtn  addTarget:self action:@selector(setupNewRemoteAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.fullscreenView  addSubview:setupGatewayBtn];
}

-(void)setupNewRemoteAction{

//    MainHomeVC *mainVC = [[MainHomeVC alloc] init];
//    CustomNavVC *navVC = [[CustomNavVC alloc] initWithRootViewController:mainVC];
    //[self  presentViewController:navVC animated:YES completion:nil];
    _dataCenter.controlFlag =2;
    CYMainHomeVC *mainVC = [[CYMainHomeVC alloc] init];
    CustomNavVC *navVC = [[CustomNavVC alloc] initWithRootViewController:mainVC];
    
    [self  presentViewController:navVC animated:YES completion:nil];
   

}
/**
 *  添加UICollectionView 来显示所有的照明设备
 */
-(void)addUICollectionView{
    
    CGFloat  collectionViewX = 10 ;
    CGFloat  collectionViewY = 80 ;
    CGFloat  collectionViewW = [UIScreen mainScreen].bounds.size.width - 20;
    CGFloat  collectionViewH = [UIScreen  mainScreen].bounds.size.height -160;
    //确定是水平滚动，还是垂直滚动
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    UICollectionView  *collectionView = [[UICollectionView  alloc]initWithFrame:CGRectMake(collectionViewX, collectionViewY, collectionViewW, collectionViewH) collectionViewLayout:flowLayout];
    
    collectionView.bounces = NO;//没有效果
    
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
    

//    themeInfraModel *device = [[themeInfraModel alloc]init];
//    
//    device.themeNo = _dataCenter.theme_No;
//    device.gatewayNo = _dataCenter.gatewayNo;
//    NSArray *deviceArray = [themeInfraModelTools querWithInfraThemes:device];
//    NSInteger count ;
//    
//    if (deviceArray.count!=0) {
//       
//        count =deviceArray.count;
//    }

    return  self.devices.count;

}


//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    _cell = [collectionView dequeueReusableCellWithReuseIdentifier:string forIndexPath:indexPath];
   
//    themeInfraModel *devicess = [[themeInfraModel alloc]init];
//    
//    devicess.themeNo = _dataCenter.theme_No;
//    devicess.gatewayNo = _dataCenter.gatewayNo;
//    themeInfraModel * device =  [themeInfraModelTools querWithInfraThemes:devicess][indexPath.row];
    
    themeInfraModel * device =self.devices[indexPath.row];
    if (_deviceSpace==nil) {
        _deviceSpace = [[deviceSpaceMessageModel alloc]init];
        
    }
    
    _deviceSpace.device_no = device.deviceNo;
    _deviceSpace.phone_num = _dataCenter.userPhoneNum;
    
    NSArray *deviceSpaceArry = [deviceSpaceMessageTool queryWithspacesDeviceNoAndPhonenum:_deviceSpace];
    
    if (deviceSpaceArry.count ==0) {
        
        _cell.deviceMessageLable.text =[NSString  stringWithFormat:@"  位置待定/%@",device.infraControlName];
    }else{
        
        deviceSpaceMessageModel *device_Name = deviceSpaceArry[0];
        if (_deviceNameModel==nil) {
            _deviceNameModel = [[spaceMessageModel  alloc]init];

        }
        
        _deviceNameModel.space_Num = device_Name.space_no;
        
        NSArray *devicePostion = [spaceMessageTool queryWithspacesDevicePostion:_deviceNameModel];
        
        spaceMessageModel *deviceName;
        
        if (devicePostion.count ==0) {
            
        }else{
            
            deviceName = devicePostion[0];
        }
        
        //显示设备位置和设备名称
        _cell.deviceMessageLable.text =[NSString  stringWithFormat:@"  %@/%@",deviceName.space_Name,device.infraControlName];
        
        
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
    
//    themeInfraModel *devicess = [[themeInfraModel alloc]init];
//    
//    devicess.themeNo = _dataCenter.theme_No;
//    devicess.gatewayNo = _dataCenter.gatewayNo;
//    themeInfraModel *device = [themeInfraModelTools querWithInfraThemes:devicess][indexNum];
     themeInfraModel *device = self.devices[indexNum];
    _dataCenter.remoteIEEAddress = device.deviceNo;
   
    NSArray *tempArray = @[@"遥控设置",@"遥控删除",];
    
    self.showView.titleArray = tempArray;
    
    self.showView.title = @"遥控管理";
    
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
    CYMainHomeVC *mainVC = [[CYMainHomeVC alloc] init];
    CustomNavVC *navVC = [[CustomNavVC alloc] initWithRootViewController:mainVC];
    switch (daterView.currentIndexPath.row) {
            
        case 0:
            //遥控配置
           
            [self  presentViewController:navVC animated:YES completion:nil];
            [self.showView hiddenInView:self.view animated:YES];
            
            break;
            
        case 1:
            //删除遥控
            [self deleteRemote];
            break;
            
    }
    
}
/**
 *  提醒用户是否需要删除网关设备
 */
-(void)deleteRemote{
    
    
    [self.showView  hiddenInView:self.view animated:YES];
    
    UIAlertView * alert = [[UIAlertView  alloc]initWithTitle:@"温馨提示" message:@"确定要删除此遥控设置吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
   
    [alert show];
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [_showView  hiddenInView:self.view animated:YES];


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
    
    CGFloat  WhiteBackgroundLableX = 10 ;
    CGFloat  WhiteBackgroundLableY = 60 ;
    CGFloat  WhiteBackgroundLableW = [UIScreen mainScreen].bounds.size.width - 20;
    CGFloat  WhiteBackgroundLableH = [UIScreen  mainScreen].bounds.size.height -130;
    WhiteBackgroundLable.frame = CGRectMake(WhiteBackgroundLableX, WhiteBackgroundLableY, WhiteBackgroundLableW, WhiteBackgroundLableH);
    
    WhiteBackgroundLable.backgroundColor = [UIColor  whiteColor];
    
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

#pragma mark UIAlertView-delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
  
    
    if(buttonIndex ==1){//点击的是确定按键
        
       
//        themeInfraModel *devicess = [[themeInfraModel alloc]init];
//        
//        devicess.themeNo = _dataCenter.theme_No;
//        devicess.gatewayNo = _dataCenter.gatewayNo;
//        themeInfraModel *device = [themeInfraModelTools querWithInfraThemes:devicess][indexNum];
        
        themeInfraModel *device = self.devices[indexNum];
        if (_delThemeInfra==nil) {
            
            _delThemeInfra = [[themeInfraModel alloc]init];

        }
       
        _delThemeInfra.deviceNo = device.deviceNo;
        _delThemeInfra.themeNo = device.themeNo;
        _delThemeInfra.infraType_ID = device.infraType_ID;
        
        [themeInfraModelTools deleteThemeInfraDevice:_delThemeInfra];
        
        if (_foundThemeDevice==nil) {
            _foundThemeDevice = [[themeDeviceMessage alloc]init];
        }
        
        _foundThemeDevice.device_No =device.deviceNo;
        
        _foundThemeDevice.theme_no = device.themeNo;
        _foundThemeDevice.infra_type_ID = device.infraType_ID;
        
    
        NSArray *foundThemeDeviceArray =   [themeDeviceMessageTool queryWithThemeDevicesOnlyForInfra:_foundThemeDevice];
        
        if (_delThemeDevice==nil) {
            _delThemeDevice = [[themeDeviceMessage alloc]init];

        }
        
        
        _delThemeDevice.device_No =device.deviceNo;
        
        _delThemeDevice.theme_no = device.themeNo;
        _delThemeDevice.infra_type_ID = device.infraType_ID;
        
        if (foundThemeDeviceArray.count!=0) {
            
            [themeDeviceMessageTool deleteThemeDeviceOnlyForInfra:_delThemeDevice];
            
        }
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            
//        
//        });
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)),
//                       dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                           
                            [self.collectionView reloadData];
                           
                       //});
       
    }
        
}

-(void)viewWillAppear:(BOOL)animated{

    [self.collectionView reloadData];

}
-(BOOL)shouldAutorotate{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskLandscape;
    
}
@end
