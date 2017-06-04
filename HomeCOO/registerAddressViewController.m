//
//  registerAddressViewController.m
//  HomeCOO
//
//  Created by tgbus on 16/5/2.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "registerAddressViewController.h"
#import "verificationCodeController.h"
#import "AppDelegate.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworkings.h"
#import "userObiect.h"
#import "PrefixHeader.pch"
#import "LoginViewController.h"
#import "NSString+Hash.h"
#import "NetManager.h"
#import "RegisterResult.h"
#import "LoginController.h"
#import "Toast+UIView.h"
#import "UIView+Extension.h"
#import "LZXDataCenter.h"
@interface registerAddressViewController ()<UITextFieldDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>
/**设置背景图片*/
@property(nonatomic,strong)  UIImageView   *fullscreenView;// UIView  * fullscreenView;

@property(nonatomic,strong)  UIScrollView   *scrollView;/**设置导航栏*/

@property NSInteger keyBoardHeight;

/**设置导航栏*/
@property(nonatomic,weak)  UINavigationBar *navBar;

/**用户名信息填写*/
@property(nonatomic,weak)  UILabel  *userNmaeLable;

/**用户名信息填写*/
@property(nonatomic,weak)  UITextField *userNameText;

/**用户名信息必填项*/
@property(nonatomic,weak) UIImageView  *userRemandView ;

/**用户密码必填项*/
@property(nonatomic,weak) UILabel  *pwdLable;

/**用户密码必填项*/
@property(nonatomic,weak) UITextField *pwdText;

/**用户确认密码*/
@property(nonatomic,weak)  UILabel  *confirmPwdLable;

/**用户确认密码*/
@property(nonatomic,weak)  UITextField *confirmPwdText;

/**用户输入手机号*/
@property(nonatomic,weak)  UILabel  *inputPhoneNumLable;

/**用户输入手机号*/
@property(nonatomic,weak)  UITextField *inputPhoneNumText;

/**用户输入邮箱*/
@property(nonatomic,weak)  UILabel  *inputEmailLable;

/**用户输入邮箱*/
@property(nonatomic,weak)  UITextField *inputEmailText;

/**用户输入姓名*/
@property(nonatomic,weak)  UILabel  *inputUserNameLable;

/**用户输入姓名*/
@property(nonatomic,weak)  UITextField *inputUserNameText;

/**用户输入注册用户信息*/
@property(nonatomic,weak)  UILabel  *inputUserAddressLable;

/**用户输入注册用户信息*/
@property(nonatomic,weak)  UITextField *inputUserAddressText;

/**添加备注信息*/
@property(nonatomic,weak)  UILabel  *noteLbale;

@property (strong,nonatomic) LoginController *loginController;

@end

@implementation registerAddressViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self  addUIScrollView];
    
    [self  registerKeyBoardNotification];
    
    [self  TapGestureRecognizer];
    //创建一个导航栏
    [self setNavBar];
    
    //添加用户名注册信息
    [self  setUserNameView];
    
    //添加用户密码信息
    [self setPwdLableView];
    
    //用户确认密码
    [self confirmPwd];
    
    //输入用户手机号
    [self  inputPhoneNum];
    
    //输入用户邮箱
    [self inputEmail];
    
    //输入用户姓名
    [self  inputUserName];
    
    //添加提交按钮
    [self  submitBtn];
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
    if (![_confirmPwdText isExclusiveTouch]) {
        [_confirmPwdText resignFirstResponder];
    }
    if (![_inputPhoneNumText isExclusiveTouch]) {
        [_inputPhoneNumText resignFirstResponder];
    }
    if (![_inputEmailText isExclusiveTouch]) {
        [_inputEmailText resignFirstResponder];
    }
    if (![_inputUserNameText isExclusiveTouch]) {
        [_inputUserNameText resignFirstResponder];
    }

    
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
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)),  dispatch_get_main_queue(), ^{
        
        NSInteger key = self.view.height - CGRectGetMaxY(textField.frame);
        
        NSInteger keyBounds = self.keyBoardHeight -key  ;
        
//        NSLog(@"   keyBounds = %ld  key = %ld  %f  self.keyBoardHeight = %ld"  ,(long)keyBounds,(long)key,CGRectGetMaxY(textField.frame),(long)self.keyBoardHeight);
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
 *设置导背景图片
 */
-(void)setFullscreenView{
    
    UIView  *fullscreenView = [[UIView  alloc]init];
    UIImage  *image = [UIImage imageNamed:@"bg_fullscreen.jpg"];
    /**设置背景图片的大小*/
    fullscreenView.backgroundColor = [UIColor  colorWithPatternImage:image];
    CGFloat fullscreenViewW = [UIScreen  mainScreen].bounds.size.width;
    CGFloat fullscreenViewH = [UIScreen  mainScreen].bounds.size.height;
    fullscreenView.frame = CGRectMake(0, 0, fullscreenViewW, fullscreenViewH);
    self.fullscreenView = fullscreenView;
    [self.view  addSubview:fullscreenView];
    
    
    
}

/**
 *设置导航栏
 */
-(void)setNavBar{
    CGFloat navBarW = [UIScreen  mainScreen].bounds.size.width;
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0,navBarW, 40)];
    //创建一个导航栏集合
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"注册账号"];
    
    //设置字体大小
    [[UINavigationBar appearance]setTitleTextAttributes:
     @{ NSFontAttributeName: [UIFont systemFontOfSize:16.0]}];
    
    //创建一个左边按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleBordered target:self action:@selector(backAction)];
    //给按钮添加图片
    
    
    //设置字体大小
    [[UIBarButtonItem appearance] setTitleTextAttributes:
     
     @{ NSFontAttributeName: [UIFont systemFontOfSize:15.0]} forState:UIControlStateNormal];
    

    leftButton.title = @"返回";
    leftButton.tintColor = [UIColor  blackColor];
    
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

/**返回到上一个界面*/
-(void)backAction{
    
    [self  dismissViewControllerAnimated:YES completion:nil];
    
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
 *填写用户名注册信息
 */
-(void)setUserNameView{
    
    UILabel  *userNmaeLable = [[UILabel  alloc]init];
    
    CGFloat  userNmaeLableX = 40;
    CGFloat  userNmaeLableY = 70;
    CGFloat  userNmaeLableW = 70;
    CGFloat  userNmaeLableH = 35;
    
    
    //添加用户名lable 的背景颜色
    //userNmaeLable.backgroundColor = [UIColor  redColor];
    userNmaeLable.text = @"用户名：";
    userNmaeLable.textAlignment = NSTextAlignmentCenter;
    userNmaeLable.font = [UIFont  systemFontOfSize:16];
    
    userNmaeLable.frame = CGRectMake(userNmaeLableX, userNmaeLableY, userNmaeLableW, userNmaeLableH);
    userNmaeLable.clipsToBounds = YES;
    userNmaeLable.layer.cornerRadius = 8.0;//设置边框圆角
    self.userNmaeLable = userNmaeLable;
    
    //添加用户名输入文本框
    UITextField *userNameText = [[UITextField  alloc]init];
    CGFloat  userNameTextX = CGRectGetMaxX(userNmaeLable.frame) +10;
    CGFloat  userNameTextY = 70 ;
    CGFloat  userNameTextW = [UIScreen  mainScreen].bounds.size.width / 4;
    CGFloat  userNameTextH = 35;
    
    //清除背景底色
    //userNameText.backgroundColor = [UIColor clearColor];
    [userNameText.layer setCornerRadius:8.0];//设置边框圆角
    userNameText.font = [UIFont  systemFontOfSize:18];
    userNameText.clearButtonMode = UITextFieldViewModeWhileEditing;
    userNameText.frame = CGRectMake(userNameTextX, userNameTextY, userNameTextW, userNameTextH);
    userNameText.text = [LZXDataCenter defaultDataCenter].textStr;
    userNameText.userInteractionEnabled = NO;
    userNameText.delegate = self;
    //添加用户名文本框背景图片
    UIImageView *userImgView=[[UIImageView alloc] initWithFrame:userNameText.bounds];
    
    userImgView.image=[UIImage imageNamed:@"注册输入框.png"];
    userImgView.contentMode = UIViewContentModeScaleToFill;
    [userNameText  addSubview:userImgView];
    //sendSubviewToBack 将该subview置于最底层
    [userNameText sendSubviewToBack:userImgView];
    self.userNameText = userNameText;
    

    //添加必填项图片
    UIImageView  *userRemandView = [[UIImageView alloc]init];
    userRemandView.image = [UIImage  imageNamed:@"红色标记.png"];
    //userRemandView.contentMode = UIViewContentModeScaleToFill;
    
    CGFloat userRemandViewX = CGRectGetMaxX(userNameText.frame) + 10;
    CGFloat userRemandViewY = 85;
    CGFloat userRemandViewW =6;
    CGFloat userRemandViewH =6;
    
    userRemandView.frame = CGRectMake(userRemandViewX, userRemandViewY, userRemandViewW, userRemandViewH);
    
    [self.fullscreenView  addSubview:userNmaeLable];
    [self.fullscreenView   addSubview:userNameText];
    [self.fullscreenView   addSubview:userRemandView];

    
}
/**
 *填写用户密码
 */

-(void)setPwdLableView{
    UILabel  *pwdLable =[[UILabel  alloc]init];
    
    CGFloat  pwdLableX = 40;
    CGFloat  pwdLableY = CGRectGetMaxY(self.userNmaeLable.frame) + 10;
    CGFloat  pwdLableW = 70;
    CGFloat  pwdLableH = 35;
    
    
    //添加用户名lable 的背景颜色
    //pwdLable.backgroundColor = [UIColor  redColor];
    pwdLable.text = @"密   码: ";
    pwdLable.textAlignment = NSTextAlignmentCenter;
    pwdLable.font = [UIFont  systemFontOfSize:16];
    
    pwdLable.frame = CGRectMake(pwdLableX, pwdLableY, pwdLableW, pwdLableH);
    pwdLable.clipsToBounds = YES;
    pwdLable.layer.cornerRadius = 8.0;//设置边框圆角
    self.pwdLable = pwdLable;
    
    //添加用户名输入文本框
    UITextField *pwdText = [[UITextField  alloc]init];
    CGFloat  pwdTextX = CGRectGetMaxX(pwdLable.frame) +10;
    CGFloat  pwdTextY = CGRectGetMaxY(self.userNmaeLable.frame) + 10; ;
    CGFloat  pwdTextW = [UIScreen  mainScreen].bounds.size.width / 4;
    CGFloat  pwdTextH = 35;
    
    [pwdText.layer setCornerRadius:8.0];//设置边框圆角
    pwdText.font = [UIFont  systemFontOfSize:18];
    pwdText.secureTextEntry = YES;
    pwdText.clearButtonMode = UITextFieldViewModeWhileEditing;
    pwdText.frame = CGRectMake(pwdTextX, pwdTextY, pwdTextW, pwdTextH);
    pwdText.delegate = self;
    
    //添加用户名文本框背景图片
    UIImageView *userImgView=[[UIImageView alloc] initWithFrame:pwdText.bounds];
    userImgView.image=[UIImage imageNamed:@"注册输入框.png"];
    userImgView.contentMode = UIViewContentModeScaleToFill;
    [pwdText  addSubview:userImgView];
    //sendSubviewToBack 将该subview置于最底层
    [pwdText sendSubviewToBack:userImgView];
    self.pwdText = pwdText;
    
    
    //添加必填项图片
    UIImageView  *pwdRemandView = [[UIImageView alloc]init];
    pwdRemandView.image = [UIImage  imageNamed:@"红色标记.png"];
    
    CGFloat pwdRemandViewX = CGRectGetMaxX(pwdText.frame) + 10;
    CGFloat pwdRemandViewY = CGRectGetMaxY(self.userNameText.frame) +25;
    CGFloat pwdRemandViewW =6;
    CGFloat pwdRemandViewH =6;
    
    pwdRemandView.frame = CGRectMake(pwdRemandViewX, pwdRemandViewY, pwdRemandViewW, pwdRemandViewH);
    
    [self.fullscreenView  addSubview:pwdLable];
    [self.fullscreenView  addSubview:pwdText];
    [self.fullscreenView  addSubview:pwdRemandView];


}


/**
 *用户确认密码
 */

-(void)confirmPwd{

    UILabel  *confirmPwdLable =[[UILabel  alloc]init];
    
    CGFloat  confirmPwdLableX = 30;
    CGFloat  confirmPwdLableY = CGRectGetMaxY(self.pwdLable.frame) + 10;
    CGFloat  confirmPwdLableW = 80;
    CGFloat  confirmPwdLableH = 35;
    
    
    //添加用户名lable 的背景颜色
    //confirmPwdLable.backgroundColor = [UIColor  redColor];
    confirmPwdLable.text = @"确认密码:";
    confirmPwdLable.textAlignment = NSTextAlignmentCenter;
    confirmPwdLable.font = [UIFont  systemFontOfSize:16];
    
    confirmPwdLable.frame = CGRectMake(confirmPwdLableX, confirmPwdLableY, confirmPwdLableW, confirmPwdLableH);
    confirmPwdLable.clipsToBounds = YES;
    confirmPwdLable.layer.cornerRadius = 8.0;//设置边框圆角
    self.confirmPwdLable = confirmPwdLable;
    
    //添加用户名输入文本框
    UITextField *confirmPwdText = [[UITextField  alloc]init];
    CGFloat  confirmPwdTextX = CGRectGetMaxX(confirmPwdLable.frame) +10;
    CGFloat  confirmPwdTextY = CGRectGetMaxY(self.pwdText.frame) + 10; ;
    CGFloat  confirmPwdTextW = [UIScreen  mainScreen].bounds.size.width / 4;
    CGFloat  confirmPwdTextH = 35;
    
    [confirmPwdText.layer setCornerRadius:8.0];//设置边框圆角
    confirmPwdText.font = [UIFont  systemFontOfSize:18];
    confirmPwdText.secureTextEntry = YES;
    confirmPwdText.clearButtonMode = UITextFieldViewModeWhileEditing;
    confirmPwdText.frame = CGRectMake(confirmPwdTextX, confirmPwdTextY, confirmPwdTextW, confirmPwdTextH);
    confirmPwdText.delegate = self;
    
    //添加用户名文本框背景图片
    UIImageView *userImgView=[[UIImageView alloc] initWithFrame:confirmPwdText.bounds];
    userImgView.image=[UIImage imageNamed:@"注册输入框.png"];
    userImgView.contentMode = UIViewContentModeScaleToFill;
    [confirmPwdText  addSubview:userImgView];
    //sendSubviewToBack 将该subview置于最底层
    [confirmPwdText sendSubviewToBack:userImgView];
    self.confirmPwdText = confirmPwdText;
    
    
    //添加必填项图片
    UIImageView  *confirmPwdRemandView = [[UIImageView alloc]init];
    confirmPwdRemandView.image = [UIImage  imageNamed:@"红色标记.png"];
    //userRemandView.contentMode = UIViewContentModeScaleToFill;
    
    CGFloat confirmPwdRemandViewX = CGRectGetMaxX(confirmPwdText.frame) + 10;
    CGFloat confirmPwdRemandViewY = CGRectGetMaxY(self.pwdText.frame) +25;
    CGFloat confirmPwdRemandViewW =6;
    CGFloat confirmPwdRemandViewH =6;
    
    confirmPwdRemandView.frame = CGRectMake(confirmPwdRemandViewX, confirmPwdRemandViewY, confirmPwdRemandViewW, confirmPwdRemandViewH);
    
    
    [self.fullscreenView  addSubview:confirmPwdLable];
    [self.fullscreenView  addSubview:confirmPwdText];
    [self.fullscreenView  addSubview:confirmPwdRemandView];
    
}

/**
 *用户输入姓名
 */

-(void)inputPhoneNum{

    UILabel  *inputPhoneNumLable = [[UILabel  alloc]init];
    
    CGFloat  inputPhoneNumLableX = CGRectGetMaxX(self.userNameText.frame) + 40;
    CGFloat  inputPhoneNumLableY = 70;
    CGFloat  inputPhoneNumLableW = 70;
    CGFloat  inputPhoneNumLableH = 35;
    
    
    //添加用户名lable 的背景颜色
    //inputPhoneNumLable.backgroundColor = [UIColor  redColor];
    inputPhoneNumLable.text = @"姓  名:";
    inputPhoneNumLable.textAlignment = NSTextAlignmentCenter;
    inputPhoneNumLable.font = [UIFont  systemFontOfSize:16];
    
    inputPhoneNumLable.frame = CGRectMake(inputPhoneNumLableX, inputPhoneNumLableY, inputPhoneNumLableW, inputPhoneNumLableH);
    inputPhoneNumLable.clipsToBounds = YES;
    inputPhoneNumLable.layer.cornerRadius = 8.0;//设置边框圆角
    self.inputPhoneNumLable = inputPhoneNumLable;
    
    //添加用户名输入文本框
    UITextField *inputPhoneNumText = [[UITextField  alloc]init];
    CGFloat  inputPhoneNumTextX = CGRectGetMaxX(inputPhoneNumLable.frame) +10;
    CGFloat  inputPhoneNumTextY = 70 ;
    CGFloat  inputPhoneNumTextW = [UIScreen  mainScreen].bounds.size.width / 4;
    CGFloat  inputPhoneNumTextH = 35;
    
    [inputPhoneNumText.layer setCornerRadius:8.0];//设置边框圆角
    inputPhoneNumText.font = [UIFont  systemFontOfSize:18];
    inputPhoneNumText.clearButtonMode = UITextFieldViewModeWhileEditing;
    inputPhoneNumText.delegate =self;
    inputPhoneNumText.frame = CGRectMake(inputPhoneNumTextX, inputPhoneNumTextY, inputPhoneNumTextW, inputPhoneNumTextH);
    //添加用户名文本框背景图片
    UIImageView *userImgView=[[UIImageView alloc] initWithFrame:inputPhoneNumText.bounds];
    userImgView.image=[UIImage imageNamed:@"注册输入框.png"];
    userImgView.contentMode = UIViewContentModeScaleToFill;
    [inputPhoneNumText  addSubview:userImgView];
    //sendSubviewToBack 将该subview置于最底层
    [inputPhoneNumText sendSubviewToBack:userImgView];
    self.inputPhoneNumText = inputPhoneNumText;
    
    [self.fullscreenView  addSubview:inputPhoneNumLable];
    [self.fullscreenView   addSubview:inputPhoneNumText];
   
}

/**
 *用户邮箱输入
 */


-(void)inputEmail{

    UILabel  *inputEmailLable = [[UILabel  alloc]init];
    
    CGFloat  inputEmailLableX = CGRectGetMaxX(self.pwdText.frame) + 40;
    CGFloat  inputEmailLableY = CGRectGetMaxY(self.inputPhoneNumLable.frame) +10;
    CGFloat  inputEmailLableW = 70;
    CGFloat  inputEmailLableH = 35;
    
    //添加用户名lable 的背景颜色
    //inputEmailLable.backgroundColor = [UIColor  redColor];
    inputEmailLable.text = @"邮  箱:";
    inputEmailLable.textAlignment = NSTextAlignmentCenter;
    inputEmailLable.font = [UIFont  systemFontOfSize:16];
    
    inputEmailLable.frame = CGRectMake(inputEmailLableX, inputEmailLableY, inputEmailLableW, inputEmailLableH);
    inputEmailLable.clipsToBounds = YES;
    inputEmailLable.layer.cornerRadius = 8.0;//设置边框圆角
    self.inputEmailLable = inputEmailLable;
    
    //添加用户名输入文本框
    UITextField *inputEmailText = [[UITextField  alloc]init];
    CGFloat  inputEmailTextX = CGRectGetMaxX(inputEmailLable.frame) +10;
    CGFloat  inputEmailTextY = CGRectGetMaxY(self.inputPhoneNumLable.frame) +10; ;
    CGFloat  inputEmailTextW = [UIScreen  mainScreen].bounds.size.width / 4;
    CGFloat  inputEmailTextH = 35;
    
    [inputEmailText.layer setCornerRadius:8.0];//设置边框圆角
    inputEmailText.font = [UIFont  systemFontOfSize:18];
    inputEmailText.clearButtonMode = UITextFieldViewModeWhileEditing;
    inputEmailText.frame = CGRectMake(inputEmailTextX, inputEmailTextY, inputEmailTextW, inputEmailTextH);
    inputEmailText.delegate = self;
    //添加用户名文本框背景图片
    UIImageView *userImgView=[[UIImageView alloc] initWithFrame:inputEmailText.bounds];
    userImgView.image=[UIImage imageNamed:@"注册输入框.png"];
    userImgView.contentMode = UIViewContentModeScaleToFill;
    [inputEmailText  addSubview:userImgView];
    //sendSubviewToBack 将该subview置于最底层
    [inputEmailText sendSubviewToBack:userImgView];
    self.inputEmailText = inputEmailText;
    
    //将lable  和 text  提示图片添加到fullscreenview上
    [self.fullscreenView  addSubview:inputEmailLable];
    [self.fullscreenView   addSubview:inputEmailText];
  
}
/**
 *用户地址输入
 */

-(void)inputUserName{

    UILabel  *inputUserNameLable = [[UILabel  alloc]init];
    
    CGFloat  inputUserNameLableX = CGRectGetMaxX(self.confirmPwdText.frame) + 40;
    CGFloat  inputUserNameLableY = CGRectGetMaxY(self.inputEmailLable.frame) +10;
    CGFloat  inputUserNameLableW = 70;
    CGFloat  inputUserNameLableH = 35;
    
    
    //添加用户名lable 的背景颜色
    //inputUserNameLable.backgroundColor = [UIColor  redColor];
    inputUserNameLable.text = @"地   址:";
    inputUserNameLable.textAlignment = NSTextAlignmentCenter;
    inputUserNameLable.font = [UIFont  systemFontOfSize:16];
    
    inputUserNameLable.frame = CGRectMake(inputUserNameLableX, inputUserNameLableY, inputUserNameLableW, inputUserNameLableH);
    inputUserNameLable.clipsToBounds = YES;
    inputUserNameLable.layer.cornerRadius = 8.0;//设置边框圆角
    self.inputUserNameLable = inputUserNameLable;
    
    //添加用户名输入文本框
    UITextField *inputUserNameText = [[UITextField  alloc]init];
    CGFloat  inputUserNameTextX = CGRectGetMaxX(inputUserNameLable.frame) +10 ;
    CGFloat  inputUserNameTextY = CGRectGetMaxY(self.inputEmailText.frame) +10 ;
    CGFloat  inputUserNameTextW = [UIScreen  mainScreen].bounds.size.width / 4;
    CGFloat  inputUserNameTextH = 35;
    
    [inputUserNameText.layer setCornerRadius:8.0];//设置边框圆角
    inputUserNameText.font = [UIFont  systemFontOfSize:18];
    inputUserNameText.clearButtonMode = UITextFieldViewModeWhileEditing;
    inputUserNameText.delegate = self;
    inputUserNameText.frame = CGRectMake(inputUserNameTextX, inputUserNameTextY, inputUserNameTextW, inputUserNameTextH);
    
    //添加用户名文本框背景图片
    UIImageView *userImgView=[[UIImageView alloc] initWithFrame:inputUserNameText.bounds];
    userImgView.image=[UIImage imageNamed:@"注册输入框.png"];
    userImgView.contentMode = UIViewContentModeScaleToFill;
    [inputUserNameText  addSubview:userImgView];
    //sendSubviewToBack 将该subview置于最底层
    [inputUserNameText sendSubviewToBack:userImgView];
    self.inputUserNameText = inputUserNameText;
    
    //将lable  和 text 添加到fullscreenview上
    [self.fullscreenView  addSubview:inputUserNameLable];
    [self.fullscreenView   addSubview:inputUserNameText];
   

}
/**
 *添加提交按钮
 */

-(void)submitBtn{

    UILabel  *noteLbale = [[UILabel  alloc]init];
    CGFloat  noteLbaleX = [UIScreen  mainScreen].bounds.size.width / 3;
    CGFloat  noteLbaleY = CGRectGetMaxY(self.inputUserNameText.frame) + 10;
    CGFloat  noteLbaleW = [UIScreen  mainScreen].bounds.size.width / 2;//noteLbaleX +32;
    CGFloat  noteLbaleH = 20;
    
    
    //添加用户名lable 的背景颜色
    //noteLbale.backgroundColor = [UIColor  redColor];
    noteLbale.text = @"备注: 带*号的为必填项，手机号或邮箱用来找回密码";
    noteLbale.textColor = [UIColor  redColor];
    noteLbale.textAlignment = NSTextAlignmentCenter;
    noteLbale.font = [UIFont  systemFontOfSize:11];
    
    noteLbale.frame = CGRectMake(noteLbaleX, noteLbaleY, noteLbaleW, noteLbaleH);
    noteLbale.clipsToBounds = YES;
    noteLbale.layer.cornerRadius = 8.0;//设置边框圆角
    self.noteLbale = noteLbale;

    UIButton  *submitBtn = [[UIButton  alloc]init];
   
    CGFloat  submitBtnX = [UIScreen  mainScreen].bounds.size.width / 2 -30;
    CGFloat  submitBtnY = CGRectGetMaxY(noteLbale.frame) +10 ;
    CGFloat  submitBtnW = 60;
    CGFloat  submitBtnH = 35;
    submitBtn.frame = CGRectMake(submitBtnX, submitBtnY, submitBtnW, submitBtnH);
    
    [submitBtn  setImage:[UIImage  imageNamed:@"提交按钮"] forState:UIControlStateNormal];
    [submitBtn  setImage:[UIImage  imageNamed:@"提交按钮_over"] forState:UIControlStateHighlighted];
    
    //监听登录按钮
    [submitBtn  addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.fullscreenView  addSubview:noteLbale];
    [self.fullscreenView   addSubview:submitBtn];

}


/**
 *  提交注册信息给服务器
 */
-(void)submitAction{
   
    if ([self.pwdText.text isEqualToString:self.confirmPwdText.text]) {
        
        NSString  *userName = self.userNameText.text;
        
        NSString *pwd = [self.pwdText.text md5String];
        
        // NSString *confirmPwd = self.confirmPwdText.text; 2016年9月7日晚 注释掉
        
        NSString *phoneNum = self.inputPhoneNumText.text;
        
        NSString  *email = self.inputEmailText.text ;
        
        NSString *inputUserName = self.inputUserNameText.text;
        
        NSString  *userAddress = self.inputUserAddressText.text;
        
        
        NSDictionary  *dict = @{@"User":[NSString  stringWithFormat:@"%@",phoneNum],
                                @"password":[NSString  stringWithFormat:@"%@",pwd],
                                @"phonenum":[NSString  stringWithFormat:@"%@",userName],
                                @"email":[NSString  stringWithFormat:@"%@",email],
                                @"realname":[NSString  stringWithFormat:@"%@",inputUserName],
                                @"address":[NSString  stringWithFormat:@"%@",userAddress]
                                };
        
        //将对象转换成json串
        NSData  *jsonData = [NSJSONSerialization  dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil  ];
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        //NSLog( @"%@",jsonString);
        
        //创建请求管理者
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager  manager];
        mgr.responseSerializer = [AFJSONResponseSerializers  serializer];
        
        //配置请求超时时间
        mgr.requestSerializer.timeoutInterval = 60;
        //发送手机号成功，跳转到验证码View
        
        [MBProgressHUD  showMessage:@"正在提交用户信息…"];
        
        
        NSMutableDictionary  *params = [NSMutableDictionary  dictionary];
        
        params[@"userJson"] = jsonString;
        
        NSString  *urlStr =[NSString  stringWithFormat:@"%@/appUserRegister" ,HomecooServiceURL];
        NSString *url = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
        
        
        [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            
            //打印日志
            // NSLog(@"请求成功--%@",responseObject);
            
            NSString  *result = [responseObject[@"result"]description];
            NSString  *message = [responseObject[@"messageInfo"]description];
            
            if ([result  isEqual:@"success"]) {
                
                
                [MBProgressHUD  loginHideHUD];//隐藏蒙版
                
                [MBProgressHUD  showSuccess:[NSString  stringWithFormat:@"%@",message]];
                
                //自动跳转到登录界面
                LoginViewController  *loginVc = [[LoginViewController  alloc]init];
                [self  presentViewController:loginVc animated:YES completion:nil];
                
                
            }
            if ([result  isEqual:@"failed"]) {
                
                [MBProgressHUD  loginHideHUD];//隐藏蒙版
                
                [MBProgressHUD  showError:[NSString  stringWithFormat:@"%@", message ]];
                
                
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [MBProgressHUD  loginHideHUD];//隐藏蒙版
            [MBProgressHUD  showError:@"网络繁忙，请稍后再试"];
        }];
        
        [self  onEmailRegister];
    }else{
        
        [MBProgressHUD showError:@"输入的密码不一致!"];
        
    }
}

/**
 *  注册摄像头用户名
 */

-(void)onEmailRegister{
    NSString *email = [self.userNameText.text stringByAppendingString:@"@homecoo.com.cn"];
    NSString *password = self.pwdText.text;
    NSString *confirmPassword = password;
   
    [[NetManager sharedManager] registerWithVersionFlag:@"1" email:email countryCode:@"" phone:@"" password:password repassword:confirmPassword phoneCode:@"" callBack:^(id JSON) {
        
        RegisterResult *registerResult = (RegisterResult*)JSON;

        switch(registerResult.error_code){
            case NET_RET_REGISTER_SUCCESS:
            {
                
                if(self.loginController){
                    self.loginController.lastRegisterId = [NSString stringWithFormat:@"%@",registerResult.contactId];
                }

            }
                break;
            case NET_RET_REGISTER_EMAIL_FORMAT_ERROR:
            {
                [self.view makeToast:NSLocalizedString(@"email_format_error", nil)];
            }
                break;
            case NET_RET_REGISTER_EMAIL_USED:
            {
                [self.view makeToast:NSLocalizedString(@"email_used", nil)];
            }
                break;
                
            default:
            {
                [self.view makeToast:[NSString stringWithFormat:@"%@:%i",NSLocalizedString(@"unknown_error", nil),registerResult.error_code]];
            }
        }
    }];
}
/**
 *  监听键盘，按下键盘上return键 自动退出键盘
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
-(BOOL)shouldAutorotate{
    return YES;
}



-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}




@end
