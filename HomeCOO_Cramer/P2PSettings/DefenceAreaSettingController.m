//
//  DefenceAreaSettingController.m
//  2cu
//
//  Created by guojunyi on 14-5-20.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import "DefenceAreaSettingController.h"
#import "Constants.h"
#import "TopBar.h"
#import "AppDelegate.h"
#import "DefenceCell.h"
#import "P2PClient.h"
#import "Contact.h"
#import "MBProgressHUD.h"
#import "Toast+UIView.h"
#import "GroupHead.h"
#import "Defence.h"
#import "DefenceNameDAO.h"
#import "LoginResult.h"
#import "UDManager.h"
#import "DefenceNameDAO.h"
#import "PrefixHeader.pch"


@interface DefenceAreaSettingController () <UIAlertViewDelegate>

@property(nonatomic,assign)NSInteger section;

@property(nonatomic,assign)NSInteger row;

@property(nonatomic,strong)NSMutableArray *total_arr; //  排序好的数组


@property(nonatomic,strong)DefenceNameDAO *defenceDAO;



@end

@implementation DefenceAreaSettingController



//-(void)dealloc{
//    [self.progressAlert release];
//    [self.contact release];
//    [self.tableView release];
//    [self.dataArray release];
//    [self.statusData release];
//    [self.switchStatusData release];
//    [super dealloc];
//}

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
    
    self.progressAlert.dimBackground = YES;
    [self.progressAlert show:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    
    self.isLoadDefenceArea = YES;
    [[P2PClient sharedClient] getDefenceAreaState:self.contact.contactId password:self.contact.contactPassword];

}

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

//            NSArray *tempArr = [switchStatus objectAtIndex:1];
//            [switchStatus removeObjectAtIndex:1];
//            [switchStatus insertObject:tempArr atIndex:7];
            
            self.switchStatusData = [NSMutableArray arrayWithArray:switchStatus];
            for (int i = 0; i < 1; i++) {
                [self.dataArray[i] setObject:self.switchStatusData[i] forKey:@"switchStatusData"];
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
            
            self.statusData = [NSMutableArray arrayWithArray:status];
            
            NSMutableArray *total_Arr = [NSMutableArray array]; // 排序好的总的数组
            
            for (int i = 0; i < self.statusData.count; i++) { // 外界数组 -- 遥控 大厅等
                
                
                NSMutableArray *learn_arr = [status objectAtIndex:i];
                NSMutableArray *temp_arr = [NSMutableArray array]; // 小数组
                int num_learn = 0;
                for (NSNumber *num in learn_arr) {
                    if ([num isEqual:@0]) { // 有学习的
                        num_learn ++ ;
                    }
                }
                for (int index = 0; index < num_learn; index ++) {
                    [temp_arr addObject:@0];
                }
                for (int index = num_learn; index < 8; index ++) {
                    [temp_arr addObject:@1];
                }
                [total_Arr addObject:temp_arr];
                
                
                
                
                
                int row = 1;
                // 存字典
                [self.dataArray[i] setObject:self.statusData[i] forKey:@"statusData"];
                NSLog(@"ii=%@",[[self.statusData objectAtIndex:0] objectAtIndex:0]);
                
                NSMutableArray *rowArr = [self.statusData objectAtIndex:i];
                for (int index = 0; index <rowArr.count; index ++) {  // 子数组
                    
                    NSNumber *row_status = [rowArr objectAtIndex:index]; // 取出每一行的 状态 0/1 区分是否学习
                    if ([row_status isEqual:@0]) {
                        row ++;
                    }
                }
                
                /*
                if (row > 8) {
                    row = 8;
                }
                 
                 */
                // 赋值tag
                switch (i) {
                    case 0:
                    {
                        self.counttag = row;
                    }
                        break;
                    case 1:
                    {
                        self.counttag1 = row;
                    }
                        break;
                    case 2:
                    {
                        self.counttag2 = row;
                    }
                        break;
                    case 3:
                    {
                        self.counttag3 = row;
                    }
                        break;
                    case 4:
                    {
                        self.counttag4 = row;
                    }
                        break;
                    case 5:
                    {
                        self.counttag5 = row;
                    }
                        break;
                    case 6:
                    {
                        self.counttag6 = row;
                    }
                        break;
                    case 7:
                    {
                        self.counttag7 = row;
                    }
                        break;
                    case 8:
                    {
                        self.counttag8 = row;
                    }
                        break;
                    default:
                        break;
                }
                
                
            
                // 赋值tag
                

            }
            
            self.total_arr = total_Arr;
//            NSLog(@"self.dataArray=%@",self.statusData);
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initDataSource];
    [self initComponent];
    
    DefenceNameDAO *defenceDAO = [[DefenceNameDAO alloc] init];
    self.defenceDAO = defenceDAO;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#define LEFT_LABEL_WIDTH 120
#define GROUP_HEAD_WIDTH ([UIScreen mainScreen].bounds.size.width)

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

-(void)initComponent{
    [self.view setBackgroundColor:XBgColor];
    CGRect rect = [AppDelegate getScreenSize:YES isHorizontal:NO];
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    TopBar *topBar = [[TopBar alloc] initWithFrame:CGRectMake(0, 0, width, NAVIGATION_BAR_HEIGHT)];
    [topBar setTitle:NSLocalizedString(@"defenceArea_set",nil)];
    [topBar setBackButtonHidden:NO];
    [topBar.backButton addTarget:self action:@selector(onBackPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:topBar];
//    [topBar release];
    
    
    UIView *maskLayerView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, width, height-NAVIGATION_BAR_HEIGHT)];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, width, height-NAVIGATION_BAR_HEIGHT) style:UITableViewStylePlain];//UITableViewStyleGrouped,headView随cell一起滚动
//    [tableView setBackgroundColor:XBGAlpha];
    tableView.backgroundView = nil;
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    [maskLayerView addSubview:tableView];
    self.tableView = tableView;
//    [tableView release];
    
    self.progressAlert = [[MBProgressHUD alloc] initWithView:maskLayerView];
    [maskLayerView addSubview:self.progressAlert];
    
    [self.view addSubview:maskLayerView];
//    [maskLayerView release];
    self.counttag=self.counttag1=self.counttag2=self.counttag3=self.counttag4=self.counttag5=self.counttag6=self.counttag7=self.counttag8=1;
    
    
    
}

-(void)onBackPress{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RECEIVE_REMOTE_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ACK_RECEIVE_REMOTE_MESSAGE object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return BAR_BUTTON_HEIGHT;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return BAR_BUTTON_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    GroupHead * headView = [[GroupHead alloc] initWithFrame:CGRectMake(10, 0, VIEWWIDTH, BAR_BUTTON_HEIGHT)];
    headView.layer.borderColor = XBgColor.CGColor;
    headView.layer.borderWidth = 0.5;
    [headView addTarget:self action:@selector(onHeadClicked:) forControlEvents:UIControlEventTouchUpInside];
    headView.tag = section;
    NSDictionary *dic = self.dataArray[section];
    [headView refreshUIWithDictionary:dic];
    
    
    return headView;
}

- (void)onHeadClicked:(UIView *)headView{
    
//    self.isAdd = 0;
//    self.isAdd1 = 0;
//    self.isAdd2 = 0;
//    self.isAdd3 = 0;
//    self.isAdd4 = 0;
//    self.isAdd5 = 0;
//    self.isAdd6 = 0;
//    self.isAdd7 = 0;
//    self.isAdd8 = 0;
    
    
    
    NSDictionary *dic = _dataArray[headView.tag];
    NSArray *statusArr = [dic valueForKey:@"statusData"];
    if (statusArr.count > 0) {
        GroupHead *head = (GroupHead *)headView;
        NSString *isHidden = dic[@"isHidden"];
        if ([isHidden intValue] == 0) {
            [dic setValue:@"1" forKey:@"isHidden"];
//            head.statusLabel.text = @">";
            head.statusLabel.image =[UIImage imageNamed:@"call_guan"];
        }else{
            [dic setValue:@"0" forKey:@"isHidden"];
//            head.statusLabel.text = @"v";
            head.statusLabel.image =[UIImage imageNamed:@"call_open"];
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:headView.tag] withRowAnimation:UITableViewRowAnimationNone];
    }
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    for (int i=0; i<[self.dataArray count]; i++) {
        if (section==i) {
            NSDictionary *dic = self.dataArray[section];
            NSArray *statusData = [dic valueForKey:@"statusData"];
            NSString *isHidden = [dic valueForKey:@"isHidden"];
            if ([isHidden intValue] == 1) {
                return 0;
            }else if (statusData.count > 0) {
                
                //        return statusData.count;
                switch (section) {
                    case 0:
                        return self.counttag;
                        break;
                    case 1:
                        return self.counttag1;
                        break;
                    case 2:
                        return self.counttag2;
                        break;
                    case 3:
                        return self.counttag3;
                        break;
                    case 4:
                        return self.counttag4;
                        break;
                    case 5:
                        return self.counttag5;
                        break;
                    case 6:
                        return self.counttag6;
                        break;
                    case 7:
                        return self.counttag7;
                        break;
                    case 8:
                        return self.counttag8;
                        break;
                        
                    default:
                        break;
                }
                
            }
        }

    }
    return 0;
    
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * reuseID = @"DefenceCell";
    DefenceCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseID];

    
    if (cell == nil) {
        cell = [[DefenceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
//        [cell setBackgroundColor:XBGAlpha];
    }
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    int section = indexPath.section;
    int row = indexPath.row;
    
    
    if (indexPath.row < 8) {
        
    /*
    if (section == 0) {
        NSDictionary *dic = self.dataArray[section];
        NSArray *statusData = [dic valueForKey:@"statusData"];
        
        [cell setLeftButtonHidden:YES];
        [cell setProgressViewHidden:YES];
        
        DefenceNameDAO *defenceDao = [[DefenceNameDAO alloc] init];
        NSString *section_str = [NSString stringWithFormat:@"%d",indexPath.section];
        NSString *row_str = [NSString stringWithFormat:@"%d",indexPath.row];
        Defence *defence = [defenceDao findDefenceNameWithContactId:self.contact.contactId Section:section_str Row:row_str];
        if (defence.defenceName.length && defence.defenceName) {
            
            cell.index = [NSString stringWithFormat:@"%@，%@",defence.Row,defence.defenceName];
        }else
        {
             cell.index = [NSString stringWithFormat:@"%d",row + 1];
        }
        
       
        //显示学习对码状态
        if ([statusData[row] intValue] == 1) {
            //显示learnCodeLabel并且隐藏delImageView
            [cell setDelImageViewHidden:YES];
            if (self.isLoadDefenceArea) {
                [cell setProgressViewHidden2:NO];
                [cell setLearnCodeLabelHidden:YES];
            }else{
                [cell setProgressViewHidden2:YES];
                [cell setLearnCodeLabelHidden:NO];
            }
        }else if ([statusData[row] intValue] == 0){
            //显示delImageView并且隐藏learnCodeLabel
            [cell setLearnCodeLabelHidden:YES];
            if (self.isLoadDefenceArea) {
                [cell setProgressViewHidden2:NO];
                [cell setDelImageViewHidden:YES];
            }else{
                [cell setProgressViewHidden2:YES];
//                [cell setDelImageViewHidden:NO];
                [cell setDelImageViewHidden:YES];
            }
        }
    }else{
     
        */
        cell.section = section;
        cell.row = row;
        cell.delegate = self;
        
        
        NSDictionary *dic = self.dataArray[section];
        NSArray *statusData = [dic valueForKey:@"statusData"];
        
        // 排序临时数组
        int num_learn = 0;
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSNumber *num in statusData) {
            if ([num isEqual:@0]) {
                num_learn ++;
            }
        }
        for (int index = 0; index < num_learn; index ++) {
            [tempArr addObject:@0];
        }
        
        for (int index = num_learn; index < 8; index ++) {
            [tempArr addObject:@1];
        }
        
        
        
        if ([tempArr[row] integerValue] == 0) { // 已学习
            [cell setLearnCodeLabelHidden:YES];
            [cell setSetnameHidden:NO];
        }else
        {
            [cell setLearnCodeLabelHidden:NO];
            [cell setSetnameHidden:YES];
        }
        
        
        // 加载条 提示Hidden
        if (self.isLoadDefenceArea) {
            [cell setProgressViewHidden2:NO];
        }else{
            [cell setProgressViewHidden2:YES];
        }
        
         
         // 获取 不同 行跟 row 的名字
        // 查询 新数组中 某个0 在原来数组的位置
        NSArray *pre_arr = self.statusData[section];
        int num_zero = -1;
        int pre_loc = -1;
        for (int index = 0; index < pre_arr.count; index ++) { // 遍历原数组
            NSNumber *num = [pre_arr objectAtIndex:index];
            if ([num isEqual:@0]) {
                num_zero ++ ;
                if (num_zero  == row) { // lastSetItem 为新数组中 0所在的位置
                    pre_loc = index;
                }
            }
        }
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//           
//        });
        
        
        Defence *defence = [self.defenceDAO findDefenceNameWithContactId:self.contact.contactId Section:[NSString stringWithFormat:@"%d",section] Row:[NSString stringWithFormat:@"%d",pre_loc]];
        
        NSLog(@"%@",defence.defenceName);
        
        if (defence.defenceName.length) {
            
            cell.index = [NSString stringWithFormat:@"%d.%@",pre_loc + 1,defence.defenceName];
            
            /*
            switch (indexPath.section) {
                case 0:
                {
                    if (indexPath.row == (self.counttag - 2)) { // 倒二行
                        if (self.isAdd == 1) { // 有按ADD
                            cell.index = [NSString stringWithFormat:@"%d.%@",pre_loc + 1,defence.defenceName];
                        }else
                        {
                            cell.index = [NSString stringWithFormat:@"%d.%@",pre_loc + 1,defence.defenceName];
                        }
                        
                        
                    }
                }
                    break;
                case 1:
                {
                    if (indexPath.row == (self.counttag1 - 2)) { // 倒二行
                        if (self.isAdd1 == 1) { // 有按ADD
                            cell.index = [NSString stringWithFormat:@"%d.%@",pre_loc + 1,defence.defenceName];
                        }else
                        {
                            cell.index = [NSString stringWithFormat:@"%d.%@",pre_loc + 1,defence.defenceName];
                        }
                        
                        
                    }
                }
                    break;
                    
                case 2:
                {
                    if (indexPath.row == (self.counttag2 - 2)) { // 倒二行
                        if (self.isAdd2 == 1) { // 有按ADD
                            cell.index = [NSString stringWithFormat:@"%d.%@",pre_loc + 1,defence.defenceName];
                        }else
                        {
                            cell.index = [NSString stringWithFormat:@"%d.%@",pre_loc + 1,defence.defenceName];
                        }
                        
                        
                    }
                }
                    break;
                case 3:
                {
                    if (indexPath.row == (self.counttag3 - 2)) { // 倒二行
                        if (self.isAdd3 == 1) { // 有按ADD
                            cell.index = [NSString stringWithFormat:@"%d.%@",pre_loc + 1,defence.defenceName];
                        }else
                        {
                            cell.index = [NSString stringWithFormat:@"%d.%@",pre_loc + 1,defence.defenceName];
                        }
                        
                        
                    }
                }
                    break;
                    
                case 4:
                {
                    if (indexPath.row == (self.counttag4 - 2)) { // 倒二行
                        if (self.isAdd4 == 1) { // 有按ADD
                            cell.index = [NSString stringWithFormat:@"%d.%@",pre_loc + 1,defence.defenceName];
                        }else
                        {
                            cell.index = [NSString stringWithFormat:@"%d.%@",pre_loc + 1,defence.defenceName];
                        }
                        
                        
                    }
                }
                    break;
                    
                case 5:
                {
                    if (indexPath.row == (self.counttag5 - 2)) { // 倒二行
                        if (self.isAdd5 == 1) { // 有按ADD
                            cell.index = [NSString stringWithFormat:@"%d.%@",pre_loc + 1,defence.defenceName];
                        }else
                        {
                            cell.index = [NSString stringWithFormat:@"%d.%@",pre_loc + 1,defence.defenceName];
                        }
                        
                        
                    }
                }
                    break;
                    
                case 6:
                {
                    if (indexPath.row == (self.counttag6 - 2)) { // 倒二行
                        if (self.isAdd6 == 1) { // 有按ADD
                            cell.index = [NSString stringWithFormat:@"%d.%@",pre_loc + 1,defence.defenceName];
                        }else
                        {
                            cell.index = [NSString stringWithFormat:@"%d.%@",pre_loc + 1,defence.defenceName];
                        }
                        
                        
                    }
                }
                    break;
                    
                case 7:
                {
                    if (indexPath.row == (self.counttag7 - 2)) { // 倒二行
                        if (self.isAdd7 == 1) { // 有按ADD
                            cell.index = [NSString stringWithFormat:@"%d.%@",pre_loc + 1,defence.defenceName];
                        }else
                        {
                            cell.index = [NSString stringWithFormat:@"%d.%@",pre_loc + 1,defence.defenceName];
                        }
                    }
                }
                    break;
                case 8:
                {
                    if (indexPath.row == (self.counttag8 - 2)) { // 倒二行
                        if (self.isAdd8 == 1) { // 有按ADD
                            cell.index = [NSString stringWithFormat:@"%d.%@",pre_loc + 1,defence.defenceName];
                        }else
                        {
                            cell.index = [NSString stringWithFormat:@"%d.%@",pre_loc + 1,defence.defenceName];
                        }
                    }
                }
                    break;
                default:
                    break;
            }
             
             */
            
        }else{
        cell.index = [NSString stringWithFormat:@"%d",pre_loc + 1];
        
        switch (indexPath.section) {
            case 0:
            {
                if (indexPath.row == (self.counttag - 2)) { // 倒二行
                    if (self.isAdd == 1) { // 有按ADD
                        cell.index = [NSString stringWithFormat:@"%ld",(long)self.loc];
                    }else
                    {
                        cell.index = [NSString stringWithFormat:@"%d",pre_loc + 1];
                    }
                    
                    
                }
            }
                break;
            case 1:
            {
                if (indexPath.row == (self.counttag1 - 2)) { // 倒二行
                    if (self.isAdd1 == 1) { // 有按ADD
                        cell.index = [NSString stringWithFormat:@"%ld",(long)self.loc1];
                    }else
                    {
                        cell.index = [NSString stringWithFormat:@"%d",pre_loc + 1];
                    }
                    
                    
                }
            }
                break;

            case 2:
            {
                if (indexPath.row == (self.counttag2 - 2)) { // 倒二行
                    if (self.isAdd2 == 1) { // 有按ADD
                        cell.index = [NSString stringWithFormat:@"%ld",(long)self.loc2];
                    }else
                    {
                        cell.index = [NSString stringWithFormat:@"%d",pre_loc + 1];
                    }
                    
                    
                }
            }
                break;
            case 3:
            {
                if (indexPath.row == (self.counttag3 - 2)) { // 倒二行
                    if (self.isAdd3 == 1) { // 有按ADD
                        cell.index = [NSString stringWithFormat:@"%ld",(long)self.loc3];
                    }else
                    {
                        cell.index = [NSString stringWithFormat:@"%d",pre_loc + 1];
                    }
                    
                    
                }
            }
                break;

            case 4:
            {
                if (indexPath.row == (self.counttag4 - 2)) { // 倒二行
                    if (self.isAdd4 == 1) { // 有按ADD
                        cell.index = [NSString stringWithFormat:@"%ld",(long)self.loc4];
                    }else
                    {
                        cell.index = [NSString stringWithFormat:@"%d",pre_loc + 1];
                    }
                    
                    
                }
            }
                break;

            case 5:
            {
                if (indexPath.row == (self.counttag5 - 2)) { // 倒二行
                    if (self.isAdd5 == 1) { // 有按ADD
                        cell.index = [NSString stringWithFormat:@"%ld",(long)self.loc5];
                    }else
                    {
                        cell.index = [NSString stringWithFormat:@"%d",pre_loc + 1];
                    }
                    
                    
                }
            }
                break;

            case 6:
            {
                if (indexPath.row == (self.counttag6 - 2)) { // 倒二行
                    if (self.isAdd6 == 1) { // 有按ADD
                        cell.index = [NSString stringWithFormat:@"%ld",(long)self.loc6];
                    }else
                    {
                        cell.index = [NSString stringWithFormat:@"%d",pre_loc + 1];
                    }
                    
                    
                }
            }
                break;

            case 7:
            {
                if (indexPath.row == (self.counttag7 - 2)) { // 倒二行
                    if (self.isAdd7 == 1) { // 有按ADD
                        cell.index = [NSString stringWithFormat:@"%ld",(long)self.loc7];
                    }else
                    {
                        cell.index = [NSString stringWithFormat:@"%d",pre_loc + 1];
                    }
                    
                    
                }
            }
                break;
            case 8:
            {
                if (indexPath.row == (self.counttag8 - 2)) { // 倒二行
                    if (self.isAdd8 == 1) { // 有按ADD
                        cell.index = [NSString stringWithFormat:@"%ld",(long)self.loc8];
                    }else
                    {
                        cell.index = [NSString stringWithFormat:@"%d",pre_loc + 1];
                    }
                    
                    
                }
            }
                break;

                
            default:
                break;
        }
         
            
        }
        
        
        
        
        /*
         DefenceNameDAO *defenceDao = [[DefenceNameDAO alloc] init];
         NSString *Section = [NSString stringWithFormat:@"%d",indexPath.section];
        NSString *Row = [NSString stringWithFormat:@"%d",pre_loc];
         Defence *defence = [defenceDao findDefenceNameWithContactId:self.contact.contactId Section:Section Row:Row];
         if (defence.defenceName && defence.defenceName.length && [defence isKindOfClass:[NSNull class]]) {  // 取出的名字有长度
             
         cell.index = [NSString stringWithFormat:@"%d，%@",pre_loc + 1,defence.defenceName];
         }else
         {
             cell.index = [NSString stringWithFormat:@"%d",pre_loc + 1];

         }
         
         */
        
         
         
        
        
        
        /*
        NSArray *switchStatusData = [dic valueForKey:@"switchStatusData"];
        
        
        
        //显示学习对码状态、启用禁用开关状态
        if ([statusData[row] intValue] == 1) {
            //隐藏leftButton、delImageView、progressView
            [cell setLeftButtonHidden:YES];
            [cell setDelImageViewHidden:YES];
            [cell setProgressViewHidden:YES];
            if (self.isLoadDefenceArea) {
                [cell setProgressViewHidden2:NO];
                [cell setLearnCodeLabelHidden:YES];
            }else{
                [cell setProgressViewHidden2:YES];
                [cell setLearnCodeLabelHidden:NO];
            }
        }else if ([statusData[row] intValue] == 0){  // 学习
            //显示leftButton、delImageView并且隐藏learnCodeLabel
            [cell setLearnCodeLabelHidden:YES];
            if (!self.isNotSurportDefenceSwitch) {
                if (self.isLoadDefenceSwitch) {
                    [cell setProgressViewHidden:NO];
                    [cell setLeftButtonHidden:YES];
                }else{
                    [cell setProgressViewHidden:YES];
//                    [cell setLeftButtonHidden:NO];
                    [cell setLeftButtonHidden:YES];
                }
            }else{
                [cell setLeftButtonHidden:YES];
                [cell setProgressViewHidden:YES];
            }
            
            if (self.isLoadDefenceArea) {
                [cell setProgressViewHidden2:NO];
                [cell setDelImageViewHidden:YES];
            }else{
                [cell setProgressViewHidden2:YES];
//                [cell setDelImageViewHidden:NO];
                [cell setDelImageViewHidden:YES];
            }
            
            if ([switchStatusData[row] intValue] == 0) {
                //显示禁用状态的按钮
                cell.isSelectedButton = NO;
            }else{
                //显示启用状态的按钮
                cell.isSelectedButton = YES;
            }
        }
         
         */
    
       
    
    /* 111
    }
     */
    
    UIImage *backImg;
    UIImage *backImg_p;
    if(row == 0){
//        backImg = [UIImage imageNamed:@"bg_bar_btn_top.png"];
//        backImg_p = [UIImage imageNamed:@"bg_bar_btn_top_p.png"];
        backImg = [UIImage imageNamed:@""];
        backImg_p = [UIImage imageNamed:@""];
    }else if (row == 7){
//        backImg = [UIImage imageNamed:@"bg_bar_btn_bottom.png"];
//        backImg_p = [UIImage imageNamed:@"bg_bar_btn_bottom_p.png"];
        backImg = [UIImage imageNamed:@""];
        backImg_p = [UIImage imageNamed:@""];
    }else{
//        backImg = [UIImage imageNamed:@"bg_bar_btn_center.png"];
//        backImg_p = [UIImage imageNamed:@"bg_bar_btn_center_p.png"];
        backImg = [UIImage imageNamed:@""];
        backImg_p = [UIImage imageNamed:@""];
    }
    
    
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImg = [backImg stretchableImageWithLeftCapWidth:backImg.size.width*0.5 topCapHeight:backImg.size.height*0.5];
    backImageView.image = backImg;
    [cell setBackgroundView:backImageView];
//    [backImageView release];
    
    UIImageView *backImageView_p = [[UIImageView alloc] init];
    backImg_p = [backImg_p stretchableImageWithLeftCapWidth:backImg_p.size.width*0.5 topCapHeight:backImg_p.size.height*0.5];
    backImageView_p.image = backImg_p;
    [cell setSelectedBackgroundView:backImageView_p];
//    [backImageView_p release];
    }
    
//    return cell;
    
    //  判断那个 加号按钮 那一行
    switch (indexPath.section) {
        case 0:
            if (self.counttag<10){
                
                
                if (indexPath.row==(self.counttag-1)) {
                    NSString *more=@"11";
                    UITableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:more];
                    
                    if(cell == nil) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:more];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        UIButton*button=[[UIButton alloc]init];
                        [cell.contentView addSubview:button];
                        button.tag=555;
                        
                    }
                    UIButton*addbtn=(UIButton *)[cell viewWithTag:555];
                    addbtn.frame=CGRectMake((VIEWWIDTH-100)/2, 10,100,BAR_BUTTON_HEIGHT-20);
                    [addbtn setImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];
                    [addbtn addTarget:self action:@selector(goadd:withEvent:) forControlEvents:UIControlEventTouchUpInside];
                    return cell;
                    
                }
            }
            break;
        case 1:
            if (self.counttag1<10){
                if (indexPath.row==(self.counttag1-1)) {
                    NSString *more=@"11";
                    UITableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:more];
                    
                    if(cell == nil) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:more];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        UIButton*button=[[UIButton alloc]init];
                        [cell.contentView addSubview:button];
                        button.tag=555;
                        
                    }
                    UIButton*addbtn=(UIButton *)[cell viewWithTag:555];
                    addbtn.frame=CGRectMake((VIEWWIDTH-100)/2, 10,100,BAR_BUTTON_HEIGHT-20);
                    [addbtn setImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];
                    [addbtn addTarget:self action:@selector(goadd:withEvent:) forControlEvents:UIControlEventTouchUpInside];
                    return cell;
                    
                }
            }
            break;
        case 2:
            if (self.counttag2<10){
                if (indexPath.row==(self.counttag2-1)) {
                    NSString *more=@"11";
                    UITableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:more];
                    
                    if(cell == nil) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:more];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        UIButton*button=[[UIButton alloc]init];
                        [cell.contentView addSubview:button];
                        button.tag=555;
                        
                    }
                    UIButton*addbtn=(UIButton *)[cell viewWithTag:555];
                    addbtn.frame=CGRectMake((VIEWWIDTH-100)/2, 10,100,BAR_BUTTON_HEIGHT-20);
                    [addbtn setImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];
                    [addbtn addTarget:self action:@selector(goadd:withEvent:) forControlEvents:UIControlEventTouchUpInside];
                    return cell;
                }
            }
            break;
        case 3:
            if (self.counttag3<10){
                if (indexPath.row==(self.counttag3-1)) {
                    NSString *more=@"11";
                    UITableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:more];
                    
                    if(cell == nil) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:more];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        UIButton*button=[[UIButton alloc]init];
                        [cell.contentView addSubview:button];
                        button.tag=555;
                        
                    }
                    UIButton*addbtn=(UIButton *)[cell viewWithTag:555];
                    addbtn.frame=CGRectMake((VIEWWIDTH-100)/2, 10,100,BAR_BUTTON_HEIGHT-20);
                    [addbtn setImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];
                    [addbtn addTarget:self action:@selector(goadd:withEvent:) forControlEvents:UIControlEventTouchUpInside];
                    return cell;
                    
                }
            }
            break;
        case 4:
            if (self.counttag4<10){
                if (indexPath.row==(self.counttag4-1)) {
                    NSString *more=@"11";
                    UITableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:more];
                    
                    if(cell == nil) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:more];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        UIButton*button=[[UIButton alloc]init];
                        [cell.contentView addSubview:button];
                        button.tag=555;
                        
                    }
                    UIButton*addbtn=(UIButton *)[cell viewWithTag:555];
                    addbtn.frame=CGRectMake((VIEWWIDTH-100)/2, 10,100,BAR_BUTTON_HEIGHT-20);
                    [addbtn setImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];
                    [addbtn addTarget:self action:@selector(goadd:withEvent:) forControlEvents:UIControlEventTouchUpInside];
                    return cell;
                    
                }
            }
            break;
        case 5:
            if (self.counttag5<10){
                if (indexPath.row==(self.counttag5-1)) {
                    NSString *more=@"11";
                    UITableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:more];
                    
                    if(cell == nil) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:more];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        UIButton*button=[[UIButton alloc]init];
                        [cell.contentView addSubview:button];
                        button.tag=555;
                        
                    }
                    UIButton*addbtn=(UIButton *)[cell viewWithTag:555];
                    addbtn.frame=CGRectMake((VIEWWIDTH-100)/2, 10,100,BAR_BUTTON_HEIGHT-20);
                    [addbtn setImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];
                    [addbtn addTarget:self action:@selector(goadd:withEvent:) forControlEvents:UIControlEventTouchUpInside];
                    return cell;
                    
                }
            }
            break;
        case 6:
            if (self.counttag6<10){
                if (indexPath.row==(self.counttag6-1)) {
                    NSString *more=@"11";
                    UITableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:more];
                    
                    if(cell == nil) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:more];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        UIButton*button=[[UIButton alloc]init];
                        [cell.contentView addSubview:button];
                        button.tag=555;
                        
                    }
                    UIButton*addbtn=(UIButton *)[cell viewWithTag:555];
                    addbtn.frame=CGRectMake((VIEWWIDTH-100)/2, 10,100,BAR_BUTTON_HEIGHT-20);
                    [addbtn setImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];
                    [addbtn addTarget:self action:@selector(goadd:withEvent:) forControlEvents:UIControlEventTouchUpInside];
                    return cell;
                    
                }
            }
            break;
        case 7:
            if (self.counttag7<10){
                if (indexPath.row==(self.counttag7-1)) {
                    NSString *more=@"11";
                    UITableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:more];
                    
                    if(cell == nil) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:more];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        UIButton*button=[[UIButton alloc]init];
                        [cell.contentView addSubview:button];
                        button.tag=555;
                        
                    }
                    UIButton*addbtn=(UIButton *)[cell viewWithTag:555];
                    addbtn.frame=CGRectMake((VIEWWIDTH-100)/2, 10,100,BAR_BUTTON_HEIGHT-20);
                    [addbtn setImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];
                    [addbtn addTarget:self action:@selector(goadd:withEvent:) forControlEvents:UIControlEventTouchUpInside];
                    return cell;
                    
                }
            }
            break;
        case 8:
            if (self.counttag8<10){
                if (indexPath.row==(self.counttag8-1)) {
                    NSString *more=@"11";
                    UITableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:more];
                    
                    if(cell == nil) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:more];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        UIButton*button=[[UIButton alloc]init];
                        [cell.contentView addSubview:button];
                        button.tag=555;
                        
                    }
                    UIButton*addbtn=(UIButton *)[cell viewWithTag:555];
                    addbtn.frame=CGRectMake((VIEWWIDTH-100)/2, 10,100,BAR_BUTTON_HEIGHT-20);
                    [addbtn setImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];
                    [addbtn addTarget:self action:@selector(goadd:withEvent:) forControlEvents:UIControlEventTouchUpInside];
                    return cell;
                    
                }
            }
            break;
            
        default:
            break;
    }
    

        
    return cell;
}
-(void)goadd:(UIButton*)btn withEvent:(UIEvent*)event{
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: [[[event touchesForView: btn] anyObject] locationInView:self.tableView]];

    if (indexPath.row == 8) {
        ALERTSHOW(NSLocalizedString(@"提示", nil), NSLocalizedString(@"已添加到最多数量", nil));
        return;
    }
    NSDictionary *dic = self.dataArray[indexPath.section];

    NSArray *statusData = self.total_arr[indexPath.section];
    
    // 插入之前应该先寻找 数据库中 某设备 某组 的数据
    
    /*
    NSString *section_str = [NSString stringWithFormat:@"%d",indexPath.section];
    NSString *row_str = [NSString stringWithFormat:@"%d",indexPath.row];
    LoginResult *loginResult = [UDManager getLoginInfo];
    DefenceNameDAO *defenceDao = [[DefenceNameDAO alloc] init];
    Defence *defence = [[Defence alloc] init];
    NSArray *defences = [defenceDao findWithContactId:self.contact.contactId Section:section_str];
    
    
    NSString *min_num = [self returnDefencesMinNum:defences];
    defence.userId = loginResult.contactId;
    defence.ContactId = self.contact.contactId;
    defence.Section = section_str;
    defence.Row = row_str;
    defence.defenceName = min_num;
    [defenceDao insert:defence];
     
     */
    
    
    
    // 查询 新数组中 某个0 在原来数组的位置
    NSArray *pre_arr = self.statusData[indexPath.section];  //  [0 1 0 1 1 1 1 1] 旧
    NSArray *now_arr = self.total_arr[indexPath.section];  //   [0 0 1 1 1 1 1 1] 新
    
    NSInteger loc = 0;
    // 旧数组中 第一个未学习的位置
    for (NSNumber *num in pre_arr) {
        if ([num isEqual:@1]) {
            loc = [pre_arr indexOfObject:num];
        }
    }
    loc ++;
    
    switch (indexPath.section) {
        case 0:
        {
            self.isAdd = 1;
            
            self.loc =loc;
        }
            break;
        case 1:
        {
            self.isAdd1 = 1;
            self.loc1 =loc;
        }
            break;
        case 2:
        {

            self.isAdd2 = 1;

            self.loc2 =loc;
        }
            break;
        case 3:
        {

            self.isAdd3 = 1;

            self.loc3 =loc;
        }
            break;
        case 4:
        {
            self.isAdd4 = 1;

            self.loc4 =loc;
        }
            break;
        case 5:
        {

            self.isAdd5 = 1;

            self.loc5 =loc;
        }
            break;
        case 6:
        {

            self.isAdd6 = 1;

            self.loc6 =loc;
        }
            break;
        case 7:
        {
            self.isAdd7 = 1;

            self.loc7 =loc;
        }
            break;
        case 8:
        {

            self.isAdd8 = 1;
            self.loc8 =loc;
        }
            break;
            
        default:
            break;
    }
    
    
    
    
    
    
    
    
    
    switch (indexPath.section) {
        case 0:
            if (self.counttag<9) {
                
                if ((self.counttag>1)) {
                    if (([statusData[self.counttag-2] intValue] == 1)) {
                        [[[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"当前存在未学习的设备", nil) delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
                        
                        return;
                    }
                }
            
                self.counttag=self.counttag+1;
            }
            break;
        case 1:
            if (self.counttag1<9) {
                
                if ((self.counttag1>1)) {
                    if (([statusData[self.counttag1-2] intValue] == 1)) {
                        [[[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"当前存在未学习的设备", nil) delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
                        return;
                    }
                }

                
                self.counttag1=self.counttag1+1;
            }
            break;
        case 2:
            if (self.counttag2<9) {
                if ((self.counttag2>1)) {
                    if (([statusData[self.counttag2-2] intValue] == 1)) {
                        [[[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"当前存在未学习的设备", nil) delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
                        return;
                    }
                }
                
                self.counttag2=self.counttag2+1;
            }
            break;
        case 3:
            if (self.counttag3<9) {
                if ((self.counttag3>1)) {
                    if (([statusData[self.counttag3-2] intValue] == 1)) {
                        [[[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"当前存在未学习的设备", nil) delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
                        return;
                    }
                }
                
                self.counttag3=self.counttag3+1;
            }
            break;
        case 4:
            if (self.counttag4<9) {
                if ((self.counttag4>1)) {
                    if (([statusData[self.counttag4-2] intValue] == 1)) {
                        [[[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"当前存在未学习的设备", nil) delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
                        return;
                    }
                }
                
                self.counttag4=self.counttag4+1;
            }
            break;
        case 5:
            if (self.counttag5<9) {
                if ((self.counttag5>1)) {
                    if (([statusData[self.counttag5-2] intValue] == 1)) {
                        [[[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"当前存在未学习的设备", nil) delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
                        return;
                    }
                }
                
                self.counttag5=self.counttag5+1;
            }
            break;
        case 6:
            if (self.counttag<9) {
                if ((self.counttag6>1)) {
                    if (([statusData[self.counttag6-2] intValue] == 1)) {
                        [[[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"当前存在未学习的设备", nil) delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
                        return;
                    }
                }
                
                self.counttag6=self.counttag6+1;
            }
            break;
        case 7:
            if (self.counttag7<9) {
                if ((self.counttag7>1)) {
                    if (([statusData[self.counttag7-2] intValue] == 1)) {
                        [[[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"当前存在未学习的设备", nil) delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
                        return;
                    }
                }
                
                self.counttag7=self.counttag7+1;
            }
            break;
            
        case 8:
            if (self.counttag8<9) {
                if ((self.counttag8>1)) {
                    if (([statusData[self.counttag8-2] intValue] == 1)) {
                        [[[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"当前存在未学习的设备", nil) delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
                        return;
                    }
                }
                
                self.counttag8=self.counttag8+1;
            }
            break;

            
        default:
            break;
    }
     
    
    
//    NSArray *tempArr = self.dataArray;
//    for (int index = 0; index < tempArr.count; index ++) {
//        if (index == indexPath.section) {
//            NSDictionary *dic = [tempArr objectAtIndex:index];
//            NSMutableArray *statusData = [dic objectForKey:@"statusData"];
//            for (int index = 0; index < statusData.count; index ++) {
//                if (index == indexPath.row) {
//                    NSNumber *result = @0;
//                    [statusData replaceObjectAtIndex:index withObject:result];
//                    
//                }
//            }
//        }
//        
//    }
    
    
    
    
    
    [self.tableView reloadData];

    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 8) {
        return;
    }
    
    if (self.counttag<8){
//        if (indexPath.row!=(self.counttag-1)) {
        // 查询 新数组中 某个0 在原来数组的位置
        NSArray *pre_arr = self.statusData[indexPath.section];  //  [0 1 0 1 1 1 1 1] 旧
        NSArray *now_arr = self.total_arr[indexPath.section];  //   [0 0 1 1 1 1 1 1] 新
        
        NSInteger loc = 0;
        // 旧数组中 第一个未学习的位置
        for (NSNumber *num in pre_arr) {
            if ([num isEqual:@1]) {
                loc = [pre_arr indexOfObject:num];
            }
        }
    
    int section = indexPath.section;
    self.lastSetGroup = section;
    int row = loc;
    self.lastSetItem = row;
//    NSDictionary *dic = self.dataArray[section];
        NSArray *statusData = self.statusData[section];
        NSArray *total = self.total_arr[section];
    if ([total[indexPath.row] intValue] == 1) {//开学习
        self.lastSetType = 0;
        
        
        int temp_tag ;
        if (section == 0) {
            temp_tag = self.counttag ;
        }else if (section == 1)
        {
            temp_tag = self.counttag1 ;
        }else if (section == 2)
        {
            temp_tag = self.counttag2;
        }else if (section == 3)
        {
            temp_tag = self.counttag3  ;
        }else if (section == 4)
        {
            temp_tag = self.counttag4  ;
        }else if (section == 5)
        {
            temp_tag = self.counttag5  ;
        }else if (section == 6)
        {
            temp_tag = self.counttag6 ;
        }else if (section == 7)
        {
            temp_tag = self.counttag7 ;
        }else {
            temp_tag = self.counttag8 ;
        }
        
        if (temp_tag == indexPath.row + 2) {// temp_tag = 9
            
            UIAlertView *learnAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"learn_defence_prompt", nil) message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"ok", nil),nil];
            learnAlert.tag = ALERT_TAG_LEARN;
            [learnAlert show];
//            [learnAlert release];
            
        }else
        {
            
        }
        
    }else{//关学习
//        self.lastSetType = 1;
//        
//        UIAlertView *clearAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"clear_defence_prompt", nil) message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"ok", nil),nil];
//        clearAlert.tag = ALERT_TAG_CLEAR;
//        [clearAlert show];
//        [clearAlert release];
    }
//        }
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.counttag<8){
//        if (indexPath.row!=(self.counttag-1)) {
        
            int section = indexPath.section;
            self.lastSetGroup = section;
            int row = indexPath.row;
            self.lastSetItem = row;
            NSDictionary *dic = self.dataArray[section];
            NSArray *statusData = [dic valueForKey:@"statusData"];
       
        int temp_tag ;
        if (section == 0) {
            temp_tag = self.counttag ;
        }else if (section == 1)
        {
            temp_tag = self.counttag1 ;
        }else if (section == 2)
        {
            temp_tag = self.counttag2;
        }else if (section == 3)
        {
            temp_tag = self.counttag3  ;
        }else if (section == 4)
        {
            temp_tag = self.counttag4  ;
        }else if (section == 5)
        {
            temp_tag = self.counttag5  ;
        }else if (section == 6)
        {
            temp_tag = self.counttag6 ;
        }else if (section == 7)
        {
            temp_tag = self.counttag7 ;
        }else {
            temp_tag = self.counttag8 ;
        }
        
        if (temp_tag == 8) {
            return UITableViewCellEditingStyleDelete;
        }else
        {
            if (temp_tag == row + 1) {
                return UITableViewCellEditingStyleNone;
            }else
            {
                return UITableViewCellEditingStyleDelete;
            }
            
        }
//            if (![statusData[row] intValue] == 1){
//              return UITableViewCellEditingStyleDelete;
//            }else{
//              return UITableViewCellEditingStyleNone;
//            }
        
//        }
    }
    return YES;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    switch (indexPath.section) {
        case 0:
        {
            self.isAdd = 0;
        }
            break;
        case 1:
        {
            self.isAdd1 = 0;
        }
            break;
        case 2:
        {
            self.isAdd2 = 0;
        }
            break;
        case 3:
        {
            self.isAdd3 = 0;
        }
            break;
        case 4:
        {
            self.isAdd4 = 0;
        }
            break;
        case 5:
        {
            self.isAdd5 = 0;
        }
            break;
        case 6:
        {
            self.isAdd6 = 0;
        }
            break;
        case 7:
        {
            self.isAdd7 = 0;
        }
            break;
        case 8:
        {
            self.isAdd8 = 0;
        }
            break;
            
        default:
            break;
    }
    
    
    if (self.counttag<8){
        NSLog(@"indexPath.row=%d,count=%ld",indexPath.row,(long)self.counttag);
        
            int section = indexPath.section;
            self.lastSetGroup = section;
            int row = indexPath.row;
            self.lastSetItem = row;
//            NSDictionary *dic = self.dataArray[section];
//            NSArray *statusData = [dic valueForKey:@"statusData"];
        NSArray *statusData = self.total_arr[section];
        

            if (![statusData[row] intValue] == 1){ // 已经设置成0 (已对码成功)
                
                self.lastSetType = 1;
                
                UIAlertView *clearAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"clear_defence_prompt", nil) message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"ok", nil),nil];
                clearAlert.tag = ALERT_TAG_CLEAR;
                [clearAlert show];
//                [clearAlert release];

            
            }else
            {
                NSInteger section = self.lastSetGroup;
                if (section == 0) {
                    self.counttag -- ;
                }else if (section == 1)
                {
                    self.counttag1 -- ;
                }else if (section == 2)
                {
                    self.counttag2 -- ;
                }else if (section == 3)
                {
                    self.counttag3 -- ;
                }else if (section == 4)
                {
                    self.counttag4 -- ;
                }else if (section == 5)
                {
                    self.counttag5 -- ;
                }else if (section == 6)
                {
                    self.counttag6 -- ;
                }else if (section == 7)
                {
                    self.counttag7 -- ;
                }else if (section == 8)
                {
                    self.counttag8 -- ;
                }
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:self.lastSetItem inSection:self.lastSetGroup], nil] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
}

#pragma mark - alert - click
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch(alertView.tag){
        case ALERT_TAG_CLEAR:
        {
            if(buttonIndex==0){
                
            }else if(buttonIndex==1){
                self.progressAlert.dimBackground = YES;
                self.progressAlert.labelText = NSLocalizedString(@"clearing", nil);
                [self.progressAlert show:YES];
                
                
                self.isLoadDefenceArea = YES;
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:self.lastSetItem inSection:self.lastSetGroup], nil] withRowAnimation:UITableViewRowAnimationNone];
                
                /*
                NSArray *tempArr = self.dataArray;
                for (int index = 0; index < tempArr.count; index ++) {
                    if (index == self.lastSetGroup) {
                        NSDictionary *dic = [tempArr objectAtIndex:index];
                        NSMutableArray *statusData = [dic objectForKey:@"statusData"];
                        for (int index = 0; index < statusData.count; index ++) {
                            if (index == self.lastSetItem) {
                                NSNumber *result = @1;
                                [statusData replaceObjectAtIndex:index withObject:result];
                                
                            }
                        }
                    }
                    
                }
                 */
                
                NSInteger section = self.lastSetGroup;
                if (section == 0) {
                    self.counttag -- ;
                }else if (section == 1)
                {
                    self.counttag1 -- ;
                }else if (section == 2)
                {
                    self.counttag2 -- ;
                }else if (section == 3)
                {
                    self.counttag3 -- ;
                }else if (section == 4)
                {
                    self.counttag4 -- ;
                }else if (section == 5)
                {
                    self.counttag5 -- ;
                }else if (section == 6)
                {
                    self.counttag6 -- ;
                }else if (section == 7)
                {
                    self.counttag7 -- ;
                }else if (section == 8)
                {
                    self.counttag8 -- ;
                }
                
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:self.lastSetItem inSection:self.lastSetGroup], nil] withRowAnimation:UITableViewRowAnimationNone];
                
                NSArray *pre_arr = self.statusData[section];
                int num_zero = -1;
                int pre_loc = 0;
                for (int index = 0; index < pre_arr.count; index ++) { // 遍历原数组
                    NSNumber *num = [pre_arr objectAtIndex:index];
                    if ([num isEqual:@0]) {
                        num_zero ++ ;
                        if (num_zero  == self.lastSetItem) { // lastSetItem 为新数组中 0所在的位置
                            pre_loc = index;
                        }
                    }
                }
                
                // 删除数据
                DefenceNameDAO *defenceDAO = [[DefenceNameDAO alloc] init];
                [defenceDAO removeSection:[NSString stringWithFormat:@"%ld",(long)self.lastSetGroup] Row:[NSString stringWithFormat:@"%d",pre_loc] ContactId:self.contact.contactId];
                
                
                [[P2PClient sharedClient] setDefenceAreaState:self.contact.contactId password:self.contact.contactPassword group:self.lastSetGroup item:pre_loc type:self.lastSetType];
                
                
                
                
            }
        }
            break;
        case ALERT_TAG_LEARN:
        {
            if(buttonIndex==0){
                
            }else if(buttonIndex==1){
                self.progressAlert.dimBackground = YES;
                self.progressAlert.labelText = NSLocalizedString(@"learning", nil);
                [self.progressAlert show:YES];
                
                self.isLoadDefenceArea = YES;
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:self.lastSetItem inSection:self.lastSetGroup], nil] withRowAnimation:UITableViewRowAnimationNone];
                
                [[P2PClient sharedClient] setDefenceAreaState:self.contact.contactId password:self.contact.contactPassword group:self.lastSetGroup item:self.lastSetItem type:self.lastSetType];
            }
        }
            break;
        case ALERT_TAG_RESET_NAME:
        {
            if (buttonIndex == 1) {
                // data source
                LoginResult *loginResult = [UDManager getLoginInfo];
                DefenceNameDAO *defenceDAO = [[DefenceNameDAO alloc] init];
                Defence *defence = [[Defence alloc] init];
                
                
                
                
//                // 删除原本数据
                [defenceDAO removeSection:[NSString stringWithFormat:@"%d",self.section] Row:[NSString stringWithFormat:@"%ld",(long)self.row] ContactId:self.contact.contactId];
//
//                // set data
                
                UITextField *tf= [alertView textFieldAtIndex:0];
                [self insertDefenceWithSection:[NSString stringWithFormat:@"%d",self.section] Row:[NSString stringWithFormat:@"%ld",(long)self.row] Name:tf.text];
                
                // 刷新数据
                
                
                
//                Defence *def = [defenceDAO findDefenceNameWithContactId:self.contact.contactId Section:[NSString stringWithFormat:@"%d",self.section] Row:[NSString stringWithFormat:@"%d",self.row]];
                
                // 插入数据
                [self.tableView reloadData];
                
            }
        }
            
    }
}

-(void)defenceCell:(DefenceCell *)defenceCell section:(NSInteger)section row:(NSInteger)row{
    NSDictionary *dic = self.dataArray[section];
    NSArray *switchStatusData = [dic valueForKey:@"switchStatusData"];
    
    if (section > 0) {
        if ([switchStatusData[row] intValue] == 0) {//启用
            self.isLoadDefenceSwitch = YES;
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:row inSection:section], nil] withRowAnimation:UITableViewRowAnimationNone];
            
            self.lastSetSwitchGroup = section-1;
            self.lastSetSwitchItem = row;
            self.lastSetSwitchType = 1;
            [[P2PClient sharedClient] setDefenceSwitchStateWithId:self.contact.contactId password:self.contact.contactPassword switchId:1 alarmCodeId:section-1 alarmCodeIndex:row];
        }else{//禁用
            self.isLoadDefenceSwitch = YES;
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:row inSection:section], nil] withRowAnimation:UITableViewRowAnimationNone];
        
            self.lastSetSwitchGroup = section-1;
            self.lastSetSwitchItem = row;
            self.lastSetSwitchType = 0;
            [[P2PClient sharedClient] setDefenceSwitchStateWithId:self.contact.contactId password:self.contact.contactPassword switchId:0 alarmCodeId:section-1 alarmCodeIndex:row];
        }
    }
}
-(void)setname:(DefenceCell *)defenceCell section:(NSInteger)section row:(NSInteger)row{
    
    
    NSLog(@"section=%ld,row=%ld",(long)section,(long)row);
    self.section = section;
    NSArray *pre_arr = self.statusData[section];
    int num_zero = -1;
    int pre_loc = 0;
    for (int index = 0; index < pre_arr.count; index ++) { // 遍历原数组
        NSNumber *num = [pre_arr objectAtIndex:index];
        if ([num isEqual:@0]) {
            num_zero ++ ;
            if (num_zero  == row) { // lastSetItem 为新数组中 0所在的位置
                pre_loc = index;
            }
        }
    }
    self.row = pre_loc;
    
    
    UIAlertView *aler = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"对该设备重新命名", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"ok", nil), nil];
    aler.alertViewStyle = UIAlertViewStylePlainTextInput;
    aler.tag = ALERT_TAG_RESET_NAME;
    
    [aler show];
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"对当前选择防区重新命名" preferredStyle:UIAlertControllerStyleAlert];
//    
//    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//        //        textField.placeholder = @"密码";
//        //        textField.secureTextEntry = YES;
//    }];
//    
//    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    
//    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//    UITextField *login = alert.textFields.firstObject;
//        
//        
//        NSLog(@"textField==%@",login.text);
//    }];
//    
//    [alert addAction:cancel];
//    [alert addAction:confirm];
//    [self presentViewController:alert animated:YES completion:nil];
    
}

- (NSString *)returnDefencesMinNum:(NSArray *)defences
{
    if (defences.count) {
        NSMutableArray *num_Arr = [NSMutableArray array];
        for (int index = 0; index < defences.count; index ++) {
            Defence *defence = [defences objectAtIndex:index];
            [num_Arr addObject:defence.Row];
        }
        
        NSInteger find = 8;
        for (int i = 0; i <= 7; i++) {
            if ([num_Arr indexOfObject:@(i)] == NSNotFound)
            {
                find = i;
                break;
            }
        }
        return [NSString stringWithFormat:@"%ld",(long)find];
        
    }else
    {
        return @"1";
    }
}

// 插入一条defence 数据
- (void)insertDefenceWithSection:(NSString *)section Row:(NSString *)row Name:(NSString *)name
{
    DefenceNameDAO *defenceDAO = [[DefenceNameDAO alloc] init];
    Defence *defence = [[Defence alloc] init];
    LoginResult *result = [UDManager getLoginInfo];
    
    defence.userId = result.contactId;
    defence.defenceName = name;
    defence.ContactId = self.contact.contactId;
    defence.Section = section;
    defence.Row = row;
    
    [defenceDAO insert:defence];
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
