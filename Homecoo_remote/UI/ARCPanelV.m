//
//  ARCPanelV.m
//  IRBT
//
//  Created by wsz on 16/8/28.
//  Copyright © 2016年 wsz. All rights reserved.
//

#import "ARCPanelV.h"
#import "ARCSlideV.h"
#import "BLTManager.h"
#import "PrefixHeader.pch"
#import "LZXDataCenter.h"
#import "themeInfraModel.h"
#import "themeInfraModelTools.h"
#import "themeDeviceMessage.h"
#import "themeDeviceMessageTool.h"

typedef NS_ENUM(NSInteger,ARCSwitchType) {
    ARCSwitchTypeOn = 0x77,
    ARCSwitchTypeOff= 0x88
};

@interface ARCPanelV ()
{

    NSString *btnName;
    NSString *devieNo;
    NSString *themeNo;
    NSString *infraControlName;
    NSString *deviceState;
    NSInteger typeId;
    NSString *gatewayNo;

}
@property (nonatomic,strong)UIImageView *modeStatus;
@property (nonatomic,strong)UIImageView *voluStatus;
@property (nonatomic,strong)UIImageView *manuStatus;
@property (nonatomic,strong)UIImageView *autoStatus;

@property (nonatomic,strong)ARCSlideV *slideV;

@end

@implementation ARCPanelV

- (void)layoutIfNeeded
{
    [super layoutIfNeeded];

   
    //中部
    self.slideV = [[ARCSlideV alloc] init];
    self.slideV.didSelecTemperature = ^(NSInteger temprature){
        
    };
   
    [self addSubview:self.slideV];
    [self.slideV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.height.equalTo(self.mas_width);
        make.centerY.equalTo(self).with.offset(-50);
        make.centerX.equalTo(self);
    }];
    [self.slideV layoutIfNeeded];
    
    self.slideV.disLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:60];//

    self.slideV.disLabel.text = @"--";
    
  
    self.voluStatus = [[UIImageView alloc] init];
    [self addSubview:self.voluStatus];
    [self.voluStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.top.equalTo(self.slideV.mas_centerY).with.offset(50);
        make.right.equalTo(self.mas_centerX).offset(-10);
    }];
    
    
    self.manuStatus = [[UIImageView alloc] init];
    [self addSubview:self.manuStatus];
    [self.manuStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.top.equalTo(self.slideV.mas_centerY).with.offset(50);
        make.left.equalTo(self.mas_centerX).offset(10);
    }];

    
    self.modeStatus = [[UIImageView alloc] init];
    [self addSubview:self.modeStatus];
    [self.modeStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.top.equalTo(self.slideV.mas_centerY).with.offset(50);
        make.right.equalTo(self.voluStatus.mas_left).offset(-20);
    }];
    
    self.autoStatus = [[UIImageView alloc] init];
    [self addSubview:self.autoStatus];
    [self.autoStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.top.equalTo(self.slideV.mas_centerY).with.offset(50);
        make.left.equalTo(self.manuStatus.mas_right).offset(20);
    }];
    
    //温度+
    UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnAdd setBackgroundImage:[UIImage imageNamed:@"aircon_btn_n"] forState:UIControlStateNormal];
    [btnAdd setBackgroundImage:[UIImage imageNamed:@"aircon_btn_h"] forState:UIControlStateHighlighted];
    [btnAdd setTitle:@"温度+" forState:UIControlStateNormal];
    [btnAdd addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnAdd];
    btnAdd.tag = 0x06;
    [btnAdd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.right.equalTo(self.mas_right).with.offset(-20);
        make.centerY.equalTo(self);
    }];
    
    //温度-
    
    UIButton *btnRed = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRed setBackgroundImage:[UIImage imageNamed:@"aircon_btn_n"] forState:UIControlStateNormal];
    [btnRed setBackgroundImage:[UIImage imageNamed:@"aircon_btn_h"] forState:UIControlStateHighlighted];
    [btnRed setTitle:@"温度-" forState:UIControlStateNormal];
    [btnRed addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnRed];
    btnRed.tag = 0x07;
    [btnRed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.left.equalTo(self.mas_left).with.offset(20);
        make.centerY.equalTo(self);
    }];

    //上部
    
    //开
    UIButton *btnOpen = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnOpen setBackgroundImage:[UIImage imageNamed:@"aircon_btn_n"] forState:UIControlStateNormal];
    [btnOpen setBackgroundImage:[UIImage imageNamed:@"aircon_btn_h"] forState:UIControlStateHighlighted];
    [btnOpen setTitle:@"开" forState:UIControlStateNormal];
    [btnOpen addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    btnOpen.tag = ARCSwitchTypeOn;
    [self addSubview:btnOpen];
    [btnOpen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.left.equalTo(self).with.offset(30);
        make.top.equalTo(self).with.offset(15);
    }];
    
    //关
    UIButton *btnOff = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnOff setBackgroundImage:[UIImage imageNamed:@"aircon_btn_n"] forState:UIControlStateNormal];
    [btnOff setBackgroundImage:[UIImage imageNamed:@"aircon_btn_h"] forState:UIControlStateHighlighted];
    [btnOff setTitle:@"关" forState:UIControlStateNormal];
    [btnOff addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    btnOff.tag = ARCSwitchTypeOff;
    [self addSubview:btnOff];
    [btnOff mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.right.equalTo(self).with.offset(-30);
        make.top.equalTo(self).with.offset(15);
    }];
    
    
    //下部
    
    NSArray *array = @[@"模式",
                       @"风量",
                       @"手动",
                       @"自动"];
    
    float dis = (UI_SCREEN_WIDTH-60*4)/8;
    
    for(int i=0;i<[array count];i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"aircon_btn_n"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"aircon_btn_h"] forState:UIControlStateHighlighted];
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 60));
            make.left.equalTo(self).with.offset(i*(60+2*dis)+dis);
            make.bottom.equalTo(self).with.offset(-70);
        }];
    
        switch (i) {
            case 0:
            {
                btn.tag = 0x02;
            }
                break;
            case 1:
            {
                btn.tag = 0x03;
            }
                break;
            case 2:
            {
                btn.tag = 0x04;
            }
                break;
            case 3:
            {
                btn.tag = 0x05;
            }
                break;
            default:
                break;
        }
    }
    
    if([BLTManager shareInstance].arcCtr.powerOn)
    {
        [self setState];
    }
}

- (void)btnClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if(![BLTManager shareInstance].arcCtr.powerOn)
    {
        //关机状态下 除开机键外，都无响应
        btnName = @"开";
        [LZXDataCenter defaultDataCenter].btnName = btnName;
        if(btn.tag!=0x77)return;
    }
    
    if(self.panelBtnClicked)
    {
        self.panelBtnClicked([self class],sender);
        if(btn.tag==0x77)//开机键
        {
            self.modeStatus.hidden = NO;
            self.voluStatus.hidden = NO;
            self.manuStatus.hidden = NO;
            self.autoStatus.hidden = NO;
            btnName = @"开";
            [BLTManager shareInstance].arcCtr.powerOn = YES;
        }
        else if(btn.tag==0x88)//关机键
        {
            self.slideV.disLabel.text = @"--";
            self.modeStatus.hidden = YES;
            self.voluStatus.hidden = YES;
            self.manuStatus.hidden = YES;
            self.autoStatus.hidden = YES;
            btnName = @"关";
            [BLTManager shareInstance].arcCtr.powerOn = NO;
            [LZXDataCenter defaultDataCenter].btnName = btnName;
            if([LZXDataCenter defaultDataCenter].controlFlag==1){//表示控制设备
            
            }else if([LZXDataCenter defaultDataCenter].controlFlag==3){//红外遥控定时
                [LZXDataCenter defaultDataCenter].scheduleName =    [[LZXDataCenter defaultDataCenter].DeviceName stringByAppendingString:[LZXDataCenter defaultDataCenter].btnName];
            }else{
           
                [self insertThemeInfraDevice];
            }
            return;
        }
        [self setState];
    }
}

- (void)setState
{
    switch ([BLTManager shareInstance].arcCtr.mode) {//模式
        case 0x01:
        {
            self.slideV.disLabel.hidden = YES;
            self.modeStatus.image = [UIImage imageNamed:@"模式自动.png"];
            btnName = @"模式自动";
        }
            break;
        case 0x02:
        {
            self.slideV.disLabel.hidden = NO;
            self.modeStatus.image = [UIImage imageNamed:@"制冷.png"];
            btnName = @"制冷";
        }
            break;
        case 0x03://风量
        {
            self.slideV.disLabel.hidden = YES;
            self.modeStatus.image = [UIImage imageNamed:@"抽湿.png"];
            btnName = @"抽湿";
        }
            break;
        case 0x04://手动
        {
            self.slideV.disLabel.hidden = YES;
            self.modeStatus.image = [UIImage imageNamed:@"风量低.png"];
            btnName = @"风量低";
        }
            break;
        case 0x05://自动
        {
            self.slideV.disLabel.hidden = NO;
            self.modeStatus.image = [UIImage imageNamed:@"制热.png"];
            btnName = @"制热";
        }
            break;
            
        default:
            break;
    }

    switch ([BLTManager shareInstance].arcCtr.volume) {//风量
        case 0x01:
            self.voluStatus.image = [UIImage imageNamed:@"风量自动.png"];
            break;
        case 0x02:
            self.voluStatus.image = [UIImage imageNamed:@"风量低.png"];
            break;
        case 0x03:
            self.voluStatus.image = [UIImage imageNamed:@"风量中.png"];
            break;
        case 0x04:
            self.voluStatus.image = [UIImage imageNamed:@"风量高.png"];
            break;
            
        default:
            break;
    }
    
    switch ([BLTManager shareInstance].arcCtr.manual) {//手动
        case 0x01:
            self.manuStatus.image = [UIImage imageNamed:@"向上.png"];
            break;
        case 0x02:
            self.manuStatus.image = [UIImage imageNamed:@"中.png"];
            break;
        case 0x03:
            self.manuStatus.image = [UIImage imageNamed:@"向下.png"];
            break;
            
        default:
            break;
    }

    switch ([BLTManager shareInstance].arcCtr.autos) {//自动
        case 0x00:
            self.autoStatus.image = [UIImage imageNamed:@""];
            break;
        case 0x01:
    self.autoStatus.image = [UIImage imageNamed:@"自动.png"];
            break;
        default:
            break;
    }
    
    self.slideV.disLabel.text = [NSString stringWithFormat:@"%ld",(long)[BLTManager shareInstance].arcCtr.temperature];
    if (self.slideV.disLabel.text==nil) {
        [LZXDataCenter defaultDataCenter].btnName = btnName;
    }else{
    
        [LZXDataCenter defaultDataCenter].btnName = [btnName stringByAppendingString:self.slideV.disLabel.text];
    }
   
    if([LZXDataCenter defaultDataCenter].controlFlag==1){//表示控制设备
        
    }else if([LZXDataCenter defaultDataCenter].controlFlag==3){//红外遥控定时
        [LZXDataCenter defaultDataCenter].scheduleName =    [[LZXDataCenter defaultDataCenter].DeviceName stringByAppendingString:[LZXDataCenter defaultDataCenter].btnName];
    }else{
        
        [self insertThemeInfraDevice];
    }
}

-(void)insertThemeInfraDevice{
    
    devieNo = [LZXDataCenter defaultDataCenter].remoteDeviceNum;//红外转发器的deviceNo
;
    themeNo =  [LZXDataCenter defaultDataCenter].theme_No;
    infraControlName = [[LZXDataCenter defaultDataCenter].DeviceName stringByAppendingString:[LZXDataCenter defaultDataCenter].btnName];
    deviceState = [LZXDataCenter defaultDataCenter].infraCode;
    typeId = [LZXDataCenter defaultDataCenter].DeviceTypeID;

    gatewayNo =[LZXDataCenter defaultDataCenter].gateway_No;

    
    
    themeInfraModel *infraDevice = [[themeInfraModel alloc]init];
    
    infraDevice.deviceNo = devieNo;
    infraDevice.themeNo = themeNo;
    infraDevice.infraType_ID = typeId;
    
    themeInfraModel *infraModel = [[themeInfraModel alloc]init];
    
    infraModel.deviceNo = devieNo;
    infraModel.deviceState_Cmd = deviceState;
    infraModel.gatewayNo = gatewayNo;
    infraModel.infraControlName= infraControlName;
    infraModel.infraType_ID= typeId;
    infraModel.themeNo = themeNo;
    if ([themeInfraModelTools querWithInfraDevices:infraDevice].count!=0) {//有值 更新
        
        if ([deviceState length]<=64) {
             [themeInfraModelTools updateInfraDeviceState:infraModel];
        }
        
       
    }else{
    
        if ([deviceState length]<=64) {
        
            [themeInfraModelTools addThemeInfraDevice:infraModel];
    
        }
    }
    
    
    
//
//    
//    NSLog(@"infraModel.deviceNo = %@ infraModel.deviceState_Cmd = %@ infraModel.gatewayNo= %@ infraModel.infraControlName = %@ infraModel.infraType_ID = %ld infraModel.themeNo = %@",infraModel.deviceNo,infraModel.deviceState_Cmd,infraModel.gatewayNo,infraModel.infraControlName,(long)infraModel.infraType_ID,infraModel.themeNo);
    [self insertToThemeDeviceTabel];
}

-(void)insertToThemeDeviceTabel{

    //增加
    themeDeviceMessage *themeDevice= [[themeDeviceMessage alloc]init];
    
    themeDevice.device_No = devieNo;
    themeDevice.device_state_cmd =deviceState;
    themeDevice.gateway_No = gatewayNo;
    themeDevice.infra_type_ID = typeId;
    themeDevice.theme_device_No = [LZXDataCenter defaultDataCenter].device_No;
    themeDevice.theme_no = themeNo ;
    themeDevice.theme_type = [LZXDataCenter defaultDataCenter].theme_Type;
    themeDevice.theme_state =[LZXDataCenter defaultDataCenter].theme_State;
    
    //查询
    themeDeviceMessage *foundThemeDevice = [[themeDeviceMessage alloc]init];
    
    foundThemeDevice.device_No =devieNo;
    
    foundThemeDevice.theme_no = themeNo;
    foundThemeDevice.infra_type_ID = typeId;
    
    NSArray *foundThemeDeviceArray =   [themeDeviceMessageTool queryWithThemeDevicesOnlyForInfra:foundThemeDevice];
    
    //更新
    themeDeviceMessage *updataThemeDeviceState = [[themeDeviceMessage alloc]init];
    
    updataThemeDeviceState.device_state_cmd = deviceState;
    updataThemeDeviceState.theme_no = themeNo;
    updataThemeDeviceState.infra_type_ID = typeId;
    updataThemeDeviceState.device_No = devieNo;
    
    if (foundThemeDeviceArray.count !=0) {//更新
        if ([deviceState length]<=64) {
       
            [themeDeviceMessageTool updateThemeDeviceStateOnlyForInfra:updataThemeDeviceState];
        }
    }else{//增加
   
        if ([deviceState length]<=64) {
       
            [themeDeviceMessageTool addThemeDevice:themeDevice];
  
        }
    }


}


@end
