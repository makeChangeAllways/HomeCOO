//
//  ChooseCountryController.h
//  Yoosee
//
//  Created by guojunyi on 14-5-21.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface selectCountryController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSArray *countrys_zh;
@property (strong,nonatomic) NSArray *countrys_en;
@property (strong,nonatomic) NSArray *countrys;
@property (strong,nonatomic) NSArray *datas;

@property (strong,nonatomic) UILabel *promptView;
@end
