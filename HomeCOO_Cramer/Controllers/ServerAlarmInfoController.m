//
//  ServerAlarmInfoController.m
//  2cu
//
//  Created by gwelltime on 15-4-2.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//

#import "ServerAlarmInfoController.h"
#import "MainController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "TopBar.h"
#import "Alarm.h"
#import "AlarmHistoryCell.h"
#import "Utils.h"
#import "Toast+UIView.h"

#import "SVPullToRefresh.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "Contact.h"

#import "UDManager.h"
#import "NetManager.h"
#import "LoginResult.h"
#import "GetAlarmRecordResult.h"


@interface ServerAlarmInfoController ()
{
    //上拉
//    MJRefreshFooterView *footerView;
}

@end

@implementation ServerAlarmInfoController

-(void)dealloc{
    [self.tableView release];
    [self.alarmHistory release];
    [self.contact release];
    [self.progressAlert release];
//    [footerView free];
    [super dealloc];
}

- (void)initFooterView
{
    self.tableView.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
       
        LoginResult * login = [UDManager getLoginInfo];
        
        Alarm * alarm = self.alarmHistory[self.alarmHistory.count-1];
        NSString * index = alarm.msgIndex;
        [[NetManager sharedManager] getAlarmRecordWithUsername:login.contactId  sessionId:login.sessionId option:@"1" msgIndex:index senderList:@"1069721" checkLevelType:@"1" vKey:@"123" callBack:^(id JSON) {
            
            GetAlarmRecordResult * alarmRecordResult = (GetAlarmRecordResult *)JSON;
            
            for (Alarm * alarm in alarmRecordResult.alarmRecord) {
                [self.alarmHistory addObject:alarm];
            }
            
            int error_code = alarmRecordResult.error_code;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //整理报警记录，刷新表格
                [self.tableView.mj_footer endRefreshing];
                if (error_code == NET_RET_NO_RECORD) {
                    //无记录,显示提示信息
                    [self.view makeToast:NSLocalizedString(@"no_more_record", nil)];
                }else if (error_code == NET_RET_NO_PERMISSION){
                    [self.view makeToast:NSLocalizedString(@"no_permission", nil)];
                }else if (error_code == NET_RET_UNKNOWN_ERROR){
                    [self.view makeToast:NSLocalizedString(@"unknown_error", nil)];
                }
                if (self.tableView) {
                    [self.tableView reloadData];
                }
            });
        }];
    }];
}

//#pragma mark -MJRefreshBaseViewDelegate
//- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
//{
//    if (refreshView == footerView)
//    {
//        
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

- (void)viewDidLoad {
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
    
    [self updateTableView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}

-(void)updateTableView{
    //向服务器请求报警记录
    LoginResult * login = [UDManager getLoginInfo];
    
    [[NetManager sharedManager] getAlarmRecordWithUsername:login.contactId  sessionId:login.sessionId option:@"2" msgIndex:nil senderList:@"1069721" checkLevelType:@"1" vKey:@"123" callBack:^(id JSON) {
        
        GetAlarmRecordResult * alarmRecordResult = (GetAlarmRecordResult *)JSON;
        self.alarmHistory = [NSMutableArray arrayWithArray:alarmRecordResult.alarmRecord];
        
        int error_code = alarmRecordResult.error_code;
        if (self.alarmHistory.count == 0) {
//            [footerView setHidden:YES];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.progressAlert hide:YES];
            //整理报警记录，刷新表格
            if (error_code == NET_RET_NO_RECORD) {
                //无记录,显示提示信息
                [self.view makeToast:NSLocalizedString(@"no_record", nil)];
            }else if (error_code == NET_RET_NO_PERMISSION){
                [self.view makeToast:NSLocalizedString(@"no_permission", nil)];
            }else if (error_code == NET_RET_UNKNOWN_ERROR){
                [self.view makeToast:NSLocalizedString(@"unknown_error", nil)];
            }
            if (self.tableView) {
                [self.tableView reloadData];
            }
        });
    }];
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
//    [topBar setRightButtonHidden:YES];
//    [topBar setRightButtonIcon:[UIImage imageNamed:@"ic_bar_btn_clear.png"]];
    [topBar.backButton addTarget:self action:@selector(onBackPress) forControlEvents:UIControlEventTouchUpInside];
//    [topBar.rightButton addTarget:self action:@selector(clearPress) forControlEvents:UIControlEventTouchUpInside];
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
                
                [self updateTableView];
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
    
    Alarm * alarm = [self.alarmHistory objectAtIndex:indexPath.row];
    [cell setDeviceId:alarm.deviceId];
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
