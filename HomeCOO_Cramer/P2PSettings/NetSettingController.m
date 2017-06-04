//
//  NetSettingController.m
//  2cu
//
//  Created by guojunyi on 14-5-19.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import "NetSettingController.h"
#import "Constants.h"
#import "P2PClient.h"
#import "TopBar.h"
#import "AppDelegate.h"
#import "Contact.h"
#import "P2PEmailSettingCell.h"
#import "P2PNetTypeCell.h"
#import "RadioButton.h"
#import "P2PWifiCell.h"
#import "Toast+UIView.h"
#import "MBProgressHUD.h"
#import "PrefixHeader.pch"
@interface NetSettingController ()

@end

@implementation NetSettingController
-(void)dealloc{
    [self.names release];
    [self.types release];
    [self.strengths release];
    [self.tableView release];
    [self.contact release];
    [self.radioNetType1 release];
    [self.radioNetType2 release];
    [self.progressAlert release];
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

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRemoteMessage:) name:RECEIVE_REMOTE_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ack_receiveRemoteMessage:) name:ACK_RECEIVE_REMOTE_MESSAGE object:nil];
    self.isLoadingNetType = YES;
    [[P2PClient sharedClient] getNpcSettingsWithId:self.contact.contactId password:self.contact.contactPassword];
}
-(void)viewDidAppear:(BOOL)animated{
    [self.tableView reloadData];
}

- (void)receiveRemoteMessage:(NSNotification *)notification{
    NSDictionary *parameter = [notification userInfo];
    int key   = [[parameter valueForKey:@"key"] intValue];
    switch(key){
        case RET_GET_NPCSETTINGS_NET_TYPE:
        {
            NSInteger type = [[parameter valueForKey:@"type"] intValue];
            
            self.netType = type;
            [self.names removeAllObjects];
            [self.types removeAllObjects];
            [self.strengths removeAllObjects];
            self.wifiCount = 0;
            self.currentWifiIndex = 0;
            self.isLoadingNetType = NO;
            self.isLoadingWifiList = YES;
            
            if(self.netType==SETTING_VALUE_NET_TYPE_WIFI){
                [[P2PClient sharedClient] getWifiListWithId:self.contact.contactId password:self.contact.contactPassword];
            }else{
                if(self.contact.contactType==CONTACT_TYPE_IPC||self.contact.contactType==CONTACT_TYPE_DOORBELL){
                    [[P2PClient sharedClient] getWifiListWithId:self.contact.contactId password:self.contact.contactPassword];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            DLog(@"net type:%i",type);
        }
            break;
        case RET_SET_NPCSETTINGS_NET_TYPE:
        {
            NSInteger result = [[parameter valueForKey:@"result"] intValue];
            
            if(result==0){
                self.lastNetType = self.netType;
                sleep(1.0);
                [[P2PClient sharedClient] getNpcSettingsWithId:self.contact.contactId password:self.contact.contactPassword];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    //[self.view makeToast:NSLocalizedString(@"operator_success", nil)];
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.isLoadingNetType = NO;
                    self.netType = self.lastNetType;
                    [self.tableView reloadData];
                    [self.view makeToast:NSLocalizedString(@"operator_failure", nil)];
                });
            }
        }
            break;
        case RET_GET_WIFI_LIST:
        {
            NSInteger count = [[parameter valueForKey:@"count"] intValue];
            NSInteger currentIndex = [[parameter valueForKey:@"currentIndex"] intValue];
            NSMutableArray *names = [parameter valueForKey:@"names"];
            NSMutableArray *types = [parameter valueForKey:@"types"];
            NSMutableArray *strengths = [parameter valueForKey:@"strengths"];
            
            self.names = [NSMutableArray arrayWithArray:names];
            self.types = [NSMutableArray arrayWithArray:types];
            self.strengths = [NSMutableArray arrayWithArray:strengths];
            self.wifiCount = count;
            self.currentWifiIndex = currentIndex;
            
            
            self.isLoadingWifiList = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
            
        }
            break;
        case RET_SET_WIFI:
        {
            NSInteger result = [[parameter valueForKey:@"result"] intValue];
            
            if(result==0){
                self.isLoadingNetType = YES;
                sleep(1.0);
                [[P2PClient sharedClient] getNpcSettingsWithId:self.contact.contactId password:self.contact.contactPassword];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.progressAlert hide:YES];
                    [self.tableView reloadData];
                    
                    //[self.view makeToast:NSLocalizedString(@"operator_success", nil)];
                    
                    NSArray *languages = [NSLocale preferredLanguages];
                    NSString *currentLanguage = [languages objectAtIndex:0];
                    if (IOS8_OR_LATER) {
                        if ([currentLanguage containsString:@"zh-Hans"]) { // 中文
                            
                            
                            if(self.netType==SETTING_VALUE_NET_TYPE_WIRED){
                                [self.nettypebtn setImage:[UIImage imageNamed:@"wifi_on_ch"] forState:UIControlStateNormal];
                            }else if(self.netType==SETTING_VALUE_NET_TYPE_WIFI){
                                [self.nettypebtn setImage:[UIImage imageNamed:@"wifi_off_ch"] forState:UIControlStateNormal];
                            }
                            
                        }else if ([currentLanguage containsString:@"en"]){
                            
                            if(self.netType==SETTING_VALUE_NET_TYPE_WIRED){
                                [self.nettypebtn setImage:[UIImage imageNamed:@"wired_open_eng"] forState:UIControlStateNormal];
                            }else if(self.netType==SETTING_VALUE_NET_TYPE_WIFI){
                                [self.nettypebtn setImage:[UIImage imageNamed:@"wifi_open_eng"] forState:UIControlStateNormal];
                            }
                            
                        }else{
                            
                            if(self.netType==SETTING_VALUE_NET_TYPE_WIRED){
                                [self.nettypebtn setImage:[UIImage imageNamed:@"wired_open_fanti"] forState:UIControlStateNormal];
                            }else if(self.netType==SETTING_VALUE_NET_TYPE_WIFI){
                                [self.nettypebtn setImage:[UIImage imageNamed:@"wifi_open_fanti"] forState:UIControlStateNormal];
                            }
                            
                        }
                    }else
                    {
                        if ([currentLanguage isEqualToString:@"zh-Hans"]) { // 中文
                            
                            
                            if(self.netType==SETTING_VALUE_NET_TYPE_WIRED){
                                [self.nettypebtn setImage:[UIImage imageNamed:@"wifi_on_ch"] forState:UIControlStateNormal];
                            }else if(self.netType==SETTING_VALUE_NET_TYPE_WIFI){
                                [self.nettypebtn setImage:[UIImage imageNamed:@"wifi_off_ch"] forState:UIControlStateNormal];
                            }
                            
                        }else if ([currentLanguage isEqualToString:@"en"]){
                            
                            if(self.netType==SETTING_VALUE_NET_TYPE_WIRED){
                                [self.nettypebtn setImage:[UIImage imageNamed:@"wired_open_eng"] forState:UIControlStateNormal];
                            }else if(self.netType==SETTING_VALUE_NET_TYPE_WIFI){
                                [self.nettypebtn setImage:[UIImage imageNamed:@"wifi_open_eng"] forState:UIControlStateNormal];
                            }
                            
                        }else{
                            
                            if(self.netType==SETTING_VALUE_NET_TYPE_WIRED){
                                [self.nettypebtn setImage:[UIImage imageNamed:@"wired_open_fanti"] forState:UIControlStateNormal];
                            }else if(self.netType==SETTING_VALUE_NET_TYPE_WIFI){
                                [self.nettypebtn setImage:[UIImage imageNamed:@"wifi_open_fanti"] forState:UIControlStateNormal];
                            }
                            
                        }
                    }
                    

                });
                
            }else{
                [self.progressAlert hide:YES];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view makeToast:NSLocalizedString(@"operator_failure", nil)];
                });
            }
            
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
            
        case ACK_RET_GET_NPC_SETTINGS:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(result==1){
                    [self.view makeToast:NSLocalizedString(@"device_password_error", nil)];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        usleep(800000);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self onBackPress];
                        });
                    });
                }else if(result==2){
                    DLog(@"resend get npc settings");
                    [[P2PClient sharedClient] getNpcSettingsWithId:self.contact.contactId password:self.contact.contactPassword];
                }
                
                
            });
            
            
            

            DLog(@"ACK_RET_GET_NPC_SETTINGS:%i",result);
        }
            break;
        case ACK_RET_SET_NPCSETTINGS_NET_TYPE:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(result==1){
                    [self.view makeToast:NSLocalizedString(@"device_password_error", nil)];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        usleep(800000);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self onBackPress];
                        });
                    });
                }else if(result==2){
                    DLog(@"resend set net type");
                    [[P2PClient sharedClient] setNetTypeWithId:self.contact.contactId password:self.contact.contactPassword type:self.netType];
                }
                
                
            });
            DLog(@"ACK_RET_SET_NPCSETTINGS_NET_TYPE:%i",result);
        }
            break;
        case ACK_RET_GET_WIFI_LIST:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(result==1){
                    [self.view makeToast:NSLocalizedString(@"device_password_error", nil)];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        usleep(800000);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self onBackPress];
                        });
                    });
                }else if(result==2){
                    DLog(@"resend get wifi list");
                    [[P2PClient sharedClient] getWifiListWithId:self.contact.contactId password:self.contact.contactPassword];
                }
                
                
            });
            DLog(@"ACK_RET_GET_WIFI_LIST:%i",result);
        }
            break;
        case ACK_RET_SET_WIFI:
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
                    DLog(@"resend set wifi list");
                    int type = [[self.types objectAtIndex:self.selectWifiIndex] intValue];
                    NSString *name = [self.names objectAtIndex:self.selectWifiIndex];
                    
                    [[P2PClient sharedClient] setWifiWithId:self.contact.contactId password:self.contact.contactPassword type:type name:name wifiPassword:self.lastSetWifiPassword];
                }
                
                
            });
            DLog(@"ACK_RET_SET_WIFI:%i",result);
        }
            break;
        
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initComponent];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initComponent{
    [self.view setBackgroundColor:XBgColor];
    CGRect rect = [AppDelegate getScreenSize:YES isHorizontal:NO];
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    TopBar *topBar = [[TopBar alloc] initWithFrame:CGRectMake(0, 0, width, NAVIGATION_BAR_HEIGHT)];
    [topBar setTitle:NSLocalizedString(@"network_set",nil)];
    [topBar setBackButtonHidden:NO];
    [topBar.backButton addTarget:self action:@selector(onBackPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:topBar];
    [topBar release];
    
    
    
    UIView *maskLayerView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, width, height-NAVIGATION_BAR_HEIGHT)];
    
    P2PHeadView*headview=[[P2PHeadView alloc]initWithFrame:CGRectMake(0, 0, VIEWWIDTH, BAR_BUTTON_HEIGHT*2+10) with:self.contact];
    [headview setContentMode:UIViewContentModeScaleAspectFill];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, width, height-NAVIGATION_BAR_HEIGHT) style:UITableViewStyleGrouped];
    [tableView setBackgroundColor:XBGAlpha];
    tableView.backgroundView = nil;
//    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tableView.tableHeaderView=headview;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    [maskLayerView addSubview:tableView];
    self.tableView = tableView;
    [tableView release];
    
    
    
    self.progressAlert = [[[MBProgressHUD alloc] initWithView:maskLayerView] autorelease];
    [maskLayerView addSubview:self.progressAlert];
    
    [self.view addSubview:maskLayerView];
    [maskLayerView release];
    
}

-(void)onBackPress{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RECEIVE_REMOTE_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ACK_RECEIVE_REMOTE_MESSAGE object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(self.isLoadingNetType){
        return 1;
    }
    
    if(self.netType==SETTING_VALUE_NET_TYPE_WIRED){
        if(self.contact.contactType==CONTACT_TYPE_IPC||self.contact.contactType==CONTACT_TYPE_DOORBELL){
            return 2;
        }else{
            return 1;
        }
    }else if(self.netType==SETTING_VALUE_NET_TYPE_WIFI){
        return 2;
    }else{
        return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0){
        if(self.isLoadingNetType){
            return 1;
        }else{
//            return 2;
            return 1;
        }
        
    }else if(section==1){
        if(self.isLoadingWifiList){
            return 1;
        }else{
            return self.wifiCount+1;
        }
        
    }else{
        return 0;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0&&indexPath.row==1){
        return BAR_BUTTON_HEIGHT*2;
    }else{
        return BAR_BUTTON_HEIGHT;
    }
    
    
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==1&&indexPath.row>0){
        return YES;
    }else{
        return NO;
    }
    
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier1 = @"P2PEmailSettingCell";
    static NSString *identifier2 = @"P2PNetTypeCell";
    static NSString *identifier3 = @"P2PWifiCell";
    CGRect rect = [AppDelegate getScreenSize:YES isHorizontal:NO];
    UITableViewCell *cell = nil;
    
    
    int section = indexPath.section;
    int row = indexPath.row;
    UIImage *backImg;
    UIImage *backImg_p;
    
    
    if(section==0){
        if(row==0){
            cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
            if(cell==nil){
                cell = [[[P2PEmailSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1] autorelease];
//                [cell setBackgroundColor:XBGAlpha];
            }
        }else if(row==1){
            cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
            if(cell==nil){
                cell = [[[P2PNetTypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier2] autorelease];
//                [cell setBackgroundColor:XBGAlpha];
            }
        }
        
        
    }else if(section==1){
        if(row==0){
            cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
            if(cell==nil){
                cell = [[[P2PEmailSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1] autorelease];
//                [cell setBackgroundColor:XBGAlpha];
            }
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:identifier3];
            if(cell==nil){
                cell = [[[P2PWifiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier3] autorelease];
//                [cell setBackgroundColor:XBGAlpha];
            }
        }
    }
    
    
    
    switch (section) {
        case 0:
        {
            if(row==0){
                P2PEmailSettingCell *emailCell = (P2PEmailSettingCell*)cell;
//                emailCell.layer.borderWidth=0.5;
                if(!self.isLoadingNetType){
//                    backImg = [UIImage imageNamed:@"bg_bar_btn_top.png"];
//                    backImg_p = [UIImage imageNamed:@"bg_bar_btn_top_p.png"];
                    backImg = [UIImage imageNamed:@""];
                    backImg_p = [UIImage imageNamed:@""];
                }else{
//                    backImg = [UIImage imageNamed:@"bg_bar_btn_single.png"];
//                    backImg_p = [UIImage imageNamed:@"bg_bar_btn_single_p.png"];
                    backImg = [UIImage imageNamed:@""];
                    backImg_p = [UIImage imageNamed:@""];
                }
                [emailCell setLeftLabelText:NSLocalizedString(@"net_type", nil)];
                
                
                
                NSArray *languages = [NSLocale preferredLanguages];
                NSString *currentLanguage = [languages objectAtIndex:0];
                
                if (IOS8_OR_LATER) {
                    if ([currentLanguage containsString:@"zh-Hans"]) { // 中文
                        
                        
                        if(self.netType==SETTING_VALUE_NET_TYPE_WIRED){
                            [emailCell.netbtn setImage:[UIImage imageNamed:@"wifi_off_ch"] forState:UIControlStateNormal];
                        }else if(self.netType==SETTING_VALUE_NET_TYPE_WIFI){
                            [emailCell.netbtn setImage:[UIImage imageNamed:@"wifi_on_ch"] forState:UIControlStateNormal];
                        }
                        
                    }else if ([currentLanguage containsString:@"zh-Hant"]){
                        
                        if(self.netType==SETTING_VALUE_NET_TYPE_WIRED){
                            [emailCell.netbtn setImage:[UIImage imageNamed:@"wired_open_fanti"] forState:UIControlStateNormal];
                        }else if(self.netType==SETTING_VALUE_NET_TYPE_WIFI){
                            [emailCell.netbtn setImage:[UIImage imageNamed:@"wifi_open_fanti"] forState:UIControlStateNormal];
                        }
                        
                    }else{
                        
                        if(self.netType==SETTING_VALUE_NET_TYPE_WIRED){
                            [emailCell.netbtn setImage:[UIImage imageNamed:@"wired_open_eng"] forState:UIControlStateNormal];
                        }else if(self.netType==SETTING_VALUE_NET_TYPE_WIFI){
                            [emailCell.netbtn setImage:[UIImage imageNamed:@"wifi_open_eng"] forState:UIControlStateNormal];
                        }
                    }

                }else
                {
                    if ([currentLanguage isEqualToString:@"zh-Hans"]) { // 中文
                        
                        
                        if(self.netType==SETTING_VALUE_NET_TYPE_WIRED){
                            [emailCell.netbtn setImage:[UIImage imageNamed:@"wifi_off_ch"] forState:UIControlStateNormal];
                        }else if(self.netType==SETTING_VALUE_NET_TYPE_WIFI){
                            [emailCell.netbtn setImage:[UIImage imageNamed:@"wifi_on_ch"] forState:UIControlStateNormal];
                        }
                        
                    }else if ([currentLanguage isEqualToString:@"zh-Hant"]){
                        
                        if(self.netType==SETTING_VALUE_NET_TYPE_WIRED){
                            [emailCell.netbtn setImage:[UIImage imageNamed:@"wired_open_fanti"] forState:UIControlStateNormal];
                        }else if(self.netType==SETTING_VALUE_NET_TYPE_WIFI){
                            [emailCell.netbtn setImage:[UIImage imageNamed:@"wifi_open_fanti"] forState:UIControlStateNormal];
                        }
                        
                    }else{
                        
                        if(self.netType==SETTING_VALUE_NET_TYPE_WIRED){
                            [emailCell.netbtn setImage:[UIImage imageNamed:@"wired_open_eng"] forState:UIControlStateNormal];
                        }else if(self.netType==SETTING_VALUE_NET_TYPE_WIFI){
                            [emailCell.netbtn setImage:[UIImage imageNamed:@"wifi_open_eng"] forState:UIControlStateNormal];
                        }
                    }

                }
                
//                [emailCell.netbtn setImage:[UIImage imageNamed:@"wifi_on_ch"] forState:UIControlStateNormal];
//                [emailCell.netbtn setImage:[UIImage imageNamed:@"wifi_off"] forState:UIControlStateSelected];
                [emailCell.netbtn addTarget:self action:@selector(Nettype:) forControlEvents:UIControlEventTouchUpInside];
                self.nettypebtn=emailCell.netbtn;
                
                if(self.isLoadingNetType){
                    [emailCell setLeftIconHidden:YES];
                    [emailCell setLeftLabelHidden:NO];
                    [emailCell setRightIconHidden:YES];
                    [emailCell setRightLabelHidden:YES];
                    [emailCell setProgressViewHidden:NO];
                }else{
                    [emailCell setLeftIconHidden:YES];
                    [emailCell setLeftLabelHidden:NO];
                    [emailCell setRightIconHidden:YES];
                    [emailCell setRightLabelHidden:YES];
                    [emailCell setProgressViewHidden:YES];
                }
            }else if(row==1){
//                backImg = [UIImage imageNamed:@"bg_bar_btn_bottom.png"];
//                backImg_p = [UIImage imageNamed:@"bg_bar_btn_bottom_p.png"];
                backImg = [UIImage imageNamed:@""];
                backImg_p = [UIImage imageNamed:@""];
                P2PNetTypeCell *netTypeCell = (P2PNetTypeCell*)cell;
//                netTypeCell.layer.borderWidth=0.5;
                self.radioNetType1 = netTypeCell.radio1;
                self.radioNetType2 = netTypeCell.radio2;
                [netTypeCell.radio1 addTarget:self action:@selector(onNetType1Press:) forControlEvents:UIControlEventTouchUpInside];
                [netTypeCell.radio2 addTarget:self action:@selector(onNetType2Press:) forControlEvents:UIControlEventTouchUpInside];
                if(self.netType==SETTING_VALUE_NET_TYPE_WIRED){
                    [netTypeCell setSelectedIndex:0];
                }else if(self.netType==SETTING_VALUE_NET_TYPE_WIFI){
                    [netTypeCell setSelectedIndex:1];
                }
            }
            
        }
            break;
        case 1:
        {
            if(row==0){
                P2PEmailSettingCell *emailCell = (P2PEmailSettingCell*)cell;
//                emailCell.layer.borderWidth=0.5;
                if(!self.isLoadingWifiList){
//                    backImg = [UIImage imageNamed:@"bg_bar_btn_top.png"];
//                    backImg_p = [UIImage imageNamed:@"bg_bar_btn_top_p.png"];
                    backImg = [UIImage imageNamed:@""];
                    backImg_p = [UIImage imageNamed:@""];
                }else{
//                    backImg = [UIImage imageNamed:@"bg_bar_btn_single.png"];
//                    backImg_p = [UIImage imageNamed:@"bg_bar_btn_single_p.png"];
                    backImg = [UIImage imageNamed:@""];
                    backImg_p = [UIImage imageNamed:@""];
                }
                [emailCell setLeftLabelText:NSLocalizedString(@"wifi_list", nil)];
                if(self.isLoadingWifiList){
                    [emailCell setLeftIconHidden:YES];
                    [emailCell setLeftLabelHidden:NO];
                    [emailCell setRightIconHidden:YES];
                    [emailCell setRightLabelHidden:YES];
                    [emailCell setProgressViewHidden:NO];
                }else{
                    [emailCell setLeftIconHidden:YES];
                    [emailCell setLeftLabelHidden:NO];
                    [emailCell setRightIconHidden:YES];
                    [emailCell setRightLabelHidden:YES];
                    [emailCell setProgressViewHidden:YES];
                }
            }else{
                if(row<self.wifiCount){
                    if((row-1)==self.currentWifiIndex){
//                        backImg = [UIImage imageNamed:@"bg_bar_btn_center_p.png"];
//                        backImg_p = [UIImage imageNamed:@"bg_bar_btn_center_p.png"];
                        backImg = [UIImage imageNamed:@""];
                        backImg_p = [UIImage imageNamed:@""];
                    }else{
//                        backImg = [UIImage imageNamed:@"bg_bar_btn_center.png"];
//                        backImg_p = [UIImage imageNamed:@"bg_bar_btn_center_p.png"];
                        backImg = [UIImage imageNamed:@""];
                        backImg_p = [UIImage imageNamed:@""];
                    }
                    
                }else{
                    if((row-1)==self.currentWifiIndex){
//                        backImg = [UIImage imageNamed:@"bg_bar_btn_bottom_p.png"];
//                        backImg_p = [UIImage imageNamed:@"bg_bar_btn_bottom_p.png"];
                        backImg = [UIImage imageNamed:@""];
                        backImg_p = [UIImage imageNamed:@""];
                    }else{
//                        backImg = [UIImage imageNamed:@"bg_bar_btn_bottom.png"];
//                        backImg_p = [UIImage imageNamed:@"bg_bar_btn_bottom_p.png"];
                        backImg = [UIImage imageNamed:@""];
                        backImg_p = [UIImage imageNamed:@""];
                    }
                    
                    
                }
                P2PWifiCell *wifiCell = (P2PWifiCell*)cell;
//                wifiCell.layer.borderWidth=0.5;
                
                [wifiCell setLeftLabelText:[self.names objectAtIndex:(row-1)]];
                int strength = [[self.strengths objectAtIndex:(row-1)] intValue];
                int type = [[self.types objectAtIndex:(row-1)] intValue];
                if(type!=2){
                    [wifiCell setRightIcon2:@""];
                }else{
                    [wifiCell setRightIcon2:@"ic_wifi_lock.png"];
                }
                if (indexPath.row-1 == self.currentWifiIndex) {
                    [wifiCell setRightIcon2:@"ic_wifi_selected.png"];
                }
                switch(strength){
                    case 0:
                    {
                        [wifiCell setRightIcon:@"ic_strength0.png"];
                    }
                        break;
                    case 1:
                    {
                        [wifiCell setRightIcon:@"ic_strength1.png"];
                    }
                        break;
                    case 2:
                    {
                        [wifiCell setRightIcon:@"ic_strength2.png"];
                    }
                        break;
                    case 3:
                    {
                        [wifiCell setRightIcon:@"ic_strength3.png"];
                    }
                        break;
                    case 4:
                    {
                        [wifiCell setRightIcon:@"ic_strength4.png"];
                    }
                        break;
                }
               
            }
        }
            break;
            
            
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
-(void)Nettype:(UIButton*)btn{
    btn.selected=!btn.selected;
    if (btn.selected==NO) {
        UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"change_net_prompt", nil) message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"ok", nil),nil];
        promptAlert.tag = ALERT_TAG_NET_TYPE1;
        [promptAlert show];
        [promptAlert release];
    }else{
        UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"change_net_prompt", nil) message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"ok", nil),nil];
        promptAlert.tag = ALERT_TAG_NET_TYPE2;
        [promptAlert show];
        [promptAlert release];
    }

    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section==1&&indexPath.row>0&&(indexPath.row-1)!=self.currentWifiIndex){
        self.selectWifiIndex = indexPath.row-1;
        UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"change_net_prompt", nil) message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"ok", nil),nil];
        promptAlert.tag = ALERT_TAG_CHANGE_WIFI;
        [promptAlert show];
        [promptAlert release];
    }
}
-(void)onNetType1Press:(id)sender{
    if(!self.isLoadingNetType&&!self.radioNetType1.isSelected){
        [self.radioNetType1 setSelected:YES];
        [self.radioNetType2 setSelected:NO];
        UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"change_net_prompt", nil) message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"ok", nil),nil];
        promptAlert.tag = ALERT_TAG_NET_TYPE1;
        [promptAlert show];
        [promptAlert release];
        
    }
    
    
}

-(void)onNetType2Press:(id)sender{
    if(!self.isLoadingNetType&&!self.radioNetType2.isSelected){
        [self.radioNetType1 setSelected:NO];
        [self.radioNetType2 setSelected:YES];
        UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"change_net_prompt", nil) message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"ok", nil),nil];
        promptAlert.tag = ALERT_TAG_NET_TYPE2;
        [promptAlert show];
        [promptAlert release];
        
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch(alertView.tag){
        case ALERT_TAG_NET_TYPE1:
        {
            if(buttonIndex==0){
                [self.radioNetType1 setSelected:NO];
                [self.radioNetType2 setSelected:YES];
            }else if(buttonIndex==1){
                self.isLoadingNetType = YES;
                self.lastNetType = self.netType;
                self.netType = SETTING_VALUE_NET_TYPE_WIRED;
                [self.tableView reloadData];
                
                [[P2PClient sharedClient] setNetTypeWithId:self.contact.contactId password:self.contact.contactPassword type:self.netType];
            }
        }
            break;
        case ALERT_TAG_NET_TYPE2:
        {
            if(buttonIndex==0){
                [self.radioNetType1 setSelected:YES];
                [self.radioNetType2 setSelected:NO];
            }else if(buttonIndex==1){
                self.isLoadingNetType = YES;
                self.lastNetType = self.netType;
                self.netType = SETTING_VALUE_NET_TYPE_WIFI;
                [self.tableView reloadData];
                
                [[P2PClient sharedClient] setNetTypeWithId:self.contact.contactId password:self.contact.contactPassword type:self.netType];
            }
        }
            break;
        case ALERT_TAG_CHANGE_WIFI:
        {
            if(buttonIndex==0){
                
            }else if(buttonIndex==1){
                NSString *name = [self.names objectAtIndex:self.selectWifiIndex];
                UIAlertView *inputAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"input_wifi_password", nil) message:name delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"ok", nil), nil];
                inputAlert.alertViewStyle = UIAlertViewStyleSecureTextInput;
                UITextField *passwordField = [inputAlert textFieldAtIndex:0];
                
                inputAlert.tag = ALERT_TAG_INPUT_WIFI_PASSWORD;
                [inputAlert show];
                [inputAlert release];
            }
        }
            break;
        case ALERT_TAG_INPUT_WIFI_PASSWORD:
        {
            if(buttonIndex==0){
                
            }else if(buttonIndex==1){
                UITextField *passwordField = [alertView textFieldAtIndex:0];
                
                NSString *inputPwd = passwordField.text;
                if(!inputPwd||inputPwd.length==0){
                    [self.view makeToast:NSLocalizedString(@"input_wifi_password", nil)];
                    return;
                }
                
                if(inputPwd.length<8){
                    [self.view makeToast:NSLocalizedString(@"wifi_password_format_error", nil)];
                    return;
                }
                
                self.progressAlert.dimBackground = YES;
                [self.progressAlert show:YES];
                int type = [[self.types objectAtIndex:self.selectWifiIndex] intValue];
                NSString *name = [self.names objectAtIndex:self.selectWifiIndex];
                self.lastSetWifiPassword = [NSString stringWithFormat:@"%@",inputPwd];
                [[P2PClient sharedClient] setWifiWithId:self.contact.contactId password:self.contact.contactPassword type:type name:name wifiPassword:self.lastSetWifiPassword];
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
