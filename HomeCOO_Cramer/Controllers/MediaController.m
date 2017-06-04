//
//  MediaController.m
//  2cu
//
//  Created by mac on 15/5/12.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//

#import "MediaController.h"
#import "TopBar.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "Toast+UIView.h"
#import "Utils.h"
#import "UDManager.h"
#import "LoginResult.h"
#import "ScreenshotCell.h"
#import "LineLayout.h"
#import "FListManager.h"
#import "Contact.h"
#import "P2PPlaybackController.h"
#import "chooseButton.h"
#import "chooseListView.h"
#import "CollectionVideoItem.h"
#import "P2PClient.h"
#import "P2PPlayingbackController.h"
#import "PrefixHeader.pch"

#define SEARCH_BAR_HEIGHT 36
#define TOP_INFO_BAR_HEIGHT 80
#define PLAYBACK_LIST_ITEM_HEIGHT 40
#define TOP_HEAD_MARGIN 10
#define PROGRESS_WIDTH_AND_HEIGHT 58
#define ANIM_VIEW_WIDTH_AND_HEIGHT 80

#define ADD_HEIGHT 120


#define CHOOSE_CONTACT_BTN_TAG 0 // 选择 设备 tag
#define CHOOSE_DATE_BTN_TAG 1 // 选择日期 tag


static NSString *collecionView_id = @"collection_video";  // collectionView 标示
@interface MediaController () <UICollectionViewDataSource,UICollectionViewDelegate,P2PPlaybackDelegate>
@property(nonatomic,strong)UIView *chooseView; // 含有设备/日期的View

@property(nonatomic,strong)chooseListView *contactListView;  // 设备选择的列表View
@property(nonatomic,assign)BOOL is_contact;  // 判断设备列表是否隐藏

@property(nonatomic,strong)chooseListView *dateListView;  // 日期选择的列表View
@property(nonatomic,assign)BOOL is_date;  // 判断日期列表是否隐藏
@property(nonatomic,strong)chooseButton *date_btn; // 日期的按钮
@property(nonatomic,strong)chooseButton *contact_btn;

@property(nonatomic,strong)NSMutableArray *contacts; // 设备数组
//@property(nonatomic,strong)NSMutableArray *videos; 
//
@property(nonatomic,strong)NSMutableArray *dateArray; // 设备所有的日期的数组



@property(nonatomic,strong)NSMutableArray *collectionArray; //collection显示数组


@property(nonatomic,strong)UICollectionView *collectionView; //
@property(nonatomic,strong)UIImage *headImg;  // 每个设备对应的一张图片/ 设计就是这样

@property(nonatomic,strong)Contact *First_contact; // 当前的设备模型
@property(nonatomic,strong)Contact *pre_contact; // 在删除数据前的设备模型

@property(nonatomic,copy)NSString *First_date; // 默认日期
@property(nonatomic,strong)NSMutableArray *total_Array; // 含有分日期数组的数组
@property(nonatomic,strong)NSMutableArray *date_count; // 日期数组
@property(nonatomic,strong)UIButton *more_btn;
@property(nonatomic,assign)int add_height;
@property(nonatomic,strong)NSDate *pre_date; // 前一个时间
@property(nonatomic,strong)NSDate *now_date; // 后一个时间


@property(nonatomic,assign)BOOL is_more_data; // 判断是否需要加载更多数据

@property(nonatomic,strong)MBProgressHUD *progressAlert;


@property(nonatomic,strong)UIImageView *noresult_video; // 没有影音显示的no result

@property(nonatomic,assign)BOOL isClear;

@property(nonatomic,strong)NSTimer *timer;


@end

@implementation MediaController

#pragma mark - 懒加载
- (NSMutableArray *)collectionArray
{
    if (_collectionArray == nil) {
        _collectionArray = [NSMutableArray array];
    }
    return _collectionArray;
}




- (NSMutableArray *)dateArray
{
    if (_dateArray == nil) {
        _dateArray = [NSMutableArray array];
    }
    return _dateArray;
}


- (NSMutableArray *)total_Array
{
    if (_total_Array == nil) {
        _total_Array = [NSMutableArray array];
    }
    return _total_Array;
}


#pragma mark -
-(void)loaddata{
    self.screenshotFiles = [NSMutableArray array];
    
    [self.tableView removeFromSuperview];
    
    LoginResult *loginResult = [UDManager getLoginInfo]; // 获取用户登录信息
    NSArray *datas = [NSArray arrayWithArray:[Utils getScreenshotFilesWithId:loginResult.contactId]];
    
    
    self.screenshotFiles = [[NSMutableArray alloc] initWithCapacity:0];
    
    int count = 0; // 数组数量
    if(([datas count]%3)==0){
        count = [datas count]/3;
    }else{
        count = [datas count]/3 + 1;
    }
    
    for(int i=0;i<count;i++){
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
        if(i!=(count-1)){
            [array addObject:[NSString stringWithFormat:@"%@",[datas objectAtIndex:i*3]]];
            [array addObject:[NSString stringWithFormat:@"%@",[datas objectAtIndex:i*3+1]]];
            [array addObject:[NSString stringWithFormat:@"%@",[datas objectAtIndex:i*3+2]]];
        }else{
            int value = [datas count]%3;
            if(value==0){
                [array addObject:[NSString stringWithFormat:@"%@",[datas objectAtIndex:i*3]]];
                [array addObject:[NSString stringWithFormat:@"%@",[datas objectAtIndex:i*3+1]]];
                [array addObject:[NSString stringWithFormat:@"%@",[datas objectAtIndex:i*3+2]]];
            }else if(value==1){
                [array addObject:[NSString stringWithFormat:@"%@",[datas objectAtIndex:i*3]]];
                [array addObject:@""];
                [array addObject:@""];
            }else if(value==2){
                [array addObject:[NSString stringWithFormat:@"%@",[datas objectAtIndex:i*3]]];
                [array addObject:[NSString stringWithFormat:@"%@",[datas objectAtIndex:i*3+1]]];
                [array addObject:@""];
            }
        }
        
        // label 修饰数据
        [self.screenshotFiles addObject:array];
        
    }
    [self initComponent];
    // 否则会出现闪退
    if (self.segment.selectedSegmentIndex == 0) {
        [self.tableView reloadData];
    }
    
 
    

}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// 请求图片资源
- (void)Request_Image_Data
{
    [self.screenshotFiles removeAllObjects];
    
    LoginResult *loginResult = [UDManager getLoginInfo]; // 获取用户登录信息
    NSArray *datas = [NSArray arrayWithArray:[Utils getScreenshotFilesWithId:loginResult.contactId]];
    
    
//    NSLog(@"%@",datas);
    
    self.screenshotFiles = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    int count = 0; // 数组数量
    if(([datas count]%3)==0){
        count = [datas count]/3;
    }else{
        count = [datas count]/3 + 1;
    }
    
    for(int i=0;i<count;i++){
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
        if(i!=(count-1)){
            [array addObject:[NSString stringWithFormat:@"%@",[datas objectAtIndex:i*3]]];
            [array addObject:[NSString stringWithFormat:@"%@",[datas objectAtIndex:i*3+1]]];
            [array addObject:[NSString stringWithFormat:@"%@",[datas objectAtIndex:i*3+2]]];
        }else{
            int value = [datas count]%3;
            if(value==0){
                [array addObject:[NSString stringWithFormat:@"%@",[datas objectAtIndex:i*3]]];
                [array addObject:[NSString stringWithFormat:@"%@",[datas objectAtIndex:i*3+1]]];
                [array addObject:[NSString stringWithFormat:@"%@",[datas objectAtIndex:i*3+2]]];
            }else if(value==1){
                [array addObject:[NSString stringWithFormat:@"%@",[datas objectAtIndex:i*3]]];
                [array addObject:@""];
                [array addObject:@""];
            }else if(value==2){
                [array addObject:[NSString stringWithFormat:@"%@",[datas objectAtIndex:i*3]]];
                [array addObject:[NSString stringWithFormat:@"%@",[datas objectAtIndex:i*3+1]]];
                [array addObject:@""];
            }
        }
        
        // label 修饰数据
        
        [self.screenshotFiles addObject:array];
        if ([self.screenshotFiles count]==0) {
            self.noresult.hidden=NO;
        }else{
            self.noresult.hidden=YES;
        }
//        [array release];
        
        
    }
    // 否则会出现闪退
    if (self.segment.selectedSegmentIndex == 0) {
        [self.tableView reloadData];
    }
    
}



#pragma mark - view

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(UpdateContactList) userInfo:nil repeats:YES];
    
    [self loaddata];
    //    [self initComponent];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UPDATE_IMAGE) name:@"UPDATE_MEDIA_IMAGE" object:nil];
    
    
   
}

/**
 *  更新图片
 */
-(void)UPDATE_IMAGE
{
    if (self.mediaType == 0) {
        [self Request_Image_Data];
    }else
    {
        _segment.selectedSegmentIndex = 0;
        [self onLoginTypeChange:_segment];
    }
}



- (void)UPDATE_CONTACT
{
    [self setContactListViewCount];
}


- (void)dealloc
{
//    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UPDATE_MEDIA_IMAGE" object:nil];
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    MainController *mainController = [AppDelegate sharedDefault].mainController;
    [mainController setBottomBarHidden:NO];
    
}

-(void)viewDidAppear:(BOOL)animated{
 
    [_timer setFireDate:[NSDate distantPast]];
    
    // 加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRemoteMessage:) name:RECEIVE_REMOTE_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ack_receiveRemoteMessage:) name:ACK_RECEIVE_REMOTE_MESSAGE object:nil];
    
   
    self.contacts=[[NSMutableArray alloc]init];
    self.contacts=[[[FListManager sharedFList] getContacts] mutableCopy];
    
    //  录像界面 判断不可用
    if (self.contacts.count == 0 && self.segment.selectedSegmentIndex == 1) {
        [self.contact_btn setTitle:NSLocalizedString(@"不可用", nil) forState:UIControlStateNormal];
        [self.contact_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.date_btn setTitle:NSLocalizedString(@"不可用", nil) forState:UIControlStateNormal];
        [self.date_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        self.contact_btn.userInteractionEnabled = NO;
        self.date_btn.userInteractionEnabled = NO;
    }else
    {
        if (self.contacts.count) {
            self.contact_btn.userInteractionEnabled = YES;
            self.date_btn.userInteractionEnabled = YES;
            [self.contact_btn setTitleColor:ColorWithRGB(171, 222, 250) forState:UIControlStateNormal];
        }
        
    }
    

    
    // 判断 noresult
    if (self.segment.selectedSegmentIndex == 1) { // 录像界面
        self.noresult.hidden = YES;
    }else
    {
        self.noresult_video.hidden = YES;
    }
    
    
    // 判断 放大图片为缩小
    [self onClearDetailImage];
    
    // 设置代理
    [[P2PClient sharedClient] setPlaybackDelegate:self];
}

-(void)viewWillDisappear:(BOOL)animated{
   
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RECEIVE_REMOTE_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ACK_RECEIVE_REMOTE_MESSAGE object:nil];
    
    [_timer setFireDate:[NSDate distantFuture]];
    [_timer timeInterval];
    self.contactListView.hidden = YES; // 设备列表
    self.dateListView.hidden = YES; //日期列表
    self.more_btn.hidden = self.dateListView.hidden;
    
}

- (void)setContactListViewCount
{
    
    self.contacts=[[NSMutableArray alloc]init];
    self.contacts=[[[FListManager sharedFList] getContacts] mutableCopy];
    [self.contactListView removeFromSuperview];
    
    
    [self.collectionArray removeAllObjects];
    [self.collectionView reloadData];
    
    if (self.mediaType == 1) {
        self.collectionView.hidden = NO;
    }
    
    
    if (self.contacts.count) {
        chooseListView *chooseList = [[chooseListView alloc] init];
        chooseList.backgroundColor = [UIColor whiteColor];
        chooseList.hidden = YES;
        self.contactListView = chooseList;
        
        [self.view addSubview:chooseList];
        CGFloat margin = 60;
        CGFloat item_w = (VIEWWIDTH - margin) / 2;
        self.contactListView.ListArrayData = self.contacts;
        if (self.contacts.count > 6) {
            self.contactListView.frame = CGRectMake(XForView(self.chooseView), BottomForView(self.chooseView), item_w, 40 * 7);
            self.contactListView.contentSize = CGSizeMake(item_w, self.contacts.count * 40);
        }else
        {
            self.contactListView.frame = CGRectMake(XForView(self.chooseView), BottomForView(self.chooseView), item_w, self.contacts.count * 40);
        }
        
        
        //设备选择回调
        
        __unsafe_unretained MediaController *wself =self;
        chooseList.clikcBlk = ^(int row){
            
            
//            [wself.date_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//            [wself.date_btn setTitle:NSLocalizedString(@"不可用", nil) forState:UIControlStateNormal];
            self.dateListView.hidden = YES;
            self.more_btn.hidden = YES;
//            wself.date_btn.userInteractionEnabled = NO;
            
            Contact *cont = wself.contacts[row];
            
            
            if (cont.onLineState == STATE_ONLINE) {
                
                [self.collectionArray removeAllObjects];
                [self.collectionView reloadData];
                // 设置设备标题
                chooseButton *contact_btn = (chooseButton *)wself.chooseView.subviews[0];
                [contact_btn setTitle:cont.contactName forState:UIControlStateNormal];
                
                wself.is_contact = NO;
                wself.contactListView.hidden = YES;
                
                
                NSString *contact_id = cont.contactId;
                NSString *pas_word = cont.contactPassword;
                
                
                
                NSDate *now_date = [self getNowDateFromatAnDate:[NSDate date]];
                NSDate *pre_date = [NSDate dateWithTimeInterval:- 60 * 60 * 24 * 365 sinceDate:now_date];
                
                // 查询一年内的回放记录
//                [[P2PClient sharedClient] getPlaybackFilesWithIdByDate:contact_id password:pas_word startDate:pre_date endDate:now_date];
                [[P2PClient sharedClient] getAddPlaybackFilesWithIdByDate:contact_id password:pas_word startDate:pre_date endDate:now_date type:@"contact"];
                
                
                // 图片设置
                NSString *filePath = [Utils getHeaderFilePathWithId:cont.contactId];
                
                UIImage *headImg = [UIImage imageWithContentsOfFile:filePath];
                if(headImg==nil){
                    headImg = [UIImage imageNamed:@"bgImageBig.jpg"];
                }
                wself.headImg = headImg;
                
                // contact 模型设置
                wself.First_contact = cont;
                
            }
        };
        
        self.contactListView.clikcBlk(0);

    }
    
    
}



#pragma mark -

// 初始化控件
-(void)initComponent{
    
    self.is_more_data = YES;
    [self.view setBackgroundColor:XBgColor];
    CGRect rect = [AppDelegate getScreenSize:YES isHorizontal:NO];
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height-TAB_BAR_HEIGHT;
    
    TopBar *topBar = [[TopBar alloc] initWithFrame:CGRectMake(0, 0, width, NAVIGATION_BAR_HEIGHT)];
    [topBar setTitle:NSLocalizedString(@"sys_video", nil)];
//    topBar.rightButton.backgroundColor=[UIColor colorWithRed:224.0/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
    
    [topBar setRightButtonIcon:[UIImage imageNamed:@"share_del"]];
    [topBar.rightButton setImage:[UIImage imageNamed:@"share_del_press"] forState:UIControlStateHighlighted];
    [topBar.rightButton addTarget:self action:@selector(onRightButtonPress) forControlEvents:UIControlEventTouchUpInside];
//    topBar.rightButton.hidden = self.mediaType == 0 ? NO : YES;
    self.mediaType == 0 ? [topBar setRightButtonHidden:NO] : [topBar setRightButtonHidden:YES];

    [self.view addSubview:topBar];
    
    
    [self.segment removeFromSuperview];
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[NSLocalizedString(@"my photos", nil),NSLocalizedString(@"my Videos", nil)]];
    [segment addTarget:self action:@selector(onLoginTypeChange:) forControlEvents:UIControlEventValueChanged];
    segment.frame = CGRectMake(50, NAVIGATION_BAR_HEIGHT+5, width-50*2, 30);
    [self.view addSubview:segment];
    segment.selectedSegmentIndex = self.mediaType;
    self.segment=segment;
    
    
    
    //  我的视频选择 设备/日期
    [self.chooseView removeFromSuperview];
    UIView *chooseView = [[UIView alloc] init];
    CGFloat margin = 60; // 左右间距和
    CGFloat item_w = (VIEWWIDTH - margin) / 2; // 中间每个item宽度
    CGFloat item_h = 40;
    chooseView.frame = CGRectMake( margin / 2, BottomForView(segment) + 10, VIEWWIDTH - margin, item_h);
    [self.view addSubview:chooseView];
    chooseView.hidden = YES;
    chooseView.backgroundColor = [UIColor whiteColor];
    self.chooseView = chooseView;
    
    
    
    // 设备按钮
    chooseButton *contact_btn = [[chooseButton alloc] init];
    contact_btn.tag = CHOOSE_CONTACT_BTN_TAG;
    self.contact_btn = contact_btn;
    contact_btn.frame = CGRectMake(0, 0, item_w, item_h);
    [contact_btn setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
     contact_btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [contact_btn setTitleColor:ColorWithRGB(171, 222, 250) forState:UIControlStateNormal];
    [chooseView addSubview:contact_btn];
    [contact_btn addTarget:self action:@selector(contactList) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 中间横线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.frame = CGRectMake(RightForView(contact_btn), 0, 0.5, item_h);
    
    [chooseView addSubview:lineView];
    
    // 日期按钮
    chooseButton *date_btn = [[chooseButton alloc] init];
    date_btn.tag = CHOOSE_CONTACT_BTN_TAG;
    date_btn.frame = CGRectMake(item_w, 0, item_w, item_h);
    self.date_btn = date_btn;
    [date_btn setTitleColor:ColorWithRGB(171, 222, 250) forState:UIControlStateNormal];
    [date_btn setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
    [date_btn addTarget:self action:@selector(show_date) forControlEvents:UIControlEventTouchUpInside];
    date_btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [chooseView addSubview:date_btn];
    
    if (self.contacts.count == 0) {
        [contact_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [contact_btn setTitle:NSLocalizedString(@"不可用", nil) forState:UIControlStateNormal];
        [date_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [date_btn setTitle:NSLocalizedString(@"不可用", nil) forState:UIControlStateNormal];
        self.date_btn.userInteractionEnabled = NO;
        self.contact_btn.userInteractionEnabled = NO;
    }else
    {
        self.date_btn.userInteractionEnabled = YES;
        self.contact_btn.userInteractionEnabled = YES                                                                                                                                                                                                                                                                                                                                                      ;
    }
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    
    [self.noresult_video removeFromSuperview];
    UIImageView *imgV = [[UIImageView alloc] init];
    imgV.frame=CGRectMake(30, (VIEWHEIGHT - (BottomForView(topBar) +100))/2, VIEWWIDTH-60, (VIEWWIDTH-60)/3);
    if (IOS8_OR_LATER) {
        if ([currentLanguage containsString:@"zh-Hans"]) {
            imgV.image = [UIImage imageNamed:@"myvideos_nodata_ch"];
        }else if ([currentLanguage containsString:@"en"]) { // 英文
            imgV.image = [UIImage imageNamed:@"myvideos_nodata_eng"];
        }else
        {
            imgV.image = [UIImage imageNamed:@"myvideos_nodata_fanti"];
        }
    }else
    {
        if ([currentLanguage isEqualToString:@"zh-Hans"]) {
            imgV.image = [UIImage imageNamed:@"myvideos_nodata_ch"];
        }else if ([currentLanguage isEqualToString:@"en"]) { // 英文
            imgV.image = [UIImage imageNamed:@"myvideos_nodata_eng"];
        }else
        {
            imgV.image = [UIImage imageNamed:@"myvideos_nodata_fanti"];
        }
    }
    
    imgV.hidden = self.collectionArray.count ? YES : NO;
    self.noresult_video=imgV;
    [self.view addSubview:imgV];

    
    
    
    // 初始化CollectionView
    [self.collectionView removeFromSuperview];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat collec_margin = 10;
    CGFloat size_w = (VIEWWIDTH - 4*collec_margin)/3;
    CGFloat size_h = 80;
    CGSize item_size = CGSizeMake(size_w, size_h);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.itemSize = item_size;
    
    
    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectMake(collec_margin, BottomForView(chooseView) + 10, VIEWWIDTH - 2*collec_margin, VIEWHEIGHT - 210) collectionViewLayout:layout];
//    collection.userInteractionEnabled = NO;
    collection.backgroundColor = [UIColor clearColor];
    self.collectionView = collection;
    [self.view addSubview:collection];
//    collection.hidden = YES;
    collection.dataSource = self;
    collection.delegate = self;
    collection.hidden = YES;
    [collection registerNib:[UINib nibWithNibName:@"CollectionVideoItem" bundle:nil] forCellWithReuseIdentifier:collecionView_id];  // 注册
    
    
    // 选择日期
    [self.dateListView removeFromSuperview];
    chooseListView *date_choose = [[chooseListView alloc] init];
//    date_choose.frame = CGRectMake(100, 100, 100, 100);
    date_choose.backgroundColor = [UIColor whiteColor];
        date_choose.hidden = YES;
    self.dateListView = date_choose;
    [self.view addSubview:date_choose];
    
    __unsafe_unretained MediaController *wself =self;
    date_choose.clikcBlk = ^(int row){
        
        wself.isClear = YES;
        
        
        
        NSString *time = [wself.dateListView.DateArray objectAtIndex:row];
        // 设置设备标题

        [self.date_btn setTitle:time forState:UIControlStateNormal];
        self.First_date = time;
        
        self.is_date = NO;
        self.dateListView.hidden = YES;
        self.more_btn.hidden = self.dateListView.hidden;
        
        self.collectionArray = [NSMutableArray array];
        for (int index = 0; index < self.dateArray.count; index ++) {
            NSString *all_dateTime = [self.dateArray objectAtIndex:index];
            if ([all_dateTime hasPrefix:time]) {
                [self.collectionArray addObject:all_dateTime];
            }
        }
        
        [self.collectionView reloadData];
        
    };
    
    
    [self.more_btn removeFromSuperview];
    UIButton *more_btn = [[UIButton alloc] init];
    more_btn.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:more_btn];
    [more_btn setTitle:NSLocalizedString(@"更多", nil) forState:UIControlStateNormal];
    [more_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [more_btn addTarget:self action:@selector(more_date) forControlEvents:UIControlEventTouchUpInside];
    more_btn.hidden = self.dateListView.hidden;
    self.more_btn = more_btn;
    
    
    
    // 选择设备的列表
    [self.contactListView removeFromSuperview];
    self.contacts=[[NSMutableArray alloc]init];
    self.contacts=[[[FListManager sharedFList] getContacts] mutableCopy];
    if (self.contacts.count) {
        chooseListView *chooseList = [[chooseListView alloc] init];
        chooseList.backgroundColor = [UIColor whiteColor];
        chooseList.hidden = YES;
        self.contactListView = chooseList;
        chooseList.ListArrayData = self.contacts;
        if (self.contacts.count > 6) {
            chooseList.frame = CGRectMake(XForView(chooseView), BottomForView(chooseView), item_w, 40 * 7);
            chooseList.contentSize = CGSizeMake(item_w, self.contacts.count * 40);
        }else
        {
        chooseList.frame = CGRectMake(XForView(chooseView), BottomForView(chooseView), item_w, self.contacts.count * 40);
        }
        [self.view addSubview:chooseList];
        
        // 默认选中第一个
        Contact *cont = self.contacts[0];
        NSString *contact_id = cont.contactId;
        NSString *pas_word = cont.contactPassword;
        
        
        NSDate *now_date = [NSDate date];
        NSDate *pre_date = [NSDate dateWithTimeInterval:- 60 * 60 * 24 * 365 sinceDate:now_date];
        
        self.pre_date = pre_date;
        self.now_date = now_date;
        
        // 查询一年内的回放记录
//        [[P2PClient sharedClient] getPlaybackFilesWithIdByDate:contact_id password:pas_word startDate:pre_date endDate:now_date];
        
        [[P2PClient sharedClient] getAddPlaybackFilesWithIdByDate:contact_id password:pas_word startDate:pre_date endDate:now_date type:@"contact"];
        
        
        //设备选择回调
        
        __unsafe_unretained MediaController *wself =self;
        chooseList.clikcBlk = ^(int row){
            Contact *cont = wself.contacts[row];
            
//            [wself.date_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//            [wself.date_btn setTitle:NSLocalizedString(@"不可用", nil) forState:UIControlStateNormal];
            self.dateListView.hidden = YES;
            self.more_btn.hidden = YES;
//            wself.date_btn.userInteractionEnabled = NO;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.noresult_video.hidden = NO;
                [self.collectionArray removeAllObjects];
                [self.collectionView reloadData];
                self.dateListView.hidden = YES;
                self.more_btn.hidden = YES;
                self.date_btn.userInteractionEnabled = NO;
                [self.date_btn setTitle:NSLocalizedString(@"不可用", nil) forState:UIControlStateNormal];
                [self.date_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            });
            
            
            
            if (cont.onLineState == STATE_ONLINE) {
                // 设置设备标题
                chooseButton *contact_btn = (chooseButton *)wself.chooseView.subviews[0];
                [contact_btn setTitle:cont.contactName forState:UIControlStateNormal];
                
                self.isClear = NO;
                
                [self.collectionArray removeAllObjects];
                [self.collectionView reloadData];
                wself.is_contact = NO;
                wself.contactListView.hidden = YES;
                
                
                NSString *contact_id = cont.contactId;
                NSString *pas_word = cont.contactPassword;
                
                
                
                NSDate *now_date = [self getNowDateFromatAnDate:[NSDate date]];
                NSDate *pre_date = [NSDate dateWithTimeInterval:- 60 * 60 * 24 * 365 sinceDate:now_date];
                
                // 查询一年内的回放记录
//                [[P2PClient sharedClient] getPlaybackFilesWithIdByDate:contact_id password:pas_word startDate:pre_date endDate:now_date];
                
                [[P2PClient sharedClient] getAddPlaybackFilesWithIdByDate:contact_id password:pas_word startDate:pre_date endDate:now_date type:@"contact"];
                
                
                // 图片设置
                NSString *filePath = [Utils getHeaderFilePathWithId:cont.contactId];
                
                UIImage *headImg = [UIImage imageWithContentsOfFile:filePath];
                if(headImg==nil){
                    headImg = [UIImage imageNamed:@"bgImageBig.jpg"];
                }
                wself.headImg = headImg;
                
                
                // contact 模型设置
                wself.First_contact = cont;
                
                //            [wself.collectionView reloadData];
            }else
            {
//                [self.collectionArray removeAllObjects];
//                [self.collectionView reloadData];
//                ALERTSHOW(NSLocalizedString(@"提示", nil), NSLocalizedString(@"id_offline", nil))
            }
           

        };
        
    }
    
    [self.movieView removeFromSuperview];
    UIView *movieView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height-NAVIGATION_BAR_HEIGHT)];
    [movieView setBackgroundColor:XBlack_128];
    UIImageView *animView = [[UIImageView alloc] initWithFrame:CGRectMake((movieView.frame.size.width-ANIM_VIEW_WIDTH_AND_HEIGHT)/2, (movieView.frame.size.height-ANIM_VIEW_WIDTH_AND_HEIGHT)/2, ANIM_VIEW_WIDTH_AND_HEIGHT, ANIM_VIEW_WIDTH_AND_HEIGHT)];
    
    NSArray *imagesArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"movie1.png"],[UIImage imageNamed:@"movie2.png"],[UIImage imageNamed:@"movie3.png"],nil];
    
    animView.animationImages = imagesArray;
    animView.animationDuration = ((CGFloat)[imagesArray count])*100.0f/1000.0f;
    animView.animationRepeatCount = 0;
    [animView startAnimating];
    
    [movieView addSubview:animView];
    [movieView setHidden:YES];
    [self.view addSubview:movieView];
    self.movieView = movieView;
    
    
    [self.tableView removeFromSuperview];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, BottomForView(segment), width, height-BottomForView(segment)) style:UITableViewStylePlain];
    [tableView setBackgroundColor:XBgColor];
    if(CURRENT_VERSION>=7.0){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    
    // headimage
    if (self.contacts.count) {
        Contact *cont = [self.contacts objectAtIndex:0];
        self.First_contact = cont;
        
        NSString *filePath = [Utils getHeaderFilePathWithId:cont.contactId];
        
        UIImage *headImg = [UIImage imageWithContentsOfFile:filePath];
        if(headImg==nil){
            headImg = [UIImage imageNamed:@"bgImageBig.jpg"];
        }
        self.headImg = headImg;
    }
    

    [self.noresult removeFromSuperview];
    UIImageView*imageview=[[UIImageView alloc]init];
    self.noresult = imageview;
    [self.view addSubview:imageview];
    imageview.frame=CGRectMake(30, (VIEWHEIGHT - (BottomForView(topBar) +100))/2, VIEWWIDTH-60, (VIEWWIDTH-60)/3);
    //    imageview.backgroundColor=[UIColor redColor];
    imageview .image=[UIImage imageNamed:@"camera_in.png"];
    
    if (IOS8_OR_LATER) {
        if ([currentLanguage containsString:@"zh-Hans"]) {
            imageview.image = [UIImage imageNamed:@"myalbum_nodata_fanti"];
        }else if ([currentLanguage containsString:@"en"]) { // 英文
            imageview.image = [UIImage imageNamed:@"myalbum_nodata_eng"];
        }else
        {
            imageview.image = [UIImage imageNamed:@"myalbum_nodata_ch"];
        }
    }else
    {
        if ([currentLanguage isEqualToString:@"zh-Hans"]) {
            imageview.image = [UIImage imageNamed:@"myalbum_nodata_fanti"];
        }else if ([currentLanguage isEqualToString:@"en"]) { // 英文
            imageview.image = [UIImage imageNamed:@"myalbum_nodata_eng"];
        }else
        {
            imageview.image = [UIImage imageNamed:@"myalbum_nodata_ch"];
        }
    }
    if ([self.screenshotFiles count]==0) {
        self.noresult.hidden=NO;
    }else{
        self.noresult.hidden=YES;
    }
    
    
    
    
    // loading
    [self.progressAlert removeFromSuperview];
    self.progressAlert = [[MBProgressHUD alloc]initWithView:self.view];
    self.progressAlert.dimBackground = YES;
    self.progressAlert.labelText = NSLocalizedString(@"loading", nil);
    //    [self.progressAlert show:YES];
    [self.view addSubview:self.progressAlert];
    
    
}

// 展现 设备列表
-(void)contactList
{
    if (self.is_contact) {
        self.is_contact = NO;
        self.contactListView.hidden = YES;
    }else
    {
        self.is_contact = YES;
        self.contactListView.hidden = NO;
    }
}


// 展现 日期
-(void)show_date
{
    if (self.is_date) {
        self.is_date = NO;
        self.dateListView.hidden = YES;
        self.more_btn.hidden = self.dateListView.hidden;
    }else
    {
        self.is_date = YES;
        self.dateListView.hidden = NO;
        self.more_btn.hidden = self.dateListView.hidden;
    }
}

-(void)onRightButtonPress{
    if (self.mediaType==0) {
        UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"sure_to_clear", nil) message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"ok", nil),nil];
        deleteAlert.tag = 88;
        [deleteAlert show];
    }
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch(alertView.tag){
        case 88:
        {
            if(buttonIndex==1){
                LoginResult *loginResult = [UDManager getLoginInfo];
                NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                NSString *filePath = [NSString stringWithFormat:@"%@/screenshot/%@",rootPath,loginResult.contactId];
                
                NSFileManager *manager = [NSFileManager defaultManager];
                NSError *error;
                
                [manager removeItemAtPath:filePath error:&error];
                if(error){
                    //DLog(@"%@",error);
                }
                
                [self.screenshotFiles removeAllObjects];
                [self.tableView reloadData];
                [self.view makeToast:NSLocalizedString(@"operator_success", nil)];
                self.noresult.hidden=NO;
            }
        }
            break;
    }
}


#pragma mark - 点击segment
-(void)onLoginTypeChange:(UISegmentedControl*)control{
    
    self.mediaType = control.selectedSegmentIndex;
    [self loaddata];
    if(self.mediaType==0){
        
        if (self.screenshotFiles.count) { // 有图片
            self.tableView.hidden = NO;
            self.noresult.hidden = YES;
        }else
        {
            self.tableView.hidden = YES;
            self.noresult.hidden = NO;
        }
        self.chooseView.hidden = YES; // 选择设备/日期
        self.contactListView.hidden = YES; // 设备列表
        self.dateListView.hidden = YES; //日期列表
        self.more_btn.hidden = self.dateListView.hidden;
        self.collectionView.hidden = YES;  // 视频
        self.noresult_video.hidden = YES;
        
    }else{
        
        self.noresult.hidden = YES;
        self.tableView.hidden = YES;
        self.contactListView.hidden = YES;
        self.dateListView.hidden = YES;
        self.more_btn.hidden = YES;
        self.collectionView.hidden = NO;
        [self getCollectionData];
    }
}

#pragma mark -
// 获取我的视频 设备列表数据
- (void)getCollectionData
{
    self.contacts=[[NSMutableArray alloc]init];
    self.contacts=[[[FListManager sharedFList] getContacts] mutableCopy];
    if ([self.contacts count]==0) { // 没有设备
        self.chooseView.hidden = NO;
        self.collectionView.hidden = YES;
        
        
    }else{  // 有设备
        self.chooseView.hidden = NO;
        self.collectionView.hidden = NO;
        chooseButton *contact_btn = (chooseButton *)self.chooseView.subviews[0];
        Contact *cont = [self.contacts objectAtIndex:0];
        self.First_contact = cont;
        
        NSString *filePath = [Utils getHeaderFilePathWithId:cont.contactId];
        
        UIImage *headImg = [UIImage imageWithContentsOfFile:filePath];
        if(headImg==nil){
            headImg = [UIImage imageNamed:@"bgImageBig.jpg"];
        }
        self.headImg = headImg;
        
        self.contactListView.clikcBlk(0);
        [contact_btn setTitle:cont.contactName forState:UIControlStateNormal];
        [contact_btn setTitleColor:ColorWithRGB(171, 222, 250) forState:UIControlStateNormal];
        [self.date_btn setTitleColor:ColorWithRGB(171, 222, 250) forState:UIControlStateNormal];
       
    }
}





#pragma mark - TableView Delegate & DataResource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.screenshotFiles count];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 90;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.segment.selectedSegmentIndex == 0) {
        static NSString *identifier = @"ScreenshotCell";
        NSString *more=@"11";
        UITableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:more];
        
        if (self.mediaType==0) { // 我的相册
            
            
            //    ScreenshotCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            //    if(cell==nil){
            ScreenshotCell *cell = [[ScreenshotCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            //    }
            
            
            UIImageView *backImageView = [[UIImageView alloc] init];
            UIImageView *backImageView_p = [[UIImageView alloc] init];
            backImageView.backgroundColor = XBgColor;
            backImageView_p.backgroundColor = XBgColor;
            [cell setBackgroundView:backImageView];
            [cell setSelectedBackgroundView:backImageView_p];
//            [backImageView release];
//            [backImageView_p release];
            LoginResult *loginResult = [UDManager getLoginInfo];
            
            // 图片名字
            NSString *name1 = [[self.screenshotFiles objectAtIndex:indexPath.row] objectAtIndex:0];
            NSString *name2 = [[self.screenshotFiles objectAtIndex:indexPath.row] objectAtIndex:1];
            NSString *name3 = [[self.screenshotFiles objectAtIndex:indexPath.row] objectAtIndex:2];
            
            // 文件路径
            NSString *filePath1 = [Utils getScreenshotFilePathWithName:name1 contactId:loginResult.contactId];
            NSString *filePath2 = [Utils getScreenshotFilePathWithName:name2 contactId:loginResult.contactId];
            NSString *filePath3 = [Utils getScreenshotFilePathWithName:name3 contactId:loginResult.contactId];
            [cell setRow:indexPath.row];
            cell.delegate = self;
            if(!name1||[name1 isEqualToString:@""]){
                [cell setFilePath1:@""];
            }else{
                [cell setFilePath1:filePath1];
            }
            
            if(!name2||[name2 isEqualToString:@""]){
                [cell setFilePath2:@""];
            }else{
                [cell setFilePath2:filePath2];
            }
            
            if(!name3||[name3 isEqualToString:@""]){
                [cell setFilePath3:@""];
            }else{
                [cell setFilePath3:filePath3];
            }
            return cell;
            
        }
        return cell;

    }else
    {
        return [UITableViewCell new];
    }
   
}





#pragma mark -  Other 

/**
 *  点击TableView 某item 回调代理
 *
 *  @param screenshotCell cell
 *  @param row            row
 *  @param index          index/3
 */
-(void)onItemPress:(ScreenshotCell *)screenshotCell row:(NSInteger)row index:(NSInteger)index{
    if(self.isShowDetail){
        return;
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (button.frame.size.height-button.frame.size.width)/2, button.frame.size.width, button.frame.size.width*3/4)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    LoginResult *loginResult = [UDManager getLoginInfo];
    NSString *name = [[self.screenshotFiles objectAtIndex:row] objectAtIndex:index];
    NSString *filePath = [Utils getScreenshotFilePathWithName:name contactId:loginResult.contactId];
    button.backgroundColor = XBlack;
    imageView.image = [UIImage imageWithContentsOfFile:filePath];
    [button addSubview:imageView];
//    [imageView release];
    self.detailImageView = button;
    [self.view addSubview:self.detailImageView];
    self.isShowDetail = YES;
    self.detailImageView.transform = CGAffineTransformMakeScale(0.3, 0.3);
    self.detailImageView.alpha = 0.1;
    [UIView transitionWithView:button duration:0.2 options:UIViewAnimationCurveEaseInOut
                    animations:^{
                        self.detailImageView.alpha = 1.0;
                        self.detailImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    }
                    completion:^(BOOL finished) {
                        
                    }
     ];
    
    [self.detailImageView addTarget:self action:@selector(onClearDetailImage) forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  将放大的图片缩放回原来大小并且清除
 */
-(void)onClearDetailImage{
    self.isShowDetail = NO;
    [UIView transitionWithView:self.detailImageView duration:0.2 options:UIViewAnimationCurveEaseInOut
                    animations:^{
                        self.detailImageView.alpha = 0.1;
                        self.detailImageView.transform = CGAffineTransformMakeScale(0.3, 0.3);
                    }
                    completion:^(BOOL finished) {
                        [self.detailImageView removeFromSuperview];
                        self.detailImageView = nil;
                    }
     ];
}


#pragma mark - collectionView dataResource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
     return  self.collectionArray.count ? self.collectionArray.count : 0;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionVideoItem *collection_cell = [collectionView dequeueReusableCellWithReuseIdentifier:collecionView_id forIndexPath:indexPath];
    
    NSString *time_str = [self.collectionArray objectAtIndex:indexPath.row];
    
    collection_cell.headImg = self.headImg;
    collection_cell.time_str = time_str;
    
    return collection_cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.movieView setHidden:NO];
    self.movieView.alpha = 0.3;
    
    [UIView transitionWithView:self.movieView duration:0.3 options:UIViewAnimationCurveEaseOut
                    animations:^{
                        self.movieView.alpha = 1.0;
                    }
     
                    completion:^(BOOL finished){
                        
                    }
     ];
    
        NSString *date = self.date_btn.titleLabel.text;
//        NSLog(@"%@ ---  %@",self.dateListView.DateArray,date);
    
        NSInteger date_index = [self.dateListView.DateArray indexOfObject:date];
    
    
    NSLog(@"%@  ---  %@",self.dateListView.DateArray,self.total_Array);
    
        int add_row = 0;
        int final_row = 0;
        if (date_index) {
            for (int index = 0; index < (int)date_index; index ++) {
                NSArray *arr = [self.total_Array objectAtIndex:index];
                add_row += arr.count;
            }
            
            final_row = add_row + indexPath.row ;
        }else
        {
            final_row = indexPath.row;
        }
    
        
        [[P2PClient sharedClient] p2pPlaybackCallWithId:self.First_contact.contactId password:self.First_contact.contactPassword index:final_row];
    
    
   
   
}

#pragma mark - p2p Notifation


/**
 *  Data Notification -
 *
 *  @param notification <#notification description#>
 */
- (void)receiveRemoteMessage:(NSNotification *)notification{
    NSDictionary *parameter = [notification userInfo];
    int key   = [[parameter valueForKey:@"key"] intValue];
    switch(key){
        case RET_GET_PLAYBACK_FILES: // 接收 日期消息
        {
            // 进入的情况 1 开始的加载 2 点击加载更多  3 换设备 切换我的相册/我的视频
            NSArray *array = [NSArray arrayWithArray:(NSArray*)[parameter valueForKey:@"files"]];
            NSArray *times = [NSArray arrayWithArray:(NSArray*)[parameter valueForKey:@"times"]];
            
            if (self.mediaType == 1) {
                if (times.count == 0) { // 没有数据
                    
                    
                    if (self.isClear == YES) { // 更多
                        self.isClear = NO;
                    }else
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.noresult_video.hidden = NO;
                            [self.collectionArray removeAllObjects];
                            [self.collectionView reloadData];
                            self.dateListView.hidden = YES;
                            self.more_btn.hidden = YES;
                            self.date_btn.userInteractionEnabled = NO;
                            [self.date_btn setTitle:NSLocalizedString(@"不可用", nil) forState:UIControlStateNormal];
                            [self.date_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                        });
                    }
            }else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
//                    self.dateListView.hidden = NO;
//                    self.more_btn.hidden = NO;
                    self.date_btn.userInteractionEnabled = YES;
                    [self.date_btn setTitle:@"" forState:UIControlStateNormal];
                    [self.date_btn setTitleColor:ColorWithRGB(171, 222, 250) forState:UIControlStateNormal];
                });
            }
            }
            
            
            // YES 表示还有更多数据
            self.is_more_data = times.count % 64 == 0 ? YES : NO;
            
            // 隐藏遮盖层
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressAlert hide:YES];
            });
            
            if ([self.pre_contact isEqual:self.First_contact]) { // 如果是同一个设备
                NSMutableArray *temp_time = [[NSMutableArray arrayWithArray:self.dateArray] mutableCopy];
                NSMutableArray *time_arr = [times mutableCopy];
                for (NSString *date in self.dateArray) {
                    for (NSString *time in times) {
                        if ([date isEqualToString:time]) {
                            [time_arr removeObject:time];
                        }
                    }
                    
                }
                [temp_time addObjectsFromArray:time_arr];
                self.dateArray = temp_time;
                
            }else  // 不同设备
            {
                [self.dateArray removeAllObjects];
                [self.dateArray addObjectsFromArray:times];
            }
            self.pre_contact = self.First_contact;
            
            
            
            NSMutableArray *temArr = [NSMutableArray array];
            
            
            for (NSString *timeStr in self.dateArray) {  // for
                
                NSString *sub_time = [timeStr substringToIndex:10];
                if (temArr.count) { // count
                    
                    if (![temArr.lastObject isEqualToString:sub_time]) { // !is_equal
                        [temArr addObject:sub_time];
                    }
                }else
                {
                    [temArr addObject:sub_time];
                }  // count
                
            }// for
            
            
            NSMutableArray *total_ARR = [NSMutableArray array]; // 总的数组
            
            for (int index = 0; index < temArr.count; index ++) {
                
                NSString *sub_str = [temArr objectAtIndex:index];
                // 创建一个小数组
                NSMutableArray *sub_Array = [NSMutableArray array]; // 小数组
                for (NSString *str in self.dateArray) {
                    if ([str hasPrefix:sub_str]) {
                        [sub_Array addObject:str];
                    }
                }
                
                [total_ARR addObject:sub_Array];
                
            }
            
            self.total_Array = total_ARR;
            
            if (times.count) {
                [self setDateView:temArr]; // 日期View
            }
            
        }
    }
}


/**
 *  isSuccess Notification
 *
 *  @param notification <#notification description#>
 */
- (void)ack_receiveRemoteMessage:(NSNotification *)notification{
    NSDictionary *parameter = [notification userInfo];
    int key   = [[parameter valueForKey:@"key"] intValue];
    int result   = [[parameter valueForKey:@"result"] intValue];
    switch(key){
        case ACK_RET_GET_PLAYBACK_FILES:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
  
                if(result==1){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.progressAlert hide:YES];
                    });
                    if (self.mediaType == 1) {
                        [self.view makeToast:NSLocalizedString(@"device_password_error", nil)];
                    }
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        usleep(800000);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                        });
                    });
                }else if(result==2){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.progressAlert hide:YES];
                    });
                    [self.view makeToast:NSLocalizedString(@"net_exception", nil)];
                }
                
            });
            
            DLog(@"ACK_RET_GET_PLAYBACK_FILES:%i",result);
        }
            break;
    }
    
}






/**
 *  传入一个包含日期的数组如[11-26 , 11-25]  显示在DateListView
 *
 *  @param tempArr <#tempArr description#>
 */
- (void)setDateView:(NSArray *)tempArr
{
//    NSLog(@"%@",self.dateListView.dateArray_temp);
    
    for (chooseButton *choose_btn in self.dateListView.dateArray_temp) {
        [choose_btn removeFromSuperview];
    }
    
    self.date_count = tempArr;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *time = @"";
        if (tempArr.count) {
            time = [tempArr objectAtIndex:0];
        }
//        [self.dateListView.date_array removeAllObjects];
        self.First_date = time;
//        [self.dateListView.dateArray_temp removeAllObjects];
        if (tempArr.count >= 6) {
            [self.date_btn setTitle:time forState:UIControlStateNormal];
            CGFloat date_x = RightForView(self.contactListView);
            CGFloat date_y = BottomForView(self.chooseView);
            CGFloat date_W = ( VIEWWIDTH - 60 ) /2;
            CGFloat date_H = 6 * 40;
            self.dateListView.frame = CGRectMake(date_x, date_y,date_W, date_H);
            
            self.dateListView.DateArray = tempArr;
            CGFloat item_w = (VIEWWIDTH - 60) / 2; // 中间每个item宽度
            self.dateListView.contentSize = CGSizeMake(item_w, tempArr.count * 40);

            self.more_btn.frame = CGRectMake(XForView(self.dateListView), BottomForView(self.dateListView), date_W, 40);
           
            
        }else
        {
        [self.date_btn setTitle:time forState:UIControlStateNormal];
        CGFloat date_x = RightForView(self.contactListView);
        CGFloat date_y = BottomForView(self.chooseView);
        CGFloat date_W = ( VIEWWIDTH - 60 ) /2;
        CGFloat date_H = tempArr.count * 40;
        CGFloat item_w = (VIEWWIDTH - 60) / 2; // 中间每个item宽度
        self.dateListView.frame = CGRectMake(date_x, date_y,date_W, date_H);
        self.dateListView.contentSize = CGSizeMake(item_w, tempArr.count * 40);
        self.dateListView.DateArray = tempArr;
            if (tempArr.count) {
                self.more_btn.frame = CGRectMake(XForView(self.dateListView), BottomForView(self.dateListView), date_W, 40);
            }else
            {
                self.more_btn.frame = CGRectZero;
            }
            
        }
        

        // collectionData
        self.collectionArray = [NSMutableArray array];
        for (int index = 0; index < self.dateArray.count; index ++) {
            NSString *all_dateTime = [self.dateArray objectAtIndex:index];
            if ([all_dateTime hasPrefix:time]) {
                [self.collectionArray addObject:all_dateTime];
            }
        }
        self.noresult_video.hidden = YES;
        [self.collectionView reloadData];
        
    });
    
}


#pragma mark - p2pPlay delegate
// P2PPlaybackReady
-(void)P2PPlaybackReady:(NSDictionary *)info{
    DLog(@"P2PPlaybackReady");
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView transitionWithView:self.movieView duration:0.3 options:UIViewAnimationCurveEaseOut
                        animations:^{
                            self.movieView.alpha = 0.3;
                        }
         
                        completion:^(BOOL finished){
                            [self.movieView setHidden:YES];
                            P2PPlayingbackController *playingbackController = [[P2PPlayingbackController alloc] init];
                            [self presentViewController:playingbackController animated:YES completion:nil];
//                            [playingbackController release];
                        }
         ];
    });
}


-(void)P2PPlaybackReject:(NSDictionary *)info{
    DLog(@"P2PPlaybackReject");
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView transitionWithView:self.movieView duration:0.3 options:UIViewAnimationCurveEaseOut
                        animations:^{
                            self.movieView.alpha = 0.3;
                        }
         
                        completion:^(BOOL finished){
                            [self.movieView setHidden:YES];
                            [self.view makeToast:[info objectForKey:@"rejectMsg"]];
                        }
         ];
    });
}


#pragma amrk - 加载更多数据

- (void)more_date
{
    
    if (self.is_more_data == YES) { // 今年的还没取完
        
        self.isClear = YES;
        [self.progressAlert show:YES];
        NSString *last_time = [self.dateArray lastObject];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *now_date1 = [format dateFromString:last_time];
        NSDate *now_date = [NSDate dateWithTimeInterval: - 1 sinceDate:now_date1];
        NSDate *last_date = [NSDate dateWithTimeInterval: - 60 *60 * 24 * 365 sinceDate:now_date];
        
//        [[P2PClient sharedClient] getPlaybackFilesWithIdByDate:self.First_contact.contactId password:self.First_contact.contactPassword startDate:last_date endDate:now_date];
        
        [[P2PClient sharedClient] getAddPlaybackFilesWithIdByDate:self.First_contact.contactId password:self.First_contact.contactPassword startDate:last_date endDate:now_date type:@"more"];
    }else
    {
        
        ALERTSHOW(NSLocalizedString(@"提示", nil), NSLocalizedString(@"没有更多数据了", nil));
    }
    
}

/**
 *  定时刷新设备列表
 */
- (void)UpdateContactList
{
    
    self.contacts=[[NSMutableArray alloc]init];
    self.contacts=[[[FListManager sharedFList] getContacts] mutableCopy];
    
    
    
    if (self.contacts.count) {
        [self.contactListView updateContacts:self.contacts];
        int i = 0;
        for (int index = 0; index < self.contacts.count; index ++) {
            Contact *cont = self.contacts[index];
            if (cont.onLineState == STATE_OFFLINE) {
                i ++;
            }else
            {
                
                if ([self.contact_btn.titleLabel.text isEqualToString:@"不可用"]) {
                    [self.contact_btn setTitle:cont.contactName forState:UIControlStateNormal];
//                    self.contactListView.clikcBlk(0);
                }
                
                [self.contact_btn setTitleColor:ColorWithRGB(171, 222, 250) forState:UIControlStateNormal];
                return;
            }
            
        }
        if (i == self.contacts.count) {
            [self.contact_btn setTitle:@"不可用" forState:UIControlStateNormal];
            [self.contact_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            self.date_btn.userInteractionEnabled = NO;
            [self.date_btn setTitle:@"不可用" forState:UIControlStateNormal];
            [self.date_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            
            [self.collectionArray removeAllObjects];
            [self.collectionView reloadData];
        }
        
        // loading
        [self.progressAlert removeFromSuperview];
        self.progressAlert = [[MBProgressHUD alloc]initWithView:self.view];
        self.progressAlert.dimBackground = YES;
        self.progressAlert.labelText = NSLocalizedString(@"loading", nil);
        [self.view addSubview:self.progressAlert];
    }
    
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




- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone *destinationTimeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}

@end
