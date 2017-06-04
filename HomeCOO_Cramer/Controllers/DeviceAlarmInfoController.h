//
//  DeviceAlarmInfoController.h
//  2cu
//
//  Created by gwelltime on 15-3-30.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//


#import <UIKit/UIKit.h>
@class Contact;
@class  MBProgressHUD;
@class Contact;
@interface DeviceAlarmInfoController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *alarmHistory;
@property (strong, nonatomic) Contact *contact;
@property (strong, nonatomic) MBProgressHUD *progressAlert;
@property (nonatomic,strong) UIImageView *noresult;
@property (nonatomic,strong) NSString *deviceids;

@property(nonatomic,strong)NSString *is_in;

@end
