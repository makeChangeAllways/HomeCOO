//
//  ContactController.m
//  2cu
//
//  Created by guojunyi on 14-3-21.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import "ContactController.h"
#import "NetManager.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "TopBar.h"
#import "BottomBar.h"
//#import "SVPullToRefresh.h"
#import "ContactCell.h"
#import "AddContactController.h"
#import "AddContactNextController.h"
#import "ContactDAO.h"
#import "Contact.h"
#import "FListManager.h"
#import "GlobalThread.h"
#import "MainSettingController.h"
#import "P2PPlaybackController.h"
#import "ChatController.h"
#import "LocalDeviceListController.h"
#import "TempContactCell.h"
#import "CreateInitPasswordController.h"
#import "MainAddContactController.h"
#import "LocalDevice.h"
#import "Toast+UIView.h"
#import "DiscoverController.h"
#import "SmartKeyController.h"
#import "QRCodeController.h"
#import "QRViewController.h"
#import "DeviceAlarm.h"
#import "MJRefresh.h"
#import "SingleSecurityViewController.h"
#import "DeviceAlarmInfoController.h"
#import "AlarmDAO.h"
@interface ContactController ()

@property(nonatomic,strong)NSMutableArray *bindIds;


@end

@implementation ContactController

-(void)dealloc{
//    [self.contacts release];
//    [self.selectedContact release];
//    [self.tableView release];
//    [self.curDelIndexPath release];
//    [self.netStatusBar release];
//    [self.localDevicesLabel release];
//    [self.localDevicesView release];
//    [self.emptyView release];
//    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DEVICE_BIND_SUCCESS" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RECEIVE_REMOTE_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ACK_RECEIVE_REMOTE_MESSAGE object:nil];
    

}


- (void)setNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRemoteMessage:) name:RECEIVE_REMOTE_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ack_receiveRemoteMessage:) name:ACK_RECEIVE_REMOTE_MESSAGE object:nil];
}


- (void)deviceBindSuccess:(NSNotification *)notify
{
    
    NSDictionary *dic = notify.userInfo;
    Contact *addcont = [dic objectForKey:@"contactName"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_MESSAGE_LIST" object:nil userInfo:dic];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_MEDIA_CONTACT" object:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_RED_POINT" object:nil];
    [[P2PClient sharedClient] getAlarmInfoWithId:addcont.contactId password:addcont.contactPassword];
}


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
    [self setNotification];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceBindSuccess:) name:@"DEVICE_BIND_SUCCESS" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshState) name:@"refreshState" object:nil];
    
    self.contacts = [[NSMutableArray alloc] initWithArray:[[FListManager sharedFList] getContacts]];
    
    NSMutableArray *contactIds = [NSMutableArray arrayWithCapacity:0];
    for(int i=0;i<[self.contacts count];i++){
        
        Contact *contact = [self.contacts objectAtIndex:i];
        [contactIds addObject:contact.contactId];
        
    }
    [[P2PClient sharedClient] getContactsStates:contactIds];
    [[FListManager sharedFList] getDefenceStates];
    [[FListManager sharedFList] searchLocalDevices];
    
    
    [self.tableView reloadData];

    

    
    
    [self initComponent];
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNetWorkChange:) name:NET_WORK_CHANGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopAnimating) name:@"updateContactState" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshContact) name:@"refreshMessage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshLocalDevices) name:@"refreshLocalDevices" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableView) name:@"UPDATE_DEVICE_TABLEVIEW" object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushCreateInitController:) name:@"reset_Device_Notification" object:nil];
    
    if([[AppDelegate sharedDefault] networkStatus]==NotReachable){
        [self.netStatusBar setHidden:NO];
    }else{
        [self.netStatusBar setHidden:YES];
    }
  
    
    if(!self.isInitPull){
        [[GlobalThread sharedThread:NO] start];
        //[[FListManager sharedFList] searchLocalDevices];
        self.isInitPull = !self.isInitPull;
    }
    [[GlobalThread sharedThread:NO] setIsPause:NO];
    [self refreshLocalDevices];
    [self refreshContact];
    
}


-(void)updateTableView
{
    [self.tableView reloadData];
}



- (void)onNetWorkChange:(NSNotification *)notification{

    
    NSDictionary *parameter = [notification userInfo];
    int status = [[parameter valueForKey:@"status"] intValue];
    if(status==NotReachable){
        [self.netStatusBar setHidden:NO];
    }else{
        NSMutableArray *contactIds = [NSMutableArray arrayWithCapacity:0];
        for(int i=0;i<[self.contacts count];i++){
            
            Contact *contact = [self.contacts objectAtIndex:i];
            [contactIds addObject:contact.contactId];
        }
        [[P2PClient sharedClient] getContactsStates:contactIds];
        
        [self.netStatusBar setHidden:YES];
    }
    [self refreshLocalDevices];
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    self.contacts = [[NSMutableArray alloc] initWithArray:[[FListManager sharedFList] getContacts]];
    
    if ([self.contacts count]==0) {
        self.noresult.hidden=NO;
    }else{
        self.noresult.hidden=YES;
    }
    
    
    MainController *mainController = [AppDelegate sharedDefault].mainController;
    [mainController setBottomBarHidden:NO];
    self.addview.hidden=YES;
}


-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NET_WORK_CHANGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateContactState" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshMessage" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshLocalDevices" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reset_Device_Notification" object:nil];
    [[GlobalThread sharedThread:NO] setIsPause:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#define CONTACT_ITEM_HEIGHT (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 120:90)
#define NET_WARNING_ICON_WIDTH_HEIGHT 24
#define LOCAL_DEVICES_VIEW_HEIGHT 52
#define LOCAL_DEVICES_ARROW_WIDTH 24
#define LOCAL_DEVICES_ARROW_HEIGHT 16
#define EMPTY_BUTTON_WIDTH 148
#define EMPTY_BUTTON_HEIGHT 42
#define EMPTY_LABEL_WIDTH 260
#define EMPTY_LABEL_HEIGHT 50
-(void)initComponent{
 
    
    [self.view setBackgroundColor:XBgColor];
    CGRect rect = [AppDelegate getScreenSize:YES isHorizontal:NO];
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height-TAB_BAR_HEIGHT;
    
    
    TopBar *topBar = [[TopBar alloc] initWithFrame:CGRectMake(0, 0, width, NAVIGATION_BAR_HEIGHT)];
    [topBar setTitle:NSLocalizedString(@"contact",nil)];
    [topBar setRightButtonHidden:NO];
//    [topBar setRightButtonIcon:[UIImage imageNamed:@"ic_bar_btn_add_contact.png"]];
    [topBar setRightButtonIcon:[UIImage imageNamed:@"add"]];
    [topBar.rightButton addTarget:self action:@selector(onAddPress) forControlEvents:UIControlEventTouchUpInside];
    [topBar  setBackButtonHidden:NO];
    [topBar.backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.view addSubview:topBar];
    [topBar release];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, width, height-NAVIGATION_BAR_HEIGHT) style:UITableViewStylePlain];
    [tableView setBackgroundColor:XBgColor];
    
    UIView *footView = [[UIView alloc] init];
    [footView setBackgroundColor:[UIColor clearColor]];
    [tableView setTableFooterView:footView];
    [footView release];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    if(CURRENT_VERSION>=7.0){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
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

    
    
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [tableView release];
    
    
    UIView *netStatusBar = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, width, 49)];
    netStatusBar.backgroundColor = [UIColor yellowColor];
    UIImageView *barLeftIconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (netStatusBar.frame.size.height-NET_WARNING_ICON_WIDTH_HEIGHT)/2, NET_WARNING_ICON_WIDTH_HEIGHT, NET_WARNING_ICON_WIDTH_HEIGHT)];
    barLeftIconView.image = [UIImage imageNamed:@"ic_net_warning.png"];
    [netStatusBar addSubview:barLeftIconView];
    
    UILabel *barLabel = [[UILabel alloc] initWithFrame:CGRectMake(barLeftIconView.frame.origin.x+barLeftIconView.frame.size.width+10, 0, netStatusBar.frame.size.width-(barLeftIconView.frame.origin.x+barLeftIconView.frame.size.width)-10, netStatusBar.frame.size.height)];
    barLabel.textAlignment = NSTextAlignmentLeft;
    barLabel.textColor = [UIColor redColor];
    barLabel.backgroundColor = XBGAlpha;
    barLabel.font = XFontBold_16;
    barLabel.lineBreakMode = NSLineBreakByWordWrapping;
    barLabel.numberOfLines = 0;
    barLabel.text = NSLocalizedString(@"net_warning_prompt", nil);
    [netStatusBar addSubview:barLabel];
    
    [barLabel release];
    [barLeftIconView release];
    
    
    
    if([[AppDelegate sharedDefault] networkStatus]==NotReachable){
        [netStatusBar setHidden:NO];
    }else{
        [netStatusBar setHidden:YES];
    }
    
    self.netStatusBar = netStatusBar;
    
    [self.view addSubview:netStatusBar];
    [netStatusBar release];
    
    UIButton *localDevicesView = [UIButton buttonWithType:UIButtonTypeCustom];
    [localDevicesView addTarget:self action:@selector(onLocalButtonPress) forControlEvents:UIControlEventTouchUpInside];
    
    localDevicesView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, width, LOCAL_DEVICES_VIEW_HEIGHT);
    localDevicesView.backgroundColor = UIColorFromRGBA(0x5ab8ffff);
    [self.view addSubview:localDevicesView];
    self.localDevicesView = localDevicesView;
    
    UILabel *localDevicesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, localDevicesView.frame.size.width, localDevicesView.frame.size.height)];
    localDevicesLabel.backgroundColor = [UIColor clearColor];
    localDevicesLabel.textAlignment = NSTextAlignmentCenter;
    localDevicesLabel.textColor = XWhite;
    localDevicesLabel.font = XFontBold_16;
    [localDevicesView addSubview:localDevicesLabel];
    self.localDevicesLabel = localDevicesLabel;
    
    UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(localDevicesLabel.frame.size.width-LOCAL_DEVICES_ARROW_WIDTH, (localDevicesLabel.frame.size.height-LOCAL_DEVICES_ARROW_HEIGHT)/2, LOCAL_DEVICES_ARROW_WIDTH, LOCAL_DEVICES_ARROW_HEIGHT)];
    arrowView.image = [UIImage imageNamed:@"ic_local_devices_arrow.png"];
    [localDevicesLabel addSubview:arrowView];
    [arrowView release];
    [localDevicesLabel release];
    [localDevicesView setHidden:YES];
    [localDevicesView release];
    
    
    UIView *emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height)];
    
    UIButton *emptyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [emptyButton addTarget:self action:@selector(onAddPress) forControlEvents:UIControlEventTouchUpInside];
    emptyButton.frame = CGRectMake((emptyView.frame.size.width-EMPTY_BUTTON_WIDTH)/2, (emptyView.frame.size.height-EMPTY_BUTTON_HEIGHT)/2, EMPTY_BUTTON_WIDTH, EMPTY_BUTTON_HEIGHT);
    UIImage *emptyButtonImage = [UIImage imageNamed:@"bg_blue_button.png"];
    UIImage *emptyButtonImage_p = [UIImage imageNamed:@"bg_blue_button_p.png"];
    emptyButtonImage = [emptyButtonImage stretchableImageWithLeftCapWidth:emptyButtonImage.size.width*0.5 topCapHeight:emptyButtonImage.size.height*0.5];
    emptyButtonImage_p = [emptyButtonImage_p stretchableImageWithLeftCapWidth:emptyButtonImage_p.size.width*0.5 topCapHeight:emptyButtonImage_p.size.height*0.5];
    [emptyButton setBackgroundImage:emptyButtonImage forState:UIControlStateNormal];
    [emptyButton setBackgroundImage:emptyButtonImage_p forState:UIControlStateHighlighted];
    [emptyButton setTitle:NSLocalizedString(@"add_device", nil) forState:UIControlStateNormal];
    [emptyView addSubview:emptyButton];
    
    [self.tableView addSubview:emptyView];
    self.emptyView = emptyView;
    [emptyView release];
    [self.emptyView setHidden:YES];
    
    
    
    UILabel *emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.emptyView.frame.size.width-EMPTY_LABEL_WIDTH)/2, emptyButton.frame.origin.y-EMPTY_LABEL_HEIGHT, EMPTY_LABEL_WIDTH, EMPTY_LABEL_HEIGHT)];
    emptyLabel.backgroundColor = [UIColor clearColor];
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    emptyLabel.textColor = [UIColor redColor];
    emptyLabel.numberOfLines = 0;
    emptyLabel.lineBreakMode = NSLineBreakByCharWrapping;
    emptyLabel.font = XFontBold_16;
    emptyLabel.text = NSLocalizedString(@"empty_contact_prompt", nil);
    [self.emptyView addSubview:emptyLabel];
    [emptyLabel release];
    
    
    
    self.addview = [[UIView alloc] initWithFrame:CGRectMake(XForView(topBar.rightButton)-50, BottomForView(topBar.rightButton), width-XForView(topBar.rightButton)+45, 105)];
    self.addview.backgroundColor=[UIColor whiteColor];
    self.addview.alpha=0.8;
    
    UIImageView *imgview1 = [[UIImageView alloc] init];
    imgview1.image = [UIImage imageNamed:@"equipment_smart"];
    [self.addview addSubview:imgview1];
    imgview1.frame=CGRectMake(10, (HeightForView(self.addview)/3-15)/2,15,15);
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn3 addTarget:self action:@selector(btn3act) forControlEvents:UIControlEventTouchUpInside];
    btn3.frame = CGRectMake(RightForView(imgview1)+5,0,WidthForView(self.addview),HeightForView(self.addview)/3);
    [btn3 setTitle:NSLocalizedString(@"add_tab_title00", nil) forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn3.titleLabel.font=[UIFont systemFontOfSize:15];
    [btn3 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.addview addSubview:btn3];
    
    UIImageView *imgview2 = [[UIImageView alloc] init];
    imgview2.image = [UIImage imageNamed:@"equipment_write"];
    [self.addview addSubview:imgview2];
    imgview2.frame=CGRectMake(10, (HeightForView(self.addview)/3-15)/2+BottomForView(btn3),15,15);

    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 addTarget:self action:@selector(btn1act) forControlEvents:UIControlEventTouchUpInside];
    btn1.frame = CGRectMake(XForView(btn3),BottomForView(btn3),WidthForView(self.addview),HeightForView(btn3));
   [btn1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btn1 setTitle:NSLocalizedString(@"manually_add", nil) forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn1.titleLabel.font=[UIFont systemFontOfSize:15];
    [self.addview addSubview:btn1];
    
    
    UIImageView *imgview3 = [[UIImageView alloc] init];
    imgview3.image = [UIImage imageNamed:@"equipment_net"];
    [self.addview addSubview:imgview3];
    imgview3.frame=CGRectMake(10, (HeightForView(self.addview)/3-15)/2+BottomForView(btn1),15,15);

    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 addTarget:self action:@selector(btn2act) forControlEvents:UIControlEventTouchUpInside];
    btn2.frame = CGRectMake(XForView(btn3),BottomForView(btn1),WidthForView(self.addview),HeightForView(btn3));
    [btn2 setTitle:NSLocalizedString(@"search_local_area", nil) forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn2.titleLabel.font=[UIFont systemFontOfSize:15];
    [btn2 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.addview addSubview:btn2];
    
    [self.view addSubview:self.addview];
    [self.addview setHidden:YES];
    
    
    UIImageView*imageview=[[UIImageView alloc]init];
    [self.tableView addSubview:imageview];
//    self.tableView.backgroundColor = [UIColor redColor];
//    imageview.backgroundColor = [UIColor blueColor];
    CGFloat h = (((VIEWWIDTH-60)/3)/131)*253;
    imageview.frame=CGRectMake(30, 0, VIEWWIDTH-60, h);
    //    imageview.backgroundColor=[UIColor redColor];
    imageview.hidden=YES;
    
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if (IOS8_OR_LATER) {
        if ([currentLanguage containsString:@"zh-Hans"]) {
            imageview.image = [UIImage imageNamed:@"contact_nocontact_ch3"];
        }else if ([currentLanguage containsString:@"en"]) { // 英文
            imageview.image = [UIImage imageNamed:@"contact_nocontact_eng2"];
        }else
        {
            imageview.image = [UIImage imageNamed:@"contact_nocontact_fanti2"];
        }
    }else
    {
        if ([currentLanguage isEqualToString:@"zh-Hans"]) {
            imageview.image = [UIImage imageNamed:@"contact_nocontact_ch3"];
        }else if ([currentLanguage isEqualToString:@"en"]) { // 英文
            imageview.image = [UIImage imageNamed:@"contact_nocontact_eng2"];
        }else
        {
            imageview.image = [UIImage imageNamed:@"contact_nocontact_fanti2"];
        }
    }
    
    
    
    self.noresult=imageview;
    if ([self.contacts count]==0) {
        self.noresult.hidden=NO;
    }else{
        self.noresult.hidden=YES;
    }


}
-(void)backAction{

//    SingleSecurityViewController *backVc = [[SingleSecurityViewController alloc]init];
//    [self  presentViewController:backVc animated:YES completion:nil];
//    
    [self  dismissViewControllerAnimated:YES completion:nil];


}
-(void)btn1act{
    
    AddContactController *addContactController = [[AddContactController alloc] init];
    [self.navigationController pushViewController:addContactController animated:YES];

}
-(void)btn2act{
    DiscoverController *discoverController = [[DiscoverController alloc]init];
    [self.navigationController pushViewController:discoverController animated:YES];
}
-(void)btn3act{
//    SmartKeyController *smartKeyController = [[SmartKeyController alloc] init];
//    [self.navigationController pushViewController:smartKeyController animated:YES];
    
    QRViewController *qecodeController = [[QRViewController alloc] init];
    [self.navigationController pushViewController:qecodeController animated:YES];
}
-(void)refreshContact{
    self.contacts = [[NSMutableArray alloc] initWithArray:[[FListManager sharedFList] getContacts]];
    if ([self.contacts count]==0) {
        self.noresult.hidden=NO;
    }else{
        self.noresult.hidden=YES;
    }
    
    if(self.tableView){
        [self.tableView reloadData];
    }
}


-(void)refreshLocalDevices{
    CGRect rect = [AppDelegate getScreenSize:YES isHorizontal:NO];
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height-TAB_BAR_HEIGHT;
    
    NSArray *array = [[NSArray alloc] initWithArray:[[FListManager sharedFList] getSetedPasswordLocalDevices]];
    dispatch_async(dispatch_get_main_queue(), ^{
        if([array count]>0){
            UILabel *localDevicesLabel = [[self.localDevicesView subviews] objectAtIndex:0];
            localDevicesLabel.text = [NSString stringWithFormat:@"%@ %i %@",NSLocalizedString(@"discovered", nil),[array count],NSLocalizedString(@"new_device", nil)];
            if([self.netStatusBar isHidden]){
                self.localDevicesView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, width, LOCAL_DEVICES_VIEW_HEIGHT);
                self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT+LOCAL_DEVICES_VIEW_HEIGHT, width, height-NAVIGATION_BAR_HEIGHT-LOCAL_DEVICES_VIEW_HEIGHT);
                self.tableViewOffset = self.localDevicesLabel.frame.size.height;
            }else{
                self.localDevicesView.frame = CGRectMake(0, self.netStatusBar.frame.origin.y+self.netStatusBar.frame.size.height, width, LOCAL_DEVICES_VIEW_HEIGHT);
                
                self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT+self.netStatusBar.frame.size.height+self.localDevicesView.frame.size.height, width, height-NAVIGATION_BAR_HEIGHT-self.netStatusBar.frame.size.height-self.localDevicesView.frame.size.height);
                self.tableViewOffset = self.netStatusBar.frame.size.height+self.netStatusBar.frame.size.height;
            }
            
            [self.localDevicesView setHidden:NO];
            
        }else{
            if([self.netStatusBar isHidden]){
                self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, width, height-NAVIGATION_BAR_HEIGHT);
                self.tableViewOffset = 0;
            }else{
                self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT+self.netStatusBar.frame.size.height, width, height-NAVIGATION_BAR_HEIGHT-self.netStatusBar.frame.size.height);
                self.tableViewOffset = self.netStatusBar.frame.size.height;
            }
            [self.localDevicesView setHidden:YES];
        }
    });
    
    self.localDevices = [[NSMutableArray alloc] initWithArray:[[FListManager sharedFList] getLocalDevices]];
//    NSLog(@"%@",self.localDevices);
    /*
    if (self.contacts.count) {
     
    }else
    {
        self.localDevices = [NSMutableArray array];
    }
     */
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    /* 未知物体
//    if(self.localDevices&&[self.localDevices count]>0){
//        [self.emptyView setHidden:YES];
//        [self.tableView setScrollEnabled:YES];
//        return 2;
//    }else{
//        return 1;
//    }
     
     */
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    /* 未知物体
    if(section==0){
//        if([self.contacts count]<=0){
//            if(self.localDevices&&[self.localDevices count]>0){
//                [self.emptyView setHidden:YES];
//                [self.tableView setScrollEnabled:YES];
//            }else{
//                [self.emptyView setHidden:NO];
//                [self.tableView setScrollEnabled:YES];
//            }
//            
//        }else{
//            [self.emptyView setHidden:YES];
//            [self.tableView setScrollEnabled:YES];
//        }
        return [self.contacts count];
    }else if(section==1){
        if(self.localDevices&&[self.localDevices count]>0){
            [self.emptyView setHidden:YES];
            [self.tableView setScrollEnabled:YES];
            return [self.localDevices count];
        }else{
            return 0;
        }
    }else{
        return 0;
    }
     */
    return self.contacts.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return CONTACT_ITEM_HEIGHT;
    return 225;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier1 = @"ContactCell1";
    ContactCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if(cell==nil){
            cell = [[ContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            
            UILabel*label=[[UILabel alloc]init];
            [cell.contentView addSubview:label];
            label.tag=555;
            
            UIButton*buttonset=[[UIButton alloc]init];
            [cell addSubview:buttonset];
            buttonset.tag=1011;
            
            UIView*celltopview=[[UIView alloc]init];
            [cell.contentView addSubview:celltopview];
            celltopview.tag=56;
            
            UIView*line=[[UIView alloc]init];
            [cell.contentView addSubview:line];
            line.tag=57;
            
            UIImageView*edit=[[UIImageView alloc]init];
            [cell.contentView addSubview:edit];
            edit.tag=58;
            
            UIButton*editbtn=[[UIButton alloc]init];
            [cell.contentView addSubview:editbtn];
            editbtn.tag=59;
            
            
            UIButton*button=[[UIButton alloc]init];
            [cell.contentView addSubview:button];
            button.tag=556;
            
            UIImageView *red_btn = [[UIImageView alloc] init];
            [cell.contentView addSubview:red_btn];
            red_btn.tag = 28;
            
            
            UIImageView *arrow = [[UIImageView alloc] init];
            [cell.contentView addSubview:arrow];
            arrow.tag = 29;
            
            UIButton *cover_btn = [[UIButton alloc] init];
            cover_btn.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:cover_btn];
            cover_btn.tag = 30;
            

            // 转动的图片
            UIImageView *backImageView = [[UIImageView alloc] init];
            UIImageView *backImageView_p = [[UIImageView alloc] init];
            [cell.contentView addSubview:backImageView];
            [cell.contentView addSubview:backImageView_p];
            backImageView.tag = 718;
            backImageView_p.tag = 719;
            
        }
        if (self.contacts.count) {
            Contact *contact = [self.contacts objectAtIndex:indexPath.row];
            
            ContactCell *contactCell = (ContactCell*)cell;
            contactCell.delegate = self;
            [contactCell setPosition:indexPath.row];
            [contactCell setContact:contact];
            self.selectedContact = contact;
        }
        
        
        cell.settingblock = ^{
            Contact *contact = [self.contacts objectAtIndex:indexPath.row];
            MainSettingController *mainSettingController = [[MainSettingController alloc] init];
            mainSettingController.contact = contact;
            [self.navigationController pushViewController:mainSettingController animated:YES];
            [mainSettingController release];
            
        };
       
    // 不知道什么东西
    UIImage *backImg = [UIImage imageNamed:@""];
    UIImage *backImg_p = [UIImage imageNamed:@""];
    UIImageView *backImageView = (UIImageView *)[cell viewWithTag:718];
    UIImageView *backImageView_p = (UIImageView *)[cell viewWithTag:719];
    backImg = [backImg stretchableImageWithLeftCapWidth:backImg.size.width*0.5 topCapHeight:backImg.size.height*0.5];
    backImageView.image = backImg;
    backImg_p = [backImg_p stretchableImageWithLeftCapWidth:backImg_p.size.width*0.5 topCapHeight:backImg_p.size.height*0.5];
    backImageView_p.image = backImg_p;
    [cell setBackgroundView:backImageView];
    [cell setSelectedBackgroundView:backImageView_p];
    
    // 重置
    Contact *contact = [self.contacts objectAtIndex:indexPath.row];
    LocalDevice *locaDevice = nil;
    for (LocalDevice *loc in self.localDevices) {
        if ([loc.contactId isEqualToString:contact.contactId]) {
            locaDevice = loc;
        }
    }
    if (locaDevice != nil) {
        cell.loc = locaDevice;
    }else
    {
        cell.loc = nil;
    }
    
    // 重置回调
    cell.resetBlock = ^(LocalDevice *loc){
         self.loc = loc;
        if (loc) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"重置密码", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"ok", nil), nil];
            alertView.tag = 1;
           
            alertView.delegate = self;
            [alertView show];
        }
    };
    
    
    UIView*topcell=(UIView *)[cell viewWithTag:56];
    topcell.frame = CGRectMake(0, 0, VIEWWIDTH, 10);
    topcell.backgroundColor=[UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0];
    
    UIView*line=(UIView *)[cell viewWithTag:57];
    line.frame = CGRectMake(0, 10, VIEWWIDTH, 0.5);
    line.backgroundColor=[UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1.0];
    
    
    UILabel*contactname=(UILabel *)[cell viewWithTag:555];
    contactname.frame = CGRectMake(45, 11, 200, 29);
    contactname.text=self.selectedContact.contactName;
    contactname.textColor=[UIColor blackColor];
    
    UIImageView*edit=(UIImageView *)[cell viewWithTag:58];
    edit.frame = CGRectMake(10, 15, 20, 20);
    [edit setImage:[UIImage imageNamed:@"system_editor"]];
  
    UIButton*editbtn=(UIButton *)[cell viewWithTag:59];
    editbtn.frame = CGRectMake(10, 15, VIEWWIDTH-100, 20);
    [editbtn wSetEvent:UIControlEventTouchUpInside ControlEventCBK:^(id sender) {
        AddContactNextController *addContactNextController = [[AddContactNextController alloc] init];
        addContactNextController.isModifyContact = YES;
        addContactNextController.contactId = self.selectedContact.contactId;
//        addContactNextController.modifyContact = self.selectedContact;
        addContactNextController.modifyContact = contact;
        [self.navigationController pushViewController:addContactNextController animated:YES];
        
    }];

    
    UIButton*statebtn=(UIButton *)[cell viewWithTag:556];
    statebtn.frame = CGRectMake(VIEWWIDTH-200, 11, 165, 29);
    [statebtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    statebtn.backgroundColor = XBGAlpha;
    [statebtn.titleLabel setFont:XFontBold_14];
    if(contact.onLineState==STATE_ONLINE){
        [statebtn setTitleColor:XBlue forState:UIControlStateNormal];
        [statebtn setTitle:NSLocalizedString(@"online", nil) forState:UIControlStateNormal];
    }else{
        [statebtn setTitleColor:XBlack forState:UIControlStateNormal];
        [statebtn setTitle:NSLocalizedString(@"offline", nil) forState:UIControlStateNormal];
    }
    [statebtn wSetEvent:UIControlEventTouchUpInside ControlEventCBK:^(id sender) {
        if(contact.defenceState==DEFENCE_STATE_NO_PERMISSION){
            [self.view makeToast:NSLocalizedString(@"no_permission", nil)];
            return ;
        }else{
        // 跳转消息界面
        DeviceAlarmInfoController *dev_info = [[DeviceAlarmInfoController alloc] init];
        dev_info.contact = contact;
        
        [self.navigationController pushViewController:dev_info animated:YES];
        }
        
    }];
    
    // 红点
    UIImageView *red_btn = (UIImageView *)[cell viewWithTag:28];
    red_btn.backgroundColor = [UIColor redColor];
    red_btn.frame = CGRectMake(RightForView(statebtn), 22, 8, 8);
    red_btn.layer.cornerRadius = 4;
    red_btn.hidden = YES;
    AlarmDAO *alarmDao = [[AlarmDAO alloc] init];
    NSMutableArray *allarr = [alarmDao findAllWithDeviceID:contact.contactId];
    if (allarr.count) {
        for (Alarm *alarm in allarr) {
            if (alarm.isRead == 0) { // 直到有未读消息
                red_btn.hidden = NO;
                break;
            }
        }
    }
    
    UIImageView *arrow = (UIImageView *)[cell viewWithTag:29];
    arrow.frame = CGRectMake(RightForView(red_btn), 17, 13, 15);
    arrow.image = [UIImage imageNamed:@"system_more"];
    
    UIButton *cover_btn = (UIButton *)[cell viewWithTag:30];
    cover_btn.frame = CGRectMake(RightForView(statebtn), 10, 35, 40);
    [cover_btn wSetEvent:UIControlEventTouchUpInside ControlEventCBK:^(id sender) {
        
        if(contact.defenceState==DEFENCE_STATE_NO_PERMISSION){
            [self.view makeToast:NSLocalizedString(@"no_permission", nil)];
            return ;
        }else{
            // 跳转消息界面
            DeviceAlarmInfoController *dev_info = [[DeviceAlarmInfoController alloc] init];
            dev_info.contact = contact;
            [self.navigationController pushViewController:dev_info animated:YES];
        }
        
    }];
    return cell;
}
-(void)onOperatorItemPress:(UIButton*)btn withEvent:(UIEvent*)event{
    
    //    UITableViewCell *cell  =[[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0?(UITableViewCell *)[[[btn superview] superview]superview]:(UITableViewCell *)[[btn superview] superview];
    //
    //    NSIndexPath *indexPath = [listview indexPathForCell:cell];
    
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: [[[event touchesForView: btn] anyObject] locationInView:self.tableView]];
    
     Contact *contact = [self.contacts objectAtIndex:indexPath.row];
    
    MainSettingController *mainSettingController = [[MainSettingController alloc] init];
    mainSettingController.contact = contact;
    [self.navigationController pushViewController:mainSettingController animated:YES];
    [mainSettingController release];



}


//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if(section==1){
//
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30)];
//        label.backgroundColor = UIColorFromRGB(0xeff0f2);
//        label.textAlignment = NSTextAlignmentCenter;
//        label.textColor = XBlue;
//        label.font = XFontBold_14;
//        label.text = NSLocalizedString(@"no_init_password_device", nil);
//        return label;
//    }else{
//        return nil;
//    }
//}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if(section==1){
//        return 30;
//    }else{
//        return 0;
//    }
//}


#define OPERATOR_ITEM_WIDTH (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 80:55)
#define OPERATOR_ITEM_HEIGHT (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 60:48)
#define OPERATOR_ARROW_WIDTH_AND_HEIGHT (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 20:10)
#define OPERATOR_BAR_OFFSET (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 40:30)

-(UIButton*)getOperatorView:(CGFloat)offset itemCount:(NSInteger)count{
    offset += self.tableViewOffset;
    CGRect rect = [AppDelegate getScreenSize:YES isHorizontal:NO];
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    UIButton *operatorView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, height-TAB_BAR_HEIGHT)];
    operatorView.tag = kOperatorViewTag;
    
    
    
    UIView *barView = [[UIView alloc] init];
    barView.tag = kBarViewTag;
    
    UIImageView *arrowView = [[UIImageView alloc] init];
    UIView *buttonsView = [[UIView alloc] init];
    buttonsView.tag = kButtonsViewTag;
    if((offset>self.tableView.frame.size.height)||((self.tableView.frame.size.height-offset)<CONTACT_ITEM_HEIGHT)){
        barView.frame = CGRectMake((width-OPERATOR_ITEM_WIDTH*count), offset-OPERATOR_BAR_OFFSET, OPERATOR_ITEM_WIDTH*count, OPERATOR_ITEM_HEIGHT+OPERATOR_ARROW_WIDTH_AND_HEIGHT);
        
        arrowView.frame = CGRectMake((OPERATOR_ITEM_WIDTH*count-OPERATOR_ARROW_WIDTH_AND_HEIGHT)/2, OPERATOR_ITEM_HEIGHT, OPERATOR_ARROW_WIDTH_AND_HEIGHT, OPERATOR_ARROW_WIDTH_AND_HEIGHT);
        
        
        buttonsView.frame = CGRectMake(0, 0, OPERATOR_ITEM_WIDTH*count, OPERATOR_ITEM_HEIGHT);
        [arrowView setImage:[UIImage imageNamed:@"bg_operator_bar_arrow_bottom.png"]];
        
    }else{
        barView.frame = CGRectMake((width-OPERATOR_ITEM_WIDTH*count), offset+OPERATOR_BAR_OFFSET, OPERATOR_ITEM_WIDTH*count, OPERATOR_ITEM_HEIGHT+OPERATOR_ARROW_WIDTH_AND_HEIGHT);
        
        
        arrowView.frame = CGRectMake((OPERATOR_ITEM_WIDTH*count-OPERATOR_ARROW_WIDTH_AND_HEIGHT)/2, 0, OPERATOR_ARROW_WIDTH_AND_HEIGHT, OPERATOR_ARROW_WIDTH_AND_HEIGHT);
        
        buttonsView.frame = CGRectMake(0, OPERATOR_ARROW_WIDTH_AND_HEIGHT, OPERATOR_ITEM_WIDTH*count, OPERATOR_ITEM_HEIGHT);
        [arrowView setImage:[UIImage imageNamed:@"bg_operator_bar_arrow_top.png"]];
    }
    
    buttonsView.layer.borderColor = [[UIColor grayColor] CGColor];
    buttonsView.layer.borderWidth = 1;
    buttonsView.layer.cornerRadius = 5;
    [buttonsView.layer setMasksToBounds:YES];
    
    
    
    [barView addSubview:arrowView];
    [barView addSubview:buttonsView];
    [operatorView addSubview:barView];
    [buttonsView release];
    [arrowView release];
    [barView release];
    //[operatorView release];
    return operatorView;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if(indexPath.section==0){
//        ContactCell *cell = (ContactCell*)[tableView cellForRowAtIndexPath:indexPath];
//        Contact *contact = cell.contact;
//        self.selectedContact = contact;
//        CGRect rect = [AppDelegate getScreenSize:YES isHorizontal:NO];
//        CGFloat width = rect.size.width;
//        CGFloat offset = cell.frame.origin.y-tableView.contentOffset.y+CONTACT_ITEM_HEIGHT;
//        int count = 1;
//        switch(contact.contactType){
//            case CONTACT_TYPE_PHONE:
//            {
//                count = 3;
//            }
//                break;
//            case CONTACT_TYPE_NPC:
//            {
//                count = 4;
//            }
//                break;
//            case CONTACT_TYPE_IPC:
//            {
//                count = 3;
//            }
//                break;
//            case CONTACT_TYPE_DOORBELL:
//            {
//                count = 2;
//            }
//                break;
//            default:
//            {
//                if(self.selectedContact.contactId.intValue<=256){
//                    count = 2;
//                }else{
//                    count = 1;
//                }
//            }
//        }
//        
//        
//        UIButton *operatorView = [self getOperatorView:offset itemCount:count];
//        
//        [operatorView addTarget:self action:@selector(onOperatorViewSingleTap) forControlEvents:UIControlEventTouchUpInside];
//        UIView *barView = [operatorView viewWithTag:kBarViewTag];
//        UIView *buttonsView = [barView viewWithTag:kButtonsViewTag];
//        switch(contact.contactType){
//            case CONTACT_TYPE_PHONE:
//            {
//                for(int i=0;i<count;i++){
//                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//                    button.frame = CGRectMake(i*OPERATOR_ITEM_WIDTH, 0, OPERATOR_ITEM_WIDTH, OPERATOR_ITEM_HEIGHT);
//                    [button setBackgroundColor:XBlack_128];
//                    [button setBackgroundImage:[UIImage imageNamed:@"bg_normal_cell_p.png"] forState:UIControlStateHighlighted];
//                    
//                    [button addTarget:self action:@selector(onOperatorItemPress:) forControlEvents:UIControlEventTouchUpInside];
//                    
//                    if(i==0){
//                        button.tag = kOperatorBtnTag_Chat;
//                        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake((button.frame.size.width-button.frame.size.height*4/7)/2, 0, button.frame.size.height*4/7, button.frame.size.height*4/7)];
//                        iconView.image = [UIImage imageNamed:@"ic_operator_item_chat.png"];
//                        [button addSubview:iconView];
//                        [iconView release];
//                        
//                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, button.frame.size.height*4/7, button.frame.size.width, button.frame.size.height*3/7-5)];
//                        label.textAlignment = NSTextAlignmentCenter;
//                        label.textColor = XWhite;
//                        label.backgroundColor = XBGAlpha;
//                        [label setFont:XFontBold_12];
//                        label.text = NSLocalizedString(@"chat", nil);
//                        [button addSubview: label];
//                        [label release];
//                    }else if(i==1){
//                        button.tag = kOperatorBtnTag_Message;
//                        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake((button.frame.size.width-button.frame.size.height*4/7)/2, 0, button.frame.size.height*4/7, button.frame.size.height*4/7)];
//                        iconView.image = [UIImage imageNamed:@"ic_operator_item_message.png"];
//                        [button addSubview:iconView];
//                        [iconView release];
//                        
//                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, button.frame.size.height*4/7, button.frame.size.width, button.frame.size.height*3/7-5)];
//                        label.textAlignment = NSTextAlignmentCenter;
//                        label.textColor = XWhite;
//                        label.backgroundColor = XBGAlpha;
//                        [label setFont:XFontBold_12];
//                        label.text = NSLocalizedString(@"message", nil);
//                        [button addSubview: label];
//                        [label release];
//                    }else if(i==2){
//                        button.tag = kOperatorBtnTag_Modify;
//                        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake((button.frame.size.width-button.frame.size.height*4/7)/2, 0, button.frame.size.height*4/7, button.frame.size.height*4/7)];
//                        iconView.image = [UIImage imageNamed:@"ic_operator_item_modify.png"];
//                        [button addSubview:iconView];
//                        [iconView release];
//                        
//                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, button.frame.size.height*4/7, button.frame.size.width, button.frame.size.height*3/7-5)];
//                        label.textAlignment = NSTextAlignmentCenter;
//                        label.textColor = XWhite;
//                        label.backgroundColor = XBGAlpha;
//                        [label setFont:XFontBold_12];
//                        label.text = NSLocalizedString(@"modify", nil);
//                        [button addSubview: label];
//                        [label release];
//                    }
//                    
//                    
//                    [buttonsView addSubview:button];
//                }
//            }
//                break;
//            case CONTACT_TYPE_NPC:
//            {
//                NSMutableArray * arr = [NSMutableArray arrayWithArray:[[FListManager sharedFList] getUnsetPasswordDevices]];
//                for (LocalDevice *localDevic in arr) {
//                    
//                    if ([localDevic.contactId isEqualToString:self.selectedContact.contactId]) {
//                        CreateInitPasswordController * createInitPwdCtl = [[CreateInitPasswordController alloc] init];
//                        createInitPwdCtl.contactId = self.selectedContact.contactId;
//                        [self.navigationController pushViewController:createInitPwdCtl animated:YES];
//                        [createInitPwdCtl release];
//                        return;
//                    }
//                }
//                for(int i=0;i<count;i++){
//                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//                    button.frame = CGRectMake(i*OPERATOR_ITEM_WIDTH, 0, OPERATOR_ITEM_WIDTH, OPERATOR_ITEM_HEIGHT);
//                    [button setBackgroundColor:XBlack_128];
//                    [button setBackgroundImage:[UIImage imageNamed:@"bg_normal_cell_p.png"] forState:UIControlStateHighlighted];
//                    
//                    [button addTarget:self action:@selector(onOperatorItemPress:) forControlEvents:UIControlEventTouchUpInside];
//                    
//                    /*if(i==0){
//                     button.tag = kOperatorBtnTag_Monitor;
//                     UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake((button.frame.size.width-button.frame.size.height*4/7)/2, 0, button.frame.size.height*4/7, button.frame.size.height*4/7)];
//                     iconView.image = [UIImage imageNamed:@"ic_operator_item_monitor.png"];
//                     [button addSubview:iconView];
//                     [iconView release];
//                     
//                     UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, button.frame.size.height*4/7, button.frame.size.width, button.frame.size.height*3/7-5)];
//                     label.textAlignment = NSTextAlignmentCenter;
//                     label.textColor = XWhite;
//                     label.backgroundColor = XBGAlpha;
//                     [label setFont:XFontBold_12];
//                     label.text = NSLocalizedString(@"monitor", nil);
//                     [button addSubview: label];
//                     [label release];
//                     }else*/ if(i==0){
//                         button.tag = kOperatorBtnTag_Chat;
//                         UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake((button.frame.size.width-button.frame.size.height*4/7)/2, 0, button.frame.size.height*4/7, button.frame.size.height*4/7)];
//                         iconView.image = [UIImage imageNamed:@"ic_operator_item_chat.png"];
//                         [button addSubview:iconView];
//                         [iconView release];
//                         
//                         UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, button.frame.size.height*4/7, button.frame.size.width, button.frame.size.height*3/7-5)];
//                         label.textAlignment = NSTextAlignmentCenter;
//                         label.textColor = XWhite;
//                         label.backgroundColor = XBGAlpha;
//                         [label setFont:XFontBold_12];
//                         label.text = NSLocalizedString(@"chat", nil);
//                         [button addSubview: label];
//                         [label release];
//                     }else if(i==1){
//                         button.tag = kOperatorBtnTag_Playback;
//                         UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake((button.frame.size.width-button.frame.size.height*4/7)/2, 0, button.frame.size.height*4/7, button.frame.size.height*4/7)];
//                         iconView.image = [UIImage imageNamed:@"ic_operator_item_playback.png"];
//                         [button addSubview:iconView];
//                         [iconView release];
//                         
//                         UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, button.frame.size.height*4/7, button.frame.size.width, button.frame.size.height*3/7-5)];
//                         label.textAlignment = NSTextAlignmentCenter;
//                         label.textColor = XWhite;
//                         label.backgroundColor = XBGAlpha;
//                         [label setFont:XFontBold_12];
//                         label.text = NSLocalizedString(@"playback", nil);
//                         [button addSubview: label];
//                         [label release];
//                     }else if(i==2){
//                         button.tag = kOperatorBtnTag_Control;
//                         UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake((button.frame.size.width-button.frame.size.height*4/7)/2, 0, button.frame.size.height*4/7, button.frame.size.height*4/7)];
//                         iconView.image = [UIImage imageNamed:@"ic_operator_item_control.png"];
//                         [button addSubview:iconView];
//                         [iconView release];
//                         
//                         UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, button.frame.size.height*4/7, button.frame.size.width, button.frame.size.height*3/7-5)];
//                         label.textAlignment = NSTextAlignmentCenter;
//                         label.textColor = XWhite;
//                         label.backgroundColor = XBGAlpha;
//                         [label setFont:XFontBold_12];
//                         label.text = NSLocalizedString(@"control", nil);
//                         [button addSubview: label];
//                         [label release];
//                     }else if(i==3){
//                         button.tag = kOperatorBtnTag_Modify;
//                         UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake((button.frame.size.width-button.frame.size.height*4/7)/2, 0, button.frame.size.height*4/7, button.frame.size.height*4/7)];
//                         iconView.image = [UIImage imageNamed:@"ic_operator_item_modify.png"];
//                         [button addSubview:iconView];
//                         [iconView release];
//                         
//                         UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, button.frame.size.height*4/7, button.frame.size.width, button.frame.size.height*3/7-5)];
//                         label.textAlignment = NSTextAlignmentCenter;
//                         label.textColor = XWhite;
//                         label.backgroundColor = XBGAlpha;
//                         [label setFont:XFontBold_12];
//                         label.text = NSLocalizedString(@"modify", nil);
//                         [button addSubview: label];
//                         [label release];
//                     }
//                    
//                    
//                    [buttonsView addSubview:button];
//                }
//            }
//                break;
//            case CONTACT_TYPE_IPC:
//            {
//                NSMutableArray * arr = [NSMutableArray arrayWithArray:[[FListManager sharedFList] getUnsetPasswordDevices]];
//                for (LocalDevice *localDevic in arr) {
//                    
//                    if ([localDevic.contactId isEqualToString:self.selectedContact.contactId]) {
//                        CreateInitPasswordController * createInitPwdCtl = [[CreateInitPasswordController alloc] init];
//                        createInitPwdCtl.contactId = self.selectedContact.contactId;
//                        [self.navigationController pushViewController:createInitPwdCtl animated:YES];
//                        [createInitPwdCtl release];
//                        return;
//                    }
//                }
//                for(int i=0;i<count;i++){
//                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//                    button.frame = CGRectMake(i*OPERATOR_ITEM_WIDTH, 0, OPERATOR_ITEM_WIDTH, OPERATOR_ITEM_HEIGHT);
//                    [button setBackgroundColor:XBlack_128];
//                    [button setBackgroundImage:[UIImage imageNamed:@"bg_normal_cell_p.png"] forState:UIControlStateHighlighted];
//                    
//                    [button addTarget:self action:@selector(onOperatorItemPress:) forControlEvents:UIControlEventTouchUpInside];
//                    
//                    /*if(i==0){
//                     button.tag = kOperatorBtnTag_Monitor;
//                     UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake((button.frame.size.width-button.frame.size.height*4/7)/2, 0, button.frame.size.height*4/7, button.frame.size.height*4/7)];
//                     iconView.image = [UIImage imageNamed:@"ic_operator_item_monitor.png"];
//                     [button addSubview:iconView];
//                     [iconView release];
//                     
//                     UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, button.frame.size.height*4/7, button.frame.size.width, button.frame.size.height*3/7-5)];
//                     label.textAlignment = NSTextAlignmentCenter;
//                     label.textColor = XWhite;
//                     label.backgroundColor = XBGAlpha;
//                     [label setFont:XFontBold_12];
//                     label.text = NSLocalizedString(@"monitor", nil);
//                     [button addSubview: label];
//                     [label release];
//                     }else*/ if(i==0){
//                         button.tag = kOperatorBtnTag_Playback;
//                         UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake((button.frame.size.width-button.frame.size.height*4/7)/2, 0, button.frame.size.height*4/7, button.frame.size.height*4/7)];
//                         iconView.image = [UIImage imageNamed:@"ic_operator_item_playback.png"];
//                         [button addSubview:iconView];
//                         [iconView release];
//                         
//                         UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, button.frame.size.height*4/7, button.frame.size.width, button.frame.size.height*3/7-5)];
//                         label.textAlignment = NSTextAlignmentCenter;
//                         label.textColor = XWhite;
//                         label.backgroundColor = XBGAlpha;
//                         [label setFont:XFontBold_12];
//                         label.text = NSLocalizedString(@"playback", nil);
//                         [button addSubview: label];
//                         [label release];
//                     }else if(i==1){
//                         button.tag = kOperatorBtnTag_Control;
//                         UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake((button.frame.size.width-button.frame.size.height*4/7)/2, 0, button.frame.size.height*4/7, button.frame.size.height*4/7)];
//                         iconView.image = [UIImage imageNamed:@"ic_operator_item_control.png"];
//                         [button addSubview:iconView];
//                         [iconView release];
//                         
//                         UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, button.frame.size.height*4/7, button.frame.size.width, button.frame.size.height*3/7-5)];
//                         label.textAlignment = NSTextAlignmentCenter;
//                         label.textColor = XWhite;
//                         label.backgroundColor = XBGAlpha;
//                         [label setFont:XFontBold_12];
//                         label.text = NSLocalizedString(@"control", nil);
//                         [button addSubview: label];
//                         [label release];
//                     }else if(i==2){
//                         button.tag = kOperatorBtnTag_Modify;
//                         UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake((button.frame.size.width-button.frame.size.height*4/7)/2, 0, button.frame.size.height*4/7, button.frame.size.height*4/7)];
//                         iconView.image = [UIImage imageNamed:@"ic_operator_item_modify.png"];
//                         [button addSubview:iconView];
//                         [iconView release];
//                         
//                         UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, button.frame.size.height*4/7, button.frame.size.width, button.frame.size.height*3/7-5)];
//                         label.textAlignment = NSTextAlignmentCenter;
//                         label.textColor = XWhite;
//                         label.backgroundColor = XBGAlpha;
//                         [label setFont:XFontBold_12];
//                         label.text = NSLocalizedString(@"modify", nil);
//                         [button addSubview: label];
//                         [label release];
//                     }
//                    
//                    
//                    [buttonsView addSubview:button];
//                }
//            }
//                break;
//                
//            default:
//            {
//                for(int i=0;i<count;i++){
//                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//                    button.frame = CGRectMake(i*OPERATOR_ITEM_WIDTH, 0, OPERATOR_ITEM_WIDTH, OPERATOR_ITEM_HEIGHT);
//                    [button setBackgroundColor:XBlack_128];
//                    [button setBackgroundImage:[UIImage imageNamed:@"bg_normal_cell_p.png"] forState:UIControlStateHighlighted];
//                    
//                    [button addTarget:self action:@selector(onOperatorItemPress:) forControlEvents:UIControlEventTouchUpInside];
//                    
//                    if(count==1){
//                        if(i==0){
//                            button.tag = kOperatorBtnTag_Modify;
//                            UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake((button.frame.size.width-button.frame.size.height*4/7)/2, 0, button.frame.size.height*4/7, button.frame.size.height*4/7)];
//                            iconView.image = [UIImage imageNamed:@"ic_operator_item_modify.png"];
//                            [button addSubview:iconView];
//                            [iconView release];
//                            
//                            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, button.frame.size.height*4/7, button.frame.size.width, button.frame.size.height*3/7-5)];
//                            label.textAlignment = NSTextAlignmentCenter;
//                            label.textColor = XWhite;
//                            label.backgroundColor = XBGAlpha;
//                            [label setFont:XFontBold_12];
//                            label.text = NSLocalizedString(@"modify", nil);
//                            [button addSubview: label];
//                            [label release];
//                        }
//                    }else if (count==2){
//                        if(i==0){
//                            button.tag = kOperatorBtnTag_Control;
//                            UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake((button.frame.size.width-button.frame.size.height*4/7)/2, 0, button.frame.size.height*4/7, button.frame.size.height*4/7)];
//                            iconView.image = [UIImage imageNamed:@"ic_operator_item_control.png"];
//                            [button addSubview:iconView];
//                            [iconView release];
//                            
//                            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, button.frame.size.height*4/7, button.frame.size.width, button.frame.size.height*3/7-5)];
//                            label.textAlignment = NSTextAlignmentCenter;
//                            label.textColor = XWhite;
//                            label.backgroundColor = XBGAlpha;
//                            [label setFont:XFontBold_12];
//                            label.text = NSLocalizedString(@"control", nil);
//                            [button addSubview: label];
//                            [label release];
//                        }else if(i==1){
//                            button.tag = kOperatorBtnTag_Modify;
//                            UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake((button.frame.size.width-button.frame.size.height*4/7)/2, 0, button.frame.size.height*4/7, button.frame.size.height*4/7)];
//                            iconView.image = [UIImage imageNamed:@"ic_operator_item_modify.png"];
//                            [button addSubview:iconView];
//                            [iconView release];
//                            
//                            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, button.frame.size.height*4/7, button.frame.size.width, button.frame.size.height*3/7-5)];
//                            label.textAlignment = NSTextAlignmentCenter;
//                            label.textColor = XWhite;
//                            label.backgroundColor = XBGAlpha;
//                            [label setFont:XFontBold_12];
//                            label.text = NSLocalizedString(@"modify", nil);
//                            [button addSubview: label];
//                            [label release];
//                            
//                        }
//                        
//                    }
//                    
//                    [buttonsView addSubview:button];
//                }
//            }
//        }
//        barView.alpha = 0;
//        [UIView transitionWithView:barView duration:0.1 options:UIViewAnimationCurveEaseInOut
//                        animations:^{
//                            
//                            CGAffineTransform transform1 = CGAffineTransformMakeTranslation(-(width-OPERATOR_ITEM_WIDTH*count), 0);
//                            barView.alpha = 0.5;
//                            barView.transform = transform1;
//                        }
//                        completion:^(BOOL finished){
//                            [UIView transitionWithView:barView duration:0.2 options:UIViewAnimationCurveEaseInOut
//                                            animations:^{
//                                                
//                                                
//                                                CGAffineTransform transform2 = CGAffineTransformMakeTranslation(-(width-OPERATOR_ITEM_WIDTH*count)/2, 0);
//                                                barView.transform = transform2;
//                                                barView.alpha = 1;
//                                            }
//                                            completion:^(BOOL finished){
//                                                
//                                            }
//                             ];
//                        }
//         ];
//        [self.view addSubview:operatorView];
//        [operatorView release];
//    }else{
//        LocalDevice *localDevice = [self.localDevices objectAtIndex:indexPath.row];
//        CreateInitPasswordController *createInitPasswordController = [[CreateInitPasswordController alloc] init];
//        createInitPasswordController.isPopRoot = YES;
//        [createInitPasswordController setAddress:localDevice.address];
//        [createInitPasswordController setContactId:localDevice.contactId];
//        [self.navigationController pushViewController:createInitPasswordController animated:YES];
//        [createInitPasswordController release];
//    }
    
}

-(void)onOperatorViewSingleTap{
    UIView *operatorView = [self.view viewWithTag:kOperatorViewTag];
    UIView *barView = [operatorView viewWithTag:kBarViewTag];
    [UIView transitionWithView:barView duration:0.2 options:UIViewAnimationCurveEaseInOut
        animations:^{
            barView.alpha = 0.3;

        }
        completion:^(BOOL finished){
            [operatorView removeFromSuperview];
        }
     ];
    
}

-(void)onOperatorItemPress:(id)sender{
    UIView *operatorView = [self.view viewWithTag:kOperatorViewTag];
    UIView *barView = [operatorView viewWithTag:kBarViewTag];
    [UIView transitionWithView:barView duration:0.2 options:UIViewAnimationCurveEaseInOut
                    animations:^{
                        barView.alpha = 0.3;
                        
                    }
                    completion:^(BOOL finished){
                        [operatorView removeFromSuperview];
                        UIButton *button = (UIButton*)sender;
                        switch(button.tag){
                            case kOperatorBtnTag_Modify:
                            {
                                AddContactNextController *addContactNextController = [[AddContactNextController alloc] init];
                                addContactNextController.isModifyContact = YES;
                                addContactNextController.contactId = self.selectedContact.contactId;
                                addContactNextController.modifyContact = self.selectedContact;
                                [self.navigationController pushViewController:addContactNextController animated:YES];
                                [addContactNextController release];
                                
                                
                            }
                                break;
                            case kOperatorBtnTag_Message:
                            {
                                ChatController *chatController = [[ChatController alloc] init];
                                
                                chatController.contact = self.selectedContact;
                                
                                [self.navigationController pushViewController:chatController animated:YES];
                                [chatController release];
                                
                                
                            }
                                break;
                            case kOperatorBtnTag_Monitor:
                            {
                                MainController *mainController = [AppDelegate sharedDefault].mainController;
                                [mainController setUpCallWithId:self.selectedContact.contactId password:self.selectedContact.contactPassword callType:P2PCALL_TYPE_MONITOR];
                            }
                                break;
                            case kOperatorBtnTag_Chat:
                            {
                                MainController *mainController = [AppDelegate sharedDefault].mainController;
                                [mainController setUpCallWithId:self.selectedContact.contactId password:@"0" callType:P2PCALL_TYPE_VIDEO];
                            }
                                break;
                            case kOperatorBtnTag_Playback:
                            {
                                if (self.selectedContact.defenceState==DEFENCE_STATE_NO_PERMISSION) {
                                    [self.view makeToast:NSLocalizedString(@"no_permission", nil)];
                                }else{
                                P2PPlaybackController *playbackController = [[P2PPlaybackController alloc] init];
                                playbackController.contact = self.selectedContact;
                                [self.navigationController pushViewController:playbackController animated:YES];
                                [playbackController release];
                                    
                                }
                            }
                                
                                break;
                            case kOperatorBtnTag_Control:
                            {
                                if (self.selectedContact.defenceState==DEFENCE_STATE_NO_PERMISSION) {
                                    [self.view makeToast:NSLocalizedString(@"no_permission", nil)];
                                }else{
                                    MainSettingController *mainSettingController = [[MainSettingController alloc] init];
                                    mainSettingController.contact = self.selectedContact;
                                    [self.navigationController pushViewController:mainSettingController animated:YES];
                                    [mainSettingController release];
                                    
                                }
                                
                            }
                                break;
                        }
                    }
     ];
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        return YES;
    }else{
        return NO;
    }

}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    self.curDelIndexPath = indexPath;
    UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"sure_to_delete", nil) message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"ok", nil),nil];
    deleteAlert.tag = ALERT_TAG_DELETE;
    [deleteAlert show];
    [deleteAlert release];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch(alertView.tag){
        case ALERT_TAG_DELETE:
        {
            if(buttonIndex==1){
           
                
                // 删除数据库数据
                AlarmDAO *alarmdao = [[AlarmDAO alloc] init];
                Contact *cont = [self.contacts objectAtIndex:self.curDelIndexPath.row];
                [alarmdao clearWithDeviceID:cont.contactId];
                // 刷新消息列表
                NSMutableDictionary *contDICT = [NSMutableDictionary dictionary];
                [contDICT setObject:cont forKey:@"contactName"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DELETE_DEVICE_MESSAGE" object:nil userInfo:contDICT];
                
                // 刷新一级菜单红点
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_RED_POINT" object:nil];
                
                
                
                [[FListManager sharedFList] delete:cont];
                
                //
                [self.contacts removeObjectAtIndex:self.curDelIndexPath.row];
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.curDelIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_MEDIA_CONTACT" object:nil];
                if ([self.contacts count]==0) {
                    self.noresult.hidden=NO;
                }else{
                    self.noresult.hidden=YES;
                }
                
                [self.view makeToast:NSLocalizedString(@"operator_success", nil)];
            }
        }
            break;
        case 1:{
            if (alertView.tag == 1) { // 重置密码提示
                if (buttonIndex == 0) {
                    
                }else // 确定
                {
                    if (self.loc) { // 存在loc
                        
                        NSString *contactId = self.loc.contactId;
                        NSString *address = self.loc.address;
                        
                        Contact *cont = nil;
                        for (Contact *contact in self.contacts) {
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
                }
                
            }
           
        }
        break;
    }

}

-(void) onAddPress{
    
//    MainAddContactController *mainAddContactController = [[MainAddContactController alloc] init];
//    [self.navigationController pushViewController:mainAddContactController animated:YES];
//    [mainAddContactController release];
    self.addview.hidden=!self.addview.hidden;
}


-(void)onLocalButtonPress{
    LocalDeviceListController *localDeviceListController = [[LocalDeviceListController alloc] init];
    [self.navigationController pushViewController:localDeviceListController animated:YES];
    [localDeviceListController release];
}

-(void)stopAnimating{
    DLog(@"stopAnimating");
    
    self.contacts = [[NSMutableArray alloc] initWithArray:[[FListManager sharedFList] getContacts]];
    if ([self.contacts count]==0) {
        self.noresult.hidden=NO;
    }else{
        self.noresult.hidden=YES;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1.0);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        });
    });
    

}

-(void)onClick:(NSInteger)position contact:(Contact *)contact{
    
   
    
    MainController *mainController = [AppDelegate sharedDefault].mainController;
    mainController.contactName = contact.contactName;
    
   
    [mainController setUpCallWithId:contact.contactId password:contact.contactPassword callType:P2PCALL_TYPE_MONITOR];
}


-(BOOL)shouldAutorotate{
    return YES;//2016 12-05修改
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interface {
//    return (interface == UIInterfaceOrientationPortrait );
//}

#ifdef IOS6

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate {
    return YES;//2016 12-05修改
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
#endif

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

//-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
//    return UIInterfaceOrientationPortrait;
//}

#pragma mark - Receive Remotation

// 接收最新消息
- (void)receiveRemoteMessage:(NSNotification *)notification{
    NSDictionary *parameter = [notification userInfo];
    int key   = [[parameter valueForKey:@"key"] intValue];
    
    switch(key){
        case RET_GET_BIND_ACCOUNT:
        {
            NSInteger *count = [[parameter valueForKey:@"count"] intValue];
            NSInteger *maxCount = [[parameter valueForKey:@"maxCount"] intValue];
            NSArray *datas = [parameter valueForKey:@"datas"];
            
            
            self.bindIds = [NSMutableArray arrayWithArray:datas];

            NSLog(@"%@",self.bindIds);
        }
            break;
        case RET_GET_ALARM_INFO:
        {
            NSInteger result = [[parameter valueForKey:@"result"] intValue];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (result == 1) {
                    
                    
                    if (self.tableView) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.tableView reloadData];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_RED_POINT" object:nil];
                        });
                    }
                }else{
                    //获取报警记录失败
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
//                        [self.view makeToast:NSLocalizedString(@"modify_failure", nil)];
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            usleep(800000);
                            dispatch_async(dispatch_get_main_queue(), ^{
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
                
                [self.view makeToast:NSLocalizedString(@"device_not_support", nil)];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    usleep(800000);
                    dispatch_async(dispatch_get_main_queue(), ^{
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
    NSString *contactId = [parameter valueForKey:@"contactId"];
    //    [self.progressAlert hide:YES];
    switch(key){
        case ACK_RET_GET_ALARM_INFO:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(result==1){
                    if (self.loc.flag == 0) {
                    }else
                    {
                    [self.view makeToast:NSLocalizedString(@"device_password_error", nil)];
                    }
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        usleep(800000);
                        dispatch_async(dispatch_get_main_queue(), ^{
                           
                        });
                    });
                }
            });
        }
            break;
        case ACK_RET_GET_DEFENCE_STATE:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                //                NSString *contactId = @"10000";
                if(result==1){
                    
                    [[FListManager sharedFList] setDefenceStateWithId:contactId type:DEFENCE_STATE_WARNING_PWD];
                    if([[FListManager sharedFList] getIsClickDefenceStateBtn:contactId]){
                        if (self.loc) {
                            if (self.loc.flag == 0) {
                                
                            }else
                            {
                                [self.view makeToast:NSLocalizedString(@"device_password_error", nil)];
                            }
                        }else
                        {
                            [self.view makeToast:NSLocalizedString(@"device_password_error", nil)];
                        }
                        
                    }
                }else if(result==2){
                    [[FListManager sharedFList] setDefenceStateWithId:contactId type:DEFENCE_STATE_WARNING_NET];
                 
                }else if (result==4){
                    [[FListManager sharedFList] setDefenceStateWithId:contactId type:DEFENCE_STATE_NO_PERMISSION];
                  
                }
                
                [[FListManager sharedFList] setIsClickDefenceStateBtnWithId:contactId isClick:NO];
                
            });
            
            DLog(@"ACK_RET_GET_DEFENCE_STATE:%i",result);
        }
            break;
    }
    
}

- (void)pushCreateInitController:(NSNotification *)notify
{
    NSDictionary *userInfo = notify.userInfo;
    NSString *contactId = [userInfo objectForKey:@"contactId"];
    NSString *address = [userInfo objectForKey:@"address"];
    
    Contact *cont = nil;
    for (Contact *contact in self.contacts) {
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

- (void)refreshState
{
    NSMutableArray *contactIds = [NSMutableArray arrayWithCapacity:0];
    for(int i=0;i<[self.contacts count];i++){
        
        Contact *contact = [self.contacts objectAtIndex:i];
        [contactIds addObject:contact.contactId];
        
    }
    [[P2PClient sharedClient] getContactsStates:contactIds];
    [[FListManager sharedFList] getDefenceStates];
    [[FListManager sharedFList] searchLocalDevices];
}
- (void)loadNewData
{
    NSMutableArray *contactIds = [NSMutableArray arrayWithCapacity:0];
    for(int i=0;i<[self.contacts count];i++){
        
        Contact *contact = [self.contacts objectAtIndex:i];
        [contactIds addObject:contact.contactId];
        
    }
    [[P2PClient sharedClient] getContactsStates:contactIds];
    [[FListManager sharedFList] getDefenceStates];
    [[FListManager sharedFList] searchLocalDevices];
}
#pragma mark - alert Delegate


@end
