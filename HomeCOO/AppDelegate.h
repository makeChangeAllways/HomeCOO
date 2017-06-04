//
//  AppDelegate.h
//  HomeCOO
//
//  Created by tgbus on 16/4/14.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "MainController.h"
#import "Reachability.h"
#import "AlarmalertView.h"
#import "FullScreenView.h"
#import "LoginViewController.h"

#define NET_WORK_CHANGE @"NET_WORK_CHANGE"
#define ALERT_TAG_ALARMING 0
#define ALERT_TAG_MONITOR 1

static NSString *appKey =@"f01169052651936b1a139e18";//（阿里服务器）
static NSString *channel = @"Publish channel";

static BOOL isProduction = true;//用于发布


@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>{
    
    SystemSoundID soundID;//系统声音的id 取值范围为：1000-2000

}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIAlertView *alter;
@property (strong, nonatomic) MainController *mainController;
@property (nonatomic) NetworkStatus networkStatus;
@property (strong, nonatomic) AlarmalertView *popView;
@property (strong, nonatomic) FullScreenView *pop2view;
@property(nonatomic,strong)NSTimer *shockTimer;
+(CGRect)getScreenSize:(BOOL)isNavigation isHorizontal:(BOOL)isHorizontal;
+(AppDelegate*)sharedDefault;

@property (strong, nonatomic) NSString *token;
@property (nonatomic) BOOL isShowAlarm;
@property (strong, nonatomic) NSString *alarmContactId;
@property (nonatomic) long lastShowAlarmTimeInterval;

+(NSString*)getAppVersion;
@property (nonatomic) BOOL isGoBack;

//当iOS系统>=9.3时，在APP将要退回登录界面时，注册远程推送，获取新的token
//原因是，iOS系统>=9.3时，注销远程推送再注册远程推送时，token变了;
-(void)reRegisterForRemoteNotifications;
@end

