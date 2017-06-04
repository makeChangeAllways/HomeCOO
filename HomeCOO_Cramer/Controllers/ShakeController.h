//
//  ShakeController.h
//  2cu
//
//  Created by guojunyi on 14-9-29.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDAsyncUdpSocket.h"
#import "ShakeCell.h"
@interface ShakeController : UIViewController<UITableViewDataSource,UITableViewDelegate,ShakeCellDelegate>
@property (strong, nonatomic) UIImageView *animView;
@property (assign) BOOL isSearching;
@property (assign) BOOL isRun;
@property (assign) BOOL isPrepared;
@property (strong, nonatomic) GCDAsyncUdpSocket *socket;

@property (retain, nonatomic) NSMutableDictionary *types;
@property (retain, nonatomic) NSMutableDictionary *flags;
@property (retain, nonatomic) NSMutableDictionary *addresses;
@property (strong,nonatomic) UITableView *tableView;

@property (strong,nonatomic) UIView *toastView;

@property (assign) BOOL isNotNeedReloadData;
@end
