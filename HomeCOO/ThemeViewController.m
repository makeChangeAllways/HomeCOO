//
//  ThemeViewController.m
//  HomeCOO
//
//  Created by tgbus on 16/5/3.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "ThemeViewController.h"
#import "AppDelegate.h"
#import "SystemViewController.h"
#import "SpaceViewController.h"
#import "SecurityViewController.h"
#import "SettingViewController.h"
#import "MethodClass.h"
#import "themeModelViewCell.h"
#import "themMessageModel.h"
#import "themeMessageTool.h"
#import "PacketMethods.h"
#import "ControlMethods.h"
#import "LZXDataCenter.h"
#import "MBProgressHUD+MJ.h"
#import "SocketManager.h"
#import "GGSocketManager.h"
#import "deviceSpaceMessageModel.h"
#import "deviceSpaceMessageTool.h"
#import "spaceMessageModel.h"
#import "spaceMessageTool.h"
//底部空间、情景模式等按钮的高度
#define HOMECOOSPACEBUTTONHEIGHT 60

//底部空间、情景模式等按钮的宽度
#define HOMECOOSPACEBUTTONWIDTH [UIScreen  mainScreen].bounds.size.width / 5

//底部空间、情景模式等按钮Y的大小
#define  HOMECOOSPACEBUTTON_Y  [UIScreen  mainScreen].bounds.size.height - 55

//底部空间、情景模式等按钮字体的大小
#define HOMESPACEFONT 13

@interface ThemeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>


/**设置背景图片*/
@property(nonatomic,weak)  UIImageView  * fullscreenView;

/**设置导航栏*/
@property(nonatomic,weak)  UINavigationBar *navBar;
/**UICollectionView 容器*/
@property (weak, nonatomic)  UICollectionView *collectionView;

/**网关cell */
@property(nonatomic,weak) themeModelViewCell *cell;

@property(nonatomic,strong)  NSArray  *theme;

@property(nonatomic,strong)   UIButton *button;

@property(nonatomic,strong) LZXDataCenter *dataCenter;
@property(nonatomic,strong)  deviceSpaceMessageModel *deviceSpace;

@end
static NSString *string = @"themeModelViewCell";

static  NSInteger indexNum;

//static  char arry[1]= {'0'};//2016年9月7日 注释掉

@implementation ThemeViewController


-(NSArray*)theme{
    
    if (_theme==nil) {
        
        LZXDataCenter *themeDevice = [LZXDataCenter defaultDataCenter];
        
        if ([themeDevice.gatewayNo isEqualToString:@"0"] | !themeDevice.gatewayNo ) {
            [MBProgressHUD  showError:@"请先添加主机"];
        }else{
            
            themMessageModel *theme = [[themMessageModel alloc]init];
            theme.gateway_No = themeDevice.gatewayNo;
            _theme=[themeMessageTool queryWiththemes:theme];
            
        }
        [MBProgressHUD  hideHUD];
        
    }
    
    return _theme;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    //创建一个导航栏
    [self setNavBar];
    
    LZXDataCenter *dataCenter = [LZXDataCenter defaultDataCenter];

    self.dataCenter = dataCenter;
    //设置底片背景
    [self  setWhiteBackground];
    
    //添加UICollectionView
    [self  addUICollectionView];
    
    [self   receivedFromGateway_deviceMessage];
    
}

-(void)receivedFromGateway_deviceMessage{
    
    SocketManager  *socket = [SocketManager  shareSocketManager];
    
    [socket  receiveMsg:^(NSString *receiveInfo) {
        
        
    }];
    
}



/**
 *  添加UICollectionView 控件
 */

-(void)addUICollectionView{
    
   
    CGFloat  collectionViewX = 20 ;
    CGFloat  collectionViewY = 60 ;
    CGFloat  collectionViewW = [UIScreen mainScreen].bounds.size.width - 40;
    CGFloat  collectionViewH = [UIScreen  mainScreen].bounds.size.height -140;
    //确定是水平滚动，还是垂直滚动
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    UICollectionView  *collectionView = [[UICollectionView  alloc]initWithFrame:CGRectMake(collectionViewX, collectionViewY, collectionViewW, collectionViewH) collectionViewLayout:flowLayout];
    
    collectionView.dataSource=self;
    collectionView.delegate=self;
    collectionView.backgroundColor = [UIColor  whiteColor];
    [collectionView registerClass:[themeModelViewCell class] forCellWithReuseIdentifier:string];
    
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
    
    return  self.theme.count;
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    _cell = [collectionView dequeueReusableCellWithReuseIdentifier:string forIndexPath:indexPath];
    
    themMessageModel  *theme = self.theme[indexPath.row];
    if (!_deviceSpace) {
        
        _deviceSpace = [[deviceSpaceMessageModel alloc]init];
        
    }
    
    if ([theme.device_No isEqualToString:@"3030303030303030"]) {
        _deviceSpace.device_no = @"";
        
    }else{
        
        _deviceSpace.device_no = theme.device_No;
        _deviceSpace.phone_num = _dataCenter.userPhoneNum;
        
    }
    
    NSArray *deviceSpaceArry = [deviceSpaceMessageTool queryWithspacesDeviceNoAndPhonenum:_deviceSpace];
    
    if (deviceSpaceArry.count == 0) {
        
        _cell.themeMessageLable.text = [NSString stringWithFormat:@"%@",theme.theme_Name];
        
    }else{
        
        deviceSpaceMessageModel *device_Name = deviceSpaceArry[0];
        
        spaceMessageModel *deviceNameModel = [[spaceMessageModel  alloc]init];
        
        deviceNameModel.space_Num = device_Name.space_no;
        
        NSArray *devicePostion = [spaceMessageTool queryWithspacesDevicePostion:deviceNameModel];
        
        spaceMessageModel *deviceName;
        
        if (devicePostion.count ==0) {
            
            _cell.themeMessageLable.text = [NSString stringWithFormat:@"%@",theme.theme_Name];
            
        }else{
            
            deviceName = devicePostion[0];
            //显示设备位置和设备名称
            _cell.themeMessageLable.text = [NSString stringWithFormat:@" %@/%@",deviceName.space_Name,theme.theme_Name];
            
            
        }
        
    }

//    _cell.themeMessageLable.text = [NSString stringWithFormat:@"%@",theme.theme_Name];
    
    [_cell.button  addTarget:self action:@selector(ChangeButton:) forControlEvents:UIControlEventTouchUpInside];
    return _cell;
    
}

/**
 *  按钮监听事件
 *
 *  @param btn 点击的是哪个
 */
- (void)ChangeButton:(UIButton *)btn{
    
    LZXDataCenter  *dataCenter = [LZXDataCenter  defaultDataCenter];
    
    self.button.enabled = YES;
   
    themeModelViewCell *cell = (themeModelViewCell *)[[[btn superview]superview]superview];//获取cell上的btn
    
    NSIndexPath *indexPathAll = [self.collectionView indexPathForCell:cell];//获取cell对应的section
    
    indexNum =indexPathAll.row;
   
    btn.enabled = !btn.enabled;
    self.button = btn;
    
    
    if (dataCenter.networkStateFlag == 0) {//内网
        
        [self   localControlThemeCommand];
         [self  localControlMusicPlay];
    }else{
   
        //调用执行控制情景方法
        [self  controlThemeCommand];
    }
   
}
-(void)localControlMusicPlay{
    
    GGSocketManager *socketManager = [GGSocketManager shareGGSocketManager];
    themMessageModel  *theme = self.theme[indexNum];
    
    NSDictionary *paramDict = @{@"bz":theme.theme_No,@"order":@"11",@"style":@"",@"songName":@"",@"wgid":_dataCenter.gatewayNo};
    
    [socketManager sendMsg:[self dictToJson:paramDict]];
    
    NSLog(@" 内网情景音乐播放=  %@",[self dictToJson:paramDict]);
    
}
- (NSString *)dictToJson:(NSDictionary *)dict{
    
    
    NSData *tempData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *json = [[NSString alloc]initWithData:tempData encoding:NSUTF8StringEncoding];
    
    
    json = [json stringByAppendingString:@"\0"];
    
    
    return json;
    
}

-(void)localControlThemeCommand{
    
    SocketManager *socket = [SocketManager  shareSocketManager];
    //获取当前情景下所有信息
    themMessageModel  *theme = self.theme[indexNum];
    
    NSString *dev_type;
    
    
    if ([theme.theme_State  isEqualToString:@"00000000"]) {//如果是自定义情景
        
        dev_type = @"0100";//自定义情景 任意填 硬件情景就是202 CA00
        
    }else{//如果是硬件情景
        
        dev_type = @"CA00";//自定义情景 任意填 硬件情景就是202 CA00
        
    }
    
    NSString *header = @"41414444";//发送给服务器的报头
    
    NSString *stamp = @"00000000";//没有用到的字段
    
    NSString *gw_id = theme.gateway_No;
    
    NSString *dev_id = theme.device_No;
    
    NSString *data_type = @"0d00";//控制情景 13
    
    NSString *data_len = @"0010";
    
    NSString *theme_no = theme.theme_No;
    
    NSString *theme_state = [ControlMethods  transThemeCoding:theme.theme_State];
    
    NSString *data = [theme_no stringByAppendingString:theme_state];
    
    //拼接发送报文
    NSString *packet = [PacketMethods  devicePacket:header getStamp:stamp getGw_id:gw_id getDev_id:dev_id getDev_type:dev_type getData_type:data_type getData_len:data_len getData:data];
    
    
    NSString *deviceControlPacketStr = [packet stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
    //打印报文
    NSLog(@"情景控制报文 == %@",deviceControlPacketStr);
    
    [socket  sendMsg:deviceControlPacketStr];
}

/**
 *  控制情景报文(外网)
 */

-(void)controlThemeCommand{

    //获取当前情景下所有信息
    themMessageModel  *theme = self.theme[indexNum];
    
    NSString *dev_type;
    
    
    if ([theme.theme_State  isEqualToString:@"00000000"]) {//如果是自定义情景
        
         dev_type = @"0100";//自定义情景 任意填 硬件情景就是202 CA00
        
    }else{//如果是硬件情景
    
        dev_type = @"CA00";//自定义情景 任意填 硬件情景就是202 CA00

    }
    
    NSString *header = @"42424141";//发送给服务器的报头
    
    NSString *stamp = @"00000000";//没有用到的字段
    
    NSString *gw_id = theme.gateway_No;
    
    NSString *dev_id = theme.device_No;
    
    NSString *data_type = @"0d00";//控制情景 13
    
    NSString *data_len = @"0010";
    
    NSString *theme_no = theme.theme_No;
    
    NSString *theme_state = [ControlMethods  transThemeCoding:theme.theme_State];
    
    NSString *data = [theme_no stringByAppendingString:theme_state];
    
    //拼接发送报文
    NSString *packet = [PacketMethods  devicePacket:header getStamp:stamp getGw_id:gw_id getDev_id:dev_id getDev_type:dev_type getData_type:data_type getData_len:data_len getData:data];
    
    
    NSString *deviceControlPacketStr = [packet stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
    //打印报文
    NSLog(@"情景控制报文 == %@",deviceControlPacketStr);
    
    //发送报文到对应设备
    [ControlMethods  controlDeviceHTTPmethods:deviceControlPacketStr ];



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
    CGFloat  WhiteBackgroundLableH = [UIScreen  mainScreen].bounds.size.height -140;
    WhiteBackgroundLable.frame = CGRectMake(WhiteBackgroundLableX, WhiteBackgroundLableY, WhiteBackgroundLableW, WhiteBackgroundLableH);
    
    WhiteBackgroundLable.backgroundColor = [UIColor  whiteColor];
    
    WhiteBackgroundLable.clipsToBounds = YES;
    WhiteBackgroundLable.layer.cornerRadius = 8.0;//设置边框圆角
    
    
    [self.fullscreenView addSubview:WhiteBackgroundLable];
    
    
    
    
    
}


/**
 *设置导航栏
 */
-(void)setNavBar{
    CGFloat navBarW = [UIScreen  mainScreen].bounds.size.width;
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0,navBarW, 40)];
    
    //创建一个导航栏集合
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"情景模式"];
    //设置字体大小
    [[UINavigationBar appearance]setTitleTextAttributes:
     @{ NSFontAttributeName: [UIFont systemFontOfSize:16.0]}];
    

    //创建一个左边按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleBordered target:self action:@selector(backAction)];
    
    leftButton.title = @"返回";
    leftButton.tintColor = [UIColor  blackColor];
    
    //设置字体大小
    [[UIBarButtonItem appearance] setTitleTextAttributes:
     @{ NSFontAttributeName: [UIFont systemFontOfSize:15.0],} forState:UIControlStateNormal];
    
    //创建一个右边按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleDone target:self action:@selector(exitAction)];
    rightButton.title = @"退出";
    rightButton.tintColor = [UIColor  blackColor];
    
    //把导航栏集合添加到导航栏中，设置动画关闭
    [navBar pushNavigationItem:navItem animated:NO];
    
    //把左右两个按钮添加到导航栏集合中去
    [navItem setLeftBarButtonItem:leftButton];
    [navItem setRightBarButtonItem:rightButton];
    
    //将标题栏中的内容全部添加到主视图当中
    [self.fullscreenView addSubview:navBar];
}

/**返回到上一个systemView*/
-(void)backAction{
    
    SystemViewController  *vc = [[SystemViewController  alloc]init];
    
    [self  presentViewController: vc animated:YES completion:nil];
  
    
}


/**
 *退出系统
 */
-(void)exitAction{
    UIAlertView * alert = [[UIAlertView  alloc]initWithTitle:@"温馨提示" message:@"确定要退出HomeCOO系统吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert show];
    
}

/**
 *退出应用
 */
- (void)exitApplication {
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    UIWindow *window = app.window;
    
    [UIView animateWithDuration:0.5 animations:^{//1.0f
        window.alpha = 0.5;//透明度似乎没有发挥作用
        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];
}
-(BOOL)shouldAutorotate{
    return YES;
}



-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}
@end
