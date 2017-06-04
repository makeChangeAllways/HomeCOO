//
//  KeyBoardController.h
//  2cu
//
//  Created by guojunyi on 14-3-20.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ALERT_TAG_MONITOR 0
@interface KeyBoardController : UIViewController<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UILabel *inputLabel;
@property (strong, nonatomic) UITableView *tableView;
@property (retain, nonatomic) NSArray *contacts;
@end
