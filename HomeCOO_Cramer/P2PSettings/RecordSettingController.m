//
//  RecordSettingController.m
//  2cu
//
//  Created by guojunyi on 14-5-16.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import "RecordSettingController.h"
#import "AppDelegate.h"
#import "TopBar.h"
#import "Toast+UIView.h"
#import "Constants.h"
#import "Contact.h"
#import "Utils.h"
#import "P2PClient.h"
#import "P2PEmailSettingCell.h"
#import "P2PRecordTypeCell.h"
#import "P2PRecordTimeCell.h"
#import "P2PTimeSettingCell.h"
#import "RadioButton.h"
#import "P2PPlanTimeSettingCell.h"
#import "PlanTimePickView.h"
#import "P2PSwitchCell.h"
#import "PrefixHeader.pch"
@interface RecordSettingController ()

@end

@implementation RecordSettingController
-(void)dealloc{
    [self.radioRecordType1 release];
    [self.radioRecordType2 release];
    [self.radioRecordType3 release];
    [self.tableView release];
    [self.contact release];
    
    [self.planPicker1 release];
    [self.planPicker2 release];
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
    
    self.isLoadingRecordType = YES;
    self.isFirstCompoleteLoadRecordType = NO;
    self.recordType = SETTING_VALUE_RECORD_MANUAL;
    self.isLoadingRecordTime = YES;
    self.recordTime = SETTING_VALUE_RECORD_TIME_ONE;
    self.isLoadingRecordPlanTime = YES;

    self.isLoadingRemoteRecord = YES;
    self.remoteRecordState = SETTING_VALUE_REMOTE_RECORD_STATE_OFF;
    [[P2PClient sharedClient] getNpcSettingsWithId:self.contact.contactId password:self.contact.contactPassword];
}
    
-(void)viewDidAppear:(BOOL)animated{
    [self.tableView reloadData];
}
    
- (void)receiveRemoteMessage:(NSNotification *)notification{
    NSDictionary *parameter = [notification userInfo];
    int key   = [[parameter valueForKey:@"key"] intValue];
    switch(key){
        case RET_GET_NPCSETTINGS_RECORD_TYPE:
        {
            NSInteger type = [[parameter valueForKey:@"type"] intValue];
            
            self.recordType = type;
            self.isFirstCompoleteLoadRecordType = YES;
            self.isLoadingRecordType = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
            });
            DLog(@"record type:%i",type);
            
        }
        break;
        case RET_SET_NPCSETTINGS_RECORD_TYPE:
        {
            NSInteger result = [[parameter valueForKey:@"result"] intValue];
            self.isLoadingRecordType = NO;
            if(result==0){
                self.lastRecordType = self.recordType;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];

                    [self.view makeToast:NSLocalizedString(@"operator_success", nil)];
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.recordType = self.lastRecordType;
                    [self.tableView reloadData];
                    [self.view makeToast:NSLocalizedString(@"operator_failure", nil)];
                });
            }
        }
        break;
        case RET_GET_NPCSETTINGS_RECORD_TIME:
        {
            NSInteger time = [[parameter valueForKey:@"time"] intValue];
            
            self.recordTime = time;
            self.isFirstCompoleteLoadRecordType = YES;
            self.isLoadingRecordTime = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            DLog(@"record time:%i",time);
        }
        break;
        case RET_SET_NPCSETTINGS_RECORD_TIME:
        {
            NSInteger result = [[parameter valueForKey:@"result"] intValue];
            self.isLoadingRecordTime = NO;
            if(result==0){
                self.lastRecordTime = self.recordTime;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [self.view makeToast:NSLocalizedString(@"operator_success", nil)];
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.recordTime = self.lastRecordTime;
                    [self.tableView reloadData];
                    [self.view makeToast:NSLocalizedString(@"operator_failure", nil)];
                });
            }
        }
            break;
        case RET_GET_NPCSETTINGS_RECORD_PLAN_TIME:
        {
            NSInteger time = [[parameter valueForKey:@"time"] intValue];
            
            self.planTime = time;
            self.isFirstCompoleteLoadRecordType = YES;
            self.isLoadingRecordPlanTime = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            DLog(@"record plan time:%i",time);
        }
            break;
        case RET_SET_NPCSETTINGS_RECORD_PLAN_TIME:
        {
            NSInteger result = [[parameter valueForKey:@"result"] intValue];
            self.isLoadingRecordPlanTime = NO;
            if(result==0){
                self.lastPlanTime = self.planTime;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [self.view makeToast:NSLocalizedString(@"operator_success", nil)];
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.planTime = self.lastPlanTime;
                    [self.tableView reloadData];
                    [self.view makeToast:NSLocalizedString(@"operator_failure", nil)];
                });
            }
        }
            break;
        case RET_GET_NPCSETTINGS_REMOTE_RECORD:
        {
            NSInteger state = [[parameter valueForKey:@"state"] intValue];
            
            self.remoteRecordState = state;
            self.isLoadingRemoteRecord = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                //usleep(500000);
                [self.tableView reloadData];
            });
            DLog(@"remote record state:%i",state);
            
        }
            break;
        case RET_SET_NPCSETTINGS_REMOTE_RECORD:
        {
            NSInteger result = [[parameter valueForKey:@"result"] intValue];
            [[P2PClient sharedClient] getNpcSettingsWithId:self.contact.contactId password:self.contact.contactPassword];
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
        case ACK_RET_SET_NPCSETTINGS_RECORD_TYPE:
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
                    DLog(@"resend set record type");
                    [[P2PClient sharedClient] setRecordTypeWithId:self.contact.contactId password:self.contact.contactPassword type:self.recordType];
                }
                
                
            });
            DLog(@"ACK_RET_SET_NPCSETTINGS_RECORD_TYPE:%i",result);
        }
            break;
        case ACK_RET_SET_NPCSETTINGS_RECORD_TIME:
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
                    DLog(@"resend set record time");
                    [[P2PClient sharedClient] setRecordTimeWithId:self.contact.contactId password:self.contact.contactPassword value:self.recordTime];
                }
                
                
            });
            DLog(@"ACK_RET_SET_NPCSETTINGS_RECORD_TIME:%i",result);
        }
            break;
        case ACK_RET_SET_NPCSETTINGS_RECORD_PLAN_TIME:
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
                    DLog(@"resend set record plan time");
                    [[P2PClient sharedClient] setRecordPlanTimeWithId:self.contact.contactId password:self.contact.contactPassword time:self.planTime];
                }
                
                
            });
            DLog(@"ACK_RET_SET_NPCSETTINGS_RECORD_PLAN_TIME:%i",result);
        }
            break;
        case ACK_RET_SET_NPCSETTINGS_REMOTE_RECORD:
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
                    DLog(@"resend set remote record state");
                    [[P2PClient sharedClient] setRemoteRecordWithId:self.contact.contactId password:self.contact.contactPassword state:self.remoteRecordState];
                }
                
                
            });
            
            
            
            
            
            DLog(@"ACK_RET_SET_NPCSETTINGS_REMOTE_RECORD:%i",result);
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
    [topBar setTitle:NSLocalizedString(@"record_set",nil)];
    [topBar setBackButtonHidden:NO];
    [topBar.backButton addTarget:self action:@selector(onBackPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:topBar];
    [topBar release];
    
    
    P2PHeadView*headview=[[P2PHeadView alloc]initWithFrame:CGRectMake(0, 0, VIEWWIDTH, BAR_BUTTON_HEIGHT*2+10) with:self.contact];
    [headview setContentMode:UIViewContentModeScaleAspectFill];
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT+10, width, height-NAVIGATION_BAR_HEIGHT) style:UITableViewStyleGrouped];
    [tableView setBackgroundColor:XBGAlpha];
    tableView.backgroundView = nil;
//    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    tableView.tableHeaderView=headview;
    self.tableView = tableView;
    [tableView release];
    
    
}
    
-(void)onBackPress{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RECEIVE_REMOTE_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ACK_RECEIVE_REMOTE_MESSAGE object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}
    
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(self.recordType==SETTING_VALUE_RECORD_MANUAL){
        return 2;
    }else{
        return 2;
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
        if(self.isFirstCompoleteLoadRecordType){
            return 2;
        }else{
            return 1;
        }
        
    }else if(section==1){
        if(self.recordType==SETTING_VALUE_RECORD_ALARM){
            return 2;
        }else if(self.recordType==SETTING_VALUE_RECORD_TIMER){
            return 3;
        }else if(self.recordType==SETTING_VALUE_RECORD_MANUAL){
            return 1;
        }else{
            return 0;
        }
        
    }else{
        return 0;
    }
    
}
    
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0&&indexPath.row==1){
        return BAR_BUTTON_HEIGHT*3;
    }else if(indexPath.section==1&&self.recordType==SETTING_VALUE_RECORD_TIMER){
        if(indexPath.row==1){
            return BAR_BUTTON_HEIGHT*3;
        }else{
            return BAR_BUTTON_HEIGHT;
        }
    }else{
        return BAR_BUTTON_HEIGHT;
    }
    
    
}
    
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.recordType==SETTING_VALUE_RECORD_TIMER&&indexPath.section==1&&indexPath.row==2){
        return YES;
    }else{
        return NO;
    }
    
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier1 = @"P2PEmailSettingCell";
    static NSString *identifier2 = @"P2PRecordTypeCell";
    static NSString *identifier3 = @"P2PRecordTimeCell";
    static NSString *identifier4 = @"P2PTimeSettingCell";
    static NSString *identifier5 = @"P2PPlanTimeSettingCell";
    static NSString *identifier6 = @"P2PSwitchCell";
    
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
                cell = [[[P2PRecordTypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier2] autorelease];
//                [cell setBackgroundColor:XBGAlpha];
            }
        }
        
        
    }else if(section==1){
        if(self.recordType==SETTING_VALUE_RECORD_ALARM){
            if(row==0){
                cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
                if(cell==nil){
                    cell = [[[P2PEmailSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1] autorelease];
//                    [cell setBackgroundColor:XBGAlpha];
                }
            }else if(row==1){
                cell = [tableView dequeueReusableCellWithIdentifier:identifier3];
                if(cell==nil){
                    cell = [[[P2PRecordTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier3] autorelease];
//                    [cell setBackgroundColor:XBGAlpha];
                }
            }
        }else if(self.recordType==SETTING_VALUE_RECORD_TIMER){
            if(row==0){
                cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
                if(cell==nil){
                    cell = [[[P2PEmailSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1] autorelease];
//                    [cell setBackgroundColor:XBGAlpha];
                }
            }else if(row==1){
                cell = [tableView dequeueReusableCellWithIdentifier:identifier5];
                if(cell==nil){
                    cell = [[[P2PPlanTimeSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier5] autorelease];
//                    [cell setBackgroundColor:XBGAlpha];
                }
            }else if(row==2){
                cell = [tableView dequeueReusableCellWithIdentifier:identifier4];
                if(cell==nil){
                    cell = [[[P2PTimeSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier4] autorelease];
//                    [cell setBackgroundColor:XBGAlpha];
                }
            }
        }else if(self.recordType==SETTING_VALUE_RECORD_MANUAL){
            if(row==0){
                cell = [tableView dequeueReusableCellWithIdentifier:identifier6];
                if(cell==nil){
                    cell = [[[P2PSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier6] autorelease];
//                    [cell setBackgroundColor:XBGAlpha];
                }
            }
        }
    }
    
    
    
    switch (section) {
        
        case 0:
        {
            
            if(row==0){
                P2PEmailSettingCell *emailCell = (P2PEmailSettingCell*)cell;
                if(self.isFirstCompoleteLoadRecordType){
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
                [emailCell setLeftLabelText:NSLocalizedString(@"record_type", nil)];
                if(self.isLoadingRecordType){
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
                P2PRecordTypeCell *recordTypeCell = (P2PRecordTypeCell*)cell;
//                backImg = [UIImage imageNamed:@"bg_bar_btn_bottom.png"];
//                backImg_p = [UIImage imageNamed:@"bg_bar_btn_bottom_p.png"];
                backImg = [UIImage imageNamed:@""];
                backImg_p = [UIImage imageNamed:@""];
                self.radioRecordType1 = recordTypeCell.radio1;
                self.radioRecordType2 = recordTypeCell.radio2;
                self.radioRecordType3 = recordTypeCell.radio3;
                [recordTypeCell.radio1 addTarget:self action:@selector(onRadioRecordType1Press) forControlEvents:UIControlEventTouchUpInside];
                [recordTypeCell.radio2 addTarget:self action:@selector(onRadioRecordType2Press) forControlEvents:UIControlEventTouchUpInside];
                [recordTypeCell.radio3 addTarget:self action:@selector(onRadioRecordType3Press) forControlEvents:UIControlEventTouchUpInside];
                if(self.recordType==SETTING_VALUE_RECORD_MANUAL){
                    [recordTypeCell setSelectedIndex:0];
                }else if(self.recordType==SETTING_VALUE_RECORD_ALARM){
                    [recordTypeCell setSelectedIndex:1];
                }else if(self.recordType==SETTING_VALUE_RECORD_TIMER){
                    [recordTypeCell setSelectedIndex:2];
                }
            }
            
        }
        break;
        case 1:
        {
            if(self.recordType==SETTING_VALUE_RECORD_ALARM){
                if(row==0){
                    P2PEmailSettingCell *emailCell = (P2PEmailSettingCell*)cell;
//                    backImg = [UIImage imageNamed:@"bg_bar_btn_top.png"];
//                    backImg_p = [UIImage imageNamed:@"bg_bar_btn_top_p.png"];
                    backImg = [UIImage imageNamed:@""];
                    backImg_p = [UIImage imageNamed:@""];
                    [emailCell setLeftLabelText:NSLocalizedString(@"record_time", nil)];
                    if(self.isLoadingRecordTime){
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
                    P2PRecordTimeCell *recordTimeCell = (P2PRecordTimeCell*)cell;
//                    backImg = [UIImage imageNamed:@"bg_bar_btn_bottom.png"];
//                    backImg_p = [UIImage imageNamed:@"bg_bar_btn_bottom_p.png"];
                    backImg = [UIImage imageNamed:@""];
                    backImg_p = [UIImage imageNamed:@""];
                    
                    recordTimeCell.delegate = self;
                    if(self.recordTime==SETTING_VALUE_RECORD_TIME_ONE){
                        
                        [recordTimeCell setSelectedIndex:0];
                    }else if(self.recordTime==SETTING_VALUE_RECORD_TIME_TWO){
                        
                        [recordTimeCell setSelectedIndex:1];
                    }else if(self.recordTime==SETTING_VALUE_RECORD_TIME_THREE){
                        
                        [recordTimeCell setSelectedIndex:2];
                    }
                }
            }else if(self.recordType==SETTING_VALUE_RECORD_TIMER){
                if(row==0){
                    P2PEmailSettingCell *emailCell = (P2PEmailSettingCell*)cell;
//                    backImg = [UIImage imageNamed:@"bg_bar_btn_top.png"];
//                    backImg_p = [UIImage imageNamed:@"bg_bar_btn_top_p.png"];
                    backImg = [UIImage imageNamed:@""];
                    backImg_p = [UIImage imageNamed:@""];
                    [emailCell setLeftLabelText:NSLocalizedString(@"plan_time_table", nil)];
                    [emailCell setLeftIconHidden:YES];
                    [emailCell setLeftLabelHidden:NO];
                    [emailCell setRightIconHidden:YES];
                    [emailCell setRightLabelHidden:YES];
                    [emailCell setProgressViewHidden:YES];
                }else if(row==1){
                    P2PPlanTimeSettingCell *planTimeCell = (P2PPlanTimeSettingCell*)cell;
//                    backImg = [UIImage imageNamed:@"bg_bar_btn_center.png"];
//                    backImg_p = [UIImage imageNamed:@"bg_bar_btn_center_p.png"];
                    backImg = [UIImage imageNamed:@""];
                    backImg_p = [UIImage imageNamed:@""];
                    self.planPicker1 = planTimeCell.picker1;
                    self.planPicker2 = planTimeCell.picker2;
                }else if(row==2){
                    P2PTimeSettingCell *timeCell = (P2PTimeSettingCell*)cell;
//                    backImg = [UIImage imageNamed:@"bg_bar_btn_bottom.png"];
//                    backImg_p = [UIImage imageNamed:@"bg_bar_btn_bottom_p.png"];
                    backImg = [UIImage imageNamed:@""];
                    backImg_p = [UIImage imageNamed:@""];
                    [timeCell setLeftLabelHidden:NO];
                    if(self.isLoadingRecordPlanTime){
                        [timeCell setRightLabelHidden:YES];
                        [timeCell setProgressViewHidden:NO];
                    }else{
                        [timeCell setRightLabelHidden:NO];
                        [timeCell setProgressViewHidden:YES];
                    }
                    [timeCell setCustomViewHidden:YES];
                    [timeCell setLeftLabelText:NSLocalizedString(@"apply", nil)];
                    [timeCell setRightLabelText:[Utils getPlanTimeByIntValue:self.planTime]];
                }
            }else if(self.recordType==SETTING_VALUE_RECORD_MANUAL){
                if(row==0){
                    P2PSwitchCell *switchCell = (P2PSwitchCell*)cell;
//                    backImg = [UIImage imageNamed:@"bg_bar_btn_single.png"];
//                    backImg_p = [UIImage imageNamed:@"bg_bar_btn_single_p.png"];
                    backImg = [UIImage imageNamed:@""];
                    backImg_p = [UIImage imageNamed:@""];
                    [switchCell setLeftLabelText:NSLocalizedString(@"remote_record_switch", nil)];
                    if(self.isLoadingRemoteRecord){
                        [switchCell setProgressViewHidden:NO];
                        [switchCell setSwitchViewHidden:YES];
                    }else{
                        [switchCell setProgressViewHidden:YES];
                        [switchCell setSwitchViewHidden:NO];
                        [switchCell.switchView addTarget:self action:@selector(onRemoteRecordChange:) forControlEvents:UIControlEventValueChanged];
                        if(self.remoteRecordState==SETTING_VALUE_REMOTE_RECORD_STATE_OFF){
                            switchCell.on = NO;
                        }else{
                            switchCell.on = YES;
                            
                        }
                    }
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


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(self.recordType==SETTING_VALUE_RECORD_TIMER&&indexPath.section==1&&indexPath.row==2){
        self.isLoadingRecordPlanTime = YES;
        [self.tableView reloadData];
        
        self.lastPlanTime = self.planTime;
        NSInteger hour_from = self.planPicker1.date.hour;
        NSInteger minute_from = self.planPicker1.date.minute;
        
        NSInteger hour_to = self.planPicker2.date.hour;
        NSInteger minute_to = self.planPicker2.date.minute;
        
        self.planTime = (int)(hour_from<<24|hour_to<<16|minute_from<<8|minute_to<<0);
        [[P2PClient sharedClient] setRecordPlanTimeWithId:self.contact.contactId password:self.contact.contactPassword time:self.planTime];
        
    }
}

-(void)onRadioRecordType1Press{
    if(!self.isLoadingRecordType&&!self.radioRecordType1.isSelected){
        [self.radioRecordType1 setSelected:YES];
        [self.radioRecordType2 setSelected:NO];
        [self.radioRecordType3 setSelected:NO];
        self.isLoadingRecordType = YES;
        
        self.lastRecordType = self.recordType;
        self.recordType = SETTING_VALUE_RECORD_MANUAL;
        [self.tableView reloadData];
        [[P2PClient sharedClient] setRecordTypeWithId:self.contact.contactId password:self.contact.contactPassword type:self.recordType];
        
    }
}

-(void)onRadioRecordType2Press{
    if(!self.isLoadingRecordType&&!self.radioRecordType2.isSelected){
        [self.radioRecordType1 setSelected:NO];
        [self.radioRecordType2 setSelected:YES];
        [self.radioRecordType3 setSelected:NO];
        self.isLoadingRecordType = YES;
        
        if(self.recordType==SETTING_VALUE_RECORD_MANUAL){
            [self.tableView reloadData];
            self.lastRecordType = self.recordType;
            self.recordType = SETTING_VALUE_RECORD_ALARM;
        }else{
            self.lastRecordType = self.recordType;
            self.recordType = SETTING_VALUE_RECORD_ALARM;
            [self.tableView reloadData];
            
        }
        
        [[P2PClient sharedClient] setRecordTypeWithId:self.contact.contactId password:self.contact.contactPassword type:self.recordType];
        
    }
}

-(void)onRadioRecordType3Press{
    if(!self.isLoadingRecordType&&!self.radioRecordType3.isSelected){
        [self.radioRecordType1 setSelected:NO];
        [self.radioRecordType2 setSelected:NO];
        [self.radioRecordType3 setSelected:YES];
        self.isLoadingRecordType = YES;
        
        if(self.recordType==SETTING_VALUE_RECORD_MANUAL){
            [self.tableView reloadData];
            self.lastRecordType = self.recordType;
            self.recordType = SETTING_VALUE_RECORD_TIMER;
        }else{
            self.lastRecordType = self.recordType;
            self.recordType = SETTING_VALUE_RECORD_TIMER;
            [self.tableView reloadData];
        }
        
        
        [[P2PClient sharedClient] setRecordTypeWithId:self.contact.contactId password:self.contact.contactPassword type:self.recordType];
        
    }
}

-(void)onRecordTimeCellRadioClick:(RadioButton *)radio index:(NSInteger)index{
    switch(index){
        case 0:
        {
            if(!self.isLoadingRecordTime&&!self.radioRecordTime1.isSelected){
                [self.radioRecordTime1 setSelected:YES];
                [self.radioRecordTime2 setSelected:NO];
                [self.radioRecordTime3 setSelected:NO];
                self.isLoadingRecordTime = YES;
                
                self.lastRecordTime = self.recordTime;
                self.recordTime = SETTING_VALUE_RECORD_TIME_ONE;
                [self.tableView reloadData];
                [[P2PClient sharedClient] setRecordTimeWithId:self.contact.contactId password:self.contact.contactPassword value:self.recordTime];
                
            }
        }
            break;
        case 1:
        {
            if(!self.isLoadingRecordTime&&!self.radioRecordTime2.isSelected){
                [self.radioRecordTime1 setSelected:NO];
                [self.radioRecordTime2 setSelected:YES];
                [self.radioRecordTime3 setSelected:NO];
                self.isLoadingRecordTime = YES;
                
                self.lastRecordTime = self.recordTime;
                self.recordTime = SETTING_VALUE_RECORD_TIME_TWO;
                [self.tableView reloadData];
                [[P2PClient sharedClient] setRecordTimeWithId:self.contact.contactId password:self.contact.contactPassword value:self.recordTime];
                
            }
        }
            break;
        case 2:
        {
            if(!self.isLoadingRecordTime&&!self.radioRecordTime3.isSelected){
                [self.radioRecordTime1 setSelected:NO];
                [self.radioRecordTime2 setSelected:NO];
                [self.radioRecordTime3 setSelected:YES];
                self.isLoadingRecordTime = YES;
                
                self.lastRecordTime = self.recordTime;
                self.recordTime = SETTING_VALUE_RECORD_TIME_THREE;
                [self.tableView reloadData];
                [[P2PClient sharedClient] setRecordTimeWithId:self.contact.contactId password:self.contact.contactPassword value:self.recordTime];
                
            }
        }
            break;
    }
}


-(void)onRemoteRecordChange:(UISwitch*)sender{
    if(self.remoteRecordState==SETTING_VALUE_REMOTE_RECORD_STATE_OFF&&sender.on){
        self.isLoadingRemoteRecord = YES;
        
        self.lastRemoteRecordState = self.remoteRecordState;
        self.remoteRecordState = SETTING_VALUE_REMOTE_RECORD_STATE_ON;
        [self.tableView reloadData];
        
        [[P2PClient sharedClient] setRemoteRecordWithId:self.contact.contactId password:self.contact.contactPassword state:self.remoteRecordState];
    }else if(self.remoteRecordState!=SETTING_VALUE_REMOTE_RECORD_STATE_OFF&&!sender.on){
        self.isLoadingRemoteRecord = YES;
        
        self.lastRemoteRecordState = self.remoteRecordState;
        self.remoteRecordState = SETTING_VALUE_REMOTE_RECORD_STATE_OFF;
        [self.tableView reloadData];
        [[P2PClient sharedClient] setRemoteRecordWithId:self.contact.contactId password:self.contact.contactPassword state:self.remoteRecordState];
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
