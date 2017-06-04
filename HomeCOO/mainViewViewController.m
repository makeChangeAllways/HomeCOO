//
//  mainViewViewController.m
//  HomeCOO
//
//  Created by tgbus on 16/7/7.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "mainViewViewController.h"
#import "sockViewController.h"
#import "windowsViewController.h"
#import "microViewController.h"
#import "musicViewController.h"
#import "lightViewController.h"
#import "remoteViewController.h"
#import "PrefixHeader.pch"

@interface mainViewViewController ()<UITabBarControllerDelegate>


@end

@implementation mainViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UITabBarController *TabBarController = [[UITabBarController  alloc]init];
//    
//    TabBarController.delegate = self;
    
    //设置子控制器
    remoteViewController  *remote = [[remoteViewController  alloc]init];
    [self  addChildVc:remote title:@"遥控"];

    //remote.tabBarItem.title = @"遥控";
    
    lightViewController  *light = [[lightViewController  alloc]init];
    [self addChildVc:light title:@"照明"];

    //light.tabBarItem.title = @"照明";
    
    sockViewController  *sock = [[sockViewController  alloc]init];
    [self addChildVc:sock title:@"插座"];

    //sock.tabBarItem.title = @"插座";
    
    windowsViewController  *windows = [[windowsViewController  alloc]init];
    [self addChildVc:windows title:@"门窗"];
    
    //windows.tabBarItem.title = @"门窗";

    
    microViewController  *micro = [[microViewController  alloc]init];
    [self addChildVc:micro title:@"微控"];
    
    //micro.tabBarItem.title = @"微控";

    
    musicViewController  *music = [[musicViewController  alloc]init];
    [self addChildVc:music title:@"音乐"];
   // music.tabBarItem.title = @"音乐";
    
    //self.viewControllers = @[remote,light,sock,windows,micro,music];
    

}

-(void)addChildVc:(UIViewController *)childVc title:(NSString *)title
{
    
    childVc.title = title;
   
    //设置文字偏移位置
    childVc.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -13);//（水平、垂直）
    //设置普通状态下的文字属性
    NSMutableDictionary  *textAttrs = [NSMutableDictionary   dictionary ];
    
    textAttrs[NSForegroundColorAttributeName] =[UIColor  blackColor];
    textAttrs[NSFontAttributeName] =[UIFont  systemFontOfSize:15];
    [childVc.tabBarItem  setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    //选中时的文字属性
    NSMutableDictionary  *selectedTextAttrs = [NSMutableDictionary  dictionary];
    selectedTextAttrs[NSForegroundColorAttributeName] = [UIColor  orangeColor];
    [childVc.tabBarItem  setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
  
    //添加为子控制器
    
    [self  addChildViewController:childVc];
    
}

-(BOOL)shouldAutorotate{
    return YES;
}



-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}
@end
