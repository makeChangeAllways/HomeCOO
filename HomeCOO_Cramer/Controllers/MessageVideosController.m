//
//  MessageVideosController.m
//  2cu
//
//  Created by mac on 15/10/27.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//  

#import "MessageVideosController.h"
#import "Alarm.h"
#import "CollectionVideoItem.h"
#import "Utils.h"
#import "P2PPlaybackController.h"
#import "P2PPlayingbackController.h"
#import "PrefixHeader.pch"
#define SEARCH_BAR_HEIGHT 36
#define TOP_INFO_BAR_HEIGHT 80
#define PLAYBACK_LIST_ITEM_HEIGHT 40
#define TOP_HEAD_MARGIN 10
#define PROGRESS_WIDTH_AND_HEIGHT 58
#define ANIM_VIEW_WIDTH_AND_HEIGHT 80

static NSString *collecionView_id = @"collection_video";  // collectionView 标示
@interface MessageVideosController ()<UICollectionViewDataSource,UICollectionViewDelegate,P2PPlaybackDelegate>

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *collectionArray; //collection显示数组

@property(strong, nonatomic) UIView *movieView;  // animtaionView

@property(nonatomic,strong)UIImage *headImg;  // 每个设备对应的一张图片/ 设计就是这样
//@property(nonatomic,strong)Contact *First_contact; // 默认的设备模型
@end

@implementation MessageVideosController


#pragma mark - 懒加载
- (NSMutableArray *)collectionArray
{
    if (_collectionArray == nil) {
        _collectionArray = [NSMutableArray array];
    }
    return _collectionArray;
}



#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self Notification];
    
    [self UI_init];
    [self DATA_init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)Notification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRemoteMessage:) name:RECEIVE_REMOTE_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ack_receiveRemoteMessage:) name:ACK_RECEIVE_REMOTE_MESSAGE object:nil];
    
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[P2PClient sharedClient] setPlaybackDelegate:self];
}


-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RECEIVE_REMOTE_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ACK_RECEIVE_REMOTE_MESSAGE object:nil];
    
}



#pragma mark --- UI
- (void)UI_init
{
    
    // base item
    self.topBar.titleLabel.text = [NSString stringWithFormat:@"%@-%@",NSLocalizedString(@"alarm_record", nil),self.contact.contactName];
    
    // collectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat collec_margin = 10;
    CGFloat size_w = (VIEWWIDTH - 4*collec_margin)/3;
    CGFloat size_h = 80;
    CGSize item_size = CGSizeMake(size_w, size_h);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.itemSize =item_size;
    
    
    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectMake(collec_margin, BottomForView(self.topBar) + 10, VIEWWIDTH - 2*collec_margin, VIEWHEIGHT - BottomForView(self.topBar) - 10) collectionViewLayout:layout];
    
//    collection.backgroundColor = [UIColor blackColor];
    
    //    collection.userInteractionEnabled = NO;
    collection.backgroundColor = [UIColor clearColor];
    self.collectionView = collection;
    [self.view addSubview:collection];
    //    collection.hidden = YES;
    collection.dataSource = self;
    collection.delegate = self;
    [collection registerNib:[UINib nibWithNibName:@"CollectionVideoItem" bundle:nil] forCellWithReuseIdentifier:collecionView_id];  // 注册
    
    
    
    // animationView
    UIView *movieView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height-NAVIGATION_BAR_HEIGHT)];
    [movieView setBackgroundColor:XBlack_128];
    UIImageView *animView = [[UIImageView alloc] initWithFrame:CGRectMake((movieView.frame.size.width-ANIM_VIEW_WIDTH_AND_HEIGHT)/2, (movieView.frame.size.height-ANIM_VIEW_WIDTH_AND_HEIGHT)/2, ANIM_VIEW_WIDTH_AND_HEIGHT, ANIM_VIEW_WIDTH_AND_HEIGHT)];
    
    NSArray *imagesArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"movie1.png"],[UIImage imageNamed:@"movie2.png"],[UIImage imageNamed:@"movie3.png"],nil];
    
    animView.animationImages = imagesArray;
    animView.animationDuration = ((CGFloat)[imagesArray count])*100.0f/1000.0f;
    animView.animationRepeatCount = 0;
    [animView startAnimating];
    
    [movieView addSubview:animView];
//    [animView release];
    [movieView setHidden:YES];
    [self.view addSubview:movieView];
    self.movieView = movieView;
    
    
}
#pragma mark --- DATA
-(void)DATA_init
{
    // 图片
    NSString *filePath = [Utils getHeaderFilePathWithId:self.contact.contactId];
    
    UIImage *headImg = [UIImage imageWithContentsOfFile:filePath];
    if(headImg==nil){
        headImg = [UIImage imageNamed:@"bgImageBig.jpg"];
    }
    self.headImg = headImg;
    
    
    if (self.contact.onLineState == STATE_ONLINE ) {
        
        NSLog(@"%@",self.alarm.alarmTime);
        
        NSString *time = [Utils convertTimeByInterval:self.alarm.alarmTime];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [formatter dateFromString:time];
        
        NSDate *pre_date = [NSDate dateWithTimeInterval:- 60 * 60 sinceDate:date];
        NSDate *now_date = [NSDate dateWithTimeInterval: 60 * 60 sinceDate:date];
        
        [[P2PClient sharedClient] getPlaybackFilesWithIdByDate:self.contact.contactId password:self.contact.contactPassword startDate:pre_date endDate:now_date];
        
    }else
    {
//        ALERTSHOW(NSLocalizedString(@"提示", nil), NSLocalizedString(@"id_offline", nil));
    }

    
    
}






#pragma mark - collectionView dataResource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  self.collectionArray.count ? self.collectionArray.count : 0;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionVideoItem *collection_cell = [collectionView dequeueReusableCellWithReuseIdentifier:collecionView_id forIndexPath:indexPath];
    
    NSString *time_str = [self.collectionArray objectAtIndex:indexPath.row];
    
    
    collection_cell.headImg = self.headImg;
    collection_cell.no_sub = @"nomeans";
    collection_cell.time_str = time_str;
    
    //    collection_cell.contact_id =
    return collection_cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.movieView setHidden:NO];
    self.movieView.alpha = 0.3;
    
    [UIView transitionWithView:self.movieView duration:0.3 options:UIViewAnimationCurveEaseOut
                    animations:^{
                        self.movieView.alpha = 1.0;
                    }
     
                    completion:^(BOOL finished){
                        
                    }
     ];
    [[P2PClient sharedClient] p2pPlaybackCallWithId:self.contact.contactId password:self.contact.contactPassword index:indexPath.row];
}



#pragma mark - p2pClient


- (void)receiveRemoteMessage:(NSNotification *)notification{
    NSDictionary *parameter = [notification userInfo];
    int key   = [[parameter valueForKey:@"key"] intValue];
    switch(key){
        case RET_GET_PLAYBACK_FILES: // 接收 日期消息
        {
            
            NSArray *array = [NSArray arrayWithArray:(NSArray*)[parameter valueForKey:@"files"]];
            NSArray *times = [NSArray arrayWithArray:(NSArray*)[parameter valueForKey:@"times"]];
//            [self.dateArray removeAllObjects];
//            [self.dateArray addObjectsFromArray:times];
            
            NSMutableArray *temArr = [NSMutableArray array];
            
            
            for (NSString *time in times) {
                NSString *sub_time = [time substringFromIndex:11];
                [temArr addObject:sub_time];
                
            }
            self.collectionArray = [NSMutableArray array];
            self.collectionArray = temArr;
            
//            NSLog(@"%@",self.collectionArray);
            
//            NSLog(@"%@",self.collectionView);
            
//            __unsafe_unretained MessageVideosController *wself = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.collectionArray.count) {
                    [self.collectionView reloadData];
                }else
                {
                    ALERTSHOW(NSLocalizedString(@"提示", nil), NSLocalizedString(@"no_record", nil));
                }
            
            });
            
           
            
//            for (NSString *timeStr in times) {  // for
//                
//                NSString *sub_time = [timeStr substringToIndex:10];
//                
//                if (temArr.count) { // count
//                    
//                    if (![temArr.lastObject isEqualToString:sub_time]) { // !is_equal
//                        [temArr addObject:sub_time];
//                    }
//                }else
//                {
//                    [temArr addObject:sub_time];
//                }  // count
//                
//            }// for
//            
//            
//            NSMutableArray *total_ARR = [NSMutableArray array]; // 总的数组
//            
//            
//            
//            for (int index = 0; index < temArr.count; index ++) {
//                
//                NSString *sub_str = [temArr objectAtIndex:index];
//                // 创建一个小数组
//                NSMutableArray *sub_Array = [NSMutableArray array]; // 小数组
//                for (NSString *str in times) {
//                    if ([str hasPrefix:sub_str]) {
//                        [sub_Array addObject:str];
//                    }
//                }
//                
//                [total_ARR addObject:sub_Array];
//                
//            }
//            
//            NSLog(@"%@",total_ARR);
////            self.total_Array = total_ARR;
//            
//            
//            NSLog(@"%@",temArr);
//            [self setDateView:temArr]; // 日期View
            
        }
    }
}


// 判断发送请求是否成功
- (void)ack_receiveRemoteMessage:(NSNotification *)notification{
    NSDictionary *parameter = [notification userInfo];
    int key   = [[parameter valueForKey:@"key"] intValue];
    int result   = [[parameter valueForKey:@"result"] intValue];
    switch(key){
        case ACK_RET_GET_PLAYBACK_FILES:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                //                [UIView transitionWithView:self.searchMaskView duration:0.3 options:UIViewAnimationCurveEaseOut
                //                                animations:^{
                //                                    self.searchMaskView.alpha = 0.3;
                //                                }
                //
                //                                completion:^(BOOL finished){
                //                                    [self.searchMaskView setHidden:YES];
                //                                }
                //                 ];
                if(result==1){
//                    [self.view makeToast:NSLocalizedString(@"device_password_error", nil)];
                    ALERTSHOW(NSLocalizedString(@"提示", nil),NSLocalizedString(@"device_password_error", nil));
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        usleep(800000);
                        dispatch_async(dispatch_get_main_queue(), ^{
 
                        });
                    });
                }else if(result==2){
                    ALERTSHOW(NSLocalizedString(@"提示", nil),NSLocalizedString(@"net_exception", nil));
//                    [self.view makeToast:NSLocalizedString(@"net_exception", nil)];
                }
                
                
            });
            
            
            
            
            
            DLog(@"ACK_RET_GET_PLAYBACK_FILES:%i",result);
        }
            break;
    }
    
}


#pragma mark - p2pPlay delegate
// P2PPlaybackReady
-(void)P2PPlaybackReady:(NSDictionary *)info{
    DLog(@"P2PPlaybackReady");
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView transitionWithView:self.movieView duration:0.3 options:UIViewAnimationCurveEaseOut
                        animations:^{
                            self.movieView.alpha = 0.3;
                        }
         
                        completion:^(BOOL finished){
                            [self.movieView setHidden:YES];
                            P2PPlayingbackController *playingbackController = [[P2PPlayingbackController alloc] init];
                            [self presentViewController:playingbackController animated:YES completion:nil];
//                            [playingbackController release];
                        }
         ];
    });
}

-(void)P2PPlaybackReject:(NSDictionary *)info{
    DLog(@"P2PPlaybackReject");
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView transitionWithView:self.movieView duration:0.3 options:UIViewAnimationCurveEaseOut
                        animations:^{
                            self.movieView.alpha = 0.3;
                        }
         
                        completion:^(BOOL finished){
                            [self.movieView setHidden:YES];
//                            [self.view makeToast:[info objectForKey:@"rejectMsg"]];
                        }
         ];
    });
}


// 支持设备自动旋转
- (BOOL)shouldAutorotate
{
    return NO;
}

// 支持横竖屏显示
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
@end
