//
//  MainController.m
//  2cu
//
//  Created by guojunyi on 14-3-20.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import "MainController.h"
#import "KeyBoardController.h"
#import "SettingController.h"
#import "RecentController.h"
#import "DiscoverController.h"
#import "ContactController.h"
#import "P2PVideoController.h"
#import "Constants.h"
#import "P2PClient.h"
#import "LoginResult.h"
#import "UDManager.h"
#import "P2PMonitorController.h"
#import "Toast+UIView.h"
#import "P2PCallController.h"
#import "AutoNavigation.h"
#import "GlobalThread.h"
#import "AccountResult.h"
#import "NetManager.h"
#import "AppDelegate.h"
#import "ToolBoxController.h"
#import "CameraManager.h"
#import "AlarmHistoryController.h"
#import "MediaController.h"
#import "DeviceAlarmInfoController.h"
#import "CreateInitPasswordController.h"
#import "LoginViewController.h"
#import "FListManager.h"
#import "LocalDevice.h"
#import "LoginViewController.h"
#define RESET_PASSWORD_ALERT_TAG 1

@interface MainController () <UIAlertViewDelegate>

@property(nonatomic,strong)LocalDevice *loc;

@end

@implementation MainController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [[P2PClient sharedClient] setDelegate:self];
    
    [self initComponent];
    LoginResult *loginResult = [UDManager getLoginInfo];
    BOOL result = [[P2PClient sharedClient] p2pConnectWithId:loginResult.contactId codeStr1:loginResult.rCode1 codeStr2:loginResult.rCode2];
    if(result){
        DLog(@"p2pConnect success.");
    }else{
        DLog(@"p2pConnect failure.");

    }
    
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        while (true) {
//            DLog(@"test thread");
//            sleep(1.0);
//        }
//    });
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initComponent{
    
    //contact
    ContactController *contactController = [[ContactController alloc] init];
    AutoNavigation *controller1 = [[AutoNavigation alloc] initWithRootViewController:contactController];
    
    //UIButton *backBtn = [[UIButton  alloc]initWithFrame:CGRectMake(5, 30, 40, 30)];
    
//    [backBtn  setTitle:@"返回" forState:UIControlStateNormal];
//   // backBtn.backgroundColor = [UIColor  redColor];
//    [backBtn setTitleColor:[UIColor  blackColor] forState:UIControlStateNormal];
//    [backBtn  addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//    [controller1.view  addSubview:backBtn];
    
    [contactController release];
    
    //keyboard
    
//    KeyBoardController *keyBoardController = [[KeyBoardController alloc] init];
//    AutoNavigation *controller2 = [[AutoNavigation alloc] initWithRootViewController:keyBoardController];
//    [keyBoardController release];
    
//    AlarmHistoryController *keyBoardController = [[AlarmHistoryController alloc] init];
//    AutoNavigation *controller2 = [[AutoNavigation alloc] initWithRootViewController:keyBoardController];
//    [keyBoardController release];
    
    DeviceAlarmInfoController *keyBoardController = [[DeviceAlarmInfoController alloc] init];
    AutoNavigation *controller2 = [[AutoNavigation alloc] initWithRootViewController:keyBoardController];
    
    //discover
//    ToolBoxController *toolboxController = [[ToolBoxController alloc] init];
//    AutoNavigation *controller3 = [[AutoNavigation alloc] initWithRootViewController:toolboxController];

    MediaController *toolboxController = [[MediaController alloc] init];
    AutoNavigation *controller3 = [[AutoNavigation alloc] initWithRootViewController:toolboxController];

    
    [toolboxController release];
    
    //setting
    SettingController *settingController = [[SettingController alloc] init];
    AutoNavigation *controller5 = [[AutoNavigation alloc] initWithRootViewController:settingController];
    
    
    [settingController release];
    
    
    [self setViewControllers:@[controller1,controller2,controller3,controller5]];
    [controller1 release];
    //[controller2 release];
    [controller3 release];
    [controller5 release];
    
    [self setSelectedIndex:0];
//    int i = 0;
//    for(RDVTabBarItem *item in self.tabBar.items){
//        switch(i){
//            case 0:
//            {
//                [item setBackgroundSelectedImage:[UIImage imageNamed:@"ic_tab_contact_p.png"] withUnselectedImage:[UIImage imageNamed:@"ic_tab_contact.png"]];
//                
//            }
//            break;
//            case 1:
//            {
//                [item setBackgroundSelectedImage:[UIImage imageNamed:@"ic_tab_keyboard_p.png"] withUnselectedImage:[UIImage imageNamed:@"ic_tab_keyboard.png"]];
//            }
//            break;
//            case 2:
//            {
//                [item setBackgroundSelectedImage:[UIImage imageNamed:@"ic_tab_discover_p.png"] withUnselectedImage:[UIImage imageNamed:@"ic_tab_discover.png"]];
//            }
//            break;
//            case 3:
//            {
//                [item setBackgroundSelectedImage:[UIImage imageNamed:@"ic_tab_recent_p.png"] withUnselectedImage:[UIImage imageNamed:@"ic_tab_recent.png"]];
//            }
//            break;
//            case 4:
//            {
//                [item setBackgroundSelectedImage:[UIImage imageNamed:@"ic_tab_setting_p.png"] withUnselectedImage:[UIImage imageNamed:@"ic_tab_setting.png"]];
//            }
//            break;
//        }
//        
//        
//        i++;
//    }
    
    
    
}

-(void)backAction{

    [self  dismissViewControllerAnimated:YES completion:nil];

}
-(void)setUpCallWithId:(NSString *)contactId password:(NSString *)password callType:(P2PCallType)type{
    
    [[P2PClient sharedClient] setIsBCalled:NO];
    [[P2PClient sharedClient] setCallId:contactId];
    [[P2PClient sharedClient] setP2pCallType:type];
    [[P2PClient sharedClient] setCallPassword:password];

    
    if(!self.presentedViewController){
        
 
        MainController *mainController = [AppDelegate sharedDefault].mainController;
    
        P2PCallController *p2pCallController = [[P2PCallController alloc] init];
        p2pCallController.contactName = self.contactName;
        
       
        
        AutoNavigation *controller = [[AutoNavigation alloc] initWithRootViewController:p2pCallController];
        
      
        
             // if (self.view.window.rootViewController) {
            
       // }else{
         //   LoginViewController *loginViewController = [[LoginViewController alloc]init];
          //  self.view.window.rootViewController = loginViewController;
       // }
        
      
        [mainController  presentViewController:controller animated:YES completion:^{
            
        }];
        
        
        [p2pCallController release];
        [controller release];
        //[[P2PClient sharedClient] p2pCallWithId:contactId password:password callType:type];
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





-(void)setUpCallWithId:(NSString *)contactId address:(NSString*)address password:(NSString *)password callType:(P2PCallType)type{
    [[P2PClient sharedClient] setIsBCalled:NO];
    [[P2PClient sharedClient] setCallId:contactId];
    [[P2PClient sharedClient] setP2pCallType:type];
    [[P2PClient sharedClient] setCallPassword:password];

    if(!self.presentedViewController){
        
        P2PCallController *p2pCallController = [[P2PCallController alloc] init];
        p2pCallController.contactName = self.contactName;
        [p2pCallController setAddress:address];
        AutoNavigation *controller = [[AutoNavigation alloc] initWithRootViewController:p2pCallController];
        [self presentViewController:controller animated:YES completion:^{
            
        }];
        [p2pCallController release];
        [controller release];
        //[[P2PClient sharedClient] p2pCallWithId:contactId password:password callType:type];
    }
}


-(void)P2PClientCalling:(NSDictionary*)info{
   //NSLog(@"P2PClientCalling");
    BOOL isBCalled = [[P2PClient sharedClient] isBCalled];
    NSString *callId = [[P2PClient sharedClient] callId];
    if(isBCalled){
        if([[AppDelegate sharedDefault] isGoBack]){
            UILocalNotification *alarmNotify = [[[UILocalNotification alloc] init] autorelease];
            alarmNotify.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
            alarmNotify.timeZone = [NSTimeZone defaultTimeZone];
            alarmNotify.soundName = @"default";
            alarmNotify.alertBody = [NSString stringWithFormat:@"%@:Calling!",callId];
            alarmNotify.applicationIconBadgeNumber = 1;
            alarmNotify.alertAction = NSLocalizedString(@"open", nil);
            [[UIApplication sharedApplication] scheduleLocalNotification:alarmNotify];
            return;
        }
        
        if(!self.isShowP2PView){
            self.isShowP2PView = YES;
            UIViewController *presentView1 = self.presentedViewController;
            UIViewController *presentView2 = self.presentedViewController.presentedViewController;
            if(presentView2){
                [self dismissViewControllerAnimated:YES completion:^{
                    P2PCallController *p2pCallController = [[P2PCallController alloc] init];
                    AutoNavigation *controller = [[AutoNavigation alloc] initWithRootViewController:p2pCallController];
                    
                    [self presentViewController:controller animated:YES completion:^{
                        
                    }];
                    
                    [p2pCallController release];
                    [controller release];
                }];
            }else if(presentView1){
                [presentView1 dismissViewControllerAnimated:YES completion:^{
                    P2PCallController *p2pCallController = [[P2PCallController alloc] init];
                    AutoNavigation *controller = [[AutoNavigation alloc] initWithRootViewController:p2pCallController];
                    
                    [self presentViewController:controller animated:YES completion:^{
                        
                    }];
                    
                    [p2pCallController release];
                    [controller release];
                }];
            }else{
                P2PCallController *p2pCallController = [[P2PCallController alloc] init];
                AutoNavigation *controller = [[AutoNavigation alloc] initWithRootViewController:p2pCallController];
                
                [self presentViewController:controller animated:YES completion:^{
                    
                }];
                
                [p2pCallController release];
                [controller release];
            }
            
            
        }
        
    }
}

-(void)dismissP2PView{
    UIViewController *presentView1 = self.presentedViewController;
    UIViewController *presentView2 = self.presentedViewController.presentedViewController;
    if(presentView2){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [presentView1 dismissViewControllerAnimated:YES completion:nil];
    }
    self.isShowP2PView = NO;
}

-(void)dismissP2PView:(void (^)())callBack{
    UIViewController *presentView1 = self.presentedViewController;
    UIViewController *presentView2 = self.presentedViewController.presentedViewController;
    if(presentView2){
        [self dismissViewControllerAnimated:YES completion:^{
            
           
            callBack();
        }];
    }else if(presentView1){
        [presentView1 dismissViewControllerAnimated:YES completion:^{
           
            callBack();
        }];
    }else{
        
        callBack();
    }
    self.isShowP2PView = NO;
}

-(void)P2PClientReject:(NSDictionary*)info{
    
    // Current_Contact

    [[P2PClient sharedClient] setP2pCallState:P2PCALL_STATE_NONE];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        usleep(500000);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            [self dismissP2PView];
            
            
            int errorFlag = [[info objectForKey:@"errorFlag"] intValue];
            switch(errorFlag)
            {
                case CALL_ERROR_NONE:
                {
                    [self.view makeToast:NSLocalizedString(@"id_unknown_error", nil)];
                    break;
                }
                case CALL_ERROR_DESID_NOT_ENABLE:
                {
                    [self.view makeToast:NSLocalizedString(@"id_disabled", nil)];
                    break;
                }
                case CALL_ERROR_DESID_OVERDATE:
                {
                    [self.view makeToast:NSLocalizedString(@"id_overdate", nil)];
                    break;
                }
                case CALL_ERROR_DESID_NOT_ACTIVE:
                {
                    [self.view makeToast:NSLocalizedString(@"id_inactived", nil)];

                    break;
                }
                case CALL_ERROR_DESID_OFFLINE:
                {
                    [self.view makeToast:NSLocalizedString(@"id_offline", nil)];

                    break;
                }
                case CALL_ERROR_DESID_BUSY:
                {
                    [self.view makeToast:NSLocalizedString(@"id_busy", nil)];

                    break;
                }
                case CALL_ERROR_DESID_POWERDOWN:
                {
                    [self.view makeToast:NSLocalizedString(@"id_powerdown", nil)];

                    break;
                }
                case CALL_ERROR_NO_HELPER:
                {
                    [self.view makeToast:NSLocalizedString(@"id_connect_failed", nil)];

                    break;
                }
                case CALL_ERROR_HANGUP:
                {
                    [self.view makeToast:NSLocalizedString(@"id_hangup", nil)];

                    break;
                }
                case CALL_ERROR_TIMEOUT:
                {
                    [self.view makeToast:NSLocalizedString(@"id_timeout", nil)];

                    break;
                }
                case CALL_ERROR_INTER_ERROR:
                {
                    [self.view makeToast:NSLocalizedString(@"id_internal_error", nil)];

                    break;
                }
                case CALL_ERROR_RING_TIMEOUT:
                {
                    [self.view makeToast:NSLocalizedString(@"id_no_accept", nil)];

                    break;
                }
                case CALL_ERROR_PW_WRONG:
                {
                    NSArray *arr = [[FListManager sharedFList] getLocalDevices];
                   
                    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
                    NSString *contactID = [userdefault objectForKey:@"Current_Contact"];
                    int i = 0;
                    for (LocalDevice *loc in arr) {
                        if ([loc.contactId isEqualToString:contactID]) { // 取出改设备ID -
                            if (loc.flag == 0) { // 已重置
                                
                                
                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"重置密码", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"ok", nil), nil];
                                alertView.tag = RESET_PASSWORD_ALERT_TAG;
                                
                                self.loc = loc;
                                [alertView show];
                            
                                i++;
                            }else if (loc.flag == 1) // 非重置
                            {
                                [self.view makeToast:NSLocalizedString(@"id_password_error", nil)];
                                i++;
                            }
                        }
                    }
                    if (i == 0) {
                        [self.view makeToast:NSLocalizedString(@"id_password_error", nil)];
                    }
                   
                    
                    

                    break;
                }
                case CALL_ERROR_NOT_SUPPORT:
                {
                    [self.view makeToast:NSLocalizedString(@"id_not_support", nil)];
                    break;
                }
                case CALL_ERROR_CONN_FAIL:
                {
                    [self.view makeToast:NSLocalizedString(@"id_connect_failed", nil)];
                    break;
                }
                default:
                    [self.view makeToast:NSLocalizedString(@"id_unknown_error", nil)];

                    break;
            }
        });
    });
    
}


-(void)P2PClientAccept:(NSDictionary*)info{
   //  NSLog(@"P2PClientAccept");
}

-(void)P2PClientReady:(NSDictionary*)info{
    
 //NSLog(@"P2PClientReady");
    
    [[P2PClient sharedClient] setP2pCallState:P2PCALL_STET_READY];
    
    if([[P2PClient sharedClient] p2pCallType]==P2PCALL_TYPE_MONITOR){
        P2PMonitorController *monitorController = [[P2PMonitorController alloc] init];
        NSArray *contacts = [[[FListManager sharedFList] getContacts] mutableCopy];
        Contact *use_contact = nil;
        for (Contact *cont in contacts) {
            if ([cont.contactName isEqualToString:self.contactName]) {
                use_contact = cont;
            }
        }
        
        monitorController.contact = use_contact;
        
        if (self.presentedViewController) {
            [self.presentedViewController presentViewController:monitorController animated:YES completion:nil];
        }else{
            [self presentViewController:monitorController animated:YES completion:nil];
        }
        [monitorController release];
    }else if([[P2PClient sharedClient] p2pCallType]==P2PCALL_TYPE_VIDEO){
        P2PVideoController *videoController = [[P2PVideoController alloc] init];
        if (self.presentedViewController) {
            [self.presentedViewController presentViewController:videoController animated:YES completion:nil];
        }else{
            [self presentViewController:videoController animated:YES completion:nil];
        }
        [videoController release];
    }
}
#pragma mark - Alert Delegate - 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == RESET_PASSWORD_ALERT_TAG) {
        
        if (buttonIndex == 0) {
            
        }else
        {
            NSMutableDictionary *userinfo = [NSMutableDictionary dictionary];
            [userinfo setObject:self.loc.contactId forKey:@"contactId"];
            [userinfo setObject:self.loc.address forKey:@"address"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reset_Device_Notification" object:nil userInfo:userinfo];
        }
        
        
    }
}

-(BOOL)shouldAutorotate{
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interface {
    return (interface == UIInterfaceOrientationPortrait );
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}
@end
