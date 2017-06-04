////
////  SettingEditController.m
////  2cu
////
////  Created by mac on 15/10/19.
////  Copyright (c) 2015年 guojunyi. All rights reserved.
////  编辑用户信息界面
//
//#import "SettingEditController.h"
//#import "MainController.h"
//#import "AppDelegate.h"
//#import "SettingGroup.h"
//#import "SettingBaseItem.h"
//#import "SettingArrowItem.h"
//#import "SettingSwitchItem.h"
//#import "SettingBaseCell.h"
//#import "LoginResult.h"
//#import "UDManager.h"
//#import "SettingChangeEmailController.h"
//#import "BindingPhonoController.h"
//#import "UnBindPhoneController.h"
//#import "ModifyLoginPasswordController.h"
//#import "SettingSystemController.h"
//#import "BindEmailController.h"
//#import "BindPhoneController.h"
//#import "NetManager.h"
//
//
//static NSString *reuseIdentifier = @"setting_item";  // TableView 重用标示
//
//@interface SettingEditController () <UITableViewDataSource , UITableViewDelegate,UIAlertViewDelegate>
//@property(nonatomic,strong)UITableView *tableView;
//@property(nonatomic,strong)NSMutableArray *TableView_titles;
//
//@end
//
//@implementation SettingEditController
//
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    [self UI_init];
//    [self DATA_init];
//    
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//}
//
//#pragma mark - 懒加载
//// tableView 标题数组
//- (NSMutableArray *)TableView_titles
//{
//    if (_TableView_titles == nil) {
//        _TableView_titles = [NSMutableArray array];
//    }
//    return _TableView_titles;
//}
//
//
//
//
//
//#pragma mark --- 初始化界面
//- (void)UI_init
//{
//    // base setting
////    self.topBar.titleLabel.text = @"账户信息";
////    [self.topBar setBackButtonHidden:NO];
////    [self.topBar setHidden:NO];
//    
//    CGRect rect = [AppDelegate getScreenSize:YES isHorizontal:NO];
//    CGFloat width = rect.size.width;
////    CGFloat height = rect.size.height;
//    [self.view setBackgroundColor:XBgColor];
//    TopBar *topBar = [[TopBar alloc] initWithFrame:CGRectMake(0, 0, width, NAVIGATION_BAR_HEIGHT)];
//    [topBar setBackButtonHidden:NO];
//    
//    
//    [topBar.backButton addTarget:self action:@selector(onBackPress) forControlEvents:UIControlEventTouchUpInside];
//    [topBar setTitle:NSLocalizedString(@"account_info",nil)];
//    [self.view addSubview:topBar];
//
//    
//    MainController *mainController = [AppDelegate sharedDefault].mainController;
//    
//    [mainController setBottomBarHidden:YES];
//    
//    
//    // tableView
//    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
//    tableView.frame = CGRectMake(0, BottomForView(topBar), self.view.frame.size.width, self.view.frame.size.height - BottomForView(topBar));
//    [self.view addSubview:tableView];
//    self.tableView = tableView;
//    tableView.delegate = self;
//    tableView.dataSource = self;
//    [tableView registerNib:[UINib nibWithNibName:@"SettingBaseCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
//    self.tableView.backgroundColor = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:255/255.0];
////    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//}
//-(void)onBackPress{
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//
//#pragma mark --- 初始化数据
//-(void)DATA_init
//{
//    // 初始化group1 -- tableView 的数据
//    SettingGroup *group_one = [[SettingGroup alloc] init];
//    
//    LoginResult *loginResult = [UDManager getLoginInfo];
//    
//    NSString *account_id = loginResult.contactId;  // 账号id
//    NSString *user_email = loginResult.email; // 邮箱
//    NSString *user_phone = loginResult.phone; // 手机号码
//    
//    
//    
//    SettingArrowItem *base_one = [SettingArrowItem settingItemWithIcon:account_id AndTitle:@"账号" ToDestViewControl:nil];
//    SettingArrowItem *base_two = [SettingArrowItem settingItemWithIcon:user_email AndTitle:@"我的邮箱" ToDestViewControl:nil];
//    __unsafe_unretained SettingEditController *wself = self;
//    base_two.block1 = ^{  // 回调打开修改邮箱界面
//        
////        SettingChangeEmailController *change_Email = [[SettingChangeEmailController alloc] init];
////        change_Email.pre_email = user_email;
////        [wself.navigationController pushViewController:change_Email animated:YES];
//        
//        
//        if(loginResult.email&&loginResult.email.length>0){
//            UIAlertView *unBindEmailAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"sure_to_unbind_email", nil) message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"ok", nil),nil];
//            unBindEmailAlert.tag = ALERT_TAG_UNBIND_EMAIL;
//            [unBindEmailAlert show];
//
//        }else{
//            BindEmailController *bindEmailController = [[BindEmailController alloc] init];
//            [self.navigationController pushViewController:bindEmailController animated:YES];
//    
//        }
//
//        
//        
//    };
//    SettingArrowItem *base_third = [SettingArrowItem settingItemWithIcon:user_phone AndTitle:@"我的手机" ToDestViewControl:nil];
//    base_third.block1 = ^{ // 回调修改手机
//        
////        if (user_phone.length) {  // 有绑定的手机号码
////            
////            UnBindPhoneController *un_bind = [[UnBindPhoneController alloc] init];
////            un_bind.pre_phone = user_phone;
////            [wself.navigationController pushViewController:un_bind animated:YES];
////            
////        }else
////        {
//        if(loginResult.phone&&loginResult.phone.length>0){
//            UIAlertView *unBindEmailAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"sure_to_unbind_phone", nil) message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"ok", nil),nil];
//            unBindEmailAlert.tag = ALERT_TAG_UNBIND_PHONE;
//        }else{
//            BindPhoneController *bindPhoneController = [[BindPhoneController alloc] init];
//            bindPhoneController.accountController = self;
//            [self.navigationController pushViewController:bindPhoneController animated:YES];
//        }
//
////        }
//    };
//    group_one.items = @[base_one,base_two,base_third];
//    
//    
//    SettingGroup *group_two = [[SettingGroup alloc] init];
//    SettingArrowItem *base_four = [SettingArrowItem settingItemWithIcon:nil AndTitle:@"修改登录密码" ToDestViewControl:@"Dontshow"];
//    base_four.block1 = ^ {
//        ModifyLoginPasswordController *modifyLoginPasswordController = [[ModifyLoginPasswordController alloc] init];
//        [self.navigationController pushViewController:modifyLoginPasswordController animated:YES];
//    };
//    group_two.items = @[base_four];
//    [self.TableView_titles addObject:group_one];
//    [self.TableView_titles addObject:group_two];
//    
//    
//}
//
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    switch(alertView.tag){
//        case ALERT_TAG_UNBIND_EMAIL:
//        {
//            if(buttonIndex==1){
//                
//                UIAlertView *inputAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"input_login_password", nil) message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"ok", nil), nil];
//                inputAlert.alertViewStyle = UIAlertViewStyleSecureTextInput;
//                UITextField *passwordField = [inputAlert textFieldAtIndex:0];
//                inputAlert.tag = ALERT_TAG_UNBIND_EMAIL_AFTER_INPUT_PASSWORD;
//                [inputAlert show];
//   
//            }
//        }
//            break;
//        case ALERT_TAG_UNBIND_EMAIL_AFTER_INPUT_PASSWORD:
//        {
//            if(buttonIndex==1){
//                self.progressAlert.dimBackground = YES;
//                [self.progressAlert show:YES];
//                UITextField *passwordField = [alertView textFieldAtIndex:0];
//                NSString *inputPwd = passwordField.text;
//                LoginResult *loginResult = [UDManager getLoginInfo];
//                [[NetManager sharedManager] setAccountInfo:loginResult.contactId password:inputPwd phone:loginResult.phone email:@"" countryCode:loginResult.countryCode phoneCheckCode:@"" flag:@"2" sessionId:loginResult.sessionId callBack:^(id JSON){
//                    [self.progressAlert hide:YES];
//                    NSInteger error_code = (NSInteger)JSON;
//                    switch (error_code) {
//                        case NET_RET_SET_ACCOUNT_SUCCESS:
//                        {
//                            loginResult.email = @"";
//                            [UDManager setLoginInfo:loginResult];
//                            [self.view makeToast:NSLocalizedString(@"operator_success", nil)];
//                            [self.tableView reloadData];
//                            
//                        }
//                            break;
//                        case NET_RET_SET_ACCOUNT_PASSWORD_ERROR:
//                        {
//                            [self.view makeToast:NSLocalizedString(@"password_error", nil)];
//                        }
//                            break;
//                        default:
//                        {
//                            [self.view makeToast:[NSString stringWithFormat:@"%@:%i",NSLocalizedString(@"unknown_error", nil),error_code]];
//                        }
//                            break;
//                    }
//                }];
//            }
//        }
//            break;
//        case ALERT_TAG_UNBIND_PHONE:
//        {
//            if(buttonIndex==1){
//                
//                UIAlertView *inputAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"input_login_password", nil) message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"ok", nil), nil];
//                inputAlert.alertViewStyle = UIAlertViewStyleSecureTextInput;
//                UITextField *passwordField = [inputAlert textFieldAtIndex:0];
//                inputAlert.tag = ALERT_TAG_UNBIND_PHONE_AFTER_INPUT_PASSWORD;
//                [inputAlert show];
//
//            }
//        }
//            break;
//        case ALERT_TAG_UNBIND_PHONE_AFTER_INPUT_PASSWORD:
//        {
//            if(buttonIndex==1){
//                self.progressAlert.dimBackground = YES;
//                [self.progressAlert show:YES];
//                UITextField *passwordField = [alertView textFieldAtIndex:0];
//                NSString *inputPwd = passwordField.text;
//                LoginResult *loginResult = [UDManager getLoginInfo];
//                [[NetManager sharedManager] setAccountInfo:loginResult.contactId password:inputPwd phone:@"" email:loginResult.email countryCode:@"" phoneCheckCode:@"" flag:@"1" sessionId:loginResult.sessionId callBack:^(id JSON){
//                    [self.progressAlert hide:YES];
//                    NSInteger error_code = (NSInteger)JSON;
//                    switch (error_code) {
//                        case NET_RET_SET_ACCOUNT_SUCCESS:
//                        {
//                            loginResult.phone = @"";
//                            loginResult.countryCode = @"";
//                            [UDManager setLoginInfo:loginResult];
//                            [self.view makeToast:NSLocalizedString(@"operator_success", nil)];
//                            
//                            [self.tableView reloadData];
//                            
//                        }
//                            break;
//                        case NET_RET_SET_ACCOUNT_PASSWORD_ERROR:
//                        {
//                            [self.view makeToast:NSLocalizedString(@"password_error", nil)];
//                        }
//                            break;
//                        default:
//                        {
//                            [self.view makeToast:[NSString stringWithFormat:@"%@:%i",NSLocalizedString(@"unknown_error", nil),error_code]];
//                        }
//                            break;
//                    }
//                }];
//            }
//        }
//            
//    }
//}
//
//
//#pragma mark - tableView dataResource
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return self.TableView_titles.count;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    SettingGroup *group = self.TableView_titles[section];
//    return group.items.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    SettingBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
//    SettingGroup *group = self.TableView_titles[indexPath.section];
//    SettingBaseItem *item = group.items[indexPath.row];
//    cell.item = item;
//    return cell;
//}
//
//
//#pragma mark - tableView delegate
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    SettingGroup *group = self.TableView_titles[indexPath.section];
//    SettingBaseItem *item = group.items[indexPath.row];
//    if (item.block1) {
//        item.block1();  // 调用代码块
//    }
//    
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 0.0f;
//}
//
//
//
//@end
