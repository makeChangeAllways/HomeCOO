//
//  SettingController.m
//  2cu
//
//  Created by guojunyi on 14-3-20.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import "SettingController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "UDManager.h"
#import "LoginResult.h"
#import "LoginController.h"
#import "P2PClient.h"
#import "AutoNavigation.h"
#import "CustomCell.h"
#import "ScreenshotController.h"
#import "TopBar.h"
#import "FListManager.h"
#import "AccountController.h"
#import "GlobalThread.h"
#import "YLLabel.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "ModifyLoginPasswordController.h"
#import "SettingEditController.h"
#import "SettingSystemController.h"
#import "PrefixHeader.pch"
@interface SettingController ()

@end

@implementation SettingController

-(void)dealloc{
    [self.ic_net_type_view release];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNetWorkChange:) name:NET_WORK_CHANGE object:nil];
    if([[AppDelegate sharedDefault] networkStatus]==ReachableViaWiFi){
        self.ic_net_type_view.image = [UIImage imageNamed:@"ic_net_type_wifi.png"];
    }else{
        self.ic_net_type_view.image = [UIImage imageNamed:@"ic_net_type_3g.png"];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NET_WORK_CHANGE object:nil];
}

- (void)onNetWorkChange:(NSNotification *)notification{
    NSDictionary *parameter = [notification userInfo];
    int status = [[parameter valueForKey:@"status"] intValue];
    if(status==ReachableViaWiFi){
        self.ic_net_type_view.image = [UIImage imageNamed:@"ic_net_type_wifi.png"];
    }else{
        self.ic_net_type_view.image = [UIImage imageNamed:@"ic_net_type_3g.png"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initComponent];
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    MainController *mainController = [AppDelegate sharedDefault].mainController;
    
    [mainController setBottomBarHidden:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#define SETTING_IC_HEAD_IMG_WIDTH (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 80:50)
#define SETTING_IC_HEAD_IMG_HEIGHT (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 80:50)
-(void)initComponent{
    [self.view setBackgroundColor:XBgColor];
    CGRect rect = [AppDelegate getScreenSize:YES isHorizontal:NO];
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height-TAB_BAR_HEIGHT;
    
    // 顶部导航框
    TopBar *topBar = [[TopBar alloc] initWithFrame:CGRectMake(0, 0, width, NAVIGATION_BAR_HEIGHT)];
    [topBar setTitle:NSLocalizedString(@"setting",nil)];
    [self.view addSubview:topBar];
    [topBar release];
    
    // 标题背景
//    UIImageView *bgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, BottomForView(topBar)-2, width,NAVIGATION_BAR_HEIGHT+22+SETTING_IC_HEAD_IMG_HEIGHT-BottomForView(topBar))];
    UIButton *bgview = [[UIButton alloc] initWithFrame:CGRectMake(0, BottomForView(topBar)-2, width,100)];
    [bgview setBackgroundImage:[UIImage imageNamed:@"setting_head_bg"] forState:UIControlStateNormal];
    [bgview addTarget:self action:@selector(edit_userInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bgview];
    
    
    
    //ic phone 图标
    UIImageView *ic_phone_view = [[UIImageView alloc] initWithFrame:CGRectMake(10, NAVIGATION_BAR_HEIGHT+25, SETTING_IC_HEAD_IMG_WIDTH, SETTING_IC_HEAD_IMG_HEIGHT)];
//    UIImage *ic_phone = [UIImage imageNamed:@"ic_setting_phone.png"];
    UIImage *ic_phone = [UIImage imageNamed:@"AppIcon76x76"];

    
    ic_phone_view.image = ic_phone;
    ic_phone_view.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:ic_phone_view];
    [ic_phone_view release];
    
    
    //current id
    UILabel *curIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(SETTING_IC_HEAD_IMG_WIDTH+20, NAVIGATION_BAR_HEIGHT+10, width-(SETTING_IC_HEAD_IMG_WIDTH+20)-(SETTING_IC_HEAD_IMG_WIDTH+10), SETTING_IC_HEAD_IMG_HEIGHT)];
    
    
    curIDLabel.textAlignment = NSTextAlignmentLeft;
    LoginResult *loginResult = [UDManager getLoginInfo];
    
    NSLog(@"%@",loginResult);
    if([loginResult.contactId isEqual:@"0517400"]){
        curIDLabel.text = NSLocalizedString(@"anonymous", nil);
    }else{
        curIDLabel.text = loginResult.contactId;
    }
    
    
    CGSize text_size = [self sizeWithString:curIDLabel.text font:XFontBold_18];
    
    
    curIDLabel.frame = CGRectMake(SETTING_IC_HEAD_IMG_WIDTH+20, YForView(ic_phone_view), text_size.width, text_size.height);
    
    
    curIDLabel.textColor =[UIColor whiteColor];;
    curIDLabel.backgroundColor = XBGAlpha;
    [curIDLabel setFont:XFontBold_18];
    [self.view addSubview:curIDLabel];
    [curIDLabel release];
    
//    curIDLabel.backgroundColor = [UIColor blackColor];
    
    // edit button
    UIButton *edit_btn = [[UIButton alloc] initWithFrame:CGRectMake(RightForView(curIDLabel) + 10, YForView(curIDLabel) + 3, 15, 15)];
    [self.view addSubview:edit_btn];
    edit_btn.userInteractionEnabled = NO;
    [edit_btn setBackgroundImage:[UIImage imageNamed:@"system_editor"] forState:UIControlStateNormal];
//    [edit_btn addTarget:self action:@selector(edit_userInfo) forControlEvents:UIControlEventTouchUpInside];
    
    
    // account
    
    
    UILabel *account_L = [[UILabel alloc] initWithFrame:CGRectMake(XForView(curIDLabel), BottomForView(curIDLabel)+5, 200, 18)];
    account_L.textColor=[UIColor whiteColor];
    if([loginResult.contactId isEqual:@"0517400"]){
        account_L.hidden = YES;
    }else{
        account_L.hidden = NO;
        account_L.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"account", nil),loginResult.phone];
        if (loginResult.phone.length==0) {
            account_L.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"account", nil),loginResult.email];
        }
    }
    [self.view addSubview:account_L];
    
    
    //ic net type
    UIImageView *ic_net_type_view = [[UIImageView alloc] initWithFrame:CGRectMake(width-SETTING_IC_HEAD_IMG_WIDTH-10, NAVIGATION_BAR_HEIGHT+10, SETTING_IC_HEAD_IMG_WIDTH, SETTING_IC_HEAD_IMG_HEIGHT)];
    
    if([[AppDelegate sharedDefault] networkStatus]==ReachableViaWiFi){
        ic_net_type_view.image = [UIImage imageNamed:@"ic_net_type_wifi.png"];
    }else{
        ic_net_type_view.image = [UIImage imageNamed:@"ic_net_type_3g.png"];
    }
    
    
    ic_net_type_view.contentMode = UIViewContentModeScaleAspectFit;
    self.ic_net_type_view = ic_net_type_view;
    [self.view addSubview:self.ic_net_type_view];
    [ic_net_type_view release];
    
    
    UIImageView *sep_view = [[UIImageView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT+20+SETTING_IC_HEAD_IMG_HEIGHT, width, 1)];
    sep_view.hidden=YES;
    UIImage *sep = [UIImage imageNamed:@"separator_horizontal.png"];
    sep_view.image = sep;
    [self.view addSubview:sep_view];
    [sep_view release];
    
    
//     UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT+SETTING_IC_HEAD_IMG_HEIGHT+1+20, width, height-(NAVIGATION_BAR_HEIGHT+SETTING_IC_HEAD_IMG_HEIGHT+20+1)) style:UITableViewStyleGrouped];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, BottomForView(bgview)-10, width, height-BottomForView(bgview)+10) style:UITableViewStyleGrouped];
    [tableView setBackgroundColor:XBGAlpha];
    tableView.backgroundView = nil;
//    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    [tableView release];
    
    self.ic_net_type_view.hidden=YES;
    tableView.scrollEnabled=NO;
    
}


#pragma mark - edit_btn
-(void)edit_userInfo
{
//    SettingEditController *set_edit = [[SettingEditController alloc] init];
//    [self.navigationController pushViewController:set_edit animated:YES];
    
    AccountController *accountController = [[AccountController alloc] init];
    [self.navigationController pushViewController:accountController animated:YES];
}



#pragma mark - tableView DataResource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
     
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if(section == 0){
//        LoginResult *loginResult = [UDManager getLoginInfo];
//        if([loginResult.contactId isEqual:@"0517400"]){
//            return 1;
//        }else{
//            return 2;
//        }
//        
//    }else if(section == 1){
//        return 1;
//    }
//    return 0;
    if(section == 0){
        return 2; // 修改更新
        
    }else if(section == 1){
        return 1;
    }
    return 0;

}
     
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"SettingCell";
//    CGRect rect = [AppDelegate getScreenSize:YES isHorizontal:NO];
//    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if(cell==nil){
//        cell = [[[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
//        [cell setBackgroundColor:XBGAlpha];
//       
//
//    }
//   
//    int section = indexPath.section;
//    int row = indexPath.row;
//    UIImage *backImg;
//    UIImage *backImg_p;
//    
//
//     
//    [cell setRightIcon:@"ic_arrow.png"];
//    
//    
//    switch (section) {
//        case 0:
//        {
//            LoginResult *loginResult = [UDManager getLoginInfo];
//            if([loginResult.contactId isEqual:@"0517400"]){
//                if(row==0){
//                    backImg = [UIImage imageNamed:@"bg_bar_btn_single.png"];
//                    backImg_p = [UIImage imageNamed:@"bg_bar_btn_single_p.png"];
//                    [cell setLeftIcon:@"ic_setting_about.png"];
//                    [cell setLabelText:NSLocalizedString(@"about_us", nil)];
////                    backImg = [UIImage imageNamed:@"bg_bar_btn_top.png"];
////                    backImg_p = [UIImage imageNamed:@"bg_bar_btn_top_p.png"];
////                    [cell setLeftIcon:@"ic_setting_update.png"];
////                    [cell setLabelText:NSLocalizedString(@"check_update", nil)];
//                    
//                }
////                else if(row==1){
////                    backImg = [UIImage imageNamed:@"bg_bar_btn_bottom.png"];
////                    backImg_p = [UIImage imageNamed:@"bg_bar_btn_bottom_p.png"];
////                    [cell setLeftIcon:@"ic_setting_about.png"];
////                    [cell setLabelText:NSLocalizedString(@"about_us", nil)];
////                }
//            }else{
//                if(row==0){
//                    backImg = [UIImage imageNamed:@"bg_bar_btn_top.png"];
//                    backImg_p = [UIImage imageNamed:@"bg_bar_btn_top_p.png"];
//                    [cell setLeftIcon:@"ic_setting_account.png"];
//                    [cell setLabelText:NSLocalizedString(@"account_info", nil)];
//                    
//                }else if(row==1){
//                    backImg = [UIImage imageNamed:@"bg_bar_btn_bottom.png"];
//                    backImg_p = [UIImage imageNamed:@"bg_bar_btn_bottom_p.png"];
//                    [cell setLeftIcon:@"ic_setting_about.png"];
//                    [cell setLabelText:NSLocalizedString(@"about_us", nil)];
////                    backImg = [UIImage imageNamed:@"bg_bar_btn_center.png"];
////                    backImg_p = [UIImage imageNamed:@"bg_bar_btn_center_p.png"];
////                    [cell setLeftIcon:@"ic_setting_update.png"];
////                    [cell setLabelText:NSLocalizedString(@"check_update", nil)];
//                }
////                else if(row==2){
////                    backImg = [UIImage imageNamed:@"bg_bar_btn_bottom.png"];
////                    backImg_p = [UIImage imageNamed:@"bg_bar_btn_bottom_p.png"];
////                    [cell setLeftIcon:@"ic_setting_about.png"];
////                    [cell setLabelText:NSLocalizedString(@"about_us", nil)];
////                }
//            }
//            
//        }
//            break;
//        case 1:
//        {
//            if(row==0){
//                backImg = [UIImage imageNamed:@"bg_bar_btn_single.png"];
//                backImg_p = [UIImage imageNamed:@"bg_bar_btn_single_p.png"];
//                
//                [cell setLeftIcon:@"ic_setting_logout.png"];
//                [cell setLabelText:NSLocalizedString(@"logout", nil)];
//            }
////            else if(row==1){
////                
////                backImg = [UIImage imageNamed:@"bg_bar_btn_bottom.png"];
////                backImg_p = [UIImage imageNamed:@"bg_bar_btn_bottom_p.png"];
////
////                [cell setLeftIcon:@"ic_setting_exit.png"];
////                [cell setLabelText:NSLocalizedString(@"exit", nil)];
////            }
//            
//        }
//            break;
//        
//    }
//    
//    
//    
//    UIImageView *backImageView = [[UIImageView alloc] init];
//
//
//
//    backImg = [backImg stretchableImageWithLeftCapWidth:backImg.size.width*0.5 topCapHeight:backImg.size.height*0.5];
//    backImageView.image = backImg;
//    [cell setBackgroundView:backImageView];
//    [backImageView release];
//    
//    UIImageView *backImageView_p = [[UIImageView alloc] init];
//    
//    backImg_p = [backImg_p stretchableImageWithLeftCapWidth:backImg_p.size.width*0.5 topCapHeight:backImg_p.size.height*0.5];
//    backImageView_p.image = backImg_p;
//    [cell setSelectedBackgroundView:backImageView_p];
//    [backImageView_p release];

    
    static NSString *more=@"11";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:more];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:more];
        cell.textLabel.textAlignment=NSTextAlignmentLeft;
        cell.backgroundColor=[UIColor whiteColor];
        
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        UILabel*label1=[[UILabel alloc]init];
        [cell.contentView addSubview:label1];
        label1.tag=111;
        
        UIImageView*lineview=[[UIImageView alloc]init];
        [cell.contentView addSubview:lineview];
        lineview.tag=999;
        
    }
    
    int section = indexPath.section;
    
    
//     NSArray * btnTitles = @[NSLocalizedString(@"check_update", nil),NSLocalizedString(@"about_us", nil),NSLocalizedString(@"modify_password", nil)]; // 修改更新
    
    NSArray * btnTitles = @[NSLocalizedString(@"about_us", nil),NSLocalizedString(@"modify_password", nil)];
     NSArray * btnTitles1 = @[NSLocalizedString(@"logout", nil)];
    
    if (section==0) {
        
        UILabel*title=(UILabel *)[cell viewWithTag:111];
        title.frame=CGRectMake(30, 0,200,40);
        title.textAlignment=NSTextAlignmentLeft;
        title.text=[btnTitles objectAtIndex:indexPath.row];
        
         UIImageView*img=(UIImageView *)[cell viewWithTag:999];
        img.backgroundColor=[UIColor grayColor];
        img.frame=CGRectMake(0, 39,VIEWWIDTH,0.5);
        
        
        
    } if (section==1) {
        
        UILabel*title=(UILabel *)[cell viewWithTag:111];
        title.frame=CGRectMake(30, 0,200,40);
        title.textAlignment=NSTextAlignmentLeft;
        title.text=[btnTitles1 objectAtIndex:indexPath.row];
    }
    return cell;
}
     
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    int section = indexPath.section;
    int row = indexPath.row;
    switch(section){
        case 0:
        {
            LoginResult *loginResult = [UDManager getLoginInfo];
            if([loginResult.contactId isEqual:@"0517400"]){
                if(row==0){
//                    MBProgressHUD * hud = [[MBProgressHUD alloc]initWithView:self.view];
//                    hud.labelText = NSLocalizedString(@"loading", nil);
//                    [self.view addSubview:hud];
//                    hud.delegate  = self;
//                    [hud show:YES];
//                    
//                    
//                    //2cu680995913,889807261,2cuX 905849946
//                    NSString *urlString = [[NSString alloc] initWithFormat:@"http://itunes.apple.com/lookup?id=680995913"];
//                    NSURL *url = [[NSURL alloc] initWithString:urlString];
//                    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
//                    DLog(@"%@", urlString);
//                    
//                    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue ] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//                        if ((!error)) {
//                            NSError *parseError;
//                            id appMetaDataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseError];
//                            if (appMetaDataDictionary) {
//                                NSArray *results = [appMetaDataDictionary objectForKey:@"results"];
//                                NSArray *remoteVersionArr = [results valueForKey:@"version"];
//                                [hud hide:YES];
//
//                                if([remoteVersionArr count]==0){
//                                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"latest_version", nil)
//                                                                                    message:nil
//                                                                                   delegate:self
//                                                                          cancelButtonTitle:NSLocalizedString(@"ok", nil)
//                                                                          otherButtonTitles:nil, nil];
//                                    [alert show];
//                                    [alert release];
//                                    return;
//                                }
//                                NSString *remoteVersion = [remoteVersionArr objectAtIndex:0];
//                                NSString *localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)@"CFBundleShortVersionString"];
//                                [hud hide:YES];
//
//                                
//                                
//                                UIAlertView *updataAlertDiag;
//                                
//                                if ( remoteVersion && ([localVersion floatValue]<[remoteVersion floatValue]) ) {
//                                    updataAlertDiag = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"release_new_version", nil)
//                                                                                 message:NSLocalizedString(@"ask_update_immediately", nil)
//                                                                                delegate:self
//                                                                       cancelButtonTitle:NSLocalizedString(@"remain_me", nil)
//                                                                       otherButtonTitles:NSLocalizedString(@"update_me", nil),NSLocalizedString(@"rate_me", nil), nil];
//                                } else {
//                                    updataAlertDiag = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"latest_version", nil)
//                                                                                 message:nil
//                                                                                delegate:nil
//                                                                       cancelButtonTitle:NSLocalizedString(@"ok", nil)
//                                                                       otherButtonTitles: nil];
//                                }
//                                [updataAlertDiag setTag:ALERT_TAG_UPDATE];
//                                [updataAlertDiag show];
//                                [updataAlertDiag release];
//                                [hud release];
//                            }
//                        }
//                        
//                    }];
                    
                    [self showAboutDialog];
                }
//                else if(row==1){
//                    [self showAboutDialog];
//                }
            }else{
//                if(row==0){
////                    AccountController *accountController = [[AccountController alloc] init];
////                    [self.navigationController pushViewController:accountController animated:YES];
////                    [accountController release];
//                    
//                    SettingSystemController *system_controller = [[SettingSystemController alloc] init];
//                    [self.navigationController pushViewController:system_controller animated:YES];
//                    
//                    
//                }else
                
                
                /* // 修改更新
                    if(row==0){
                    MBProgressHUD * hud = [[MBProgressHUD alloc]initWithView:self.view];
                    hud.labelText = NSLocalizedString(@"loading", nil);
                    [self.view addSubview:hud];
                    hud.delegate  = self;
                    [hud show:YES];
                    
                    
                    //2cu680995913,889807261,2cuX 905849946
                    NSString *urlString = [[NSString alloc] initWithFormat:@"http://itunes.apple.com/lookup?id=960120443"];
                    NSURL *url = [[NSURL alloc] initWithString:urlString];
                    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
                    DLog(@"%@", urlString);
                    
                    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue ] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                        if ((!error)) {
                            NSError *parseError;
                            id appMetaDataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseError];
                            if (appMetaDataDictionary) {
                                NSArray *results = [appMetaDataDictionary objectForKey:@"results"];
                                NSArray *remoteVersionArr = [results valueForKey:@"version"];
                                [hud hide:YES];

                                if([remoteVersionArr count]==0){
                                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"latest_version", nil)
                                                                                    message:nil
                                                                                   delegate:self
                                                                          cancelButtonTitle:NSLocalizedString(@"ok", nil)
                                                                          otherButtonTitles:nil, nil];
                                    [alert show];
                                    [alert release];
                                    return;
                                }
                                NSString *remoteVersion = [remoteVersionArr objectAtIndex:0];
                                NSString *localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)@"CFBundleShortVersionString"];
                                [hud hide:YES];

                                
                                UIAlertView *updataAlertDiag;
                                
                                if ( remoteVersion && ([localVersion floatValue]<[remoteVersion floatValue]) ) {
                                    updataAlertDiag = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"release_new_version", nil)
                                                                                 message:NSLocalizedString(@"ask_update_immediately", nil)
                                                                                delegate:self
                                                                       cancelButtonTitle:NSLocalizedString(@"remain_me", nil)
                                                                       otherButtonTitles:NSLocalizedString(@"update_me", nil),NSLocalizedString(@"rate_me", nil), nil];
                                } else {
                                    updataAlertDiag = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"latest_version", nil)
                                                                                 message:nil
                                                                                delegate:nil
                                                                       cancelButtonTitle:NSLocalizedString(@"ok", nil)
                                                                       otherButtonTitles: nil];
                                }
                                [updataAlertDiag setTag:ALERT_TAG_UPDATE];
                                [updataAlertDiag show];
                                [updataAlertDiag release];
                                [hud release];
                            }
                        }
                        
                    }];
                    
//                    [self showAboutDialog];
                }
                else
                 
                 */
                    
                    if(row==0){  // 修改更新
                    [self showAboutDialog];
                
                }else if(row==1){ // 修改更新
                    ModifyLoginPasswordController *modifyLoginPasswordController = [[ModifyLoginPasswordController alloc] init];
                    [self.navigationController pushViewController:modifyLoginPasswordController animated:YES];
                    [modifyLoginPasswordController release];
                }
            }
            
        }
            break;
        case 1:
        {
            if(row==0){
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"logout_prompt", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"ok", nil), nil];
                alert.tag = ALERT_TAG_LOGOUT;
                [alert show];
                [alert release];
            }
//            else if(row==1){
//                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"exit_prompt", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"ok", nil), nil];
//                alert.tag = ALERT_TAG_EXIT;
//                [alert show];
//                [alert release];
//            }
        }
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return BAR_BUTTON_HEIGHT;
     return 40;
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch(alertView.tag){
        case ALERT_TAG_EXIT:
        {
            if(buttonIndex==1){
                
            }
        }
            break;
        case ALERT_TAG_LOGOUT:
        {
            if(buttonIndex==1){
                [UDManager setIsLogin:NO];
                
                [[GlobalThread sharedThread:NO] kill];
                [[FListManager sharedFList] setIsReloadData:YES];
                [[UIApplication sharedApplication] unregisterForRemoteNotifications];
                LoginController *loginController = [[LoginController alloc] init];
                AutoNavigation *mainController = [[AutoNavigation alloc] initWithRootViewController:loginController];
                
               // self.view.window.rootViewController = mainController;
                [loginController release];
                [mainController release];
                
                //APP将返回登录界面时，注册新的token，登录时传给服务器
                [[AppDelegate sharedDefault] reRegisterForRemoteNotifications];
                
                dispatch_queue_t queue = dispatch_queue_create(NULL, NULL);
                dispatch_async(queue, ^{
                    [[P2PClient sharedClient] p2pDisconnect];
                    DLog(@"p2pDisconnect.");
                });
                
            }
        }
            break;
        case ALERT_TAG_UPDATE:
        {
            if (buttonIndex==1) {
                NSString *iTunesUrl = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/k10bao-jing-she-xiang-ji/id960120443?l=en&mt=8"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesUrl]];
                DLog(@"%@", iTunesUrl);
            }else if (buttonIndex==2){
                NSString *iTunesUrl = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=960120443"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesUrl]];
                DLog(@"%@", iTunesUrl);
            }
        }
            break;
    }
}

#define CONNECT_VIEW_LEFT_RIGHT_MARGIN 20
#define CONNECT_VIEW_TITLE_HEIGHT 32

-(void)showAboutDialog{

    if(self.aboutView==nil){
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        UIView *view = [[UIView alloc] init];
        view.tag = 100;
        [view setBackgroundColor:XWhite]; // bg color  XWhite
        
        [view.layer setShadowOffset:CGSizeMake(1, 1)];  // view shadow
        [view.layer setShadowColor:[XBlack CGColor]];
        [view.layer setShadowOpacity:1.0];
        
        view.layer.borderWidth = 0.5f; // border width
        view.layer.borderColor = [UIColor lightGrayColor].CGColor; // border color
        
        view.layer.cornerRadius = 5.0; // radius corner
        [view setClipsToBounds:YES];
        CGFloat viewHeight = 0;
        if([language hasPrefix:@"zh"]){
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                viewHeight = 160;
            }else{
                viewHeight = 170;
            }
        }else{
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                viewHeight = 230;
            }else{
                viewHeight = 250;
            }
        }
        
        view.frame = CGRectMake(CONNECT_VIEW_LEFT_RIGHT_MARGIN, (self.view.frame.size.height-viewHeight)/2, self.view.frame.size.width-CONNECT_VIEW_LEFT_RIGHT_MARGIN*2, viewHeight);
        
        // 标题 版本
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,100,CONNECT_VIEW_TITLE_HEIGHT)];
        
        title.textAlignment = NSTextAlignmentLeft;
        title.backgroundColor = XBGAlpha;
        title.textColor = XBlue;
        title.font = XFontBold_18;
        title.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"about", nil)];
        
        [view addSubview:title];
        [title release];
        
        UILabel *version = [[UILabel alloc] init];
        version.frame = CGRectMake((self.view.frame.size.width-CONNECT_VIEW_LEFT_RIGHT_MARGIN*2) - 10 - 200, 0, 200, CONNECT_VIEW_TITLE_HEIGHT);
        version.textAlignment = NSTextAlignmentRight;
        version.backgroundColor = XBGAlpha;
        version.textColor = XBlue;
        version.font = XFontBold_18;
        version.text = @"1.1";
        
        [view addSubview:version];
        [version release];
        
        
        
        
        UIImageView *seperator = [[UIImageView alloc] initWithFrame:CGRectMake(0, CONNECT_VIEW_TITLE_HEIGHT, view.frame.size.width, 1)];
        [seperator setBackgroundColor:XBlue];
        [view addSubview:seperator];
        [seperator release];
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor lightGrayColor];
        label.font = XFontBold_16;
        label.numberOfLines = 0;
        
        CGSize size = [NSLocalizedString(@"about_text", nil) boundingRectWithSize:CGSizeMake(view.frame.size.width-10, 600) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: label.font} context:nil].size;
        label.frame=CGRectMake(5,CONNECT_VIEW_TITLE_HEIGHT+5,size.width,size.height);
//        label.backgroundColor = XBGAlpha;

//        label.text = NSLocalizedString(@"about_text", nil);
        [label setText:NSLocalizedString(@"about_text", nil)];
        [label setTextColor:[UIColor lightGrayColor]];
        
        [view addSubview:label];
        
        UIView *layerView = [[UIView alloc] init];
        layerView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        layerView.backgroundColor = XBGAlpha;
        [layerView addSubview:view];
        
        [self.view addSubview:layerView];
        
        
        UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAboutDialog)];
        [singleTap1 setNumberOfTapsRequired:1];
        [view addGestureRecognizer:singleTap1];
        
        UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAboutDialog)];
        [singleTap2 setNumberOfTapsRequired:1];
        [layerView addGestureRecognizer:singleTap2];
        
        
        [layerView release];
        [view release];
        [label release];
        
        
        self.aboutView = layerView;
        
        
    }
    
    
    [self.aboutView setHidden:NO];
    UIView *view = [self.aboutView viewWithTag:100];
    view.transform = CGAffineTransformMakeScale(1, 0.1);
    [UIView transitionWithView:view duration:0.1 options:UIViewAnimationCurveEaseInOut
                    animations:^{
                        CGAffineTransform transform1 = CGAffineTransformScale(view.transform, 1, 10);
                        view.transform = transform1;
                    }
                    completion:^(BOOL finished){
                        
                    }
     ];
}

//  计算字符宽高
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(VIEWWIDTH - 20, MAXFLOAT)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    
    return rect.size;
}




-(void)hideAboutDialog{
    UIView *view = [self.aboutView viewWithTag:100];
    [UIView transitionWithView:view duration:0.2 options:UIViewAnimationCurveEaseInOut
                    animations:^{
                        
                        CGAffineTransform transform1 = CGAffineTransformScale(view.transform, 1, 0.1);
                        view.transform = transform1;
                    }
                    completion:^(BOOL finished){
                        [self.aboutView setHidden:YES];
                    }
     ];
    
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
