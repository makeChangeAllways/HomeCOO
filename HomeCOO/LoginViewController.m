//
//  LoginViewController.m
//  HomeCOO
//
//  Created by tgbus on 16/4/28.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "LoginViewController.h"
#import "registerViewController.h"
#import "AFNetworkings.h"
#import "AppDelegate.h"
#import "SystemViewController.h"
#import "MBProgressHUD+MJ.h"
#import "FMDB.h"
#import "HCUserTable.h"
#import "PrefixHeader.pch"
#import "userMessage.h"
#import "userMessageTool.h"
#import "LZXDataCenter.h"
#import "NSString+Hash.h"
#import "JPUSHService.h"
#import "ControlMethods.h"
#import "gatewayMessageModel.h"
#import "gatewayMessageTool.h"
#import "GCDAsyncSocket.h"
#import "SocketManager.h"
#import "NetManager.h"
#import "LoginResult.h"
#import "UDManager.h"
#import "MainController.h"
#import "AccountResult.h"
#import "CheckNewMessageResult.h"
#import "GetContactMessageResult.h"
#import "ContactDAO.h"
#import "MessageDAO.h"
#import "Message.h"
#import "FListManager.h"
#import "configureWirelessController.h"
#import "UIView+Extension.h"
#import "USerDataView.h"
#import "HCGatewayView.h"
#import "UdpSocketManager.h"
#import "GGSocketManager.h"
#define HOMECOOEDIGEWIDTH  10;

@interface LoginViewController ()<UITextFieldDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,USerDataViewDelegate,HCGatewayViewDelegate>

/**设置背景图片*/
@property(nonatomic,strong)  UIImageView   *fullscreenView;// UIView  * fullscreenView;
@property(nonatomic,strong)  UIScrollView   *scrollView;
/**设置login_background*/
@property(nonatomic,strong)  UIImageView  * loginBackGroundView;

/**设置主页图标*/
@property(nonatomic,strong)  UIImageView  * setHomeIconView ;

/**输入用户名*/
@property(nonatomic,strong)  UITextField *userNameText;

/**输入密码*/
@property(nonatomic,strong)  UITextField *pwdText;

/**添加找回用户名和密码按钮*/
@property(nonatomic,strong)  UIButton  *foundUserNameAndPwd;

@property(nonatomic,strong)  USerDataView *userView;

@property(nonatomic,strong)  HCGatewayView *resetPwdView;

/**添加注册按钮*/
@property(nonatomic,strong)  UIButton  *registerBtn;

/**添加登录按钮*/
@property(nonatomic,strong)UIButton  *loginBtn;

// 获得当前所指向的数据
@property(nonatomic,copy) NSString *userName_t ;

@property(nonatomic,copy) NSString *userPwd_t ;

@property(nonatomic,strong) HCUserTable *user;

@property (nonatomic, strong) FMDatabasess *db;

@property(nonatomic,strong) NSArray *users;

@property(nonatomic,strong)  GCDAsyncSocket *socket;

@property (nonatomic,strong) UdpSocketManager *udpManager;

@property (nonatomic,strong)  GGSocketManager *socketManger ;


@property NSInteger conectNum;

@property NSInteger flag;
@property NSInteger keyBoardHeight;

@end

@implementation LoginViewController

-(NSArray*)users{

    if (_users==nil) {
        
        _users = [userMessageTool queryWithgUsers];
        
       
    }

    return _users;

}

- (void)viewDidLoad {
   
    [super viewDidLoad];
    
    //设置背景
    //[self setFullscreenView];

    [self addUIScrollView];
    
    [self registerKeyBoardNotification];
    //设置homecoo logo
    [self setHomelogo];
    
    //设置login_background
    [self  setLoginBackground];
    
    //设置主页图标
    [self setHomeIcon];
    
    //设置用户名 密码图标
    [self  setUSerAndPwdView];
    
    //配置主机无线
    [self ConfigureHostWirelessBtn];
    
    //退出homecoo 系统
    [self  exitActionBtn];
    
    [self TapGestureRecognizer];
    
    //记住用户名和密码
    [self  saveUserAndPwd];
    
    NSInteger  flag = 5;
    
    self.flag = flag;   
}
//添加点按击手势监听器 解决touch事件被uiscrollview截获
-(void)TapGestureRecognizer{
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapUiscrollView)];
    //设置手势属性
    tapGesture.delegate = self;
    tapGesture.numberOfTapsRequired=1;//设置点按次数，默认为1，注意在iOS中很少用双击操作
    tapGesture.numberOfTouchesRequired=1;//点按的手指数
    [self.fullscreenView addGestureRecognizer:tapGesture];
    
}

-(void)tapUiscrollView{

    CGPoint offset =  CGPointMake(0.0f, 0.0f);
    
    [self.scrollView setContentOffset:offset animated:YES];


    if (![_userNameText isExclusiveTouch]) {
        [_userNameText resignFirstResponder];
    }
    if (![_pwdText isExclusiveTouch]) {
        [_pwdText resignFirstResponder];
    }

}
/**
 *退出homecoo 系统
 */
-(void)exitActionBtn{
    UIButton  *exitBtn = [[UIButton  alloc]init];
    
    CGFloat  exitBtnX = [UIScreen  mainScreen].bounds.size.width - 60 ;
    CGFloat  exitBtnY = 10;
    CGFloat  exitBtnW = 40;
    CGFloat  exitBtnH = 30;
    exitBtn.frame = CGRectMake(exitBtnX, exitBtnY, exitBtnW, exitBtnH);
    [exitBtn  setTitle:@"退出" forState:UIControlStateNormal];
    [exitBtn  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    //点击时的状态
    [exitBtn  setTitle:@"退出" forState:UIControlStateHighlighted];
    [exitBtn  setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    //[exitBtn  setFont:[UIFont  systemFontOfSize:15]];
    exitBtn.titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:16];
    //添加退出按钮背景颜色
    //exitBtn.backgroundColor = [UIColor redColor];
    [exitBtn  addTarget:self action:@selector(exitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.fullscreenView  addSubview:exitBtn];

}

/**
 *退出系统
 */
-(void)exitAction{
    
    UIAlertView * alert = [[UIAlertView  alloc]initWithTitle:@"温馨提示" message:@"确定要退出HomeCOO系统吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
    if(buttonIndex ==1){//点击的是确定按键
        
        [self exitApplication ];
        
    }
    
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
 *配置主机无线
 */

-(void)ConfigureHostWirelessBtn{
    UIButton  *ConfigureHostBtn = [[UIButton  alloc]init];
    
    CGFloat  ConfigureHostX = [UIScreen  mainScreen].bounds.size.width - 100 ;
    CGFloat  ConfigureHostY = 10;
    CGFloat  ConfigureHostW = 40;
    CGFloat  ConfigureHostH = 30;
    ConfigureHostBtn.frame = CGRectMake(ConfigureHostX, ConfigureHostY, ConfigureHostW, ConfigureHostH);
    [ConfigureHostBtn  setTitle:@"配置 |" forState:UIControlStateNormal];
    [ConfigureHostBtn  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    //点击时的状态
    // [ConfigureHostBtn  setTitle:@"配置|" forState:UIControlStateHighlighted];
    //[ConfigureHostBtn  setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    //[exitBtn  setFont:[UIFont  systemFontOfSize:15]];
    ConfigureHostBtn.titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:16];
    //添加退出按钮背景颜色
    //exitBtn.backgroundColor = [UIColor redColor];
    [ConfigureHostBtn  addTarget:self action:@selector(ConfigureHostAction) forControlEvents:UIControlEventTouchUpInside];
    [self.fullscreenView  addSubview:ConfigureHostBtn];
    
}
-(void)ConfigureHostAction{
    
    configureWirelessController  *vc = [[configureWirelessController  alloc]init];
    
    [self  presentViewController:vc animated:YES completion:nil];
    
    
}
/**
 *设置背景图片
 */

-(void)setFullscreenView{
    
    UIView  *fullscreenView = [[UIView  alloc]init];
    UIImage  *image = [UIImage imageNamed:@"bg_fullscreen.jpg"];
    
    /**设置背景图片的大小*/
    fullscreenView.backgroundColor = [UIColor  colorWithPatternImage:image];
    CGFloat fullscreenViewW = [UIScreen  mainScreen].bounds.size.width;
    CGFloat fullscreenViewH = [UIScreen  mainScreen].bounds.size.height;
    fullscreenView.frame = CGRectMake(0, 0, fullscreenViewW, fullscreenViewH);
    //self.fullscreenView = fullscreenView;
    [self.view  addSubview:fullscreenView];
    
}
/**
 *  添加 UIScrollView
 */

-(void)addUIScrollView{
    
    UIScrollView   *scrollView = [[UIScrollView alloc]init];
    
    scrollView.frame = self.view.bounds;
    [self.view  addSubview:scrollView];
    UIImageView  *image = [[UIImageView  alloc]init];
    
    image.frame = self.view.bounds;
    //显示图片
    image.image = [UIImage  imageNamed:@"bg_fullscreen.jpg"];
    self.fullscreenView = image;
    image.userInteractionEnabled = YES;
    [scrollView  addSubview:image];

    scrollView.contentSize = CGSizeMake(0,scrollView.height);
   
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.delegate = self;
    scrollView.userInteractionEnabled = YES;
    self.scrollView = scrollView;
    scrollView.alwaysBounceVertical =NO;
    scrollView.scrollEnabled = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
   
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8* NSEC_PER_SEC)),  dispatch_get_main_queue(), ^{
        
        NSInteger key = self.view.height - CGRectGetMaxY(textField.frame)-CGRectGetMinY(self.loginBackGroundView.frame);
        
        NSInteger keyBounds = self.keyBoardHeight -key  ;
        
        
//        NSLog(@"   keyBounds = %ld  key = %ld  %f %f self.keyBoardHeight = %ld"  ,(long)keyBounds,(long)key,CGRectGetMaxY(textField.frame),CGRectGetMinY(self.loginBackGroundView.frame),(long)self.keyBoardHeight);
//
        if (keyBounds<0) {//不做处理
            
        }else{
            CGPoint offset =  CGPointMake(0.0f, keyBounds);
            [self.scrollView setContentOffset:offset animated:YES];
        }
       
    });
    
}

- (void)registerKeyBoardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBoardAction:) name:UIKeyboardWillShowNotification object:nil];

}

- (void)handleKeyBoardAction:(NSNotification *)notification {
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSInteger keyBoardHeight = keyboardRect.size.height;
    
    self.keyBoardHeight = keyBoardHeight;
    
}


/**
 *设置HomeCOO Logo
 */

-(void)setHomelogo{
    
    UIImage  *homeCooPic = [UIImage  imageNamed:@"HomeCOO.png"];
    
    UIImageView  *homeCooView = [[UIImageView  alloc]initWithImage:homeCooPic];
    /**设置图片大小*/
    homeCooView.contentMode = UIViewContentModeScaleToFill;
    CGFloat  homeCOOX = HOMECOOEDIGEWIDTH;
    CGFloat  homeCOOY = HOMECOOEDIGEWIDTH;
    CGFloat  homeCOOW = 115;
    CGFloat  homeCOOH = 18;
    
    homeCooView.frame = CGRectMake(homeCOOX, homeCOOY, homeCOOW, homeCOOH);
    [self.fullscreenView  addSubview:homeCooView];
    
    
}

/**
 *设置login_background
 */

-(void)setLoginBackground{
    
    UIImage *loginBackGround = [UIImage  imageNamed:@"login_backgroud.png"];
    UIImageView  *loginBackGroundView =[[UIImageView  alloc]initWithImage:loginBackGround];
    
    loginBackGroundView.contentMode = UIViewContentModeScaleToFill;
    CGFloat  loginBackGroundViewW = [UIScreen  mainScreen].bounds.size.width / 2 + 5 *HOMECOOEDIGEWIDTH;
    
    CGFloat  loginBackGroundViewH = [UIScreen  mainScreen].bounds.size.height /2 + 6 *HOMECOOEDIGEWIDTH;
    
   
    CGFloat  loginBackGroundViewX = [UIScreen  mainScreen].bounds.size.width / 2 -loginBackGroundViewW/2;
    CGFloat  loginBackGroundViewY = [UIScreen  mainScreen].bounds.size.height /2 -loginBackGroundViewH/2 + 10;
    
    loginBackGroundView.frame = CGRectMake(loginBackGroundViewX, loginBackGroundViewY, loginBackGroundViewW, loginBackGroundViewH);
    loginBackGroundView.userInteractionEnabled = YES;
    self.loginBackGroundView = loginBackGroundView;
    [self.fullscreenView  addSubview:loginBackGroundView];
    
    
}

/**
 *设置主页图标
 */
-(void)setHomeIcon{
    
     UIImage *setHomeIcon = [UIImage imageNamed:@"主页显示图标.png"];
     UIImageView  *setHomeIconView = [[UIImageView  alloc]initWithImage:setHomeIcon];
    /**设置图片大小*/
  
    setHomeIconView.contentMode = UIViewContentModeScaleAspectFit;
    CGFloat  setHomeIconX = [UIScreen  mainScreen].bounds.size.width / 2 - 40;
    CGFloat  setHomeIconY = CGRectGetMinY(self.loginBackGroundView.frame) - 40;
    CGFloat  setHomeIconW = 80;
    CGFloat  setHomeIconH = 80;
    
    setHomeIconView.frame = CGRectMake(setHomeIconX, setHomeIconY,setHomeIconW, setHomeIconH);
    self.setHomeIconView = setHomeIconView;
    [self.fullscreenView  addSubview:setHomeIconView];
    
}

/**
 *设置用户名，密码
 */

-(void)setUSerAndPwdView{

    //添加用户名标签
    UILabel  *userNmaeLable = [[UILabel  alloc]init];
    
    CGFloat  userNmaeLableX = 10;//CGRectGetMinX(self.loginBackGroundView.frame) ;//110;
    CGFloat  userNmaeLableY = CGRectGetMaxY(self.setHomeIconView.frame) -60 ;
    CGFloat  userNmaeLableW = 80;
    CGFloat  userNmaeLableH = 40;
   
    //添加用户名lable 的背景颜色
    //userNmaeLable.backgroundColor = [UIColor  whiteColor];
    userNmaeLable.text = @"用户名：";
    userNmaeLable.textAlignment = NSTextAlignmentCenter;
    userNmaeLable.font = [UIFont  systemFontOfSize:18];
    
    userNmaeLable.frame = CGRectMake(userNmaeLableX, userNmaeLableY, userNmaeLableW, userNmaeLableH);
    userNmaeLable.clipsToBounds = YES;
    userNmaeLable.layer.cornerRadius = 8.0;//设置边框圆角
    
    //添加用户名输入文本框
    UITextField *userNameText = [[UITextField  alloc]init];
    CGFloat  userNameTextX = CGRectGetMaxX(userNmaeLable.frame) +10;
    CGFloat  userNameTextY = CGRectGetMaxY(self.setHomeIconView.frame) -60 ;
    CGFloat  userNameTextW = self.loginBackGroundView.frame.size.width / 2;
    CGFloat  userNameTextH = 40;
    
  
    
    [userNameText.layer setCornerRadius:8.0];//设置边框圆角
    userNameText.font = [UIFont  systemFontOfSize:18];
    userNameText.frame = CGRectMake(userNameTextX, userNameTextY, userNameTextW, userNameTextH);
    userNameText.placeholder = @"请输入用户名";
    userNameText.delegate = self;
    //添加一个空的view，让text偏移
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    userNameText.leftView = paddingView;
    userNameText.leftViewMode = UITextFieldViewModeAlways;
    userNameText.backgroundColor = [UIColor  whiteColor];

    //[verificationView  setValue:[UIFont boldSystemFontOfSize:24]forKeyPath:@"_placeholderLabel.font"];
    userNameText.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    
    self.userNameText = userNameText;
    
    //添加密码标签
    UILabel  *pwdLable = [[UILabel  alloc]init];
    
    CGFloat  pwdLableX = 10;//CGRectGetMinX(self.loginBackGroundView.frame) -110 ;
    CGFloat  pwdLableY = CGRectGetMaxY(userNmaeLable.frame) +10 ;
    CGFloat  pwdLableW = 80;
    CGFloat  pwdLableH = 40;
    
    //添加密码lable 的背景颜色
    //pwdLable.backgroundColor = [UIColor  whiteColor];
    pwdLable.text = @"密    码：";
    pwdLable.textAlignment = NSTextAlignmentCenter;
    pwdLable.font = [UIFont  systemFontOfSize:18];
    
    pwdLable.frame = CGRectMake(pwdLableX, pwdLableY, pwdLableW, pwdLableH);
    pwdLable.clipsToBounds = YES;
    pwdLable.layer.cornerRadius = 8.0;//设置边框圆角
    
    //添加密码文本框
    UITextField *pwdText = [[UITextField  alloc]init];
    CGFloat  pwdTextX = CGRectGetMaxX(pwdLable.frame) +10;
    CGFloat  pwdTextY = CGRectGetMaxY(userNameText.frame) +10  ;
    CGFloat  pwdTextW = self.loginBackGroundView.frame.size.width / 2;
    CGFloat  pwdTextH = 40;
    
    [pwdText.layer setCornerRadius:8.0];//设置边框圆角
    pwdText.font = [UIFont  systemFontOfSize:18];
    pwdText.placeholder = @"请输入密码";
    pwdText.text = self.user.userPwd;
    pwdText.delegate = self;
    //创建一个空的view，让text偏移
    UIView *padding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    pwdText.leftView = padding;
    pwdText.leftViewMode = UITextFieldViewModeAlways;
    //[verificationView  setValue:[UIFont boldSystemFontOfSize:24]forKeyPath:@"_placeholderLabel.font"];
    pwdText.secureTextEntry = YES;
    pwdText.clearButtonMode = UITextFieldViewModeWhileEditing;
    pwdText.frame = CGRectMake(pwdTextX, pwdTextY, pwdTextW, pwdTextH);
    pwdText.backgroundColor = [UIColor  whiteColor];
    
    //添加密码文本框背景图片
    self.pwdText = pwdText;
    

    
    //添加找回用户名和密码按钮
    UIButton  *foundUserNameAndPwd = [[UIButton  alloc]init];
    //foundUserNameAndPwd.backgroundColor = [UIColor  redColor];
    CGFloat  foundUserNameAndPwdX = 10;//CGRectGetMinX(self.loginBackGroundView.frame) -110 ;
    CGFloat  foundUserNameAndPwdY = CGRectGetMaxY(pwdLable.frame) +10 ;
    CGFloat  foundUserNameAndPwdW = 120;//self.loginBackGroundView.frame.size.width / 3;
    CGFloat  foundUserNameAndPwdH = 30;
    foundUserNameAndPwd.frame = CGRectMake(foundUserNameAndPwdX, foundUserNameAndPwdY, foundUserNameAndPwdW, foundUserNameAndPwdH);
    [foundUserNameAndPwd  setTitle:@"找回用户名和密码" forState:UIControlStateNormal];
    [foundUserNameAndPwd  setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    //点击时的状态
    [foundUserNameAndPwd  setTitle:@"找回用户名和密码" forState:UIControlStateHighlighted];
   // [foundUserNameAndPwd  setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    //[foundUserNameAndPwd  setFont:[UIFont  systemFontOfSize:15]];
     foundUserNameAndPwd.titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:15];
    [foundUserNameAndPwd  addTarget:self action:@selector(foundUserNameAndPwdAction) forControlEvents:UIControlEventTouchUpInside];
    
    //添加按钮的背景颜色
    //foundUserNameAndPwd.backgroundColor = [UIColor grayColor];
    self.foundUserNameAndPwd = foundUserNameAndPwd;
    
    //登录界面按钮的宽度
    CGFloat loginBtnAndLoginW =( CGRectGetMaxX(self.pwdText.frame) - CGRectGetMaxX(self.foundUserNameAndPwd.frame) ) /2 -10;
    
    //添加注册按钮
    UIButton  *registerBtn = [[UIButton  alloc]init];
    CGFloat  registerBtnX = CGRectGetMaxX(foundUserNameAndPwd.frame)+10;
    CGFloat  registerBtnY = CGRectGetMaxY(pwdText.frame) +10 ;
   // CGFloat  registerBtnW = 60;
    CGFloat  registerBtnH = 37;
    registerBtn.frame = CGRectMake(registerBtnX, registerBtnY, loginBtnAndLoginW, registerBtnH);
    
    //添加注册按钮背景颜色
    //registerBtn.backgroundColor = [UIColor redColor];
    [registerBtn  setImage:[UIImage  imageNamed:@"bt_register0"] forState:UIControlStateNormal];
    [registerBtn  setImage:[UIImage  imageNamed:@"bt_register1"] forState:UIControlStateHighlighted];
    self.registerBtn = registerBtn;
   
    //监听注册按钮
    [registerBtn  addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    //添加登录按钮
    UIButton  *loginBtn = [[UIButton  alloc]init];
    
    CGFloat  loginBtnX = CGRectGetMaxX(registerBtn.frame)+10 ;
    CGFloat  loginBtnY = CGRectGetMaxY(pwdText.frame) +10 ;
    //CGFloat  loginBtnW = 60;
    CGFloat  loginBtnH = 37;
    loginBtn.frame = CGRectMake(loginBtnX, loginBtnY, loginBtnAndLoginW, loginBtnH);
    
    //添加登录按钮背景颜色
    //loginBtn.backgroundColor = [UIColor redColor];
    [loginBtn  setImage:[UIImage  imageNamed:@"bt_login0"] forState:UIControlStateNormal];
    [loginBtn  setImage:[UIImage  imageNamed:@"bt_login1"] forState:UIControlStateHighlighted];
    self.loginBtn = loginBtn;
    
    //监听登录按钮
    [loginBtn  addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.loginBackGroundView  addSubview:userNmaeLable];
    [self.loginBackGroundView  addSubview:userNameText];
    [self.loginBackGroundView  addSubview:pwdLable];
    [self.loginBackGroundView  addSubview:pwdText];
    [self.loginBackGroundView  addSubview:foundUserNameAndPwd];
    [self.loginBackGroundView  addSubview:registerBtn];
    [self.loginBackGroundView  addSubview:loginBtn];
    
}

/**
 *  监听键盘 按下键盘上return自动退出
 *
 *  @param textField
 *
 *  @return 
 */

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField  resignFirstResponder];
    
    CGPoint offset =  CGPointMake(0.0f, 0.0f);
    
    [self.scrollView setContentOffset:offset animated:YES];
    return  YES;

}


/**
 *找回用户名和密码
 */
-(void)foundUserNameAndPwdAction{
   
    [self.userView  showView:self.view animated:YES];
    
}

-(HCGatewayView *)resetPwdView{

    _resetPwdView = [[HCGatewayView alloc]initWithFrame:CGRectZero];
    _resetPwdView.delegate = self;
    _resetPwdView.mainTitle.text = @"密码重置";
    _resetPwdView.secondaryTitle.text = @"用户名 :";
    _resetPwdView.secondaryField.placeholder = @"请输入手机号";
    _resetPwdView.thirdTitle.text = @"密码 :";
    _resetPwdView.thirdField.secureTextEntry = YES;
    _resetPwdView.thirdField.placeholder = @"密码为6-18个数字或字母";
    _resetPwdView.fourthTitle.text = @"确认密码 :";
    _resetPwdView.fourthField.placeholder = @"请再次输入密码";
    _resetPwdView.fourthField.secureTextEntry = YES;
    
    return _resetPwdView;

}

-(USerDataView*)userView{

    _userView = [[USerDataView alloc]initWithFrame:CGRectZero];

    _userView.delegate = self;
    _userView.mainTitle.text = @"短信验证";
    _userView.secondaryField.placeholder  = @"请输入注册的手机号";
    _userView.secondaryTitle.text = @"手机号 :";
    _userView.thirdTitle.text = @"验证码 :";
    _userView.thirdField.placeholder = @"请输入验证码";


    return _userView;
}
#pragma delegate


/**
 校验验证码

 @param daterView
 */

-(void)sureButtonlicked:(USerDataView *)daterView{
    //创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager  manager];
    mgr.responseSerializer = [AFJSONResponseSerializers  serializer];
    
    //配置请求超时时间
    mgr.requestSerializer.timeoutInterval = 60;
    
    
    //设置请求参数
    NSMutableDictionary  *params = [NSMutableDictionary  dictionary];
    params[@"phonenum"] = _userView.secondaryField.text;
    params[@"identifyCode"] = _userView.thirdField.text;
    params[@"smsCodeType"] = @"2";
    NSString  *urlStr =[NSString  stringWithFormat:@"%@/appPhoneCheckCode" ,HomecooServiceURL];
    NSString *url = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
    
    [mgr  POST:url parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        //打印日志
        //NSLog(@"请求成功--%@",responseObject);
        NSString  *result = [responseObject[@"result"]description];
        NSString *message = [responseObject[@"messageInfo"]description];
        
        if ([result  isEqual:@"success"]) {
            
            [self.userView  hiddenView:self.view animated:YES];
            [self.resetPwdView  showGatewayView:self.view animated:YES];
            
        } if ([result  isEqual:@"failed"]) {
            
            [MBProgressHUD  showError:[NSString  stringWithFormat:@"%@",message]];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        [MBProgressHUD  showError:@"网络繁忙，请稍后再试"];
    }];
    

}


/**
 发送验证码(找回密码)

 @param dataView
 */
-(void)checkButtonClick:(USerDataView *)dataView{
    
    //判断手机号码是否正确
    BOOL result =  [self  isMobile:_userView.secondaryField.text];
    
    if (result){
    
        //创建请求管理者
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager  manager];
        mgr.responseSerializer = [AFJSONResponseSerializers  serializer];
        
        //配置请求超时时间
        mgr.requestSerializer.timeoutInterval = 60;

        //设置请求参数
        NSMutableDictionary  *params = [NSMutableDictionary  dictionary];
        params[@"phonenum"] = _userView.secondaryField.text;
        
        NSString  *urlStr =[NSString  stringWithFormat:@"%@/appSendRePwdCode" ,HomecooServiceURL];
        NSString *url = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
        
        [mgr  POST:url parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            
            //打印日志
            //NSLog(@"请求成功--%@",responseObject);
            NSString  *result = [responseObject[@"result"]description];
            NSString *message = [responseObject[@"messageInfo"]description];
            
            if ([result  isEqual:@"success"]) {
                
                [MBProgressHUD  showSuccess:[NSString  stringWithFormat:@"%@",message]];
                
            } if ([result  isEqual:@"failed"]) {
                
                [MBProgressHUD  showError:[NSString  stringWithFormat:@"%@",message]];
                
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
            [MBProgressHUD  showError:@"网络繁忙，请稍后再试"];
        }];
    }else{
    
        UIAlertView  *alertView = [[UIAlertView  alloc]initWithTitle:@"温馨提示" message:@"请输入正确的手机号码 !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];

    
    }
}

-(void)makeSureViewClicked:(HCGatewayView *)daterView{

    //判断手机号码是否正确
    BOOL result =  [self  isMobile:_resetPwdView.secondaryField.text];
    
    if (result){
        
        if ([_resetPwdView.thirdField.text isEqualToString:_resetPwdView.fourthField.text]) {
            
            if ([_resetPwdView.thirdField.text length]>=6) {
                
                //创建请求管理者
                AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager  manager];
                mgr.responseSerializer = [AFJSONResponseSerializers  serializer];
                
                //配置请求超时时间
                mgr.requestSerializer.timeoutInterval = 60;
                
                //设置请求参数
                NSMutableDictionary  *params = [NSMutableDictionary  dictionary];
                params[@"phonenum"] = _resetPwdView.secondaryField.text;
                params[@"newPassword"] = [_resetPwdView.thirdField.text md5String];
                
                NSString  *urlStr =[NSString  stringWithFormat:@"%@/appUpdatePassword" ,HomecooServiceURL];
                NSString *url = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
                
                [mgr  POST:url parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                    
                    //打印日志
                    //NSLog(@"请求成功--%@",responseObject);
                    NSString  *result = [responseObject[@"result"]description];
                    NSString *message = [responseObject[@"messageInfo"]description];
                    
                    if ([result  isEqual:@"success"]) {
                        
                        [MBProgressHUD  showSuccess:[NSString  stringWithFormat:@"%@",message]];
                        
                    } if ([result  isEqual:@"failed"]) {
                        
                        [MBProgressHUD  showError:[NSString  stringWithFormat:@"%@",message]];
                        
                    }
                    
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    [MBProgressHUD  showError:@"网络繁忙，请稍后再试"];
                }];
            
            }else{
            
                UIAlertView  *alertView = [[UIAlertView  alloc]initWithTitle:@"温馨提示" message:@"请输入至少6位数的密码 !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
            
            }
            
        }else{
            
            UIAlertView  *alertView = [[UIAlertView  alloc]initWithTitle:@"温馨提示" message:@"密码输入不一致 !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        
        }
        
        
    }else{
    
        UIAlertView  *alertView = [[UIAlertView  alloc]initWithTitle:@"温馨提示" message:@"请输入正确的手机号码 !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    
    }
    
}

/**
 *  记住用户名和密码
 */
- (void)saveUserAndPwd{
    
    NSArray *user = self.users;//次方法不可行，原因未知
   
    NSInteger count = user.count;
    
    if (count == 0) {
        
    }else{
        
        userMessage *users = user[count-1];
        self.userNameText.text = users.phone_Num;
        self.pwdText.text = users.password;
        
    }
    
}

/**
 *  远程连接
 */
-(void)remoteConnectToHost{

    //每次在登陆之前，首先登录判断的是否是否存在网关，如果没有就先设置为空，如果有网关就将网关的id，设置为别名
    LZXDataCenter *gatewayno = [LZXDataCenter defaultDataCenter];

    NSArray *gatewayArray = [gatewayMessageTool queryWithgateways];
    
    if (gatewayArray.count == 0) {
        //每次调用之前清空之前的别名
        [JPUSHService setAlias:@"" callbackSelector:nil object:nil];
        
    }else{
        
        gatewayMessageModel *gateway = gatewayArray[0];
        gatewayno.gatewayNo =gateway.gatewayID;
        gatewayno.gatewayIP = gateway.gatewyIP;
        gatewayno.gatewayPwd = gateway.gatewayPWD;
        //将该网关编号设置为 别名
        [JPUSHService  setAlias:gateway.gatewayID callbackSelector:nil object:nil];
        
    }
    
    NSString  *userName = self.userNameText.text;
    NSString  *userPwd = [self.pwdText.text md5String];
    
    LZXDataCenter *userPhoneNum = [LZXDataCenter defaultDataCenter];
    
    //创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager  manager];
    mgr.responseSerializer = [AFJSONResponseSerializers  serializer];
    
    //配置请求超时时间
    mgr.requestSerializer.timeoutInterval = 60;
    
    [MBProgressHUD  showMessage:@"正在切换远程登陆…"];
    
    //设置请求参数
    NSMutableDictionary  *params = [NSMutableDictionary  dictionary];
    params[@"phonenum"] = userName;
    params[@"password"] = userPwd;
    
    NSString  *urlStr =[NSString  stringWithFormat:@"%@/appLogin" ,HomecooServiceURL];
    
    NSString *url = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
     [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        //打印日志
        // NSLog(@"请求成功--%@",responseObject);
        
        NSString  *result = [responseObject[@"result"]description];
        
        NSString *message = [responseObject[@"messageInfo"]description];
        
        if ([result  isEqual:@"success"]) {//成功获取验证码
            
            //利用单例传值 将该手机号定义为全局变量
            userPhoneNum.userPhoneNum  = userName;
            userPhoneNum.networkStateFlag = 1;//表示远程
            userMessage *user = [[userMessage alloc]init];
            
            user.phone_Num = userName;
            
            NSArray * userArray =  [userMessageTool queryWithgUsers:user];
            
            if (userArray.count == 0) {//没有此用户
                [userMessageTool deleteUserTable];
                userMessage *user = [[userMessage  alloc]init];
                
                user.phone_Num = userName;
                user.password = self.pwdText.text;
                
                [userMessageTool  addUser:user];
                
                
            }else{
               
                userMessage *user = [[userMessage  alloc]init];
                
                user.phone_Num = userName;
                user.password = self.pwdText.text;
                
                [userMessageTool  updateUserPWD:user];
                
            }
            
            SystemViewController  *systemVc = [[SystemViewController  alloc]init];
            [self  presentViewController:systemVc animated:YES completion:nil];
             self.flag =0;
            [MBProgressHUD  loginHideHUD];//隐藏蒙版
            
        }
        if ([result  isEqual:@"failed"]) {
             [MBProgressHUD  loginHideHUD];//隐藏蒙版
            
            [MBProgressHUD  showError:[NSString  stringWithFormat:@"%@",message]];

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD  loginHideHUD];//隐藏蒙版
        
        
    }];
    
    [self  onLoginPress];
}

/**
 *  摄像头登录
 *
 *  @param sender
 */
-(void)onLoginPress{
    
    NSString *username =[self.userNameText.text  stringByAppendingString:@"@homecoo.com.cn"];
    NSString *password = self.pwdText.text;
        
    [[NetManager sharedManager] loginWithUserName:username password:password token:[AppDelegate sharedDefault].token callBack:^(id result){
        
        LoginResult *loginResult = (LoginResult*)result;
                   
        
        switch(loginResult.error_code){
            case NET_RET_LOGIN_SUCCESS:
            {
                if (CURRENT_VERSION<9.3) {
                    if(CURRENT_VERSION>=8.0){//8.0以后使用这种方法来注册推送通知
                        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
                        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
                        [[UIApplication sharedApplication] registerForRemoteNotifications];
                        
                    }else{
                        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
                    }
                }
                
                [UDManager setIsLogin:YES];
                [UDManager setLoginInfo:loginResult];
                [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"USER_NAME"];
                [[NSUserDefaults standardUserDefaults] setInteger:self.loginType forKey:@"LOGIN_TYPE"];

                [[NetManager sharedManager] getAccountInfo:loginResult.contactId sessionId:loginResult.sessionId callBack:^(id JSON){
                    AccountResult *accountResult = (AccountResult*)JSON;
                    loginResult.email = accountResult.email;
                    loginResult.phone = accountResult.phone;
                    loginResult.countryCode = accountResult.countryCode;
                    [UDManager setLoginInfo:loginResult];
                }];
                
                [[NetManager sharedManager] checkNewMessage:loginResult.contactId sessionId:loginResult.sessionId callBack:^(id JSON){
                    CheckNewMessageResult *checkNewMessageResult = (CheckNewMessageResult*)JSON;
                    if(checkNewMessageResult.error_code==NET_RET_CHECK_NEW_MESSAGE_SUCCESS){
                        if(checkNewMessageResult.isNewContactMessage){
                            DLog(@"have new");
                            [[NetManager sharedManager] getContactMessageWithUsername:loginResult.contactId sessionId:loginResult.sessionId callBack:^(id JSON){
                                NSArray *datas = [NSArray arrayWithArray:JSON];
                                if([datas count]<=0){
                                    return;
                                }
                                BOOL haveContact = NO;
                                for(GetContactMessageResult *result in datas){
                                    DLog(@"%@",result.message);
                                    ContactDAO *contactDAO = [[ContactDAO alloc] init];
                                    Contact *contact = [contactDAO isContact:result.contactId];
                                    if(nil!=contact){
                                        haveContact = YES;
                                    }
                                    [contactDAO release];
                                    
                                    MessageDAO *messageDAO = [[MessageDAO alloc] init];
                                    Message *message = [[Message alloc] init];
                                    
                                    message.fromId = result.contactId;
                                    message.toId = loginResult.contactId;
                                    message.message = [NSString stringWithFormat:@"%@",result.message];
                                    message.state = MESSAGE_STATE_NO_READ;
                                    message.time = [NSString stringWithFormat:@"%@",result.time];
                                    message.flag = result.flag;
                                    [messageDAO insert:message];
                                    [message release];
                                    [messageDAO release];
                                    int lastCount = [[FListManager sharedFList] getMessageCount:result.contactId];
                                    [[FListManager sharedFList] setMessageCountWithId:result.contactId count:lastCount+1];
                                    
                                }
                                if(haveContact){
                                    [Utils playMusicWithName:@"message" type:@"mp3"];
                                }
                                
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMessage"
                                                                                    object:self
                                                                                  userInfo:nil];
                            }];
                        }
                    }else{
                        
                    }
                }];
                
            }
                break;
            case NET_RET_LOGIN_USER_UNEXIST:
            {
                [self.view makeToast:NSLocalizedString(@"user_unexist", nil)];
            }
                break;
            case NET_RET_LOGIN_PWD_ERROR:
            {
                [self.view makeToast:NSLocalizedString(@"password_error", nil)];
            }
                break;
            case NET_RET_LOGIN_EMAIL_FORMAT_ERROR:
            {
                [self.view makeToast:NSLocalizedString(@"user_unexist", nil)];
            }
                break;
                
            default:
            {
                
                [self.view makeToast:[NSString stringWithFormat:@"%@:%i",NSLocalizedString(@"login_failure", nil),loginResult.error_code]];
            }
                break;
        }
        
    }];
        
  
}

/**
 *  本地连接
 */
-(void)localConnectToHost{
    
    
    SocketManager *socketManager = [SocketManager shareSocketManager];
    LZXDataCenter *gatewayno = [LZXDataCenter defaultDataCenter];
   
   
    NSString *gatewayID;
    NSString *gatewayIP;
    NSString *gatewayPwd;
    NSArray *gatewayArray = [gatewayMessageTool queryWithgateways];
    
    //内网登录的情况下  关闭jpush接收
    if (!(gatewayArray.count == 0)) {
        
        gatewayMessageModel *gatewayModel = gatewayArray[0];
        
        gatewayno.gatewayNo =gatewayModel.gatewayID;
        gatewayno.gatewayIP = gatewayModel.gatewyIP;
        gatewayno.gatewayPwd = gatewayModel.gatewayPWD;

        gatewayID =gatewayModel.gatewayID;
        gatewayIP = gatewayModel.gatewyIP;
        gatewayPwd =[ControlMethods  stringToByte:gatewayModel.gatewayPWD];
        
        //将该网关编号设置为 别名
       //NSLog(@"gatewayno.gatewayNo = %@",gatewayno.gatewayNo);
       [JPUSHService setAlias:gatewayno.gatewayNo callbackSelector:nil object:nil];
    
    }else{
       
        gatewayID = @"0000000000000000";
        gatewayIP = @"192.168.0.0";
        gatewayPwd = @"3838383838383838";
        //每次调用之前清空之前的别名
        [JPUSHService setAlias:@"" callbackSelector:nil object:nil];
    
    }
    
    NSString *head = @"4141444430303030";
    NSString *datas = [@"000000000000000032001C000008"  stringByAppendingString:gatewayPwd];
    NSString *gatewayConnectStr1 = [head  stringByAppendingString:gatewayID];
    NSString *gatewayConnectStr = [gatewayConnectStr1 stringByAppendingString:datas];
    
    [socketManager startConnectHost:gatewayIP WithPort:9091];
    
    [socketManager sendMsg:gatewayConnectStr];
   
    [socketManager  receiveMsg:^(NSString *receiveInfo) {
        
        if ([[receiveInfo  substringFromIndex:receiveInfo.length -10] isEqualToString:@"4300000100"]) {
           
            dispatch_queue_t queue = dispatch_get_main_queue();
            
            dispatch_async(queue, ^{
                //开始广播搜索七寸屏的IP
                [self receivedUdpGB];
                
                if (self.flag ==5) {
                    
                    
                    SystemViewController  *systemVc = [[SystemViewController  alloc]init];
                    
                    [self  presentViewController:systemVc animated:YES completion:nil];
                    //利用单例传值
                    NSString  *userName = self.userNameText.text;
                    LZXDataCenter *userPhoneNum = [LZXDataCenter defaultDataCenter];
                    userPhoneNum.userPhoneNum  = userName;
                    userPhoneNum.networkStateFlag = 0;//表示本地
                   
                    [userMessageTool deleteUserTable];
                    userMessage *user = [[userMessage  alloc]init];
                    
                    user.phone_Num = userName;
                    user.password = self.pwdText.text;
                    [userMessageTool  addUser:user];
                    
                    [MBProgressHUD  loginHideHUD];
                  
                    self.flag =0;
              
                }
   
            });
            
        }
       
    }  ];

    [self  onLoginPress];
}

- (void)receivedUdpGB{
    
    _udpManager= [UdpSocketManager shareUdpSocketManager];
    
    _udpManager.udpSocket.delegate = self;
    
    NSError *error;
    if([_udpManager.udpSocket enableBroadcast:YES error:&error]){
        NSLog(@"udpSocket = %@",error);
    }
    NSString *test = @"S";

    test = [test stringByAppendingString:[LZXDataCenter defaultDataCenter].gatewayNo];

    NSData *data = [test dataUsingEncoding:NSUTF8StringEncoding];

    [_udpManager runloopSendData:data host:@"255.255.255.255" port:8004 interval:1];
    [_udpManager begingReceived:8004];

}

#pragma mark *******************************************

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext{
    
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSString *subStr = [str substringToIndex:1];
    
    if([subStr isEqualToString:@"C"]){
        
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        if ([[LZXDataCenter defaultDataCenter].QICUNPINGIP isEqualToString:str]) {
            
        }else{

            [LZXDataCenter defaultDataCenter].QICUNPINGIP = str;
            
        }
        self.socketManger = [GGSocketManager shareGGSocketManager];

        [self.socketManger startConnectHost:[str substringFromIndex:1] WithPort:8000];
        
        self.socketManger.socket.delegate = self;
        
        NSDictionary *paramDict = @{@"order":@23,@"wgid":[LZXDataCenter defaultDataCenter].gatewayNo};

        NSData *tempData = [NSJSONSerialization dataWithJSONObject:paramDict options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *json = [[NSString alloc]initWithData:tempData encoding:NSUTF8StringEncoding];
        
        json = [json stringByAppendingString:@"\0"];
        
        [self.socketManger sendMsg:json];

    }
    
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error{
    
    NSLog(@"广播失败");
}

//- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
//    
//    NSLog(@"发送成功");
//}


#pragma mark *********TCP socket*********

#pragma mark GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    
    //连接到服务端时同样要设置监听，否则收不到服务器发来的消息
    [sock readDataWithTimeout:-1 tag:0];
    self.socketManger.gatewayIP = 1;
    NSLog(@"socket连接成功");
}


- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    //当接受到服务器发来的消息时，同样设置监听，否则只会收到一次
    [sock readDataWithTimeout:-1 tag:0];
    NSString *readDataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    if([[readDataStr  substringFromIndex:readDataStr.length -2] isEqualToString:@"ff"]){//网关认证未通过
        
        self.socketManger.socketStatus = 0;
       
        
    }
    
    readDataStr = [readDataStr substringToIndex:readDataStr.length-1];
    
    NSData *tempData = [readDataStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:tempData options:NSJSONReadingMutableContainers error:nil];
    
    NSLog(@"收到的内容=%@",dict);
    
    if([dict[@"order"] isEqualToString:@"24"]){
       
        [_udpManager stopRunloopSendData];
        
        NSLog(@"停止广播");
        
        [self.socketManger closeSocket];
        
    }

}

/**
 *登录系统
 */
- (void)loginAction {
    
    SocketManager *socketManager = [SocketManager shareSocketManager];
    
    [MBProgressHUD  showMessage:@"正在本地登录中…"];
    
    NSString *passWord;
    
    userMessage *user = [[userMessage alloc]init];
    
    user.phone_Num = self.userNameText.text;

    NSArray * userArray =  [userMessageTool queryWithgUsers:user];
    
    if (userArray.count!=0) {
        
        userMessage *realPassWord =userArray[0];
        passWord = realPassWord.password;
       
        if ([passWord isEqualToString:self.pwdText.text]) {
            //优先使用本地登录
            [self  localConnectToHost];
            
        }
    }
    
    dispatch_queue_t  queue = dispatch_get_main_queue();
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3* NSEC_PER_SEC)),
                   queue, ^{
                      
                       if ([socketManager sockeConnectStatus] == 0) {//本地连接失败，切换远程登录
                         
                           [MBProgressHUD  loginHideHUD];
                           
                           [self  remoteConnectToHost];
                           
                       }
                      
                   });
      
}

/**
 *注册用户
 */
- (void)registerAction{
    
    registerViewController  *regestPhoneVC = [[registerViewController  alloc]init];
    [self  presentViewController:regestPhoneVC animated:YES completion:nil];
    
}

/**
 *  手机号码验证
 *
 *  @param mobileNumbel 传入的手机号码
 *
 *  @return 格式正确返回true  错误 返回false
 */
-(BOOL) isMobile:(NSString *)mobileNumbel{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189,181(增加)
     */
    NSString * MOBIL = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,181(增加)
     22         */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNumbel]
         || [regextestcm evaluateWithObject:mobileNumbel]
         || [regextestct evaluateWithObject:mobileNumbel]
         || [regextestcu evaluateWithObject:mobileNumbel])) {
        return YES;
    }
    
    return NO;
}
-(BOOL)shouldAutorotate{
    return YES;
}



-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}


@end


