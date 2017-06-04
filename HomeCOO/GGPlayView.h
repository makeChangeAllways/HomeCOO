//
//  PlayView.h
//  界面搭建
//
//  Created by 王立广 on 16/9/6.
//  Copyright © 2016年 GG. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kLeftRightPadding 10

#define kTopBottomPadding 20

#define kScreenWWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface GGPlayView : UIView


@property (nonatomic,strong) NSMutableArray *dataArray;


@end
