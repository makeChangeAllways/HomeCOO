//
//  SystemViewController.m
//  HomeCOO
//
//  Created by tgbus on 16/5/3.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import "SystemViewController.h"
#import "SpaceViewController.h"
#import "ThemeViewController.h"
#import "SecurityViewController.h"
#import "SettingViewController.h"
#import "AppDelegate.h"
#import "SingleSecurityViewController.h"
#import "SingleLightViewController.h"
#import "SingleRemoteViewController.h"
#import "MethodClass.h"
#import "singleWindowAndDoorController.h"
#import "singleSockViewController.h"
#import "singleMicroViewController.h"
#import "AFNetworkings.h"
#import "UIImageView+WebCache.h"
#import "deviceMessage.h"
#import "deviceMessageTool.h"
#import "LZXDataCenter.h"
#import "SingleMessageViewController.h"
#import "GGMusicControlViewController.h"
#import "CYMainHomeVC.h"
#import "CustomNavVC.h"



//距离边框的距离
#define  HOMECOOEDGWIDTH    20

//按钮之间的间隔
#define  HOMEOOGAPDISTANCE  20

//自适应按钮和文字标签的大小
#define  HOMECOOBUTTONWIDTH  [UIScreen  mainScreen].bounds.size.width / 7

//下面按钮控件距离上面按钮的距离
#define  HOMECOOBUTTONDISTANCE 10

//文字标签的高度
#define  HOMECOOLABLEHEIGHT    20

//上面子控件里屏幕顶端的距离
#define  HOMECOODISTANCESCREEN 60

//底部空间、情景模式等按钮的高度
#define HOMECOOSPACEBUTTONHEIGHT 60

//底部空间、情景模式等按钮的宽度
#define HOMECOOSPACEBUTTONWIDTH [UIScreen  mainScreen].bounds.size.width / 5

//底部空间、情景模式等按钮Y的大小
#define  HOMECOOSPACEBUTTON_Y  [UIScreen  mainScreen].bounds.size.height - 55

//底部空间、情景模式等按钮字体的大小
#define HOMESPACEFONT 13

//4.7寸以上 屏幕天气界面上下间隔
#define HOMEWEATHERGAP 10
@interface SystemViewController ()<CLLocationManagerDelegate>

@property(nonatomic,strong) CLLocationManager* locationmanager;

/**空间view*/
@property (nonatomic, strong) SpaceViewController    *spaceView;

/**情景view*/
@property (nonatomic, strong) ThemeViewController    *themeView;

/**安防view*/
@property (nonatomic, strong) SecurityViewController *securityView;

/**设置view*/
@property (nonatomic, strong) SettingViewController  *settingView;

/**设置背景图片*/
@property(nonatomic,weak)  UIImageView  * fullscreenView;

/**设置导航栏*/
@property(nonatomic,weak)  UINavigationBar *navBar;

/**设置导航栏item*/
@property(nonatomic,weak) UINavigationItem *navItem;

/**设置安防按钮*/
@property(nonatomic,weak)UIButton  *securityControlBtn ;

/**设置安防标签*/
@property(nonatomic,weak)UILabel   *securityLable ;

/**设置遥控按钮*/
@property(nonatomic,weak)UIButton  *remoteControlBtn ;

/**设置遥控标签*/
@property(nonatomic,weak)UILabel   *remoteLable ;

/**设置照明按钮*/
@property(nonatomic,weak)UIButton  *lightControlBtn ;

/**设置照明标签*/
@property(nonatomic,weak)UILabel   *lightLable ;

/**设置消息按钮*/
@property(nonatomic,weak)UIButton  *messageControlBtn ;

/**设置消息标签*/
@property(nonatomic,weak)UILabel   *messageLable ;

/**设置门窗按钮*/
@property(nonatomic,weak)UIButton  *windowAndDoorControlBtn ;

/**设置门窗标签*/
@property(nonatomic,weak)UILabel   *windowAndDoorLable ;

/**设置插座按钮*/
@property(nonatomic,weak)UIButton  *socketControlBtn ;

/**设置插座标签*/
@property(nonatomic,weak)UILabel   *socketLable;

/**设置微控按钮*/
@property(nonatomic,weak)UIButton  *microControllerBtn ;

/**设置微控标签*/
@property(nonatomic,weak)UILabel   *microLable;

/**设置音乐按钮*/
@property(nonatomic,weak)UIButton  *musicControllerBtn ;

/**设置音乐标签*/
@property(nonatomic,weak)UILabel   *musicLable;

/**设置时间标签*/
@property(nonatomic,weak)UILabel *  datelabel;

/**设置白天图片*/
@property(nonatomic,weak)UIImageView  *dayPicture;

/**设置夜间图片*/
@property(nonatomic,weak)UIImageView  *nightPicture;

/**设置天气*/
@property(nonatomic,weak) UILabel  * weatherlabel;

/**设置风速*/
@property(nonatomic,weak) UILabel  * windlabel;

/**设置温度*/
@property(nonatomic,weak) UILabel  *temperaturelabel;

/**当前地理位置经纬度*/
@property(nonatomic,copy) NSString *latitudeAndlongitudeStr;

@property(nonatomic,copy)  NSString *latitude;

@property(nonatomic,copy)  NSString *longitude;

@property(nonatomic,weak) NSArray  * dictArray;

@property(nonatomic,strong) NSArray *devices;
@property(nonatomic,strong) NSArray *device;
@property(nonatomic,strong) UIButton  *localAndRemoteChangesBtn;

@property(nonatomic,strong) UIAlertView * alert;
@end

@implementation SystemViewController

/**
 *懒加载spaceview控制器
 */
-(SpaceViewController *) spaceView{

    if (!_spaceView) {
        self.spaceView = [[SpaceViewController  alloc]init];
        self.spaceView.view.frame = [UIScreen mainScreen].bounds;
    }
    return _spaceView;
}

/**
 *懒加载themeView控制器
 */

-(ThemeViewController *) themeView{
    
    if (!_themeView) {
        self.themeView = [[ThemeViewController  alloc]init];
        self.themeView.view.frame = [UIScreen mainScreen].bounds;
    }
    return _themeView;
}

/**
 *懒加载securityView控制器
 */

-(SecurityViewController *) securityView{
    
    if (!_securityView) {
        self.securityView = [[SecurityViewController  alloc]init];
        self.securityView.view.frame = [UIScreen mainScreen].bounds;
    }
    return _securityView;
}


/**
 *懒加载settingView控制器
 */
-(SettingViewController *) settingView{
    
    if (!_settingView) {
        self.settingView = [[SettingViewController  alloc]init];
        self.settingView.view.frame = [UIScreen mainScreen].bounds;
    }
    return _settingView;
}
-(NSArray *)devices
{
    if (_devices==nil) {
        
        LZXDataCenter *gateway = [LZXDataCenter defaultDataCenter];
        
        if ([gateway.gatewayNo isEqualToString:@"0"] | !gateway.gatewayNo ) {
            
           
            
        }else{
            
            deviceMessage *device = [[deviceMessage alloc]init];
            device.GATEWAY_NO = gateway.gatewayNo;
            
            _devices=[deviceMessageTool queryTempSensorDevices:device];
            
          
        }
      
    }
    
    return _devices;
    
}
-(NSArray *)device
{
    if (_device==nil) {
        
        LZXDataCenter *gateway = [LZXDataCenter defaultDataCenter];
        
        if ([gateway.gatewayNo isEqualToString:@"0"] | !gateway.gatewayNo ) {
            
            
            
        }else{
            
            deviceMessage *device = [[deviceMessage alloc]init];
            device.GATEWAY_NO = gateway.gatewayNo;
            
            _device=[deviceMessageTool queryPM2_5SensorDevices:device];
            
            
        }
        
    }
    
    return _device;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建一个导航栏
    [self setNavBar];
    
    //添加上面部分子控件
    [self setUpScreenView];
    
    //添加天气模块
    [self  addWeatherModle];

    //获取当前的地理位置
    [self  getCurrentGeolocations];
   
//    NSTimer  *time =  [NSTimer  scheduledTimerWithTimeInterval:3 target:self selector:@selector(getCurrentGeolocations) userInfo:nil repeats:YES];
//    //主线程也会抽出一点时间处理一下timer （不管主线程是否在处理其他时间）
//    [[NSRunLoop  mainRunLoop]addTimer:time forMode:NSRunLoopCommonModes];

    //获取实时天气
    //[self  getWeather];
    
}


-(void)getCurrentGeolocations {
   
    _locationmanager = [[CLLocationManager alloc]init];
   
    //设置定位的精度

    [_locationmanager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    _locationmanager.delegate = self;
  
    [_locationmanager requestAlwaysAuthorization];// 前后台同时定位   
  
    //开始定位
    [_locationmanager startUpdatingLocation];
    
   // NSLog(@"开始定位");
   
}

#pragma mark Core Location委托方法用于实现位置的更新

//获取当前的地理位置
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    
    //打印出经度和纬度
    CLLocationCoordinate2D coordinate  = newLocation.coordinate;
    
    double latitude = coordinate.latitude;
    double longitude = coordinate.longitude;

    //将double类型转换成nsstring  将经纬度调换
    _latitudeAndlongitudeStr = [NSString stringWithFormat:@"%f,%f",longitude,latitude];
  
   // NSLog(@"经纬度:%@",_latitudeAndlongitudeStr);//南昌市经纬度 115.8645280000,28.6876750000
    
    //停止定位
    [_locationmanager stopUpdatingLocation];
    //获取当前地理位置的天气信息
    
    [self  getWeather];
        
  
}


//定位失败 代理方法
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;{
    
    //停止定位
    [_locationmanager stopUpdatingLocation];

   // NSLog(@"定位失败");

}


/**
 *添加天气模块
 */

-(void)addWeatherModle{
    
    deviceMessage  *tempSensor;
    deviceMessage *PM2_5Sensor;
    if (self.devices.count !=0) {
        
        tempSensor = self.devices[0];
    }
    if (self.device.count !=0) {
        PM2_5Sensor = self.device[0];
    }

    //时间lable
    UILabel  * datelabel = [[UILabel alloc]init];
    
    CGFloat  datelabelX =CGRectGetMaxX(self.messageControlBtn.frame) + HOMEOOGAPDISTANCE;
    CGFloat  datelabelY =CGRectGetMinY(self.messageControlBtn.frame);
    CGFloat  datelabelW =[UIScreen  mainScreen].bounds.size.width - CGRectGetMaxX(self.messageControlBtn.frame) -2*HOMEOOGAPDISTANCE;
    CGFloat  datelabelH =25;
    
    datelabel.frame = CGRectMake(datelabelX, datelabelY, datelabelW, datelabelH);
    datelabel.numberOfLines = 0;//不做行限制
    
    //datelabel.backgroundColor = [UIColor   redColor];
    //datelabel.textAlignment =NSTextAlignmentCenter;
    datelabel.font = [UIFont  systemFontOfSize:15];

    self.datelabel =datelabel;
    
    
    UIImageView  *dayPicture = [[UIImageView  alloc]init];
    
    CGFloat  dayPictureX =CGRectGetMaxX(self.messageControlBtn.frame) +datelabelW/ 3-10 ;
    CGFloat  dayPictureY =CGRectGetMaxY(datelabel.frame )+10;
    CGFloat  dayPictureW =30;
    CGFloat  dayPictureH =20;
    
    dayPicture.frame = CGRectMake(dayPictureX, dayPictureY, dayPictureW, dayPictureH);
    dayPicture.contentMode = UIViewContentModeScaleToFill;
    //dayPicture.backgroundColor = [UIColor  blueColor];
    self.dayPicture =dayPicture;
    
    
    UIImageView  *nightPicture = [[UIImageView  alloc]init];
    
    CGFloat  nightPictureX =CGRectGetMaxX(dayPicture.frame) + datelabelW/3 -30;
    CGFloat  nightPictureY =CGRectGetMaxY(datelabel.frame )+10;
    CGFloat  nightPictureW =30;
    CGFloat  nightPictureH =20;
    
    nightPicture.frame = CGRectMake(nightPictureX, nightPictureY, nightPictureW, nightPictureH);
    nightPicture.contentMode = UIViewContentModeScaleToFill;
    //nightPicture.backgroundColor = [UIColor  blueColor];
    self.nightPicture =nightPicture;
    
    
    //天气lable
    UILabel  * weatherlabel = [[UILabel alloc]init];
    
    CGFloat  weatherlabelX =CGRectGetMaxX(self.messageControlBtn.frame) + HOMEOOGAPDISTANCE;
    CGFloat  weatherlabelY =CGRectGetMaxY(dayPicture.frame) + 5;
    CGFloat  weatherlabelW =datelabelW/2;
    CGFloat  weatherlabelH =40;
    
    weatherlabel.frame = CGRectMake(weatherlabelX, weatherlabelY, weatherlabelW, weatherlabelH);
    weatherlabel.numberOfLines = 0;//不做行限制
    
    //weatherlabel.backgroundColor = [UIColor   redColor];
    //weatherlabel.textAlignment =NSTextAlignmentCenter;
    weatherlabel.font = [UIFont  systemFontOfSize:15];
    self.weatherlabel =weatherlabel;
    
    //风速lable
    UILabel  * windlabel = [[UILabel alloc]init];
    
    CGFloat  windlabelX =CGRectGetMaxX(weatherlabel.frame) ;
    CGFloat  windlabelY =CGRectGetMaxY(dayPicture.frame) + 5;
    CGFloat  windlabelW =datelabelW-weatherlabelW;
    CGFloat  windlabelH =40;
    
    windlabel.frame = CGRectMake(windlabelX, windlabelY, windlabelW, windlabelH);
    windlabel.numberOfLines = 0;//不做行限制
    windlabel.font = [UIFont  systemFontOfSize:15];
    //windlabel.backgroundColor = [UIColor   blueColor];
    //windlabel.textAlignment =NSTextAlignmentCenter;
    
    self.windlabel =windlabel;
   
    //温度lable
    UILabel  * temperaturelabel = [[UILabel alloc]init];
    
    CGFloat  temperaturelabelX =CGRectGetMaxX(self.messageControlBtn.frame) + HOMEOOGAPDISTANCE ;
    CGFloat  temperaturelabelY =CGRectGetMaxY(weatherlabel.frame) ;
    CGFloat  temperaturelabelW =datelabelW;
    CGFloat  temperaturelabelH =25;
    
    temperaturelabel.frame = CGRectMake(temperaturelabelX, temperaturelabelY, temperaturelabelW, temperaturelabelH);
    temperaturelabel.numberOfLines = 0;//不做行限制
    temperaturelabel.font = [UIFont  systemFontOfSize:15];
    //temperaturelabel.backgroundColor = [UIColor   blueColor];
    //temperaturelabel.textAlignment =NSTextAlignmentCenter;
    self.temperaturelabel =temperaturelabel;
    
    UILabel *indoorTemp = [[UILabel  alloc]init];
    
    CGFloat  indoorX;
    CGFloat  indoorY;
    CGFloat  indoorW;
    CGFloat  indoorH;
    
    if ([UIScreen  mainScreen].bounds.size.width == 568) {//4.0的屏幕
        indoorX =CGRectGetMaxX(self.messageControlBtn.frame) + HOMEOOGAPDISTANCE ;
        indoorY =CGRectGetMaxY(temperaturelabel.frame) ;
        indoorW =70;
        indoorH =25;
    }else{
        
        indoorX =CGRectGetMaxX(self.messageControlBtn.frame) + HOMEOOGAPDISTANCE ;
        indoorY =CGRectGetMaxY(temperaturelabel.frame) + HOMEWEATHERGAP;
        indoorW =70;
        indoorH =25;
    
    }
    
    
    indoorTemp.frame = CGRectMake(indoorX, indoorY, indoorW, indoorH);
    indoorTemp.numberOfLines = 0;//不做行限制
    indoorTemp.font = [UIFont  systemFontOfSize:15];
    indoorTemp.text = @"室内温度:";
    //indoorTemp.backgroundColor = [UIColor   redColor];
    
    UILabel *indoorTempText = [[UILabel  alloc]init];
    
    CGFloat  indoorTempTextX;
    CGFloat  indoorTempTextY;
    CGFloat  indoorTempTextW;
    CGFloat  indoorTempTextH;
    
    if ([UIScreen  mainScreen].bounds.size.width == 568) {//4.0的屏幕
      
        indoorTempTextX =CGRectGetMaxX(indoorTemp.frame)  ;
        indoorTempTextY =CGRectGetMaxY(temperaturelabel.frame) ;
        indoorTempTextW =datelabelW-indoorW;
        indoorTempTextH =25;
    }else{
        indoorTempTextX =CGRectGetMaxX(indoorTemp.frame)  ;
        indoorTempTextY =CGRectGetMaxY(temperaturelabel.frame) +HOMEWEATHERGAP;
        indoorTempTextW =datelabelW-indoorW;
        indoorTempTextH =25;
        
    }
    
    indoorTempText.frame = CGRectMake(indoorTempTextX, indoorTempTextY, indoorTempTextW, indoorTempTextH);
    indoorTempText.numberOfLines = 0;//不做行限制
    indoorTempText.font = [UIFont  systemFontOfSize:15];
    //分割字符串
    NSArray *array = [tempSensor.DEVICE_STATE componentsSeparatedByString:@"p"]; //从字符A中分隔成2个元素的数组
  
    
    indoorTempText.text =[array[0]  stringByAppendingString:@"ºC"];
    indoorTempText.textAlignment =NSTextAlignmentLeft;
    //indoorTempText.backgroundColor = [UIColor   greenColor];
    
    
    UILabel *indoorHumi = [[UILabel  alloc]init];
    
    CGFloat  indoorHumiX;
    CGFloat  indoorHumiY;
    CGFloat  indoorHumiW;
    CGFloat  indoorHumiH;
    
    
    if ([UIScreen  mainScreen].bounds.size.width == 568) {//4.0的屏幕
        
        indoorHumiX =CGRectGetMaxX(self.messageControlBtn.frame) + HOMEOOGAPDISTANCE ;
        indoorHumiY =CGRectGetMaxY(indoorTemp.frame) ;
        indoorHumiW =35;
        indoorHumiH =25;
    }else{
        indoorHumiX =CGRectGetMaxX(self.messageControlBtn.frame) + HOMEOOGAPDISTANCE ;
        indoorHumiY =CGRectGetMaxY(indoorTemp.frame) + HOMEWEATHERGAP;
        indoorHumiW =35;
        indoorHumiH =25;
        
    }

    
    indoorHumi.frame = CGRectMake(indoorHumiX, indoorHumiY, indoorHumiW, indoorHumiH);
    indoorHumi.numberOfLines = 0;//不做行限制
    indoorHumi.font = [UIFont  systemFontOfSize:15];
    indoorHumi.text = @"湿度:";
    //indoorHumi.backgroundColor = [UIColor   greenColor];
    
    UILabel *indoorHumiText = [[UILabel  alloc]init];
    
    CGFloat  indoorHumiTextX;
    CGFloat  indoorHumiTextY;
    CGFloat  indoorHumiTextW ;
    CGFloat  indoorHumiTextH;
    if ([UIScreen  mainScreen].bounds.size.width == 568) {//4.0的屏幕
        
        indoorHumiTextX =CGRectGetMaxX(indoorHumi.frame) + 1;
        indoorHumiTextY =CGRectGetMaxY(indoorTemp.frame) ;
        indoorHumiTextW =datelabelW-indoorHumiW;
        indoorHumiTextH =25;
        
    }else{
        
        indoorHumiTextX =CGRectGetMaxX(indoorHumi.frame) + 1;
        indoorHumiTextY =CGRectGetMaxY(indoorTemp.frame) + HOMEWEATHERGAP ;
        indoorHumiTextW =datelabelW-indoorHumiW;
        indoorHumiTextH =25;
    }
    
    
    indoorHumiText.frame = CGRectMake(indoorHumiTextX,indoorHumiTextY , indoorHumiTextW, indoorHumiTextH);
    indoorHumiText.numberOfLines = 0;//不做行限制
    indoorHumiText.font = [UIFont  systemFontOfSize:15];
    indoorHumiText.text =[ array[1]  stringByAppendingString:@"%"];
    indoorHumiText.textAlignment =NSTextAlignmentLeft;
   //indoorHumiText.backgroundColor = [UIColor   redColor];
    
    
    
    UILabel *PM2_5 = [[UILabel  alloc]init];
    
    CGFloat  PM2_5X ;
    CGFloat  PM2_5Y ;
    CGFloat  PM2_5W ;
    CGFloat  PM2_5H ;
    
    if ([UIScreen  mainScreen].bounds.size.width == 568) {//4.0的屏幕
        
        PM2_5X =CGRectGetMaxX(self.messageControlBtn.frame) + HOMEOOGAPDISTANCE ;
        PM2_5Y =CGRectGetMaxY(indoorHumi.frame) ;
        PM2_5W =55;
        PM2_5H =25;
    }else{
        PM2_5X =CGRectGetMaxX(self.messageControlBtn.frame) + HOMEOOGAPDISTANCE ;
        PM2_5Y =CGRectGetMaxY(indoorHumi.frame) + HOMEWEATHERGAP ;
        PM2_5W =55;
        PM2_5H =25;
        
    }

    PM2_5.frame = CGRectMake(PM2_5X, PM2_5Y, PM2_5W, PM2_5H);
    PM2_5.numberOfLines = 0;//不做行限制
    PM2_5.font = [UIFont  systemFontOfSize:15];
    PM2_5.text = @"PM2.5:";
    //PM2_5.backgroundColor = [UIColor   orangeColor];
    
    
    UILabel *PM2_5Text = [[UILabel  alloc]init];
    
    CGFloat  PM2_5TextX;
    CGFloat  PM2_5TextY;
    CGFloat  PM2_5TextW;
    CGFloat  PM2_5TextH;
    
    if ([UIScreen  mainScreen].bounds.size.width == 568) {//4.0的屏幕
        
        PM2_5TextX =CGRectGetMaxX(PM2_5.frame);
        PM2_5TextY =CGRectGetMaxY(indoorHumi.frame) ;
        PM2_5TextW =datelabelW-PM2_5W;
        PM2_5TextH =25;
        
    }else{
        PM2_5TextX =CGRectGetMaxX(PM2_5.frame);
        PM2_5TextY =CGRectGetMaxY(indoorHumi.frame) + HOMEWEATHERGAP;
        PM2_5TextW =datelabelW-PM2_5W;
        PM2_5TextH =25;
        
    }
    PM2_5Text.frame = CGRectMake(PM2_5TextX, PM2_5TextY,PM2_5TextW , PM2_5TextH);
    PM2_5Text.numberOfLines = 0;//不做行限制
    PM2_5Text.font = [UIFont  systemFontOfSize:15];
    PM2_5Text.text = PM2_5Sensor.DEVICE_STATE;
    PM2_5Text.textAlignment =NSTextAlignmentLeft;
    //PM2_5Text.backgroundColor = [UIColor   greenColor];
    
    [self.fullscreenView  addSubview:PM2_5Text];
    [self.fullscreenView  addSubview:indoorHumiText];
    [self.fullscreenView  addSubview:indoorTempText];
    [self.fullscreenView  addSubview:PM2_5];
    [self.fullscreenView  addSubview:indoorHumi];
    [self.fullscreenView  addSubview:indoorTemp];
    [self.fullscreenView  addSubview:temperaturelabel];
    [self.fullscreenView  addSubview:windlabel];
    [self.fullscreenView  addSubview:weatherlabel];
    [self.fullscreenView  addSubview:nightPicture];
    [self.fullscreenView  addSubview:dayPicture];
    [self.fullscreenView  addSubview:datelabel];
    
}


-(void)getWeather{

    
    dispatch_queue_t   queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
   
        //创建请求管理者
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager  manager];
        mgr.responseSerializer = [AFJSONResponseSerializers  serializer];
        
        //配置请求超时时间
        mgr.requestSerializer.timeoutInterval = 60;
        
        //设置请求参数
        NSMutableDictionary  *params = [NSMutableDictionary  dictionary];
        params[@"ak"] = @"Ldj2VvqlfeyX2DjWVWCc911tjMPg2xGy";
        params[@"location"] = _latitudeAndlongitudeStr;
        params[@"output"] = @"json";
      
       //打印出经纬度
       // NSLog(@"location = %@" ,_latitudeAndlongitudeStr);
        
        [mgr GET:@"http://api.map.baidu.com/telematics/v3/weather" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            //打印日志
            
             //NSLog(@"请求成功--%@",responseObject);
            //获取当天时间
            NSString  *date = [responseObject[@"date"]description];
            
            
            //获取返回天气结果
     
            NSArray  * dictArray = responseObject[@"results"];

            NSDictionary  *weatherDict = dictArray[0];

            //获得最近一周的天气数据
            NSArray *weatherMsg = weatherDict[@"weather_data"];
            
            //提取当天的天气数据
            NSDictionary *todayWeather =weatherMsg[0];
            
            NSString *nightPictureUrlStr =[todayWeather[@"nightPictureUrl"]description];
            NSString *weather =[todayWeather[@"weather"]description];
            NSString *wind =[todayWeather[@"wind"]description];
            NSString *temperature =[todayWeather[@"temperature"]description];
            NSString *dayPictureUrlStr =[todayWeather[@"dayPictureUrl"]description];
            NSString *weekdate =[todayWeather[@"date"]description];
            
            if ([UIScreen  mainScreen].bounds.size.width==568) {//4.0寸屏幕上
                
                self.datelabel.text = [NSString stringWithFormat:@"%@  %@",date,[weekdate  substringToIndex:2]];
            }else{
                self.datelabel.text = [NSString stringWithFormat:@"%@       %@",date,[weekdate  substringToIndex:2]];}
          
            NSURL *dayPictureUrl = [NSURL  URLWithString:dayPictureUrlStr];
            NSURL *nightPictureUrl = [NSURL  URLWithString:nightPictureUrlStr];

           
            [self.dayPicture  sd_setImageWithURL:dayPictureUrl placeholderImage:nil];
            [self.nightPicture  sd_setImageWithURL:nightPictureUrl placeholderImage:nil];
            
            self.weatherlabel.text = [NSString  stringWithFormat:@"%@",weather];
            self.windlabel.text = [NSString  stringWithFormat:@"%@",wind];
            self.temperaturelabel.text = [NSString  stringWithFormat:@"%@",temperature];
    //        NSLog(@"nightPictureUrl%@",nightPictureUrl);
    //        NSLog(@"weather%@",weather);
    //        NSLog(@"wind%@",wind);
    //        NSLog(@"temperature%@",temperature);
    //        NSLog(@"dayPictureUrl%@",dayPictureUrl);
    //        NSLog(@"date%@",date);

            
            //NSLog(@"todayWeather is%@",todayWeather);
            
       
           
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
        }];
        
 });

}

/**
 *添加上面部分控件
 */

-(void)setUpScreenView{

    //添加安防按钮
    UIButton  *securityControlBtn = [[UIButton  alloc]init];
    
    CGFloat  securityControlBtnX = HOMECOOEDGWIDTH;
    CGFloat  securityControlBtnY = HOMECOODISTANCESCREEN ;
    CGFloat  securityControlBtnW = HOMECOOBUTTONWIDTH;
    CGFloat  securityControlBtnH = securityControlBtnW;
    if ([UIScreen  mainScreen].bounds.size.width==568){//4.0存屏幕
        securityControlBtn.frame = CGRectMake(securityControlBtnX, 50, securityControlBtnW, securityControlBtnH);
    }else{
    
     securityControlBtn.frame = CGRectMake(securityControlBtnX, securityControlBtnY, securityControlBtnW, securityControlBtnH);
    
    }
   
    //添加注册按钮背景颜色
   // securityControlBtn.backgroundColor = [UIColor redColor];
    [MethodClass  setButton:securityControlBtn setNormalImage:@"安防.png" setHighlightedImage:@"安防.png"];

    self.securityControlBtn = securityControlBtn;
    
    
    //监听注册按钮
    [securityControlBtn  addTarget:self action:@selector(securityAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel  *securityLable = [[UILabel  alloc]init];
    
    CGFloat  securityLableX = HOMECOOEDGWIDTH;
    CGFloat  securityLableY = CGRectGetMaxY(securityControlBtn.frame)  ;
    CGFloat  securityLableW = HOMECOOBUTTONWIDTH;
    CGFloat  securityLableH = HOMECOOLABLEHEIGHT;
    
    securityLable.frame = CGRectMake(securityLableX, securityLableY, securityLableW, securityLableH);
    securityLable.text = @"安防";
    securityLable.textColor = [UIColor  blackColor];
    securityLable.textAlignment = NSTextAlignmentCenter;
    securityLable.font = [UIFont fontWithName:@"Arial" size:15];
    //securityLable.backgroundColor = [UIColor  redColor];
    self.securityLable = securityLable;
    
    
    //添加遥控按钮
    UIButton  *remoteControlBtn = [[UIButton  alloc]init];
    
    CGFloat  remoteControlBtnX = CGRectGetMaxX(securityControlBtn.frame) + HOMEOOGAPDISTANCE;
    CGFloat  remoteControlBtnY = HOMECOODISTANCESCREEN ;
    CGFloat  remoteControlBtnW = HOMECOOBUTTONWIDTH;
    CGFloat  remoteControlBtnH = remoteControlBtnW;
    
    if ([UIScreen  mainScreen].bounds.size.width==568){//4.0存屏幕
    
    
        remoteControlBtn.frame = CGRectMake(remoteControlBtnX, 50, remoteControlBtnW, remoteControlBtnH);
    }else{
    
   
        remoteControlBtn.frame = CGRectMake(remoteControlBtnX, remoteControlBtnY, remoteControlBtnW, remoteControlBtnH);
    
    }
    
    
    //添加注册按钮背景颜色
    //registerBtn.backgroundColor = [UIColor redColor];
    [MethodClass  setButton:remoteControlBtn setNormalImage:@"遥控.png" setHighlightedImage:@"遥控.png"];
    
    self.remoteControlBtn = remoteControlBtn;
    //监听注册按钮
    [remoteControlBtn  addTarget:self action:@selector(remoteAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel  *remoteLable = [[UILabel  alloc]init];
    
    CGFloat  remoteLableX = CGRectGetMaxX(securityLable.frame) + HOMEOOGAPDISTANCE;
    CGFloat  remoteLableY = CGRectGetMaxY(remoteControlBtn.frame)  ;
    CGFloat  remoteLableW = HOMECOOBUTTONWIDTH;
    CGFloat  remoteLableH = HOMECOOLABLEHEIGHT;
    
    remoteLable.frame = CGRectMake(remoteLableX, remoteLableY, remoteLableW, remoteLableH);
    remoteLable.text = @"遥控";
    remoteLable.textColor = [UIColor  blackColor];
    remoteLable.textAlignment = NSTextAlignmentCenter;
    remoteLable.font = [UIFont fontWithName:@"Arial" size:15];
    //remoteLable.backgroundColor = [UIColor  redColor];
    self.remoteLable = remoteLable;
    
    //添加照明按钮
    UIButton  *lightControlBtn = [[UIButton  alloc]init];
    
    CGFloat  lightControlBtnX = CGRectGetMaxX(remoteControlBtn.frame) + HOMEOOGAPDISTANCE;
    CGFloat  lightControlBtnY = HOMECOODISTANCESCREEN ;
    CGFloat  lightControlBtnW = HOMECOOBUTTONWIDTH;
    CGFloat  lightControlBtnH = lightControlBtnW;
    
     if ([UIScreen  mainScreen].bounds.size.width==568){//4.0存屏幕
        
         lightControlBtn.frame = CGRectMake(lightControlBtnX, 50, lightControlBtnW, lightControlBtnH);
     }else{
        
         lightControlBtn.frame = CGRectMake(lightControlBtnX, lightControlBtnY, lightControlBtnW, lightControlBtnH);
     }
   
    //添加注册按钮背景颜色
    //lightControlBtn.backgroundColor = [UIColor redColor];
    [MethodClass  setButton:lightControlBtn setNormalImage:@"照明.png" setHighlightedImage:@"照明.png"];

    self.lightControlBtn = lightControlBtn;
    //监听注册按钮
    [lightControlBtn  addTarget:self action:@selector(lightAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel  *lightLable = [[UILabel  alloc]init];
    
    CGFloat  lightLableX = CGRectGetMaxX(remoteLable.frame) + HOMEOOGAPDISTANCE;
    CGFloat  lightLableY = CGRectGetMaxY(lightControlBtn.frame)  ;
    CGFloat  lightLableW = HOMECOOBUTTONWIDTH;
    CGFloat  lightLableH = HOMECOOLABLEHEIGHT;
    
    lightLable.frame = CGRectMake(lightLableX, lightLableY, lightLableW, lightLableH);
    lightLable.text = @"照明";
    lightLable.textColor = [UIColor  blackColor];
    lightLable.textAlignment = NSTextAlignmentCenter;
    lightLable.font = [UIFont fontWithName:@"Arial" size:15];
    //lightLable.backgroundColor = [UIColor  redColor];
    self.lightLable = lightLable;

    
    //添加消息按钮
    UIButton  *messageControlBtn = [[UIButton  alloc]init];
    
    CGFloat  messageControlBtnX = CGRectGetMaxX(lightControlBtn.frame) + HOMEOOGAPDISTANCE;
    CGFloat  messageControlBtnY = HOMECOODISTANCESCREEN ;
    CGFloat  messageControlBtnW = HOMECOOBUTTONWIDTH;
    CGFloat  messageControlBtnH = messageControlBtnW;
    
      if ([UIScreen  mainScreen].bounds.size.width==568){//4.0存屏幕
      
       
          messageControlBtn.frame = CGRectMake(messageControlBtnX, 50, messageControlBtnW, messageControlBtnH);
      
      }else{
    
          messageControlBtn.frame = CGRectMake(messageControlBtnX, messageControlBtnY, messageControlBtnW, messageControlBtnH);
      }
    //添加注册按钮背景颜色
    //messageControlBtn.backgroundColor = [UIColor redColor];
    [MethodClass setButton:messageControlBtn setNormalImage:@"消息.png" setHighlightedImage:@"消息.png"];
    
    self.messageControlBtn = messageControlBtn;
    //监听注册按钮
    [messageControlBtn  addTarget:self action:@selector(messageAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel  *messageLable = [[UILabel  alloc]init];
    
    CGFloat  messageLableX = CGRectGetMaxX(lightLable.frame) +HOMEOOGAPDISTANCE;
    CGFloat  messageLableY = CGRectGetMaxY(messageControlBtn.frame)  ;
    CGFloat  messageLableW = HOMECOOBUTTONWIDTH;
    CGFloat  messageLableeH = HOMECOOLABLEHEIGHT;
    
    messageLable.frame = CGRectMake(messageLableX, messageLableY, messageLableW, messageLableeH);
    messageLable.text = @"消息";
    messageLable.textColor = [UIColor  blackColor];
    messageLable.textAlignment = NSTextAlignmentCenter;
    messageLable.font = [UIFont fontWithName:@"Arial" size:15];
    //messageLable.backgroundColor = [UIColor  redColor];
    self.messageLable = messageLable;

    //添加门窗按钮
    UIButton  *windowAndDoorControlBtn = [[UIButton  alloc]init];
    
    CGFloat  windowAndDoorControlBtnX = HOMECOOEDGWIDTH;
    CGFloat  windowAndDoorControlBtnY = CGRectGetMaxY(self.securityLable.frame)+ HOMECOOBUTTONDISTANCE ;
    CGFloat  windowAndDoorControlBtnW = HOMECOOBUTTONWIDTH;
    CGFloat  windowAndDoorControlBtnH = windowAndDoorControlBtnW;
    windowAndDoorControlBtn.frame = CGRectMake(windowAndDoorControlBtnX, windowAndDoorControlBtnY, windowAndDoorControlBtnW, windowAndDoorControlBtnH);
    
    //添加背景图片
    [MethodClass  setButton:windowAndDoorControlBtn setNormalImage:@"门窗.png" setHighlightedImage:@"门窗.png"];

    self.windowAndDoorControlBtn = windowAndDoorControlBtn;
    //监听注册按钮
    [windowAndDoorControlBtn  addTarget:self action:@selector(windowAndDoorAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel  *windowAndDoorLable = [[UILabel  alloc]init];
    
    CGFloat  windowAndDoorLableX = HOMECOOEDGWIDTH;
    CGFloat  windowAndDoorLableY = CGRectGetMaxY(windowAndDoorControlBtn.frame)  ;
    CGFloat  windowAndDoorLableW = HOMECOOBUTTONWIDTH;
    CGFloat  windowAndDoorLableH = HOMECOOLABLEHEIGHT;
    
    windowAndDoorLable.frame = CGRectMake(windowAndDoorLableX, windowAndDoorLableY, windowAndDoorLableW, windowAndDoorLableH);
    windowAndDoorLable.text = @"门窗";
    windowAndDoorLable.textColor = [UIColor  blackColor];
    windowAndDoorLable.textAlignment = NSTextAlignmentCenter;
    windowAndDoorLable.font = [UIFont fontWithName:@"Arial" size:15];
   // windowAndDoorLable.backgroundColor = [UIColor  redColor];
    self.windowAndDoorLable = windowAndDoorLable;

    //添加插座按钮
    UIButton  *socketControlBtn = [[UIButton  alloc]init];
    
    CGFloat  socketControlBtnX = CGRectGetMaxX(windowAndDoorControlBtn.frame) + HOMEOOGAPDISTANCE;
    CGFloat  socketControlBtnY = CGRectGetMaxY(self.remoteLable.frame)+ HOMECOOBUTTONDISTANCE ;
    CGFloat  socketControlBtnW = HOMECOOBUTTONWIDTH;
    CGFloat  socketControlBtnH = socketControlBtnW;
    socketControlBtn.frame = CGRectMake(socketControlBtnX, socketControlBtnY, socketControlBtnW, socketControlBtnH);
    
    //添加背景图片
    [MethodClass  setButton:socketControlBtn setNormalImage:@"插座.png" setHighlightedImage:@"插座.png"];

    self.socketControlBtn = socketControlBtn;
    //监听注册按钮
    [socketControlBtn  addTarget:self action:@selector(socketAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel  *socketLable = [[UILabel  alloc]init];
    
    CGFloat  socketLableX = CGRectGetMaxX(windowAndDoorLable.frame) + HOMEOOGAPDISTANCE;
    CGFloat  socketLableLableY = CGRectGetMaxY(socketControlBtn.frame)   ;
    CGFloat  socketLableW = HOMECOOBUTTONWIDTH;
    CGFloat  socketLableH = HOMECOOLABLEHEIGHT;
    
    socketLable.frame = CGRectMake(socketLableX, socketLableLableY, socketLableW, socketLableH);
    socketLable.text = @"插座";
    socketLable.textColor = [UIColor  blackColor];
    socketLable.textAlignment = NSTextAlignmentCenter;
    socketLable.font = [UIFont fontWithName:@"Arial" size:15];
    //socketLable.backgroundColor = [UIColor  redColor];
    self.socketLable = socketLable;
    

    //添加微控按钮
    UIButton  *microControllerBtn = [[UIButton  alloc]init];

    CGFloat  microControllerBtnX = CGRectGetMaxX(socketControlBtn.frame) + HOMEOOGAPDISTANCE;
    CGFloat  microControllerBtnY = CGRectGetMaxY(self.lightLable.frame)+ HOMECOOBUTTONDISTANCE;
    CGFloat  microControllerBtnW = HOMECOOBUTTONWIDTH;
    CGFloat  microControllerBtnH = microControllerBtnW;
    microControllerBtn.frame = CGRectMake(microControllerBtnX, microControllerBtnY, microControllerBtnW, microControllerBtnH);
    
    //添加背景图片
    [MethodClass  setButton:microControllerBtn setNormalImage:@"微控.png" setHighlightedImage:@"微控.png"];
    

    self.microControllerBtn = microControllerBtn;
    //监听注册按钮
    [microControllerBtn  addTarget:self action:@selector(microAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel  *microLable = [[UILabel  alloc]init];
    
    CGFloat  microLableX = CGRectGetMaxX(socketLable.frame) + HOMEOOGAPDISTANCE;
    CGFloat  microLableY = CGRectGetMaxY(microControllerBtn.frame);
    CGFloat  microLableW = HOMECOOBUTTONWIDTH;
    CGFloat  microLableH = HOMECOOLABLEHEIGHT;
    
    microLable.frame = CGRectMake(microLableX, microLableY, microLableW, microLableH);
    microLable.text = @"微控";
    microLable.textColor = [UIColor  blackColor];
    microLable.textAlignment = NSTextAlignmentCenter;
    microLable.font = [UIFont fontWithName:@"Arial" size:15];
    //microLable.backgroundColor = [UIColor  redColor];
    self.microLable = microLable;
    
    //添加音乐按钮
    UIButton  *musicControllerBtn = [[UIButton  alloc]init];
    
    
    CGFloat  musicControllerBtnX = CGRectGetMaxX(microControllerBtn.frame) + HOMEOOGAPDISTANCE;
    CGFloat  musicControllerBtnY = CGRectGetMaxY(self.messageLable.frame)+ HOMECOOBUTTONDISTANCE;
    CGFloat  musicControllerBtnW = HOMECOOBUTTONWIDTH;
    CGFloat  musicControllerBtnH = musicControllerBtnW;
    musicControllerBtn.frame = CGRectMake(musicControllerBtnX, musicControllerBtnY, musicControllerBtnW, musicControllerBtnH);
    
    //添加背景图片
    [MethodClass  setButton:musicControllerBtn setNormalImage:@"音乐.png" setHighlightedImage:@"音乐.png"];

    self.musicControllerBtn = musicControllerBtn;
    
    //监听注册按钮
    [musicControllerBtn  addTarget:self action:@selector(musicAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel  *musicLable = [[UILabel  alloc]init];
    
    CGFloat  musicLableX = CGRectGetMaxX(microLable.frame) + HOMEOOGAPDISTANCE;
    CGFloat  musicLableY = CGRectGetMaxY(musicControllerBtn.frame);
    CGFloat  musicLableW = HOMECOOBUTTONWIDTH;
    CGFloat  musicLableH = HOMECOOLABLEHEIGHT;
    
    musicLable.frame = CGRectMake(musicLableX, musicLableY, musicLableW, musicLableH);
    musicLable.text = @"音乐";
    musicLable.textColor = [UIColor  blackColor];
    musicLable.textAlignment = NSTextAlignmentCenter;
    musicLable.font = [UIFont fontWithName:@"Arial" size:15];
    //musicLable.backgroundColor = [UIColor  redColor];
    self.musicLable = musicLable;
    

    //添加安防子控件到fullscreenView上，
    [self.fullscreenView  addSubview:securityLable];
    [self.fullscreenView  addSubview:securityControlBtn];
    
    //添加遥控子控件到fullscreenView上，
    [self.fullscreenView  addSubview:remoteControlBtn];
    [self.fullscreenView  addSubview:remoteLable];
    
    //添加照明子控件到fullscreenView上，
    [self.fullscreenView  addSubview:lightControlBtn];
    [self.fullscreenView  addSubview:lightLable];
    
    //添加消息子控件到fullscreenView上，
    [self.fullscreenView  addSubview:messageControlBtn];
    [self.fullscreenView  addSubview:messageLable];
    
    //添加门窗子控件到fullscreenView上，
    [self.fullscreenView  addSubview:windowAndDoorControlBtn];
    [self.fullscreenView  addSubview:windowAndDoorLable];
    
    //添加插座子控件到fullscreenView上，
    [self.fullscreenView  addSubview:socketControlBtn];
    [self.fullscreenView  addSubview:socketLable];
    
    //添加微控子控件到fullscreenView上，
    [self.fullscreenView  addSubview:microControllerBtn];
    [self.fullscreenView  addSubview:microLable];
    
    //添加音乐子控件到fullscreenView上，
    [self.fullscreenView  addSubview:musicControllerBtn];
    [self.fullscreenView  addSubview:musicLable];

    
}

/**
 *进入安防设备空间
 */

-(void)securityAction{


    SingleSecurityViewController  *securityVC = [[SingleSecurityViewController  alloc]init];
    [self  presentViewController:securityVC animated:YES completion:nil];
    
}



/**
 *进入遥控设备空间
 */
-(void)remoteAction{

//    SingleRemoteViewController   *remoteVC = [[SingleRemoteViewController  alloc]init];
//    [self  presentViewController:remoteVC animated:YES completion:nil];

    [LZXDataCenter defaultDataCenter].controlFlag =1;
    
    CYMainHomeVC *mainVC = [[CYMainHomeVC alloc] init];
    CustomNavVC *navVC = [[CustomNavVC alloc] initWithRootViewController:mainVC];
    
    [self  presentViewController:navVC animated:YES completion:nil];
}

/**
 *进入照明设备空间
 */

-(void)lightAction{
    
    SingleLightViewController  *lightVC = [[SingleLightViewController  alloc]init];
    [self  presentViewController:lightVC animated:YES completion:nil];
    
}


/**
 *进入消息设备空间
 */

-(void)messageAction{

    SingleMessageViewController  *messageVC = [[SingleMessageViewController  alloc]init];
    [self  presentViewController:messageVC animated:YES completion:nil];

}


/**
 *进入门窗设备空间
 */

-(void)windowAndDoorAction{

    singleWindowAndDoorController  *singleWindowAndDoorVc = [[singleWindowAndDoorController  alloc]init];
    [self  presentViewController:singleWindowAndDoorVc animated:YES completion:nil];
   }



/**
 *进入插座设备空间
 */

-(void)socketAction{

    singleSockViewController  *sockVc = [[singleSockViewController  alloc]init];
    [self  presentViewController:sockVc animated:YES completion:nil];


}



/**
 *进入微控设备空间
 */

-(void)microAction{

    singleMicroViewController  *microVc = [[singleMicroViewController  alloc]init];
    [self  presentViewController:microVc animated:YES completion:nil];

}


/**
 *进入音乐设备空间
 */

-(void)musicAction{

    GGMusicControlViewController *musicControlVC = [[GGMusicControlViewController alloc]init];
    
    musicControlVC.view.backgroundColor = [UIColor whiteColor];
    
    [self presentViewController:musicControlVC animated:YES completion:nil];

}



/**
 *设置导背景图片
 */
-(void)setFullscreenView{
    
    
    UIImageView  *fullscreenView = [[UIImageView  alloc]init];
    UIImage  *image = [UIImage imageNamed:@"界面背景.jpg"];
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
    
    UIImage * homeCOOIcon = [UIImage  imageNamed:@"HomeCOO.png"];
    
    UIImageView  *homeCOOIconView = [[UIImageView  alloc]initWithImage:homeCOOIcon];
    
    CGFloat homeCOOIconViewX = 10;
    CGFloat homeCOOIconViewY = 5;
    CGFloat homeCOOIconViewW = 115;
    CGFloat homeCOOIconViewH = 18;
    
    homeCOOIconView.contentMode = UIViewContentModeScaleToFill;
    homeCOOIconView.frame = CGRectMake(homeCOOIconViewX, homeCOOIconViewY, homeCOOIconViewW, homeCOOIconViewH);
    
    
    UIButton  *exitBtn = [[UIButton  alloc]init];
    
    CGFloat  exitBtnX = [UIScreen  mainScreen].bounds.size.width - 60 ;
    CGFloat  exitBtnY = 5 ;
    CGFloat  exitBtnW = 40;
    CGFloat  exitBtnH = 30;
    
    exitBtn.frame = CGRectMake(exitBtnX, exitBtnY, exitBtnW, exitBtnH);
    
    [exitBtn  setTitle:@"退出" forState:UIControlStateNormal];
    [exitBtn  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [exitBtn  setFont:[UIFont  systemFontOfSize:15]];
   
    //添加退出按钮背景颜色
    //exitBtn.backgroundColor = [UIColor redColor];
    [exitBtn  addTarget:self action:@selector(exitAction) forControlEvents:UIControlEventTouchUpInside];
   
    [self.fullscreenView  addSubview:homeCOOIconView];
    [self.fullscreenView  addSubview:exitBtn];
    
}

/**
 *退出系统
 */

-(void)exitAction{
    
    UIAlertView * alert = [[UIAlertView  alloc]initWithTitle:@"温馨提示" message:@"确定要退出HomeCOO系统吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];

    [alert show];
}

-(BOOL)shouldAutorotate{
 
    return YES;
}


-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}



@end
