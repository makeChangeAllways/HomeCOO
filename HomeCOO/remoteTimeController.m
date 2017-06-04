//
//  remoteViewController.m
//  HomeCOO
//
//  Created by tgbus on 16/7/8.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "remoteTimeController.h"
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
#import "productCollectionViewCell.h"
#import "deviceMessage.h"
#import "deviceMessageTool.h"
#import "deviceSpaceMessageModel.h"
#import "deviceSpaceMessageTool.h"
#import "MBProgressHUD+MJ.h"
#import "spaceMessageModel.h"
#import "spaceMessageTool.h"
#import "MainHomeVC.h"
#import "CustomVC.h"
#import "scheduleRemoteController.h"
//底部空间、情景模式等按钮的高度
#define HOMECOOSPACEBUTTONHEIGHT 60

//底部空间、情景模式等按钮的宽度
#define HOMECOOSPACEBUTTONWIDTH [UIScreen  mainScreen].bounds.size.width / 5

//底部空间、情景模式等按钮Y的大小
#define  HOMECOOSPACEBUTTON_Y  [UIScreen  mainScreen].bounds.size.height - 55

//底部空间、情景模式等按钮字体的大小
#define HOMESPACEFONT 13

@interface remoteTimeController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

/**设置背景图片*/
@property(nonatomic,weak)  UIImageView  * fullscreenView;

/**设置导航栏*/
@property(nonatomic,weak)  UINavigationBar *navBar;


/**UICollectionView 容器*/
@property (strong, nonatomic)  UICollectionView *collectionView;

/**设备cell */
@property(nonatomic,strong) productCollectionViewCell *cell;


@end

@implementation remoteTimeController

static NSString *string = @"productCollectionViewCell";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //设置背景
    [self setFullscreenView];
    
    [self  setWhiteBackground];
   
    //添加aUICollectionView
    [self  addUICollectionView];
   
}


/**
 *  添加UICollectionView 来显示所有的照明设备
 */
-(void)addUICollectionView{
    
    CGFloat  collectionViewX = 10 ;
    CGFloat  collectionViewY = 60 ;
    CGFloat  collectionViewW = [UIScreen mainScreen].bounds.size.width - 20;
    CGFloat  collectionViewH = [UIScreen  mainScreen].bounds.size.height -130;
    //确定是水平滚动，还是垂直滚动
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    UICollectionView  *collectionView = [[UICollectionView  alloc]initWithFrame:CGRectMake(collectionViewX, collectionViewY, collectionViewW, collectionViewH) collectionViewLayout:flowLayout];
    
    collectionView.bounces = NO;//没有效果
    
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
    
    LZXDataCenter *dataCenter = [LZXDataCenter  defaultDataCenter];
    
    
    deviceMessage *device = [[deviceMessage alloc]init];
    
    device.GATEWAY_NO = dataCenter.gatewayNo;
    
    NSInteger  count;
    
    if ([dataCenter.gatewayNo isEqualToString:@"0"] | !dataCenter.gatewayNo ) {
        
        [MBProgressHUD  showError:@"请先添加主机"];
        
    }else{
        
        deviceMessage *devicess = [[deviceMessage  alloc]init];
        devicess.GATEWAY_NO = dataCenter.gatewayNo;
        
        count = [deviceMessageTool queryWithRemoteDevices:devicess].count;
        
    }
    
    [MBProgressHUD  hideHUD];
    
    
    
    return  count;
    
}


//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    _cell = [collectionView dequeueReusableCellWithReuseIdentifier:string forIndexPath:indexPath];
    
    LZXDataCenter *dataCenter = [LZXDataCenter defaultDataCenter];
    
    deviceMessage *devicess = [[deviceMessage alloc]init];
    devicess.GATEWAY_NO = dataCenter.gatewayNo;
    
    deviceMessage  *device = [deviceMessageTool queryWithRemoteDevices:devicess][indexPath.row];
    
    deviceSpaceMessageModel *deviceSpace = [[deviceSpaceMessageModel alloc]init];
    
    deviceSpace.device_no = device.DEVICE_NO;
    deviceSpace.phone_num = dataCenter.userPhoneNum;
    
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
        _cell.deviceMessageLable.text =[NSString  stringWithFormat:@"  %@/%@",deviceName.space_Name,device_Name.device_name];
        
        
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
    
    NSInteger  indexNum =indexPathAll.row;
    
    LZXDataCenter *dataCenter = [LZXDataCenter defaultDataCenter];
    
    deviceMessage *devicess = [[deviceMessage alloc]init];
    devicess.GATEWAY_NO = dataCenter.gatewayNo;
    
    deviceMessage *device = [deviceMessageTool queryWithRemoteDevices:devicess][indexNum];
    
    dataCenter.remoteIEEAddress = device.DEVICE_NO;
   
    scheduleRemoteController *nextVc = [[scheduleRemoteController alloc]init];
    [self  presentViewController:nextVc animated:YES completion:nil];
    
    
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
    
    //WhiteBackgroundLable.clipsToBounds = YES;
    //WhiteBackgroundLable.layer.cornerRadius = 8.0;//设置边框圆角
    
    
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
-(BOOL)shouldAutorotate{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskLandscape;
    
}
@end