//
//  CustomVC.m
//  IRBT
//
//  Created by wsz on 16/8/28.
//  Copyright © 2016年 wsz. All rights reserved.
//

#import "CustomVC.h"
#import "PrefixHeader.pch"
@interface CustomVC ()

@end

@implementation CustomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = Public_Background_Color;
}

- (void)onGoback
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
