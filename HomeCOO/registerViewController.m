//
//  registerViewController.m
//  HomeCOO
//
//  Created by tgbus on 16/5/13.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "registerViewController.h"
#import "UIView+Extension.h"
#import "AFNetworkings.h"
#import "verificationCodeController.h"
#import "LoginViewController.h"
#import "LZXDataCenter.h"
#import "MBProgressHUD+MJ.h"
#import "AppDelegate.h"
#import "selectCountryController.h"
#import "PrefixHeader.pch"
//#import "AFNetworking.h"
//输入手机号文本框的高度（和国家区号高度一样）
#define   HOMECOOPHONENUMHEIGHT [UIScreen  mainScreen].bounds.size.height / 4.2


@interface registerViewController ()<UITextFieldDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>

/**设置背景图片*/
@property(nonatomic,strong)  UIImageView   *fullscreenView;// UIView  * fullscreenView;
@property(nonatomic,strong)  UIScrollView   *scrollView;/**设置导航栏*/
/**设置导航栏*/
@property(nonatomic,weak)  UINavigationBar *navBar;


/**输入手机号*/
@property(nonatomic,weak)  UITextField *phoneNumView;

/**提醒文字*/
@property(nonatomic,weak)  UILabel  *alertLlable;

@property NSInteger keyBoardHeight;

@end

@implementation registerViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置背景
    //[self setFullscreenView];
    [self  addUIScrollView];
    
    [self  registerKeyBoardNotification];
    
    [self TapGestureRecognizer];
    
    //创建一个导航栏
    [self setNavBar];
    
    //国家区号
    [self setCountryCode];
    
    //输入手机号码
    [self  setPhoneNumView];
    
    //提醒文字
    [self setAlertLlable];
    
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
    
    if (![_phoneNumView isExclusiveTouch]) {
        [_phoneNumView resignFirstResponder];
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
   // self.fullscreenView = fullscreenView;
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
 *国家区号
 */
-(void)setCountryCode{
    
    LZXDataCenter *dataCenter = [LZXDataCenter defaultDataCenter];

    UIButton *countryCode = [[UIButton  alloc]init];
    countryCode.frame = CGRectMake(10, 100, 85, HOMECOOPHONENUMHEIGHT);
    countryCode.backgroundColor = [UIColor whiteColor];
    [countryCode.layer setCornerRadius:8.0]; //设置矩形四个圆角半径
   
    [countryCode  setTitleColor:[UIColor  grayColor] forState:UIControlStateNormal];
    
    if (dataCenter.countyrCode==nil) {
        [countryCode  setTitle:@"+86" forState:UIControlStateNormal];
        
    }else{
        [countryCode  setTitle:[NSString stringWithFormat:@"+%@",dataCenter.countyrCode ] forState:UIControlStateNormal];
        
    }
    
   
    [countryCode  addTarget:self action:@selector(onChooseCountryPress:) forControlEvents:UIControlEventTouchUpInside];
     countryCode.titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:22];
    self.countryCode = countryCode;
    
    [self.fullscreenView  addSubview:countryCode];

}

-(void)viewDidAppear:(BOOL)animated{

    LZXDataCenter *dataCenter = [LZXDataCenter defaultDataCenter];

    if (dataCenter.countyrCode==nil) {
        
        [self.countryCode  setTitle:@"+86" forState:UIControlStateNormal];
        
    }else{
        [self.countryCode  setTitle:[NSString stringWithFormat:@"+%@",dataCenter.countyrCode ]forState:UIControlStateNormal];
    }
    
}
#pragma mark - 调用时，进入国家选择界面
-(void)onChooseCountryPress:(UIButton*)button{
   
    selectCountryController *selectVc = [[selectCountryController alloc]init];
    [self presentViewController:selectVc animated:YES completion:nil];
  
}

/**
 *输入手机号
 */
-(void)setPhoneNumView{
    
    
    UITextField  *phoneNumView = [[UITextField alloc]init];
    CGFloat  phoneNumViewX = CGRectGetMaxX(self.countryCode.frame) +10;
    CGFloat  phoneNumViewW = [UIScreen  mainScreen].bounds.size.width - CGRectGetMaxX(self.countryCode.frame) - 20;
    CGFloat  phoneNumViewH = HOMECOOPHONENUMHEIGHT;
    phoneNumView.font = [UIFont  systemFontOfSize:30];
    [phoneNumView.layer setCornerRadius:8.0];//设置边框圆角
    phoneNumView.placeholder = @"请输入手机号码";
    phoneNumView.delegate = self;
    
    phoneNumView.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //添加一个空的view，让text偏移
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    
    phoneNumView.leftView = paddingView;
    phoneNumView.leftViewMode = UITextFieldViewModeAlways;
    phoneNumView.frame = CGRectMake(phoneNumViewX, 100 , phoneNumViewW, phoneNumViewH);
    
    //为了测试方便直接写死
    // phoneNumView.text = @"18720087104";
    phoneNumView.backgroundColor = [UIColor  whiteColor];
    self.phoneNumView = phoneNumView;
    
    [self.fullscreenView  addSubview:phoneNumView];
    
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
/**
 *  手机号码验证
 *
 *  @param mobileNumbel 传入的手机号码
 *
 *  @return 格式正确返回true  错误 返回fals
 */
-(BOOL) isMobile:(NSString *)mobileNumbel{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186 增加 170 171 173 176 177 178
     * 电信：133,1349,153,180,189,181(增加)177
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
    NSString * CU = @"^1(3[0-2]|5[256]|8[56]|7[013678])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,181(增加)
     22         */
    NSString * CT = @"^1((33|53|8[019]|77)[0-9]|349)\\d{7}$";
    
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

/**
 *设置提醒文字
 */
-(void)setAlertLlable{
    
    UILabel  *alertLlable = [[UILabel  alloc]init];
    
    alertLlable.text = @"请输入正确的手机号 ，该手机号将作为注册的用户账号及找回密码使用。";
    alertLlable.font = [UIFont  systemFontOfSize:15];
    alertLlable.textColor = [UIColor  grayColor];
    CGFloat  alertLlableX = 10;
    CGFloat  alertLlableY = CGRectGetMaxY(self.phoneNumView.frame) + 10;
    CGFloat  alertLlableW = [UIScreen  mainScreen].bounds.size.width - 20;
    CGFloat  alertLlableH = 30;
    //alertLlable.backgroundColor = [UIColor  redColor];
    alertLlable.frame = CGRectMake(alertLlableX, alertLlableY, alertLlableW, alertLlableH);
    self.alertLlable = alertLlable;
    [self.fullscreenView  addSubview:alertLlable];
    
    
    
    
}

/**返回*/
-(void)backAction{
    
    [self  dismissViewControllerAnimated:YES completion:nil];    
}


/**
 *下一步
 */
-(void)nextAction{
    
    //判断手机号码是否正确
    BOOL result =  [self  isMobile:self.phoneNumView.text];
    
    if (result) {
        
        LZXDataCenter *dataCenter = [LZXDataCenter defaultDataCenter];
        //保存在单例对象中,顺传
        dataCenter.textStr = _phoneNumView.text;
        
        
        //获取手机号
        NSString  *phoneNum = self.phoneNumView.text;
        // NSLog(@"%@",phoneNum);
        
        
        //创建请求管理者
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager  manager];
        mgr.responseSerializer = [AFJSONResponseSerializers  serializer];
        
        //配置请求超时时间
        mgr.requestSerializer.timeoutInterval = 60;
        
   
        //发送手机号成功，跳转到验证码View
        
        [MBProgressHUD  showMessage:@"正在获取验证码…"];
     
        NSMutableDictionary  *params = [NSMutableDictionary  dictionary];
        
        params[@"phonenum"] = phoneNum;
        
        NSString  *urlStr =[NSString  stringWithFormat:@"%@/appSendRegitserCode" ,HomecooServiceURL];
        NSString *url = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
        
        
        [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            
            //打印日志
            //NSLog(@"请求成功--%@",responseObject);
            
            NSString  *result = [responseObject[@"result"]description];
            NSString  *message = [responseObject[@"messageInfo"]description];
            if ([result  isEqual:@"success"]) {//成功获取验证码
                
                //填写注册用户的地址
                verificationCodeController  *registerAddressVC = [[verificationCodeController  alloc]init];
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
        
       

    }else{
        
        UIAlertView  *alertView = [[UIAlertView  alloc]initWithTitle:@"温馨提示" message:@"请输入正确的手机号码!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
    }
    
}
-(BOOL)shouldAutorotate{
    return YES;
}



-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}




@end
