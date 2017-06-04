//
//  chooseListView.h
//  2cu
//
//  Created by mac on 15/10/21.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickBlock)(int row);

@interface chooseListView : UIScrollView

@property(nonatomic,strong)NSArray *ListArrayData; // 数据数组

@property(nonatomic,strong)NSArray *DateArray; // 时间字符串数组


@property(nonatomic,strong)clickBlock clikcBlk; // 回调点击哪个按钮 传递tag

@property(nonatomic,strong)NSMutableArray *dateArray_temp;

- (void)updateContacts:(NSArray *)contacts; // 更新 contactsList


@property(nonatomic,strong)NSMutableArray *contactBtns;

@end
