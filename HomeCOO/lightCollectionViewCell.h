//
//  lightCollectionViewCell.h
//  HomeCOO
//
//  Created by tgbus on 16/5/18.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDB.h"



@interface lightCollectionViewCell : UICollectionViewCell

@property(nonatomic ,strong) UIImageView *imgView;
@property(nonatomic ,strong) UILabel *messageLable;
@property(nonatomic ,strong) UIButton *button1;
@property(nonatomic ,strong) UIButton *button2;
@property(nonatomic ,strong) UIButton *button3;
@property(nonatomic ,strong) UIButton *button4;

@property(nonatomic,strong)  UISlider *process;

@end
