//
//  BottomBar.h
//  2cu
//
//  Created by guojunyi on 14-4-11.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottomBar : UIView

@property (strong,nonatomic) NSMutableArray *items;
@property (strong,nonatomic) NSMutableArray *backViews;
@property (strong,nonatomic) NSMutableArray *iconViews;
@property (strong,nonatomic) NSMutableArray *labelViews;
@property (nonatomic) NSInteger selectedIndex;
-(void)updateItemIcon:(NSInteger)willSelectedIndex;

@property(nonatomic,strong)UIButton *red_point; // 消息模块的红点

@end
