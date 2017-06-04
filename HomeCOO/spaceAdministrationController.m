//
//  spaceAdministrationController.m
//  HomeCOO
//
//  Created by tgbus on 16/6/23.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "spaceAdministrationController.h"
#import "AppDelegate.h"
#import "SystemViewController.h"
#import "SpaceViewController.h"
#import "ThemeViewController.h"
#import "SecurityViewController.h"
#import "SettingViewController.h"
#import "MethodClass.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworkings.h"
#import "PrefixHeader.pch"
#import "alertViewModel.h"
#import "spaceMessageModel.h"
#import "spaceMessageTool.h"
#import "spaceCollectionViewCell.h"
#import "gatewayMessageModel.h"
#import "gatewayMessageTool.h"
#import "NSString+Hash.h"
#import "LZXDataCenter.h"
#import "deviceSpaceMessageModel.h"
#import "deviceSpaceMessageTool.h"
#import "alarmMessages.h"
#import "alarmMessagesTool.h"
#import "deviceMessage.h"
#import "deviceMessageTool.h"
#import "alarmRinging.h"
#import "transCodingMethods.h"
#import "ControlMethods.h"
#import "SocketManager.h"
#import "HCSDaterView.h"
#import "HSAddspaceDaterView.h"
//底部空间、情景模式等按钮的高度
#define HOMECOOSPACEBUTTONHEIGHT 60

//底部空间、情景模式等按钮的宽度
#define HOMECOOSPACEBUTTONWIDTH [UIScreen  mainScreen].bounds.size.width / 5

//底部空间、情景模式等按钮Y的大小
#define  HOMECOOSPACEBUTTON_Y  [UIScreen  mainScreen].bounds.size.height - 55

//底部空间、情景模式等按钮字体的大小
#define HOMESPACEFONT 13

//网关标签距离左边的距离
#define   HOMECOOLEFTEDGE [UIScreen  mainScreen].bounds.size.width /4

//网关标签距离上边的距离
#define   HOMECOOTOPEDGE   [UIScreen  mainScreen].bounds.size.height / 4

//网关标签的宽度
#define   HOMECOOLABLEWIDTH  [UIScreen  mainScreen].bounds.size.width /7

//网关输入框的宽度
#define   HOMECOOFIELDWIDTH  [UIScreen  mainScreen].bounds.size.width /3

@interface spaceAdministrationController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextFieldDelegate,HCSDaterViewDelegate,HSAddspaceDaterViewDelegate>{
    
    
    NSMutableArray *_cellArray;
    
}

/**设置背景图片*/
@property(nonatomic,weak)  UIImageView  * fullscreenView;

/**设置导航栏*/
@property(nonatomic,weak)  UINavigationBar *navBar;

/**设置白色背景*/
@property(nonatomic,weak) UILabel  *WhiteBackgroundLable;

/**设置提示框背景*/
@property(nonatomic,weak)UILabel  *WhiteBackground;

/**设置蒙版*/
@property(nonatomic,weak) UIView  *backgroundView;

@property(nonatomic,strong) HCSDaterView *showView;
@property(nonatomic,strong) HSAddspaceDaterView *addSpaceView;

/**UICollectionView 容器*/
@property (weak, nonatomic)  UICollectionView *collectionView;

/**网关cell */
@property(nonatomic,weak) spaceCollectionViewCell *cell;

/**存放所有网关*/
@property(nonatomic,strong)  NSArray *spaces;

/**用来接收服务器返回的空间信息*/
@property(nonatomic,weak)  NSArray * spaceListArray;

@property(nonatomic,strong) UIAlertView * alert;

@property(nonatomic,copy) NSString * alarmString;

@property(nonatomic,copy) NSString *alertString;

@end


static NSString *string = @"spaceCollectionViewCell";

static  NSInteger indexNum;

@implementation spaceAdministrationController


-(NSArray *)spaces{
    
    if (_spaces==nil) {
        
        
        LZXDataCenter *spaceCenter = [LZXDataCenter defaultDataCenter];
        
        if ([spaceCenter.gatewayNo isEqualToString:@"0"] | !spaceCenter.gatewayNo ) {
            
            [MBProgressHUD  showError:@"请先添加主机"];
            
        }else{
        
            spaceMessageModel *space = [[spaceMessageModel alloc]init];
        
            space.phone_Num = spaceCenter.userPhoneNum;
            
            _spaces=[spaceMessageTool  queryWithspaces:space];
        
         
            
        }
        
        [MBProgressHUD  hideHUD];
        
    }
    
    return _spaces;
    
}

/**
 *  启动加载
 */

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //设置背景
    [self setFullscreenView];
    
    //创建一个导航栏
    [self setNavBar];
    
    //设置底片背景
    [self  setWhiteBackground];
    
    //添加新空间
    [self  setupNewSpace];
    
    //添加UICollectionView
    //[self  addUICollectionView];
    [self  performSelector:@selector(addUICollectionView) withObject:nil afterDelay:0.5];
    
    //测试获取对应当前用户的空间信息 spacetable
    //[self  getAllSpaceFromServer];
    LZXDataCenter *dataCenter = [LZXDataCenter defaultDataCenter];
    
    if (dataCenter.networkStateFlag == 0) {//内网不做任何操作
        
        [self  receivedFromGateway_deviceMessage];

    }else{
    
    
        [self  performSelectorInBackground:@selector(getAllSpaceFromServer) withObject:nil];
    }
}
/**
 *  内网情况下，接收底层设备手动出发报上来的信息（用于更新设备状态）
 *
 *  @return
 */
-(void)receivedFromGateway_deviceMessage{
    
    SocketManager  *socket = [SocketManager  shareSocketManager];
    
    [socket receiveMsg:^(NSString *receiveInfo) {
        
        NSString *receiveMessage = receiveInfo;
        
        NSString*  gw_id;//内网情况下 退网的时候 设备的id 全部是0
        gw_id= [receiveMessage  substringWithRange:NSMakeRange(16, 16)];
        if ([gw_id  isEqualToString:@"0000000000000000"]) {
            LZXDataCenter *dataCenter = [LZXDataCenter  defaultDataCenter];
            gw_id = dataCenter.gatewayNo;
        }
        NSString* dev_id = [receiveMessage  substringWithRange:NSMakeRange(32, 16)];
        NSString* dev_type = [receiveMessage  substringWithRange:NSMakeRange(48, 2)];
        NSString*  data_type = [receiveMessage  substringWithRange:NSMakeRange(52, 4)];
        NSString*  data = [receiveMessage  substringFromIndex:60];
        
        NSInteger deviceType_ID = strtoul([[dev_type substringWithRange:NSMakeRange(0, 2)] UTF8String], 0, 16);
        
        NSInteger deviceGategory_ID;
        NSString *deviceName;
        NSString *deviceState;
        NSString * temp;
        NSString *humi;
        NSString *deviceStateStr;
        NSInteger  PM2_5H ;
        NSInteger  PM2_5L ;
        NSInteger  PM2_5;
        
        alarmMessages *alarmMessage = [[alarmMessages  alloc]init];
        
        switch (deviceType_ID) {
            case 1:
                
                deviceGategory_ID = 1;
                deviceName = @"一路开关";
                deviceState = [transCodingMethods  transCodingFromServer:data ];
                break;
            case 2:
                
                deviceGategory_ID = 1;
                deviceName = @"二路开关";
                deviceState = [transCodingMethods  transCodingFromServer:data ];
                break;
            case 3:
                
                deviceGategory_ID = 1;
                deviceName = @"三路开关";
                deviceState = [transCodingMethods  transCodingFromServer:data ];
                break;
            case 4:
                
                deviceGategory_ID = 1;
                deviceName = @"四路开关";
                deviceState = [transCodingMethods  transCodingFromServer:data ];
                break;
                
            case 5:
                
                deviceGategory_ID = 1;
                deviceName = @"调光开关";
                deviceState =[NSString  stringWithFormat:@"%lu",strtoul([[data substringWithRange:NSMakeRange(0, 2)] UTF8String], 0, 16)];
                
                if ([deviceState isEqualToString:@"10"]) {
                    
                    deviceState = @"9";
                    
                }
                break;
                
            case 6:
                
                deviceGategory_ID = 3;
                deviceName = @"窗帘";
                deviceState = [transCodingMethods  transCodingFromServer:data ];
                break;
                
            case 8:
                deviceGategory_ID = 5;
                deviceName = @"插座";
                deviceState = [transCodingMethods  transCodingFromServer:data ];
                
                break;
            case 11:
                deviceGategory_ID = 3;
                deviceName = @"窗户";
                deviceState = [transCodingMethods  transCodingFromServer:data ];
                break;
                
            case 51:
                
                deviceGategory_ID = 2;
                deviceName = @"空气净化器";
                deviceState = [transCodingMethods  transCodingFromServer:data ];
                
                break;
            case 104:
                
                deviceGategory_ID = 2;
                deviceName = @"温湿度";
                temp = [NSString stringWithFormat:@"%lu",strtoul([[data substringWithRange:NSMakeRange(2, 2)] UTF8String], 0, 16)];
                humi = [NSString  stringWithFormat:@"%lu",strtoul([[data substringWithRange:NSMakeRange(6, 2)] UTF8String], 0, 16)];
                deviceStateStr = [temp  stringByAppendingString:@"p" ];
                deviceState = [deviceStateStr  stringByAppendingString:humi];
                
                break;
            case 105:
                deviceName = @"红外转发器";
                deviceState = data;
                break;
            case 109:
                deviceGategory_ID = 2;
                deviceName = @"PM2.5";
                PM2_5H = strtoul([[data substringWithRange:NSMakeRange(0, 2)] UTF8String], 0, 16);
                PM2_5L = strtoul([[data substringWithRange:NSMakeRange(2, 2)] UTF8String], 0, 16);
                PM2_5 = PM2_5H *10 + PM2_5L/10;
                deviceState  = [NSString  stringWithFormat:@"%ld",(long)PM2_5];
                
                break;
            case 110:
                deviceGategory_ID = 2;
                deviceName = @"门磁";
                deviceState = [transCodingMethods  transThemeCodingFromServer:data ];
                if ([[deviceState substringToIndex:2] isEqualToString:@"01"]  ) {
                    
                    
                    NSString *string1 =[receiveMessage  substringToIndex:52];
                    NSString *string2 = @"020000026400";
                    self.alarmString = [string1  stringByAppendingString:string2];
                    
                    alarmMessage.device_no = dev_id;
                    alarmMessage.gateway_no = gw_id;
                    alarmMessage.time = [ControlMethods  getCurrentTime];
                    [alarmMessagesTool  addDevice:alarmMessage];
                    [self  alarmMessageAlterView:deviceName];
                }
                
                break;
            case 113:
                deviceGategory_ID = 2;
                deviceName = @"红外感应";
                deviceState = [transCodingMethods  transThemeCodingFromServer:data ];
                if ([[deviceState substringToIndex:2] isEqualToString:@"01"]  ) {
                    
                    NSString *string1 =[receiveMessage  substringToIndex:52];
                    NSString *string2 = @"020000026400";
                    self.alarmString = [string1  stringByAppendingString:string2];
                    
                    alarmMessage.device_no = dev_id;
                    alarmMessage.gateway_no = gw_id;
                    alarmMessage.time = [ControlMethods  getCurrentTime];
                    
                    [alarmMessagesTool  addDevice:alarmMessage];
                     [self  alarmMessageAlterView:deviceName];
                    
                }
                
                break;
            case 115:
                deviceGategory_ID = 2;
                deviceName = @"燃气";
                deviceState = [transCodingMethods  transThemeCodingFromServer:data ];
                if ([[deviceState substringToIndex:2] isEqualToString:@"01"]  ) {
                    
                    NSString *string1 =[receiveMessage  substringToIndex:52];
                    NSString *string2 = @"020000026400";
                    self.alarmString = [string1  stringByAppendingString:string2];
                    
                    alarmMessage.device_no = dev_id;
                    alarmMessage.gateway_no = gw_id;
                    alarmMessage.time = [ControlMethods  getCurrentTime];
                    [alarmMessagesTool  addDevice:alarmMessage];
                     [self  alarmMessageAlterView:deviceName];
                    
                }
                
                break;
                
            case 118:
                deviceGategory_ID = 2;
                deviceName = @"烟感";
                deviceState = [transCodingMethods  transThemeCodingFromServer:data ];
                if ([[deviceState substringToIndex:2] isEqualToString:@"01"]  ) {
                    
                    NSString *string1 =[receiveMessage  substringToIndex:52];
                    NSString *string2 = @"020000026400";
                    self.alarmString = [string1  stringByAppendingString:string2];
                    
                    alarmMessage.device_no = dev_id;
                    alarmMessage.gateway_no = gw_id;
                    alarmMessage.time = [ControlMethods  getCurrentTime];
                    [alarmMessagesTool  addDevice:alarmMessage];
                     [self  alarmMessageAlterView:deviceName];
                }
                break;
            case 201:
                deviceGategory_ID = 6;
                deviceName = @"双控";
                deviceState = [transCodingMethods  transThemeCodingFromServer:data ];
                break;
            case 202:
                deviceGategory_ID = 4;
                deviceName = @"情景开关";
                deviceState = [transCodingMethods  transThemeCodingFromServer:data];
                break;
        }
        
        
        deviceMessage *device = [[deviceMessage  alloc]init];
        
        device.DEVICE_GATEGORY_ID  = deviceGategory_ID;
        device.DEVICE_NAME = deviceName;
        device.DEVICE_STATE = deviceState;
        device.DEVICE_NO = dev_id;
        device.DEVICE_TYPE_ID = deviceType_ID;
        device.GATEWAY_NO = gw_id;
        device.SPACE_NO = @"0";
        device.SPACE_TYPE_ID = 0;
        
        deviceMessage *dev = [[deviceMessage  alloc]init];
        
        dev.DEVICE_NO = dev_id;
        dev.GATEWAY_NO = gw_id;
        
        NSArray *deviceArray = [deviceMessageTool  queryWithDeviceNumDevices:dev];
        
        if([data_type isEqualToString:@"0100"]){//上行报文
            
            if (deviceArray.count == 0) {//添加新设备
                
                // NSLog(@"    插入新设备！！！   ");
                
                [deviceMessageTool  addDevice:device];
                
            }else{//更新设备状态
                
                //  NSLog(@"    更新设备！！！   ");
                [deviceMessageTool  updateDeviceMessageOnlyLocal:device];
                
            }
            
        }if([data_type isEqualToString:@"0c00"]){//退网报文
            
            if (deviceArray.count != 0){
                
                // NSLog(@"    删除设备成功！！！   ");
                [deviceMessageTool  deleteDevice:dev];
                
            }
            
        }
        
    }];
    
}

/**
 *  报警弹出对话框
 */
-(void)alarmMessageAlterView:(NSString *)deviceName{
    
    //调用系统铃声
    [alarmRinging  alarmMessageBells];
    
    if (![deviceName isEqualToString:self.alertString]) {
        
        self.alertString = deviceName;
        
        //回到主线程 刷新UI
        
        dispatch_queue_t queue = dispatch_get_main_queue();
        
        dispatch_async(queue, ^{
            
            NSString *alarmMessage = [NSString  stringWithFormat: @"检测到%@发生报警，系统正在为您处理！",deviceName];
            
            UIAlertView *alterView = [[UIAlertView  alloc]initWithTitle:@"报警通知" message:alarmMessage delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"撤防", nil];
            
            [alterView  show];
            
        });
    }
    
    
}

/**
 *  判断是否是确定按键被点击
 *
 *  @param alertView   提醒view
 *  @param buttonIndex 确定哪个按钮被点击
 */

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
    SocketManager *socket = [SocketManager shareSocketManager];
    
    if (self.alert != nil) {
        
        if(buttonIndex ==1){//点击的是确定按键
            
            //删除网关
            [self deletespaces];
            
        }
        
        self.alert = nil;
        
    }
    
    else {
        if(buttonIndex ==1){//点击的是确定按键
            //清除BadgeNumber为0
            
            
            
            self.alertString = @"1";
            
            [socket  sendMsg:self.alarmString];
            
            
        }if (buttonIndex == 0) {//点击的是取消按键
            //清除BadgeNumber为0
            
            self.alertString = @"1";
            
        }
        
        
        
    }
    
}

/**
 *  从服务器获取用户的空间信息
 */
-(void)getAllSpaceFromServer{

    //创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager  manager];
    mgr.responseSerializer = [AFJSONResponseSerializers  serializer];
    
    //配置请求超时时间
    mgr.requestSerializer.timeoutInterval = 60;
    
    LZXDataCenter *userPhoneNum = [LZXDataCenter defaultDataCenter];
    
    //设置请求参数
    NSMutableDictionary  *params = [NSMutableDictionary  dictionary];
    params[@"phonenum"] = userPhoneNum.userPhoneNum;
    
    NSString  *urlStr =[NSString  stringWithFormat:@"%@/appGetALLSpace" ,HomecooServiceURL];
    
    NSString *url = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
    
    [mgr  POST:url parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        //打印日志
        //NSLog(@"请求成功--%@",responseObject);
       
        NSString  *result = [responseObject[@"result"]description];
        //服务器返回的设备表信息
        NSArray *spaceListArray = responseObject[@"spaceList" ];
    
        self.spaceListArray = spaceListArray;
        
        if ([result  isEqual:@"success"]) {

            [self updateSpaceList];
            
        } if ([result  isEqual:@"failed"]) {
            
            [MBProgressHUD  showError:@"请求失败!"];
            
        }
        
        [MBProgressHUD  hideHUD];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        [MBProgressHUD  showError:@"网络繁忙，请稍后再试"];
    }];
    

}

/**
 *  在本地数据库中插入 拉回来的服务器中设备的空间信息
 */
-(void)updateSpaceList{
   
    spaceMessageModel * spaceList = [[spaceMessageModel alloc]init];
    
    LZXDataCenter *spaceCenter = [LZXDataCenter  defaultDataCenter];
    
    NSInteger  count;
    
    if (self.spaceListArray.count ==0) {
        
        count = 0;
        
    }else{
    
        count = self.spaceListArray.count;
    }
    
    for (int i = 0; i<count; i++) {
        
        NSDictionary *spaceDit = self.spaceListArray[i];
        
        NSString *spaceName = [spaceDit  objectForKey:@"spaceName"];
        NSString *spaceNo = [spaceDit  objectForKey:@"spaceNo"];
        NSString *gatewayNo = [spaceDit  objectForKey:@"gatewayNo"];
        NSString *spaceId = [spaceDit  objectForKey:@"spaceId"];
        NSString *phoneNum = [spaceDit  objectForKey:@"phoneNum"];
        spaceMessageModel *space = [[spaceMessageModel alloc]init];
       
        space.space_Num =spaceNo;
        
        NSArray *spaceArry =  [spaceMessageTool queryWithspacesDevicePostion:space];
        
        if (spaceArry.count == 0) {//没有此条空间信息
            
            spaceList.space_Name = spaceName;
            spaceList.space_ID = spaceId;
            spaceList.space_Num = spaceNo;
            spaceList.phone_Num = phoneNum;
            spaceList.gateway_Num = gatewayNo;
            
            [spaceMessageTool addSpace:spaceList];
            
        }else{
        
            spaceList.space_Name = spaceName;
            spaceList.space_ID = spaceId;
            spaceList.space_Num = spaceNo;
            spaceList.phone_Num = phoneNum;
            spaceList.gateway_Num = gatewayNo;

            [spaceMessageTool  updateSpaceMessage:spaceList];
    
        }

    }

    spaceMessageModel *space = [[spaceMessageModel alloc]init];

    space.phone_Num = spaceCenter.userPhoneNum;
    
    _spaces=[spaceMessageTool  queryWithspaces:space];
    
    [_collectionView  reloadData];
   
}

/**
 *  添加CollectionView控件
 */
-(void)addUICollectionView{
    
    CGFloat  collectionViewX = 20 ;
    CGFloat  collectionViewY = 90 ;
    CGFloat  collectionViewW = [UIScreen mainScreen].bounds.size.width - 40;
    CGFloat  collectionViewH = [UIScreen  mainScreen].bounds.size.height -125;
    //确定是水平滚动，还是垂直滚动
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    UICollectionView  *collectionView = [[UICollectionView  alloc]initWithFrame:CGRectMake(collectionViewX, collectionViewY, collectionViewW, collectionViewH) collectionViewLayout:flowLayout];
    
    collectionView.dataSource=self;
    collectionView.delegate=self;
    collectionView.backgroundColor = [UIColor  whiteColor];
    [collectionView registerClass:[spaceCollectionViewCell class] forCellWithReuseIdentifier:string];
    
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
    
  
    return   self.spaces.count;
}


//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    _cell = [collectionView dequeueReusableCellWithReuseIdentifier:string forIndexPath:indexPath];
 
    spaceMessageModel  *space = self.spaces[indexPath.row];
    
    _cell.spaceMessageLable.text = [NSString  stringWithFormat:@"%@",space.space_Name];
    
    [_cell.button  addTarget:self action:@selector(enterChangeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return _cell;
    
}
/**
 *  按钮监听事件
 *
 *  @param btn 点击的是哪个
 */
- (void)enterChangeButton:(UIButton *)btn{
    
    spaceCollectionViewCell *cell = (spaceCollectionViewCell *)[[[btn superview]superview]superview];//获取cell
    
    NSIndexPath *indexPathAll = [self.collectionView indexPathForCell:cell];//获取cell对应的section
    
    indexNum =indexPathAll.row;
    
    
    NSArray *tempArray = @[@"删除",];
    
    self.showView.titleArray = tempArray;
    
    self.showView.title = @"空间设置";
    
    [self.showView showInView:self.view animated:YES];

 
}

- (HCSDaterView *)showView{
    
    if(_showView == nil){
        
        _showView = [[HCSDaterView alloc]initWithFrame:CGRectZero];
        
        _showView.sureBtn.hidden = YES;
        
        _showView.cancleBtn.hidden = YES;
        
        _showView.delegate = self;
    }
    
    return _showView;
}

- (void)daterViewClicked:(HCSDaterView *)daterView{
    
    switch (daterView.currentIndexPath.row) {
            
        case 0:
            //删除空间
            [self deletespace];
            
            break;
            
      
    }
    
}


/**
 *  提醒用户是否需要删除网关设备
 */
-(void)deletespace{
    
    [_showView  hiddenInView:self.view animated:YES];
    
    UIAlertView * alert = [[UIAlertView  alloc]initWithTitle:@"温馨提示" message:@"确定要删除此空间吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    self.alert = alert;
    
    [alert show];
    
}


/**
 *  点击删除当前选中的空间
 */
-(void)deletespaces{

    //查找数据库中所有存在的网关设备
    NSArray  *spaces = self.spaces;
    
    LZXDataCenter *spaceCenter = [LZXDataCenter  defaultDataCenter];
    
    //建立模型
    spaceMessageModel *space = spaces[indexNum];
    
    //取出当前cell中的网关信息
    spaceMessageModel  *spaceIndex = [[spaceMessageModel  alloc]init];
    
    spaceIndex.space_Num = space.space_Num;
    
    //NSLog(@"%@",spaceIndex.space_Num);
    
    //创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager  manager];
    mgr.responseSerializer = [AFJSONResponseSerializers  serializer];
    
    //配置请求超时时间
    mgr.requestSerializer.timeoutInterval = 60;

    //设置请求参数
    NSMutableDictionary  *params = [NSMutableDictionary  dictionary];
    
    
    params[@"SpaceNo"] = space.space_Num;
    params[@"phoneNum"] = spaceCenter.userPhoneNum;
    
    NSLog(@"%@",params);
    
    
    NSString  *urlStr =[NSString  stringWithFormat:@"%@/appDeleteSpace" ,HomecooServiceURL];
    NSString *url = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
    
    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        //打印日志
        // NSLog(@"请求成功--%@",responseObject);
        
        NSString  *result = [responseObject[@"result"]description];
        
        NSString *message = [responseObject[@"messageInfo"]description];
        
        if ([result  isEqual:@"success"]) {//删除空间成功成功
        
            [MBProgressHUD  showSuccess:[NSString  stringWithFormat:@"%@",message]];
            
            //删除当前空间
            [spaceMessageTool  delete:spaceIndex];
            
            //更新cell中网关设备
            
            spaceMessageModel *spaceMessage = [[spaceMessageModel alloc]init];
            
            spaceMessage.gateway_Num = spaceCenter.gatewayNo;
            spaceMessage.phone_Num = spaceCenter.userPhoneNum;
            
            _spaces=[spaceMessageTool   queryWithspaces:spaceMessage];
            
            //删除devicespace（用户配置表中的 spaceno）
            
            deviceSpaceMessageModel *deviceSpace = [[deviceSpaceMessageModel alloc]init];
            
            deviceSpace.phone_num = spaceCenter.userPhoneNum;
            deviceSpace.space_no = space.space_Num;
            
            [deviceSpaceMessageTool  deleteDeviceSpace:deviceSpace];
            
            //刷新collectionView
            [_collectionView  reloadData];
            
            
        }
        if ([result  isEqual:@"failed"]) {
            
            
            [MBProgressHUD  showError:[NSString  stringWithFormat:@"%@",message]];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        [MBProgressHUD  showError:@"网络繁忙，请稍后再试"];
    }];
    
    [MBProgressHUD  hideHUD];
    
    

}

//点击界面 退出蒙版
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    //点击界面 退出蒙版效果
    [_showView  hiddenInView:self.view animated:YES];
   
}




/**
 *  定义每个UICollectionView 的大小
 *
 *  @param CGSize 一个cell的宽度
 *
 *  @return 返回设置后的结果
 */

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat  collectionViewW= (CGRectGetMaxX(self.collectionView.frame) -CGRectGetMinX(self.collectionView.frame))/2;
    
    
    
    return CGSizeMake(collectionViewW-20, 40);
    
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


/**
 *设置纯白背景底色
 */
-(void)setWhiteBackground{
    
    
    UILabel  *WhiteBackgroundLable= [[UILabel  alloc]init];
    
    CGFloat  WhiteBackgroundLableX = 20 ;
    CGFloat  WhiteBackgroundLableY = 60 ;
    CGFloat  WhiteBackgroundLableW = [UIScreen mainScreen].bounds.size.width - 40;
    CGFloat  WhiteBackgroundLableH = [UIScreen  mainScreen].bounds.size.height -90;
    WhiteBackgroundLable.frame = CGRectMake(WhiteBackgroundLableX, WhiteBackgroundLableY, WhiteBackgroundLableW, WhiteBackgroundLableH);
    
    WhiteBackgroundLable.backgroundColor = [UIColor  whiteColor];
    
    WhiteBackgroundLable.clipsToBounds = YES;
    WhiteBackgroundLable.layer.cornerRadius = 8.0;//设置边框圆角
    self.WhiteBackgroundLable = WhiteBackgroundLable;
    
    [self.fullscreenView addSubview:WhiteBackgroundLable];
    
}

/**
 *  点击按钮添加新网关
 */
-(void)setupNewSpace{
    
    UIButton  *setupNewSpaceBtn = [[UIButton  alloc]init];
    
    CGFloat setupNewSpaceX =20;
    CGFloat setupNewSpaceY =60;
    CGFloat setupNewSpaceW =130;
    CGFloat setupNewSpaceH =30;
    
    setupNewSpaceBtn.frame = CGRectMake(setupNewSpaceX, setupNewSpaceY, setupNewSpaceW, setupNewSpaceH);
    
    [setupNewSpaceBtn  setTitle:@"+添加新空间" forState:UIControlStateNormal];
    [setupNewSpaceBtn  setTitle:@"+添加新空间" forState:UIControlStateHighlighted];
    [setupNewSpaceBtn  setTitleColor:[UIColor  blackColor] forState:UIControlStateNormal];
    
    [setupNewSpaceBtn  setTitleColor:[UIColor  blackColor] forState:UIControlStateHighlighted];
   
    setupNewSpaceBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    setupNewSpaceBtn.contentEdgeInsets = UIEdgeInsetsMake(0,2, 0, 0);
    
    //[setupNewSpaceBtn  setFont:[UIFont  systemFontOfSize:13]];
    setupNewSpaceBtn.titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:13];

    
    [setupNewSpaceBtn  addTarget:self action:@selector(setupNewSpaceAction) forControlEvents:UIControlEventTouchUpInside];
  
    [self.fullscreenView  addSubview:setupNewSpaceBtn];
    
    
    
}

/**
 *  点击添加网关按钮 调用此方法 加载添加新网关界面
 */
-(void)setupNewSpaceAction{
   
    LZXDataCenter *dataCenter = [LZXDataCenter  defaultDataCenter];
    //UIView  *backgroundView;
    if ([dataCenter.gatewayNo isEqualToString:@"0"] | !dataCenter.gatewayNo ) {
        
        [MBProgressHUD  showError:@"请先添加主机"];
        
    }else{

        self.addSpaceView.mainTitle.text = @"添加空间";
        self.addSpaceView.secondaryTitle.text = @"空间名称 :";
        [self.addSpaceView showGatewayView:self.view animated:YES];
        
        
        }

    
}

-(HSAddspaceDaterView *)addSpaceView{
    
    if(_addSpaceView == nil){
        
        _addSpaceView = [[HSAddspaceDaterView alloc]initWithFrame:CGRectZero];
        _addSpaceView.secondaryField.placeholder = @"请输入空间名称";
        _addSpaceView.delegate = self;
        
    }
    
    return _addSpaceView;
}

-(void)makeSureViewClicked:(HSAddspaceDaterView *)daterView{

    [self addSpaceAction];
}


/**
 *  点击添加按钮  添加新的空间
 */
-(void)addSpaceAction{
    
   
    LZXDataCenter *userPhoneNo = [LZXDataCenter  defaultDataCenter];

    NSString *phoneNum = userPhoneNo.userPhoneNum;
        
    NSString  *phoneNum_gatewayID = [phoneNum  stringByAppendingString:userPhoneNo.gatewayNo];
    NSString  *phoneNum_gatewayID_space_Name = [phoneNum_gatewayID  stringByAppendingString:_addSpaceView.secondaryField.text];
        
        
    NSString *phoneNum_gatewayID_space_Name_tap = [phoneNum_gatewayID_space_Name stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
       
    NSString  *md5Security16 = [phoneNum_gatewayID_space_Name_tap  md5String];
        
    //建立模型
    spaceMessageModel *space = [[spaceMessageModel  alloc]init];
        
    //将新加入的空间名称，添加到模型中
    space.space_Name = _addSpaceView.secondaryField.text;
    space.gateway_Num = userPhoneNo.gatewayNo;
    space.phone_Num = userPhoneNo.userPhoneNum;
    space.space_Num = md5Security16;
   
 
    //创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager  manager];
    mgr.responseSerializer = [AFJSONResponseSerializers  serializer];
    
    //配置请求超时时间
    mgr.requestSerializer.timeoutInterval = 60;
    
    
    NSDictionary  *dict = @{@"spaceName":_addSpaceView.secondaryField.text,
                            @"gatewayNo":userPhoneNo.gatewayNo,
                            @"phoneNum":userPhoneNo.userPhoneNum,
                            @"sapceId":@"",
                            @"spaceNo":md5Security16
                    
                            };
    
    //将字典转换成json串
    NSData  *jsonData = [NSJSONSerialization  dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil  ];
    
    NSString *gatewayJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    
    //设置请求参数
    NSMutableDictionary  *params = [NSMutableDictionary  dictionary];
    
    
    params[@"spaceJson"] = gatewayJson;
   
    //NSLog(@"%@",params);
    
    
    NSString  *urlStr =[NSString  stringWithFormat:@"%@/appAddSpace" ,HomecooServiceURL];
    NSString *url = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
    
    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        //打印日志
        // NSLog(@"请求成功--%@",responseObject);
        
        NSString  *result = [responseObject[@"result"]description];
        
        NSString *message = [responseObject[@"messageInfo"]description];
        
        if ([result  isEqual:@"success"]) {//同步成功
            
           
            [MBProgressHUD  showSuccess:[NSString  stringWithFormat:@"%@",message]];
           
            if ([space.space_Name isEqualToString:@""]) {//空间信息不为空
                
                
                [MBProgressHUD  showError:@"请输入空间名称"];
                
                
            }else{
                
                //向数据库中添加新增加的空间
                [spaceMessageTool  addSpace:space];
                //重新查询数据库中 共有多少个空间
                spaceMessageModel *spaceMessage = [[spaceMessageModel  alloc]init];
                
                spaceMessage.gateway_Num = userPhoneNo.gatewayNo;
                spaceMessage.phone_Num = userPhoneNo.userPhoneNum;
                
                _spaces=[spaceMessageTool   queryWithspaces:spaceMessage];
                
                //刷新表格
                [_collectionView reloadData];

                
            }

        }
        if ([result  isEqual:@"failed"]) {
            
            
            [MBProgressHUD  showError:[NSString  stringWithFormat:@"%@",message]];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
      
        [MBProgressHUD  showError:@"网络繁忙，请稍后再试"];
    }];
    
    [MBProgressHUD  hideHUD];
    
   
}

/**
 *  取消
 */
-(void)cancleBtnAction{
    
    [self.backgroundView  removeFromSuperview];
    
}


/**
 *设置导航栏
 */
-(void)setNavBar{
    
    
    CGFloat navBarW = [UIScreen  mainScreen].bounds.size.width;
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0,navBarW, 40)];
    
    //创建一个导航栏集合
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"空间管理"];
    
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
    
    
    //创建一个右边按钮
//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleDone target:self action:@selector(asyncGatewayInfoAction)];
//    rightButton.title = @"完成";
//    rightButton.tintColor = [UIColor  blackColor];
    //把导航栏集合添加到导航栏中，设置动画关闭
    [navBar pushNavigationItem:navItem animated:NO];
    
    //把左右两个按钮添加到导航栏集合中去
    [navItem setLeftBarButtonItem:leftButton];
    //[navItem setRightBarButtonItem:rightButton];
    
    //将标题栏中的内容全部添加到主视图当中
    [self.fullscreenView addSubview:navBar];
    
    
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
-(BOOL)shouldAutorotate{
    return YES;
}



-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}
@end
