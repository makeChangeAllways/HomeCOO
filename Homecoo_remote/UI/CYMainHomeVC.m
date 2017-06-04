//
//  CYMainHomeVC.m
//  IRBT
//
//  Created by app on 2017/1/2.
//  Copyright © 2017年 wsz. All rights reserved.
//

#import "CYMainHomeVC.h"
#import "CustomVC.h"
#import "CYDevicesVC.h"
#import "CustomNavVC.h"
#import  "PrefixHeader.pch"
#import "deviceMessage.h"
#import "deviceMessageTool.h"
#import "LZXDataCenter.h"
#import "deviceSpaceMessageModel.h"
#import "deviceSpaceMessageTool.h"
#import "spaceMessageModel.h"
#import "spaceMessageTool.h"

#define RGBA(a) [UIColor colorWithRed:(a)/255.0 green:(a)/255.0 blue:(a)/255.0 alpha:1.0]

@interface CYMainHomeVC ()
{
    NSMutableArray *deviceNum;
    NSMutableArray *imgs;
}

@end

@implementation CYMainHomeVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self.navigationItem setTitleView:[CustomNavVC setNavgationItemTitle:@"场景"]];
    
    [self.navigationItem  setLeftBarButtonItem:[CustomNavVC getLeftBarButtonItemWithTarget:self action:@selector(back) titile:@"返回"]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    deviceNum = [NSMutableArray array];
    imgs = [NSMutableArray array];
    
    [self layoutView];
    
}

-(NSArray *)queryDevicePostions{
    
    deviceMessage *devicess = [[deviceMessage alloc]init];
    devicess.GATEWAY_NO = [LZXDataCenter defaultDataCenter].gatewayNo;
    
    NSArray *devices = [deviceMessageTool queryWithRemoteDevices:devicess];
    NSMutableArray *devicePostionArray = [NSMutableArray array];
    
    if (devices.count !=0) {//有红外转发器

        deviceMessage  *device;
        deviceSpaceMessageModel *deviceSpace = [[deviceSpaceMessageModel alloc]init];
        for (int i = 0; i<devices.count; i++) {
            
            device =devices[i];
            deviceSpace.device_no = device.DEVICE_NO;
            deviceSpace.phone_num = [LZXDataCenter defaultDataCenter].userPhoneNum;
            [deviceNum addObject:device.DEVICE_NO];
            
            [imgs addObject:@"home_tv"];
          
            NSArray *deviceSpaceArry = [deviceSpaceMessageTool queryWithspacesDeviceNoAndPhonenum:deviceSpace];
            

            if (deviceSpaceArry.count!=0) {//有位置信息
                
                deviceSpaceMessageModel *device_Name = deviceSpaceArry[0];
                
                spaceMessageModel *deviceNameModel = [[spaceMessageModel  alloc]init];
                
                deviceNameModel.space_Num = device_Name.space_no;
                
                NSArray *devicePostion = [spaceMessageTool queryWithspacesDevicePostion:deviceNameModel];
                
                spaceMessageModel *deviceName;
                
                if (devicePostion.count ==0) {
                   
                    [devicePostionArray addObject:@"位置待定"];
                    
                }else{
                    deviceName = devicePostion[0];
                    [devicePostionArray addObject:deviceName.space_Name];
                }
                
            }else{
            
                [devicePostionArray addObject:@"位置待定"];
            }
            
        }
        
    }

    return devicePostionArray;
    
}

-(void)back{
    
    [self  dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)layoutView{

    NSArray *names =[self queryDevicePostions];
    
    CGSize size = CGSizeMake(70, 60);
    float dis = (UI_SCREEN_WIDTH-70*3)/4;
    
    for(int i=0;i<imgs.count;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        [btn setBackgroundImage:[UIImage imageNamed:imgs[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:btn];
       
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.size.mas_equalTo(size);
            make.left.equalTo(self.view).offset(dis+(i%3)*(60+dis));
            
            int k = i/3;
            if(k==0)
            {
                make.bottom.equalTo(self.view.mas_centerY).offset(-(dis*1.5+60));
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
                make.top.equalTo(self.view.mas_centerY).offset((dis*1.5+60));
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

-(void)btnClicked:(UIButton *)btn{
    
    [LZXDataCenter defaultDataCenter].remoteDeviceNum = deviceNum[btn.tag];
    
    [self.navigationController pushViewController:[[CYDevicesVC alloc]init] animated:YES];
    
}

@end
