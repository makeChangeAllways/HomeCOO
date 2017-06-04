//
//  BLTConnectVC.m
//  IRBT
//
//  Created by wsz on 16/9/26.
//  Copyright © 2016年 wsz. All rights reserved.
//

#import "BLTConnectVC.h"
#import "BLTManager.h"
#import "PrefixHeader.pch"
@interface BLTConnectVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableV;
@property (nonatomic,strong)NSMutableArray *ds;

@end

@implementation BLTConnectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitleView:[CustomNavVC setNavgationItemTitle:@"蓝牙扫描"]];
    [self.navigationItem setLeftBarButtonItem:[CustomNavVC getLeftBarButtonItemWithTarget:self action:@selector(onGoback)]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   // __weak __typeof(self)wself = self;
//    [[BLTManager shareInstance] scanValidBLTDeviceWithTimeOut:5 callBack:^(CBPeripheral *peripheral) {
//        [wself.ds addObject:peripheral];
//        [wself.tableV reloadData];
//    }];
}

- (UITableView *)tableV
{
    if(!_tableV)
    {
        _tableV = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        _tableV.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableV.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_tableV];
    }
    return _tableV;
}

- (NSMutableArray *)ds
{
    if(!_ds)
    {
        _ds = [NSMutableArray new];
    }
    return _ds;
}

#pragma mark -
#pragma mark - UITableViewDataSource&&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.ds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifer = @"UITableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    
//    CBPeripheral *peripheral = self.ds[[indexPath row]];
//    cell.textLabel.text = peripheral.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    CBPeripheral *peripheral = self.ds[[indexPath row]];
//    if(peripheral)
//    {
//        //__weak __typeof(self)wself = self;
////        [[BLTManager shareInstance] connect2Device:peripheral callBack:^{
////            [wself onGoback];
////        }];
//    }
}

@end
