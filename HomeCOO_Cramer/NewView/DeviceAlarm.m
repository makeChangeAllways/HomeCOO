//
//  DeviceAlarm.m
//  2cu
//
//  Created by gwelltime on 15-3-30.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//

#import "DeviceAlarm.h"
#import "MainController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "TopBar.h"
#import "Alarm.h"
#import "AlarmDAO.h"
#import "AlarmHistoryCell.h"
#import "Utils.h"
#import "Toast+UIView.h"

#import "MBProgressHUD.h"
#import "SVPullToRefresh.h"
#import "MJRefresh.h"
#import "Contact.h"
#import "P2PClient.h"
#import "MessageDetailController.h"

#define ALERT_TAG_CLEAR 1

@interface DeviceAlarm ()
{
    //上拉
//    MJRefreshFooterView *footerView;
    
    NSInteger startIndex;
}
@end

@implementation DeviceAlarm
-(void)dealloc{
    [self.tableView release];
    [self.alarmHistory release];
    [self.contact release];
    [self.progressAlert release];
//    [footerView free];
    [super dealloc];
}

//- (void)initFooterView
//{
//    footerView = [[MJRefreshFooterView alloc] initWithScrollView:self.tableView];
//    footerView.delegate = self;
//}

#pragma mark -MJRefreshBaseViewDelegate
//- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
//{
//    if (refreshView == footerView)
//    {
//        startIndex = (NSInteger)self.alarmHistory.count;
//        
//        AlarmDAO * alarmDAO = [[AlarmDAO alloc]init];
//        NSMutableArray *array = [NSMutableArray arrayWithArray:[alarmDAO get20AlarmRecordsWithDeviceID:self.contact.contactId startIndex:startIndex]];
//        for(Alarm *alarm in array){
//            [self.alarmHistory addObject:alarm];
//        }
//        
//        startIndex = (NSInteger)self.alarmHistory.count;
//        [alarmDAO release];
//        
//        
//        if (self.tableView) {
//            [self.tableView reloadData];
//        }
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [footerView endRefreshing];//why inside
//        });
//        //[footerView endRefreshing];
//    }
//}

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
    // Do any additional setup after loading the view.
    
    [self initComponent];
    
    [self initFooterView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    MainController *mainController = [AppDelegate sharedDefault].mainController;
    [mainController setBottomBarHidden:YES];
    
    self.progressAlert.dimBackground = YES;
    [self.progressAlert show:YES];
    
    [self updateTableView];//从本地获取报警记录
}

-(void)updateTableView{
    
    AlarmDAO * alarmDAO = [[AlarmDAO alloc]init];
    self.alarmHistory = [NSMutableArray arrayWithArray:[alarmDAO get20AlarmRecordsWithDeviceID:self.contact.contactId startIndex:0]];
    [alarmDAO release];
    if (self.tableView) {
        [self.tableView reloadData];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRemoteMessage:) name:RECEIVE_REMOTE_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ack_receiveRemoteMessage:) name:ACK_RECEIVE_REMOTE_MESSAGE object:nil];
    
    if(self.contact.onLineState==STATE_ONLINE){
        
        //获取报警记录信息(app->设备)
        [[P2PClient sharedClient] getAlarmInfoWithId:self.contact.contactId password:self.contact.contactPassword];
    }else{
        //设备离线，不获取
        [self.progressAlert hide:YES];
//        [self.view makeToast:NSLocalizedString(@"modify_failure", nil)];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RECEIVE_REMOTE_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ACK_RECEIVE_REMOTE_MESSAGE object:nil];
}

- (void)receiveRemoteMessage:(NSNotification *)notification{
    NSDictionary *parameter = [notification userInfo];
    int key   = [[parameter valueForKey:@"key"] intValue];
    switch(key){
        case RET_GET_ALARM_INFO:
        {
            NSInteger result = [[parameter valueForKey:@"result"] intValue];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (result == 1) {
                    AlarmDAO * alarmDAO = [[AlarmDAO alloc]init];
                    self.alarmHistory = [NSMutableArray arrayWithArray:[alarmDAO get20AlarmRecordsWithDeviceID:self.contact.contactId startIndex:0]];
                    [alarmDAO release];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.progressAlert hide:YES];
                        if (self.tableView) {
                            [self.tableView reloadData];
                        }
                    });
                }else{
                    //获取报警记录失败
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.progressAlert hide:YES];
                        [self.view makeToast:NSLocalizedString(@"modify_failure", nil)];
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            usleep(800000);
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self onBackPress];
                            });
                        });
                    });
                }
            });
        }
            break;
        case RET_DEVICE_NOT_SUPPORT:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.progressAlert hide:YES];
                [self.view makeToast:NSLocalizedString(@"device_not_support", nil)];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    usleep(800000);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self onBackPress];
                    });
                });
            });
        }
            break;
    }
    
}

- (void)ack_receiveRemoteMessage:(NSNotification *)notification{
    NSDictionary *parameter = [notification userInfo];
    int key   = [[parameter valueForKey:@"key"] intValue];
    int result   = [[parameter valueForKey:@"result"] intValue];
    switch(key){
        case ACK_RET_GET_ALARM_INFO:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(result==1){
                    [self.progressAlert hide:YES];
                    [self.view makeToast:NSLocalizedString(@"device_password_error", nil)];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        usleep(800000);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self onBackPress];
                        });
                    });
                    
                }else if(result==2){
                    DLog(@"resend do device update");
                    if(self.contact.onLineState==STATE_ONLINE){
                        
                        //获取报警记录信息(app->设备)
                        [[P2PClient sharedClient] getAlarmInfoWithId:self.contact.contactId password:self.contact.contactPassword];
                    }else{
                        //设备离线，不获取
                    }
                }
            });
        }
            break;
    }
    
}


#define CONTACT_ITEM_HEIGHT (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 120:90)
-(void)initComponent{
    [self.view setBackgroundColor:XBgColor];
    
    CGRect rect = [AppDelegate getScreenSize:YES isHorizontal:NO];
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    TopBar *topBar = [[TopBar alloc] initWithFrame:CGRectMake(0, 0, width, NAVIGATION_BAR_HEIGHT)];
    [topBar setTitle:NSLocalizedString(@"alarm_history",nil)];
    [topBar setBackButtonHidden:NO];
    [topBar setRightButtonHidden:NO];
    [topBar setRightButtonIcon:[UIImage imageNamed:@"ic_bar_btn_clear.png"]];
    [topBar.backButton addTarget:self action:@selector(onBackPress) forControlEvents:UIControlEventTouchUpInside];
    [topBar.rightButton addTarget:self action:@selector(clearPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:topBar];
    [topBar release];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, width, height-NAVIGATION_BAR_HEIGHT) style:UITableViewStylePlain];
    [tableView setBackgroundColor:XBgColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [tableView addPullToRefreshWithActionHandler:^{
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            sleep(1.0);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(self.contact.onLineState==STATE_ONLINE){
                    
                    //获取报警记录信息(app->设备)
                    [[P2PClient sharedClient] getAlarmInfoWithId:self.contact.contactId password:self.contact.contactPassword];
                }else{
                    //设备离线，不获取
                }
                [self.tableView.pullToRefreshView stopAnimating];
            });
        });
        
    }];
    
    [tableView release];
    
    self.progressAlert = [[MBProgressHUD alloc]initWithView:self.view];
    self.progressAlert.labelText = NSLocalizedString(@"loading", nil);
    [self.tableView addSubview:self.progressAlert];
    
}

-(void)onBackPress{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clearPress{
    UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"sure_to_clear", nil) message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"ok", nil),nil];
    deleteAlert.tag = ALERT_TAG_CLEAR;
    [deleteAlert show];
    [deleteAlert release];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.alarmHistory count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CONTACT_ITEM_HEIGHT;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"AlarmHistoryCell";
    
    
    AlarmHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell==nil){
        cell = [[[AlarmHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        [cell setBackgroundColor:XBGAlpha];
        
    }
    
    Alarm *alarm = [self.alarmHistory objectAtIndex:indexPath.row];
    [cell setDeviceId:self.contact.contactId];
    [cell setAlarmTime:[Utils convertTimeByInterval:alarm.alarmTime]];
    [cell setAlarmType:alarm.alarmType];
    
    UIImage *backImg = [UIImage imageNamed:@"bg_normal_cell.png"];
    UIImage *backImg_p = [UIImage imageNamed:@"bg_normal_cell_p.png"];
    UIImageView *backImageView = [[UIImageView alloc] init];
    UIImageView *backImageView_p = [[UIImageView alloc] init];
    
    backImg = [backImg stretchableImageWithLeftCapWidth:backImg.size.width*0.5 topCapHeight:backImg.size.height*0.5];
    backImageView.image = backImg;
    [cell setBackgroundView:backImageView];
    
    backImg_p = [backImg_p stretchableImageWithLeftCapWidth:backImg_p.size.width*0.5 topCapHeight:backImg_p.size.height*0.5];
    backImageView_p.image = backImg_p;
    [cell setSelectedBackgroundView:backImageView_p];
    
    [backImageView release];
    [backImageView_p release];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Alarm *alarm = [self.alarmHistory objectAtIndex:indexPath.row];
    MessageDetailController *vc = [[MessageDetailController alloc] init];
    vc.alarm = alarm;
    vc.contact=self.contact;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch(alertView.tag){
        case ALERT_TAG_CLEAR:
        {
            if(buttonIndex==1){
                AlarmDAO *alarmDAO = [[AlarmDAO alloc] init];
                [alarmDAO clearWithDeviceID:self.contact.contactId];
                [self updateTableView];
                [alarmDAO release];
                [self.view makeToast:NSLocalizedString(@"operator_success", nil)];
            }
        }
            break;
    }
}

-(BOOL)shouldAutorotate{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interface {
    return (interface == UIInterfaceOrientationPortrait );
}

#ifdef IOS6

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
#endif

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

@end
