//
//  RecentController.m
//  2cu
//
//  Created by guojunyi on 14-3-21.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import "RecentController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "RecentCell.h"
#import "RecentDAO.h"
#import "Recent.h"
#import "Utils.h"
#import "Toast+UIView.h"
#import "TopBar.h"
@interface RecentController ()

@end

@implementation RecentController

-(void)dealloc{
    [self.recents release];
    [self.tableView release];
    [self.curDelIndexPath release];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateTableDatas];
    [self initComponent];
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self updateTableDatas];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateTableDatas{
    RecentDAO *recentDAO = [[RecentDAO alloc] init];
    self.recents = [NSMutableArray arrayWithArray:[recentDAO findAll]];
    [recentDAO release];
    if(self.tableView){
        [self.tableView reloadData];
    }
}

#define RECENT_ITEM_HEIGHT (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 100:70)
-(void)initComponent{

    [self.view setBackgroundColor:XBgColor];
    CGRect rect = [AppDelegate getScreenSize:YES isHorizontal:NO];
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height-TAB_BAR_HEIGHT;
    
    TopBar *topBar = [[TopBar alloc] initWithFrame:CGRectMake(0, 0, width, NAVIGATION_BAR_HEIGHT)];
    [topBar setTitle:NSLocalizedString(@"recent",nil)];
    [topBar setRightButtonHidden:NO];
    [topBar setRightButtonIcon:[UIImage imageNamed:@"ic_bar_btn_clear.png"]];
    [topBar.rightButton addTarget:self action:@selector(onClearPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:topBar];
    [topBar release];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, width, height-NAVIGATION_BAR_HEIGHT) style:UITableViewStylePlain];
    [tableView setBackgroundColor:XBgColor];
    if(CURRENT_VERSION>=7.0){
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
    
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [tableView release];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.recents count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return RECENT_ITEM_HEIGHT;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"RecentCell";
    RecentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell==nil){
        cell = [[[RecentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    
    UIImage *backImg = [UIImage imageNamed:@"bg_normal_cell.png"];
    UIImage *backImg_p = [UIImage imageNamed:@"bg_normal_cell_p.png"];
    UIImageView *backImageView = [[UIImageView alloc] init];
    UIImageView *backImageView_p = [[UIImageView alloc] init];
    
    backImg = [backImg stretchableImageWithLeftCapWidth:backImg.size.width*0.5 topCapHeight:backImg.size.height*0.5];
    backImageView.image = backImg;
    [cell setBackgroundView:backImageView];
    
    backImg_p = [backImg_p stretchableImageWithLeftCapWidth:backImg_p.size.width*0.5 topCapHeight:backImg_p.size.height*0.5];
    backImageView_p.image = backImg_p;
    [cell setSelectedBackgroundView:backImageView_p];
    
    [backImageView release];
    [backImageView_p release];
    
    Recent *recent = [self.recents objectAtIndex:indexPath.row];
    
    [cell setContactId:recent.contactId];
    [cell setLeftIcon:@"bgImageBig.jpg"];
    [cell setTime:[Utils convertTimeByInterval:recent.time]];
    DLog(@"%@",[Utils convertTimeByInterval:recent.time])
    switch(recent.callState){
        case RECENT_CALLSTATE_CALLIN_ACCEPT:
            [cell setCallState:@"ic_call_in_accept.png"];
            break;
        case RECENT_CALLSTATE_CALLIN_REJECT:
            [cell setCallState:@"ic_call_in_reject.png"];
            break;
        case RECENT_CALLSTATE_CALLOUT_ACCEPT:
            [cell setCallState:@"ic_call_out_accept.png"];
            break;
        case RECENT_CALLSTATE_CALLOUT_REJECT:
            [cell setCallState:@"ic_call_out_reject.png"];
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    self.curDelIndexPath = indexPath;
    UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"sure_to_delete", nil) message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"ok", nil),nil];
    deleteAlert.tag = ALERT_TAG_DELETE;
    [deleteAlert show];
    [deleteAlert release];
}

-(void)onClearPress{
    UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"sure_to_clear", nil) message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"ok", nil),nil];
    deleteAlert.tag = ALERT_TAG_CLEAR;
    [deleteAlert show];
    [deleteAlert release];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch(alertView.tag){
        case ALERT_TAG_DELETE:
        {
            if(buttonIndex==1){
                RecentDAO *recentDAO = [[RecentDAO alloc] init];
                [recentDAO delete:[self.recents objectAtIndex:self.curDelIndexPath.row]];
                [self.recents removeObjectAtIndex:self.curDelIndexPath.row];
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.curDelIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [recentDAO release];
                [self.view makeToast:NSLocalizedString(@"operator_success", nil)];
            }
        }
            break;
        case ALERT_TAG_CLEAR:
        {
            if(buttonIndex==1){
                RecentDAO *recentDAO = [[RecentDAO alloc] init];
                [recentDAO clear];
                [self updateTableDatas];
                [recentDAO release];
                [self.view makeToast:NSLocalizedString(@"operator_success", nil)];
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
