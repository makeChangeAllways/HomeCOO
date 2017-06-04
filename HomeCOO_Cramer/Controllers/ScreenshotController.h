//
//  ScreenshotController.h
//  2cu
//
//  Created by guojunyi on 14-4-3.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScreenshotCell.h"
@class Stack;
#define ALERT_TAG_CLEAR 0
@interface ScreenshotController : UIViewController<UITableViewDataSource,UITableViewDelegate,ScreenshotCellDelegate,UIAlertViewDelegate>
@property (retain, nonatomic) NSMutableArray *screenshotFiles;


@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIButton *detailImageView;
@property (nonatomic) BOOL isShowDetail;
@end
