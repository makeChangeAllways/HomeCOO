//
//  CYDevicesVC.m
//  IRBT
//
//  Created by app on 2017/1/2.
//  Copyright © 2017年 wsz. All rights reserved.
//

#import "CYDevicesVC.h"
#import "CustomVC.h"
#import "MainHomeVC.h"
#import "BLTManager.h"
#import "PanelMainVC.h"
#import "PrefixHeader.pch"
#import "ModelMatch2VC.h"

#import "CYdeviceMessageTool.h"
#import "CYdeviceMessage.h"
#import "BLTAssist.h"
#import "LZXDataCenter.h"
#import "CYMainHomeVC.h"
@interface CYDevicesVC ()<UIAlertViewDelegate>
{
    NSMutableArray *imgs;
    NSInteger Devicestype;
    
    NSMutableArray *names;
    NSMutableArray *codes;
    NSString *imageName;
    NSString * DeviceName;
    CYdeviceMessage *delDevice;
}

@end

@implementation CYDevicesVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.translucent = NO;
    [self.navigationItem setTitleView:[CustomNavVC setNavgationItemTitle:@"设备"]];
    [self.navigationItem setLeftBarButtonItem:[CustomNavVC getLeftBarButtonItemWithTarget:self action:@selector(backAction) titile:@"返回" ]];
    self.view.backgroundColor = [UIColor whiteColor];
    imgs = [NSMutableArray arrayWithObjects:@"pusbtn.jpg", nil];
    
    names = [NSMutableArray arrayWithObjects:@"添加设备", nil];
    codes = [NSMutableArray array];
    delDevice = [[CYdeviceMessage alloc]init];
    [self layuotView];
    
}

-(void)layuotView{
    
    CYdeviceMessage *sss = [[CYdeviceMessage alloc]init];
    CYdeviceMessage *test = [[CYdeviceMessage alloc]init];
    
    test.currentDeviceNo = [LZXDataCenter defaultDataCenter].remoteDeviceNum;
    NSArray *ss = [CYdeviceMessageTool queryWithSocksDevices:test];
    
    if (ss.count !=0) {
        
        for (int i = 0; i<ss.count; i++) {
            sss = ss[i];
            [imgs addObject:sss.type];
            [names addObject:sss.name];
            [codes addObject:sss.setCode];
        }
        
    }

    imgs = (NSMutableArray *)[[imgs reverseObjectEnumerator] allObjects];
    names = (NSMutableArray *)[[names reverseObjectEnumerator] allObjects];
    codes = (NSMutableArray *)[[codes reverseObjectEnumerator] allObjects];

    CGSize size = CGSizeMake(60, 60);
    
    float dis = (UI_SCREEN_WIDTH-60*3)/4;
    
    for(int i=0;i<imgs.count;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        [btn setBackgroundImage:[UIImage imageNamed:imgs[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        //btn.frame = CGRectMake(10*(i+1)+(i*50), 10, 50, 50);
        [self.view addSubview:btn];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
        
        longPress.view.tag = i;
        longPress.minimumPressDuration = 0.8; //定义按的时间
        [btn addGestureRecognizer:longPress];
        
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

-(void)btnLong:(UILongPressGestureRecognizer *)gestureRecognizer{

    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan )
    {
        UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)gestureRecognizer;
        
        delDevice.setCode = codes[longPress.view.tag];
        
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除该设备吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"确定",nil];
        
        [alter show];
    
    }
}
-(void)btnClicked:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    
    if (btn.tag!=(imgs.count-1)) {
        
        if([BLTManager shareInstance].isconnected)
        {
            if ([imgs[btn.tag] isEqualToString:@"home_prj"] ) {
                Devicestype = 0;
                DeviceName = @"投影仪";
            }if ([imgs[btn.tag] isEqualToString:@"home_fan"] ) {
                 Devicestype = 1;
                 DeviceName = @"电扇";
            }
            if ([imgs[btn.tag] isEqualToString:@"home_tvbox"] ) {
                 Devicestype = 2;
                 DeviceName = @"机顶盒";
            }if ([imgs[btn.tag] isEqualToString:@"home_tv" ]) {
                Devicestype = 3;
                DeviceName = @"电视";
            }
            if ([imgs[btn.tag] isEqualToString:@"home_iptv"] ) {
                 Devicestype = 4;
                DeviceName = @"网络机顶盒";
            }if ([imgs[btn.tag] isEqualToString:@"home_dvd"] ) {
                 Devicestype = 5;
                 DeviceName = @"DVD";
            }
            if ([imgs[btn.tag] isEqualToString:@"home_arc" ]) {
                Devicestype = 6;
                DeviceName = @"空调";
            }if ([imgs[btn.tag] isEqualToString:@"home_wh" ]) {
                Devicestype = 7;
                DeviceName = @"热水器";
            }
            if ([imgs[btn.tag] isEqualToString:@"home_airer"] ) {
                 Devicestype = 8;
                DeviceName =  @"空气净化器";
            }if ([imgs[btn.tag] isEqualToString:@"home_slr"] ) {
                 Devicestype = 9;
                DeviceName = @"相机";
            }
            
            [LZXDataCenter defaultDataCenter].DeviceName = DeviceName;
            [LZXDataCenter defaultDataCenter].DeviceTypeID = Devicestype;
            [BLTAssist clearIRStorage:[self dviceType2class:Devicestype]];
            [BLTAssist setCode:codes[btn.tag] device:Devicestype];
            
            PanelMainVC *panel = [[PanelMainVC alloc] initWithDeviceType:Devicestype];
            [self.navigationController pushViewController:panel animated:YES];
        }
    }else{
   
        [self.navigationController pushViewController:[[MainHomeVC alloc]init] animated:YES];
    }
}
//UI类型转化成设备类型
- (Class)dviceType2class:(DeviceType)type
{
    if(type==DeviceTypePJT)
    {
        return NSClassFromString(@"ProjtPanelV");
    }
    if(type==DeviceTypeFan)
    {
        return NSClassFromString(@"FanPanelV");
    }
    if(type==DeviceTypeTVBox)
    {
        return NSClassFromString(@"TVBoxPanelV");
    }
    if(type==DeviceTypeTV)
    {
        return NSClassFromString(@"TVPanelV");
    }
    if(type==DeviceTypeIPTV)
    {
        return NSClassFromString(@"IPBoxPanelV");
    }
    if(type==DeviceTypeDVD)
    {
        return NSClassFromString(@"DVDPanelV");
    }
    if(type==DeviceTypeARC)
    {
        return NSClassFromString(@"ARCPanelV");
    }
    if(type==DeviceTypeWheater)
    {
        return NSClassFromString(@"WheaterPanelV");
    }
    if(type==DeviceTypeAir)
    {
        return NSClassFromString(@"AirerPanelV");
    }
    if(type==DeviceTypeSLR)
    {
        return NSClassFromString(@"SlrPanelV");
    }
    return NULL;
}

-(void)backAction{
    [self.navigationController pushViewController:[[CYMainHomeVC alloc]init] animated:YES];
    //[self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex ==1){//点击的是确定按键
        
        [CYdeviceMessageTool deleteDevice:delDevice];
        
         [self.navigationController pushViewController:[[CYDevicesVC alloc]init] animated:YES];
       
    }

}

-(void)viewWillAppear:(BOOL)animated{

    //[self viewDidLoad];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
