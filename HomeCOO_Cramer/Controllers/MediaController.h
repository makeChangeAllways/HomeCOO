//
//  MediaController.h
//  2cu
//
//  Created by mac on 15/5/12.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScreenshotCell.h"
#import "AlarmalertView.h"

@interface MediaController : UIViewController<UITableViewDelegate,UITableViewDataSource,ScreenshotCellDelegate,UIAlertViewDelegate>
@property (assign) NSInteger mediaType;
@property (retain, nonatomic) NSMutableArray *screenshotFiles;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *detailImageView;
@property (nonatomic) BOOL isShowDetail;
@property (strong, nonatomic) UISegmentedControl *segment;
@property (strong, nonatomic) AlarmalertView *popView;
@property (strong, nonatomic) UIImageView *noresult;
@property(strong, nonatomic) UIView *movieView;
@end
