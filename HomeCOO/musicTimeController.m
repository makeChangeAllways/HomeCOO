//
//  musicViewController.m
//  HomeCOO
//
//  Created by tgbus on 16/7/8.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "musicTimeController.h"
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
#import "HCDaterView.h"
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
#import "scheduleMusicTaskController.h"

//底部空间、情景模式等按钮的高度
#define HOMECOOSPACEBUTTONHEIGHT 60

//底部空间、情景模式等按钮的宽度
#define HOMECOOSPACEBUTTONWIDTH [UIScreen  mainScreen].bounds.size.width / 5

//底部空间、情景模式等按钮Y的大小
#define  HOMECOOSPACEBUTTON_Y  [UIScreen  mainScreen].bounds.size.height - 55

//底部空间、情景模式等按钮字体的大小
#define HOMESPACEFONT 13

@interface musicTimeController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HCDaterViewDelegate>

@property (nonatomic,strong) HCDaterView *selectedView;
/**设置背景图片*/
@property(nonatomic,weak)  UIImageView  * fullscreenView;

/**设置导航栏*/
@property(nonatomic,weak)  UINavigationBar *navBar;

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,copy) NSString *currentSongName;

@property(nonatomic,strong) LZXDataCenter *dataCenter;

@property  NSInteger index;
@end

@implementation musicTimeController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //设置背景
    [self setFullscreenView];
    
    LZXDataCenter *dataCenter = [LZXDataCenter defaultDataCenter];
    
    self.dataCenter = dataCenter;
    
    //设置背景底色
    [self  setWhiteBackground];
    
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
    self.dataArray = [NSMutableArray array];
    
    AFHTTPSessionManagers *session = [[AFHTTPSessionManagers alloc]init];
    
    
    NSString *url = [HomecooServiceURL stringByAppendingString:@"/appGetMusic"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
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
    
    NSArray *tempArray = @[@"播放音乐",@"暂停音乐"];
    
    self.selectedView.titleArray = tempArray;

    self.selectedView.title = @"音乐定时设置";
    
    [self.selectedView showInView:self.view animated:YES];
    
    GGMusicModel *model = self.dataArray[indexPath.row];
    
    self.currentSongName = model.songName;
    _dataCenter.songName = model.songName;
}

- (void)daterViewClicked:(HCDaterView *)daterView{
    
    scheduleMusicTaskController  *nextVc = [[scheduleMusicTaskController  alloc]init];
  
    switch (daterView.currentIndexPath.row) {
            
        case 0:
           
            _dataCenter.musicType =0;
            [self.selectedView  hiddenInView:self.view animated:YES];
           
            [self  presentViewController:nextVc animated:YES completion:nil];
            break;
        case 1:
            
             _dataCenter.musicType =1;
            [self.selectedView  hiddenInView:self.view animated:YES];
            
            [self  presentViewController:nextVc animated:YES completion:nil];
            break;
            
        }
}


- (HCDaterView *)selectedView{
    
    if(_selectedView == nil){
        
        _selectedView = [[HCDaterView alloc]initWithFrame:CGRectZero];
        _selectedView.sureBtn.hidden = YES;
        _selectedView.cancleBtn.hidden = YES;
        _selectedView.delegate = self;
    }
    
    return _selectedView;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.selectedView  hiddenInView:self.view animated:YES];

}

/**返回到上一个systemView*/
-(void)backAction{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
@end
