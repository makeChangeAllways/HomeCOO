//
//  verificationCodeController.m
//  HomeCOO
//
//  Created by tgbus on 16/5/13.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "verificationCodeController.h"
#import "registerViewController.h"
#import "registerAddressViewController.h"
#import "LZXDataCenter.h"
#import "AFNetworkings.h"
#import "MBProgressHUD+MJ.h"
#import "PrefixHeader.pch"
#import "UIView+Extension.h"
//输入验证码文本框的的宽度
#define   HOMECOOINPUTCODE  [UIScreen  mainScreen].bounds.size.width / 1.35

//重新获取验证码按钮的宽度（和倒计时lable一样宽）
#define   HOMEREFETCODEWIDTH   [UIScreen  mainScreen].bounds.size.width - CGRectGetMaxX(self.verificationView.frame) - 20
//输入验证码文本框的高度（和倒计时lable 重新获取按钮高度一样）
#define   HOMECOOPHONENUMHEIGHT [UIScreen  mainScreen].bounds.size.height / 4.2

@interface verificationCodeController ()<UITextFieldDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>

/**设置背景图片*/
@property(nonatomic,strong)  UIImageView   *fullscreenView;// UIView  * fullscreenView;
@property(nonatomic,strong)  UIScrollView   *scrollView;/**设置导航栏*/
@property(nonatomic,weak)  UINavigationBar *navBar;

/**设置提醒文字*/
@property(nonatomic,weak)  UILabel *alertLlable;

/**重发验证码*/
@property(nonatomic,weak)  UIButton *reSendCode;

/**输入验证码*/
@property(nonatomic,weak)  UITextField  *verificationView;

/**总是收不到验证码*/
@property(nonatomic,weak)  UIButton *verCode;

/**手动创建一个定时器*/
@property(nonatomic,weak)  NSTimer * countDownTimer;

/**显示定时器倒计时时间*/
@property(nonatomic,weak)  UILabel * labelText;

@property NSInteger keyBoardHeight;

@end

@implementation verificationCodeController



static int   secondsCountDown;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //设置背景图片
    //[self  setFullscreenView];
    [self  addUIScrollView];
    
    [self TapGestureRecognizer];
    
    [self registerKeyBoardNotification];
    //创建一个导航栏
    [self setNavBar];
    
    //提醒文字
    [self  setAlertLlable];
    
    
    //输入验证码
    [self setVerificationView];
    
    //总是收不到验证码
    [self  setVerCode];
    
    //加载页面后。开始倒计时60秒
    [self reGetverificationCode];
    
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
    
    if (![_verificationView isExclusiveTouch]) {
        [_verificationView resignFirstResponder];
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
 *设置背景图片
 */

-(void) setFullscreenView{
    
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
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleDone target:self action:@selector(nextAction)];
    rightButton.title = @"下一步";
    rightButton.tintColor = [UIColor  blackColor];
    
    //把导航栏集合添加到导航栏中，设置动画关闭
    [navBar pushNavigationItem:navItem animated:NO];
    
    //把左右两个按钮添加到导航栏集合中去
    [navItem setLeftBarButtonItem:leftButton];
    [navItem setRightBarButtonItem:rightButton];
    
    //将标题栏中的内容全部添加到主视图当中
    [self.fullscreenView addSubview:navBar];
    
}



/**
 *设置提醒文字
 */

-(void)setAlertLlable{
    
    UILabel  *alertLlable = [[UILabel  alloc]init];
    
    //将用户传过来的的手机号，显示到lable中
    LZXDataCenter *dataCenter = [LZXDataCenter defaultDataCenter];
    
    alertLlable.text = [NSString  stringWithFormat:@"验证码经发送到*%@",dataCenter.textStr];
    //alertLlable.text = @"验证码经发送到* %@";//@"验证码经发送到*";
    alertLlable.font = [UIFont  systemFontOfSize:15];
    alertLlable.textColor = [UIColor  blueColor];
    
    CGFloat  alertLlableX = 10;
    CGFloat  alertLlableY = 80;
    CGFloat  alertLlableW = [UIScreen  mainScreen].bounds.size.width - 20;
    CGFloat  alertLlableH = 30;
    // alertLlable.backgroundColor = [UIColor  redColor];
    alertLlable.frame = CGRectMake(alertLlableX, alertLlableY, alertLlableW, alertLlableH);
    self.alertLlable = alertLlable;
    [self.fullscreenView  addSubview:alertLlable];
    
}




/**
 *重发验证码
 */
-(void)setReSendCode{
    
    UIButton *reSendCode = [[UIButton  alloc]init];
    CGFloat  reSendCodeX = CGRectGetMaxX(self.verificationView.frame) + 10;;
    CGFloat  reSendY = CGRectGetMaxY(self.alertLlable.frame) +10;
    CGFloat  reSendW = HOMEREFETCODEWIDTH;
    CGFloat  reSendH = HOMECOOPHONENUMHEIGHT;
    
    reSendCode.userInteractionEnabled = YES;
    reSendCode.frame = CGRectMake(reSendCodeX, reSendY, reSendW, reSendH);
    [reSendCode  setTitle:@"重新获取" forState:UIControlStateNormal];
    [reSendCode  setTitle:@"重新获取" forState:UIControlStateHighlighted];
    //[reSendCode  setFont:[UIFont  systemFontOfSize:15]];
    reSendCode.titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:16];
    
    [reSendCode  setTitleColor:[UIColor  blackColor] forState:UIControlStateNormal];
    [reSendCode  setTitleColor:[UIColor  grayColor] forState:UIControlStateDisabled];
    
    //点击重发验证码
    [reSendCode  addTarget:self action:@selector(reGetverificationCodeAction) forControlEvents:UIControlEventTouchUpInside];
    reSendCode.backgroundColor = [UIColor  colorWithRed:0.29 green:0.57 blue:0.53 alpha:1.0];
    
    [reSendCode.layer setCornerRadius:8.0]; //设置矩形四个圆角半径
    self.reSendCode = reSendCode;
    [self.fullscreenView  addSubview:reSendCode];
    
    
    
}

/**
 *重新获取新的验证码
 */

-(void)reGetverificationCodeAction{
    
    //重新计时
    [self timeUpdata];
    
    LZXDataCenter *dataCenter = [LZXDataCenter defaultDataCenter];
    
    //截取手机号码
    
    NSString  *getUserPhoneNum = dataCenter.textStr;
    
    NSLog(@"重新获取验证码的手机号 %@",getUserPhoneNum);
    
    //创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager  manager];
    mgr.responseSerializer = [AFJSONResponseSerializers  serializer];
    
    //配置请求超时时间
    mgr.requestSerializer.timeoutInterval = 60;
    
    //发送手机号成功，跳转到验证码View
    
    [MBProgressHUD  showMessage:@"正在获取验证码…"];
    
    NSMutableDictionary  *params = [NSMutableDictionary  dictionary];
    
    params[@"phonenum"] = getUserPhoneNum;
    
    NSString  *urlStr =[NSString  stringWithFormat:@"%@/appSendRePwdCode" ,HomecooServiceURL];
    NSString *url = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格

    
    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        //打印日志
        // NSLog(@"请求成功--%@",responseObject);
        
        NSString  *result = [responseObject[@"result"]description];
        
        NSString *message = [responseObject[@"messageInfo"]description];
        
        if ([result  isEqual:@"success"]) {//成功获取验证码
            
            [MBProgressHUD  loginHideHUD];//隐藏蒙版
            [MBProgressHUD  showSuccess:[NSString  stringWithFormat:@"%@",message]];
        }
        if ([result  isEqual:@"failed"]) {
            
            [MBProgressHUD  loginHideHUD];//隐藏蒙版
            
            [MBProgressHUD  showError:[NSString  stringWithFormat:@"%@",message]];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD  loginHideHUD];//隐藏蒙版
        [MBProgressHUD  showError:@"网络繁忙，请稍后再试"];
    }];
    
    
    
}

//重新计时、获取验证码
-(void)timeUpdata{
    
    //重发验证码时，按钮不可点击
    self.reSendCode.enabled = NO;
    
    //设置倒计时总时长
    secondsCountDown = 60;//60秒倒计时
    
    //开始倒计时
    NSTimer * countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES]; //启动倒计时后会每秒钟调用一次方法 timeFireMethod
    
    
    //创建UILabel 显示倒计时时间
    UILabel * labelText=[[UILabel alloc]init];
    
    CGFloat  labletextX = CGRectGetMaxX(self.verificationView.frame) + 10;
    CGFloat  labletextY = CGRectGetMaxY(self.alertLlable.frame) +10;
    
    CGFloat  labletextW = HOMEREFETCODEWIDTH ;
    CGFloat  labletextH = HOMECOOPHONENUMHEIGHT;
    
    labelText.frame = CGRectMake(labletextX, labletextY, labletextW, labletextH);
    
    //设置倒计时显示的时间
    labelText.text=[NSString stringWithFormat:@"重新获取（%d）",secondsCountDown];
    labelText.font = [UIFont  systemFontOfSize:13];
    labelText.textColor = [UIColor  whiteColor];
    labelText.backgroundColor = [UIColor  grayColor];
    labelText.textAlignment = NSTextAlignmentCenter;
    labelText.clipsToBounds = YES;
    labelText.layer.cornerRadius = 8.0;//设置边框圆角
    self.labelText = labelText;
    self.countDownTimer = countDownTimer;
    
    [self.fullscreenView addSubview:labelText];
    
    
    
}




/**
 *调用此方法开始倒计时
 */
-(void)timeFireMethod{
    
    //倒计时-1
    secondsCountDown--;
    //修改倒计时标签现实内容
    self.labelText.text=[NSString stringWithFormat:@"重新获取（%d）",secondsCountDown];
    self.labelText.font = [UIFont  systemFontOfSize:13];
    self.labelText.textColor = [UIColor  whiteColor];
    self.labelText.clipsToBounds = YES;
    self.labelText.layer.cornerRadius = 8.0;//设置边框圆角
    self.labelText.backgroundColor = [UIColor  grayColor];
    //当倒计时到0时，做需要的操作，比如验证码过期不能提交
    if(secondsCountDown==0){
        self.reSendCode.enabled = YES;
        [self.countDownTimer invalidate];
        [self.labelText removeFromSuperview];
    }
}

/**
 *在页面时开始倒计时60秒
 */
-(void)reGetverificationCode{
    
    //设置倒计时总时长
    secondsCountDown = 60;//60秒倒计时
    
    //开始倒计时
    NSTimer * countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethodAction) userInfo:nil repeats:YES]; //启动倒计时后会每秒钟调用一次方法 timeFireMethod
    //主线程也会抽出一点时间处理一下timer （不管主线程是否在处理其他时间）
    //[[NSRunLoop  mainRunLoop]addTimer:countDownTimer forMode:NSRunLoopCommonModes];
    
    //创建UILabel 显示倒计时时间
    UILabel * labelText=[[UILabel alloc]init];
    
    CGFloat  labletextX = CGRectGetMaxX(self.verificationView.frame) + 10;
    CGFloat  labletextY = CGRectGetMaxY(self.alertLlable.frame) +10;
    
    CGFloat  labletextW = HOMEREFETCODEWIDTH;
    CGFloat  labletextH = HOMECOOPHONENUMHEIGHT;
    
    labelText.frame = CGRectMake(labletextX, labletextY, labletextW, labletextH);
    
    //设置倒计时显示的时间
    labelText.text=[NSString stringWithFormat:@"重新获取（%d）",secondsCountDown];
    labelText.font = [UIFont  systemFontOfSize:13];
    labelText.textColor = [UIColor  whiteColor];
    labelText.backgroundColor = [UIColor  grayColor];
    labelText.textAlignment = NSTextAlignmentCenter;
    labelText.clipsToBounds = YES;
    labelText.layer.cornerRadius = 8.0;//设置边框圆角
    self.labelText = labelText;
    self.countDownTimer = countDownTimer;
    
    [self.fullscreenView addSubview:labelText];
    
    
}

/**
 *调用此方法开始倒计时
 */
-(void)timeFireMethodAction{
    //倒计时-1
    secondsCountDown--;
    
    //修改倒计时标签现实内容
    self.labelText.text=[NSString stringWithFormat:@"重新获取（%d）",secondsCountDown];
    self.labelText.font =  [UIFont fontWithName:@"HelveticaNeue" size:13];
    self.labelText.textColor = [UIColor  whiteColor];
    self.labelText.clipsToBounds = YES;
    self.labelText.layer.cornerRadius = 8.0;//设置边框圆角
    self.labelText.backgroundColor = [UIColor  grayColor];
    
    //当倒计时到0时，做需要的操作，比如验证码过期不能提交
    if(secondsCountDown==0){
        
        [self.countDownTimer invalidate];
        [self.labelText removeFromSuperview];
        
        [self setReSendCode];//重发验证码
    }
}





/**
 *输入验证码
 */
-(void)setVerificationView{
    
    UITextField  *verificationView = [[UITextField alloc]init];
    CGFloat  verificationViewX = 10;
    CGFloat  verificationViewY = CGRectGetMaxY(self.alertLlable.frame) +10;
    CGFloat  verificationViewW = HOMECOOINPUTCODE;
    CGFloat  phoneNumViewH = HOMECOOPHONENUMHEIGHT;
    verificationView.font = [UIFont  systemFontOfSize:30];
    [verificationView.layer setCornerRadius:8.0];//设置边框圆角
    verificationView.placeholder = @"请输入验证码";
    verificationView.clearButtonMode = UITextFieldViewModeWhileEditing;
    verificationView.delegate = self;
    //添加一个空的view，让text偏移
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    verificationView.leftView = paddingView;
    verificationView.leftViewMode = UITextFieldViewModeAlways;
    
    verificationView.frame = CGRectMake(verificationViewX, verificationViewY , verificationViewW, phoneNumViewH);
    verificationView.backgroundColor = [UIColor  whiteColor];
    self.verificationView = verificationView;
    [self.fullscreenView  addSubview:verificationView];
    
}


/**
 *总是收不到验证码
 */
-(void)setVerCode{
    
    UIButton  *verCode = [[UIButton  alloc]init];
    CGFloat   verCodeX = 10;
    CGFloat   verCodeY = CGRectGetMaxY(self.verificationView.frame) + 10;
    CGFloat   verCodeW = [UIScreen  mainScreen].bounds.size.width / 3;
    CGFloat   verCodeH = 35;
    verCode.frame = CGRectMake(verCodeX, verCodeY, verCodeW, verCodeH);
    
    [verCode  setTitle:@"总是收不到验证码？" forState:UIControlStateNormal];
    [verCode  setTitleColor:[UIColor  blueColor] forState:UIControlStateNormal];
    [verCode  setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [verCode  addTarget:self action:@selector(verCodeAction) forControlEvents:UIControlEventTouchUpInside];
    //[verCode  setFont:[UIFont  systemFontOfSize:15]];
    verCode.titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:16];
    
    verCode.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//文字居左,紧贴边框
    //verCode.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);//设置文字内边距
    
    // verCode.backgroundColor = [UIColor  whiteColor];
    
    [self.fullscreenView  addSubview:verCode];
    
    
}




-(void)verCodeAction{
    
    NSLog(@"总是收不到验证码");
    
    
}

/**返回到上一个View*/
-(void)backAction{
    
    [self  dismissViewControllerAnimated:YES completion:nil];

}

/**
 *下一步
 */
-(void)nextAction{
    
    NSString  *getAlertLableText = self.alertLlable.text;
    
    //截取手机号码
    NSString  *getUserPhoneNum = [getAlertLableText  substringFromIndex:8];
    
    //验证码
    NSString  * verificationCode = self.verificationView.text;
    
    // NSLog(@"%@",verificationCode);
    //验证码类型
    NSString  *verificationCodeType = @"1";
    //创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager  manager];
    mgr.responseSerializer = [AFJSONResponseSerializers  serializer];
    
    //配置请求超时时间
    mgr.requestSerializer.timeoutInterval = 60;
    //发送手机号成功，跳转到验证码View
    
    [MBProgressHUD  showMessage:@"正在校验验证码…"];
    
    
    
    NSMutableDictionary  *params = [NSMutableDictionary  dictionary];
    
    params[@"phonenum"] = getUserPhoneNum;
    params[@"identifyCode"] = verificationCode;
    params[@"smsCodeType"] = verificationCodeType;
    
    NSString  *urlStr =[NSString  stringWithFormat:@"%@/appPhoneCheckCode" ,HomecooServiceURL];
    NSString *url = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格

    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        //打印日志
        //NSLog(@"请求成功--%@",responseObject);
        
        NSString  *result = [responseObject[@"result"]description];
        NSString  *message = [responseObject[@"messageInfo"]description];
        if ([result  isEqual:@"success"]) {//成功获取验证码
            
            //填写注册用户的地址
            registerAddressViewController  *registerAddressVC = [[registerAddressViewController  alloc]init];
            [self  presentViewController:registerAddressVC animated:YES completion:nil];
            
            [MBProgressHUD  loginHideHUD];//隐藏蒙版
            
        }
        if ([result  isEqual:@"failed"]) {
            
            [MBProgressHUD  loginHideHUD];//隐藏蒙版
            
            [MBProgressHUD  showError:[NSString  stringWithFormat:@"%@", message ]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD  loginHideHUD];//隐藏蒙版
        [MBProgressHUD  showError:@"网络繁忙，请稍后再试"];
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

