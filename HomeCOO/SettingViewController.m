//
//  SettingViewController.m
//  HomeCOO
//
//  Created by tgbus on 16/5/3.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "SettingViewController.h"
#import "AppDelegate.h"
#import "SystemViewController.h"
#import "SpaceViewController.h"
#import "ThemeViewController.h"
#import "SecurityViewController.h"
#import "MethodClass.h"
#import "gatewaySettingController.h"
#import "spaceAdministrationController.h"
#import "productAdministrationController.h"
#import "ThemeAdministrationController.h"
#import "linkageController.h"
#import "SystemSettingController.h"
#import "SettingTimeControl.h"
#import "LZXDataCenter.h"
#import "MBProgressHUD+MJ.h"
/**底部空间、情景模式等按钮的高度*/
#define HOMECOOSPACEBUTTONHEIGHT 60

/**底部空间、情景模式等按钮的宽度*/
#define HOMECOOSPACEBUTTONWIDTH [UIScreen  mainScreen].bounds.size.width / 5

/**底部空间、情景模式等按钮Y的大小*/
#define  HOMECOOSPACEBUTTON_Y  [UIScreen  mainScreen].bounds.size.height - 55

/**底部空间、情景模式等按钮字体的大小*/
#define HOMESPACEFONT 13

/**产品管理按钮按钮距离屏幕左边的距离*/
#define HOMECOOEDGEDISTANCE [UIScreen  mainScreen].bounds.size.width / 5.3

/**产品管理按钮按钮距离屏幕上边的距离*/
#define HOMECOOTOPDISTANCE   [UIScreen  mainScreen].bounds.size.height / 5

/**产品管理按钮按钮的宽度*/
#define HOMECOOBUTTONWIDTH   [UIScreen  mainScreen].bounds.size.width / 3.5

/**产品管理按钮按钮的高度*/
#define HOMECOOBUTTONHEIGHT  40

/**产品管理按钮之间的距离*/
#define HOMECOOPRODUCTIONBUTTONDISTANCE  10

/**产品管理按钮左边栏与右边栏之间的距离*/
#define HOMECOOLEFTANDRIGHTGAP 40

/**按钮上字体大小*/
#define HOMECOOBUTTONFONT 16
@interface SettingViewController ()


/**设置背景图片*/
@property(nonatomic,weak)  UIImageView  * fullscreenView;

/**设置导航栏*/
@property(nonatomic,weak)  UINavigationBar *navBar;

/**产品管理button*/
@property(nonatomic,weak)  UIButton  *productManagementBtn ;

/**空间管理button*/
@property(nonatomic,weak)  UIButton  *spaceManagementBtn;

/**联动设置button*/
@property(nonatomic,weak)  UIButton  *linkageSettingBtn;

/**情景管理button*/
@property(nonatomic,weak)  UIButton  *lthemeManagementBtn;

/**定时设置button*/
@property(nonatomic,weak)  UIButton  *timerSettingBtn;

/**网关设置button*/
@property(nonatomic,weak)  UIButton  *gatewaySettingBtn;

/**系统设置button*/
@property(nonatomic,weak)  UIButton  *systemSettingBtn;

@property(nonatomic,strong) LZXDataCenter *dataCenter ;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //创建一个导航栏
    [self setNavBar];
    
    //设置底片背景
    //[self  setWhiteBackground];
    LZXDataCenter *dataCenter = [LZXDataCenter defaultDataCenter];
    
    self.dataCenter = dataCenter;
    //添加产品管理
    [self  productManagement];
    
    //添加空间管理
    [self  spaceManagement];
    
    //添加联动是设置
    [self  linkageSetting];
    
    //添加情景管理
    [self  themeManagement];
    
    //添加定时设置
    [self  timerSetting];
    
    //添加网关设置
    [self  gatewaySetting];
    
    //添加系统设置
    [self  systemSetting];
    
}


/**
 *添加产品管理
 */


-(void)productManagement{

    //创建一个产品管理button
    UIButton  *productManagementBtn = [[UIButton  alloc]init];
    
    CGFloat productManagementBtnX = HOMECOOEDGEDISTANCE;
    CGFloat productManagementBtnY = HOMECOOTOPDISTANCE;
    CGFloat productManagementBtnW = HOMECOOBUTTONWIDTH;
    CGFloat productManagementBtnH = HOMECOOBUTTONHEIGHT;
    
    productManagementBtn.frame = CGRectMake(productManagementBtnX, productManagementBtnY, productManagementBtnW, productManagementBtnH);
    self.productManagementBtn = productManagementBtn;
    [productManagementBtn setBackgroundImage:[UIImage  imageNamed:@"设置按钮.png"] forState:UIControlStateNormal];
    [productManagementBtn  setBackgroundImage:[UIImage  imageNamed:@"设置按钮.png"] forState:UIControlStateHighlighted];
    
    [productManagementBtn  setTitle:@"产品管理" forState:UIControlStateNormal];
    [productManagementBtn  setTitle:@"产品管理" forState:UIControlStateHighlighted];
    //[productManagementBtn setFont:HOMECOOBUTTONFONT];
    productManagementBtn.titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:HOMECOOBUTTONFONT];
    
    [productManagementBtn setTitleColor:[UIColor  blackColor] forState:UIControlStateNormal];
    [productManagementBtn setTitleColor:[UIColor  orangeColor] forState:UIControlStateHighlighted];
    

    //监听按钮点击事件
    [productManagementBtn  addTarget:self action:@selector(productManagementAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.fullscreenView  addSubview:productManagementBtn];
    



}
/**
 *进入产品管理中心
 */
-(void)productManagementAction{

    productAdministrationController  *backVC = [[productAdministrationController  alloc]init];
    [self  presentViewController:backVC animated:YES completion:nil];
    


}


/**
 *添加空间管理
 */

-(void)spaceManagement{
    
    //创建一个空间管理button
    UIButton  *spaceManagementBtn = [[UIButton  alloc]init];
    
    CGFloat spaceManagementBtnX = HOMECOOEDGEDISTANCE;
    CGFloat spaceManagementBtnY = CGRectGetMaxY (self.productManagementBtn.frame) + HOMECOOPRODUCTIONBUTTONDISTANCE;
    CGFloat spaceManagementBtnW = HOMECOOBUTTONWIDTH ;
    CGFloat spaceManagementBtnH = HOMECOOBUTTONHEIGHT;
    
    spaceManagementBtn.frame = CGRectMake(spaceManagementBtnX, spaceManagementBtnY, spaceManagementBtnW, spaceManagementBtnH);
    self.spaceManagementBtn = spaceManagementBtn;
    [spaceManagementBtn setBackgroundImage:[UIImage  imageNamed:@"设置按钮.png"] forState:UIControlStateNormal];
    [spaceManagementBtn  setBackgroundImage:[UIImage  imageNamed:@"设置按钮.png"] forState:UIControlStateHighlighted];
    
    [spaceManagementBtn  setTitle:@"空间管理" forState:UIControlStateNormal];
    [spaceManagementBtn  setTitle:@"空间管理" forState:UIControlStateHighlighted];
   // [spaceManagementBtn setFont:HOMECOOBUTTONFONT];
    spaceManagementBtn.titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:HOMECOOBUTTONFONT];
    [spaceManagementBtn setTitleColor:[UIColor  blackColor] forState:UIControlStateNormal];
    [spaceManagementBtn setTitleColor:[UIColor  orangeColor] forState:UIControlStateHighlighted];
    

    //监听按钮点击事件
    [spaceManagementBtn  addTarget:self action:@selector(spaceManagementAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.fullscreenView  addSubview:spaceManagementBtn];
    
    
    
    
}
/**
 *进入空间管理中心
 */
-(void)spaceManagementAction{
    
    spaceAdministrationController  *backVC = [[spaceAdministrationController  alloc]init];
    [self  presentViewController:backVC animated:YES completion:nil];
    
    
}

/**
 *添加联动设置linkageSetting
 */

-(void)linkageSetting{
    
    //创建一个联动是设置button
    UIButton  *linkageSettingBtn = [[UIButton  alloc]init];
    
    CGFloat linkageSettingBtnX = HOMECOOEDGEDISTANCE;
    CGFloat linkageSettingBtnY = CGRectGetMaxY (self.spaceManagementBtn.frame) + HOMECOOPRODUCTIONBUTTONDISTANCE;
    CGFloat linkageSettingBtnW = HOMECOOBUTTONWIDTH ;
    CGFloat linkageSettingBtnH = HOMECOOBUTTONHEIGHT;
    
    linkageSettingBtn.frame = CGRectMake(linkageSettingBtnX, linkageSettingBtnY, linkageSettingBtnW, linkageSettingBtnH);
    self.linkageSettingBtn = linkageSettingBtn;
    [linkageSettingBtn setBackgroundImage:[UIImage  imageNamed:@"设置按钮.png"] forState:UIControlStateNormal];
    [linkageSettingBtn  setBackgroundImage:[UIImage  imageNamed:@"设置按钮.png"] forState:UIControlStateHighlighted];
    
    [linkageSettingBtn  setTitle:@"联动设置" forState:UIControlStateNormal];
    [linkageSettingBtn  setTitle:@"联动设置" forState:UIControlStateHighlighted];
    //[linkageSettingBtn setFont:HOMECOOBUTTONFONT];
    linkageSettingBtn.titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:HOMECOOBUTTONFONT];
    [linkageSettingBtn setTitleColor:[UIColor  blackColor] forState:UIControlStateNormal];
    [linkageSettingBtn setTitleColor:[UIColor  orangeColor] forState:UIControlStateHighlighted];
    

    
    //监听按钮点击事件
    [linkageSettingBtn  addTarget:self action:@selector(linkageSettingAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.fullscreenView  addSubview:linkageSettingBtn];
    
    
    
    
}
/**
 *进入联动设置中心
 */
-(void)linkageSettingAction{
    
     linkageController  *linkSetting = [[linkageController  alloc]init];
    
    [self  presentViewController:linkSetting animated:YES completion:nil];
    

    
}


/**
 *添加情景管理
 */

-(void)themeManagement{
    
    //创建一个情景管理button
    UIButton  *lthemeManagementBtn = [[UIButton  alloc]init];
    
    CGFloat lthemeManagementBtnX = HOMECOOEDGEDISTANCE;
    CGFloat lthemeManagementBtnY = CGRectGetMaxY (self.linkageSettingBtn.frame) + HOMECOOPRODUCTIONBUTTONDISTANCE;
    CGFloat lthemeManagementBtnW = HOMECOOBUTTONWIDTH;
    CGFloat lthemeManagementBtnH = HOMECOOBUTTONHEIGHT;
    
    lthemeManagementBtn.frame = CGRectMake(lthemeManagementBtnX, lthemeManagementBtnY, lthemeManagementBtnW, lthemeManagementBtnH);
    self.lthemeManagementBtn = lthemeManagementBtn;
    [lthemeManagementBtn setBackgroundImage:[UIImage  imageNamed:@"设置按钮.png"] forState:UIControlStateNormal];
    [lthemeManagementBtn  setBackgroundImage:[UIImage  imageNamed:@"设置按钮.png"] forState:UIControlStateHighlighted];
    
    [lthemeManagementBtn  setTitle:@"情景管理" forState:UIControlStateNormal];
    [lthemeManagementBtn  setTitle:@"情景管理" forState:UIControlStateHighlighted];
    //[lthemeManagementBtn setFont:HOMECOOBUTTONFONT];
     lthemeManagementBtn.titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:HOMECOOBUTTONFONT];
    
    [lthemeManagementBtn setTitleColor:[UIColor  blackColor] forState:UIControlStateNormal];
    [lthemeManagementBtn setTitleColor:[UIColor  orangeColor] forState:UIControlStateHighlighted];
  
    //监听按钮点击事件
    
    [lthemeManagementBtn  addTarget:self action:@selector(themeManagementAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.fullscreenView  addSubview:lthemeManagementBtn];
    
    
    
}
/**
 *进入情景管理中心
 */
-(void)themeManagementAction{
    
    ThemeAdministrationController  *themeSetting = [[ThemeAdministrationController  alloc]init];
    
    [self  presentViewController:themeSetting animated:YES completion:nil];
    
    
    
}

/**
 *添加定时设置
 */

-(void)timerSetting{
    
    //创建一个定时设置button
    UIButton  *timerSettingBtn = [[UIButton  alloc]init];
    
    CGFloat timerSettingBtnX = CGRectGetMaxX(self.productManagementBtn.frame) + HOMECOOLEFTANDRIGHTGAP ;
    CGFloat timerSettingBtnY = HOMECOOTOPDISTANCE;
    CGFloat timerSettingBtnW = HOMECOOBUTTONWIDTH;
    CGFloat timerSettingBtnH = HOMECOOBUTTONHEIGHT;
    
    timerSettingBtn.frame = CGRectMake(timerSettingBtnX, timerSettingBtnY, timerSettingBtnW, timerSettingBtnH);
    self.timerSettingBtn = timerSettingBtn;
    [timerSettingBtn setBackgroundImage:[UIImage  imageNamed:@"设置按钮.png"] forState:UIControlStateNormal];
    [timerSettingBtn  setBackgroundImage:[UIImage  imageNamed:@"设置按钮.png"] forState:UIControlStateHighlighted];
    
    [timerSettingBtn  setTitle:@"定时设置" forState:UIControlStateNormal];
    [timerSettingBtn  setTitle:@"定时设置" forState:UIControlStateHighlighted];
    //[timerSettingBtn setFont:HOMECOOBUTTONFONT];
    timerSettingBtn.titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:HOMECOOBUTTONFONT];
    [timerSettingBtn setTitleColor:[UIColor  blackColor] forState:UIControlStateNormal];
    [timerSettingBtn setTitleColor:[UIColor  orangeColor] forState:UIControlStateHighlighted];    //监听按钮点击事件
    [timerSettingBtn  addTarget:self action:@selector(timerSettingAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.fullscreenView  addSubview:timerSettingBtn];
    
}
/**
 *进入定时设置中心
 */
-(void)timerSettingAction{
    
//    LZXDataCenter *dataCenter = [LZXDataCenter defaultDataCenter];
//    
//    if (dataCenter.networkStateFlag==0) {
//        [MBProgressHUD  showError:@"请切换到远程网络！"];
//    }else{
    
    SettingTimeControl *nextVC = [[SettingTimeControl  alloc]init];
    
    [self  presentViewController:nextVC animated:YES completion:nil];
    
   // }
 
}

/**
 *添加网关设置
 */

-(void)gatewaySetting{
    
    //创建一个网关设置button
    UIButton  *gatewaySettingBtn = [[UIButton  alloc]init];
    
    CGFloat gatewaySettingBtnX = CGRectGetMaxX(self.productManagementBtn.frame) + HOMECOOLEFTANDRIGHTGAP ;
    CGFloat gatewaySettingBtnY = CGRectGetMaxY(self.timerSettingBtn.frame) + HOMECOOPRODUCTIONBUTTONDISTANCE;
    CGFloat gatewaySettingBtnW = HOMECOOBUTTONWIDTH ;
    CGFloat gatewaySettingBtnH = HOMECOOBUTTONHEIGHT;
    
    gatewaySettingBtn.frame = CGRectMake(gatewaySettingBtnX, gatewaySettingBtnY, gatewaySettingBtnW, gatewaySettingBtnH);
    self.gatewaySettingBtn = gatewaySettingBtn;
    [gatewaySettingBtn setBackgroundImage:[UIImage  imageNamed:@"设置按钮.png"] forState:UIControlStateNormal];
    [gatewaySettingBtn  setBackgroundImage:[UIImage  imageNamed:@"设置按钮.png"] forState:UIControlStateHighlighted];
    
    [gatewaySettingBtn  setTitle:@"主机设置" forState:UIControlStateNormal];
    [gatewaySettingBtn  setTitle:@"主机设置" forState:UIControlStateHighlighted];
    //[gatewaySettingBtn setFont:HOMECOOBUTTONFONT];
    gatewaySettingBtn.titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:HOMECOOBUTTONFONT];
    [gatewaySettingBtn setTitleColor:[UIColor  blackColor] forState:UIControlStateNormal];
    [gatewaySettingBtn setTitleColor:[UIColor  orangeColor] forState:UIControlStateHighlighted];
   
    
    //监听按钮点击事件
    [gatewaySettingBtn  addTarget:self action:@selector(gatewaySettingAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.fullscreenView  addSubview:gatewaySettingBtn];
  
}
/**
 *进入网关设置中心
 */
-(void)gatewaySettingAction{
    
    gatewaySettingController  *gatewaySetting = [[gatewaySettingController  alloc]init];
    
    [self  presentViewController:gatewaySetting animated:YES completion:nil];
    
    
}

/**
 *添加系统设置
 */

-(void)systemSetting{
    
    //创建一个系统设置button
    UIButton  *systemSettingBtn = [[UIButton  alloc]init];
    
    CGFloat systemSettingBtnX = CGRectGetMaxX(self.productManagementBtn.frame) + HOMECOOLEFTANDRIGHTGAP ;
    CGFloat systemSettingBtnY = CGRectGetMaxY(self.gatewaySettingBtn.frame) + HOMECOOPRODUCTIONBUTTONDISTANCE;
    CGFloat systemSettingBtnW = HOMECOOBUTTONWIDTH;
    CGFloat systemSettingBtnH = HOMECOOBUTTONHEIGHT;
    
    systemSettingBtn.frame = CGRectMake(systemSettingBtnX, systemSettingBtnY, systemSettingBtnW, systemSettingBtnH);
    self.systemSettingBtn = systemSettingBtn;
    [systemSettingBtn setBackgroundImage:[UIImage  imageNamed:@"设置按钮.png"] forState:UIControlStateNormal];
    [systemSettingBtn  setBackgroundImage:[UIImage  imageNamed:@"设置按钮.png"] forState:UIControlStateHighlighted];
    
    [systemSettingBtn  setTitle:@"系统设置" forState:UIControlStateNormal];
    [systemSettingBtn  setTitle:@"系统设置" forState:UIControlStateHighlighted];
    //[systemSettingBtn setFont:HOMECOOBUTTONFONT];
     systemSettingBtn.titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:HOMECOOBUTTONFONT];
    [systemSettingBtn setTitleColor:[UIColor  blackColor] forState:UIControlStateNormal];
    [systemSettingBtn setTitleColor:[UIColor  orangeColor] forState:UIControlStateHighlighted];
    //监听按钮点击事件
    [systemSettingBtn  addTarget:self action:@selector(systemSettingAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.fullscreenView  addSubview:systemSettingBtn];
    
}
/**
 *进入系统设置中心
 */
-(void)systemSettingAction{
    
    SystemSettingController *vc = [[SystemSettingController  alloc]init];
    [self  presentViewController:vc animated:YES completion:nil];
    
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
 *设置导航栏
 */
-(void)setNavBar{
    CGFloat navBarW = [UIScreen  mainScreen].bounds.size.width;
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0,navBarW, 40)];
    //创建一个导航栏集合
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"设置"];
    
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
    
    SystemViewController  *vc = [[SystemViewController  alloc]init];
    [self  presentViewController: vc animated:YES completion:nil];
   
}


/**
 *退出系统
 */
-(void)exitAction{
    
    UIAlertView * alert = [[UIAlertView  alloc]initWithTitle:@"温馨提示" message:@"确定要退出HomeCOO系统吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert show];
    
    
}
/**
 *  UIalert view 代理方法
 *
 *  @param alertView   提示
 *  @param buttonIndex 点击的按钮
 */

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
-(BOOL)shouldAutorotate{
    return YES;
}



-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}
@end

