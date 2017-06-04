//
//  SecuritySettingController.m
//  2cu
//
//  Created by guojunyi on 14-5-14.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import "SecuritySettingController.h"
#import "P2PClient.h"
#import "Constants.h"
#import "Toast+UIView.h"
#import "P2PSettingCell.h"
#import "Contact.h"
#import "AppDelegate.h"
#import "TopBar.h"
#import "ModifyDevicePasswordController.h"
#import "ModifyVisitorPasswordController.h"
#import "P2PSwitchCell.h"
#import "P2PSettingHeader.h"
#import "P2PStringNew.h"
#import "PrefixHeader.pch"

@interface SecuritySettingController ()<HeaderViewDelegate>

@end

@implementation SecuritySettingController

-(void)dealloc{
    [self.tableView release];
    [self.autoUpdateSwitch release];
    [self.contact release];
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

-(void)viewDidAppear:(BOOL)animated{
    DLog(@"%@",self.contact.contactPassword);
    [self.tableView reloadData];
    
}

-(void)viewWillAppear:(BOOL)animated{
    if(!self.isFirstLoadingCompolete){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRemoteMessage:) name:RECEIVE_REMOTE_MESSAGE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ack_receiveRemoteMessage:) name:ACK_RECEIVE_REMOTE_MESSAGE object:nil];
        self.isLoadingAutoUpdate = YES;
        self.autoUpdateState = SETTING_VALUE_AUTO_UPDATE_STATE_OFF;
        
        [[P2PClient sharedClient] getNpcSettingsWithId:self.contact.contactId password:self.contact.contactPassword];
        self.isFirstLoadingCompolete = !self.isFirstLoadingCompolete;
    }
    
}


- (void)receiveRemoteMessage:(NSNotification *)notification{
    NSDictionary *parameter = [notification userInfo];
    int key   = [[parameter valueForKey:@"key"] intValue];
    switch(key){
            
        case RET_GET_NPCSETTINGS_AUTO_UPDATE:
        {
            NSInteger state = [[parameter valueForKey:@"state"] intValue];
            self.isSupportAutoUpdate = YES;
            self.autoUpdateState = state;
            self.lastAutoUpdateState = state;
            self.isLoadingAutoUpdate = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                //usleep(500000);
                [self.tableView reloadData];
            });
            DLog(@"auto update state:%i",state);
            
        }
            break;
        case RET_SET_DEVICE_PASSWORD:
        {
            
            NSInteger result = [[parameter valueForKey:@"result"] intValue];
            
            if(result==0){
                
                self.contact.contactPassword = self.lastSetNewPassowrd;
                [[FListManager sharedFList] update:self.contact];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.progressAlert hide:YES];
                    [self.view makeToast:NSLocalizedString(@"operator_success", nil)];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        usleep(800000);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self onBackPress];
                        });
                    });
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.progressAlert hide:YES];
                    
                    [self.view makeToast:NSLocalizedString(@"operator_failure", nil)];
                });
            }
        }
            break;
        case RET_SET_VISITOR_PASSWORD:
        {
            
            NSInteger result = [[parameter valueForKey:@"result"] intValue];
            
            if(result==0){
                
                //self.contact.contactPassword = self.lastSetNewPassowrd;
                //[[FListManager sharedFList] update:self.contact];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.progressAlert hide:YES];
                    [self.view makeToast:NSLocalizedString(@"operator_success", nil)];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        usleep(800000);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self onBackPress];
                        });
                    });
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.progressAlert hide:YES];
                    
                    [self.view makeToast:NSLocalizedString(@"operator_failure", nil)];
                });
            }
        }
            break;


        
        case RET_SET_NPCSETTINGS_AUTO_UPDATE:
        {
            NSInteger result = [[parameter valueForKey:@"result"] intValue];
            self.isLoadingAutoUpdate = NO;
            if(result==0){
                self.lastAutoUpdateState = self.autoUpdateState;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [self.view makeToast:NSLocalizedString(@"operator_success", nil)];
                });
                
            }else{
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(self.lastAutoUpdateState==SETTING_VALUE_AUTO_UPDATE_STATE_ON){
                        self.autoUpdateState = self.lastAutoUpdateState;
                        self.autoUpdateSwitch.on = YES;
                        
                    }else if(self.lastAutoUpdateState==SETTING_VALUE_AUTO_UPDATE_STATE_OFF){
                        self.autoUpdateState = self.lastAutoUpdateState;
                        self.autoUpdateSwitch.on = NO;
                    }
                    [self.tableView reloadData];
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
            
        case ACK_RET_SET_NPCSETTINGS_AUTO_UPDATE:
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
                    DLog(@"resend set auto update state");
                    [[P2PClient sharedClient] setMotionWithId:self.contact.contactId password:self.contact.contactPassword state:self.autoUpdateState];
                }
                
                
            });
            
            
            
            
            
            DLog(@"ACK_RET_SET_NPCSETTINGS_AUTO_UPDATE:%i",result);
        }
            break;
        case ACK_RET_SET_DEVICE_PASSWORD:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(result==1){
                    [self.progressAlert hide:YES];
                    [self.view makeToast:NSLocalizedString(@"original_password_error", nil)];
                    
                }else if(result==2){
                    DLog(@"resend set device password");
                    [[P2PClient sharedClient] setDevicePasswordWithId:self.contact.contactId password:self.lastSetOriginPassowrd newPassword:self.lastSetNewPassowrd];
                }
                
                
            });
            
            
            
            
            
            DLog(@"ACK_RET_SET_DEVICE_PASSWORD:%i",result);
        }
            break;
        case ACK_RET_SET_VISITOR_PASSWORD:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(result==1){
                    [self.progressAlert hide:YES];
                    [self.view makeToast:NSLocalizedString(@"device_password_error", nil)];
                    
                }else if(result==2){
                    DLog(@"resend set visitor password");
                    [[P2PClient sharedClient] setVisitorPasswordWithId:self.contact.contactId password:self.contact.contactPassword newPassword:self.lastSetNewPassowrd2];
                }
                
                
            });
            
            DLog(@"ACK_RET_SET_VISITOR_PASSWORD:%i",result);
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
    [topBar setTitle:NSLocalizedString(@"security_set",nil)];
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
    
    self.progressAlert = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
    [self.view addSubview:self.progressAlert];


}

-(void)onBackPress{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RECEIVE_REMOTE_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ACK_RECEIVE_REMOTE_MESSAGE object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (_manageisOpen == NO) {
            return 0;
        }else{
            return 1;
        }
    } else {
        if (_accessisOpen == NO) {
            return 0;
        }else{
            return 1;
        }
    }
}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 10;
//    
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return BAR_BUTTON_HEIGHT;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 && indexPath.section == 0) {
        return 190;
    }else{
        return 95;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    P2PStringNew *cell;
    if(indexPath.section == 0){
        cell = [P2PStringNew p2pstringnewmanager:self.tableView];
        [cell fill];
        [cell.oldpassword setDelegate:self];
        [cell.newpassword setDelegate:self];
        [cell.repassword setDelegate:self];
        self.oldtf=cell.oldpassword;
        self.newtf=cell.newpassword;
        self.retf=cell.repassword;
        [cell.savebutton addTarget:self action:@selector(gosave1:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        cell = [P2PStringNew p2pstringnewvisitor:self.tableView];
        [cell fill2];
        [cell.savebutton addTarget:self action:@selector(gosave2:) forControlEvents:UIControlEventTouchUpInside];
        cell.visitorpassword.delegate=self;
        self.vistf=cell.visitorpassword;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //回收键盘,取消第一响应者
    [textField resignFirstResponder]; return YES;
    
}
-(void)gosave1:(id)sender{
    
    NSString *originalPassword = self.oldtf.text;
    NSString *newPassword = self.newtf.text;
    NSString *confirmPassword = self.retf.text;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0-9]*$"];
    
    if(!originalPassword||!originalPassword.length>0){
        [self.view makeToast:NSLocalizedString(@"input_original_password", nil)];
        return;
    }
    
    if([predicate evaluateWithObject:originalPassword]==NO){
        [self.view makeToast:NSLocalizedString(@"password_number_format_error", nil)];
        return;
    }
    
    if(!newPassword||!newPassword.length>0){
        [self.view makeToast:NSLocalizedString(@"input_new_password", nil)];
        return;
    }
    if([predicate evaluateWithObject:newPassword]==NO){
        [self.view makeToast:NSLocalizedString(@"password_number_format_error", nil)];
        return;
    }
    
    if([newPassword characterAtIndex:0]=='0'){
        [self.view makeToast:NSLocalizedString(@"password_zero_format_error", nil)];
        return;
    }
    
    if(newPassword.length>10){
        [self.view makeToast:NSLocalizedString(@"device_password_too_long", nil)];
        return;
    }
    
    if(!confirmPassword||!confirmPassword.length>0){
        [self.view makeToast:NSLocalizedString(@"confirm_input", nil)];
        return;
    }
    
    if(![newPassword isEqualToString:confirmPassword]){
        [self.view makeToast:NSLocalizedString(@"two_passwords_not_match", nil)];
        return;
    }
    
    self.progressAlert.dimBackground = YES;
    [self.progressAlert show:YES];
    self.lastSetNewPassowrd = newPassword;
    self.lastSetOriginPassowrd = originalPassword;
    [[P2PClient sharedClient] setDevicePasswordWithId:self.contact.contactId password:originalPassword newPassword:newPassword];

}
-(void)gosave2:(id)sender{       //设置访客密码

    NSString *newPassword = self.vistf.text;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0-9]*$"];
    
    if(!newPassword||!newPassword.length>0){
        [self.view makeToast:NSLocalizedString(@"input_new_visitor_password", nil)];
        return;
    }
    
    
    if([predicate evaluateWithObject:newPassword]==NO){
        [self.view makeToast:NSLocalizedString(@"password_number_format_error", nil)];
        return;
    }
    
    if([newPassword characterAtIndex:0]=='0'){
        [self.view makeToast:NSLocalizedString(@"password_zero_format_error", nil)];
        return;
    }
    
    if(newPassword.length>10){
        [self.view makeToast:NSLocalizedString(@"device_password_too_long", nil)];
        return;
    }
    
    
    
    self.progressAlert.dimBackground = YES;
    [self.progressAlert show:YES];
    self.lastSetNewPassowrd2 = newPassword;
    
    [[P2PClient sharedClient] setVisitorPasswordWithId:self.contact.contactId password:self.contact.contactPassword newPassword:newPassword];

}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.3f animations:^{
        self.view.frame=CGRectMake(0, self.view.frame.origin.y-100, VIEWWIDTH,  VIEWHEIGHT);
    }];


}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.3f animations:^{
        self.view.frame=CGRectMake(0, 0, VIEWWIDTH,  VIEWHEIGHT);
    }];

}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==2){
        return NO;
    }else{
        return YES;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    if (indexPath.section == 0) {
//        _manageisOpen = !_manageisOpen;
//    }else{
//        _accessisOpen = !_accessisOpen;
//    }
//    [self.tableView reloadData];
//    
//    P2PSettingCell *cell = (P2PSettingCell*)[_tableView cellForRowAtIndexPath:indexPath];
//    
//    
//    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    P2PSettingHeader *headerView = [P2PSettingHeader headerViewWithTableView:self.tableView];
    headerView.delegate=self;
    if(section == 0){
        
        self.imageview1 = [[UIImageView alloc] initWithFrame:CGRectMake(VIEWWIDTH-30, 20, 20, 8)];
        [headerView.button addSubview:self.imageview1];
        self.imageview1.image=[UIImage imageNamed:@"call_guan"];
        [headerView setName:NSLocalizedString(@"modify_manager_password",nil)];
        if (self.manageisOpen) {
             self.imageview1.image=[UIImage imageNamed:@"call_open"];
        }else{
            self.imageview1.image=[UIImage imageNamed:@"call_guan"];
        }
        
    }else{
        self.imageview2 = [[UIImageView alloc] initWithFrame:CGRectMake(VIEWWIDTH-30, 20, 20, 8)];
        [headerView.button addSubview:self.imageview2];
        self.imageview2.image=[UIImage imageNamed:@"call_guan"];
        if (self.accessisOpen) {
            self.imageview2.image=[UIImage imageNamed:@"call_open"];
        }else{
            self.imageview2.image=[UIImage imageNamed:@"call_guan"];
        }
        [headerView setName:NSLocalizedString(@"modify_visitor_password",nil)];
    }
    return headerView;
}

-(void)headerViewDidClickBtn:(UITableViewHeaderFooterView *)view{
    P2PSettingHeader *header = (P2PSettingHeader*)view;
    if (header.flag == 0) {
        NSLog(@"%@",NSLocalizedString(@"modify_manager_password",nil));
        _manageisOpen = !_manageisOpen;
    }else{
        NSLog(@"%@",NSLocalizedString(@"modify_visitor_password",nil));
        _accessisOpen = !_accessisOpen;
    }
    [self.tableView reloadData];
}

-(void)onAutoUpdateChange:(UISwitch*)sender{
    if(self.autoUpdateState==SETTING_VALUE_AUTO_UPDATE_STATE_OFF&&sender.on){
        self.isLoadingAutoUpdate = YES;
        
        self.lastAutoUpdateState = self.autoUpdateState;
        self.autoUpdateState = SETTING_VALUE_AUTO_UPDATE_STATE_ON;
        [self.tableView reloadData];
        [[P2PClient sharedClient] setAutoUpdateWithId:self.contact.contactId password:self.contact.contactPassword state:self.autoUpdateState];
    }else if(self.autoUpdateState==SETTING_VALUE_AUTO_UPDATE_STATE_ON&&!sender.on){
        self.isLoadingAutoUpdate = YES;
        
        self.lastAutoUpdateState = self.autoUpdateState;
        self.autoUpdateState = SETTING_VALUE_AUTO_UPDATE_STATE_OFF;
        [self.tableView reloadData];
        [[P2PClient sharedClient] setAutoUpdateWithId:self.contact.contactId password:self.contact.contactPassword state:self.autoUpdateState];
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
