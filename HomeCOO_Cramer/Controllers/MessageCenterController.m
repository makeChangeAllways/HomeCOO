//
//  MessageCenterController.m
//  2cu
//
//  Created by mac on 15/10/23.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//

#import "MessageCenterController.h"
#import "P2PClient.h"
#import "FListManager.h"
#import "PrefixHeader.pch"
@interface MessageCenterController () <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;


@end

@implementation MessageCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self UI_init];
    [self DATA_init];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --- UI
- (void)UI_init
{
    // base setting
    self.topBar.titleLabel.text = NSLocalizedString(@"alarm_history", nil);
    [self.topBar setHidden:NO];
    
    // UITableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.frame = CGRectMake(0, BottomForView(self.topBar), VIEWHEIGHT ,VIEWHEIGHT - 60 - BottomForView(self.topBar));
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:255/255.0];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    
    
}
#pragma mark --- DATA
-(void)DATA_init
{
    // 默认请求一次数据
    for (int i=0; i<[[[FListManager sharedFList] getContacts] count]; i++) {
        Contact *contact = [[[FListManager sharedFList] getContacts] objectAtIndex:i];
        
        if(contact.onLineState==STATE_ONLINE){
            //获取报警记录信息(app->设备)
            [[P2PClient sharedClient] getAlarmInfoWithId:contact.contactId password:contact.contactPassword];
        }else{
            //设备离线，不获取
//            [self.progressAlert hide:YES];
            //        [self.view makeToast:NSLocalizedString(@"modify_failure", nil)];
        }
        
        
    }
}








#pragma mark - p2p remotation 





@end
