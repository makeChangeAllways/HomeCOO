//
//  linkageController.m
//  HomeCOO
//
//  Created by tgbus on 16/7/22.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "linkageController.h"
#import "AppDelegate.h"
#import "SystemViewController.h"
#import "SpaceViewController.h"
#import "ThemeViewController.h"
#import "SecurityViewController.h"
#import "SettingViewController.h"
#import "MethodClass.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworking.h"
#import "PrefixHeader.pch"
#import "spaceMessageModel.h"
#import "spaceMessageTool.h"
#import "deviceSpaceMessageModel.h"
#import "deviceSpaceMessageTool.h"
#import "spaceCollectionViewCell.h"
#import "NSString+Hash.h"
#import "lightCollectionViewCell.h"
#import "deviceMessage.h"
#import "deviceMessageTool.h"
#import "productCollectionViewCell.h"
#import "getFromServerDevices.h"
#import "MJExtension.h"
#import "transCodingMethods.h"
#import "ControlMethods.h"
#import "LZXDataCenter.h"
#import "themeMessageTool.h"
#import "themMessageModel.h"
#import "mainViewViewController.h"
#import "UnscrollTabController.h"


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

@interface linkageController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    
    
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

/**UICollectionView 容器*/
@property (weak, nonatomic)  UICollectionView *collectionView;

/**设备cell */
@property(nonatomic,weak) productCollectionViewCell *cell;

/**存放所有网关*/
@property(nonatomic,strong)  NSArray *devices;


@property(nonatomic,weak)  UITextField *spaceNameField;

@property(nonatomic,weak) UITextField  *productPositionField;

@property(nonatomic,weak) UITextField  *productNameField;

@property(nonatomic,weak) UITableView *tableView;

@property(nonatomic,weak) UIButton  *positionBtn;

@property(nonatomic,weak) UITextField  *themeNameField_1;

@property(nonatomic,weak) UITextField  *themeNameField_2;

@property(nonatomic,weak) UITextField  *themeNameField_3;

@property(nonatomic,weak) UITextField  *themeNameField_4;


/**用来接收服务器返回的devicetable表中设备信息 */
@property(nonatomic,weak) NSArray *devicesMessages;

/**用来接收服务器返回的userDeviceSpaceList表中设备空间信息 */
@property(nonatomic,weak) NSArray * userDeviceSpaceList;

@property(nonatomic,strong) LZXDataCenter *dataCenter;

@end


static NSString *string = @"productCollectionViewCell";

static  NSInteger indexNum;

@implementation linkageController


-(NSArray *)devices{
    
    if (_devices==nil) {
        
        LZXDataCenter *gateway = [LZXDataCenter defaultDataCenter];
        
        if ([gateway.gatewayNo isEqualToString:@"0"] | !gateway.gatewayNo ) {
            
            [MBProgressHUD  showError:@"请先添加主机"];
            
        }else{
            
            deviceMessage *device = [[deviceMessage alloc]init];
            device.GATEWAY_NO = gateway.gatewayNo;
            
            _devices=[deviceMessageTool queryWithSensorDevices:device];
            
        }
        [MBProgressHUD  hideHUD];
        
        
    }
    
    return _devices;
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //设置背景
    [self setFullscreenView];
    
    LZXDataCenter *dataCenter = [LZXDataCenter  defaultDataCenter];
    
    self.dataCenter = dataCenter;
    
    //创建一个导航栏
    [self setNavBar];
    
    //设置底片背景
    [self  setWhiteBackground];
    
    //添加UICollectionView
    [self  addUICollectionView];
    
}

/**
 *  添加UICollectionView 空间
 */
-(void)addUICollectionView{
    
    CGFloat  collectionViewX = 20 ;
    CGFloat  collectionViewY = 60 ;
    CGFloat  collectionViewW = [UIScreen mainScreen].bounds.size.width - 40;
    CGFloat  collectionViewH = [UIScreen  mainScreen].bounds.size.height -95;
    //确定是水平滚动，还是垂直滚动
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    UICollectionView  *collectionView = [[UICollectionView  alloc]initWithFrame:CGRectMake(collectionViewX, collectionViewY, collectionViewW, collectionViewH) collectionViewLayout:flowLayout];
    
    collectionView.dataSource=self;
    collectionView.delegate=self;
    collectionView.backgroundColor = [UIColor  whiteColor];
    [collectionView registerClass:[productCollectionViewCell class] forCellWithReuseIdentifier:string];
    
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
    
    return  self.devices.count;
}


//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    _cell = [collectionView dequeueReusableCellWithReuseIdentifier:string forIndexPath:indexPath];
    
    deviceMessage  *device = self.devices[indexPath.row];
    
    deviceSpaceMessageModel *deviceSpace = [[deviceSpaceMessageModel alloc]init];
    
    deviceSpace.device_no = device.DEVICE_NO;
    deviceSpace.phone_num = _dataCenter.userPhoneNum;
    NSArray *deviceSpaceArry = [deviceSpaceMessageTool queryWithspacesDeviceNoAndPhonenum:deviceSpace];
    
    if (deviceSpaceArry.count ==0) {
        
        _cell.deviceMessageLable.text =[NSString  stringWithFormat:@"  位置待定/%@",device.DEVICE_NAME];
    }else{
        
        deviceSpaceMessageModel *device_Name = deviceSpaceArry[0];
        
        spaceMessageModel *deviceNameModel = [[spaceMessageModel  alloc]init];
        
        deviceNameModel.space_Num = device_Name.space_no;
        
        NSArray *devicePostion = [spaceMessageTool queryWithspacesDevicePostion:deviceNameModel];
        
        spaceMessageModel *deviceName;
        
        if (devicePostion.count ==0) {
            
        }else{
            
            deviceName = devicePostion[0];
        }
       
        //显示设备位置和设备名称
        _cell.deviceMessageLable.text =[NSString  stringWithFormat:@"  %@/%@",deviceName.space_Name,device.DEVICE_NAME];
        
        
    }
    
    
    [_cell.button  addTarget:self action:@selector(ClickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return _cell;
    
}
/**
 *  按钮监听事件
 *
 *  @param btn 点击的是哪个
 */
- (void)ClickButton:(UIButton *)btn{
    
    productCollectionViewCell *cell = (productCollectionViewCell *)[[[btn superview]superview]superview];//获取cell
    
    NSIndexPath *indexPathAll = [self.collectionView indexPathForCell:cell];//获取cell对应的section
    
    indexNum =indexPathAll.row;
    
    deviceMessage *device = self.devices[indexNum];
   
    NSString *senesorDeviceNo = device.DEVICE_NO;
    NSString *sensorGatewayNo = device.GATEWAY_NO;
    NSString *sensorThmeId = @"";
    NSString *sensorTheme_name = device.DEVICE_NAME;
    NSString *sensorThemeState = device.DEVICE_STATE;
    NSString *gatewayNo_deviceId = [sensorGatewayNo stringByAppendingString:senesorDeviceNo];
    NSString *gatewayNo_deviceId_deviceState = [gatewayNo_deviceId  stringByAppendingString:sensorThemeState];
    NSString *gatewayNo_deviceId_deviceState_md5 = [gatewayNo_deviceId_deviceState md5String];
    
    NSString *sensorThemeNo = gatewayNo_deviceId_deviceState_md5;
    
    NSInteger seneorThemeTypeId = 3;
    
    themMessageModel *sensorTheme = [[themMessageModel  alloc]init];
    
    sensorTheme.device_No = senesorDeviceNo;
    sensorTheme.gateway_No = sensorGatewayNo;
    
    NSArray *sensorThemeArray = [themeMessageTool  queryWiththemeNo:sensorTheme];
    
    if (sensorThemeArray.count == 0) {//表示还未生成该情景 则生成该情景
        
        themMessageModel *addSensorTheme = [[themMessageModel  alloc]init];
        
        addSensorTheme.device_No = senesorDeviceNo;
        addSensorTheme.gateway_No = sensorGatewayNo;
        addSensorTheme.theme_ID = sensorThmeId;
        addSensorTheme.theme_Name = sensorTheme_name;
        addSensorTheme.theme_No = sensorThemeNo;
        addSensorTheme.theme_State = sensorThemeState;
        addSensorTheme.theme_Type = seneorThemeTypeId;
        
        [themeMessageTool addTheme:addSensorTheme];
        
        
    }else{//有此设备的情景存在  则跟新themeno
        
        themMessageModel *updateSensorTheme = [[themMessageModel  alloc]init];
        
        updateSensorTheme.gateway_No = sensorGatewayNo;
        updateSensorTheme.device_No = senesorDeviceNo;
        updateSensorTheme.theme_No = sensorThemeNo;
        
        [themeMessageTool updateSensorThemeNo:updateSensorTheme  ];
    
    }

    _dataCenter.device_No = senesorDeviceNo;
    _dataCenter.gateway_No = sensorGatewayNo;
    _dataCenter.theme_Name = sensorTheme_name;
    _dataCenter.theme_No = sensorThemeNo;
    _dataCenter.theme_State = sensorThemeState;
    _dataCenter.theme_Type = seneorThemeTypeId;
    _dataCenter.theme_ID = sensorThmeId;

    //NSLog(@"====%@====%@===%@====%@====%@====%ld=====%@",_dataCenter.device_No,_dataCenter.gateway_No,_dataCenter.theme_Name,_dataCenter.theme_No,_dataCenter.theme_State,(long)dataCenter.theme_Type,_dataCenter.theme_ID);
//    
    UnscrollTabController  *nextVC = [[UnscrollTabController  alloc]init];
    [self  presentViewController:nextVC animated:YES completion:nil];
    
  
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
 *设置导航栏
 */
-(void)setNavBar{
    
    
    CGFloat navBarW = [UIScreen  mainScreen].bounds.size.width;
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0,navBarW, 40)];
    
    //创建一个导航栏集合
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"联动管理"];
    
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
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleDone target:self action:@selector(finshedAction)];
    rightButton.title = @"完成";
    rightButton.tintColor = [UIColor  blackColor];
    //把导航栏集合添加到导航栏中，设置动画关闭
    [navBar pushNavigationItem:navItem animated:NO];
    
    //把左右两个按钮添加到导航栏集合中去
    [navItem setLeftBarButtonItem:leftButton];
    [navItem setRightBarButtonItem:rightButton];
    
    //将标题栏中的内容全部添加到主视图当中
    [self.fullscreenView addSubview:navBar];
    
    
}

/**
 *  完成
 */
-(void)finshedAction{
    
    NSLog(@"=========完成======");

}


/**返回到上一个systemView*/
-(void)backAction{
    
    SettingViewController  *backVC = [[SettingViewController  alloc]init];
    [self  presentViewController:backVC animated:YES completion:nil];
    
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
