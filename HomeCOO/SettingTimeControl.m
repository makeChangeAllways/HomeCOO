//
//  UnscrollTabController.m
//  YPTabBarController
//
//  Created by 喻平 on 16/5/25.
//  Copyright © 2016年 YPTabBarController. All rights reserved.
//

#import "SettingTimeControl.h"
#import "sockTimeController.h"
#import "windowsTimeController.h"
#import "microTimeController.h"
#import "musicTimeController.h"
#import "lightTimeController.h"
#import "remoteTimeController.h"
#import "ThemeTimeController.h"
#import "PrefixHeader.pch"
@interface SettingTimeControl ()

@property(nonatomic,weak)  UIImageView  *fullscreenView;

@end

@implementation SettingTimeControl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建一个导航栏
    [self setNavBar];
    
    //初始化子控制器
    [self initViewControllers];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.contentViewFrame = CGRectMake(0, 0, screenSize.width, screenSize.height - 44 );//screenSize.height - 64 - 50
    self.tabBar.frame = CGRectMake(0, screenSize.height-54, screenSize.width, 54);
    self.tabBar.backgroundColor =  [UIColor colorWithRed:229/255.0 green:237/255.0 blue:234/255.0 alpha:1];
    
    self.tabBar.itemTitleColor = [UIColor blackColor];
    self.tabBar.itemTitleSelectedColor = [UIColor orangeColor];
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:18];
    
    [self setContentScrollEnabledAndTapSwitchAnimated:YES];
    self.tabBar.itemSelectedBgScrollFollowContent = YES;
    self.tabBar.itemColorChangeFollowContentScroll = NO;
    
    //self.tabBar.itemSelectedBgColor = [UIColor redColor];
    
    [self.tabBar setItemSelectedBgInsets:UIEdgeInsetsZero tapSwitchAnimated:YES];
    
  
}
/**
 *设置导航栏
 */
-(void)setNavBar{
    
    CGFloat navBarW = [UIScreen  mainScreen].bounds.size.width;
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0,navBarW, 40)];
    
    //创建一个导航栏集合
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"定时设置"];
    
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
/**返回到上一个systemView*/
-(void)backAction{
    
    [self  dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)initViewControllers {
  
    ThemeTimeController *controller1 = [[ThemeTimeController alloc] init];
    controller1.yp_tabItemTitle = @"情景";
    
    
    remoteTimeController *controller2 = [[remoteTimeController alloc] init];
    controller2.yp_tabItemTitle = @"遥控";
    
    lightTimeController *controller3 = [[lightTimeController alloc] init];
    controller3.yp_tabItemTitle = @"照明";
    
    sockTimeController *controller4 = [[sockTimeController alloc] init];
    controller4.yp_tabItemTitle = @"插座";
    
    windowsTimeController *controller5 = [[windowsTimeController alloc] init];
    controller5.yp_tabItemTitle = @"门窗";
    
    microTimeController *controller6 = [[microTimeController alloc] init];
    controller6.yp_tabItemTitle = @"微控";
    
    musicTimeController *controller7 = [[musicTimeController alloc] init];
    controller7.yp_tabItemTitle = @"音乐";
    
    self.viewControllers = [NSMutableArray arrayWithObjects:controller1, controller2, controller3, controller4, controller5, controller6,controller7, nil];
    
  
    
}
-(BOOL)shouldAutorotate{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskLandscape;
    
}
@end
