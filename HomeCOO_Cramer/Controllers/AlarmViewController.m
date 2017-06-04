//
//  AlarmViewController.m
//  2cu
//
//  Created by mac on 15/5/18.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//

#import "AlarmViewController.h"
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
#import "Contact.h"
#import "PrefixHeader.pch"

@interface AlarmViewController ()

@end

@implementation AlarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self initComponent];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    MainController *mainController = [AppDelegate sharedDefault].mainController;
    [mainController setBottomBarHidden:YES];
}
-(void)initComponent{
    [self.view setBackgroundColor:[UIColor blueColor]];
    CGRect rect = [AppDelegate getScreenSize:YES isHorizontal:NO];
    CGFloat width = rect.size.width;
    //    CGFloat height = rect.size.height-TAB_BAR_HEIGHT;
    
    TopBar *topBar = [[TopBar alloc] initWithFrame:CGRectMake(0, 0, width, NAVIGATION_BAR_HEIGHT)];
    [topBar setTitle:@"报警信息"];
    [self.view addSubview:topBar];
    [topBar release];
    
    UILabel*label1=[[UILabel alloc]init];
    [self.view addSubview:label1];
    label1.text=[NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"device", nil),self.contactid];
    label1.frame=CGRectMake(50, BottomForView(topBar)+50, 200, 40);
    
    UILabel*label2=[[UILabel alloc]init];
    [self.view addSubview:label2];
    label2.text=[NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"alarm_type", nil),self.typestr];
    label2.frame=CGRectMake(50, BottomForView(label1), 200, 40);


    
    
    UIButton*btn1=[[UIButton alloc]init];
    [self.view addSubview:btn1];
    NSString *look = [NSString stringWithFormat:@"%@",NSLocalizedString(@"view", nil)];
    NSString *ignore = [NSString stringWithFormat:@"%@",NSLocalizedString(@"ignore", nil)];
    [btn1 setTitle:look forState:UIControlStateNormal];
    [btn1 setFrame:CGRectMake(150, BottomForView(label2), 100, 50)];
    [btn1 addTarget:self action:@selector(gobtn1) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton*btn2=[[UIButton alloc]init];
    [self.view addSubview:btn2];
    [btn2 setTitle:ignore forState:UIControlStateNormal];
    [btn2 setFrame:CGRectMake(50, BottomForView(label2), 100, 50)];
    [btn2 addTarget:self action:@selector(gobtn2) forControlEvents:UIControlEventTouchUpInside];
}
-(void)gobtn1{
    ContactDAO *contactDAO = [[ContactDAO alloc] init];
    Contact *contact = [contactDAO isContact:self.contactid];
    
//    MainController *mainController = [[MainController alloc] init];
//    self.mainController = mainController;
    
    

    
    if(nil!=contact){
//        [[P2PClient sharedClient] p2pHungUp];
//        [self.mainController dismissP2PView:^{
//            [self.mainController setUpCallWithId:contact.contactId password:contact.contactPassword callType:P2PCALL_TYPE_MONITOR];
////            self.lastShowAlarmTimeInterval = [Utils getCurrentTimeInterval];
////            self.isShowAlarm = NO;
//        }];
        MainController *mainController = [AppDelegate sharedDefault].mainController;
        mainController.contactName = contact.contactName;
        [mainController setUpCallWithId:contact.contactId password:contact.contactPassword callType:P2PCALL_TYPE_MONITOR];
        
    }else{
        UIAlertView *inputAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"input_device_password", nil) message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"ok", nil), nil];
        inputAlert.alertViewStyle = UIAlertViewStyleSecureTextInput;
        UITextField *passwordField = [inputAlert textFieldAtIndex:0];
        passwordField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        inputAlert.tag = ALERT_TAG_MONITOR;
        [inputAlert show];
        [inputAlert release];
    }
    

}
-(void)gobtn2{
//       [CommonFunction dismissModalViewController];
    MainController *mainController = [[MainController alloc] init];
    self.mainController = mainController;
    
//    self.window.rootViewController = self.mainController;

}
@end
