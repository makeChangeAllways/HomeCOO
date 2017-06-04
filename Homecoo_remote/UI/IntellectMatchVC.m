//
//  IntellectMatchVC.m
//  IRBT
//
//  Created by wsz on 16/9/27.
//  Copyright © 2016年 wsz. All rights reserved.
//

#import "IntellectMatchVC.h"
#import "IRDBManager.h"
#import "PrefixHeader.pch"
#import "CYDevicesVC.h"
@interface IntellectMatchVC ()<UITableViewDelegate,UITableViewDataSource>
{
    DeviceType _type;
}

@property (nonatomic,strong)NSMutableArray *ds;
@property (nonatomic,strong)CustomTableV *tableV;

@end

@implementation IntellectMatchVC

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
        _ds = [[IRDBManager shareInstance] getAllBrandByDeviceType:_type];
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
        NSMutableArray *array = [[IRDBManager shareInstance] getAllNoModelByBrand:brand DeviceType:_type];
        
//        DeviceM * device  = array[2];
//        
//        NSLog(@"  =array= %@   code =%@ ",array,device.code);
        if([array count])
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请注意" message:[NSString stringWithFormat:@"点确定进入智能匹配模式，一共搜索到%ld组红外码，请按下测试面板上的按键，观察家电的反应",(unsigned long)array.count] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"nIRCodeDidMatched" object:array];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    
//                    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
                    [self.navigationController pushViewController:[[CYDevicesVC alloc]init] animated:YES];
                    
                });
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
            [alert addAction:action1];
            [alert addAction:action2];
            [self presentViewController:alert animated:YES completion:^{}];
            
        }
    }
}

@end
