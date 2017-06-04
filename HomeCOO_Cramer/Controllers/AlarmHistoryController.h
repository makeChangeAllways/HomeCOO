//
//  AlarmHistoryController.h
//  2cu
//
//  Created by Jie on 14-10-22.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  MBProgressHUD;

@interface AlarmHistoryController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *alarmHistory;

@property (strong, nonatomic) MBProgressHUD *progressAlert;


@end
