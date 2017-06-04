//
//  scheduleCollectionViewCell.h
//  HomeCOO
//
//  Created by app on 2016/11/22.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface scheduleCollectionViewCell : UICollectionViewCell

@property(nonatomic ,strong)UIImageView *imgView;
//downset
@property(nonatomic ,strong) UIButton *buttonTag;

@property(nonatomic ,strong)UILabel *alarmMessageLable;

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


@end
