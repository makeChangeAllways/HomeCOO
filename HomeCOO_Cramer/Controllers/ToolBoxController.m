//
//  ToolBoxController.m
//  2cu
//
//  Created by Jie on 14-7-22.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import "ToolBoxController.h"
#import "TopBar.h"
#import "AppDelegate.h"
#import "CustomCell.h"
#import "ScreenshotController.h"
#import "DiscoverController.h"
#import "InfraredRemoteController.h"
#import "QRCodeController.h"
#import "ShakeController.h"
#import "SmartKeyController.h"
#import "AlarmHistoryController.h"
@interface ToolBoxController ()

@end

@implementation ToolBoxController

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


-(void)initComponent{
    [self.view setBackgroundColor:XBgColor];
    CGRect rect = [AppDelegate getScreenSize:YES isHorizontal:NO];
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height-TAB_BAR_HEIGHT;
    
    TopBar *topBar = [[TopBar alloc] initWithFrame:CGRectMake(0, 0, width, NAVIGATION_BAR_HEIGHT)];
    [topBar setTitle:NSLocalizedString(@"toolbox",nil)];
    [self.view addSubview:topBar];
    [topBar release];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, width, height-NAVIGATION_BAR_HEIGHT) style:UITableViewStyleGrouped];
    [tableView setBackgroundColor:XBGAlpha];
    tableView.backgroundView = nil;
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    [tableView release];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    if(section == 0){
        return 3;
    }else if(section == 1){
        return 2;
    }
    return 0;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return BAR_BUTTON_HEIGHT;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ToolBoxCell";
    CGRect rect = [AppDelegate getScreenSize:YES isHorizontal:NO];
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell==nil){
        cell = [[[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        [cell setBackgroundColor:XBGAlpha];
        
    }
    
    int section = indexPath.section;
    int row = indexPath.row;
    UIImage *backImg;
    UIImage *backImg_p;
    
    
    [cell setRightIcon:@"ic_arrow.png"];
    
    
    switch (section) {
        case 0:
        {
            if(row==0){
                backImg = [UIImage imageNamed:@"bg_bar_btn_top.png"];
                backImg_p = [UIImage imageNamed:@"bg_bar_btn_top_p.png"];
                [cell setLeftIcon:@"ic_bar_left_shake.png"];
                [cell setLabelText:NSLocalizedString(@"discover", nil)];
                
            }else if(row==1){
                backImg = [UIImage imageNamed:@"bg_bar_btn_center.png"];
                backImg_p = [UIImage imageNamed:@"bg_bar_btn_center_p.png"];
//                [cell setLeftIcon:@"ic_bar_left_infrared_control.png"];
//                [cell setLabelText:NSLocalizedString(@"infrared_remote", nil)];
                [cell setLeftIcon:@"ic_qr_code.png"];
                [cell setLabelText:NSLocalizedString(@"qrcode", nil)];
            }else{
                backImg = [UIImage imageNamed:@"bg_bar_btn_bottom.png"];
                backImg_p = [UIImage imageNamed:@"bg_bar_btn_bottom_p.png"];
                [cell setLeftIcon:@"ic_add_contact_smart_key.png"];
                [cell setLabelText:NSLocalizedString(@"smart_key", nil)];
            }
        }
            break;
        case 1:
        {
            if (row==0) {
                backImg = [UIImage imageNamed:@"bg_bar_btn_top.png"];
                backImg_p = [UIImage imageNamed:@"bg_bar_btn_top_p.png"];
                
                [cell setLeftIcon:@"ic_setting_screenshot.png"];
                [cell setLabelText:NSLocalizedString(@"screenshot", nil)];
            }else{
                backImg = [UIImage imageNamed:@"bg_bar_btn_bottom.png"];
                backImg_p = [UIImage imageNamed:@"bg_bar_btn_bottom_p.png"];
                
                [cell setLeftIcon:@"ic_ctl_alarm.png"];
                [cell setLabelText:NSLocalizedString(@"alarm_history", nil)];
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
    
    int section = indexPath.section;
    int row = indexPath.row;
    
    
    switch(section){
        case 0:
        {
            if(row==0){
                ShakeController *shakeController = [[ShakeController alloc]init];
                [self.navigationController pushViewController:shakeController animated:YES];
                [shakeController release];
            }else if(row==1){
//                InfraredRemoteController *infraredRemoteController = [[InfraredRemoteController alloc] init];
//                [self.navigationController pushViewController:infraredRemoteController animated:YES];
//                [infraredRemoteController release];
                QRCodeController *qecodeController = [[QRCodeController alloc] init];
                [self.navigationController pushViewController:qecodeController animated:YES];
                [qecodeController release];
                
            }else{
                SmartKeyController *smartKeyController = [[SmartKeyController alloc] init];
                [self.navigationController pushViewController:smartKeyController animated:YES];
                [smartKeyController release];
            }
        }
            break;
        case 1:
        {
            if (row==0) {
                ScreenshotController *screenshotController = [[ScreenshotController alloc] init];
                [self.navigationController pushViewController:screenshotController animated:YES];
                [screenshotController release];
            }else{
                AlarmHistoryController *alarmHistoryController = [[AlarmHistoryController alloc] init];
                [self.navigationController pushViewController:alarmHistoryController animated:YES];
                [alarmHistoryController release];
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
