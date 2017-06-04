//
//  StorageSettingController.m
//  2cu
//
//  Created by gwelltime on 14-11-8.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import "StorageSettingController.h"
#import "Contact.h"
#import "MainController.h"
#import "AutoNavigation.h"
#import "TopBar.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "Constants.h"
#import "P2PEmailSettingCell.h"
#import "PrefixHeader.pch"
#import "MBProgressHUD.h"
#import "Toast+UIView.h"

#define MESG_FORMAT_SDCARD_SUCCESS 80
#define MESG_FORMAT_SDCARD_FAIL 81
#define MESG_SDCARD_NO_EXIST 82

@interface StorageSettingController ()
{
    BOOL _isShow;
}
@end

@implementation StorageSettingController
-(void)dealloc{
    [self.progressAlert release];
    [self.contact release];
    [self.tableView release];
    [self.sdTotalStorage release];
    [self.sdFreeStorage release];
    [self.usbTotalStorage release];
    [self.usbFreeStorage release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    self.isLoadingStorageInfo = YES;
    self.isLoadingStorageFormat = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRemoteMessage:) name:RECEIVE_REMOTE_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ack_receiveRemoteMessage:) name:ACK_RECEIVE_REMOTE_MESSAGE object:nil];
    
    [[P2PClient sharedClient] getSDCardInfoWithId:self.contact.contactId password:self.contact.contactPassword];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RECEIVE_REMOTE_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ACK_RECEIVE_REMOTE_MESSAGE object:nil];
}

- (void)receiveRemoteMessage:(NSNotification *)notification{
    NSDictionary *parameter = [notification userInfo];
    int key   = [[parameter valueForKey:@"key"] intValue];
    switch(key){
        case RET_GET_SDCARD_INFO:
        {
            NSInteger result = [[parameter valueForKey:@"result"] intValue];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (result == 1) {
                    int storageCount = [[parameter valueForKey:@"storageCount"] intValue];
                    self.storageCount = storageCount;
                    self.sdCardID = [[parameter valueForKey:@"sdCardID"] intValue];
                    self.storageType = [[parameter valueForKey:@"storageType"] intValue];
                    
                    if (self.storageType == SDCARD) {
                        NSString * sdTotalStorage = [NSString stringWithFormat:@"%@M",[parameter valueForKey:@"sdTotalStorage"]];
                        self.sdTotalStorage = sdTotalStorage;
                        NSString * sdFreeStorage = [NSString stringWithFormat:@"%@M",[parameter valueForKey:@"sdFreeStorage"]];
                        self.sdFreeStorage = sdFreeStorage;
                    }else{
                        NSString * usbTotalStorage = [NSString stringWithFormat:@"%@M",[parameter valueForKey:@"usbTotalStorage"]];
                        self.usbTotalStorage = usbTotalStorage;
                        NSString * usbFreeStorage = [NSString stringWithFormat:@"%@M",[parameter valueForKey:@"usbFreeStorage"]];
                        self.usbFreeStorage = usbFreeStorage;
                    }
                    
                    if (storageCount > 1) {
                        self.storageCount = storageCount;
                        if (self.storageType == SDCARD) {NSString * usbTotalStorage = [NSString stringWithFormat:@"%@M",[parameter valueForKey:@"usbTotalStorage"]];
                            self.usbTotalStorage = usbTotalStorage;
                            NSString * usbFreeStorage = [NSString stringWithFormat:@"%@M",[parameter valueForKey:@"usbFreeStorage"]];
                            self.usbFreeStorage = usbFreeStorage;
                        }else{
                            NSString * sdTotalStorage = [NSString stringWithFormat:@"%@M",[parameter valueForKey:@"sdTotalStorage"]];
                            self.sdTotalStorage = sdTotalStorage;
                            NSString * sdFreeStorage = [NSString stringWithFormat:@"%@M",[parameter valueForKey:@"sdFreeStorage"]];
                            self.sdFreeStorage = sdFreeStorage;
                        }
                    }
                    
                    self.isLoadingStorageInfo = NO;
                    [self.tableView reloadData];
                }else{
                    //1.存储器不存在，隐藏表格--->return 0;
                    self.storageCount = 0;
                    
                    [self.tableView reloadData];
                    //2.隐藏表格时，显示提示信息
                    if (_isShow) {
                        [self showDialog];
                        _isShow = !_isShow;
                    }
                    
                }
            });
        }
            break;
        case RET_SET_SDCARD_FORMAT:
        {
            int result = [[parameter valueForKey:@"result"] intValue];
            self.isLoadingStorageFormat = NO;
            if (result == MESG_FORMAT_SDCARD_SUCCESS) {
                //格式化成功
                [[P2PClient sharedClient] getSDCardInfoWithId:self.contact.contactId password:self.contact.contactPassword];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [self.view makeToast:NSLocalizedString(@"sd_format_success", nil)];
                });
            }else if (result == MESG_FORMAT_SDCARD_FAIL){
                //格式化失败(可能设备的原因)
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [self.view makeToast:NSLocalizedString(@"not_support_format", nil)];
                });
            }else{
                //SD卡不存在
            }
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
        case RET_GET_DEVICE_INFO:
        {
            NSInteger result = [[parameter valueForKey:@"result"] intValue];
            NSString *curVersion = [parameter valueForKey:@"curVersion"];
            NSString *kernelVersion = [parameter valueForKey:@"kernelVersion"];
            NSString *rootfsVersion = [parameter valueForKey:@"rootfsVersion"];
            NSString *ubootVersion = [parameter valueForKey:@"ubootVersion"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //                [self.progressAlert hide:YES];
                
                if(result==1){
                    [self showDeviceInfoViewWithCurVersion:curVersion kernelVersion:kernelVersion rootfsVersion:rootfsVersion ubootVersion:ubootVersion];
                }
            });
        }
            break;
    }
    
}
#define INFO_VIEW_WIDTH 240
#define INFO_VIEW_HEIGHT 200
#define TITLE_LABEL_HEIGHT 40
-(void)showDeviceInfoViewWithCurVersion:(NSString*)curVersion kernelVersion:(NSString*)kernelVersion rootfsVersion:(NSString*)rootfsVersion ubootVersion:(NSString*)ubootVersion{
    UIButton *parent = [UIButton buttonWithType:UIButtonTypeCustom];
    parent.tag = 800;
    parent.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    parent.backgroundColor = XBlack_128;
    [parent addTarget:self action:@selector(hideDeviceInfoView:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *infoView = [UIButton buttonWithType:UIButtonTypeCustom];
    infoView.layer.borderWidth = 2;
    infoView.layer.borderColor = [XBlack CGColor];
    infoView.backgroundColor = XBlack_128;
    infoView.frame = CGRectMake((parent.frame.size.width-INFO_VIEW_WIDTH)/2, (parent.frame.size.height-INFO_VIEW_HEIGHT)/2, INFO_VIEW_WIDTH, INFO_VIEW_HEIGHT);
    [infoView addTarget:self action:@selector(hideDeviceInfoView:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, infoView.frame.size.width, TITLE_LABEL_HEIGHT)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = UIColorFromRGB(0xa4979b);
    titleLabel.font = XFontBold_16;
    titleLabel.text = NSLocalizedString(@"device_info", nil);
    [infoView addSubview:titleLabel];
    for(int i=0;i<8;i++){
        int x = i%2;
        int y = i/2;
        CGFloat itemWidth = INFO_VIEW_WIDTH/2;
        CGFloat itemHeight = (INFO_VIEW_HEIGHT-TITLE_LABEL_HEIGHT)/4;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x*itemWidth, titleLabel.frame.origin.y+titleLabel.frame.size.height+y*itemHeight, itemWidth, itemHeight)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = UIColorFromRGB(0xffffff);
        label.font = XFontBold_16;
        
        [infoView addSubview:label];
        [label release];
        
        switch (i) {
            case 0:
                label.text = NSLocalizedString(@"cur_version", nil);
                break;
            case 1:
                label.text = curVersion;
                break;
            case 2:
                label.text = NSLocalizedString(@"kernel_version", nil);
                break;
            case 3:
                label.text = kernelVersion;
                break;
            case 4:
                label.text = NSLocalizedString(@"rootfs_version", nil);
                break;
            case 5:
                label.text = rootfsVersion;
                break;
            case 6:
                label.text = NSLocalizedString(@"uboot_version", nil);
                break;
            case 7:
                label.text = ubootVersion;
                break;
                
        }
    }
    
    [titleLabel release];
    [parent addSubview:infoView];
    [self.view addSubview:parent];
    parent.alpha = 0.3;
    [UIView transitionWithView:parent duration:0.3 options:UIViewAnimationCurveEaseInOut
                    animations:^{
                        parent.alpha = 1.0;
                    }
     
                    completion:^(BOOL Finished){
                        
                    }
     ];
    
    infoView.transform = CGAffineTransformMakeScale(0.6,0.6);
    [UIView transitionWithView:infoView duration:0.3 options:UIViewAnimationCurveEaseInOut
                    animations:^{
                        infoView.transform = CGAffineTransformMakeScale(1.0,1.0);
                    }
     
                    completion:^(BOOL Finished){
                        
                    }
     ];
}
-(void)hideDeviceInfoView:(UIButton*)button{
    
    UIButton *parent = (UIButton*)[self.view viewWithTag:800];
    [UIView transitionWithView:parent duration:0.2 options:UIViewAnimationCurveEaseInOut
                    animations:^{
                        parent.alpha = 0.3;
                    }
     
                    completion:^(BOOL Finished){
                        
                    }
     ];
    
    UIButton *infoView = [[parent subviews] objectAtIndex:0];
    
    [UIView transitionWithView:infoView duration:0.2 options:UIViewAnimationCurveEaseInOut
                    animations:^{
                        infoView.transform = CGAffineTransformMakeScale(0.6,0.6);
                    }
     
                    completion:^(BOOL Finished){
                        [parent removeFromSuperview];
                    }
     ];
    
}
- (void)ack_receiveRemoteMessage:(NSNotification *)notification{
    NSDictionary *parameter = [notification userInfo];
    int key   = [[parameter valueForKey:@"key"] intValue];
    int result   = [[parameter valueForKey:@"result"] intValue];
    switch(key){
        case ACK_RET_GET_SDCARD_INFO:
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
                    [[P2PClient sharedClient] getSDCardInfoWithId:self.contact.contactId password:self.contact.contactPassword];
                }
                
                
            });
            
            DLog(@"ACK_RET_GET_SDCARD_INFO:%i",result);
        }
            break;
        case ACK_RET_SET_SDCARD_INFO:
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
                    [[P2PClient sharedClient] setSDCardInfoWithId:self.contact.contactId password:self.contact.contactPassword sdcardID:self.sdCardID];
                }
                
                
            });
            
            DLog(@"ACK_RET_GET_SDCARD_INFO:%i",result);
        }
            break;
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isShow = YES;
    [self initComponent];
}

#define TOP_INFO_BAR_HEIGHT 80
#define TOP_HEAD_MARGIN 10

- (void) initComponent
{
    [self.view setBackgroundColor:XBgColor];
    CGRect rect = [AppDelegate getScreenSize:YES isHorizontal:NO];
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    //导航
    TopBar *topBar = [[TopBar alloc] initWithFrame:CGRectMake(0, 0, width, NAVIGATION_BAR_HEIGHT)];
    [topBar setTitle:NSLocalizedString(@"storage_info",nil)];
    [topBar setBackButtonHidden:NO];
    [topBar.backButton addTarget:self action:@selector(onBackPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:topBar];
    [topBar release];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, width, height-NAVIGATION_BAR_HEIGHT)];
    
    
//    UIView *topInfoBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, TOP_INFO_BAR_HEIGHT)];
//    //[topInfoBarView setBackgroundColor:XWhite];
//    UIImageView *headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(TOP_HEAD_MARGIN, TOP_HEAD_MARGIN, (TOP_INFO_BAR_HEIGHT-TOP_HEAD_MARGIN*2)*4/3, TOP_INFO_BAR_HEIGHT-TOP_HEAD_MARGIN*2)];
//    //动态头像
//    NSString *filePath = [Utils getHeaderFilePathWithId:self.contact.contactId];
//    
//    UIImage *headImg = [UIImage imageWithContentsOfFile:filePath];
//    if(headImg==nil){
//        //静态头像
//        headImg = [UIImage imageNamed:@"bgImageBig.jpg"];
//    }
//    headImgView.image = headImg;
//    
//    [topInfoBarView addSubview:headImgView];
//    [headImgView release];
//    
//    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(TOP_HEAD_MARGIN+(TOP_INFO_BAR_HEIGHT-TOP_HEAD_MARGIN*2)*4/3+TOP_HEAD_MARGIN,0,width-(TOP_HEAD_MARGIN+(TOP_INFO_BAR_HEIGHT-TOP_HEAD_MARGIN*2)*4/3+TOP_HEAD_MARGIN),TOP_INFO_BAR_HEIGHT)];
//    
//    nameLabel.textAlignment = NSTextAlignmentLeft;
//    nameLabel.textColor = XBlack;
//    nameLabel.backgroundColor = XBGAlpha;
//    [nameLabel setFont:XFontBold_18];
//    
//    //联系（设备）的名字
//    nameLabel.text = self.contact.contactName;
//    [topInfoBarView addSubview:nameLabel];
//    [nameLabel release];
//    
//    [contentView addSubview:topInfoBarView];
//    [topInfoBarView release];
//    
//    //水平线
//    UIImageView *sep_view = [[UIImageView alloc] initWithFrame:CGRectMake(0, TOP_INFO_BAR_HEIGHT, width, 1)];
//    UIImage *sep = [UIImage imageNamed:@"separator_horizontal.png"];
//    sep_view.image = sep;
//    [contentView addSubview:sep_view];
//    [sep_view release];
    
    P2PHeadView*headview=[[P2PHeadView alloc]initWithFrame:CGRectMake(0, 0, VIEWWIDTH, BAR_BUTTON_HEIGHT*2+10) with:self.contact];
    [headview setContentMode:UIViewContentModeScaleAspectFill];

    //表格
//    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,TOP_INFO_BAR_HEIGHT+1, width, height-(NAVIGATION_BAR_HEIGHT+TOP_INFO_BAR_HEIGHT+1)) style:UITableViewStyleGrouped];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,10, width, height-(NAVIGATION_BAR_HEIGHT+TOP_INFO_BAR_HEIGHT-70)) style:UITableViewStyleGrouped];
    [tableView setBackgroundColor:XBGAlpha];
    tableView.backgroundView = nil;
//    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tableView.tableHeaderView=headview;
    
    self.storageCount = 2;
    tableView.delegate = self;
    tableView.dataSource = self;
    [contentView addSubview:tableView];
    self.tableView = tableView;
    [tableView release];
    [self.view addSubview:contentView];
    [contentView release];
}

-(void)onBackPress{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RECEIVE_REMOTE_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ACK_RECEIVE_REMOTE_MESSAGE object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.storageCount == 1 && self.storageType == SDCARD) {
        return 2;
    }else{
        return 1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.storageCount * 2;
    }else{
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"StorageCell";
    P2PEmailSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell==nil){
        cell = [[[P2PEmailSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
//        [cell setBackgroundColor:XBGAlpha];
    }
    
    int section = indexPath.section;
    int row = indexPath.row;
    UIImage *backImg;
    UIImage *backImg_p;
    
//    [cell setRightIcon:@"ic_arrow.png"];
    
    switch (section) {
        case 0:
        {
            if ((self.storageCount*2) == 2) {
                NSString * totalStorageName = nil;
                NSString * freeStorageName = nil;
                NSString * totalStorage = nil;
                NSString * freeStorage = nil;
                if (self.storageType == SDCARD) {
                    totalStorageName = NSLocalizedString(@"sd_card_capacity", nil);
                    freeStorageName = NSLocalizedString(@"sd_card_rem_capacity", nil);
                    totalStorage = self.sdTotalStorage;
                    freeStorage = self.sdFreeStorage;
                }else{
                    totalStorageName = NSLocalizedString(@"u_disk_capacity", nil);
                    freeStorageName = NSLocalizedString(@"u_disk_rem_capacity", nil);
                    totalStorage = self.usbTotalStorage;
                    freeStorage = self.usbFreeStorage;
                }
                
                if(row==0){
//                    backImg = [UIImage imageNamed:@"bg_bar_btn_top.png"];
//                    backImg_p = [UIImage imageNamed:@"bg_bar_btn_top_p.png"];
                    backImg = [UIImage imageNamed:@""];
                    backImg_p = [UIImage imageNamed:@""];

                    
                    [cell setLeftLabelText:totalStorageName];
                    if(self.isLoadingStorageInfo){
                        [cell setLeftLabelHidden:NO];
                        [cell setRightLabelHidden:YES];
                        [cell setProgressViewHidden:NO];
                        
                        [cell setLeftIconHidden:YES];
                        [cell setRightIconHidden:YES];
                    }else{
                        [cell setRightLabelText:totalStorage];
                        
                        [cell setLeftLabelHidden:NO];
                        [cell setRightLabelHidden:NO];
                        [cell setProgressViewHidden:YES];
                        
                        [cell setLeftIconHidden:YES];
                        [cell setRightIconHidden:YES];
                    }
                }else if(row==1){
//                    backImg = [UIImage imageNamed:@"bg_bar_btn_center.png"];
//                    backImg_p = [UIImage imageNamed:@"bg_bar_btn_center_p.png"];
                    backImg = [UIImage imageNamed:@""];
                    backImg_p = [UIImage imageNamed:@""];
                    
                    [cell setLeftLabelText:freeStorageName];
                    if(self.isLoadingStorageInfo){
                        [cell setLeftLabelHidden:NO];
                        [cell setRightLabelHidden:YES];
                        [cell setProgressViewHidden:NO];
                        
                        [cell setLeftIconHidden:YES];
                        [cell setRightIconHidden:YES];
                    }else{
                        [cell setRightLabelText:freeStorage];
                        
                        [cell setLeftLabelHidden:NO];
                        [cell setRightLabelHidden:NO];
                        [cell setProgressViewHidden:YES];
                        
                        [cell setLeftIconHidden:YES];
                        [cell setRightIconHidden:YES];
                    }
                }
            }else{
                if(row==0){
//                    backImg = [UIImage imageNamed:@"bg_bar_btn_top.png"];
//                    backImg_p = [UIImage imageNamed:@"bg_bar_btn_top_p.png"];
                    backImg = [UIImage imageNamed:@""];
                    backImg_p = [UIImage imageNamed:@""];
                    
                    [cell setLeftLabelText:NSLocalizedString(@"sd_card_capacity", nil)];
                    if(self.isLoadingStorageInfo){
                        [cell setLeftLabelHidden:NO];
                        [cell setRightLabelHidden:YES];
                        [cell setProgressViewHidden:NO];
                        
                        [cell setLeftIconHidden:YES];
                        [cell setRightIconHidden:YES];
                    }else{
                        [cell setRightLabelText:self.sdTotalStorage];
                        
                        [cell setLeftLabelHidden:NO];
                        [cell setRightLabelHidden:NO];
                        [cell setProgressViewHidden:YES];
                        
                        [cell setLeftIconHidden:YES];
                        [cell setRightIconHidden:YES];
                    }
                }else if(row==1){
//                    backImg = [UIImage imageNamed:@"bg_bar_btn_center.png"];
//                    backImg_p = [UIImage imageNamed:@"bg_bar_btn_center_p.png"];
                    backImg = [UIImage imageNamed:@""];
                    backImg_p = [UIImage imageNamed:@""];
                    
                    [cell setLeftLabelText:NSLocalizedString(@"sd_card_rem_capacity", nil)];
                    if(self.isLoadingStorageInfo){
                        [cell setLeftLabelHidden:NO];
                        [cell setRightLabelHidden:YES];
                        [cell setProgressViewHidden:NO];
                        
                        [cell setLeftIconHidden:YES];
                        [cell setRightIconHidden:YES];
                    }else{
                        [cell setRightLabelText:self.sdFreeStorage];
                        
                        [cell setLeftLabelHidden:NO];
                        [cell setRightLabelHidden:NO];
                        [cell setProgressViewHidden:YES];
                        
                        [cell setLeftIconHidden:YES];
                        [cell setRightIconHidden:YES];
                    }
                }else if(row==2){
//                    backImg = [UIImage imageNamed:@"bg_bar_btn_center.png"];
//                    backImg_p = [UIImage imageNamed:@"bg_bar_btn_center_p.png"];
                    backImg = [UIImage imageNamed:@""];
                    backImg_p = [UIImage imageNamed:@""];
                    
                    [cell setLeftLabelText:NSLocalizedString(@"u_disk_capacity", nil)];
                    if(self.isLoadingStorageInfo){
                        [cell setLeftLabelHidden:NO];
                        [cell setRightLabelHidden:YES];
                        [cell setProgressViewHidden:NO];
                        
                        [cell setLeftIconHidden:YES];
                        [cell setRightIconHidden:YES];
                    }else{
                        [cell setRightLabelText:self.usbTotalStorage];
                        
                        [cell setLeftLabelHidden:NO];
                        [cell setRightLabelHidden:NO];
                        [cell setProgressViewHidden:YES];
                        
                        [cell setLeftIconHidden:YES];
                        [cell setRightIconHidden:YES];
                    }
                }else{
//                    backImg = [UIImage imageNamed:@"bg_bar_btn_bottom.png"];
//                    backImg_p = [UIImage imageNamed:@"bg_bar_btn_bottom_p.png"];
                    backImg = [UIImage imageNamed:@""];
                    backImg_p = [UIImage imageNamed:@""];
                    
                    [cell setLeftLabelText:NSLocalizedString(@"u_disk_rem_capacity", nil)];
                    if(self.isLoadingStorageInfo){
                        [cell setLeftLabelHidden:NO];
                        [cell setRightLabelHidden:YES];
                        [cell setProgressViewHidden:NO];
                        
                        [cell setLeftIconHidden:YES];
                        [cell setRightIconHidden:YES];
                    }else{
                        [cell setRightLabelText:self.usbFreeStorage];
                        
                        [cell setLeftLabelHidden:NO];
                        [cell setRightLabelHidden:NO];
                        [cell setProgressViewHidden:YES];
                        
                        [cell setLeftIconHidden:YES];
                        [cell setRightIconHidden:YES];
                    }
                }
            }
        }
            break;
            
        case 1:
        {
            if (self.storageType == SDCARD) {
//                backImg = [UIImage imageNamed:@"bg_bar_btn_single.png"];
//                backImg_p = [UIImage imageNamed:@"bg_bar_btn_single_p.png"];
                backImg = [UIImage imageNamed:@""];
                backImg_p = [UIImage imageNamed:@""];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                
                [cell setLeftLabelText:NSLocalizedString(@"sd_card_format", nil)];
                if(self.isLoadingStorageFormat){
                    [cell setLeftLabelHidden:NO];
                    [cell setRightLabelHidden:YES];
                    [cell setProgressViewHidden:NO];
                    
                    [cell setLeftIconHidden:YES];
                    [cell setRightIconHidden:YES];
                }else{
                    [cell setLeftLabelHidden:NO];
                    [cell setRightLabelHidden:YES];
                    [cell setProgressViewHidden:YES];
                    
                    [cell setLeftIconHidden:YES];
                    [cell setRightIconHidden:NO];
                }
            }
        }
            break;
    }
    
    
    
    if((self.storageCount*2) == 2){
        if(row==1){
//            backImg = [UIImage imageNamed:@"bg_bar_btn_bottom.png"];
//            backImg_p = [UIImage imageNamed:@"bg_bar_btn_bottom_p.png"];
            backImg = [UIImage imageNamed:@""];
            backImg_p = [UIImage imageNamed:@""];
        }
    }
    
    
    UIImageView *backImageView = [[UIImageView alloc] init];
    
    backImg = [backImg stretchableImageWithLeftCapWidth:backImg.size.width*0.5 topCapHeight:backImg.size.height*0.5];
    backImageView.image = backImg;
    [cell setBackgroundView:backImageView];
    [backImageView release];
    
    UIImageView *backImageView_p = [[UIImageView alloc] init];
    
    backImg_p = [backImg_p stretchableImageWithLeftCapWidth:backImg_p.size.width*0.5 topCapHeight:backImg_p.size.height*0.5];
    backImageView_p.image = backImg_p;
    [cell setSelectedBackgroundView:backImageView_p];
    [backImageView_p release];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"format_sd_card", nil) message:NSLocalizedString(@"confirm_format", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"ok", nil), nil];
        [alertView show];
        [alertView release];
        
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        self.isLoadingStorageFormat = YES;
        [self.tableView reloadData];
        
        [[P2PClient sharedClient] setSDCardInfoWithId:self.contact.contactId password:self.contact.contactPassword sdcardID:self.sdCardID];
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return BAR_BUTTON_HEIGHT;
}

#define CONNECT_VIEW_LEFT_RIGHT_MARGIN 20

#pragma mark - 没有发现存储器（提示）
-(void)showDialog{
    CGFloat viewHeight = 175;
    
//    UIImage *backImg = [UIImage imageNamed:@"bg_bar_btn_single.png"];
    UIImage *backImg = [UIImage imageNamed:@""];
    UIImageView *backImageView = [[UIImageView alloc] init];
    //拉伸的图片作用的对象（如：backImageView），其frame=父视图frame，但左右仍会离父视图左右边20像素????
    backImageView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT+TOP_INFO_BAR_HEIGHT+BAR_BUTTON_HEIGHT-10, self.view.frame.size.width, viewHeight);
    backImg = [backImg stretchableImageWithLeftCapWidth:backImg.size.width*0.5 topCapHeight:backImg.size.height*0.5];
    backImageView.image = backImg;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5,backImageView.frame.size.width, backImageView.frame.size.height-10)];
    label.backgroundColor = XBGAlpha;
    label.textColor = XBlack;
    label.font = XFontBold_18;
    label.text = NSLocalizedString(@"no_storage", nil);
    label.textAlignment = UITextAlignmentCenter;
    
    [backImageView addSubview:label];
    [label release];
    
    backImageView.transform = CGAffineTransformMakeScale(1, 0.1);
    [UIView transitionWithView:backImageView duration:0.1 options:UIViewAnimationCurveEaseInOut
                    animations:^{
                        CGAffineTransform transform1 = CGAffineTransformScale(backImageView.transform, 1, 10);
                        backImageView.transform = transform1;
                    }
                    completion:^(BOOL finished){
                        
                    }
     ];
    
    [self.view addSubview:backImageView];
    [backImageView release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

