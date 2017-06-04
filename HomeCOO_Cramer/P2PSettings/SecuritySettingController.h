//
//  SecuritySettingController.h
//  2cu
//
//  Created by guojunyi on 14-5-14.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FListManager.h"
#import "MBProgressHUD.h"
@class Contact;
@interface SecuritySettingController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) Contact *contact;

@property(assign) BOOL isFirstLoadingCompolete;
@property (strong,nonatomic) UISwitch *autoUpdateSwitch;
@property (nonatomic) BOOL isLoadingAutoUpdate;
@property(assign) NSInteger autoUpdateState;
@property (assign) NSInteger lastAutoUpdateState;

@property (nonatomic) BOOL isSupportAutoUpdate;

@property (nonatomic) BOOL manageisOpen;
@property (nonatomic) BOOL accessisOpen;
@property (strong, nonatomic) UITextField *oldtf;
@property (strong, nonatomic) UITextField *newtf;
@property (strong, nonatomic) UITextField *retf;
@property (strong, nonatomic) UITextField *vistf;
@property (strong, nonatomic) MBProgressHUD *progressAlert;
@property (strong, nonatomic) UIImageView *imageview1;
@property (strong, nonatomic) UIImageView *imageview2;
@property (strong, nonatomic) NSString *lastSetOriginPassowrd;
@property (strong, nonatomic) NSString *lastSetNewPassowrd;
@property (strong, nonatomic) NSString *lastSetNewPassowrd2;
@end
