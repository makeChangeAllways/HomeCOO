//
//  SecurityViewController.m
//  HomeCOO
//
//  Created by tgbus on 16/5/3.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "SecurityViewController.h"
#import "AppDelegate.h"
#import "SystemViewController.h"
#import "SpaceViewController.h"
#import "ThemeViewController.h"
#import "SettingViewController.h"
#import "MethodClass.h"
#import "MBProgressHUD+MJ.h"
#import "deviceMessage.h"
#import "deviceMessageTool.h"
#import "LZXDataCenter.h"
#import "MBProgressHUD+MJ.h"
#import "ControlMethods.h"


/**底部空间、情景模式等按钮的高度*/
#define HOMECOOSPACEBUTTONHEIGHT 60

/**底部空间、情景模式等按钮的宽度*/
#define HOMECOOSPACEBUTTONWIDTH [UIScreen  mainScreen].bounds.size.width / 5

/**底部空间、情景模式等按钮Y的大小*/
#define  HOMECOOSPACEBUTTON_Y  [UIScreen  mainScreen].bounds.size.height - 55

/**底部空间、情景模式等按钮字体的大小*/
#define HOMESPACEFONT 13

/**室内布防（撤防）距离左边屏幕的距离*/
#define   HOMECOOINDOOPREVENTX  [UIScreen  mainScreen].bounds.size.width / 4.5


/**室内布防（室外撤防）距离顶部屏幕的距离*/
#define  HOMECOOINDOOPREVENTY  [UIScreen  mainScreen].bounds.size.height / 3

/**室内布防和室外布防的距离*/
#define  HOMECOOGAPDISTANCE 20

/**室内布防和室内撤防的距离*/
#define  HOMECOOARRANGEANDCANCELGAPDISTANCE 10

/**室内布防(室内撤防、室外布防、室外撤防的宽度)*/
#define  HOMECOOSECURITYWIDTH  [UIScreen  mainScreen].bounds.size.width / 4

/**室内布防(室内撤防、室外布防、室外撤防的高度)*/
#define  HOMECOOSECURITYHEIGHT  45

@interface SecurityViewController ()


/**设置背景图片*/
@property(nonatomic,weak)  UIImageView  * fullscreenView;

/**设置导航栏*/
@property(nonatomic,weak)  UINavigationBar *navBar;

/**设置背景底色*/
@property(nonatomic,weak) UILabel  *WhiteBackgroundLable;

/**室内布防*/
@property(nonatomic,weak) UIButton *indoorArrangementPreventionBtn;

/**室内撤防*/
@property(nonatomic,weak) UIButton *indoorCancelPreventionBtn;

/**室外布防*/
@property(nonatomic,weak) UIButton *outdoorArrangementPreventionBtn;

/**室外撤防*/
@property(nonatomic,weak) UIButton *outdoorCancelPreventionBtn;

/**室内的安防设备*/
@property(nonatomic,strong)  NSArray *Indoordevices;

/**室外的安防设备*/
@property(nonatomic,strong)  NSArray *Outdoordevices;

@end

@implementation SecurityViewController


-(NSArray*)Indoordevices{
    
    if (_Indoordevices==nil) {
        
        LZXDataCenter *dataCenter = [LZXDataCenter defaultDataCenter];
        
        if ([dataCenter.gatewayNo isEqualToString:@"0"] | !dataCenter.gatewayNo ) {
            
            [MBProgressHUD  showError:@"请先添加网关"];
            
        }else{
            
            deviceMessage *device = [[deviceMessage alloc]init];
            
            device.GATEWAY_NO = dataCenter.gatewayNo;
            
            _Indoordevices=[deviceMessageTool queryWithSecurityDevices:device];
            
        }
        [MBProgressHUD  hideHUD];
        
    }
    
    return _Indoordevices;
}

-(NSArray*)Outdoordevices{
    
    if (_Outdoordevices==nil) {
        
        LZXDataCenter *dataCenter = [LZXDataCenter defaultDataCenter];
        
        if ([dataCenter.gatewayNo isEqualToString:@"0"] | !dataCenter.gatewayNo ) {
            
            [MBProgressHUD  showError:@"请先添加网关"];
            
        }else{
            
            deviceMessage *device = [[deviceMessage alloc]init];
            
            device.GATEWAY_NO = dataCenter.gatewayNo;
            
            _Outdoordevices=[deviceMessageTool queryWithOutdoorSecurityDevices:device];
            
        }
        [MBProgressHUD  hideHUD];
        
    }
    
    return _Outdoordevices;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //创建一个导航栏
    [self setNavBar];
    
    //设置底片背景
    [self  setWhiteBackground];
    
    //室内布防
    [self  indoorArrangementPrevention];
    
    //室内撤防
    [self  indoorCancelPrevention];
    
    //室外布防
    [self outdoorArrangementPrevention];
    
    //室外撤防
    [self outdoorCancelPrevention];
    
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
    self.WhiteBackgroundLable = WhiteBackgroundLable ;
    
    [self.fullscreenView addSubview:WhiteBackgroundLable];

}

/**
 *室内布防
 */

-(void)indoorArrangementPrevention{

    UIButton *indoorArrangementPreventionBtn = [[UIButton alloc]init];
    
    CGFloat indoorArrangementPreventionBtnX = HOMECOOINDOOPREVENTX;
    CGFloat indoorArrangementPreventionBtnY = HOMECOOINDOOPREVENTY;
    CGFloat indoorArrangementPreventionBtnW = HOMECOOSECURITYWIDTH;
    CGFloat indoorArrangementPreventionBtnH = HOMECOOSECURITYHEIGHT;
    indoorArrangementPreventionBtn.frame = CGRectMake(indoorArrangementPreventionBtnX, indoorArrangementPreventionBtnY, indoorArrangementPreventionBtnW, indoorArrangementPreventionBtnH);
    [indoorArrangementPreventionBtn  setImage:[UIImage imageNamed:@"室内布防.png"] forState:UIControlStateNormal];
    [indoorArrangementPreventionBtn  setImage:[UIImage  imageNamed:@"室内布防_over.png"] forState:UIControlStateDisabled];
    indoorArrangementPreventionBtn.contentMode = UIViewContentModeScaleToFill;
    self.indoorArrangementPreventionBtn = indoorArrangementPreventionBtn;
    
    //indoorArrangementPreventionBtn.backgroundColor = [UIColor  redColor];
    [indoorArrangementPreventionBtn.layer setCornerRadius:8.0];
    [indoorArrangementPreventionBtn  addTarget:self action:@selector(indoorArrangementPreventionAction) forControlEvents:UIControlEventTouchUpInside];
    [self.fullscreenView  addSubview:indoorArrangementPreventionBtn];
    

}
/**
 *室内布防成功
 */

-(void)indoorArrangementPreventionAction{

    self.indoorArrangementPreventionBtn.enabled = NO;
    self.indoorCancelPreventionBtn.enabled = YES;
   
    [self  indoorSecurityFinshed];
}
/**
 *  室内布防成功
 */
-(void)indoorSecurityFinshed{
    
    NSArray *SecurityArray = self.Indoordevices;
    
    NSInteger count = SecurityArray.count;
     deviceMessage *updateDeviceState = [[deviceMessage  alloc]init];
    if (count == 0) {
        
        [MBProgressHUD  showError:@"请先添加室内设备"];
       
    }else{
    
        for (int  i = 0; i < count; i ++) {
            
            deviceMessage  *device = SecurityArray[i];
            
            NSString *gatewayNo = device.GATEWAY_NO;
            NSString *deviceNo = device.DEVICE_NO;
            
            NSInteger  deviceTypeId = device.DEVICE_TYPE_ID;
           
            updateDeviceState.DEVICE_NO = device.DEVICE_NO;
            updateDeviceState.GATEWAY_NO = device.GATEWAY_NO;
            updateDeviceState.DEVICE_STATE = @"11000000";
            [deviceMessageTool  updateDeviceState:updateDeviceState];
            
            //GCD延时
            dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),
                               queue, ^{
                                   
                                   [ControlMethods  indoorAndOutdoorSecurity:gatewayNo deviceNo:deviceNo deviceTypeId:deviceTypeId data:@"11"];
                                  
                               });
            }
            
        
        [MBProgressHUD  showSuccess:@"室内布防成功"];
        
      
        
    }
    
    [MBProgressHUD  hideHUD];
    

       
}




/**
 *室内撤防
 */

-(void)indoorCancelPrevention{
    
    UIButton *indoorCancelPreventionBtn = [[UIButton alloc]init];
    
    CGFloat indoorCancelPreventionBtnX = HOMECOOINDOOPREVENTX;
    CGFloat indoorCancelPreventionBtnY =CGRectGetMaxY(self.indoorArrangementPreventionBtn.frame)+HOMECOOARRANGEANDCANCELGAPDISTANCE;

    CGFloat indoorCancelPreventionBtnW = HOMECOOSECURITYWIDTH;
    CGFloat indoorCancelPreventionBtnH = HOMECOOSECURITYHEIGHT;
    indoorCancelPreventionBtn.frame = CGRectMake(indoorCancelPreventionBtnX, indoorCancelPreventionBtnY, indoorCancelPreventionBtnW, indoorCancelPreventionBtnH);
    [indoorCancelPreventionBtn  setImage:[UIImage imageNamed:@"室内撒防.png"] forState:UIControlStateNormal];
    [indoorCancelPreventionBtn  setImage:[UIImage  imageNamed:@"室内撒防_over"] forState:UIControlStateDisabled];
    indoorCancelPreventionBtn.contentMode = UIViewContentModeScaleToFill;
    self.indoorCancelPreventionBtn = indoorCancelPreventionBtn;

    //indoorCancelPreventionBtn.backgroundColor = [UIColor  redColor];
    [indoorCancelPreventionBtn.layer setCornerRadius:8.0];
    [indoorCancelPreventionBtn  addTarget:self action:@selector(indoorCancelPreventionAction) forControlEvents:UIControlEventTouchUpInside];
    [self.fullscreenView  addSubview:indoorCancelPreventionBtn];
    
    
}
/**
 *室内撤防成功
 */

-(void)indoorCancelPreventionAction{
    self.indoorArrangementPreventionBtn.enabled = YES;
    self.indoorCancelPreventionBtn.enabled = NO;
    
    [self  indoorUnSecurityFinshed];
}
/**
 *  室内撤防成功
 */
-(void)indoorUnSecurityFinshed{
    
    NSArray *SecurityArray = self.Indoordevices;
    
    NSInteger count = SecurityArray.count;
    deviceMessage *updateDeviceState = [[deviceMessage  alloc]init];
    if (count == 0) {
        
        [MBProgressHUD  showError:@"请先添加室内设备"];
        
    }else{
    
        for (int  i = 0; i < count; i ++) {
            
            
            deviceMessage  *device = SecurityArray[i];
            
            NSString *gatewayNo = device.GATEWAY_NO;
            NSString *deviceNo = device.DEVICE_NO;
            
            NSInteger  deviceTypeId = device.DEVICE_TYPE_ID;
           
            
            updateDeviceState.DEVICE_NO = device.DEVICE_NO;
            updateDeviceState.GATEWAY_NO = device.GATEWAY_NO;
            updateDeviceState.DEVICE_STATE = @"10000000";
            [deviceMessageTool  updateDeviceState:updateDeviceState];
            
            //GCD延时
            dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),
                           queue, ^{
                               
                               [ControlMethods  indoorAndOutdoorSecurity:gatewayNo deviceNo:deviceNo deviceTypeId:deviceTypeId data:@"10"];
                               [NSThread  sleepForTimeInterval:10  ];
                           });
        }
    
        [MBProgressHUD  showSuccess:@"室内撤防成功"];

    }
    
    [MBProgressHUD  hideHUD];
}




/**
 *室外布防
 */

-(void)outdoorArrangementPrevention{
    
    UIButton *outdoorArrangementPreventionBtn = [[UIButton alloc]init];
    
    CGFloat outdoorArrangementPreventionBtnX = CGRectGetMaxX(self.indoorArrangementPreventionBtn.frame) + HOMECOOGAPDISTANCE;
    CGFloat outdoorArrangementPreventionBtnY = HOMECOOINDOOPREVENTY;
    CGFloat outdoorArrangementPreventionBtnW = HOMECOOSECURITYWIDTH;
    CGFloat outdoorArrangementPreventionBtnH = HOMECOOSECURITYHEIGHT;
    outdoorArrangementPreventionBtn.frame = CGRectMake(outdoorArrangementPreventionBtnX, outdoorArrangementPreventionBtnY, outdoorArrangementPreventionBtnW, outdoorArrangementPreventionBtnH);
    [outdoorArrangementPreventionBtn  setImage:[UIImage imageNamed:@"室外布防.png"] forState:UIControlStateNormal];
    [outdoorArrangementPreventionBtn  setImage:[UIImage  imageNamed:@"室外布防_over.png"] forState:UIControlStateDisabled];
    outdoorArrangementPreventionBtn.contentMode = UIViewContentModeScaleToFill;
    self.outdoorArrangementPreventionBtn = outdoorArrangementPreventionBtn;
    
    //indoorArrangementPreventionBtn.backgroundColor = [UIColor  redColor];
    [outdoorArrangementPreventionBtn.layer setCornerRadius:8.0];
    [outdoorArrangementPreventionBtn  addTarget:self action:@selector(outdoorArrangementPreventionAction) forControlEvents:UIControlEventTouchUpInside];
    [self.fullscreenView  addSubview:outdoorArrangementPreventionBtn];
    
    
}
/**
 *室外布防成功
 */

-(void)outdoorArrangementPreventionAction{
    self.outdoorArrangementPreventionBtn.enabled = NO;
    self.outdoorCancelPreventionBtn.enabled = YES;
    
    [self  outdoorSecurityFinshed];
}

/**
 *  室外布防成功
 */
-(void)outdoorSecurityFinshed{

    NSArray *SecurityArray = self.Outdoordevices;
    
    NSInteger count = SecurityArray.count;
    deviceMessage *updateDeviceState = [[deviceMessage  alloc]init];
    
    if (count == 0) {
        
        [MBProgressHUD  showError:@"请先添加室外设备"];
        
    }else{
    
        for (int  i = 0; i < count; i ++) {
            
            
            deviceMessage  *device = SecurityArray[i];
            
            NSString *gatewayNo = device.GATEWAY_NO;
            NSString *deviceNo = device.DEVICE_NO;
            
            NSInteger  deviceTypeId = device.DEVICE_TYPE_ID;
            updateDeviceState.DEVICE_NO = device.DEVICE_NO;
            updateDeviceState.GATEWAY_NO = device.GATEWAY_NO;
            updateDeviceState.DEVICE_STATE = @"11000000";
            [deviceMessageTool  updateDeviceState:updateDeviceState];
            
            //GCD延时
            dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),
                           queue, ^{
                               
                               [ControlMethods  indoorAndOutdoorSecurity:gatewayNo deviceNo:deviceNo deviceTypeId:deviceTypeId data:@"11"];
                               
                           });
        }

        [MBProgressHUD  showSuccess:@"室外布防成功"];
        
    }
    
    [MBProgressHUD  hideHUD];
}




/**
 *室外撤防
 */

-(void)outdoorCancelPrevention{
    
    UIButton *outdoorCancelPreventionBtn = [[UIButton alloc]init];
    
    CGFloat indoorArrangementPreventionBtnX = CGRectGetMaxX(self.indoorCancelPreventionBtn.frame) + HOMECOOGAPDISTANCE;

    CGFloat indoorArrangementPreventionBtnY =CGRectGetMaxY(self.outdoorArrangementPreventionBtn.frame)+HOMECOOARRANGEANDCANCELGAPDISTANCE;
    
    CGFloat indoorArrangementPreventionBtnW = HOMECOOSECURITYWIDTH;
    CGFloat indoorArrangementPreventionBtnH = HOMECOOSECURITYHEIGHT;
    outdoorCancelPreventionBtn.frame = CGRectMake(indoorArrangementPreventionBtnX, indoorArrangementPreventionBtnY, indoorArrangementPreventionBtnW, indoorArrangementPreventionBtnH);
    [outdoorCancelPreventionBtn  setImage:[UIImage imageNamed:@"室外撒防.png"] forState:UIControlStateNormal];
    [outdoorCancelPreventionBtn  setImage:[UIImage  imageNamed:@"室外撒防_over.png"] forState:UIControlStateDisabled];
    outdoorCancelPreventionBtn.contentMode = UIViewContentModeScaleToFill;
    self.outdoorCancelPreventionBtn = outdoorCancelPreventionBtn;
    
    //indoorCancelPreventionBtn.backgroundColor = [UIColor  redColor];
    [outdoorCancelPreventionBtn.layer setCornerRadius:8.0];
    [outdoorCancelPreventionBtn  addTarget:self action:@selector(outdoorCancelPreventionAction) forControlEvents:UIControlEventTouchUpInside];
    [self.fullscreenView  addSubview:outdoorCancelPreventionBtn];
    
    
}
/**
 *室外撤防成功
 */

-(void)outdoorCancelPreventionAction{
    
    self.outdoorCancelPreventionBtn.enabled = NO;
    self.outdoorArrangementPreventionBtn.enabled = YES;
   
    [self   outdoorsUnecurityFinshed];
}

/**
 *  室外撤防成功
 */
-(void)outdoorsUnecurityFinshed{
    
    NSArray *SecurityArray = self.Outdoordevices;
    
    NSInteger count = SecurityArray.count;
    deviceMessage *updateDeviceState = [[deviceMessage  alloc]init];
    
    if (count == 0) {
        
        [MBProgressHUD  showError:@"请先添加室外设备"];
        
    }else{
    
        for (int  i = 0; i < count; i ++) {
            
            
            deviceMessage  *device = SecurityArray[i];
            
            NSString *gatewayNo = device.GATEWAY_NO;
            NSString *deviceNo = device.DEVICE_NO;
            
            NSInteger  deviceTypeId = device.DEVICE_TYPE_ID;
            
            updateDeviceState.DEVICE_NO = device.DEVICE_NO;
            updateDeviceState.GATEWAY_NO = device.GATEWAY_NO;
            updateDeviceState.DEVICE_STATE = @"10000000";
            [deviceMessageTool  updateDeviceState:updateDeviceState];
            
            //GCD延时
            dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),
                           queue, ^{
                               
                               [ControlMethods  indoorAndOutdoorSecurity:gatewayNo deviceNo:deviceNo deviceTypeId:deviceTypeId data:@"10"];
                               
                           });
        }
    
        [MBProgressHUD  showSuccess:@"室外撤防成功"];
        
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
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"防区管理"];
    
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
    
    
    SystemViewController  *vc = [[SystemViewController alloc]init];
    
    [self  presentViewController:vc animated:YES completion:nil];
    
    
}


/**
 *退出系统
 */
-(void)exitAction{
    UIAlertView * alert = [[UIAlertView  alloc]initWithTitle:@"温馨提示" message:@"确定要退出HomeCOO系统吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert show];
    
}
-(BOOL)shouldAutorotate{
    return YES;
}



-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}


@end
