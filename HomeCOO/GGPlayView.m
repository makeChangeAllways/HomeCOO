//
//  PlayView.m
//  界面搭建
//
//  Created by 王立广 on 16/9/6.
//  Copyright © 2016年 GG. All rights reserved.
//

#import "GGPlayView.h"
#import "AFNetworkings.h"
#import "UIViewExt.h"
#import "GGMusicModel.h"
#import "MJExtension.h"
#import "NSArray+Log.h"
#import "PrefixHeader.pch"
#import "LZXDataCenter.h"
#import "MBProgressHUD+MJ.h"
#import "SocketManager.h"
#import "GGSocketManager.h"


@interface GGPlayView ()<UITableViewDelegate,UITableViewDataSource>

{
    NSString *filePath;
}

@property (nonatomic,strong) UISlider *volumeSlider;

@property (nonatomic,strong) NSString *currentSong;

@property (nonnull,strong) NSIndexPath *currentIndexPath;

@property (nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) LZXDataCenter *dataCenter;

@property (nonatomic,strong) GGSocketManager *socketManager;



@end


@implementation GGPlayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self layoutUI];
        LZXDataCenter *dataCenter = [LZXDataCenter defaultDataCenter];
        
        self.dataCenter = dataCenter;
        
        if(_dataCenter.networkStateFlag == 0){
            
            self.socketManager = [GGSocketManager shareGGSocketManager];
            
            [self.socketManager startConnectHost:[_dataCenter.QICUNPINGIP  substringFromIndex:1] WithPort:8000];
            
            self.socketManager.socket.delegate = self;
            
        }
        
        filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"musicList.plist"];
        
        [self loadData];
        
    }
    return self;
}

- (void)getCurrentVolume{
    
    if(_dataCenter.networkStateFlag == 0){
       
        NSDictionary *dict = @{@"bz":@"",@"order":@"15",@"style":@"",@"wgid":_dataCenter.gatewayNo};
  
        [self.socketManager sendMsg:[self dictToJson:dict]];
        
        
        
        return;
    }

    //获取当前音量
    AFHTTPSessionManagers *session = [[AFHTTPSessionManagers alloc]init];
    
    [session POST:[HomecooServiceURL stringByAppendingPathComponent:@"appGetVolume"] parameters:@{@"gatewayNo":_dataCenter.gatewayNo} success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"result"] isEqualToString:@"success"]) {
            
            self.volumeSlider.value = [responseObject[@"volume"][@"volume"] intValue];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];
    

}

- (void)loadData{
    
    if(_dataCenter.networkStateFlag == 0){
        
        NSDictionary *paramDict = @{@"bz":@"",@"order":@"0",@"style":@"",@"wgid":_dataCenter.gatewayNo};
        
        [self.socketManager sendMsg:[self dictToJson:paramDict]];
        
        return;
    }
    
    self.dataArray = [NSMutableArray array];
    
    AFHTTPSessionManagers *session = [[AFHTTPSessionManagers alloc]init];
    
    NSString *url = [HomecooServiceURL stringByAppendingString:@"/appGetMusic"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"gatewayNo"] = _dataCenter.gatewayNo;
    
    [[session POST:url parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSMutableArray *loaclArray = [NSMutableArray arrayWithContentsOfFile:filePath];
        
        NSArray *tempArray;
        
        if ([responseObject[@"result"] isEqualToString:@"success"]) {
            
            tempArray = responseObject[@"musicList"];
        
        }
        
        if(loaclArray == nil){
            
            loaclArray = [NSMutableArray array];
            
                if(tempArray.count !=0){
                    
                    self.dataArray = [[GGMusicModel objectArrayWithKeyValuesArray:tempArray ] mutableCopy];
                    
                    for(GGMusicModel *model in self.dataArray){
                        
                        [loaclArray addObject:model.songName];
                        
                    }
                    
                    [loaclArray writeToFile:filePath atomically:YES];
                    
                    [self.dataArray removeAllObjects];
                }

            
            }
        
      
            if(tempArray.count !=0 ){
                
                
                
                self.dataArray = [[GGMusicModel objectArrayWithKeyValuesArray:tempArray ] mutableCopy];
                
                [loaclArray removeAllObjects];
                
                for(GGMusicModel *model in self.dataArray){
                    
                    [loaclArray addObject:model.songName];
                    
                }
                
                [loaclArray writeToFile:filePath atomically:YES];
                
                [self.dataArray removeAllObjects];
                
                
                
            }
        
            for (int i=0; i<loaclArray.count; i++) {
                
                GGMusicModel *model = [GGMusicModel new];
                
                model.songName = loaclArray[i];
                
                [self.dataArray addObject:model];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
                
                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
                
                self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                
            });

            

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }]resume];
    
    
    
}

#pragma mark Event

//播放或暂停
- (void)playOrStopSong:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    if(self.dataArray.count!=0){
    
        GGMusicModel *model = self.dataArray[self.currentIndexPath.row];

        if(sender.selected == NO){
            
            //内网播放
            if(_dataCenter.networkStateFlag == 0){
                
                NSData *plainData = [model.songName dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *base64String = [plainData base64EncodedStringWithOptions:0];
                
                NSDictionary *dict = @{@"order":@"2",@"songName":base64String,@"style":@"",@"wgid":_dataCenter.gatewayNo};
                
                [self.socketManager sendMsg:[self dictToJson:dict]];
                
                
                return;
                
            }
            
            //外网播放
            NSDictionary *dict = @{
                                     @"gatewayNo":_dataCenter.gatewayNo,
                                     @"messsageType":@3,
                                     @"object":@{
                                         
                                         @"songName" : model.songName,
                                         @"wgid" : _dataCenter.gatewayNo,
                                         @"order" : @"2"
                                     },
                                     @"time":@0
                                    
                                  };

            
             [self songControParam:dict];
            
            
        }else{
 
            //内网播放
            if(_dataCenter.networkStateFlag == 0){
                
                
                NSData *plainData = [model.songName dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *base64String = [plainData base64EncodedStringWithOptions:0];
                
                NSDictionary *dict = @{@"order":@"1",@"songName":base64String,@"style":@"",@"wgid":_dataCenter.gatewayNo};
                
                [self.socketManager sendMsg:[self dictToJson:dict]];
                
                
                return;
                
            }
            
            NSDictionary *dict = @{
                                   @"gatewayNo":_dataCenter.gatewayNo,
                                   @"messsageType":@3,
                                   @"object":@{
                                           
                                           @"songName" :model.songName,
                                           @"wgid" : _dataCenter.gatewayNo,
                                           @"order" : @"1"
                                           },
                                   @"time":@0
                                   
                                   };
            
            
             [self songControParam:dict];
        }
    
    }
}



//上一曲
- (void)lastSong{

    if (self.dataArray.count !=0) {
        
        GGMusicModel *model = nil;
        
        if (self.currentIndexPath.row == 0) {
            
            
            
            self.currentIndexPath = [NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0];
            
            model = self.dataArray[self.dataArray.count-1];
            
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            
        }else{
            
            
            model = self.dataArray[self.currentIndexPath.row-1];
            
            self.currentIndexPath = [NSIndexPath indexPathForRow:self.currentIndexPath.row-1 inSection:0];
            
            [self.tableView selectRowAtIndexPath:self.currentIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            
        }

        if(_dataCenter.networkStateFlag == 0){
            
            
            NSData *plainData = [model.songName dataUsingEncoding:NSUTF8StringEncoding];
            
            NSString *base64String = [plainData base64EncodedStringWithOptions:0];
            
            
            NSDictionary *dict = @{@"order":@"3",@"songName":base64String,@"style":@"",@"wgid":_dataCenter.gatewayNo};
            
            [self.socketManager sendMsg:[self dictToJson:dict]];
            
            return;
            
            
        }
        
        
        
        
        NSDictionary *dict = @{
                               @"gatewayNo":_dataCenter.gatewayNo,
                               @"messsageType":@3,
                               @"object":@{
                                       
                                       @"songName" : model.songName,
                                       @"wgid" : _dataCenter.gatewayNo,
                                       @"order" : @"3"
                                       },
                               @"time":@0
                               
                               };
        
         [self songControParam:dict];
    }
}


//单曲循环
- (void)refreshSong{

    GGMusicModel *model = self.dataArray[self.currentIndexPath.row];
    
    if (self.dataArray.count !=0) {
        
        if(_dataCenter.networkStateFlag == 0){
            
            NSData *plainData = [model.songName dataUsingEncoding:NSUTF8StringEncoding];
            
            NSString *base64String = [plainData base64EncodedStringWithOptions:0];
            
            NSDictionary *dict = @{@"order":@"5",@"songName":base64String,@"style":@"",@"wgid":_dataCenter.gatewayNo};
            
            [self.socketManager sendMsg:[self dictToJson:dict]];
            
            return;
        }
        NSDictionary *dict = @{
                               @"gatewayNo":_dataCenter.gatewayNo,
                               @"messsageType":@3,
                               @"object":@{
                                       @"songName" :model.songName,
                                       @"wgid" : _dataCenter.gatewayNo,
                                       @"order" : @"5"
                                       },
                               @"time":@0
                               
                               };
        
        
         [self songControParam:dict];
        
    }
    
}

//下一曲
- (void)nextSong{
    
    NSLog(@"下一曲");
    
    if (self.dataArray.count !=0) {
        
        GGMusicModel *model = nil;
      
        
        if (self.currentIndexPath.row+1 == self.dataArray.count) {
            
          
            
            self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            
            model = self.dataArray[0];
            
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            
        }else{
            
            
             model = self.dataArray[self.currentIndexPath.row+1];
            
            self.currentIndexPath = [NSIndexPath indexPathForRow:self.currentIndexPath.row+1 inSection:0];
            
            [self.tableView selectRowAtIndexPath:self.currentIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            
        }
        
        if(_dataCenter.networkStateFlag == 0){
            
            
            NSData *plainData = [model.songName dataUsingEncoding:NSUTF8StringEncoding];
            
            NSString *base64String = [plainData base64EncodedStringWithOptions:0];
            
            
            NSDictionary *dict = @{@"order":@"4",@"songName":base64String,@"style":@"",@"wgid":_dataCenter.gatewayNo};
            
            [self.socketManager sendMsg:[self dictToJson:dict]];
            
            return;
            
            
        }
        
        
        
        NSDictionary *dict = @{
                               @"gatewayNo":_dataCenter.gatewayNo,
                               @"messsageType":@3,
                               @"object":@{
                                       
                                       @"songName" : model.songName,
                                       @"wgid" : _dataCenter.gatewayNo,
                                       @"order" : @"4"
                                       },
                               @"time":@0
                               
                               };
        
        
         [self songControParam:dict];
            
    }
}

//随机播放
- (void)randmSong{
    
    NSLog(@"随机播放");
    
    if(_dataCenter.networkStateFlag == 0){
        
        NSDictionary *dict = @{@"order":@"7",@"songName":@"",@"style":@"",@"wgid":_dataCenter.gatewayNo};
        
        [self.socketManager sendMsg:[self dictToJson:dict]];
        
        return;
        
        
    }
    

    NSDictionary *dict = @{
                           @"gatewayNo":_dataCenter.gatewayNo,
                           @"messsageType":@3,
                           @"object":@{
                                   @"wgid" : _dataCenter.gatewayNo,
                                   @"order" : @"7"
                                   },
                           @"time":@0
                           
                           };
    
    [self songControParam:dict];
    
}

//音量控制
- (void)volumeChange:(UISlider *)sender{
    
    
    if(_dataCenter.networkStateFlag == 0){
        
        
        NSDictionary *dict = @{@"bz":@"",@"order":@"16",@"style":[NSString stringWithFormat:@"%.2ld",(long)sender.value],@"wgid":_dataCenter.gatewayNo};
        
        [self.socketManager sendMsg:[self dictToJson:dict]];
        
        
        
        return;
    }
    
   
    NSDictionary *tempDict =  @{
                                  @"gatewayNo":_dataCenter.gatewayNo,
                                  @"messsageType":@3,
                                  @"object":@{
                                                @"songName" : [NSString stringWithFormat:@"%.2ld",(long)sender.value] ,
                                                @"wgid" : _dataCenter.gatewayNo,
                                                @"order" : @"15"
                                             },
                                  @"time":@0
                                                     
                                };
    
    
    [self songControParam:tempDict];
}


- (void)songControParam:(NSDictionary *)paramDict{
    
    //歌曲控制
    AFHTTPRequestOperationManager *session = [[AFHTTPRequestOperationManager alloc]init];
    
    NSData *tempData = [NSJSONSerialization dataWithJSONObject:paramDict options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *json = [[NSString alloc]initWithData:tempData encoding:NSUTF8StringEncoding];
    
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    dict[@"jpushJson"] = json;

    [session POST:[HomecooServiceURL stringByAppendingPathComponent:@"appSendMusicOrder"] parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
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

#pragma mark GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    
    //连接到服务端时同样要设置监听，否则收不到服务器发来的消息
    [sock readDataWithTimeout:-1 tag:0];
    self.socketManager.gatewayIP = 1;
    NSLog(@"socket连接成功");
    
}


- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    
    if (self.socketManager.connectStatus == GACSocketConnectStatusDisconnected) {//主动断开
        
        NSLog(@"用户主动断开连接");
        
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
    
    NSLog(@"本地音乐收到的内容=%@",dict);
    
    switch ([dict[@"order"] integerValue]) {
        
        case 0:{
            
            [self getMusicList:dict];
            
            
            [self getCurrentVolume];
            
            
        }break;
            
        case 15: {
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
            
                _volumeSlider.value = [dict[@"style"] intValue];
                
            });
             
            
            
        }break;
    }
    
    
    
}

- (void)getMusicList:(NSDictionary *)dict {
    
    NSArray *tempArray =  [self jsonToArrayOrdict:dict[@"style"]];
    

    
    //NSLog(@"当前线程=%@",[NSThread currentThread]);
    
    if(tempArray.count !=0){
        
        
        self.dataArray = [NSMutableArray array];
        
        NSMutableArray *localArray = [NSMutableArray arrayWithContentsOfFile:filePath];
        
        if(localArray == nil){
            
            localArray = [NSMutableArray array];
            
            for (int i=0; i<tempArray.count; i++) {
                
                NSData *nsdataFromBase64String = [[NSData alloc]
                                                  initWithBase64EncodedString:tempArray[i][@"songName"] options:0];
                
                
                NSString *base64Decoded = [[NSString alloc]
                                           initWithData:nsdataFromBase64String encoding:NSUTF8StringEncoding];
                
                [localArray addObject:base64Decoded];
                
                
            }

        }
        
        
        if(tempArray.count != 0){
            
             [localArray writeToFile:filePath atomically:YES];
            
        }
        
        
        
        for (int i=0; i<localArray.count; i++) {
            
            GGMusicModel *model = [[GGMusicModel alloc]init];
            
            model.songName = localArray[i];
            
            [self.dataArray addObject:model];
            
        }
        
        [self.tableView reloadData];
        
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        
        self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
   
        
        
        
        
       
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            [self.tableView reloadData];
            
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            
            self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            
            
        });
        
        
    }

}



#pragma mark UITableViewDelegate UITabelViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellID = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
        
    }
    
    cell.textLabel.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    GGMusicModel *model = self.dataArray[indexPath.row];
    
    cell.textLabel.text = model.songName;
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GGMusicModel *model = self.dataArray[indexPath.row];
    
    self.currentSong = model.songName;
    
    self.currentIndexPath = indexPath;
    
    if(_dataCenter.networkStateFlag == 0){
        
        
        NSData *plainData = [self.currentSong dataUsingEncoding:NSUTF8StringEncoding];
        
        NSString *base64String = [plainData base64EncodedStringWithOptions:0];
        
        NSDictionary *dict = @{@"order":@"2",@"songName":base64String,@"style":@"",@"wgid":_dataCenter.gatewayNo};
        
        [self.socketManager sendMsg:[self dictToJson:dict]];
        
        return;
        
        
        
    }
    
    
 
    NSDictionary *dict = @{
                           @"gatewayNo":_dataCenter.gatewayNo,
                           @"messsageType":@3,
                           @"object":@{
                                   
                                   @"songName" : self.currentSong,
                                   @"wgid" : _dataCenter.gatewayNo,
                                   @"order" : @"2"
                                   },
                           @"time":@0
                           
                           };
    
     [self songControParam:dict];

    
}


# pragma mark 布局UI

- (void)layoutUI{
    
    
#pragma 歌曲列表
    
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(kLeftRightPadding, kTopBottomPadding, kScreenWWidth*2/3, 50)];
    headerLabel.text = @"歌曲列表";
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:headerLabel];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(kLeftRightPadding, headerLabel.bottom, kScreenWWidth*2/3, self.frame.size.height-headerLabel.bottom-kTopBottomPadding)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
   
    
    [self addSubview:self.tableView];
    
    
#pragma  播放控制
    
    //控制按钮之间的间距
    float padding = 5;
    
    //播放按钮的宽高
    float playBtnWH = 40;
    
    //other按钮的宽高
    float otherBtnWH = 30;
    
    //头像的宽高
    float iconImageWH = kScreenWWidth*0.1;
    
    //头像
    float iconImageViewX = self.tableView.right + kLeftRightPadding + ((kScreenWWidth-self.tableView.right - kLeftRightPadding*2)/2-iconImageWH/2);
    
    UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(iconImageViewX, headerLabel.bottom-kLeftRightPadding, iconImageWH, iconImageWH)];
    iconImageView.image = [UIImage imageNamed:@"icon"];
    [self addSubview:iconImageView];
    
    //播放按钮
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [playBtn setBackgroundImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
    [playBtn setBackgroundImage:[UIImage imageNamed:@"stop"] forState:UIControlStateSelected];
    
    playBtn.frame = CGRectMake(iconImageView.center.x-playBtnWH/2, iconImageView.bottom+20, playBtnWH, playBtnWH);
    [playBtn addTarget:self action:@selector(playOrStopSong:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:playBtn];
    
    
    //上一曲
    UIButton *lastSongBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    lastSongBtn.frame = CGRectMake(playBtn.left-otherBtnWH-padding,playBtn.center.y-otherBtnWH/2, otherBtnWH, otherBtnWH);
    [lastSongBtn setBackgroundImage:[UIImage imageNamed:@"last"] forState:UIControlStateNormal];
    [self addSubview:lastSongBtn];
    [lastSongBtn addTarget:self action:@selector(lastSong) forControlEvents:UIControlEventTouchUpInside];
    
    //刷新
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshBtn.frame = CGRectMake(lastSongBtn.left-otherBtnWH-padding,playBtn.center.y-otherBtnWH/2, otherBtnWH, otherBtnWH);
    [refreshBtn addTarget:self action:@selector(refreshSong) forControlEvents:UIControlEventTouchUpInside];
    
    [refreshBtn setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [self addSubview:refreshBtn];
    
    //下一曲
    UIButton *nextSongBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    nextSongBtn.frame = CGRectMake(playBtn.right+padding,playBtn.center.y-otherBtnWH/2, otherBtnWH, otherBtnWH);
    [nextSongBtn addTarget:self action:@selector(nextSong) forControlEvents:UIControlEventTouchUpInside];

    [nextSongBtn setBackgroundImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [self addSubview:nextSongBtn];
    
    //随机播放
    UIButton *randmSongBtn = [UIButton buttonWithType:UIButtonTypeCustom];
   
    randmSongBtn.frame = CGRectMake(nextSongBtn.right+padding,playBtn.center.y-otherBtnWH/2, otherBtnWH, otherBtnWH);
    
   [randmSongBtn setBackgroundImage:[UIImage imageNamed:@"random"] forState:UIControlStateNormal];
    [self addSubview:randmSongBtn];
    [randmSongBtn addTarget:self action:@selector(randmSong) forControlEvents:UIControlEventTouchUpInside];

    
#pragma 进度条
    
    UIImageView *volumeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.tableView.right+kLeftRightPadding, self.tableView.bottom-kTopBottomPadding, otherBtnWH, otherBtnWH)];
    volumeImageView.image = [UIImage imageNamed:@"volume_large"];
    [self addSubview:volumeImageView];
    
    
     _volumeSlider = [[UISlider alloc]initWithFrame:CGRectMake(volumeImageView.right+padding, volumeImageView.center.y-otherBtnWH/2, kScreenWWidth-kLeftRightPadding-volumeImageView.right-padding, otherBtnWH)];
    [_volumeSlider addTarget:self action:@selector(volumeChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_volumeSlider];
    _volumeSlider.minimumValue = 0.0;
    _volumeSlider.maximumValue = 7.0;
    _volumeSlider.continuous = NO;
    
}


@end

