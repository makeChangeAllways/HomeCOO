//
//  SingleSecurityViewController.m
//  HomeCOO
//
//  Created by tgbus on 16/5/7.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "SingleSecurityViewController.h"
#import "AppDelegate.h"
#import "SystemViewController.h"
#import "SpaceViewController.h"
#import "ThemeViewController.h"
#import "SecurityViewController.h"
#import "SettingViewController.h"
#import "MethodClass.h"
#import "UDManager.h"
#import "MainController.h"
#import "NetManager.h"
#import "LoginController.h"
#import "AutoNavigation.h"
#import "LoginResult.h"
#import "AccountResult.h"
//底部空间、情景模式等按钮的高度
#define HOMECOOSPACEBUTTONHEIGHT 60

//底部空间、情景模式等按钮的宽度
#define HOMECOOSPACEBUTTONWIDTH [UIScreen  mainScreen].bounds.size.width / 5

//底部空间、情景模式等按钮Y的大小
#define  HOMECOOSPACEBUTTON_Y  [UIScreen  mainScreen].bounds.size.height - 55

//底部空间、情景模式等按钮字体的大小
#define HOMESPACEFONT 13

//设置云台摄像机、室外枪机，可视对讲显示图标的大小
#define  HOMECRAMEWIDTHANDHEIGHT  [UIScreen  mainScreen].bounds.size.width / 7

//设置云台摄像机、室外枪机，可视对讲lABLE图标的大小
#define  HOMElABLEWIDTHANDHEIGHT  [UIScreen  mainScreen].bounds.size.width / 7

//设置显示图标离屏幕边缘的距离
#define  HOMEEDGEDISTANCE  [UIScreen  mainScreen].bounds.size.width / 4.5

//设置显示图标离屏幕顶端的距离
#define  HOMETOPDISTANCE  [UIScreen  mainScreen].bounds.size.height / 3



@interface SingleSecurityViewController ()


/**设置背景图片*/
@property(nonatomic,strong)  UIImageView  * fullscreenView;

/**设置导航栏*/
@property(nonatomic,strong)  UINavigationBar *navBar;

/**添加云台摄像机按钮*/
@property(nonatomic,strong)UIButton  *cradleHeadCameraBtn ;

/**设置云台摄像机标签*/
@property(nonatomic,strong)UILabel   *cradleHeadCameraLable;

/**添加室外枪机按钮*/
@property(nonatomic,strong)UIButton  *outdoorBoltBtn ;

/**设置室外枪机标签*/
@property(nonatomic,strong)UILabel   *outdoorBoltLable;

/**添加可视对讲按钮*/
@property(nonatomic,strong)UIButton  *VisualIntercomBtn ;

/**设置可是对讲标签*/
@property(nonatomic,strong)UILabel   *VisualIntercomLable;



@end

@implementation SingleSecurityViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //创建一个导航栏
    [self setNavBar];
    
    //添加云台摄像机显示界面
    [self  addCradleHeadCameraBtn];
    
    //添加室外枪机显示界面
    //[self  addOutdoorBoltBtn];
    
    //添加可是对讲显示界面
    [self  addVisualIntercomBtn];
    
}


/**
 *添加云台摄像机显示界面
 */

-(void)addCradleHeadCameraBtn{
    
    //添加云台安防摄像机按钮 cradle head camera
    UIButton  *cradleHeadCameraBtn = [[UIButton  alloc]init];
    
    CGFloat  cradleHeadCameraBtnX = HOMEEDGEDISTANCE;
    CGFloat  cradleHeadCameraBtnY = HOMETOPDISTANCE ;
    CGFloat  cradleHeadCameraBtnW = HOMECRAMEWIDTHANDHEIGHT;
    CGFloat  cradleHeadCameraBtnH = cradleHeadCameraBtnW;
    cradleHeadCameraBtn.frame = CGRectMake(cradleHeadCameraBtnX, cradleHeadCameraBtnY, cradleHeadCameraBtnW, cradleHeadCameraBtnH);
   
    //添加云台摄像机按钮背景
    // securityControlBtn.backgroundColor = [UIColor redColor];
    [cradleHeadCameraBtn  setImage:[UIImage  imageNamed:@"云台摄像机图标.png"] forState:UIControlStateNormal];
   
    [cradleHeadCameraBtn  setImage:[UIImage  imageNamed:@"云台摄像机图标.png"] forState:UIControlStateHighlighted];
    self.cradleHeadCameraBtn = cradleHeadCameraBtn;
    
    //cradleHeadCameraBtn.backgroundColor = [UIColor  redColor];
    //监听云台摄像机按钮
    
    [cradleHeadCameraBtn  addTarget:self action:@selector(cradleHeadCameraAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel  *cradleHeadCameraLable = [[UILabel  alloc]init];
    
    CGFloat  cradleHeadCameraLableX = HOMEEDGEDISTANCE;
    CGFloat  cradleHeadCameraLableY = CGRectGetMaxY(cradleHeadCameraBtn.frame) +10  ;
    CGFloat  cradleHeadCameraLableW = HOMElABLEWIDTHANDHEIGHT;
    CGFloat  cradleHeadCameraLableH = 20;
    
    cradleHeadCameraLable.frame = CGRectMake(cradleHeadCameraLableX, cradleHeadCameraLableY, cradleHeadCameraLableW, cradleHeadCameraLableH);
    cradleHeadCameraLable.text = @"云台摄像机";
    cradleHeadCameraLable.textColor = [UIColor  blackColor];
    cradleHeadCameraLable.textAlignment = NSTextAlignmentCenter;
    cradleHeadCameraLable.font = [UIFont fontWithName:@"Arial" size:15];
    //securityLable.backgroundColor = [UIColor  redColor];
    self.cradleHeadCameraLable = cradleHeadCameraLable;
    
    //添加云台摄像机到fullscreenView上，
    [self.fullscreenView  addSubview:cradleHeadCameraBtn];
    [self.fullscreenView  addSubview:cradleHeadCameraLable];
    
    
}

/**
 *进入云台摄像机
 */

-(void)cradleHeadCameraAction{

 //if([UDManager isLogin]){
        
        MainController *mainController = [AppDelegate sharedDefault].mainController;
        [self  presentViewController:mainController animated:YES completion:nil];
        
       // [mainController release];
//        LoginResult *loginResult = [UDManager getLoginInfo];
//        
//        [[NetManager sharedManager] getAccountInfo:loginResult.contactId sessionId:loginResult.sessionId callBack:^(id JSON){
//            
//            AccountResult *accountResult = (AccountResult*)JSON;
//            if(accountResult.error_code==NET_RET_GET_ACCOUNT_SUCCESS){
//                loginResult.email = accountResult.email;
//                loginResult.phone = accountResult.phone;
//                loginResult.countryCode = accountResult.countryCode;
//                [UDManager setLoginInfo:loginResult];
//            }
//    
//        }];
//    }else{
//        LoginController *loginController = [[LoginController alloc] init];
//        AutoNavigation *mainController = [[AutoNavigation alloc] initWithRootViewController:loginController];
//        
//        [self  presentViewController:mainController animated:YES completion:nil];
//        
//    }
    //NSLog(@"进入云台摄像机");

}


/**
 *添加室外枪机显示界面Outdoor bolt
 */

-(void)addOutdoorBoltBtn{
    
    //添加室外枪机
    UIButton  *outdoorBoltBtn = [[UIButton  alloc]init];
    
    CGFloat  outdoorBoltBtnX = CGRectGetMaxX(self.cradleHeadCameraBtn.frame) + HOMEEDGEDISTANCE;
    CGFloat  outdoorBoltBtnY = HOMETOPDISTANCE;
    CGFloat  outdoorBoltBtnW = HOMECRAMEWIDTHANDHEIGHT;
    CGFloat  outdoorBoltBtnH = outdoorBoltBtnW;
    outdoorBoltBtn.frame = CGRectMake(outdoorBoltBtnX, outdoorBoltBtnY, outdoorBoltBtnW, outdoorBoltBtnH);
    
    //添加室外枪机按钮背景
    // securityControlBtn.backgroundColor = [UIColor redColor];
    [outdoorBoltBtn  setImage:[UIImage  imageNamed:@"室外枪机按钮.png"] forState:UIControlStateNormal];
    
    [outdoorBoltBtn  setImage:[UIImage  imageNamed:@"室外枪机按钮.png"] forState:UIControlStateHighlighted];
    self.outdoorBoltBtn = outdoorBoltBtn;
    
    //监听室外枪机点击事件
    [outdoorBoltBtn  addTarget:self action:@selector(outdoorBoltAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel  *outdoorBoltLable = [[UILabel  alloc]init];
    
    CGFloat  outdoorBoltLableX = CGRectGetMaxX(self.cradleHeadCameraLable.frame) + HOMEEDGEDISTANCE ;
    CGFloat  outdoorBoltLableY = CGRectGetMaxY(outdoorBoltBtn.frame) +10  ;
    CGFloat  outdoorBoltLableW = HOMElABLEWIDTHANDHEIGHT;
    CGFloat  outdoorBoltLableH = 20;
    
    outdoorBoltLable.frame = CGRectMake(outdoorBoltLableX, outdoorBoltLableY, outdoorBoltLableW, outdoorBoltLableH);
    outdoorBoltLable.text = @"室外枪机";
    outdoorBoltLable.textColor = [UIColor  blackColor];
    outdoorBoltLable.textAlignment = NSTextAlignmentCenter;
    outdoorBoltLable.font = [UIFont fontWithName:@"Arial" size:15];
    //securityLable.backgroundColor = [UIColor  redColor];
    self.outdoorBoltLable = outdoorBoltLable;
    
    //添加室外枪机到fullscreenView上，
    [self.fullscreenView  addSubview:outdoorBoltBtn];
    [self.fullscreenView  addSubview:outdoorBoltLable];
    
    
}

/**
 *进入室外枪机
 */

-(void)outdoorBoltAction{
    
    NSLog(@"进入室外枪机");
    
}



/**
 *添加可视对讲显示界面visual intercom
 */

-(void)addVisualIntercomBtn{
    
    //添加可视对讲按钮
    UIButton  *VisualIntercomBtn = [[UIButton  alloc]init];
    
    CGFloat  VisualIntercomBtnX = CGRectGetMaxX(self.cradleHeadCameraBtn.frame) + HOMEEDGEDISTANCE ;
    CGFloat  VisualIntercomBtnY = HOMETOPDISTANCE ;
    CGFloat  VisualIntercomBtnW = HOMECRAMEWIDTHANDHEIGHT;
    CGFloat  VisualIntercomBtnH = VisualIntercomBtnW;
    VisualIntercomBtn.frame = CGRectMake(VisualIntercomBtnX, VisualIntercomBtnY, VisualIntercomBtnW, VisualIntercomBtnH);
    
    //添加可视对讲按钮背景图片
    [VisualIntercomBtn  setImage:[UIImage  imageNamed:@"可视对讲图标.png"] forState:UIControlStateNormal];
    [VisualIntercomBtn  setImage:[UIImage  imageNamed:@"可视对讲图标.png"] forState:UIControlStateHighlighted];
    self.VisualIntercomBtn = VisualIntercomBtn;
    

    //监听可视对讲点击事件
    [VisualIntercomBtn  addTarget:self action:@selector(visualIntercomAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel  *VisualIntercomLable = [[UILabel  alloc]init];
    
    CGFloat  VisualIntercomLableX = CGRectGetMaxX(self.cradleHeadCameraBtn.frame) +HOMEEDGEDISTANCE;
    CGFloat  VisualIntercomLableY = CGRectGetMaxY(VisualIntercomBtn.frame) +10  ;
    CGFloat  VisualIntercomLableW = HOMElABLEWIDTHANDHEIGHT;
    CGFloat  VisualIntercomLableH = 20;
    
    VisualIntercomLable.frame = CGRectMake(VisualIntercomLableX, VisualIntercomLableY, VisualIntercomLableW, VisualIntercomLableH);
    VisualIntercomLable.text = @"可视对讲";
    VisualIntercomLable.textColor = [UIColor  blackColor];
    VisualIntercomLable.textAlignment = NSTextAlignmentCenter;
    VisualIntercomLable.font = [UIFont fontWithName:@"Arial" size:15];
    //securityLable.backgroundColor = [UIColor  redColor];
    self.VisualIntercomLable = VisualIntercomLable;
    
    //添加可视对讲到fullscreenView上，
    [self.fullscreenView  addSubview:VisualIntercomBtn];
    [self.fullscreenView  addSubview:VisualIntercomLable];
    
    
}

/**
 *进入可视对讲
 */

-(void)visualIntercomAction{
    
    NSLog(@"进入可视对讲");
    
}


/**
 *设置导航栏
 */
-(void)setNavBar{
    
    
    CGFloat navBarW = [UIScreen  mainScreen].bounds.size.width;
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0,navBarW, 40)];
    
    //创建一个导航栏集合
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"安防"];
    
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
    
    SystemViewController  *vc =[[SystemViewController  alloc]init];
    
    [self  presentViewController:vc animated:YES completion:nil];
    
}


/**
 *退出系统
 */
-(void)exitAction{
    UIAlertView * alert = [[UIAlertView  alloc]initWithTitle:@"温馨提示" message:@"确定要退出HomeCOO系统吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
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

//-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    returnUIInterfaceOrientationLandscapeRight;
//}
//
//-(NSUInteger)supportedInterfaceOrientations
//{
//    returnUIInterfaceOrientationMaskLandscapeRight;
//}
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}


@end
