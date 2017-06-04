//
//  AppDelegate.m
//  HomeCOO
//
//  Created by tgbus on 16/4/14.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "registerViewController.h"
#import "registerAddressViewController.h"
#import "SystemViewController.h"
#import "SpaceViewController.h"
#import "SingleSecurityViewController.h"
#import "verificationCodeController.h"
#import "MBProgressHUD+MJ.h"
#import "SecurityViewController.h"
#import "SettingViewController.h"
#import "gatewaySettingController.h"
#import "SingleLightViewController.h"
#import "singleWindowAndDoorController.h"
#import<CoreLocation/CoreLocation.h>
#import "spaceAdministrationController.h"
#import "mainViewViewController.h"
#import "remoteCollectionViewController.h"
#import "sockViewController.h"
#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>
#import "PacketMethods.h"
#import "deviceMessage.h"
#import "deviceMessageTool.h"
#import "ControlMethods.h"
#import "transCodingMethods.h"
#import "AFNetworking.h"
#import <AudioToolbox/AudioToolbox.h>
#import "alarmMessages.h"
#import "alarmMessagesTool.h"
#import "commonClass.h"
#import "UnscrollTabController.h"
#import "MainController.h"
#import "UDManager.h"
#import "LoginController.h"
#import "Constants.h"
#import "AutoNavigation.h"
#import "LoginResult.h"
#import "UDManager.h"
#import "NetManager.h"
#import "AccountResult.h"
#import "MainLoginController.h"
#import "Reachability.h"
#import "Message.h"
#import "Utils.h"
#import "MessageDAO.h"
#import "FListManager.h"
#import "CheckNewMessageResult.h"
#import "GetContactMessageResult.h"
#import "CheckAlarmMessageResult.h"
#import "ContactDAO.h"
#import "GlobalThread.h"
#import "Contact.h"
#import "Toast+UIView.h"
#import "UncaughtExceptionHandler.h"
#import "Alarm.h"
#import "AlarmDAO.h"
#import "AlarmViewController.h"
#import "PrefixHeader.pch"
#import "HCDaterView.h"
#import "HCGatewayView.h"
#import <AdSupport/AdSupport.h>
#import "LZXDataCenter.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
@interface AppDelegate ()<JPUSHRegisterDelegate>

//定义一个全局变量 接受报警通知
@property(nonatomic,copy) NSString *alertString;

//接受报警报文
@property(nonatomic,copy) NSString *alarmString;

@end

@implementation AppDelegate

#pragma mark - 返回三种类型的rect，分别是水平、7.0和其他情况 这个不能注释掉  否则现场视频的时候 屏幕不适配
+(CGRect)getScreenSize:(BOOL)isNavigation isHorizontal:(BOOL)isHorizontal{
    CGRect rect = [UIScreen mainScreen].bounds;
    
    if(isHorizontal){
        rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.height, rect.size.width);
    }
    
    if([[[UIDevice currentDevice] systemVersion] floatValue]<7.0){
        rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height-20);
    }
    return rect;
}

+ (AppDelegate*)sharedDefault
{
    
    return [UIApplication sharedApplication].delegate;
}

+(NSString*)getAppVersion{
    return [NSString stringWithFormat:APP_VERSION];
}

-(void)dealloc{
    [self.window release];
    [self.mainController release];
    [super dealloc];
}
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    self.networkStatus = [curReach currentReachabilityStatus];
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameter setObject:[NSNumber numberWithInt:self.networkStatus] forKey:@"status"];
    [[NSNotificationCenter defaultCenter] postNotificationName:NET_WORK_CHANGE
                                                        object:self
                                                      userInfo:parameter];
}

-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskAll;
    
}

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
   
    if([UDManager isLogin]){
        
        MainController *mainController = [[MainController alloc] init];
        self.mainController = mainController;
        
        [mainController  release];
//        LoginResult *loginResult = [UDManager getLoginInfo];
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
        
    }else{
        
        MainController *mainController = [[MainController alloc] init];
        self.mainController = mainController;
        [mainController  release];
        
    }
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRemoteMessage:) name:RECEIVE_REMOTE_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ack_receiveRemoteMessage:) name:ACK_RECEIVE_REMOTE_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSessionIdError:) name:NOTIFICATION_ON_SESSION_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceiveAlarmMessage:) name:RECEIVE_ALARM_MESSAGE object:nil];
    [AppDelegate getAppVersion];
    NSLog(@"[AppDelegate getAppVersion] = %@",[AppDelegate getAppVersion]);
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.networkStatus = ReachableViaWWAN;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    NSString *remoteHostName = @"www.baidu.com";
    
    [[Reachability reachabilityWithHostName:remoteHostName] startNotifier];
    
    //开机提醒用户 允不允许苹果发送通知，允许后 就会获取手机的devicetoke
    //开机启动就获取设备的devicetoke
    if ([UIDevice  currentDevice].systemVersion.doubleValue<=8.0) {
        //不是ios8
        //当用户第一次启动程序时，就获取devicetoke 该方法在ios8以前已经过期了
        UIRemoteNotificationType type = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert;
        
        [application  registerForRemoteNotificationTypes:type];
        
    }else{
        
        //ios8及以后
        UIUserNotificationType type = UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
       //注册通知类型
        [application  registerUserNotificationSettings:settings];
        //申请使用通知
        [application  registerForRemoteNotifications];
    
    }
    
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
   if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
} else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];
     NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    //建立连接
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJPFNetworkDidSetupNotification
                        object:nil];
   
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
   
  
    [LZXDataCenter defaultDataCenter].loginStateFlag=1;
    
    //设置启动界面
    self.window.rootViewController = [[LoginViewController alloc]init];
    [NSThread sleepForTimeInterval:1.0];//延迟启动图片
    [self.window  makeKeyAndVisible];
    

    return YES;
}
-(void)onSessionIdError:(id)sender{
    
    [UDManager setIsLogin:NO];
    
    [[GlobalThread sharedThread:NO] kill];
    [[FListManager sharedFList] setIsReloadData:YES];
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    LoginController *loginController = [[LoginController alloc] init];
    loginController.isSessionIdError = YES;
    AutoNavigation *mainController = [[AutoNavigation alloc] initWithRootViewController:loginController];
    
    //[AppDelegate sharedDefault].window.rootViewController = mainController;
    //APP将返回登录界面时，注册新的token，登录时传给服务器
    [[AppDelegate sharedDefault] reRegisterForRemoteNotifications];
    
    [loginController release];
    [mainController release];
    
    dispatch_queue_t queue = dispatch_queue_create(NULL, NULL);
    dispatch_async(queue, ^{
        [[P2PClient sharedClient] p2pDisconnect];
        DLog(@"p2pDisconnect.");
    });
}
- (void)onReceiveAlarmMessage:(NSNotification *)notification{
    
    NSDictionary *parameter = [notification userInfo];

    NSString *contactId   = [parameter valueForKey:@"contactId"];
    int type   = [[parameter valueForKey:@"type"] intValue];
    int isSupportExternAlarm   = [[parameter valueForKey:@"isSupportExternAlarm"] intValue];
    int group   = [[parameter valueForKey:@"group"] intValue];
    int item   = [[parameter valueForKey:@"item"] intValue];
    
    NSString *typeStr = @"";
    switch(type){
        case 1:
        {
            typeStr = NSLocalizedString(@"extern_alarm", nil);
        }
            break;
        case 2:
        {
            typeStr = NSLocalizedString(@"motion_dect_alarm", nil);
        }
            break;
        case 3:
        {
            typeStr = NSLocalizedString(@"emergency_alarm", nil);
        }
            break;
        case 5:
        {
            typeStr = NSLocalizedString(@"ext_line_alarm", nil);
        }
            break;
        case 6:
        {
            typeStr = NSLocalizedString(@"low_vol_alarm", nil);
        }
            break;
        case 7:
        {
            typeStr = NSLocalizedString(@"pir_alarm", nil);
        }
            break;
        case 8:
        {
            typeStr = NSLocalizedString(@"defence_alarm", nil);
        }
            break;
        case 9:
        {
            typeStr = NSLocalizedString(@"defence_disable_alarm", nil);
        }
            break;
        case 10:
        {
            typeStr = NSLocalizedString(@"battery_low_vol", nil);
        }
            break;
        case 11:
        {
            typeStr = NSLocalizedString(@"update_to_ser", nil);
        }
            break;
        case 12:
        {
            typeStr = NSLocalizedString(@"TH_ALARM", nil);
        }
            break;
        case 14:
        {
            typeStr = NSLocalizedString(@"FORCE_FROM_KEYPRESS_ALARM", nil);
        }
            break;
        case 16:
        {
            typeStr = NSLocalizedString(@"EMAIL_TOO_OFTEN_ALARM", nil);
        }
            break;
        case 17:
        {
            typeStr = NSLocalizedString(@"UART_INPUT_ALARM", nil);
        }
            break;
        case 18:
        {
            typeStr = NSLocalizedString(@"FIRE_PROBER_ALARM", nil);
        }
            break;
        case 19:
        {
            typeStr = NSLocalizedString(@"GAS_PROBER_ALARM", nil);
        }
            break;
        case 20:
        {
            typeStr = NSLocalizedString(@"STEAL_PROBER_ALARM", nil);
        }
            break;
        case 21:
        {
            typeStr = NSLocalizedString(@"AROUND_PROBER_ALARM", nil);
        }
            break;
        case 23:
        {
            typeStr = NSLocalizedString(@"I20_PROBER_ALARM", nil);
        }
            break;
        case 24:
        {
            typeStr = NSLocalizedString(@"PREVENTDISCONNECT_PROBER_ALARM", nil);
        }
            break;
        case 25:
        {
            typeStr = NSLocalizedString(@"COMMUNICATION_TIMING_PROBER_ALARM", nil);
        }
            break;
        case 26:
        {
            typeStr = NSLocalizedString(@"LOW_POWER_PROBER_ALARM", nil);
        }
            break;
        case 27:
        {
            typeStr = NSLocalizedString(@"LOW_POWER_RECOVERY_PROBER_ALARM", nil);
        }
            break;
        case 28:
        {
            typeStr = NSLocalizedString(@"POWERONPROBER_ALARM", nil);
        }
            break;
        case 29:
        {
            typeStr = NSLocalizedString(@"POWEROFF_PROBER_ALARM", nil);
        }
            break;
        case 30:
        {
            typeStr = NSLocalizedString(@"DEF_PROBER_ALARM", nil);
        }
            break;
        case 31:
        {
            typeStr = NSLocalizedString(@"DEFDIS_PROBER_ALARM", nil);
        }
            break;
        case 32:
        {
            typeStr = NSLocalizedString(@"EXT_PROBER_ALARM", nil);
        }
            break;
        case 33:
        {
            typeStr = NSLocalizedString(@"PROBER_ALARM", nil);
        }
            break;
            
            
    }
    
    NSArray *contacts = [[[FListManager sharedFList] getContacts] mutableCopy];
    //
    if (contacts.count == 0) {
        return;
    }
    
    int i = 0;
    for (int index = 0; index < contacts.count; index ++) {
        Contact *cont = [contacts objectAtIndex:index];
        if ([cont.contactId isEqualToString:contactId]) {
            i ++;
        }
    }
    
    if (i > 0) { // 有存在设备
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshState" object:nil];
    }else
    {
        return;
    }
    
    
    for (Contact *cont in contacts) {
        if ([cont.contactId isEqualToString:contactId]) {
            [[P2PClient sharedClient] getAlarmInfoWithId:cont.contactId password:cont.contactPassword];
        }
        
    }
    
    P2PCallState p2pCallState = [[P2PClient sharedClient] p2pCallState];
    NSString *callId = [[P2PClient sharedClient] callId];
    BOOL isCanShow = NO;
    if(p2pCallState==P2PCALL_STATE_NONE){
        isCanShow = YES;
    }else{
        //        if([callId isEqualToString:contactId]){
        //            isCanShow = NO;
        //        }else{
        //            isCanShow = YES;
        //        }
        isCanShow = NO;
    }
    
    if(self.isGoBack){
        UILocalNotification *alarmNotify = [[[UILocalNotification alloc] init] autorelease];
        alarmNotify.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
        alarmNotify.timeZone = [NSTimeZone defaultTimeZone];
        alarmNotify.soundName = @"default";
        alarmNotify.alertBody = [NSString stringWithFormat:@"%@:%@",contactId,typeStr];
        alarmNotify.applicationIconBadgeNumber = 1;
        alarmNotify.alertAction = NSLocalizedString(@"open", nil);
        [[UIApplication sharedApplication] scheduleLocalNotification:alarmNotify];
    }
    
    BOOL isTimeAfter = NO;
    DLog(@"%li",[Utils getCurrentTimeInterval]);
    if(([Utils getCurrentTimeInterval]-self.lastShowAlarmTimeInterval)>1){
        isTimeAfter = YES;
        
    }else{
        isTimeAfter = NO;
    }
    if(!self.isShowAlarm&&isCanShow&&isTimeAfter){
        self.isShowAlarm = YES;
        self.alarmContactId = contactId;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([typeStr isEqualToString:NSLocalizedString(@"defence_disable_alarm", nil)] || [typeStr isEqualToString:NSLocalizedString(@"defence_alarm", nil)] || [typeStr isEqualToString:NSLocalizedString(@"POWEROFF_PROBER_ALARM", nil)]  || [typeStr isEqualToString:NSLocalizedString(@"POWERONPROBER_ALARM", nil)] || [typeStr isEqualToString:NSLocalizedString(@"LOW_POWER_PROBER_ALARM", nil)]|| [typeStr isEqualToString:NSLocalizedString(@"LOW_POWER_RECOVERY_PROBER_ALARM", nil)]) {
                
                [self.popView removeFromSuperview];
                self.popView = [[AlarmalertView alloc]initWithFrame:CGRectMake(10,100, VIEWWIDTH-20, 0.42*VIEWHEIGHT) withtypestr:typeStr withcid:contactId];
                [self.window addSubview:self.popView];
                [self.popView.canclebtn addTarget:self action:@selector(OnCick:) forControlEvents:UIControlEventTouchUpInside];
                [self.popView show];
                
                [self performSelector:@selector(dismissView) withObject:nil afterDelay:2];
                
            }else{
                [self.pop2view removeFromSuperview];
                self.pop2view = [[FullScreenView alloc]initWithFrame:CGRectMake(0,0, VIEWWIDTH, VIEWHEIGHT) withtypestr:typeStr withcid:contactId];
                 self.shockTimer=[Utils shockPhoneWithTarget:self selector:@selector(shockPhone:)];//修改
                [self.window addSubview:self.pop2view];
                [self.pop2view.canclebtn addTarget:self action:@selector(OnCick:) forControlEvents:UIControlEventTouchUpInside];
                [self.pop2view.callbtn addTarget:self action:@selector(OnCick:) forControlEvents:UIControlEventTouchUpInside];
                [self.pop2view show];
            }
            
            
        });
        
        
        DLog(@"%@:%i:%i:%i:%i",contactId,type,isSupportExternAlarm,group,item);
        //        Alarm * alarm = [[Alarm alloc]init];
        //        AlarmDAO * alarmDAO = [[AlarmDAO alloc]init];
        //        alarm.deviceId = contactId;
        //        alarm.alarmTime = [NSString stringWithFormat:@"%d",[Utils getCurrentTimeInterval]];
        //        alarm.alarmType = type;
        //        alarm.alarmGroup = group;
        //        alarm.alarmItem = item;
        //        [alarmDAO insert:alarm];
        //        [alarm release];
        //        [alarmDAO release];
    }
}
- (void)shockPhone:(NSTimer *)timer
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}


//点击现场视频 问题待解决
-(void)OnCick:(UIButton*)btn{
    
    [self stopPlaymusicAndShacke];//修改20161015
    if (btn==self.pop2view.callbtn) {
        
        NSLog(@"查看现场视频");
        [self.pop2view dissmiss];
        
        ContactDAO *contactDAO = [[ContactDAO alloc] init];//数据库的一些操作
        
        Contact *contact = [contactDAO isContact:self.alarmContactId];
  
        if(nil!=contact){
            
            [[P2PClient sharedClient] p2pHungUp];
    
            [self.mainController dismissP2PView:^{
                
                [self.mainController setUpCallWithId:contact.contactId password:contact.contactPassword callType:P2PCALL_TYPE_MONITOR];
                self.lastShowAlarmTimeInterval = [Utils getCurrentTimeInterval];
                self.isShowAlarm = NO;
                
            }];
            
        }else{
            
            UIAlertView *inputAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"input_device_password", nil) message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"ok", nil), nil];
            inputAlert.alertViewStyle = UIAlertViewStyleSecureTextInput;
            UITextField *passwordField = [inputAlert textFieldAtIndex:0];
            passwordField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            inputAlert.tag = ALERT_TAG_MONITOR;
            self.isShowAlarm = NO;
            [inputAlert show];
            [inputAlert release];
        }
        
        return;
    }
    if (btn==self.popView.canclebtn) {
        NSLog(@"忽略");
        [self.popView removeFromSuperview];
        [self.popView dissmiss];
        self.lastShowAlarmTimeInterval = [Utils getCurrentTimeInterval];
        self.isShowAlarm = NO;
        return;
    }
    if (btn==self.pop2view.canclebtn) {
        NSLog(@"屏蔽");
        //        [self.pop2view removeFromSuperview];
        [self.pop2view dissmiss];
        self.isShowAlarm = NO;
        return;
    }
    
}

- (UIViewController *)activityViewController

{
    
    UIViewController* activityViewController = nil;
    
    
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    if(window.windowLevel != UIWindowLevelNormal)
        
    {
        
        NSArray *windows = [[UIApplication sharedApplication] windows];
        
        for(UIWindow *tmpWin in windows)
            
        {
            
            if(tmpWin.windowLevel == UIWindowLevelNormal)
                
            {
                
                window = tmpWin;
                
                break;
                
            }
            
        }
        
    }
    
    
    
    NSArray *viewsArray = [window subviews];
    
    if([viewsArray count] > 0)
        
    {
        
        UIView *frontView = [viewsArray objectAtIndex:0];
        
        
        
        id nextResponder = [frontView nextResponder];
        
        
        
        if([nextResponder isKindOfClass:[UIViewController class]])
            
        {
            
            activityViewController = nextResponder;
            
        }
        
        else
            
        {
            
            activityViewController = window.rootViewController;
            
        }
        
    }
    
    
    
    return activityViewController;
    
}







-(void)stopPlaymusicAndShacke{
    [Utils stopRePlayMusicWithSoundID:self.pop2view.soundID];
    [self.shockTimer invalidate];
}
-(void)dismissView
{
    [self.popView removeFromSuperview];
    [self.popView dissmiss];
    self.lastShowAlarmTimeInterval = [Utils getCurrentTimeInterval];
    self.isShowAlarm = NO;
    return;
}

- (void)networkDidSetup:(NSNotification *)notification {
    
    NSLog(@"JPUSH已连接！！！！");
    
}
/**
 *  登陆成功 设置别名 移除监听
 *
 *  @param notification
 */
- (void)networkDidLogin:(NSNotification *)notification {
    
    NSLog(@"JPUSH已登录！！！！");
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    
    [defaultCenter addObserver:self
                      selector:@selector(networkDidReceiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kJPFNetworkDidLoginNotification
                                                  object:nil];
  
}

/**
 *  收到自定义消息 调用该函数
 *
 *  @param notification 
 */
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    
    NSString *contents = [userInfo valueForKey:@"content"];
    
    //json串  转NSDictionary
    NSData *jsonData = [contents dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    
    NSDictionary *packets;
    NSString *content;
    
    //content = [userInfo  valueForKey:@"content"];20161101 注释
  
    NSLog(@"==============   %@  ========",[dic  valueForKey:@"messsageType"]);
    
    if ([[dic  valueForKey:@"messsageType"]integerValue] ==3 |[[dic  valueForKey:@"messsageType"]integerValue] ==4) {//音乐报文
   
        //不做任何处理
        
    }else{
   
       packets = [dic  valueForKey:@"packet"];
       content = [packets  valueForKey:@"packet"];
    
        //content = [userInfo  valueForKey:@"content"];
        //41414444000000003230313641303032bcbc3706004b1200030002000003000064
        
        NSLog(@"== JPUSHCONTENT= %@ ==", content);
       
        NSString *gw_id;
        NSString *dev_id;
        NSString *dev_type;
        NSString *data_type;
        NSString *data = nil;
        NSInteger deviceType_ID;
        
        if ([content  length] >=60) {
            
            gw_id = [content  substringWithRange:NSMakeRange(16, 16)];
            dev_id = [content  substringWithRange:NSMakeRange(32, 16)];
            dev_type = [content  substringWithRange:NSMakeRange(48, 2)];
            data_type = [content  substringWithRange:NSMakeRange(52, 4)];
            data = [content  substringFromIndex:60];
            
            deviceType_ID = strtoul([[dev_type substringWithRange:NSMakeRange(0, 2)] UTF8String], 0, 16);
            
            NSInteger deviceGategory_ID;
            NSString *deviceName = nil;
            NSString *deviceState = nil;
            NSString * temp;
            NSString *humi;
            NSString *deviceStateStr;
            NSInteger  PM2_5H ;
            NSInteger  PM2_5L ;
            NSInteger  PM2_5;
            
            alarmMessages *alarmMessage = [[alarmMessages  alloc]init];
            
            switch (deviceType_ID) {
                case 1:
                    
                    deviceGategory_ID = 1;
                    deviceName = @"一路开关";
                    deviceState = [transCodingMethods  transCodingFromServer:data];
                    break;
                case 2:
                    
                    deviceGategory_ID = 1;
                    deviceName = @"二路开关";
                    deviceState = [transCodingMethods  transCodingFromServer:data ];
                    break;
                case 3:
                    
                    deviceGategory_ID = 1;
                    deviceName = @"三路开关";
                    deviceState = [transCodingMethods  transCodingFromServer:data ];
                    break;
                case 4:
                
                    deviceGategory_ID = 1;
                    deviceName = @"四路开关";
                    deviceState = [transCodingMethods  transCodingFromServer:data ];
                    break;
                case 5:
                    deviceGategory_ID = 1;
                    deviceName = @"调光开关";
                    deviceState =[NSString  stringWithFormat:@"%lu",strtoul([[data substringWithRange:NSMakeRange(0, 2)] UTF8String], 0, 16)];
                    if ([deviceState isEqualToString:@"10"]) {
                        deviceState = @"9";
                    }
                    break;
                case 6:
                    deviceGategory_ID = 3;
                    deviceName = @"窗帘";
                    deviceState = [transCodingMethods  transCodingFromServer:data ];
                    break;
                case 8:
                    deviceGategory_ID = 5;
                    deviceName = @"插座";
                    deviceState = [transCodingMethods  transCodingFromServer:data ];

                    break;
                case 11:
                    deviceGategory_ID = 3;
                    deviceName = @"窗户";
                    deviceState = [transCodingMethods  transCodingFromServer:data ];
                    break;
                case 51:
                    deviceGategory_ID = 2;
                    deviceName = @"空气净化器";
                    deviceState = [transCodingMethods  transCodingFromServer:data ];

                    break;
                case 104:
                    
                    deviceGategory_ID = 2;
                    deviceName = @"温湿度";
                    temp = [NSString stringWithFormat:@"%lu",strtoul([[data substringWithRange:NSMakeRange(2, 2)] UTF8String], 0, 16)];
                    humi = [NSString  stringWithFormat:@"%lu",strtoul([[data substringWithRange:NSMakeRange(6, 2)] UTF8String], 0, 16)];
                    deviceStateStr = [temp  stringByAppendingString:@"p" ];
                    deviceState = [deviceStateStr  stringByAppendingString:humi];
                    
                    break;
                case 105:
                    deviceName = @"红外转发器";
                    deviceState = data;
                    break;
                case 109:
                    deviceGategory_ID = 2;
                    deviceName = @"PM2.5";
                    PM2_5H = strtoul([[data substringWithRange:NSMakeRange(0, 2)] UTF8String], 0, 16);
                    PM2_5L = strtoul([[data substringWithRange:NSMakeRange(2, 2)] UTF8String], 0, 16);
                    PM2_5 = PM2_5H *10 + PM2_5L/10;
                    deviceState  = [NSString  stringWithFormat:@"%ld",(long)PM2_5];
                    
                    break;
                case 110:
                    deviceGategory_ID = 2;
                    deviceName = @"门磁";
                    deviceState = [transCodingMethods  transThemeCodingFromServer:data ];
                    if ([[deviceState substringToIndex:2] isEqualToString:@"01"]  ) {
                        
                        NSString *string1 =[content  substringToIndex:52];
                        NSString *string2 = @"020000026400";
                        self.alarmString = [string1  stringByAppendingString:string2];
                        
                        alarmMessage.device_no = dev_id;
                        alarmMessage.gateway_no = gw_id;
                        alarmMessage.time = [ControlMethods  getCurrentTime];
                        [alarmMessagesTool  addDevice:alarmMessage];
                    }
                    
                    break;
                case 113:
                    deviceGategory_ID = 2;
                    deviceName = @"红外感应";
                    deviceState = [transCodingMethods  transThemeCodingFromServer:data ];
                    if ([[deviceState substringToIndex:2] isEqualToString:@"01"]  ) {
                        
                        NSString *string1 =[content  substringToIndex:52];
                        NSString *string2 = @"020000026400";
                        self.alarmString = [string1  stringByAppendingString:string2];
                        
                        alarmMessage.device_no = dev_id;
                        alarmMessage.gateway_no = gw_id;
                        alarmMessage.time = [ControlMethods  getCurrentTime];
                       
                        [alarmMessagesTool  addDevice:alarmMessage];
                        
                    }
                   
                    break;
                case 115:
                    deviceGategory_ID = 2;
                    deviceName = @"燃气";
                    deviceState = [transCodingMethods  transThemeCodingFromServer:data ];
                    if ([[deviceState substringToIndex:2] isEqualToString:@"01"]  ) {
                        
                        NSString *string1 =[content  substringToIndex:52];
                        NSString *string2 = @"020000026400";
                        self.alarmString = [string1  stringByAppendingString:string2];
                        
                        alarmMessage.device_no = dev_id;
                        alarmMessage.gateway_no = gw_id;
                        alarmMessage.time = [ControlMethods  getCurrentTime];
                        [alarmMessagesTool  addDevice:alarmMessage];

                    }
                   
                    break;
                    
                case 118:
                    deviceGategory_ID = 2;
                    deviceName = @"烟感";
                    deviceState = [transCodingMethods  transThemeCodingFromServer:data ];
                    if ([[deviceState substringToIndex:2] isEqualToString:@"01"]  ) {
                        
                        NSString *string1 =[content  substringToIndex:52];
                        NSString *string2 = @"020000026400";
                        self.alarmString = [string1  stringByAppendingString:string2];
                        
                        alarmMessage.device_no = dev_id;
                        alarmMessage.gateway_no = gw_id;
                        alarmMessage.time = [ControlMethods  getCurrentTime];
                        [alarmMessagesTool  addDevice:alarmMessage];
                    }
                    break;
                case 201:
                    deviceGategory_ID = 6;
                    deviceName = @"双控";
                    deviceState = [transCodingMethods  transThemeCodingFromServer:data ];
                    break;
                case 202:
                    deviceGategory_ID = 4;
                    deviceName = @"情景开关";
                    deviceState = [transCodingMethods  transThemeCodingFromServer:data];
                    break;
            }
            
            
            deviceMessage *device = [[deviceMessage  alloc]init];

            device.DEVICE_GATEGORY_ID  = deviceGategory_ID;
            device.DEVICE_NAME = deviceName;
            device.DEVICE_STATE = deviceState;
            device.DEVICE_NO = dev_id;
            device.DEVICE_TYPE_ID = deviceType_ID;
            device.GATEWAY_NO = gw_id;
            device.SPACE_NO = @"0";
            device.SPACE_TYPE_ID = 0;

            deviceMessage *dev = [[deviceMessage  alloc]init];
            
            dev.DEVICE_NO = dev_id;
            dev.GATEWAY_NO = gw_id;
            
            NSArray *deviceArray = [deviceMessageTool  queryWithDeviceNumDevices:dev];
            
            if([data_type isEqualToString:@"0100"]){//上行报文
                
                if (deviceArray.count == 0) {//添加新设备
                    
                    [deviceMessageTool  addDevice:device];
                   
                }else{//更新设备状态
                    
                    [deviceMessageTool  updateDeviceMessageOnlyLocal:device];

                }
                
            }if([data_type isEqualToString:@"0c00"]){//退网报文
                
                if (deviceArray.count != 0){
                
                    [deviceMessageTool  deleteDevice:dev];
                    
                }
           
            
            }
        
        }else {
            
            NSLog(@"=======服务器给的报文出错=====");
            
        }
    }
}

/**
 *  传递获取到的 DeviceToken给JPUSH （获取到 DeviceToken 就会调用）
 *
 *  @param application
 *  @param deviceToken
 */
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required - 注册 DeviceToken
    //传递获取到的 DeviceToken给JPUSH ，JUPSH会自动帮我们管理DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    
    NSString *deviceTokens = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceTokens = [deviceTokens stringByReplacingOccurrencesOfString:@" " withString:@""];
    //注册成功，将deviceToken保存到应用服务器数据库中
    NSLog(@"deviceToken！！！！！ = %@",deviceToken);
    self.token = [NSString stringWithFormat:@"%@",deviceTokens];
}


-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    //收到本地推送消息后调用的方法
    DLog(@"%@",notification.alertBody);
    [Utils playMusicWithName:@"message" type:@"mp3"];
}

/**
 *  在ios7以前，只要程序在前台或者后台接收到远程推送过来的通知就会调用
 *
 *  @param application
 *  @param userInfo
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
   
    NSLog(@"userInfo %@", userInfo);
    // 处理推送消息
    NSLog(@"userinfo:%@",userInfo);
    NSArray *allKeys = [userInfo allKeys];
    for (NSString *aString in allKeys) {
        DLog(@"id %@ content is %@", aString, userInfo[aString]);
    }
    
    NSLog(@"收到推送消息:%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
    

    //如果应用程序在后台，点击了通知之后才会调用，如果应用程序在前台，会直接调用，即便应用程序关闭，也可以接收到远程通知
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
    //清除BadgeNumber为0
    [UIApplication sharedApplication].applicationIconBadgeNumber =0;
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    
    [self systemShake];
    [self createSystemSoundWithName:@"alarm.caf" soundType:@"SystemSoundPreview"];
    [self   playSound];
    if (![content isEqualToString:self.alertString]) {
       
        self.alertString = content;
         NSString *alarmMessage = [NSString  stringWithFormat: @"检测到%@发生报警，系统正在为您处理！",content];
        UIAlertView *alter = [[UIAlertView  alloc]initWithTitle:@"报警通知" message:alarmMessage delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"撤防", nil];
        alter.tag = 3;
        self.alter = alter;
        [alter  show];
    }

}

/**
 *  ios7 以后调用
 *
 *  @param application
 *  @param userInfo
 *  @param completionHandler
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"userInfo %@", userInfo);
    // 处理推送消息
    NSLog(@"userinfo:%@",userInfo);
    NSArray *allKeys = [userInfo allKeys];
    for (NSString *aString in allKeys) {
        DLog(@"id %@ content is %@", aString, userInfo[aString]);
    }
    NSLog(@"收到推送消息:%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
    
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
   
    NSLog(@"jpush推送");
    
    //每次处理完推送过来的通知，都必须告诉系统是否处理成功
    //1.方便程序在后台更新数据
    //2.系统会根据状态判断是否处理成功
    completionHandler(UIBackgroundFetchResultNewData);
    
    [self systemShake];
    [self createSystemSoundWithName:@"alarm" soundType:@"caf"];
    [self   playSound];
 
    // 取得 APNs 标准信息内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
   
    if (![content isEqualToString:self.alertString]) {
        
        self.alertString = content;
        
        NSString *alarmMessage = [NSString  stringWithFormat: @"检测到%@发生报警，系统正在为您处理！",content];
        UIAlertView *alter = [[UIAlertView  alloc]initWithTitle:@"报警通知" message:alarmMessage delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"撤防", nil];
        alter.tag = 3;
        self.alter = alter;
        [alter  show];
       
    }

}

//调用震动
-(void)systemShake
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

//调用系统铃声
-(void)createSystemSoundWithName:(NSString *)soundName soundType:(NSString *)soundType
{

    NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@",soundName,soundType];
    if (path) {
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
        AudioServicesPlaySystemSound(soundID);
        
    }
    
}
/**
 *  播放音乐
 */
-(void)playSound{
    
    AudioServicesPlaySystemSound(soundID);
    
}
/**
 *  UIAlertview 代理方法
 *
 *  @param alertView
 *  @param buttonIndex
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
    
    if (self.alter.tag == 3) {
        
        self.alter.tag = 4;
        
        if(buttonIndex ==1){//点击的是确定按键
            //清除BadgeNumber为0
            [UIApplication sharedApplication].applicationIconBadgeNumber =0;
            
            NSLog(@"撤防====%@=====",self.alarmString);
            self.alertString = @"1";
            [ControlMethods  controlDeviceHTTPmethods:self.alarmString];
            
        }if (buttonIndex == 0) {//点击的是取消按键
            //清除BadgeNumber为0
            [UIApplication sharedApplication].applicationIconBadgeNumber =0;
            self.alertString = @"1";
            
        }
    }
    
    
    switch(alertView.tag){
        case ALERT_TAG_ALARMING:
        {
            
            if(buttonIndex==0){
                ContactDAO *contactDAO = [[ContactDAO alloc] init];
                Contact *contact = [contactDAO isContact:self.alarmContactId];
                
                if(nil!=contact){
                    [[P2PClient sharedClient] p2pHungUp];
                    [self.mainController dismissP2PView:^{
                        [self.mainController setUpCallWithId:contact.contactId password:contact.contactPassword callType:P2PCALL_TYPE_MONITOR];
                        self.lastShowAlarmTimeInterval = [Utils getCurrentTimeInterval];
                        self.isShowAlarm = NO;
                    }];
                    
                }else{
                    UIAlertView *inputAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"input_device_password", nil) message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"ok", nil), nil];
                    inputAlert.alertViewStyle = UIAlertViewStyleSecureTextInput;
                    UITextField *passwordField = [inputAlert textFieldAtIndex:0];
                    passwordField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                    inputAlert.tag = ALERT_TAG_MONITOR;
                    [inputAlert show];
                    [inputAlert release];
                }
            }else{
                self.lastShowAlarmTimeInterval = [Utils getCurrentTimeInterval];
                self.isShowAlarm = NO;
            }
        }
            break;
        case ALERT_TAG_MONITOR:
        {
            
            if(buttonIndex==1){
                UITextField *passwordField = [alertView textFieldAtIndex:0];
                
                NSString *inputPwd = passwordField.text;
                if(!inputPwd||inputPwd.length==0){
                    [self.mainController.view makeToast:NSLocalizedString(@"input_device_password", nil)];
                    self.lastShowAlarmTimeInterval = [Utils getCurrentTimeInterval];
                    self.isShowAlarm = NO;
                    return;
                }
                [[P2PClient sharedClient] p2pHungUp];
                [self.mainController dismissP2PView:^{
                    [self.mainController setUpCallWithId:self.alarmContactId password:inputPwd callType:P2PCALL_TYPE_MONITOR];
                    self.lastShowAlarmTimeInterval = [Utils getCurrentTimeInterval];
                    self.isShowAlarm = NO;
                }];
                
                
            }
            self.lastShowAlarmTimeInterval = [Utils getCurrentTimeInterval];
            self.isShowAlarm = NO;
        }
            break;
    }

}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{

    //成功注册registerUserNotificationSettings:后，回调的方法
    NSLog(@"notificationSettings%@",notificationSettings);
}
UIBackgroundTaskIdentifier backgroundTask;
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
- (void)receiveRemoteMessage:(NSNotification *)notification{
    NSDictionary *parameter = [notification userInfo];
    int key   = [[parameter valueForKey:@"key"] intValue];
    switch(key){
        case RET_RECEIVE_MESSAGE:
        {
            NSString *contactId = [parameter valueForKey:@"contactId"];
            NSString *messageStr = [parameter valueForKey:@"message"];
            LoginResult *loginResult = [UDManager getLoginInfo];
            MessageDAO *messageDAO = [[MessageDAO alloc] init];
            Message *message = [[Message alloc] init];
            
            message.fromId = contactId;
            message.toId = loginResult.contactId;
            message.message = [NSString stringWithFormat:@"%@",messageStr];
            message.state = MESSAGE_STATE_NO_READ;
            message.time = [NSString stringWithFormat:@"%ld",[Utils getCurrentTimeInterval]];
            message.flag = -1;
            [messageDAO insert:message];
            [message release];
            [messageDAO release];
            int lastCount = [[FListManager sharedFList] getMessageCount:contactId];
            [[FListManager sharedFList] setMessageCountWithId:contactId count:lastCount+1];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMessage"
                                                                  userInfo:nil];
            });
            UILocalNotification *notification = [[[UILocalNotification alloc] init] autorelease];
            notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
            notification.timeZone = [NSTimeZone defaultTimeZone];
            notification.soundName = @"message.mp3";
            notification.alertBody = [NSString stringWithFormat:@"%@:%@",contactId,messageStr];
            notification.applicationIconBadgeNumber = 1;
            notification.alertAction = NSLocalizedString(@"open", nil);
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
            break;
        case RET_GET_NPCSETTINGS_REMOTE_DEFENCE:
        {
            NSInteger state = [[parameter valueForKey:@"state"] intValue];
            NSString *contactId = [parameter valueForKey:@"contactId"];
            if(state==SETTING_VALUE_REMOTE_DEFENCE_STATE_ON){
                [[FListManager sharedFList] setDefenceStateWithId:contactId type:DEFENCE_STATE_ON];
            }else{
                [[FListManager sharedFList] setDefenceStateWithId:contactId type:DEFENCE_STATE_OFF];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMessage"
                                                                    object:self
                                                                  userInfo:nil];
            });
            DLog(@"RET_GET_NPCSETTINGS_REMOTE_DEFENCE");
            
        }
            break;
    }
}

- (void)ack_receiveRemoteMessage:(NSNotification *)notification{
    NSDictionary *parameter = [notification userInfo];
    int key   = [[parameter valueForKey:@"key"] intValue];
    int result   = [[parameter valueForKey:@"result"] intValue];
    NSString *contactId = [parameter valueForKey:@"contactId"];
    switch(key){
        case ACK_RET_SEND_MESSAGE:
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                int flag = [[parameter valueForKey:@"flag"] intValue];
                MessageDAO *messageDAO = [[MessageDAO alloc] init];
                if(result==0){
                    [messageDAO updateMessageStateWithFlag:flag state:MESSAGE_STATE_NO_READ];
                }else{
                    [messageDAO updateMessageStateWithFlag:flag state:MESSAGE_STATE_SEND_FAILURE];
                }
                [messageDAO release];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMessage"
                                                                        object:self
                                                                      userInfo:nil];
                });
            });
            
            
            DLog(@"ACK_RET_GET_DEVICE_TIME:%i",result);
        }
            break;
        case ACK_RET_GET_DEFENCE_STATE:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                //                NSString *contactId = @"10000";
                if(result==1){
                    
                    [[FListManager sharedFList] setDefenceStateWithId:contactId type:DEFENCE_STATE_WARNING_PWD];
                    if([[FListManager sharedFList] getIsClickDefenceStateBtn:contactId]){
                        //                        [self.window makeToast:NSLocalizedString(@"device_password_error", nil)];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMessage"
                                                                            object:self
                                                                          userInfo:nil];
                    });
                }else if(result==2){
                    [[FListManager sharedFList] setDefenceStateWithId:contactId type:DEFENCE_STATE_WARNING_NET];
                    if([[FListManager sharedFList] getIsClickDefenceStateBtn:contactId]){
                        [self.window makeToast:NSLocalizedString(@"net_exception", nil)];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMessage"
                                                                            object:self
                                                                          userInfo:nil];
                    });
                }else if (result==4){
                    [[FListManager sharedFList] setDefenceStateWithId:contactId type:DEFENCE_STATE_NO_PERMISSION];
                    if([[FListManager sharedFList] getIsClickDefenceStateBtn:contactId]){
                        //                        [self.window makeToast:NSLocalizedString(@"no_permission", nil)];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMessage"
                                                                            object:self
                                                                          userInfo:nil];
                    });
                }
                
                //                [[FListManager sharedFList] setIsClickDefenceStateBtnWithId:contactId isClick:NO];
                
            });
            
            DLog(@"ACK_RET_GET_DEFENCE_STATE:%i",result);
        }
            break;
        case ACK_RET_SET_NPCSETTINGS_REMOTE_DEFENCE:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(result==1){
                    
                    [[FListManager sharedFList] setDefenceStateWithId:contactId type:DEFENCE_STATE_WARNING_PWD];
                    if([[FListManager sharedFList] getIsClickDefenceStateBtn:contactId]){
                        [self.window makeToast:NSLocalizedString(@"device_password_error", nil)];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMessage"
                                                                            object:self
                                                                          userInfo:nil];
                    });
                }else if(result==2){
                    [[FListManager sharedFList] setDefenceStateWithId:contactId type:DEFENCE_STATE_WARNING_NET];
                    if([[FListManager sharedFList] getIsClickDefenceStateBtn:contactId]){
                        [self.window makeToast:NSLocalizedString(@"net_exception", nil)];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMessage"
                                                                            object:self
                                                                          userInfo:nil];
                    });
                }else if (result==4){
                    [[FListManager sharedFList] setDefenceStateWithId:contactId type:DEFENCE_STATE_NO_PERMISSION];
                    if([[FListManager sharedFList] getIsClickDefenceStateBtn:contactId]){
                        [self.window makeToast:NSLocalizedString(@"no_permission", nil)];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMessage"
                                                                            object:self
                                                                          userInfo:nil];
                    });
                }else{
                    ContactDAO *contactDAO = [[ContactDAO alloc] init];
                    Contact *contact = [contactDAO isContact:contactId];
                    if(nil!=contact){
                        [[P2PClient sharedClient] getDefenceState:contact.contactId password:contact.contactPassword];
                    }
                    
                }
                
                //                [[FListManager sharedFList] setIsClickDefenceStateBtnWithId:contactId isClick:NO];
                
            });
            DLog(@"ACK_RET_GET_DEFENCE_STATE:%i",result);
        }
            break;
    }
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    DLog(@"applicationDidEnterBackground");
    
    
    [[P2PClient sharedClient] p2pHungUp];
    [self.mainController dismissP2PView];
    
    
    
    UIApplication *app = [UIApplication sharedApplication];
    UIBackgroundTaskIdentifier taskID;
    taskID = [app beginBackgroundTaskWithExpirationHandler:^{
        [[P2PClient sharedClient] p2pDisconnect];
        [app endBackgroundTask:taskID];
    }];
    
    if (taskID == UIBackgroundTaskInvalid) {
        [[P2PClient sharedClient] p2pDisconnect];
        NSLog(@"Failed to start background task!");
        return;
    }
    
    self.isGoBack = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (self.isGoBack) {
            DLog(@"run background");
            sleep(1.0);
            
        }
    });
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    DLog(@"applicationWillEnterForeground");
    self.isGoBack = NO;
    if([UDManager isLogin]){
        application.applicationIconBadgeNumber = 0;
        LoginResult *loginResult = [UDManager getLoginInfo];
        BOOL result = [[P2PClient sharedClient] p2pConnectWithId:loginResult.contactId codeStr1:loginResult.rCode1 codeStr2:loginResult.rCode2];
        if(result){
            DLog(@"p2pConnect success.");
        }else{
            DLog(@"p2pConnect failure.");
        }
        
        [[NetManager sharedManager] getAccountInfo:loginResult.contactId sessionId:loginResult.sessionId callBack:^(id JSON){
            AccountResult *accountResult = (AccountResult*)JSON;
            loginResult.email = accountResult.email;
            loginResult.phone = accountResult.phone;
            loginResult.countryCode = accountResult.countryCode;
            [UDManager setLoginInfo:loginResult];
        }];
        
        
        //        [[NetManager sharedManager] checkNewMessage:loginResult.contactId sessionId:loginResult.sessionId callBack:^(id JSON){
        //            CheckNewMessageResult *checkNewMessageResult = (CheckNewMessageResult*)JSON;
        //            if(checkNewMessageResult.error_code==NET_RET_CHECK_NEW_MESSAGE_SUCCESS){
        //                if(checkNewMessageResult.isNewContactMessage){
        //                    DLog(@"have new");
        //                    [[NetManager sharedManager] getContactMessageWithUsername:loginResult.contactId sessionId:loginResult.sessionId callBack:^(id JSON){
        //                        NSArray *datas = [NSArray arrayWithArray:JSON];
        //                        if([datas count]<=0){
        //                            return;
        //                        }
        //                        BOOL haveContact = NO;
        //                        for(GetContactMessageResult *result in datas){
        //                            DLog(@"%@",result.message);
        //
        //                            ContactDAO *contactDAO = [[ContactDAO alloc] init];
        //                            Contact *contact = [contactDAO isContact:result.contactId];
        //                            if(nil!=contact){
        //                                haveContact = YES;
        //                            }
        //                            [contactDAO release];
        //                            MessageDAO *messageDAO = [[MessageDAO alloc] init];
        //                            Message *message = [[Message alloc] init];
        //
        //                            message.fromId = result.contactId;
        //                            message.toId = loginResult.contactId;
        //                            message.message = [NSString stringWithFormat:@"%@",result.message];
        //                            message.state = MESSAGE_STATE_NO_READ;
        //                            message.time = [NSString stringWithFormat:@"%@",result.time];
        //                            message.flag = result.flag;
        //                            [messageDAO insert:message];
        //                            [message release];
        //                            [messageDAO release];
        //                            int lastCount = [[FListManager sharedFList] getMessageCount:result.contactId];
        //                            [[FListManager sharedFList] setMessageCountWithId:result.contactId count:lastCount+1];
        //
        //                        }
        //                        if(haveContact){
        //                            [Utils playMusicWithName:@"message" type:@"mp3"];
        //                        }
        //
        //                        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMessage"
        //                                                                            object:self
        //                                                                          userInfo:nil];
        //                    }];
        //                }
        //            }else{
        //
        //            }
        //        }];
        
        
        [[NetManager sharedManager] checkAlarmMessage:loginResult.contactId sessionId:loginResult.sessionId callBack:^(id JSON){
            CheckAlarmMessageResult *checkAlarmMessageResult = (CheckAlarmMessageResult*)JSON;
            if(checkAlarmMessageResult.error_code==NET_RET_CHECK_ALARM_MESSAGE_SUCCESS){
                if(checkAlarmMessageResult.isNewAlarmMessage){
                    DLog(@"have new");
                    
                }
            }else{
                
            }
        }];
    }
    
    
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}



/**
 *  传递 DeviceToken给JPUSH 失败时 调用
 *
 *  @param application
 *  @param error
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
#pragma mark - APP将返回登录界面时，注册新的token，登录时传给服务器
-(void)reRegisterForRemoteNotifications{
    if (CURRENT_VERSION>=9.3) {
        if(CURRENT_VERSION>=8.0){//8.0以后使用这种方法来注册推送通知
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
            
        }else{
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
        }
    }
}
#ifdef NSFoundationVersionNumber_iOS_9_x_Max //接收到通知
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
      
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        
        NSLog(@"iOS10 前台收到远程通知 1");
        [self systemShake];
        [self createSystemSoundWithName:@"alarm" soundType:@"caf"];
        [self   playSound];
        
        // 取得 APNs 标准信息内容
        NSDictionary *aps = [userInfo valueForKey:@"aps"];
        NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
        
        if (![content isEqualToString:self.alertString]) {
            
            self.alertString = content;
            
            NSString *alarmMessage = [NSString  stringWithFormat: @"检测到%@发生报警，系统正在为您处理！",content];
            UIAlertView *alter = [[UIAlertView  alloc]initWithTitle:@"报警通知" message:alarmMessage delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"撤防", nil];
            alter.tag = 3;
            self.alter = alter;
            [alter  show];
            
        }

       
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知");
        [self systemShake];
        [self createSystemSoundWithName:@"alarm" soundType:@"caf"];
        [self   playSound];
        
        // 取得 APNs 标准信息内容
        NSDictionary *aps = [userInfo valueForKey:@"aps"];
        NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
        
        if (![content isEqualToString:self.alertString]) {
            
            self.alertString = content;
            
            NSString *alarmMessage = [NSString  stringWithFormat: @"检测到%@发生报警，系统正在为您处理！",content];
            UIAlertView *alter = [[UIAlertView  alloc]initWithTitle:@"报警通知" message:alarmMessage delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"撤防", nil];
            alter.tag = 3;
            self.alter = alter;
            [alter  show];
            
        }

    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSLog(@"jpush yuancheng");
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知");
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知");
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif


@end
