//
//  SettingEditController.h
//  2cu
//
//  Created by mac on 15/10/19.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//

#import "BaseViewController.h"
#define ALERT_TAG_UNBIND_EMAIL 0
#define ALERT_TAG_UNBIND_EMAIL_AFTER_INPUT_PASSWORD 1

#define ALERT_TAG_UNBIND_PHONE 2
#define ALERT_TAG_UNBIND_PHONE_AFTER_INPUT_PASSWORD 3
@class MBProgressHUD;
@interface SettingEditController : UIViewController
@property (strong, nonatomic) MBProgressHUD *progressAlert;
@end
