//
//  DefenceAreaSettingController.h
//  2cu
//
//  Created by guojunyi on 14-5-20.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefenceCell.h"
#define ALERT_TAG_CLEAR 0
#define ALERT_TAG_LEARN 1
#define ALERT_TAG_RESET_NAME 2
@class Contact;
@class  MBProgressHUD;

@interface DefenceAreaSettingController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIDefenceCellDelegate>
@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) Contact *contact;


@property(assign) NSInteger selectedIndex;

@property(nonatomic, strong) NSMutableArray *dataArray;
@property(strong,nonatomic) NSMutableArray *statusData;
@property(strong,nonatomic) NSMutableArray *switchStatusData;

@property(assign) BOOL isLoadDefenceArea;
@property(assign) BOOL isLoadDefenceSwitch;
@property(assign) BOOL isNotSurportDefenceSwitch;

@property(nonatomic) BOOL isNotRightPWD;
@property (strong, nonatomic) MBProgressHUD *progressAlert;

@property(assign) NSInteger lastSetGroup;
@property(assign) NSInteger lastSetItem;
@property(assign) NSInteger lastSetType;

@property(assign) NSInteger lastSetSwitchGroup;
@property(assign) NSInteger lastSetSwitchItem;
@property(assign) NSInteger lastSetSwitchType;
@property(assign) NSInteger counttag;
@property(assign) NSInteger counttag1;
@property(assign) NSInteger counttag2;
@property(assign) NSInteger counttag3;
@property(assign) NSInteger counttag4;
@property(assign) NSInteger counttag5;
@property(assign) NSInteger counttag6;
@property(assign) NSInteger counttag7;
@property(assign) NSInteger counttag8;

@property(assign) BOOL isSetting;

@property(assign) NSInteger isAdd;
@property(assign) NSInteger isAdd1;
@property(assign) NSInteger isAdd2;
@property(assign) NSInteger isAdd3;
@property(assign) NSInteger isAdd4;
@property(assign) NSInteger isAdd5;
@property(assign) NSInteger isAdd6;
@property(assign) NSInteger isAdd7;
@property(assign) NSInteger isAdd8;

@property(assign) NSInteger loc;
@property(assign) NSInteger loc1;
@property(assign) NSInteger loc2;
@property(assign) NSInteger loc3;
@property(assign) NSInteger loc4;
@property(assign) NSInteger loc5;
@property(assign) NSInteger loc6;
@property(assign) NSInteger loc7;
@property(assign) NSInteger loc8;


@end
