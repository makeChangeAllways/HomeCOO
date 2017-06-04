//
//  IntellectMatchVC.m
//  IRBT
//
//  Created by wsz on 16/9/27.
//  Copyright © 2016年 wsz. All rights reserved.
//

#import "ModelMatchVC.h"
#import "ModelMatch2VC.h"
#import "IRDBManager.h"
#import "PrefixHeader.pch"
@interface ModelMatchVC ()<UITableViewDelegate,UITableViewDataSource>
{
    DeviceType _type;
}

@property (nonatomic,strong)NSMutableArray *ds;
@property (nonatomic,strong)CustomTableV *tableV;

@end

@implementation ModelMatchVC

- (id)initWithType:(DeviceType )type
{
    self = [super init];
    if(self)
    {
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setTitleView:[CustomNavVC setNavgationItemTitle:@"选品牌"]];
    [self.navigationItem setLeftBarButtonItem:[CustomNavVC getLeftBarButtonItemWithTarget:self action:@selector(onGoback)]];
    
    [self tableV];
}

- (NSMutableArray *)ds
{
    if(!_ds)
    {
        _ds = [[IRDBManager shareInstance] getAllBrandContainModelByDeviceType:_type];
    }
    return _ds;
}

- (CustomTableV *)tableV
{
    if(!_tableV)
    {
        _tableV = [[CustomTableV alloc] initWithFrame:self.view.bounds
                                                style:UITableViewStyleGrouped];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        _tableV.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:_tableV];
    }
    return _tableV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return .1f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.ds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"UITableViewCellDefault";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }

    cell.textLabel.text = self.ds[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *brand = self.ds[indexPath.row];
    if([brand length])
    {
        ModelMatch2VC *vc = [[ModelMatch2VC alloc] initWithDeviceType:_type brand:brand];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
