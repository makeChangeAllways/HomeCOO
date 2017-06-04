//
//  SettingController.h
//  2cu
//
//  Created by guojunyi on 14-3-20.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#define ALERT_TAG_EXIT 0
#define ALERT_TAG_LOGOUT 1
#define ALERT_TAG_UPDATE 2
@interface SettingController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,MBProgressHUDDelegate>

@property (strong, nonatomic) UIImageView *ic_net_type_view;
@property (strong, nonatomic) UIView *aboutView;
@end
