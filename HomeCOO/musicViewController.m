//
//  musicViewController.m
//  HomeCOO
//
//  Created by tgbus on 16/7/8.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "musicViewController.h"
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
#import "PrefixHeader.pch"
#import "AFNetworkings.h"
#import "GGMusicModel.h"
#import "MJExtension.h"
#import "XFMusicDaterView.h"
#import "MBProgressHUD+MJ.h"
#import "SocketManager.h"
#import "themMessageModel.h"
#import "themeMessageTool.h"
#import "themeDeviceMessage.h"
#import "themeDeviceMessageTool.h"
#import "ControlMethods.h"
#import "deviceMessage.h"
#import "deviceMessageTool.h"
#import "PacketMethods.h"
#import "gatewayMessageTool.h"
#import "gatewayMessageModel.h"
#import "GGSocketManager.h"
#import "musicModelDB.h"
#import "musicModelDBTools.h"
//底部空间、情景模式等按钮的高度
#define HOMECOOSPACEBUTTONHEIGHT 60

//底部空间、情景模式等按钮的宽度
#define HOMECOOSPACEBUTTONWIDTH [UIScreen  mainScreen].bounds.size.width / 5

//底部空间、情景模式等按钮Y的大小
#define  HOMECOOSPACEBUTTON_Y  [UIScreen  mainScreen].bounds.size.height - 55

//底部空间、情景模式等按钮字体的大小
#define HOMESPACEFONT 13

@interface musicViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,XFDaterViewDelegate,GCDAsyncSocketDelegate>

@property (nonatomic,strong) XFMusicDaterView *selectedView;
/**设置背景图片*/
@property(nonatomic,weak)  UIImageView  * fullscreenView;

/**设置导航栏*/
@property(nonatomic,weak)  UINavigationBar *navBar;

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,copy) NSString *currentSongName;

@property(nonatomic,strong) LZXDataCenter *dataCenter;
@property (nonatomic,strong) GGSocketManager *socketManager;

@end

@implementation musicViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //设置背景
    [self setFullscreenView];
    
    LZXDataCenter *dataCenter = [LZXDataCenter defaultDataCenter];
    
    self.dataCenter = dataCenter;
    
    //设置背景底色
    [self  setWhiteBackground];
    
    if(_dataCenter.networkStateFlag == 0){
        
        [musicModelDBTools deleteMusicTable];
        self.socketManager = [GGSocketManager shareGGSocketManager];
        
        [self.socketManager startConnectHost:[_dataCenter.QICUNPINGIP substringFromIndex:1] WithPort:8000];
        
        self.socketManager.socket.delegate = self;
        
    }
    
    [self loadData];
    
}




/**
 *设置纯白背景底色
 */
-(void)setWhiteBackground{
    
    CGFloat  WhiteBackgroundLableX = 20 ;
    CGFloat  WhiteBackgroundLableY = 60 ;
    CGFloat  WhiteBackgroundLableW = [UIScreen mainScreen].bounds.size.width - 40;
    CGFloat  WhiteBackgroundLableH = [UIScreen  mainScreen].bounds.size.height -140;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    layout.itemSize = CGSizeMake(WhiteBackgroundLableW/2-10, 50);
    
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(WhiteBackgroundLableX, WhiteBackgroundLableY, WhiteBackgroundLableW, WhiteBackgroundLableH) collectionViewLayout:layout];
    
    self.collectionView.layer.cornerRadius = 8.0;
    self.collectionView.clipsToBounds = YES;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.fullscreenView addSubview:self.collectionView];
    

}

-(void)loadData{
    
    
    if(_dataCenter.networkStateFlag == 0 ){
        
        NSDictionary *paramDict = @{@"bz":@"",@"order":@"0",@"style":@"",@"wgid":_dataCenter.gatewayNo};
        
        
        [self.socketManager sendMsg:[self dictToJson:paramDict]];
        
        
        
        
        
    }else{
        
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        AFHTTPSessionManagers *session = [[AFHTTPSessionManagers alloc]init];

        
        self.dataArray = [NSMutableArray array];
        
        
        NSString *url = [HomecooServiceURL stringByAppendingString:@"/appGetMusic"];
        
        
        dict[@"gatewayNo"] = _dataCenter.gatewayNo;
        
        
        [[session POST:url parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
            
            if ([responseObject[@"result"] isEqualToString:@"success"]) {
                
                NSArray *tempArray = responseObject[@"musicList"];
                
                if(tempArray.count !=0){
                    
                    self.dataArray = [[GGMusicModel objectArrayWithKeyValuesArray:tempArray ] mutableCopy];
                    
                    [self.collectionView reloadData];
                    
                    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionTop];
                    
                }
                
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            
        }]resume];
        
        
        dict[@"themeNo"] = _dataCenter.theme_No;
        
        NSString *getThemeMusic =  [HomecooServiceURL stringByAppendingString:@"/appGetThemeMusic"];
        
        [session POST:getThemeMusic parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
            
            if (![responseObject[@"result"] isEqualToString:@"success"]) {
                
                [MBProgressHUD showError:responseObject[@"messageInfo"]];
                
            }else{
                
                NSArray *tempArray;
                
                if ([responseObject[@"themeMusic"][@"style"] isEqualToString:@"1" ]) {
                    
                    tempArray = @[[NSString stringWithFormat:@"当前设置：暂停%@",responseObject[@"themeMusic"][@"songName"]],@"删除联动音乐",@"暂停联动音乐"];
                }else{
                    
                    tempArray = @[[NSString stringWithFormat:@"当前设置：播放%@",responseObject[@"themeMusic"][@"songName"]],@"删除联动音乐",@"暂停联动音乐"];
                }
                
                self.selectedView.title = @"当前联动音乐设置";
                
                self.currentSongName = responseObject[@"themeMusic"][@"songName"];
                
                self.selectedView.titleArray = tempArray;
                
                [self.selectedView showInView:self.view animated:YES];
                
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            
        }];
        

        
        
        
    }
    
    
    
   
 
}

#pragma mark CollectionViewDelegate CollectionViewDatasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    
    UILabel *label = [[UILabel alloc]initWithFrame:cell.frame];
    
    label.backgroundColor = [UIColor colorWithRed:236/255.0 green:249/255.0 blue:247/255.0 alpha:1];
    
    label.textColor = [UIColor blackColor];
    
    GGMusicModel *model = self.dataArray[indexPath.row];
    
    label.text = model.songName;
    
    
    label.textAlignment = NSTextAlignmentCenter;
    
    cell.backgroundView = label;
    
    return cell;
    
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(5, 10, 5, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *tempArray = @[@"播放音乐",@"暂停音乐",@"删除音乐"];
    
    self.selectedView.titleArray = tempArray;

    self.selectedView.title = @"联动音乐设置";
    
    [self.selectedView showInView:self.view animated:YES];
    
    GGMusicModel *model = self.dataArray[indexPath.row];
    
    self.currentSongName = model.songName;
    
    
    
}

- (void)daterViewDidClicked:(XFMusicDaterView *)daterView{
    
    
    musicModelDB *music =[[musicModelDB alloc]init];
    
    musicModelDB *queryMusic = [[musicModelDB alloc]init];
    
    NSArray *musicArray = [[NSArray alloc]init];
    ////情景音乐设置
    if ([daterView.titleArray.lastObject isEqualToString:@"删除音乐"]) {
        
        switch (daterView.currentIndexPath.row) {
                
            case 0:{
                
                if(_dataCenter.networkStateFlag == 0){
                    
                    
                    NSData *songNamedata = [self.currentSongName dataUsingEncoding:NSUTF8StringEncoding];
                    
                    NSString *songName = [songNamedata base64EncodedStringWithOptions:0];
                    
                    NSData *themeNameData = [_dataCenter.theme_Name dataUsingEncoding:NSUTF8StringEncoding];
                    
                    NSString *themeName = [themeNameData base64EncodedStringWithOptions:0];
                    
                
                    NSDictionary *dict = @{
                                           @"bz":@{
                                                   @"bz":@"",
                                                   @"deviceNo":_dataCenter.device_No,
                                                   @"deviceState":_dataCenter.theme_State,
                                                   @"gatewayNo":_dataCenter.gatewayNo,
                                                   @"songName":songName,
                                                   @"space":@"",
                                                   @"style":@"5",
                                                   @"themeName":themeName,
                                                   @"themeNo":_dataCenter.theme_No,
                                                   
                                                  },
                                            @"order":@"10",
                                            @"songName":songName,
                                            @"style":@"5",
                                            @"wgid":_dataCenter.gatewayNo,
                                           
                                           };
                    
                    music.bz=dict[@"bz"][@"bz"];
                    music.deviceNo =dict[@"bz"][@"deviceNo"];
                    music.deviceState =dict[@"bz"][@"deviceState"];
                    music.gatewayNo =dict[@"bz"][@"gatewayNo"];
                    music.songName =[[NSString alloc]
                                     initWithData:[[NSData alloc]
                                                   initWithBase64EncodedString:dict[@"bz"][@"songName"] options:0] encoding:NSUTF8StringEncoding];
                    music.space =dict[@"bz"][@"space"];
                    music.style =dict[@"bz"][@"style"];
                    music.themeName =dict[@"bz"][@"themeName"];
                    music.themeNo =dict[@"bz"][@"themeNo"];
                    
                    queryMusic.themeNo =dict[@"bz"][@"themeNo"];
                    musicArray = [musicModelDBTools querWithThemeNoMusic:queryMusic];
                    if (musicArray.count !=0) {
                        
                        [musicModelDBTools updateMusicList:music];
                        
                    }else{
                        
                        [musicModelDBTools addMusicList:music];
                    }
                    
                    

                    [self.socketManager sendMsg:[self dictToJson:dict]];
                    
                    NSLog(@" 内网情景音乐设置 = %@",[self dictToJson:dict]);
                    
                    break;
                    
                    
                }
             
                NSDictionary *dict = @{
                                       
                                       @"deviceNo":_dataCenter.device_No,
                                       @"deviceState":_dataCenter.theme_State,
                                       @"gatewayNo":_dataCenter.gatewayNo,
                                       @"songName":self.currentSongName,
                                       @"space":@"",
                                       @"themeName":_dataCenter.theme_Name,
                                       @"themeNo":_dataCenter.theme_No,
                                       @"style":@5
                                       
                                       };
                
                
                [self setThemeApi:@"setThemeMusic" key:@"thememusic" value:dict];
                
                [self appSendThemeMusicOrder];

                
            }break;
                
            case 1:{
                
                
                if(_dataCenter.networkStateFlag == 0){
                    
                    
                    NSData *plainData = [self.currentSongName dataUsingEncoding:NSUTF8StringEncoding];
                    
                    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
                    
                    NSData *themeNameData = [_dataCenter.theme_Name dataUsingEncoding:NSUTF8StringEncoding];
                    
                    NSString *themeName = [themeNameData base64EncodedStringWithOptions:0];
                    
                    NSDictionary *dict = @{@"bz": @{
                                                   @"bz":@"",
                                                   @"deviceNo":_dataCenter.device_No,
                                                   @"deviceState":_dataCenter.theme_State,
                                                   @"gatewayNo":_dataCenter.gatewayNo,
                                                   @"songName":base64String,
                                                   @"space":@"",
                                                   @"style":@"1",
                                                   @"themeName":themeName,
                                                   @"themeNo":_dataCenter.theme_No,
                                                   },
                                           
                                           @"order":@"12",
                                           @"songName":base64String,
                                           @"style":@"5",
                                           @"wgid":_dataCenter.gatewayNo,
                                           
                                           };
                    
                    
                    [self.socketManager sendMsg:[self dictToJson:dict]];
                    
                    
                    
                    
                    
                    
                    break;
                }
                
                NSDictionary *dict = @{
                                       
                                       @"deviceNo":_dataCenter.device_No,
                                       @"deviceState":_dataCenter.theme_State,
                                       @"gatewayNo":_dataCenter.gatewayNo,
                                       @"songName":self.currentSongName,
                                       @"space":@"",
                                       @"themeName":_dataCenter.theme_Name,
                                       @"themeNo":_dataCenter.theme_No,
                                       @"style":@1
                                       };
                
                
                [self setThemeApi:@"setThemeMusic" key:@"thememusic" value:dict];
                
                
                [self appSendThemeMusicOrder];
                
            }break;
                
            case 2:{
                
                if(_dataCenter.networkStateFlag == 0){
                    
                    NSData *plainData = [self.currentSongName dataUsingEncoding:NSUTF8StringEncoding];
                    
                    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
                    
                    NSDictionary *paramDict = @{@"bz":_dataCenter.theme_No,@"order":@"9",@"songName":base64String,@"style":@"5",@"wgid":_dataCenter.gatewayNo};
                    
                    
                    [self.socketManager sendMsg:[self dictToJson:paramDict]];
                    
                   
                    break;
                }
                
                NSDictionary *dict = @{@"themeNo":_dataCenter.theme_No,@"gatewayNO":_dataCenter.gatewayNo};
                
                [self setThemeApi:@"DeleteThemeMusic" key:nil value:dict];
                
                [self appSendThemeMusicOrder];
                
            }break;

        }

    }else{//情景设置
        
        switch (daterView.currentIndexPath.row) {
                
            case 1:{
                
                if(_dataCenter.networkStateFlag == 0){
                    
                    
                    NSData *plainData = [self.currentSongName dataUsingEncoding:NSUTF8StringEncoding];
                    
                    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
                    
                    NSDictionary *paramDict = @{@"bz":_dataCenter.theme_No,@"order":@"9",@"songName":base64String,@"style":@"5",@"wgid":_dataCenter.gatewayNo};
                    
                    
                    [self.socketManager sendMsg:[self dictToJson:paramDict]];
                    

                
                    
                }else{
                    
                    NSDictionary *dict = @{@"themeNo":_dataCenter.theme_No,@"gatewayNo":_dataCenter.gatewayNo};
                    
                    [self setThemeApi:@"DeleteThemeMusic" key:nil value:dict];
                    
                    [self appSendThemeMusicOrder];
                }
                
              
                
            }break;
                
            case 2:{
                
                
                if(_dataCenter.networkStateFlag == 0){
                    
                    NSData *plainData = [self.currentSongName dataUsingEncoding:NSUTF8StringEncoding];
                    
                    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
                    
                    NSData *themeNameData = [_dataCenter.theme_Name dataUsingEncoding:NSUTF8StringEncoding];
                    
                    NSString *themeName = [themeNameData base64EncodedStringWithOptions:0];
                    
                   NSDictionary *dict = @{@"bz": @{
                                                  @"bz":@"",
                                                  @"deviceNo":_dataCenter.device_No,
                                                  @"deviceState":_dataCenter.theme_State,
                                                  @"gatewayNo":_dataCenter.gatewayNo,
                                                  @"songName":base64String,
                                                  @"space":@"",
                                                  @"style":@"1",
                                                  @"themeName":themeName,
                                                  @"themeNo":_dataCenter.theme_No,
                                                 },
                     
                                         @"order":@"12",
                                         @"songName":base64String,
                                         @"style":@"5",
                                         @"wgid":_dataCenter.gatewayNo,
                    
                                          };
                    
                    
                    [self.socketManager sendMsg:[self dictToJson:dict]];
                    
                    
                    
                    
                    
                    
                }else {
                    
                    NSDictionary *dict = @{
                                           
                                           @"deviceNo":_dataCenter.device_No,
                                           @"deviceState":_dataCenter.theme_State,
                                           @"gatewayNo":_dataCenter.gatewayNo,
                                           @"songName":self.currentSongName,
                                           @"space":@"",
                                           @"themeName":_dataCenter.theme_Name,
                                           @"themeNo":_dataCenter.theme_No,
                                           @"style":@1
                                           
                                           };
                    
                    [self setThemeApi:@"setThemeMusic" key:@"thememusic" value:dict];
                    
                    [self appSendThemeMusicOrder];

                }
                
                
            }break;
        }
        
        
    }
    
}


- (void)appSendThemeMusicOrder {
    
    NSDictionary *dict = @{@"gatewayNo":_dataCenter.gatewayNo,
                           @"messsageType":@5,
                           @"time":@0,
                           @"object":@[
                                   
                                   @{ @"bz":@"",
                                      @"deviceNo":_dataCenter.device_No,
                                      @"deviceState":_dataCenter.theme_State,
                                      @"gatewayNo":_dataCenter.gatewayNo,
                                      @"songName":self.currentSongName,
                                      @"space":@"",
                                      @"style":@"6",
                                      @"themeName":_dataCenter.theme_Name,
                                      @"themeNo":_dataCenter.theme_No
                                      }
                                   
                                   
                                   ]
                           
                           };
    
    [self setThemeApi:@"appSendThemeMusicOrder" key:@"jpushJson" value:dict];

}

- (XFMusicDaterView *)selectedView{
    
    if(_selectedView == nil){
        
        _selectedView = [[XFMusicDaterView alloc]initWithFrame:CGRectZero];
        
        _selectedView.delegate = self;
    }
    
    return _selectedView;
}

- (void)setThemeApi:(NSString *)api key:(NSString *)key value:(NSDictionary *)value {

    //歌曲控制
    AFHTTPRequestOperationManager *session = [[AFHTTPRequestOperationManager alloc]init];
    
    NSData *tempData = [NSJSONSerialization dataWithJSONObject:value options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *json = [[NSString alloc]initWithData:tempData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    if (key == nil) {
        
        dict = (NSMutableDictionary *)value;
        
    }else {
        
        dict[key] = json;
    }
    
    [session POST:[HomecooServiceURL stringByAppendingPathComponent:api] parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dic[@"result"] isEqualToString:@"success"]) {
            
            NSLog(@"控制成功");
            
        }else{
            
            NSLog(@"控制失败");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}


- (id)jsonToArrayOrdict:(NSString *)json{
    
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    
    
    
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    
}


- (NSString *)dictToJson:(NSDictionary *)dict{
    
    
    NSData *tempData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *json = [[NSString alloc]initWithData:tempData encoding:NSUTF8StringEncoding];
    
    
    json = [json stringByAppendingString:@"\0"];
    
    
    return json;
    
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
-(BOOL)shouldAutorotate{
    return YES;
}



-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}



#pragma mark GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    
    //连接到服务端时同样要设置监听，否则收不到服务器发来的消息
    [sock readDataWithTimeout:-1 tag:0];
    self.socketManager.gatewayIP = 1;
    NSLog(@"socket连接成功");
    
    
}


- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    
    if (self.socketManager.connectStatus == GACSocketConnectStatusDisconnected) {//主动断开
        
    }else{//网关掉线
        
        //断开连接以后再自动重连
        
        
        if (self.socketManager.socketConnectNum < 1) {
            
            [sock connectToHost:self.socketManager.host onPort:self.socketManager.port error:nil];
        }
        self.socketManager.socketConnectNum ++;
        
        self.socketManager.socketStatus = 0;
       
    }
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    //当接受到服务器发来的消息时，同样设置监听，否则只会收到一次
    [sock readDataWithTimeout:-1 tag:0];
    NSString *readDataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    if([[readDataStr  substringFromIndex:readDataStr.length -2] isEqualToString:@"ff"]){//网关认证未通过
        
        self.socketManager.socketStatus = 0;
        
    }
    readDataStr = [readDataStr substringToIndex:readDataStr.length-1];
    
    
   
    NSData *tempData = [readDataStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:tempData options:NSJSONReadingMutableContainers error:nil];
    
    if(dict!=nil){
        
        switch ([dict[@"order"] integerValue]) {
                
            case 0:{
                
                [self getMusicList:dict];
                
                NSDictionary *paramDict = @{@"bz":@"",@"order":@"17",@"style":@"",@"wgid":_dataCenter.gatewayNo};
              
                NSLog(@"获取当前情景下联动的音乐 = %@",[self dictToJson:paramDict]);
                
                [self.socketManager sendMsg:[self dictToJson:paramDict]];
                
            }break;
                
            case 18: {
                
                NSArray *tempArray;
                
                NSString *str = dict[@"style"];
                
                NSData *tempData = [str dataUsingEncoding:NSUTF8StringEncoding];
                
                NSArray *array = [NSJSONSerialization JSONObjectWithData:tempData options:NSJSONReadingMutableContainers error:nil];
                
                musicModelDB *music =[[musicModelDB alloc]init];
                
                musicModelDB *queryMusic = [[musicModelDB alloc]init];
                
                NSArray *musicArray;
                
                for (int i=0; i<array.count; i++){
                    
                    NSDictionary *dict = array[i];
                    
                    music.bz=dict[@"bz"];
                    music.deviceNo =dict[@"deviceNo"];
                    music.deviceState =dict[@"deviceState"];
                    music.gatewayNo =dict[@"gatewayNo"];
                    music.songName =[[NSString alloc]
                                     initWithData:[[NSData alloc]
                                                   initWithBase64EncodedString:dict[@"songName"] options:0] encoding:NSUTF8StringEncoding];
                    music.space =dict[@"space"];
                    music.style =dict[@"style"];
                    music.themeName =dict[@"themeName"];
                    music.themeNo =dict[@"themeNo"];
                    
                    queryMusic.themeNo =dict[@"themeNo"];
                    musicArray = [musicModelDBTools querWithThemeNoMusic:queryMusic];
                    if (musicArray.count !=0) {
                        
                        [musicModelDBTools updateMusicList:music];
                        
                    }else{
                        
                        [musicModelDBTools addMusicList:music];
                    }
                    
                    if([_dataCenter.theme_No isEqualToString:dict[@"themeNo"]]){
                        
                        
                        NSString *tt = array[i][@"songName"];
                        
                        NSData *nsdataFromBase64String = [[NSData alloc]
                                                          initWithBase64EncodedString:tt options:0];
                        
                        
                        NSString *base64Decoded = [[NSString alloc]
                                                   initWithData:nsdataFromBase64String encoding:NSUTF8StringEncoding];
                        
                        tempArray = @[[NSString stringWithFormat:@"当前设置：%@",base64Decoded],@"删除联动音乐",@"暂停联动音乐"];
                        
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            self.selectedView.title = @"当前联动音乐设置";
                            
                            self.currentSongName = base64Decoded;
                            
                            self.selectedView.titleArray = tempArray;
                            
                            [self.selectedView showInView:self.view animated:YES];
                            
                        });
                        
                        
                    }
                    
                    
                }
                
        
            }break;
                
            default:{
                
                
                
            }
        }
    }
}

- (void)getMusicList:(NSDictionary *)dict {
    
    NSArray *tempArray;
    if (dict[@"style"]!=nil) {
        tempArray = [self jsonToArrayOrdict:dict[@"style"]];
    }
    if(tempArray.count !=0){
        
        
        self.dataArray = [NSMutableArray array];
        
        for (int i=0; i<tempArray.count; i++) {
            
            GGMusicModel *model = [[GGMusicModel alloc]init];
            
            
            
            NSData *nsdataFromBase64String = [[NSData alloc]
                                              initWithBase64EncodedString:tempArray[i][@"songName"] options:0];
            
            
            NSString *base64Decoded = [[NSString alloc]
                                       initWithData:nsdataFromBase64String encoding:NSUTF8StringEncoding];
            
            
            model.songName = base64Decoded ;
            
            [self.dataArray addObject:model];
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.collectionView reloadData];
            
            [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionTop];
            
        });
        
        
    }
    
}
@end
