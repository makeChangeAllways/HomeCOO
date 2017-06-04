//
//  DeviceAlarmInfoController.m
//  2cu
//
//  Created by gwelltime on 15-3-30.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//



#import "DeviceAlarmInfoController.h"
#import "MainController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "TopBar.h"
#import "Alarm.h"
#import "AlarmDAO.h"
#import "AlarmHistoryCell.h"
#import "Utils.h"
#import "Toast+UIView.h"
#import "PrefixHeader.pch"
#import "MBProgressHUD.h"
//#import "SVPullToRefresh.h"
#import "MJRefresh.h"
#import "Contact.h"
#import "P2PClient.h"
#import "MessageDetailController.h"
#import "FListManager.h"
#import "MessageCell.h"
#import "SingleMessageCell.h"

#define ALERT_TAG_CLEAR 1



@interface DeviceAlarmInfoController ()<UIAlertViewDelegate>
{
    //上拉
//    MJRefreshFooterView *footerView;
    
    NSInteger startIndex;
}

@property(nonatomic,strong)NSMutableArray *New_alarmArray; // 报警数组
@property(nonatomic,strong)NSMutableArray *total_Array;  // 总的数据数组

@property(nonatomic,strong)NSMutableArray *total_models;  // 总的模型数组
@property(nonatomic,strong)NSMutableArray *contacts;  // 设备数组


@property(nonatomic,assign)BOOL is_ADD; //是否添加设备

@property(nonatomic,strong)TopBar *topbar;



@end

@implementation DeviceAlarmInfoController


#pragma mark - 懒加载



- (NSMutableArray *)New_alarmArray
{
    if (_New_alarmArray == nil) {
        _New_alarmArray = [NSMutableArray array];
    }
    return _New_alarmArray;
}


- (NSMutableArray *)total_Array
{
    if (_total_Array == nil ) {
        _total_Array = [NSMutableArray array];
    }
    return _total_Array;
}


- (NSMutableArray *)total_models
{
    if (_total_models == nil) {
        _total_models = [NSMutableArray array];
    }
    return _total_models;
}

- (NSMutableArray *)contacts
{
    if (_contacts == nil) {
        _contacts = [NSMutableArray array];
    }
    return _contacts;
}


#pragma mark -


-(void)dealloc{

//    [footerView free];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RECEIVE_REMOTE_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ACK_RECEIVE_REMOTE_MESSAGE object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DELETE_DEVICE_MESSAGE" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SET_IN" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UPDATE_MESSAGE_LIST" object:nil];
}

- (void)initFooterView
{
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
       
        startIndex = (int)self.alarmHistory.count;
        
        //        NSLog(@"%d",startIndex);
        
        AlarmDAO * alarmDAO = [[AlarmDAO alloc]init];
        
        NSMutableArray *array = [NSMutableArray array];
        if (self.contact) {
            array=[NSMutableArray arrayWithArray:[alarmDAO get20AlarmRecordsWithStartIndex:startIndex with:self.contact.contactId]];
        }else
        {
            array=[NSMutableArray arrayWithArray:[alarmDAO get20AlarmRecordsWithStartIndex:startIndex]];
        }
        
        
        for(Alarm *alarm in array){
            [self.alarmHistory addObject:alarm];
        }
        
        startIndex = (NSInteger)self.alarmHistory.count;
        //        [alarmDAO release];
        
        
        // 判断是否有数据
        if ([self.alarmHistory count]==0) {
            self.noresult.hidden=NO;
            self.tableView.hidden = YES;
        }else{
            self.noresult.hidden=YES;
            self.tableView.hidden = NO;
        }
        
        // 刷新表格
        
        if (self.tableView) {
            [self GetNewListArray:self.alarmHistory]; // resetData
            [self.tableView reloadData];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_footer endRefreshing];//why inside
        });
    }];
}

#pragma mark -MJRefreshBaseViewDelegate
//// 上拉加载更多
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




#define CONTACT_ITEM_HEIGHT (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 120:90)
// 初始化 只进行一次
-(void)initComponent{
    [self.view setBackgroundColor:XBgColor];
    
    self.is_ADD = NO;
    
    
    
    
    CGRect rect = [AppDelegate getScreenSize:YES isHorizontal:NO];
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    // 顶部
    TopBar *topBar = [[TopBar alloc] initWithFrame:CGRectMake(0, 0, width, NAVIGATION_BAR_HEIGHT)];
    
    if (self.contact) {
        [topBar setBackButtonHidden:NO];
        [topBar setTitle:[NSString stringWithFormat:@"%@",self.contact.contactName]];
    }else
    {
        [topBar setBackButtonHidden:YES];
        [topBar setTitle:NSLocalizedString(@"alarm_history",nil)];
    }
    
    
    
    self.topbar = topBar;
    [topBar setRightButtonHidden:NO];
//    topBar.rightButton.backgroundColor=[UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1.0];
    
//    [topBar setRightButtonIcon:[UIImage imageNamed:@"is_read"]];
    [topBar.backButton addTarget:self action:@selector(onBackPress) forControlEvents:UIControlEventTouchUpInside];
    // 清除消息
    // 2015 - 10 - 28 替换成消息已读
//    [topBar.rightButton addTarget:self action:@selector(clearPress) forControlEvents:UIControlEventTouchUpInside];
    [topBar.rightButton addTarget:self action:@selector(isReadPress) forControlEvents:UIControlEventTouchUpInside];
//    topBar.rightButton.frame = CGRectMake(VIEWWIDTH - 62, 22, 62, 62);
//    topBar.rightButton.frame = CGRectMake(VIEWWIDTH - 72, 20, 62, 62);
//    topBar.rightButton.backgroundColor = [UIColor blackColor];
//    topBar.rightButtonIconView.backgroundColor = [UIColor redColor];
    
    
//    topBar.rightButton.frame = CGRectMake(VIEWWIDTH - 61, NAVIGATION_BAR_HEIGHT - 41, 31, 31);
    [self.view addSubview:topBar];
    
//    [topBar release];
    
    // 表格
    [self.tableView removeFromSuperview];
    UITableView *tableView = nil;
    if (self.contact) {
        tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, width, height-NAVIGATION_BAR_HEIGHT) style:UITableViewStylePlain];
    }else
    {
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, width, height-NAVIGATION_BAR_HEIGHT-49) style:UITableViewStylePlain];
    }
    [tableView setBackgroundColor:XBgColor];
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.hidden = YES;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.tableFooterView = [UIView new];

    
    // 设备数组
//    self.contacts = [[[FListManager sharedFList] getContacts] mutableCopy];
    
    
    // 没有数据 -- 显示的图片
    [self.noresult removeFromSuperview];
    UIImageView*imageview=[[UIImageView alloc]init];
//    [self.tableView addSubview:imageview];
    [self.view addSubview:imageview];
//    self.tableView.backgroundColor = [UIColor redColor];
//    imageview.backgroundColor = [UIColor blueColor];
    imageview.frame=CGRectMake(30, (VIEWHEIGHT - (BottomForView(topBar) +100))/2, VIEWWIDTH-60, (VIEWWIDTH-60)/3);
    //    imageview.backgroundColor=[UIColor redColor];
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    
    if (IOS8_OR_LATER) {
        if ([currentLanguage containsString:@"zh-Hans"]) {
            imageview.image = [UIImage imageNamed:@"alarmrecord_nodata_ch"];
        }else if ([currentLanguage containsString:@"en"]) { // 英文
            imageview.image = [UIImage imageNamed:@"alarmrecord_nodata_eng"];
        }else
        {
            imageview.image = [UIImage imageNamed:@"alarmrecord_nodata_fanti"];
        }
    }else
    {
        if ([currentLanguage isEqualToString:@"zh-Hans"]) {
            imageview.image = [UIImage imageNamed:@"alarmrecord_nodata_ch"];
        }else if ([currentLanguage isEqualToString:@"en"]) { // 英文
            imageview.image = [UIImage imageNamed:@"alarmrecord_nodata_eng"];
        }else
        {
            imageview.image = [UIImage imageNamed:@"alarmrecord_nodata_fanti"];
        }
    }
   
    imageview.hidden=NO;
    self.noresult=imageview;

    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 马上进入刷新状态
    [header beginRefreshing];
    
    // 设置header
    tableView.mj_header = header;
    
    
    
    
    // loading
    [self.progressAlert removeFromSuperview];
    self.progressAlert = [[MBProgressHUD alloc]initWithView:self.view];
    self.progressAlert.dimBackground = YES;
    self.progressAlert.labelText = NSLocalizedString(@"loading", nil);
//    [self.progressAlert show:YES];
    [self.view addSubview:self.progressAlert];
    
    [self judgeData];
   
}

// 返回操作
-(void)onBackPress{
    [self.navigationController popViewControllerAnimated:YES];
}


//  清除操作
-(void)clearPress{
    UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"sure_to_clear", nil) message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"ok", nil),nil];
    deleteAlert.tag = ALERT_TAG_CLEAR;
    [deleteAlert show];
//    [deleteAlert release];
}


// 已读设置
- (void)isReadPress{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"设置已读", nil) message:NSLocalizedString(@"是否设置所有消息已读?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"ok", nil), nil];
    [alert show];
    
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1 ) {
        
        [self.topbar setRightButtonIcon:[UIImage imageNamed:@"setread_btn"]];
        
        if (self.contact) { // 是有设备进入的
            // 更新模型数据
            for (NSArray *arry in self.total_models) {
                for (Alarm *alarm in arry) {
                    alarm.isRead = 1;
                }
            }
            //刷新表格
            [self.tableView reloadData];
            // 更新数据库所有数据
            AlarmDAO *alarmDao = [[AlarmDAO alloc] init];

            // 更新数据库数据
            [alarmDao updateWithDeviceID:self.contact.contactId];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_RED_POINT" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_DEVICE_TABLEVIEW" object:nil];
            
        }else
        {
            // 更新模型数据
            for (NSArray *arry in self.total_models) {
                for (Alarm *alarm in arry) {
                    alarm.isRead = 1;
                }
            }
            //刷新表格
            [self.tableView reloadData];
            // 更新数据库所有数据
            AlarmDAO *alarmDao = [[AlarmDAO alloc] init];
//            NSMutableArray *allArray = [alarmDao findAll];
//            for (Alarm *alarm in allArray) {
//                [alarmDao update:alarm];
//            }
//            for (Contact *contact in self.contacts) {
//             
//                [alarmDao updateWithDeviceID:contact.contactId];
//            }
            [alarmDao update];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_RED_POINT" object:nil];
        }

        
    }
}



#pragma mark - View Life week

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNotification];
    
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
    if (self.contact) {
        [mainController setBottomBarHidden:YES];
    }else
    {
        [mainController setBottomBarHidden:NO];
    }
}


-(void)viewDidAppear:(BOOL)animated{
    
//    [self judgeData_NORELOAD];
    [self Is_ALL_Read];
 
}

-(void)viewWillDisappear:(BOOL)animated{

}


#pragma mark - dataJudge

/**
 *  判断当前页面的消息是否全部已读
 */
- (void)Is_ALL_Read
{
    
    BOOL is_all_read = YES;
    if (self.contact) {
        AlarmDAO *alarmDAO = [[AlarmDAO alloc] init];
        NSMutableArray *alarm_arr = [alarmDAO findAllWithDeviceID:self.contact.contactId];
        for (Alarm *alarm in alarm_arr) {
            if (alarm.isRead == 0) {
                is_all_read = NO;
                break;
            }
        }
        is_all_read ? [self.topbar setRightButtonIcon:[UIImage imageNamed:@"setread_btn"]] : [self.topbar setRightButtonIcon:[UIImage imageNamed:@"setreaddisable"]];
        if (is_all_read) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_RED_POINT" object:nil];
        }
        
    }else // 从设备进入
    {
        AlarmDAO *alarmDAO = [[AlarmDAO alloc] init];
        NSMutableArray *alarm_arr = [alarmDAO findAll];
        for (Alarm *alarm in alarm_arr) {
            if (alarm.isRead == 0) {
                is_all_read = NO;
                break;
            }
        }
        is_all_read ? [self.topbar setRightButtonIcon:[UIImage imageNamed:@"setread_btn"]] : [self.topbar setRightButtonIcon:[UIImage imageNamed:@"setreaddisable"]];
        if (is_all_read) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_RED_POINT" object:nil];
        }
    }
}


- (void)judgeData // 判断数据
{
    
    [self.progressAlert show:YES];
    NSMutableArray *temArray = [[[FListManager sharedFList] getContacts] mutableCopy];

    
        self.contacts = temArray;
        // 没有设备
        if (self.contacts.count == 0) {
            self.noresult.hidden = NO;
            self.tableView.hidden = YES;
            [self.progressAlert hide:YES];
        }else
        {
            AlarmDAO *alarmDAO = [[AlarmDAO alloc] init];
            
            // 分为 我的页面和消息页面的进入判断
            [self.alarmHistory removeAllObjects];
            if (self.contact) { // 从设备进入
                self.alarmHistory = [NSMutableArray arrayWithArray:[alarmDAO get20AlarmRecordsWithStartIndex:0 with:self.contact.contactId]];
            }else // 从消息进入
            {
                self.alarmHistory = [NSMutableArray arrayWithArray:[alarmDAO get20AlarmRecordsWithStartIndex:0]];
                
            }
            // 数据库有数据的
            if (self.alarmHistory.count) {
                [self GetNewListArray:self.alarmHistory];
                [self.tableView reloadData];
                self.tableView.hidden = NO;
                self.noresult.hidden = YES;
                [self.progressAlert hide:YES];
            }else // 加载所有设备的数据
            {
                [self MORE_Contact_DATA];
            }
            
        }

}

- (void)judgeData_NORELOAD // 判断数据
{

    self.contacts = [[[FListManager sharedFList] getContacts] mutableCopy];
    if ([self.is_in isEqualToString:@"in"]) {
        
        if (self.contact) { // 从设备进入
            [self MORE_Contact_DATA];
            
            
        }else
        {
    if (self.contacts.count) {
        
        if (self.is_ADD) { // 有添加设备
            [self.progressAlert show:YES];
            [self deleteDATA:nil];
            self.is_ADD = NO;
//            [self.progressAlert hide:YES];
            
        }else
        {
        AlarmDAO *alarmDao = [[AlarmDAO alloc] init];
        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:[alarmDao get20AlarmRecordsWithStartIndex:0]];
        if (tempArr.count > 0) { // 数据库有数据
            self.alarmHistory = tempArr;
            [self GetNewListArray:self.alarmHistory];
            [self.tableView reloadData];
            self.tableView.hidden = NO;
            self.noresult.hidden = YES;
            [self.progressAlert hide:YES];
        }
            
        }
    }
            
        }
    }
}


// 删除数据
- (void)deleteDATA:(NSNotification *)info
{
    
    Contact *contact = [info.userInfo objectForKey:@"contactName"];
    
    // 删除数据库数据
    AlarmDAO *alarmdao = [[AlarmDAO alloc] init];
    [alarmdao clearWithDeviceID:contact.contactId];
    NSMutableArray *contacts = [[[FListManager sharedFList] getContacts] mutableCopy];
    if (contacts.count) {
        [self.total_models removeAllObjects];
        [self.total_Array removeAllObjects];
        [self.alarmHistory removeAllObjects];
        [self.New_alarmArray removeAllObjects];
        
        
        self.alarmHistory = [alarmdao get20AlarmRecordsWithStartIndex:0];
        [self GetNewListArray:self.alarmHistory];
        [self.tableView reloadData];
    }else
    {
        self.tableView.hidden = YES;
        self.noresult.hidden = NO;
    }
    
    
}


// 添加设备
-(void)addContact:(NSNotification *)notify
{
    NSDictionary *dict = notify.userInfo;
    Contact *addcont = [dict objectForKey:@"contactName"];
//    [[P2PClient sharedClient] getAlarmInfoWithId:addcont.contactId password:addcont.contactPassword];
}



- (void)setNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRemoteMessage:) name:RECEIVE_REMOTE_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ack_receiveRemoteMessage:) name:ACK_RECEIVE_REMOTE_MESSAGE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addContact:) name:@"UPDATE_MESSAGE_LIST" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteDATA:) name:@"DELETE_DEVICE_MESSAGE" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setin) name:@"SET_IN" object:nil];
   
    
}

- (void)setin
{
    self.is_in = @"in";
}

// 请求所有设备最新数据
-(void)MORE_Contact_DATA
{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        if (self.contact) {
//            [alarmDAO get20AlarmRecordsWithStartIndex:startIndex with:self.contact.contactId];
            [[P2PClient sharedClient] getAlarmInfoWithId:self.contact.contactId password:self.contact.contactPassword];
            
        }else
        {
            for (int i=0; i<[[[FListManager sharedFList] getContacts] count]; i++) {
                Contact *contact = [[[FListManager sharedFList] getContacts] objectAtIndex:i];
                
                if(contact.onLineState == STATE_ONLINE){
                    //获取报警记录信息(app->设备)
                    [[P2PClient sharedClient] getAlarmInfoWithId:contact.contactId password:contact.contactPassword];
                }else{
                    //设备离线，不获取
                }
            }
        }
        

    });
    
}



#pragma mark - tableView dateResouce & Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
    return  self.total_models.count ? self.total_models.count : 0;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    NSString *DATE = self.New_alarmArray[section];
    
    
    UIView * headView=[[UIView alloc]init];
    headView.frame=CGRectMake(0, 0, VIEWWIDTH, 50);
    headView.backgroundColor=XBgColor;
    
    UILabel*label=[[UILabel alloc]init];
    [headView addSubview:label];
    label.frame=CGRectMake(20, 0, 200, 50);
    label.text=DATE;
    label.textColor=[UIColor grayColor];
    
    
    return headView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (self.total_models.count) {
        NSArray *arr = self.total_models[section];
        return arr.count;
    }else
    {
        return 0;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return CONTACT_ITEM_HEIGHT;
    return 60;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *identifier = @"AlarmHistoryCell";
    
   
    static NSString *identifier = @"msg_cell";
    static NSString *singleId = @"single_msg";
    
    
    
    if (self.contact) {
        
        SingleMessageCell *singCell = [tableView dequeueReusableCellWithIdentifier:singleId];
        if (singCell == nil) {
            singCell = [[NSBundle mainBundle] loadNibNamed:@"SingleMessageCell" owner:nil options:nil][0];
        }
        
        if ([self.alarmHistory count] > 0) { // 可以用alarmHistory 也可以用total_models判断
            NSArray *models = [self.total_models objectAtIndex:indexPath.section];
            Alarm *alarm = [models objectAtIndex:indexPath.row];
            singCell.alarm = alarm;
        }
        return singCell;
        
        
    }else
    {
        MessageCell *msgCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (msgCell == nil) {
            msgCell = [[NSBundle mainBundle] loadNibNamed:@"MessageCell" owner:nil options:nil][0];
        }
        
        if ([self.alarmHistory count] > 0) { // 可以用alarmHistory 也可以用total_models判断
            NSArray *models = [self.total_models objectAtIndex:indexPath.section];
            Alarm *alarm = [models objectAtIndex:indexPath.row];
            
            msgCell.alarm = alarm;
            
        }
        return msgCell;
    }
    
    return [UITableViewCell new];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *models = [self.total_models objectAtIndex:indexPath.section];
    Alarm *alarm = [models objectAtIndex:indexPath.row];
    MessageDetailController *vc = [[MessageDetailController alloc] init];
    vc.alarm = alarm;
    for (Contact *contact in self.contacts) {
        if ([alarm.deviceId isEqualToString:contact.contactId]) {
            vc.contact = contact;
        }
    }
    
    
    [self.navigationController pushViewController:vc animated:YES];
    
    // 更新红点数据
    AlarmDAO *alarmDAO = [[AlarmDAO alloc] init];
    [alarmDAO update:alarm]; // 更新数据库数据
    alarm.isRead = 1; // 更新模型数据
    [self.tableView reloadData]; // 刷新表格
}



#pragma mark - Receive Remotation

// 接收最新消息
- (void)receiveRemoteMessage:(NSNotification *)notification{
    NSDictionary *parameter = [notification userInfo];
    int key   = [[parameter valueForKey:@"key"] intValue];
    
//    [self.progressAlert removeFromSuperview];
    switch(key){
        case RET_GET_ALARM_INFO:
        {
            NSInteger result = [[parameter valueForKey:@"result"] intValue];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (result == 1) {
                    AlarmDAO * alarmDAO = [[AlarmDAO alloc]init];
                    
                    if (self.contact) {
                        self.alarmHistory = [alarmDAO get20AlarmRecordsWithStartIndex:0 with:self.contact.contactId];
                    }else
                    {
                        self.alarmHistory = [alarmDAO get20AlarmRecordsWithStartIndex:0];
                    }
                    
                    
                    // 判断是否获取到数据
                    if ([self.alarmHistory count]==0) {
                        self.noresult.hidden=NO;
                        self.tableView.hidden = YES;
                    }else{
                        self.noresult.hidden=YES;
                        self.tableView.hidden = NO;
                    }
                    
                    if (self.tableView) {
                        [self GetNewListArray:self.alarmHistory]; // resetData
                        dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                        [self.progressAlert hide:YES];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_RED_POINT" object:nil];
                            [self Is_ALL_Read];
                        });
                    }
                }else{
                    //获取报警记录失败
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
//                        [self.view makeToast:NSLocalizedString(@"modify_failure", nil)];
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            usleep(800000);
                            dispatch_async(dispatch_get_main_queue(), ^{
//                                [self onBackPress];
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
//                        [self onBackPress];
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
//    [self.progressAlert hide:YES];
    switch(key){
        case ACK_RET_GET_ALARM_INFO:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(result==1){
                    [self.progressAlert hide:YES];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        usleep(800000);
                        dispatch_async(dispatch_get_main_queue(), ^{
//                            [self onBackPress];
                            [self.progressAlert hide:YES];
                        });
                    });
                    
                }else if(result==2){
                    
                    [self MORE_Contact_DATA];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.progressAlert hide:YES];
                    });
   
                }
            });
        }
            break;
    }
    
}



#pragma mark -


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


#pragma mark - new

/**
 *  给予数组整理出 分好时间数组的数组
 *
 */
- (void)GetNewListArray:(NSMutableArray *)Array
{
  
    // 日期格式
    [self.New_alarmArray removeAllObjects];
    
    
    NSMutableArray *temArr = [NSMutableArray array];
    
    for (Alarm *alar in self.alarmHistory) {  // for
        
        // 转化出的时间
        NSString *time = [Utils convertTimeByInterval:alar.alarmTime];

        NSString *sub_time = [time substringToIndex:10];
        if (temArr.count) { // count
        
            if (![temArr.lastObject isEqualToString:sub_time]) { // !is_equal
                [temArr addObject:sub_time];
            }
        }else
        {
            [temArr addObject:sub_time];
        }  // count
        
    }// for
    
//    NSLog(@"%@",temArr);
    self.New_alarmArray = temArr;
    
        NSMutableArray *total_ARR = [NSMutableArray array]; // 总的数组
    
        NSMutableArray *total_Models = [NSMutableArray array]; // 总的模型数组
    
        for (int index = 0; index < temArr.count; index ++) {
    
            NSString *sub_str = [temArr objectAtIndex:index];
            // 创建一个小数组
            NSMutableArray *sub_Array = [NSMutableArray array]; // 小数组
            
            
            NSMutableArray *mode_arrays = [NSMutableArray array]; // 存放分好模型的数组
            for (Alarm *alar in self.alarmHistory) {
                // 转化出的时间
                NSString *time = [Utils convertTimeByInterval:alar.alarmTime];
                if ([time hasPrefix:sub_str]) {
                    
                    [sub_Array addObject:time];
                    [mode_arrays addObject:alar];
                    
                }
            }
            [total_ARR addObject:sub_Array];
            [total_Models addObject:mode_arrays];
        }

        self.total_Array = total_ARR;
    
        self.total_models = total_Models;


}


- (void)loadNewData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1.0);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // 下拉 获取数据
            for (int i=0; i<[[[FListManager sharedFList] getContacts] count]; i++) {
                Contact *contact = [[[FListManager sharedFList] getContacts] objectAtIndex:i];
                
                if(contact.onLineState==STATE_ONLINE){
                    //获取报警记录信息(app->设备)
                    [[P2PClient sharedClient] getAlarmInfoWithId:contact.contactId password:contact.contactPassword];
                }else{
                    //设备离线，不获取
                    [self.progressAlert hide:YES];
                }
            }
            [self.tableView.mj_header endRefreshing];
        });
    });
}

@end
