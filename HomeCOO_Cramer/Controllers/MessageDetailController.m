//
//  MessageDetailController.m
//  2cu
//
//  Created by mac on 15/5/15.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//

#import "MessageDetailController.h"
#import "TopBar.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "Toast+UIView.h"
#import "Utils.h"
#import "UDManager.h"
#import "LoginResult.h"
#import "ScreenshotCell.h"
#import "LineLayout.h"
#import "ContactDAO.h"
#import "MessageVideosController.h"
#import "MessageDetailView.h"
#import "CreateInitPasswordController.h"
#import "PrefixHeader.pch"
#include "DeviceAlarmInfoController.h"
#import "FListManager.h"
@interface MessageDetailController ()

@end

@implementation MessageDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initComponent];
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillDisappear:animated];
    MainController *mainController = [AppDelegate sharedDefault].mainController;
    [mainController setBottomBarHidden:YES];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushCreateInitController:) name:@"reset_Device_Notification" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reset_Device_Notification" object:nil];
    
}

- (void)dealloc
{
    
}

-(void)initComponent{
    [self.view setBackgroundColor:XBgColor];
    CGRect rect = [AppDelegate getScreenSize:YES isHorizontal:NO];
    CGFloat width = rect.size.width;
//    CGFloat height = rect.size.height-TAB_BAR_HEIGHT;
    
    
    TopBar *topBar = [[TopBar alloc] initWithFrame:CGRectMake(0, 0, width, NAVIGATION_BAR_HEIGHT)];
    [topBar setTitle:NSLocalizedString(@"消息详情", nil)];
    [topBar setBackButtonHidden:NO];
    [topBar setRightButtonIcon:[UIImage imageNamed:@"ic_bar_btn_clear.png"]];
    [topBar.backButton addTarget:self action:@selector(onBackPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:topBar];
   // [topBar release];
    
    UIImageView*imageview=[[UIImageView alloc]init];
    [self.view addSubview:imageview];
    imageview.frame=CGRectMake(5, NAVIGATION_BAR_HEIGHT+5, VIEWWIDTH-10, 150);
    
    NSString *filePath = [Utils getHeaderFilePathWithId:self.alarm.deviceId];
    UIImage *headImg = [UIImage imageWithContentsOfFile:filePath];
    
    if (headImg) {
        imageview.image=headImg;
    }else
    {
        imageview.image = [UIImage imageNamed:@"bgImageBig.jpg"];
    }
    
    UILabel*namelabel=[[UILabel alloc]init];
    [self.view addSubview:namelabel];
    namelabel.frame=CGRectMake(10, BottomForView(imageview)+10, 200, 40);
    

    MessageDetailView *msgDetailView = [[NSBundle mainBundle] loadNibNamed:@"MessageDetailView" owner:nil options:nil][0];
    [self.view addSubview:msgDetailView];
    msgDetailView.frame = CGRectMake(0, BottomForView(imageview), VIEWWIDTH, 200);
    msgDetailView.alarm = self.alarm;
    msgDetailView.backgroundColor = XBgColor;
    
    
    NSString *titlestr = @"";
    if ((self.alarm.alarmType==8)||(self.alarm.alarmType==9)) {
        titlestr = NSLocalizedString(@"现场视频", nil);
    }else{
        titlestr = NSLocalizedString(@"消息录像", nil);
    }
    
    
//    UILabel*devicename=[[UILabel alloc]init];
//    [self.view addSubview:devicename];
//    devicename.frame=CGRectMake(10, BottomForView(namelabel)+10, 200, 40);
//    devicename.text=[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"alarm_device", nil),self.alarm.deviceId];
//    
//    UILabel*timelabel=[[UILabel alloc]init];
//    [self.view addSubview:timelabel];
//    timelabel.frame=CGRectMake(10, BottomForView(devicename)+10, 200, 40);
//    timelabel.text=[NSString stringWithFormat:@"时间:%@",[Utils convertTimeByInterval:self.alarm.alarmTime]];
    
    
    
 
    
    UIButton*button=[[UIButton alloc]init];
    [self.view addSubview:button];
    button.frame=CGRectMake((VIEWWIDTH-150)/2, BottomForView(msgDetailView), 150, 40);
    button.backgroundColor=XBlue;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:titlestr forState:UIControlStateNormal];
    [button wSetEvent:UIControlEventTouchUpInside ControlEventCBK:^(id sender) {
        
        if ([titlestr isEqualToString:NSLocalizedString(@"现场视频", nil)]) {   //连接监控

                MainController *mainController = [AppDelegate sharedDefault].mainController;
                mainController.contactName = self.contact.contactName;
          
                [mainController setUpCallWithId:self.contact.contactId password:self.contact.contactPassword callType:P2PCALL_TYPE_MONITOR];

        }else{ // 消息录像
            
            MessageVideosController *msgVideo = [[MessageVideosController alloc] init];
            msgVideo.alarm = self.alarm;
            msgVideo.contact = self.contact;
            [self.navigationController pushViewController:msgVideo animated:YES];
            
        }
    }];
    
    
}
-(void)onBackPress{
//    [self.navigationController popViewControllerAnimated:YES];
   for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[DeviceAlarmInfoController class]]) {
                DeviceAlarmInfoController *vc = (DeviceAlarmInfoController *)temp;
                vc.is_in = @"out";
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
}

- (void)pushCreateInitController:(NSNotification *)notify
{
    NSDictionary *userInfo = notify.userInfo;
    NSString *contactId = [userInfo objectForKey:@"contactId"];
    NSString *address = [userInfo objectForKey:@"address"];
    
    Contact *cont = nil;
    NSMutableArray *contacts = [[[FListManager sharedFList] getContacts] mutableCopy];
    for (Contact *contact in contacts) {
        if ([contact.contactId isEqualToString:contactId]) {
            cont = contact;
        }
    }
    
    CreateInitPasswordController *createInitPasswordController = [[CreateInitPasswordController alloc] init];
    [createInitPasswordController setContactId:contactId];
    [createInitPasswordController setAddress:address];
    createInitPasswordController.contact = cont;
    [self.navigationController pushViewController:createInitPasswordController animated:YES];
}

// 支持设备自动旋转
- (BOOL)shouldAutorotate
{
    return NO;
}

// 支持横竖屏显示
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
