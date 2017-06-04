//
//  spaceDeviceCollectionViewCell.h
//  HomeCOO
//
//  Created by app on 16/8/16.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface spaceDeviceCollectionViewCell : UICollectionViewCell

@property(nonatomic ,strong) UIImageView *imgView;
@property(nonatomic ,strong) UILabel *messageLable;
//开关
@property(nonatomic ,strong) UIButton *button1;
@property(nonatomic ,strong) UIButton *button2;
@property(nonatomic ,strong) UIButton *button3;
@property(nonatomic ,strong) UIButton *button4;
//门窗
@property(nonatomic ,strong) UIButton *button5;
@property(nonatomic ,strong) UIButton *button6;
@property(nonatomic ,strong) UIButton *button7;
//插座
@property(nonatomic ,strong) UIButton *button8;
//调光
@property(nonatomic,strong)  UISlider *process;

//微控类
@property(nonatomic,strong)  UIButton  *button9;


@end
