//
//  MainHomeVC.m
//  IRBT
//
//  Created by wsz on 16/8/28.
//  Copyright © 2016年 wsz. All rights reserved.
//

#import "MainHomeVC.h"
#import "PanelMainVC.h"
#import "BLTConnectVC.h"
#import "BLTManager.h"
#import "PrefixHeader.pch"
#import "SingleRemoteViewController.h"
#import "CYChooseCodeVc.h"

@implementation MainHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitleView:[CustomNavVC setNavgationItemTitle:@"设备"]];

    //    [self.navigationItem setRightBarButtonItem:[CustomNavVC getRightBarButtonItemWithTarget:self action:@selector(linkerSelect) titile:@"连接"]];
    
    [self.navigationItem  setLeftBarButtonItem:[CustomNavVC getLeftBarButtonItemWithTarget:self action:@selector(back) titile:@"返回"]];
    
    NSArray *imgs = @[@"home_prj",
                      @"home_fan",
                      @"home_tvbox",
                      @"home_tv",
                      @"home_iptv",
                      @"home_dvd",
                      @"home_arc",
                      @"home_wh",
                      @"home_airer",
                      @"home_slr"];
    
    NSArray *names = @[@"投影仪",
                       @"风扇",
                       @"机顶盒",
                       @"电视",
                       @"IPTV",
                       @"DVD",
                       @"空调",
                       @"热水器",
                       @"空气净化器",
                       @"单反"];
    
    CGSize size = CGSizeMake(75, 75);
    float dis = (UI_SCREEN_WIDTH-75*3)/4;//UI_SCREEN_WIDTH UI_SCREEN_HEIGHT
    
    
    for(int i=0;i<imgs.count;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        [btn setBackgroundImage:[UIImage imageNamed:imgs[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(size);
            make.left.equalTo(self.view).offset(dis+(i%3)*(75+dis));
            
            int k = i/3;
            if(k==0)
            {
                make.bottom.equalTo(self.view.mas_centerY).offset(-(dis*1.5+75));
            }
            else if(k==1)
            {
                make.bottom.equalTo(self.view.mas_centerY).offset(-(dis*0.5));
            }
            else if(k==2)
            {
                make.top.equalTo(self.view.mas_centerY).offset(dis*0.5);
            }
            else
            {
                make.top.equalTo(self.view.mas_centerY).offset((dis*1.5+75));
            }
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = names[i];
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btn);
            make.top.equalTo(btn.mas_bottom).offset(3);
        }];
    }
}
-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)btnClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    if([BLTManager shareInstance].isconnected)
    {

        CYChooseCodeVc *panel = [[CYChooseCodeVc alloc] initWithDeviceType:btn.tag];
        
        [self.navigationController pushViewController:panel animated:YES];
    }
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"暂未连接到任何蓝牙设备，是否扫描可用蓝牙？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"扫描" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            BLTConnectVC *bltVC = [[BLTConnectVC alloc] init];
            [self.navigationController pushViewController:bltVC animated:YES];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
        [alert addAction:action1];
        [alert addAction:action2];
        
        [self presentViewController:alert animated:YES completion:^{}];
    }
}

- (void)linkerSelect
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请选择连接方式" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"蓝牙" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //BLTConnectVC *bltVC = [[BLTConnectVC alloc] init];
        //[self.navigationController pushViewController:bltVC animated:YES];
    }];

    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    
    [alert addAction:action1];
    [alert addAction:action3];
    
    [self presentViewController:alert animated:YES completion:^{}];
}

@end
