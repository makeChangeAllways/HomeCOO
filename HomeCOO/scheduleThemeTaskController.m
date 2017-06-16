//
//  scheduleThemeTaskController.m
//  HomeCOO
//
//  Created by app on 2016/11/23.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//


#import "scheduleThemeTaskController.h"
#import "AppDelegate.h"
#import "SystemViewController.h"
#import "SpaceViewController.h"
#import "ThemeViewController.h"
#import "SecurityViewController.h"
#import "SettingViewController.h"
#import "MethodClass.h"
#import "LZXDataCenter.h"
#import "ThemeAdministrationController.h"
#import "linkageController.h"
#import "AFNetworkings.h"
#import "PrefixHeader.pch"
#import "deviceMessage.h"
#import "deviceMessageTool.h"
#import "deviceSpaceMessageModel.h"
#import "deviceSpaceMessageTool.h"
#import "MBProgressHUD+MJ.h"
#import "spaceMessageModel.h"
#import "spaceMessageTool.h"
#import "MainHomeVC.h"
#import "CustomVC.h"
#import "HCDaterView.h"
#import "themMessageModel.h"
#import "themeMessageTool.h"
#import "scheduleThemeDataView.h"


#import "scheduleCollectionViewCell.h"
#import "musicModel.h"
#import "MJExtension.h"

//底部空间、情景模式等按钮的高度
#define HOMECOOSPACEBUTTONHEIGHT 60

//底部空间、情景模式等按钮的宽度
#define HOMECOOSPACEBUTTONWIDTH [UIScreen  mainScreen].bounds.size.width / 5

//底部空间、情景模式等按钮Y的大小
#define  HOMECOOSPACEBUTTON_Y  [UIScreen  mainScreen].bounds.size.height - 55

//底部空间、情景模式等按钮字体的大小
#define HOMESPACEFONT 13

@interface scheduleThemeTaskController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,HCDaterViewDelegate,scheduleThemeDataViewDelegate>

/**设置背景图片*/
@property(nonatomic,weak)  UIImageView  * fullscreenView;

/**设置导航栏*/
@property(nonatomic,weak)  UINavigationBar *navBar;

/**设置导航栏*/
@property(nonatomic,strong)  HCDaterView *showView;

@property(nonatomic,strong) scheduleThemeDataView *scheduleView;

@property  NSInteger scheduleFlag;

@property(nonatomic,strong)  NSMutableArray * scheduleListArray;

/**UICollectionView 容器*/
@property (strong, nonatomic)  UICollectionView *collectionView;
@property(copy,nonatomic) NSString * scheduleID;
/**设备cell */
@property(nonatomic,strong) scheduleCollectionViewCell *cell;

@property(nonatomic,strong) LZXDataCenter *dataCenter ;
@property(nonatomic,strong) NSMutableArray* scheduleInfraListArray;

@end

@implementation scheduleThemeTaskController

static NSString *string = @"scheduleCollectionViewCell";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //设置背景
    [self setFullscreenView];
    
    [self  setNavBar];
    
    LZXDataCenter *dataCenter = [LZXDataCenter  defaultDataCenter];
    
    self.dataCenter = dataCenter;
    
    self.scheduleFlag = 1;
    
    [self  setWhiteBackground];
    
    [self setupNewRemote];
    
    [self  addUICollectionView];
    
    [self getScheduleTaskFromServer];
    
}
-(void)getScheduleTaskFromServer{
    
    //创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager  manager];
    mgr.responseSerializer = [AFJSONResponseSerializers  serializer];
    
    //配置请求超时时间
    mgr.requestSerializer.timeoutInterval = 60;
    
    //设置请求参数
    NSMutableDictionary  *params = [NSMutableDictionary  dictionary];
    
    params[@"phoneNum"] = _dataCenter.userPhoneNum;
    
    NSString  *urlStr =[NSString  stringWithFormat:@"%@/appGetScheduleByPhoneNum" ,HomecooServiceURL];
    
    NSString *url = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
    
    [mgr  POST:url parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        //打印日志
        //NSLog(@"请求成功--%@",responseObject);
        
        NSString  *result = [responseObject[@"result"]description];
        
        if ([result  isEqual:@"success"]) {
            
            //服务器返回的设备表信息
            NSArray *scheduleListArray = responseObject[@"scheduleList" ];
            if(scheduleListArray.count !=0){
            
                self.scheduleListArray =  [[musicModel objectArrayWithKeyValuesArray:scheduleListArray ] mutableCopy];
            }
            
            [self queryInfraTimingSchduleTasks];
        
        } if ([result  isEqual:@"failed"]) {
            
        }
        
        [MBProgressHUD  hideHUD];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
-(void)queryInfraTimingSchduleTasks{
    
    
    self.scheduleInfraListArray = [NSMutableArray array];
    
    if(self.scheduleListArray.count!=0){
        
        for (int i = 0; i<self.scheduleListArray.count; i++) {
            
            musicModel *schedules = self.scheduleListArray[i];
            
            if ([schedules.themeNo isEqualToString:_dataCenter.theme_No]) {
                
                musicModel *schedule = [[musicModel alloc]init];
                schedule.scheduleId =schedules.scheduleId;
                schedule.xingqi =schedules.xingqi;
                schedule.riqi =schedules.riqi;
                schedule.shij =schedules.shij;
                schedule.state =schedules.state;
                schedule.strategy =schedules.strategy;
                schedule.phoneNum =schedules.phoneNum;
                schedule.deviceNo =schedules.deviceNo;
                schedule.themeNo =schedules.themeNo;
                schedule.gatewayNo =schedules.gatewayNo;
                schedule.deviceState =schedules.deviceState;
                schedule.scheduleName =schedules.scheduleName;
                
                [self.scheduleInfraListArray addObject:schedule];
                
            }
        }
        
        [_collectionView reloadData];
        
    }
   
}

/**
 *  点击定时任务
 */
-(void)setupNewRemote{
    
    UIButton  *setupGatewayBtn = [[UIButton  alloc]init];
    
    CGFloat setupGatewayBtnX =20;
    CGFloat setupGatewayBtnY =55;
    CGFloat setupGatewayBtnW =200;
    CGFloat setupGatewayBtnH =30;
    
    setupGatewayBtn.frame = CGRectMake(setupGatewayBtnX, setupGatewayBtnY, setupGatewayBtnW, setupGatewayBtnH);
    [setupGatewayBtn  setTitle:@"+请按此处添加定时任务" forState:UIControlStateNormal];
    [setupGatewayBtn  setTitle:@"+请按此处添加定时任务" forState:UIControlStateHighlighted];
    [setupGatewayBtn  setTitleColor:[UIColor  blackColor] forState:UIControlStateNormal];
    [setupGatewayBtn  setTitleColor:[UIColor  orangeColor] forState:UIControlStateHighlighted];
    setupGatewayBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    setupGatewayBtn.titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:13];
    
    [setupGatewayBtn  addTarget:self action:@selector(setupcheduleiewAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.fullscreenView  addSubview:setupGatewayBtn];
}

-(void)setupcheduleiewAction{
    self.scheduleID = @"";
    self.scheduleFlag = 1;
    [self.scheduleView  showInView:self.view animated:YES];
    
}

- (scheduleThemeDataView *)scheduleView{
    
    // if(_scheduleView == nil){
    
    _scheduleView = [[scheduleThemeDataView alloc]initWithFrame:CGRectZero];
    
    _scheduleView.delegate = self;
    
    //}
    
    return _scheduleView;
}

/**
 *  添加UICollectionView 来显示所有的照明设备
 */
-(void)addUICollectionView{
    
    CGFloat  collectionViewX = 10 ;
    CGFloat  collectionViewY = 80 ;
    CGFloat  collectionViewW = [UIScreen mainScreen].bounds.size.width - 20;
    CGFloat  collectionViewH = [UIScreen  mainScreen].bounds.size.height -160;
    //确定是水平滚动，还是垂直滚动
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    UICollectionView  *collectionView = [[UICollectionView  alloc]initWithFrame:CGRectMake(collectionViewX, collectionViewY, collectionViewW, collectionViewH) collectionViewLayout:flowLayout];
    
    collectionView.bounces = NO;//没有效果
    
    collectionView.dataSource=self;
    collectionView.delegate=self;
    collectionView.backgroundColor = [UIColor  whiteColor];
    collectionView.userInteractionEnabled = YES;
    [collectionView registerClass:[scheduleCollectionViewCell class] forCellWithReuseIdentifier:string];
    
    self.collectionView = collectionView;
    
    [self.fullscreenView addSubview:collectionView];
    
}
/**
 *  决定cell的个数
 *
 *  @param collectionView 容器
 *  @param section        章节
 *
 *  @return cell
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.scheduleInfraListArray.count;
    
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    _cell = [collectionView dequeueReusableCellWithReuseIdentifier:string forIndexPath:indexPath];
    _cell.button1.hidden = YES;
    _cell.button2.hidden = YES;
    _cell.button3.hidden = YES;
    _cell.button4.hidden = YES;
    _cell.button5.hidden = YES;
    _cell.button6.hidden = YES;
    _cell.button7.hidden = YES;
    _cell.button8.hidden = YES;
    _cell.process.hidden = YES;
    _cell.buttonTag.hidden = NO;
    
    themMessageModel *currentTheme=[[themMessageModel alloc]init];
    
    currentTheme.theme_No = _dataCenter.theme_No;
    
    themMessageModel  * theme = [themeMessageTool  queryThemeWithThemeNum:currentTheme][0];//[indexPath.row];
    
    deviceSpaceMessageModel *deviceSpace = [[deviceSpaceMessageModel alloc]init];
    
    if ([theme.device_No isEqualToString:@"3030303030303030"]) {
        
    }else{
        
        deviceSpace.device_no = theme.device_No;
        deviceSpace.phone_num = _dataCenter.userPhoneNum;
        
    }
    
    NSArray *deviceSpaceArry = [deviceSpaceMessageTool queryWithspacesDeviceNoAndPhonenum:deviceSpace];
    

    musicModel *schedules = self.scheduleInfraListArray[indexPath.row];
    
    NSString *riqi;
    NSString *shijin;
    NSString *postion;
    
    if (deviceSpaceArry.count == 0) {
        postion =[NSString stringWithFormat:@"%@ ",theme.theme_Name];
  
        riqi = [postion  stringByAppendingString:schedules.riqi];
      
        if ([schedules.xingqi length] !=0) {//meitian
 
            NSString *timeStr = schedules.xingqi;
            NSString *str;
            NSString *days=@" ";
            for (int i = 0; i<[timeStr  length]; i++) {
                
                str = [timeStr substringWithRange:NSMakeRange(i, 1)];
                if ([str  isEqualToString:@"1"]) {
                    days = [NSString  stringWithFormat:@"%@星期%d",days,i+1];
                }
            }
            
            shijin = [NSString  stringWithFormat:@"%@ %@  %@",riqi,days,schedules.shij];
        
        }else{
            
         shijin = [NSString  stringWithFormat:@"%@ %@",riqi,schedules.shij];
        }
       
        
        _cell.alarmMessageLable.text =shijin;
        
    }else{
        
        deviceSpaceMessageModel *device_Name = deviceSpaceArry[0];
        
        spaceMessageModel *deviceNameModel = [[spaceMessageModel  alloc]init];
        
        deviceNameModel.space_Num = device_Name.space_no;
        
        NSArray *devicePostion = [spaceMessageTool queryWithspacesDevicePostion:deviceNameModel];
        
        spaceMessageModel *deviceName;
       
        if (devicePostion.count ==0) {
            
            postion =[NSString stringWithFormat:@"%@ ",theme.theme_Name];
            riqi = [postion  stringByAppendingString:schedules.riqi];
            
            if ([schedules.xingqi length] !=0) {//meitian
                
                NSString *timeStr = schedules.xingqi;
                NSString *str;
                NSString *days=@" ";
                for (int i = 0; i<[timeStr  length]; i++) {
                    
                    str = [timeStr substringWithRange:NSMakeRange(i, 1)];
                    if ([str  isEqualToString:@"1"]) {
                        days = [NSString  stringWithFormat:@"%@星期%d",days,i+1];
                    }
                }
                
                shijin = [NSString  stringWithFormat:@"%@ %@  %@",riqi,days,schedules.shij];
            }else{
                
                shijin = [NSString  stringWithFormat:@"%@ %@",riqi,schedules.shij];
            }
  
            _cell.alarmMessageLable.text =shijin;
            
        }else{
            
            deviceName = devicePostion[0];
            //显示设备位置和设备名称
            postion =[NSString stringWithFormat:@" %@/%@ ",deviceName.space_Name,theme.theme_Name];

            riqi = [postion  stringByAppendingString:schedules.riqi];
            if ([schedules.xingqi length] !=0) {//meitian
                
                NSString *timeStr = schedules.xingqi;
                NSString *str;
                NSString *days=@" ";
                for (int i = 0; i<[timeStr  length]; i++) {
                    
                    str = [timeStr substringWithRange:NSMakeRange(i, 1)];
                    if ([str  isEqualToString:@"1"]) {
                        days = [NSString  stringWithFormat:@"%@星期%d",days,i+1];
                    }
                }
                
                shijin = [NSString  stringWithFormat:@"%@ %@",riqi,days];
                
            }else{
                
                shijin = [NSString  stringWithFormat:@"%@ %@",riqi,schedules.shij];
            }
            
            _cell.alarmMessageLable.text =shijin;
        }
        
    }
    
    [_cell.buttonTag  addTarget:self action:@selector(ClickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return _cell;
    
}
/**
 *  按钮监听事件
 *  @param btn 点击的是哪个
 */
- (void)ClickButton:(UIButton *)btn{
    scheduleCollectionViewCell *cell = (scheduleCollectionViewCell *)[[[btn superview]superview]superview];//获取cell
    
    NSIndexPath *indexPathAll = [self.collectionView indexPathForCell:cell];//获取cell对应的section
    
    musicModel *schedule = self.scheduleInfraListArray[indexPathAll.row];
    
    self.scheduleID = schedule.scheduleId;
    

    NSArray *tempArray = @[@"定时设置",@"定时删除",];
    
    self.showView.titleArray = tempArray;
    
    self.showView.title = @"定时管理";
    
    [self.showView showInView:self.view animated:YES];
    
}
- (HCDaterView *)showView{
    
    if(_showView == nil){
        
        _showView = [[HCDaterView alloc]initWithFrame:CGRectZero];
        
        _showView.sureBtn.hidden = YES;
        
        _showView.cancleBtn.hidden = YES;
        
        _showView.delegate = self;
    }
    
    return _showView;
}

- (void)daterViewClicked:(HCDaterView *)daterView{
    
    switch (daterView.currentIndexPath.row) {
            
        case 0:
            //定时设置
            [self.showView hiddenInView:self.view animated:YES];
            self.scheduleFlag = 2;
            [self.scheduleView  showInView:self.view animated:YES];
            break;
            
        case 1:
            //删除定时
            [self.showView hiddenInView:self.view animated:YES];
            self.scheduleFlag = 1;
            [self delegateScheduleTask];//删除定时任务
            break;
            
    }
    
}
/**
 *退出系统
 */
-(void)delegateScheduleTask{
    UIAlertView * alert = [[UIAlertView  alloc]initWithTitle:@"温馨提示" message:@"确定要删除该定时任务吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert show];
    
}
-(void)makeSureClicked:(scheduleThemeDataView *)daterView{
    
    NSDictionary  *dict;
    switch (daterView.currentTag) {
        case 1://单次
            dict = @{@"scheduleId":self.scheduleID,
                     @"xingqi":@"",
                     @"riqi":daterView.riqi,
                     @"shij":daterView.shijian,
                     @"state":daterView.state,
                     @"strategy":daterView.stratege,
                     @"phoneNum":_dataCenter.userPhoneNum,
                     @"themeNo":_dataCenter.theme_No,
                     @"gatewayNo":_dataCenter.gatewayNo,
                     @"deviceNo":_dataCenter.device_No,
                     @"deviceState":_dataCenter.theme_State,
                     @"scheduleName":_dataCenter.theme_Name,
                     @"packetData":daterView.packData
                     };
            break;
        case 2://每天
            dict = @{@"scheduleId":self.scheduleID,
                     @"xingqi":daterView.xingqi,
                     @"riqi":@"",
                     @"shij":daterView.shijian ,
                     @"state":daterView.state ,
                     @"strategy":daterView.stratege,
                     @"phoneNum":_dataCenter.userPhoneNum,
                     @"themeNo":_dataCenter.theme_No,
                     @"gatewayNo":_dataCenter.gatewayNo,
                     @"deviceNo":_dataCenter.device_No,
                     @"deviceState":_dataCenter.theme_State,
                     @"scheduleName":_dataCenter.theme_Name,
                     @"packetData":daterView.packData
                     };
            break;
    }
    
    [self  addScheduleTask:dict];
}

-(void)addScheduleTask:(NSDictionary *)dict{
    //创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager  manager];
    mgr.responseSerializer = [AFJSONResponseSerializers  serializer];
    
    //配置请求超时时间
    mgr.requestSerializer.timeoutInterval = 60;
    
    NSMutableDictionary  *params = [NSMutableDictionary  dictionary];
    
    NSData  *jsonData = [NSJSONSerialization  dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil  ];
    
    NSString *scheduleJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    params[@"scheduleJson"] = scheduleJson;
    
    NSLog(@" scheduleJson = %@",params[@"scheduleJson"]);
    NSString *urlStr;
    if (self.scheduleFlag==2) {//更新定时
        urlStr =[HomecooServiceURL stringByAppendingString:@"/appUpdateSchedule"];
    }else{//设置定时
        urlStr =[HomecooServiceURL stringByAppendingString:@"/appAddSchedule"];
    }
    
    NSString *url = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
    
    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        //打印日志
        //NSLog(@"请求成功--%@",responseObject);
        NSString  *result = [responseObject[@"result"]description];
        NSString *message = [responseObject[@"messageInfo"]description];
        
        if ([result  isEqual:@"success"]) {//同步成功
            
            [self getScheduleTaskFromServer];
            
            [MBProgressHUD  showSuccess:[NSString  stringWithFormat:@"%@",message]];
        }
        if ([result  isEqual:@"failed"]) {
            
            [MBProgressHUD  showError:[NSString  stringWithFormat:@"%@",message]];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];


}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [_showView  hiddenInView:self.view animated:YES];
    [self.scheduleView  hiddenInView:self.view animated:YES];
}

/**
 *  定义每个UICollectionView 的大小
 *
 *  @param CGSize 一个cell的宽度
 *
 *  @return 返回设置后的结果
 */

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat  collectionViewW= (CGRectGetMaxX(self.collectionView.frame) -CGRectGetMinX(self.collectionView.frame))-40;
    
    return CGSizeMake(collectionViewW, 40);
}


/**
 *  定义每个UICollectionView 的 margin
 *
 *  @param UIEdgeInsets 改变文本框的位置
 *
 *  @return 返回设置的结果
 */

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    
    
    return UIEdgeInsetsMake(10, 10, 10, 10);//改变文本框的位置（上左下右）
    
}

/**
 *  调整section
 *
 *  @param collectionView       容器
 *  @param collectionViewLayout 布局方式
 *  @param section              显示多少
 *
 *  @return 返回section
 */
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    
    return 1;
    
}


/**
 *  调整两个cell之间的高度
 *
 *  @param CGFloat 高度
 *
 *  @return 返回设置的高度
 */

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 10.0f;
}
#pragma alterView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex ==1){//点击的是确定按键
        
        [self makeSureDelegateTask];
        
    }else{
    }
    
}


/**
 确定删除定时任务
 */
-(void)makeSureDelegateTask{
    
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager  manager];
    mgr.responseSerializer = [AFJSONResponseSerializers  serializer];
    
    //配置请求超时时间
    mgr.requestSerializer.timeoutInterval = 60;
    
    //设置请求参数
    NSMutableDictionary  *params = [NSMutableDictionary  dictionary];
    
    params[@"scheduleId"] = self.scheduleID;
    
    NSString  *urlStr =[NSString  stringWithFormat:@"%@/appDeleteScheduleByScheduleId" ,HomecooServiceURL];
    
    NSString *url = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
    
    [mgr  POST:url parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        //打印日志
        NSLog(@"请求成功--%@",responseObject);
        NSString  *result = [responseObject[@"result"]description];
        NSString *message = [responseObject[@"messageInfo"]description];
        if ([result  isEqual:@"success"]) {
            
            [MBProgressHUD  showSuccess:[NSString  stringWithFormat:@"%@",message]];
            [self getScheduleTaskFromServer];
            
        } if ([result  isEqual:@"failed"]) {
            [MBProgressHUD  showError:[NSString  stringWithFormat:@"%@",message]];
        }
        
        [MBProgressHUD  hideHUD];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


/**
 *设置纯白背景底色
 */
-(void)setWhiteBackground{
    
    UILabel  *WhiteBackgroundLable= [[UILabel  alloc]init];
    
    CGFloat  WhiteBackgroundLableX = 10 ;
    CGFloat  WhiteBackgroundLableY = 60 ;
    CGFloat  WhiteBackgroundLableW = [UIScreen mainScreen].bounds.size.width - 20;
    CGFloat  WhiteBackgroundLableH = [UIScreen  mainScreen].bounds.size.height -80;
    WhiteBackgroundLable.frame = CGRectMake(WhiteBackgroundLableX, WhiteBackgroundLableY, WhiteBackgroundLableW, WhiteBackgroundLableH);
    WhiteBackgroundLable.backgroundColor = [UIColor  whiteColor];
    WhiteBackgroundLable.clipsToBounds = YES;
    WhiteBackgroundLable.layer.cornerRadius = 8.0;//设置边框圆角
    WhiteBackgroundLable.userInteractionEnabled = YES;
    
    [self.fullscreenView addSubview:WhiteBackgroundLable];
    
}

/**返回到上一个systemView*/
-(void)backAction{
    
    [self  dismissViewControllerAnimated:YES completion:nil];
}

/**
 *设置导背景图片
 */

-(void)setFullscreenView{
    
    UIImageView  *fullscreenView = [[UIImageView  alloc]init];
    UIImage  *image = [UIImage imageNamed:@"bg_title.jpg"];
    
    /**设置背景图片的大小*/
    fullscreenView.image = image;
    fullscreenView.userInteractionEnabled = YES;
    fullscreenView.contentMode = UIViewContentModeScaleToFill;
    CGFloat fullscreenViewW = [UIScreen  mainScreen].bounds.size.width;
    CGFloat fullscreenViewH = [UIScreen  mainScreen].bounds.size.height;
    fullscreenView.frame = CGRectMake(0, 0, fullscreenViewW, fullscreenViewH);
    self.fullscreenView = fullscreenView;
    
    [self.view  addSubview:fullscreenView];
}


/**
 *设置导航栏
 */
-(void)setNavBar{
    
    CGFloat navBarW = [UIScreen  mainScreen].bounds.size.width;
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0,navBarW, 40)];
    
    //创建一个导航栏集合
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"定时任务"];
    
    [[UINavigationBar appearance]setTitleTextAttributes:
     @{ NSFontAttributeName: [UIFont systemFontOfSize:16.0]}];
    
    //创建一个左边按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleBordered target:self action:@selector(backAction)];
    //给按钮添加图片
    
    leftButton.title = @"返回";
    leftButton.tintColor = [UIColor  blackColor];
    
    //设置字体大小
    [[UIBarButtonItem appearance] setTitleTextAttributes:
     @{ NSFontAttributeName: [UIFont systemFontOfSize:15.0],} forState:UIControlStateNormal];
    
    //把导航栏集合添加到导航栏中，设置动画关闭
    [navBar pushNavigationItem:navItem animated:NO];
    
    //把左右两个按钮添加到导航栏集合中去
    [navItem setLeftBarButtonItem:leftButton];
    
    //将标题栏中的内容全部添加到主视图当中
    [self.view addSubview:navBar];
    
}


-(BOOL)shouldAutorotate{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskLandscape;
    
}
@end
