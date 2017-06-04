//
//  ModelMatch2VC.m
//  IRBT
//
//  Created by wsz on 16/9/27.
//  Copyright © 2016年 wsz. All rights reserved.
//

#import "ModelMatch2VC.h"
#import "IRDBManager.h"

#import "PrefixHeader.pch"
#import "CYDevicesVC.h"
#import "CYdeviceMessage.h"
#import "CYdeviceMessageTool.h"
#import "LZXDataCenter.h"
@interface ModelMatch2VC ()<UITableViewDelegate,UITableViewDataSource>

{
    NSString *deviceName;
    NSString *imageName;

}
@property (nonatomic,assign)NSInteger curType;
@property (nonatomic,copy)NSString *curBrand;

@property (nonatomic,strong)NSMutableArray *ds;
@property (nonatomic,strong)CustomTableV *tableV;

@end

@implementation ModelMatch2VC

- (id)initWithDeviceType:(DeviceType)type brand:(NSString *)brand
{
    self = [super init];
    if(self)
    {
        self.curType = type;
        self.curBrand = brand;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitleView:[CustomNavVC setNavgationItemTitle:@"选型号"]];
    [self.navigationItem setLeftBarButtonItem:[CustomNavVC getLeftBarButtonItemWithTarget:self action:@selector(onGoback)]];
    
    [self tableV];
}

- (NSMutableArray *)ds
{
    if(!_ds)
    {
        _ds = [[IRDBManager shareInstance] getAllModelByBrand:self.curBrand DeviceType:self.curType];
        if(!_ds.count)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:@"此品牌无具体型号"];
            });
        }
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
    
    DeviceM *model = self.ds[indexPath.row];
    cell.textLabel.text = model.model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DeviceM *model = self.ds[indexPath.row];
    
    deviceName =[NSString stringWithFormat:@"%@品牌%ld",model.brandCN,(long)model.type];
    
    CYdeviceMessage *cyDevice = [[CYdeviceMessage alloc]init];
    
    cyDevice.name = [deviceName substringToIndex:deviceName.length-1];
    
        switch ([[deviceName substringFromIndex:deviceName.length -1] integerValue]) {
            case 0:
                imageName = @"home_prj";
                break;
            case 1:
                imageName = @"home_fan";
                break;
            case 2:
                imageName = @"home_tvbox";
                break;
            case 3:
                imageName =  @"home_tv";
                break;
            case 4:
                imageName = @"home_iptv";
                break;
            case 5:
                imageName = @"home_dvd";
                break;
            case 6:
                imageName = @"home_arc";
                break;
            case 7:
                imageName = @"home_wh";
                break;
            case 8:
                imageName = @"home_airer";
                break;
            case 9:
                imageName = @"home_slr";
                break;
        }

      
        cyDevice.type = imageName;
        cyDevice.setCode = model.code;
        cyDevice.currentType =[NSString stringWithFormat:@"%ld",(long)model.type]   ;
    cyDevice.currentDeviceNo = [LZXDataCenter defaultDataCenter].remoteDeviceNum;
   
    if(model.code.length)
    {
        [SVProgressHUD showSuccessWithStatus:@"选择成功"];
       
        [CYdeviceMessageTool addDevice:cyDevice];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"nIRCodeDidSelsected" object:model.code];
            
//            [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
            [self.navigationController pushViewController:[[CYDevicesVC alloc]init] animated:YES];
                      
        });
    }
}


@end
