//
//  P2PDefenceAreaController.m
//  2cu
//
//  Created by mac on 15/11/10.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//

#import "P2PDefenceAreaController.h"
#import "AppDelegate.h"
#import "GroupHead.h"
#import "P2PDefenceCell.h"
#include "DefenceAddCell.h"
#import "DefenceCellModel.h"
#import "MJExtension.h"
#import "MBProgressHUD.h"
#import "Contact.h"
#import "PrefixHeader.pch"
@interface P2PDefenceAreaController () < UITableViewDataSource , UITableViewDelegate >


@property(nonatomic,strong)NSMutableArray *dataArray;  // 数据SENTION数组
@property(strong,nonatomic) NSMutableArray *statusData; // 数据ROW数组
@property(strong,nonatomic) NSMutableArray *switchStatusData; // ????

@property(nonatomic,strong)UITableView *tableView; // 表格

@property(nonatomic,strong)MBProgressHUD *progressAlert; // 遮盖曾


/**
 *  未知BOOL
 */
@property(assign) BOOL isLoadDefenceArea;
@property(assign) BOOL isLoadDefenceSwitch;
@property(assign) BOOL isNotSurportDefenceSwitch;
@property(assign) BOOL isSetting;
@property(nonatomic) BOOL isNotRightPWD;
@property(assign) NSInteger lastSetGroup;
@property(assign) NSInteger lastSetItem;
@property(assign) NSInteger lastSetType;

@property(assign) NSInteger lastSetSwitchGroup;
@property(assign) NSInteger lastSetSwitchItem;
@property(assign) NSInteger lastSetSwitchType;

@end

@implementation P2PDefenceAreaController



#pragma mark - View Life

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UI_init];
    [self DATA_init];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRemoteMessage:) name:RECEIVE_REMOTE_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ack_receiveRemoteMessage:) name:ACK_RECEIVE_REMOTE_MESSAGE object:nil];
    
    self.progressAlert.dimBackground = YES;
    [self.progressAlert show:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    
    self.isLoadDefenceArea = YES;
    // 最初发送一次请求 获取子设备学习状态
    [[P2PClient sharedClient] getDefenceAreaState:self.contact.contactId password:self.contact.contactPassword];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI & DATA
- (void)UI_init
{
    // 标题栏
    [self.topBar setTitle:NSLocalizedString(@"defenceArea_set",nil)];
    [self.topBar setBackButtonHidden:NO];
    [self.topBar.backButton addTarget:self action:@selector(onBackPress) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view setBackgroundColor:XBgColor];
    CGRect rect = [AppDelegate getScreenSize:YES isHorizontal:NO];
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    // 遮盖层
    UIView *maskLayerView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, width, height-NAVIGATION_BAR_HEIGHT)];
    
    // 表格
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, width, height-NAVIGATION_BAR_HEIGHT) style:UITableViewStylePlain];//UITableViewStyleGrouped,headView随cell一起滚动
    
    tableView.backgroundView = nil;
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
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

-(void)DATA_init
{
    // 初始化TableView 数据
    [self initDataSource];
    
}

#pragma AutoWay

/**
 *  获取防区位置的标题
 *
 *  @param index 防区位置索引
 */
-(NSString *)getDefenceGroupNameWithIndex:(NSInteger)index{
    switch (index) {
        case 0:
            return NSLocalizedString(@"remote", nil);
            break;
        case 1:
            return NSLocalizedString(@"hall", nil);
            break;
        case 2:
            return NSLocalizedString(@"window", nil);
            break;
        case 3:
            return NSLocalizedString(@"balcony", nil);
            break;
        case 4:
            return NSLocalizedString(@"bedroom", nil);
            break;
        case 5:
            return NSLocalizedString(@"kitchen", nil);
            break;
        case 6:
            return NSLocalizedString(@"courtyard", nil);
            break;
        case 7:
            return NSLocalizedString(@"door_lock", nil);
            break;
        case 8:
            return NSLocalizedString(@"other", nil);
            break;
            
        default:
            return @"";
            break;
    }
}
/**
 *  初始化数据
 */
-(void)initDataSource{
    NSMutableArray *dataArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 9; i++) {
        NSMutableDictionary *groupDic = [NSMutableDictionary dictionaryWithCapacity:0];
        
        switch (i) {
            case 0:
                [groupDic setObject:NSLocalizedString(@"remote", nil) forKey:@"groupName"];
                break;
            case 1:
                [groupDic setObject:NSLocalizedString(@"hall", nil) forKey:@"groupName"];
                break;
            case 2:
                [groupDic setObject:NSLocalizedString(@"window", nil) forKey:@"groupName"];
                break;
            case 3:
                [groupDic setObject:NSLocalizedString(@"balcony", nil) forKey:@"groupName"];
                break;
            case 4:
                [groupDic setObject:NSLocalizedString(@"bedroom", nil) forKey:@"groupName"];
                break;
            case 5:
                [groupDic setObject:NSLocalizedString(@"kitchen", nil) forKey:@"groupName"];
                break;
            case 6:
                [groupDic setObject:NSLocalizedString(@"courtyard", nil) forKey:@"groupName"];
                break;
            case 7:
                [groupDic setObject:NSLocalizedString(@"door_lock", nil) forKey:@"groupName"];
                break;
            case 8:
                [groupDic setObject:NSLocalizedString(@"other", nil) forKey:@"groupName"];
                break;
            default:
                break;
        }
        [groupDic setValue:@"1" forKey:@"isHidden"];
        [dataArr addObject:groupDic];
    }
    self.dataArray = dataArr;
}

/**
 *  返回
 */
-(void)onBackPress{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RECEIVE_REMOTE_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ACK_RECEIVE_REMOTE_MESSAGE object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  点击Section
 *
 */
- (void)onHeadClicked:(UIView *)headView{
    
    
    NSDictionary *dic = _dataArray[headView.tag];
    NSArray *statusArr = [dic valueForKey:@"statusData"];
    if (statusArr.count > 0) {
        GroupHead *head = (GroupHead *)headView;
        NSString *isHidden = dic[@"isHidden"];
        if ([isHidden intValue] == 0) {
            [dic setValue:@"1" forKey:@"isHidden"];
            head.statusLabel.image =[UIImage imageNamed:@"call_guan"];
        }else{
            [dic setValue:@"0" forKey:@"isHidden"];
            head.statusLabel.image =[UIImage imageNamed:@"call_open"];
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:headView.tag] withRowAnimation:UITableViewRowAnimationNone];
    }
}


#pragma mark - RemoteMessage Notification
// 接收设备数据
- (void)receiveRemoteMessage:(NSNotification *)notification{
    NSDictionary *parameter = [notification userInfo];
    int key   = [[parameter valueForKey:@"key"] intValue];
    NSLog(@"%@",parameter);
    switch(key){
        case RET_DEVICE_NOT_SUPPORT://不支持禁用、启用开关
        {
            self.isLoadDefenceSwitch = NO;
            self.isNotSurportDefenceSwitch = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!self.isNotRightPWD) {
                    [self.view makeToast:NSLocalizedString(@"device_not_support_sensor_switch", nil)];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.progressAlert hide:YES];
                    [self.tableView reloadData];
                });
                
            });
        }
            break;
        case RET_GET_DEFENCE_SWITCH_STATE:
        {
            
            NSMutableArray *switchStatus = [parameter valueForKey:@"switchStatus"];
 
            self.switchStatusData = [NSMutableArray arrayWithArray:switchStatus];
            for (int i = 0; i < 1; i++) {
                [self.dataArray[i] setObject:self.switchStatusData[i] forKey:@"switchStatusData"];
            }
            
            // 转模型
            NSMutableArray *defence_Models = [NSMutableArray array];
            for (NSDictionary *dice in self.dataArray) {
                DefenceCellModel *defence_M = [[DefenceCellModel alloc] init];
                
            }
            
            
            
            self.isLoadDefenceSwitch = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(self.isSetting){
                    self.isSetting = NO;
                    [self.progressAlert hide:YES];
                    [self.view makeToast:NSLocalizedString(@"modify_success", nil)];
                }
                
                [self.tableView reloadData];
            });
        }
            break;
        case RET_SET_DEFENCE_SWITCH_STATE:
        {
            NSInteger result = [[parameter valueForKey:@"result"] intValue];
            
            if(result==0){
                self.isSetting = YES;
                [[P2PClient sharedClient] getDefenceSwitchStateWithId:self.contact.contactId password:self.contact.contactPassword];
                
            }else if(result==41){
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!self.isNotRightPWD) {
                        [self.view makeToast:NSLocalizedString(@"device_not_support_sensor_switch", nil)];
                    }
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
                    self.isLoadDefenceSwitch = NO;
                    [self.tableView reloadData];
                    [self.view makeToast:NSLocalizedString(@"modify_failure", nil)];
                });
            }
        }
            break;
        case RET_GET_DEFENCE_AREA_STATE:
        {
            NSMutableArray *status = [parameter valueForKey:@"status"];
            
            // 获取 status Data
            self.statusData = [NSMutableArray arrayWithArray:status];
            
            // 设置数据
            for (int index = 0; index < self.dataArray.count; index++) {
                [self.dataArray[index] setObject:self.statusData[index] forKey:@"statusData"];
            }
            
            
            
            
            
            self.isLoadDefenceArea = NO;
            if (!self.isSetting) {
                self.isLoadDefenceSwitch = YES;
                [[P2PClient sharedClient] getDefenceSwitchStateWithId:self.contact.contactId password:self.contact.contactPassword];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(self.isSetting){
                    self.isSetting = NO;
                    [self.view makeToast:NSLocalizedString(@"modify_success", nil)];
                }
                // 刷新表格
                [self.progressAlert hide:YES];
                [self.tableView reloadData];
            });
            
            
        }
            break;
        case RET_SET_DEFENCE_AREA_STATE:
        {
            NSInteger result = [[parameter valueForKey:@"result"] intValue];
            
            if(result==0){ // 有数据
                self.isSetting = YES;
                [[P2PClient sharedClient] getDefenceAreaState:self.contact.contactId password:self.contact.contactPassword];
                
            }else if(result==32){
                int group = [[parameter valueForKey:@"group"] intValue];
                int item = [[parameter valueForKey:@"item"] intValue];
                
                DLog(@"%i %i->already learned!",group,item);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.progressAlert hide:YES];
                    self.isLoadDefenceArea = NO;
                    [self.tableView reloadData];
                    NSString *promptString = [NSString stringWithFormat:@"%@:%@ %i %@",[self getDefenceGroupNameWithIndex:group],NSLocalizedString(@"defence_item",nil),item+1,NSLocalizedString(@"already_learn",nil)];
                    [self.view makeToast:promptString];
                });
            }else if(result==41){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view makeToast:NSLocalizedString(@"device_not_support_defence_area", nil)];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        usleep(800000);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self onBackPress];
                        });
                    });
                });
                
            }else{
                
                DLog(@"%i",result);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.progressAlert hide:YES];
                    self.isLoadDefenceArea = NO;
                    [self.tableView reloadData];
                    [self.view makeToast:NSLocalizedString(@"modify_failure", nil)];
                });
            }
        }
            break;
    }
}

// 接收判断是否成功
- (void)ack_receiveRemoteMessage:(NSNotification *)notification{
    NSDictionary *parameter = [notification userInfo];
    int key   = [[parameter valueForKey:@"key"] intValue];
    int result   = [[parameter valueForKey:@"result"] intValue];
    switch(key){
            
        case ACK_RET_GET_DEFENCE_AREA_STATE:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(result==1){
                    self.isNotRightPWD = YES;
                    [self.view makeToast:NSLocalizedString(@"device_password_error", nil)];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        usleep(800000);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self onBackPress];
                        });
                    });
                }else if(result==2){
                    DLog(@"resend get defence area state");
                    [[P2PClient sharedClient] getDefenceAreaState:self.contact.contactId password:self.contact.contactPassword];
                }
                
                
            });
            
            DLog(@"ACK_RET_GET_DEFENCE_AREA_STATE:%i",result);
        }
            break;
        case ACK_RET_SET_DEFENCE_AREA_STATE:
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
                    DLog(@"resend set defence area state");
                    
                    [[P2PClient sharedClient] setDefenceAreaState:self.contact.contactId password:self.contact.contactPassword group:self.lastSetGroup item:self.lastSetItem type:self.lastSetType];
                }
            });
            DLog(@"ACK_RET_SET_DEFENCE_AREA_STATE:%i",result);
        }
            break;
        case ACK_RET_GET_DEFENCE_SWITCH_STATE:{
            dispatch_async(dispatch_get_main_queue(), ^{
                if(result==1){
                    [self.progressAlert hide:YES];
                    [self.view makeToast:NSLocalizedString(@"device_password_error", nil)];
                    
                }else if(result==2){
                    DLog(@"resend do device update");
                    [[P2PClient sharedClient] getDefenceSwitchStateWithId:self.contact.contactId password:self.contact.contactPassword];
                }
            });
            
            DLog(@"ACK_RET_GET_DEVICE_INFO:%i",result);
        }
            break;
        case ACK_RET_SET_DEFENCE_SWITCH_STATE:{
            dispatch_async(dispatch_get_main_queue(), ^{
                if(result==1){
                    [self.progressAlert hide:YES];
                    [self.view makeToast:NSLocalizedString(@"device_password_error", nil)];
                    
                }else if(result==2){
                    DLog(@"resend do device update");
                    [[P2PClient sharedClient] setDefenceSwitchStateWithId:self.contact.contactId password:self.contact.contactPassword switchId:self.lastSetSwitchType alarmCodeId:self.lastSetSwitchGroup alarmCodeIndex:self.lastSetSwitchItem];
                }
                
                
            });
            
            DLog(@"ACK_RET_GET_DEVICE_INFO:%i",result);
        }
            break;
            
    }
}
#pragma mark - TableView DataResource - TableView 数据源


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
     int row = 0;
     for (int index = 0; index < self.dataArray.count; index ++) {
     if (section == index) {
     NSDictionary *dict = [self.dataArray objectAtIndex:section];
     NSMutableArray *statusData = [dict valueForKey:@"statusData"];
     NSString *isHidden = [dict valueForKey:@"isHidden"];
     if (isHidden.integerValue == 1) { // 该组隐藏
                return 0;
        }else {
            for (int inde = 0; inde < statusData.count; inde ++) {
                NSNumber *num = [statusData objectAtIndex:inde];
                if (num.integerValue == 0) {
                    row ++;
                    }
                }
            }
        }
     }
     return row + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = 0; // row 为最后一行
    for (int index = 0; index < self.dataArray.count; index ++) {
        if (indexPath.section == index) {
            NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.section];
            NSMutableArray *statusData = [dict valueForKey:@"statusData"];
            NSString *isHidden = [dict valueForKey:@"isHidden"];
            if (isHidden.integerValue == 1) { // 该组隐藏
                return 0;
            }else {
                for (int inde = 0; inde < statusData.count; inde ++) {
                    NSNumber *num = [statusData objectAtIndex:inde];
                    if (num.integerValue == 0) {
                        row ++;
                    }
                }
            }
        }
    }
    
    if (indexPath.row == row) { // 最后一行
        
        static NSString *reuse_id = @"defence_add";
        DefenceAddCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse_id];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"DefenceAddCell" owner:nil options:nil][0];
        }
        return cell;
       
    }else
    {
    
    static NSString *reuse_id = @"defence_cell";
    P2PDefenceCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse_id];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"P2PDefenceCell" owner:nil options:nil][0];
    }
    NSDictionary *dict = self.dataArray[indexPath.section];
    
    
    // temp todo index
    cell.index = indexPath.row + 1;
    return cell;
    }
}


#pragma mark - TableView Delegate - TableView 代理

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return BAR_BUTTON_HEIGHT;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return BAR_BUTTON_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    GroupHead * headView = [[[GroupHead alloc] initWithFrame:CGRectMake(10, 0, VIEWWIDTH, BAR_BUTTON_HEIGHT)] autorelease];
    headView.layer.borderColor = XBgColor.CGColor;
    headView.layer.borderWidth = 0.5;
    [headView addTarget:self action:@selector(onHeadClicked:) forControlEvents:UIControlEventTouchUpInside];
    headView.tag = section;
    
    NSDictionary *dic = self.dataArray[section];
    [headView refreshUIWithDictionary:dic];
    
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
