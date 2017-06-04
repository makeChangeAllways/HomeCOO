//
//  BaseViewController.m
//  2cu
//
//  Created by mac on 15/10/19.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//

#import "BaseViewController.h"
#import "MainController.h"
#import "AppDelegate.h"
#import "PrefixHeader.pch"
@implementation BaseViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self set_UI];
}


#pragma mark --- UI
- (void)set_UI
{
    // 顶部导航框
    TopBar *topBar = [[TopBar alloc] initWithFrame:CGRectMake(0, 0, VIEWWIDTH, NAVIGATION_BAR_HEIGHT)];
    [self.view addSubview:topBar];
    self.topBar = topBar;
    
    // 返回按钮
    [self.topBar.backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.topBar setBackButtonHidden:NO];
    [self.topBar setHidden:NO];
    MainController *mainController = [AppDelegate sharedDefault].mainController;
    
    [mainController setBottomBarHidden:YES];

}

// 返回操作
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}


@end
