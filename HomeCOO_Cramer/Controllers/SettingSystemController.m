//
//  SettingSystemController.m
//  2cu
//
//  Created by mac on 15/10/19.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//

#import "SettingSystemController.h"
#import "SettingArrowItem.h"
#import "SettingSwitchItem.h"
#import "MainController.h"
#import "AppDelegate.h"
#import "SettingGroup.h"
#import "SettingBaseItem.h"
#import "SettingArrowItem.h"
#import "SettingSwitchItem.h"
#import "SettingBaseCell.h"
#import "LoginResult.h"
#import "UDManager.h"
#import "PrefixHeader.pch"

static NSString *reuseIdentifier = @"system_item";  // TableView 重用标示

@interface SettingSystemController ()<UITableViewDelegate , UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *groups;


@end

@implementation SettingSystemController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UI_init];
    [self DATA_init];
    // Do any additional setup after loading the view.
}

- (NSMutableArray *)groups
{
    if (_groups == nil) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}


#pragma mark --- UI
- (void)UI_init
{
    // base setting
    self.topBar.titleLabel.text = @"账户信息";
    [self.topBar setBackButtonHidden:NO];
    [self.topBar setHidden:NO];
    MainController *mainController = [AppDelegate sharedDefault].mainController;
    
    [mainController setBottomBarHidden:YES];
    
    
    UILabel *label=[[UILabel alloc]init];
    [self.view addSubview:label];
    label.text=@"报警时间间隔";
    label.frame = CGRectMake(15, BottomForView(self.topBar)+30, 150, 40);
    
    
    // tableView
//    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
//    tableView.frame = CGRectMake(0, BottomForView(self.topBar), self.view.frame.size.width, self.view.frame.size.height - BottomForView(self.topBar));
//    [self.view addSubview:tableView];
//    self.tableView = tableView;
//    tableView.delegate = self;
//    tableView.dataSource = self;
//    tableView.sectionHeaderHeight = 0.0f;
//    tableView.sectionFooterHeight = 8.0f;
//    tableView.contentInset = UIEdgeInsetsMake(- 25, 0, 0, 0);
//    [tableView registerNib:[UINib nibWithNibName:@"SettingBaseCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
//    self.tableView.backgroundColor = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:255/255.0];

}
#pragma mark --- DATA
-(void)DATA_init
{
    SettingGroup *group_one = [[SettingGroup alloc] init];
    SettingSwitchItem *switch_1 = [SettingSwitchItem settingViewWithIcon:nil AndTitle:@"报警震动"];
    SettingSwitchItem *switch_2 = [SettingSwitchItem settingViewWithIcon:nil AndTitle:@"报警铃声"];
    SettingArrowItem *arrow_1 = [SettingArrowItem settingItemWithIcon:nil AndTitle:@"报警铃声" ToDestViewControl:@"Dontshow"];
    SettingArrowItem *arrow_2 = [SettingArrowItem settingItemWithIcon:nil AndTitle:@"报警时间间隔" ToDestViewControl:@"Dontshow"];
    group_one.items = @[switch_1,switch_2,arrow_1,arrow_2];
    
    SettingGroup *group_tow = [[SettingGroup alloc] init];
    SettingSwitchItem *switch_3 = [SettingSwitchItem settingViewWithIcon:nil AndTitle:@"通知栏挂机图标"];
    group_tow.items = @[switch_3];
    
    SettingGroup *group_three = [[SettingGroup alloc] init];
    SettingSwitchItem *switch_4 = [SettingSwitchItem settingViewWithIcon:nil AndTitle:@"自动启动"];
    group_three.items = @[switch_4];
    
    
    [self.groups addObject:group_one];
    [self.groups addObject:group_tow];
    [self.groups addObject:group_three];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    SettingGroup *group = self.groups[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    SettingGroup *group = self.groups[indexPath.section];
    SettingBaseItem *item = group.items[indexPath.row];
    cell.row = (int)indexPath.row;
    cell.section = (int)indexPath.section;
    cell.item = item;
    
    /*
    cell.switch_blk = ^(int row,int section){
        
        if (section == 0) { //
            
            switch (row) {
                case 0:
                {
                    ALERTSHOW(@"报警震动");
                }
                    break;
                case 1:
                {
                    ALERTSHOW(@"报警铃声");
                }
                    break;
                    
                default:
                    break;
            }
            
            
        }else if (section == 1)
        {
            ALERTSHOW(@"通知栏挂机图标");
            
        }else if (section == 2)
        {
            ALERTSHOW(@"自动启动");
            
        }
        
        
        
    };
    */
    return cell;
}


#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SettingGroup *group = self.groups[indexPath.section];
    SettingBaseItem *item = group.items[indexPath.row];
    if (item.block1) {
        item.block1();
    }
}


@end
