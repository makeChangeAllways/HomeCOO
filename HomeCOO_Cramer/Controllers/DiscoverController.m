//
//  DiscoverController.m
//  2cu
//
//  Created by guojunyi on 14-3-21.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import "DiscoverController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "TopBar.h"
#import "GCDAsyncUdpSocket.h"

#import <ifaddrs.h>
#import <arpa/inet.h>
#import <sys/types.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import "mesg.h"
#import "P2PSwitchCell.h"
#import "ShakeCell.h"
#import "Contact.h"
#import "Utils.h"
#import "MainController.h"
#import "ContactDAO.h"
#import "AddContactNextController.h"
#import "CreateInitPasswordController.h"
#import "Toast+UIView.h"
#import "MJRefresh.h"
#import "PrefixHeader.pch"
@interface DiscoverController ()
{
    //上拉
//    MJRefreshFooterView *footerView;
    
    NSInteger startIndex;
}


@end

@implementation DiscoverController

-(void)dealloc{
    [self.animView release];
    [self.tableView release];
    [self.types release];
    [self.flags release];
    [self.addresses release];
    [self.progressAlert release];
//    [footerView free];
    [super dealloc];
}


- (void)initFooterView
{
//    footerView = [[MJRefreshFooterView alloc] initWithScrollView:self.tableView];
//    footerView.delegate = self;
    self.tableView.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
       
        if (self.tableView) {
            [self.tableView reloadData];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_footer endRefreshing];//why inside
        });
    }];
}

//#pragma mark -MJRefreshBaseViewDelegate
//- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
//{
//    if (refreshView == footerView)
//    {
////        startIndex = (NSInteger)self.alarmHistory.count;
////        
////        AlarmDAO * alarmDAO = [[AlarmDAO alloc]init];
////        //        NSMutableArray *array = [NSMutableArray arrayWithArray:[alarmDAO get20AlarmRecordsWithDeviceID:self.contact.contactId startIndex:startIndex]];
////        NSMutableArray *array=[NSMutableArray arrayWithArray:[alarmDAO get20AlarmRecordsWithStartIndex:startIndex]];
////        for(Alarm *alarm in array){
////            [self.alarmHistory addObject:alarm];
////        }
////        
////        startIndex = (NSInteger)self.alarmHistory.count;
////        [alarmDAO release];
////        
////        if ([self.alarmHistory count]==0) {
////            self.noresult.hidden=NO;
////        }else{
////            self.noresult.hidden=YES;
////        }
//        
//        
//       
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

-(void)viewDidAppear:(BOOL)animated{
    [self.tableView reloadData];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        usleep(800000);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.progressAlert hide:YES];
            
        });
    });
    
    
    self.isNotNeedReloadData = NO;
    //[[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    [self becomeFirstResponder];
    
    self.isSearching = NO;
    self.isRun = YES;
    self.isPrepared = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        while(self.isRun){
            if(!self.isPrepared){
                [self prepareSocket];
            }else{
                [self sendUDPBroadcast];
            }
            
            
            usleep(1000000);
        }
    });
    
    
    

}

-(BOOL)prepareSocket{
    GCDAsyncUdpSocket *socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    NSError *error = nil;
    
    
    if (![socket bindToPort:8899 error:&error])
    {
        //NSLog(@"Error binding: %@", [error localizedDescription]);
        return NO;
    }
    if (![socket beginReceiving:&error])
    {
        NSLog(@"Error receiving: %@", [error localizedDescription]);
        return NO;
    }
    
    if (![socket enableBroadcast:YES error:&error])
    {
        NSLog(@"Error enableBroadcast: %@", [error localizedDescription]);
        return NO;
    }
    
    self.socket = socket;
    self.isPrepared = YES;
    return YES;
}

-(void)viewWillAppear:(BOOL)animated{
    MainController *mainController = [AppDelegate sharedDefault].mainController;
    [mainController setBottomBarHidden:YES];
    
    self.progressAlert.dimBackground = YES;
    [self.progressAlert show:YES];
    
    
}
-(void)updateTableView{
    
//    AlarmDAO * alarmDAO = [[AlarmDAO alloc]init];
//    self.alarmHistory = [NSMutableArray arrayWithArray:[alarmDAO get20AlarmRecordsWithStartIndex:0]];
//    [alarmDAO release];
    if (self.tableView) {
        [self.tableView reloadData];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(!self.isNotNeedReloadData){
        [self.types removeAllObjects];
        [self.flags removeAllObjects];
        [self.tableView reloadData];
    }
    
     
    //[[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:NO];
    [self.toastView setHidden:YES];
    self.isSearching = NO;
    self.isRun = NO;
    if(self.socket){
        [self.socket close];
        self.socket=nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.types = [[NSMutableDictionary alloc] initWithCapacity:1];
    self.flags = [[NSMutableDictionary alloc] initWithCapacity:1];
    self.addresses = [[NSMutableDictionary alloc] initWithCapacity:1];
    [self initComponent];
	// Do any additional setup after loading the view.
    
    [self initFooterView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#define ANIM_VIEW_WIDTH_AND_HEIGHT 150
#define ITEM_HEIGHT 78
#define PROGRESS_WIDTH_HEIGHT 32
-(void)initComponent{

    [self.view setBackgroundColor:XBgColor];
    CGRect rect = [AppDelegate getScreenSize:YES isHorizontal:NO];
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    TopBar *topBar = [[TopBar alloc] initWithFrame:CGRectMake(0, 0, width, NAVIGATION_BAR_HEIGHT)];
    [topBar setTitle:NSLocalizedString(@"search_local_area",nil)];
    [topBar setBackButtonHidden:NO];
    [topBar.backButton addTarget:self action:@selector(onBackPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:topBar];
    [topBar release];
    
    NSArray *imagesArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"shake1.png"],[UIImage imageNamed:@"shake2.png"],[UIImage imageNamed:@"shake3.png"],[UIImage imageNamed:@"shake4.png"],[UIImage imageNamed:@"shake5.png"],[UIImage imageNamed:@"shake4.png"],[UIImage imageNamed:@"shake3.png"],[UIImage imageNamed:@"shake2.png"],[UIImage imageNamed:@"shake1.png"],[UIImage imageNamed:@"shake2.png"],[UIImage imageNamed:@"shake3.png"],[UIImage imageNamed:@"shake4.png"],[UIImage imageNamed:@"shake5.png"],[UIImage imageNamed:@"shake4.png"],[UIImage imageNamed:@"shake3.png"],[UIImage imageNamed:@"shake2.png"],[UIImage imageNamed:@"shake1.png"],[UIImage imageNamed:@"shake2.png"],[UIImage imageNamed:@"shake3.png"],[UIImage imageNamed:@"shake4.png"],[UIImage imageNamed:@"shake5.png"],[UIImage imageNamed:@"shake4.png"],[UIImage imageNamed:@"shake3.png"],[UIImage imageNamed:@"shake2.png"],[UIImage imageNamed:@"shake1.png"],nil];
    UIImageView *animView = [[UIImageView alloc] initWithFrame:CGRectMake((width-ANIM_VIEW_WIDTH_AND_HEIGHT)/2, NAVIGATION_BAR_HEIGHT, ANIM_VIEW_WIDTH_AND_HEIGHT, ANIM_VIEW_WIDTH_AND_HEIGHT)];
    animView.animationImages = imagesArray;
    animView.animationDuration = ((CGFloat)[imagesArray count])*80.0f/1000.0f;;
    animView.animationRepeatCount = 1;
    animView.image = [UIImage imageNamed:@"shake1.png"];
    [self.view addSubview:animView];
    self.animView = animView;
    [animView release];
    [self.animView setHidden:YES];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, width, height-NAVIGATION_BAR_HEIGHT) style:UITableViewStyleGrouped];
    [tableView setBackgroundColor:XBGAlpha];
    tableView.backgroundView = nil;
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [tableView release];
    
    
    
    //ToastView
    CGFloat textWidth = [Utils getStringWidthWithString:NSLocalizedString(@"searching_device_in_local", nil) font:XFontBold_14 maxWidth:width-80];
    CGFloat textHeight = [Utils getStringHeightWithString:NSLocalizedString(@"searching_device_in_local", nil) font:XFontBold_14 maxWidth:width-80];
    DLog(@"%f:%f",textWidth,textHeight);
    UIView *toastView = [[UIView alloc] initWithFrame:CGRectMake((width-textWidth-PROGRESS_WIDTH_HEIGHT)/2-30, height-textHeight-80, textWidth+PROGRESS_WIDTH_HEIGHT+30*2, textHeight+40)];
    
   
    UIImageView *toastImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, toastView.frame.size.width, toastView.frame.size.height)];
    UIImage *toastImage = [UIImage imageNamed:@"bg_toast.png"];
    toastImage = [toastImage stretchableImageWithLeftCapWidth:toastImage.size.width*0.5 topCapHeight:toastImage.size.height*0.5];
    toastImageView.image = toastImage;
    [toastView addSubview:toastImageView];
    
    UIActivityIndicatorView *toastProgress = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    toastProgress.frame = CGRectMake(20, (toastImageView.frame.size.height-PROGRESS_WIDTH_HEIGHT)/2, PROGRESS_WIDTH_HEIGHT, PROGRESS_WIDTH_HEIGHT);
    [toastImageView addSubview:toastProgress];
    [toastProgress startAnimating];
    
    [toastProgress release];
    
    UILabel *toastLabel = [[UILabel alloc] initWithFrame:CGRectMake(30+PROGRESS_WIDTH_HEIGHT, (toastImageView.frame.size.height-textHeight)/2, textWidth, textHeight)];
    toastLabel.textAlignment = NSTextAlignmentLeft;
    toastLabel.textColor = XWhite;
    toastLabel.font = XFontBold_14;
    toastLabel.backgroundColor = XBGAlpha;
    toastLabel.text = NSLocalizedString(@"searching_device_in_local", nil);
    toastLabel.lineBreakMode = NSLineBreakByWordWrapping;
    toastLabel.numberOfLines = 0;
    [toastImageView addSubview:toastLabel];
    [toastLabel release];
    
    [toastImageView release];
    [toastView setHidden:YES];
    [self.view addSubview:toastView];
    self.toastView = toastView;
    
    [self.toastView release];
    
    
    self.progressAlert = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
    
    [self.view addSubview:self.progressAlert];
    
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
    
    
    
}

-(void)onBackPress{
    [self.navigationController popViewControllerAnimated:YES];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    @synchronized(self){
        return [[self.types allKeys] count];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return ITEM_HEIGHT;
    
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    @synchronized(self){
        static NSString *identifier1 = @"ShakeCell";
        
        CGRect rect = [AppDelegate getScreenSize:YES isHorizontal:NO];
        ShakeCell *cell = nil;
        
        cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if(cell==nil){
            cell = [[[ShakeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1] autorelease];
            [cell setBackgroundColor:XBGAlpha];
        }
        
        
        cell.delegate = self;
        NSString *contactId = [[self.types allKeys] objectAtIndex:indexPath.section];
        
        int type = [[self.types objectForKey:contactId] intValue];
        int flag = [[self.flags objectForKey:contactId] intValue];
        NSString *address = [self.addresses objectForKey:contactId];

        [cell setContactId:contactId];
        [cell setAddress:address];
        [cell setContactFlag:flag];
        [cell setContactType:type];
        [cell setLabelText:contactId];
        switch(type){
            case CONTACT_TYPE_NPC:
            {
                [cell setTypeIcon:@"ic_contact_type_npc.png"];
            }
                break;
            case CONTACT_TYPE_IPC:
            {
                [cell setTypeIcon:@"ic_contact_type_ipc.png"];
            }
                break;
            case CONTACT_TYPE_DOORBELL:
            {
                [cell setTypeIcon:@"ic_contact_type_doorbell.png"];
            }
                break;
            default:{
                [cell setTypeIcon:@"ic_contact_type_unknown.png"];
            }
        }
        ContactDAO *contactDAO = [[ContactDAO alloc] init];
        Contact *contact = [contactDAO isContact:contactId];
        [contactDAO release];
        if(contact!=nil&&flag==1){
            [cell setRightIcon:@"ic_shake_monitor_blue.png"];
        }else{
            [cell setRightIcon:@"ic_shake_add_blue.png"];
        }
        
        
        UIImageView *backImageView = [[UIImageView alloc] init];
        UIImageView *backImageView_p = [[UIImageView alloc] init];
        backImageView.backgroundColor = XBGAlpha;
        backImageView_p.backgroundColor = XBGAlpha;
        
        [cell setBackgroundView:backImageView];
        
        [cell setSelectedBackgroundView:backImageView_p];
        
        [backImageView release];
        [backImageView_p release];
        
        
        
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

-(void)onShakeCellPress:(ShakeCell *)shakeCell contactId:(NSString *)contactId contactType:(NSInteger)contactType contactFlag:(NSInteger)contactFlag address:(NSString *)address{
    ContactDAO *contactDAO = [[ContactDAO alloc] init];
    Contact *contact = [contactDAO isContact:contactId];
    [contactDAO release];
    if(contact!=nil&&contactFlag==1){
        self.isNotNeedReloadData = YES;
        MainController *mainController = [AppDelegate sharedDefault].mainController;
        mainController.contactName = contact.contactName;
        [mainController setUpCallWithId:contactId address:address password:contact.contactPassword callType:P2PCALL_TYPE_MONITOR];
//        [mainController setUpCallWithId:contactId password:contact.contactPassword callType:P2PCALL_TYPE_MONITOR];
    }else if(contact==nil&&contactFlag==1){
        self.isNotNeedReloadData = YES;
        AddContactNextController *addContactNextController = [[AddContactNextController alloc] init];
        [addContactNextController setContactId:contactId];
        [self.navigationController pushViewController:addContactNextController animated:YES];
        [addContactNextController release];
        
    }else if(contact==nil&&contactFlag==0){
        self.isNotNeedReloadData = YES;
        CreateInitPasswordController *createInitPasswordController = [[CreateInitPasswordController alloc] init];
        [createInitPasswordController setContactId:contactId];
        [createInitPasswordController setAddress:address];
        [self.navigationController pushViewController:createInitPasswordController animated:YES];
        [createInitPasswordController release];
    }else if(contact!=nil&&contactFlag==0){
        self.isNotNeedReloadData = YES;
        CreateInitPasswordController *createInitPasswordController = [[CreateInitPasswordController alloc] init];
        [createInitPasswordController setContactId:contactId];
        [createInitPasswordController setAddress:address];
        [self.navigationController pushViewController:createInitPasswordController animated:YES];
        [createInitPasswordController release];
    }

}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    DLog(@"motionBegan");
    
    if(!self.isSearching){
        [self.animView startAnimating];
        [self.types removeAllObjects];
        [self.flags removeAllObjects];
        [self.tableView reloadData];
        
        
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            sleep(2.0);
            
            self.tableView.scrollEnabled = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.toastView.transform = CGAffineTransformMakeScale(0.1, 0.1);
                [self.toastView setHidden:NO];
                [UIView transitionWithView:self.toastView duration:0.2 options:UIViewAnimationCurveEaseInOut
                                animations:^{
                                    self.toastView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                }
                                completion:^(BOOL finished) {
                                    self.isSearching = YES;
                                }
                 ];
            });
            self.tableView.scrollEnabled = YES;
            sleep(10.0);
            self.isSearching = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [UIView transitionWithView:self.toastView duration:0.2 options:UIViewAnimationCurveEaseInOut
                                animations:^{
                                    self.toastView.transform = CGAffineTransformMakeScale(0.1, 0.1);
                                }
                                completion:^(BOOL finished) {
                                    [self.toastView setHidden:YES];
                                }
                 ];
            });
            DLog(@"Search End");
        });
    }
    
}

-(void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    DLog(@"motionCancelled");
}


-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    DLog(@"motionEnded");
}


- (void)sendUDPBroadcast
{
    
    NSString *host = @"255.255.255.255";
    int port = 8899;
    
    sMesgShakeType message;
    message.dwCmd = LAN_TRANS_SHAKE_GET;
    message.dwStructSize = 28;
    message.dwStrCon = 0;
    
    Byte sendBuffer[1024];
    memset(sendBuffer, 0, 1024);
    sendBuffer[0] = 1;
    
    NSData *myData = [NSData dataWithBytes:sendBuffer length:1024];
    [self.socket sendData:myData toHost:host port:port withTimeout:-1 tag:0];
}


- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    NSLog(@"did send");
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error
{
    NSLog(@"error %@", error);
}


- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext
{
    
    @synchronized(self){
        if (data) {
            Byte receiveBuffer[1024];
            [data getBytes:receiveBuffer length:1024];
            
            if(receiveBuffer[0]==2){
                NSString *host = nil;
                uint16_t port = 0;
                [GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
                
                int contactId = *(int*)(&receiveBuffer[16]);
                int type = *(int*)(&receiveBuffer[20]);
                int flag = *(int*)(&receiveBuffer[24]);
                DLog(@"%i:%i:%i",contactId,type,flag);
                [self.types setObject:[NSNumber numberWithInt:type] forKey:[NSString stringWithFormat:@"%i",contactId]];
                [self.flags setObject:[NSNumber numberWithInt:flag] forKey:[NSString stringWithFormat:@"%i",contactId]];
                [self.addresses setObject:host forKey:[NSString stringWithFormat:@"%i",contactId]];

                DLog(@"size:%i",[[self.types allKeys] count]);
                
            }
                
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}

-(BOOL)shouldAutorotate{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interface {
    return (interface == UIInterfaceOrientationPortrait );
}

- (void)loadNewData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1.0);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //                                if(self.contact.onLineState==STATE_ONLINE){
            //
            //                                    //获取报警记录信息(app->设备)
            //                                    [[P2PClient sharedClient] getAlarmInfoWithId:self.contact.contactId password:self.contact.contactPassword];
            //                                }else{
            //                                    //设备离线，不获取
            //                                }
            //                for (int i=0; i<[[[FListManager sharedFList] getContacts] count]; i++) {
            //                    Contact *contact = [[[FListManager sharedFList] getContacts] objectAtIndex:i];
            //
            //                    if(contact.onLineState==STATE_ONLINE){
            //
            //                        //获取报警记录信息(app->设备)
            //                        [[P2PClient sharedClient] getAlarmInfoWithId:contact.contactId password:contact.contactPassword];
            //                    }else{
            //                        //设备离线，不获取
            //                        [self.progressAlert hide:YES];
            //                        //        [self.view makeToast:NSLocalizedString(@"modify_failure", nil)];
            //                    }
            //
            //
            //                }
            
            [self.tableView.mj_header endRefreshing];
        });
    });
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
