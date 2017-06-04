//
//  ServerAlarmInfoController.h
//  2cu
//
//  Created by gwelltime on 15-4-2.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Contact;
@class  MBProgressHUD;

@interface ServerAlarmInfoController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *alarmHistory;
@property (strong, nonatomic) Contact *contact;
@property (strong, nonatomic) MBProgressHUD *progressAlert;

@end
