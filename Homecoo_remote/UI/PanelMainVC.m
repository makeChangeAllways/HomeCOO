//
//  PanelMainVC.m
//  IRBT
//
//  Created by wsz on 16/8/28.
//  Copyright © 2016年 wsz. All rights reserved.
//

#import "PanelMainVC.h"
#import "ProjtPanelV.h"
#import "FanPanelV.h"
#import "TVBoxPanelV.h"
#import "TVPanelV.h"
#import "ARCPanelV.h"
#import "DVDPanelV.h"
#import "IPBoxPanelV.h"
#import "WheaterPanelV.h"
#import "AirerPanelV.h"
#import "SlrPanelV.h"
#import "DeviceM.h"
#import "ModelMatchVC.h"
#import "IntellectMatchVC.h"
#import "BLTManager.h"
#import "IRDBManager.h"
#import "BLTAssist.h"
#import "SMMchTestV.h"
#import "PrefixHeader.pch"

@interface PanelMainVC ()
{
    BOOL isMatchMode;
    
}

@property (nonatomic,strong)SMMchTestV *smm;
@property (nonatomic,assign)DeviceType curType;
@property (nonatomic,strong)NSMutableArray *ds;
@property (nonatomic,assign)NSInteger curMatchIndex;

@end

@implementation PanelMainVC

- (id)initWithDeviceType:(DeviceType)type
{
    self = [super init];
    
    if(self)
    {
        self.curType = type;
        self.curMatchIndex = -1;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"nIRCodeDidSelsected" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"nIRCodeDidMatched" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(IRCodeDidSelected:) name:@"nIRCodeDidSelsected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(IRCodeDidMatched:) name:@"nIRCodeDidMatched" object:nil];
    
    NSArray *arrayN = @[@"投影仪",
                        @"电扇",
                        @"机顶盒",
                        @"电视",
                        @"网络机顶盒",
                        @"DVD",
                        @"空调",
                        @"热水器",
                        @"空气净化器",
                        @"相机"];
    
    [self.navigationItem setTitleView:[CustomNavVC setNavgationItemTitle:arrayN[self.curType]]];
    [self.navigationItem setLeftBarButtonItem:[CustomNavVC getLeftBarButtonItemWithTarget:self action:@selector(onGoback)]];
//    [self.navigationItem setRightBarButtonItem:[CustomNavVC getRightBarButtonItemWithTarget:self action:@selector(selectCode) titile:@"选码"]];
    [self layoutPanel];
}

- (void)layoutPanel
{
    NSArray *arrayV = @[@"ProjtPanelV",
                        @"FanPanelV",
                        @"TVBoxPanelV",
                        @"TVPanelV",
                        @"IPBoxPanelV",
                        @"DVDPanelV",
                        @"ARCPanelV",
                        @"WheaterPanelV",
                        @"AirerPanelV",
                        @"SlrPanelV"];
    
    Class cls = NSClassFromString(arrayV[self.curType]);
    if(cls)
    {
        PanelBaseV *pv = (PanelBaseV *)[[cls alloc] init];
        [self.view addSubview:(UIView *)pv];
        pv.tag =0x99;
        [pv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsZero);
        }];
        
        __weak __typeof(self)wself = self;
        pv.panelBtnClicked = ^(Class cls,id sender){
            
            if(![NSStringFromClass(cls) isEqualToString:@"ARCPanelV"])
            {
                if([sender isKindOfClass:[UILongPressGestureRecognizer class]])
                {
                    UILongPressGestureRecognizer *reco = (UILongPressGestureRecognizer *)sender;
                    if (reco.state == UIGestureRecognizerStateBegan)
                    {
                        [wself learnFromClass:cls tag:reco.view.tag];
                    }
                }
                else //按空调之外的面板调用在这个
                {
                    UIButton *btn = (UIButton *)sender;
                    [wself sendFromClass:cls tag:btn.tag];
                    
                    
                }
            }
            else//按空调面板调用这个
            {
                UIButton *btn = (UIButton *)sender;
                [wself sendFromClass:cls tag:btn.tag];
                
                
            }
        };
        [pv layoutIfNeeded];
    }
}

- (void)selectCode
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请选择匹配类型" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"型号匹配" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ModelMatchVC *vc = [[ModelMatchVC alloc] initWithType:self.curType];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"智能匹配" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        IntellectMatchVC *vc = [[IntellectMatchVC alloc] initWithType:self.curType];
        [self.navigationController pushViewController:vc animated:YES];
    }];
//    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"一键匹配" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self onekeyMatch];
//    }];
    
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:action1];
    [alert addAction:action2];
    if(self.curType==DeviceTypeARC)
       // [alert addAction:action3];
    [alert addAction:action4];
    [self presentViewController:alert animated:YES completion:^{}];
}

//型号匹配选定code
- (void)IRCodeDidSelected:(NSNotification *)noti
{
    [BLTAssist setCode:noti.object device:self.curType];
    [BLTAssist clearIRStorage:[self dviceType2class:self.curType]];
}

//智能匹配选定code组
- (void)IRCodeDidMatched:(NSNotification *)noti
{
    isMatchMode = YES;
    self.ds = noti.object;
    
    self.curMatchIndex =0;
    
    self.smm = [[SMMchTestV alloc] init];
    
    DeviceM *model = (DeviceM *)self.ds[self.curMatchIndex];

    [self.smm showWithDeviceType:model.type];

    [self.smm setLabelCur:self.curMatchIndex totelCount:self.ds.count];
  
    __weak __typeof(self)wself = self;
    self.smm.testBtnClicked = ^(DeviceType type,NSInteger tag){
        [wself sendFromClass:[wself dviceType2class:type] tag:tag];
    };
    self.smm.ctrBtnClicked = ^(NSInteger tag){
        if(tag==0)//save
        {
            
            DeviceM *device = wself.ds[wself.curMatchIndex];
            
            [BLTAssist setCode:device.code device:wself.curType];
            [BLTAssist clearIRStorage:[wself dviceType2class:wself.curType]];
            isMatchMode = NO;
            wself.ds = nil;
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            if(wself.curType==DeviceTypeARC)
            {
                
                [[BLTManager shareInstance].arcCtr resetState];
                
                PanelBaseV *v = [wself.view viewWithTag:0x99];
                if([v isKindOfClass:[ARCPanelV class]])
                {
                    ARCPanelV *arcV = (ARCPanelV *)v;
                    [arcV setState];
                }
            }
        }
        else if(tag==1)//下一组
        {
            if(wself.curMatchIndex!=wself.ds.count-1)
            {
                wself.curMatchIndex++;
                
                if(wself.curMatchIndex==wself.ds.count-1)
                {
                 //   [SVProgressHUD showErrorWithStatus:@"所有数据已经试完"];
                }
                [wself.smm setLabelCur:wself.curMatchIndex totelCount:wself.ds.count];
            }
            else
            {
               // [SVProgressHUD showErrorWithStatus:@"所有数据已经试完"];
            }
        }
        else if(tag==2)//上一组
        {
            if(wself.curMatchIndex>0)
            {
                wself.curMatchIndex--;
                if(wself.curMatchIndex<=0)
                {
                    //[SVProgressHUD showErrorWithStatus:@"所有数据已经试完"];
                }
                [wself.smm setLabelCur:wself.curMatchIndex totelCount:wself.ds.count];
            }
            else
            {
                //[SVProgressHUD showErrorWithStatus:@"所有数据已经试完"];
            }
        }
    };
}

#pragma mark -
#pragma mark - process btn click event

//短按面板按键发送回调
- (void)sendFromClass:(Class)cls tag:(NSInteger)tag
{
    if(isMatchMode)
    {
        if(!self.ds.count)
        {
            return;
        }
        
      
        DeviceM *device = self.ds[self.curMatchIndex];
        if([device.code length])
        {
            if(device.type!=DeviceTypeARC)
                [[BLTManager shareInstance] sendData:[BLTAssist nomarlCode:device.code key:tag]];
            else
                [[BLTManager shareInstance] sendARCData:device.code withTag:tag];
        }
       
    }
    else
    {
        NSData *data = [BLTAssist readFromClass:cls tag:tag];
        if([data length])
        {  
            NSData *pData = [BLTAssist processLearnCode:data];
            [[BLTManager shareInstance] sendLearnedData:pData];
            return;
        }
        
        NSData *data1 = [BLTAssist codeForDevice:[self class2dviceType:cls]];
        if(data1.length)
        {
            if(![NSStringFromClass(cls) isEqualToString:@"ARCPanelV"])
                [[BLTManager shareInstance] sendData:[BLTAssist nomarlCode:data1 key:tag]];
            else
                [[BLTManager shareInstance] sendARCData:data1 withTag:tag];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"本面板尚未有选择的码值"];
        }
        
     
        
    }
}

//长按面板按键学习回调
- (void)learnFromClass:(Class)cls tag:(NSInteger)tag
{
    if(isMatchMode)return;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"是否让此按键学习红外码？" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"学习" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请在按下“确定”之后，使用真实遥控器，对准设备的红外接受头，按下想要学习的按键" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if([[BLTManager shareInstance] isconnected])
            {
                [BLTManager shareInstance].learnCB = ^(NSData *data){
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"收到学习的红外码,请点击“测试”键来观察家电是否正确响应" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"测试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSData *pData = [BLTAssist processLearnCode:data];
                        [[BLTManager shareInstance] sendLearnedData:pData];
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"如果家电正确响应，请点击“保存”，否则请取消" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [BLTAssist saveFromClass:cls tag:tag code:data];
                        }];
                        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        }];
                        [alert addAction:action1];
                        [alert addAction:action2];
                        [self presentViewController:alert animated:YES completion:^{}];
                        
                    }];
                    [alert addAction:action];
                    [self presentViewController:alert animated:YES completion:^{}];
                };
                [[BLTManager shareInstance] bideOrderBytype:BideOrderTypeLearn];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:@"蓝牙未连接"];
            }

        }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){}];
        [alert addAction:action0];
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:^{}];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:^{}];
}

//UI类型转化成设备类型
- (DeviceType)class2dviceType:(Class)cls
{
    NSString *clsStr = NSStringFromClass(cls);
    
    if([clsStr isEqualToString:@"ProjtPanelV"])
    {
        return DeviceTypePJT;
    }
    if([clsStr isEqualToString:@"FanPanelV"])
    {
        return DeviceTypeFan;
    }
    if([clsStr isEqualToString:@"TVBoxPanelV"])
    {
        return DeviceTypeTVBox;
    }
    if([clsStr isEqualToString:@"TVPanelV"])
    {
        return DeviceTypeTV;
    }
    if([clsStr isEqualToString:@"IPBoxPanelV"])
    {
        return DeviceTypeIPTV;
    }
    if([clsStr isEqualToString:@"DVDPanelV"])
    {
        return DeviceTypeDVD;
    }
    if([clsStr isEqualToString:@"ARCPanelV"])
    {
        return DeviceTypeARC;
    }
    if([clsStr isEqualToString:@"WheaterPanelV"])
    {
        return DeviceTypeWheater;
    }
    if([clsStr isEqualToString:@"AirerPanelV"])
    {
        return DeviceTypeAir;
    }
    if([clsStr isEqualToString:@"SlrPanelV"])
    {
        return DeviceTypeSLR;
    }
    return -1;
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


#pragma mark -
#pragma mark -

- (void)onekeyMatch
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请在按下“确定”之后，使用真实空调遥控器，对准设备的红外接受头，按下开机键" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([[BLTManager shareInstance] isconnected])
        {
            [BLTManager shareInstance].matchCB = ^(NSData *data){
                [self matchProcess:data];
            };
            [[BLTManager shareInstance] bideOrderBytype:BideOrderTypeMatch];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"蓝牙未连接"];
        }
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:action0];
    [alert addAction:action1];
    [self presentViewController:alert animated:YES completion:^{}];
}

- (void)matchProcess:(NSData *)data
{
    if(!data.length)return;
    
    uint8_t *rev = (uint8_t *)[data bytes];
    NSInteger revlenth = data.length;

    NSMutableArray *array = [[IRDBManager shareInstance] getAllARCMatchCode];
    
    int match = 0;
    int curGrp = -1;
    for(int i=0;i<[array count];i++)
    {
        NSData *locData = array[i];
        uint8_t *loc = (uint8_t *)[locData bytes];
        
        int k = compareMatch(rev, (int)revlenth, loc, (int)locData.length);
        if(k>=match)
        {
            match = k;
            curGrp = i;
        }
    }
    
    if(curGrp<0)
    {
        [SVProgressHUD showErrorWithStatus:@"匹配失败"];
    }
    else
    {
        [SVProgressHUD showSuccessWithStatus:@"匹配成功"];
        
        NSData *data = [[IRDBManager shareInstance] getARCCodeByPointedIndex:curGrp];
        [BLTAssist setCode:data device:DeviceTypeARC];
        [BLTAssist clearIRStorage:[self dviceType2class:DeviceTypeARC]];
    }
}

@end
