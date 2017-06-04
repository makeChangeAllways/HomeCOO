//
//  AlarmHistoryController.m
//  2cu
//
//  Created by Jie on 14-10-22.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import "AlarmHistoryController.h"
#import "MainController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "TopBar.h"
#import "Alarm.h"
#import "AlarmDAO.h"
#import "AlarmHistoryCell.h"
#import "Utils.h"
#import "Toast+UIView.h"

#import "SVPullToRefresh.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "FListManager.h"
#import "LocalDeviceCell.h"
#import "Contact.h"
#import "DeviceAlarmInfoController.h"
#import "ServerAlarmInfoController.h"
#import "MessageDetailController.h"

#define ALERT_TAG_CLEAR 1
@interface AlarmHistoryController ()
{
    //
    BOOL isLocalAlarmRecord;
    
    //
    BOOL isDeviceAlarmRecord;
    
    //
    BOOL isServerAlarmRecord;
    
    //上拉
    
    
    NSInteger startIndex;
}
@end

@implementation AlarmHistoryController

-(void)dealloc{
    [self.tableView release];
    [self.alarmHistory release];
    
    [self.progressAlert release];
    [super dealloc];
}

//- (void)initFooterView
//{
//    self.tableView.mj_footer
//}

#pragma mark -MJRefreshBaseViewDelegate
//- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
//{
//    if (refreshView == footerView)
//    {
//        startIndex = (NSInteger)self.alarmHistory.count;
////         startIndex = (NSInteger)self.dataarry.count;
//        
//        AlarmDAO * alarmDAO = [[AlarmDAO alloc]init];
//        NSMutableArray *array = [NSMutableArray arrayWithArray:[alarmDAO get20AlarmRecordsWithStartIndex:startIndex]];
//        for(Alarm *alarm in array){
//            [self.alarmHistory addObject:alarm];
////            [self.dataarry addObject:alarm];
//        }
//        
//        startIndex = (NSInteger)self.alarmHistory.count;
////        startIndex = (NSInteger)self.dataarry.count;
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
    
    if (isLocalAlarmRecord) {
        [self initFooterView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    MainController *mainController = [AppDelegate sharedDefault].mainController;
//    [mainController setBottomBarHidden:YES];
    [mainController setBottomBarHidden:NO];
    
    
    if(isLocalAlarmRecord){
        self.progressAlert.dimBackground = YES;
        [self.progressAlert show:YES];
        
        [self updateTableView];
    }
}

-(void)updateTableView{
    
    AlarmDAO * alarmDAO = [[AlarmDAO alloc]init];
    self.alarmHistory = [NSMutableArray arrayWithArray:[alarmDAO get20AlarmRecordsWithStartIndex:0]];
    [alarmDAO release];
    if (self.tableView) {
        [self.tableView reloadData];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    if(isLocalAlarmRecord){
        [self.progressAlert hide:YES];;
    }
}

#define CONTACT_ITEM_HEIGHT (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 120:90)
#define TABLE_ITEM_HEIGHT (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 68:40)

-(void)initComponent{
    //
    NSString * plist = [[NSBundle mainBundle] pathForResource:@"Common-Configuration" ofType:@"plist"];
    NSDictionary * dic = [NSDictionary dictionaryWithContentsOfFile:plist];
    isLocalAlarmRecord = [dic[@"isLocalAlarmRecord"] boolValue];
    isDeviceAlarmRecord = [dic[@"isDeviceAlarmRecord"] boolValue];
    isServerAlarmRecord = [dic[@"isServerAlarmRecord"] boolValue];
    
    
    [self.view setBackgroundColor:XBgColor];
    CGRect rect = [AppDelegate getScreenSize:YES isHorizontal:NO];
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    TopBar *topBar = [[TopBar alloc] initWithFrame:CGRectMake(0, 0, width, NAVIGATION_BAR_HEIGHT)];
    [topBar setTitle:NSLocalizedString(@"alarm_history",nil)];
    [topBar setBackButtonHidden:NO];
//    topBar.rightButton.backgroundColor=[UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1.0];
    if (isLocalAlarmRecord) {
        [topBar setRightButtonHidden:NO];
    }else{
        [topBar setRightButtonHidden:YES];
    }
    [topBar setRightButtonIcon:[UIImage imageNamed:@"ic_bar_btn_clear.png"]];
    [topBar.backButton addTarget:self action:@selector(onBackPress) forControlEvents:UIControlEventTouchUpInside];
    [topBar.rightButton addTarget:self action:@selector(clearPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:topBar];
    topBar.backButton.hidden=YES;
    [topBar release];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, width, height-NAVIGATION_BAR_HEIGHT-49) style:UITableViewStylePlain];
    [tableView setBackgroundColor:XBgColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    
    
    
    
    if (isLocalAlarmRecord) {
        [tableView addPullToRefreshWithActionHandler:^{

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                sleep(1.0);
                dispatch_async(dispatch_get_main_queue(), ^{

                    [self updateTableView];
                    [self.tableView.pullToRefreshView stopAnimating];
                });
            });
            
        }];
    }
    [tableView release];
    
    if (isLocalAlarmRecord) {
        self.progressAlert = [[MBProgressHUD alloc]initWithView:self.view];
        self.progressAlert.labelText = NSLocalizedString(@"loading", nil);
        [self.view addSubview:self.progressAlert];
    }

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
    if (isLocalAlarmRecord) {
       return [self.alarmHistory count];
    }else{
       return [[[FListManager sharedFList] getContacts] count];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isLocalAlarmRecord) {
        return CONTACT_ITEM_HEIGHT;
    }else{
//        return TABLE_ITEM_HEIGHT;
        return 60;
    }
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isLocalAlarmRecord) {
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

    }else{
        static NSString *identifier = @"LocalDeviceCell";
        LocalDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell==nil){
            cell = [[[LocalDeviceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }

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

        Contact *contact = [[[FListManager sharedFList] getContacts] objectAtIndex:indexPath.row];
//        cell.rightImage = @"ic_local_devices_arrow.png";
        cell.contentText = contact.contactId;
        switch (contact.contactType) {
            case CONTACT_TYPE_IPC:
            {
                cell.leftImage = @"ic_contact_type_ipc.png";
            }
                break;
            case CONTACT_TYPE_NPC:
            {
                cell.leftImage = @"ic_contact_type_npc.png";
            }
                break;
            default:
            {
                cell.leftImage = @"ic_contact_type_unknown.png";
            }
                break;
        }
        
        
//        static NSString *identifier = @"AlarmHistoryCell";
//        
//        
//        AlarmHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//        
//        if(cell==nil){
//            cell = [[[AlarmHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        }
//        Alarm * alarm = [self.dataarry objectAtIndex:indexPath.row];
//        
//        [cell setDeviceId:alarm.deviceId];
//        [cell setAlarmTime:[Utils convertTimeByInterval:alarm.alarmTime]];
//        [cell setAlarmType:alarm.alarmType];
//        
//        if ((alarm.alarmType==8)||(alarm.alarmType==9)) {
//            [cell setLeftimg:[UIImage imageNamed:@"message_removalblue.png"]];
//        }else{
//        [cell setLeftimg:[UIImage imageNamed:@"message_police"]];
//        }
        
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    Alarm *alarm = [self.dataarry objectAtIndex:indexPath.row];
//    MessageDetailController *vc = [[MessageDetailController alloc] init];
//    vc.alarm = alarm;
//    [self.navigationController pushViewController:vc animated:YES];
//    return;
    
    if (isDeviceAlarmRecord) {//进入设备返回的报警消息列表
        
        Contact *contact = [[[FListManager sharedFList] getContacts] objectAtIndex:indexPath.row];
        
        DeviceAlarmInfoController *deviceAlarmInfoController = [[DeviceAlarmInfoController alloc] init];
        deviceAlarmInfoController.contact = contact;
        [self.navigationController pushViewController:deviceAlarmInfoController animated:YES];
        [deviceAlarmInfoController release];
    }else if (isServerAlarmRecord){//进入服务器返回的报警消息列表
        Contact *contact = [[[FListManager sharedFList] getContacts] objectAtIndex:indexPath.row];
        
        ServerAlarmInfoController *serverAlarmInfoController = [[ServerAlarmInfoController alloc] init];
        serverAlarmInfoController.contact = contact;
        [self.navigationController pushViewController:serverAlarmInfoController animated:YES];
        [serverAlarmInfoController release];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch(alertView.tag){
//        case ALERT_TAG_DELETE:
//        {
//            if(buttonIndex==1){
//                RecentDAO *recentDAO = [[RecentDAO alloc] init];
//                [recentDAO delete:[self.recents objectAtIndex:self.curDelIndexPath.row]];
//                [self.recents removeObjectAtIndex:self.curDelIndexPath.row];
//                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.curDelIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//                [recentDAO release];
//                [self.view makeToast:NSLocalizedString(@"operator_success", nil)];
//            }
//        }
//            break;
        case ALERT_TAG_CLEAR:
        {
            if(buttonIndex==1){
                AlarmDAO *alarmDAO = [[AlarmDAO alloc] init];
                [alarmDAO clear];
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
