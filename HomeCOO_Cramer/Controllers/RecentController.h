//
//  RecentController.h
//  2cu
//
//  Created by guojunyi on 14-3-21.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ALERT_TAG_DELETE 0
#define ALERT_TAG_CLEAR 1
@interface RecentController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (retain, nonatomic) NSMutableArray *recents;
@property (strong, nonatomic) UITableView *tableView;
@property (retain, nonatomic) NSIndexPath *curDelIndexPath;
@end
