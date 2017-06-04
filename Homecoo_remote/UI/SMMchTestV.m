//
//  SMMchTestV.m
//  IRBT
//
//  Created by wsz on 16/10/9.
//  Copyright © 2016年 wsz. All rights reserved.
//

#import "SMMchTestV.h"
#import "PrefixHeader.pch"
#import "MainHomeVC.h"

@interface SMMchTestV ()
{
    NSInteger curType;
    UILabel *label;
}


@end
@implementation SMMchTestV

- (void)showWithDeviceType:(DeviceType)type
{
//    NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication] windows] reverseObjectEnumerator]; // 按照索引号从大到小访问数组的元素，而不是从小到大访问数组的元素，即逆序遍历数组。下面会做一个延伸阅读。
//    
//    UIWindow *showWindow = nil;
//    for (UIWindow *window in frontToBackWindows)// 从windows 数组里面获取application 的当前的Window
//    if (window.windowLevel == UIWindowLevelNormal)
//    {
//        
//        showWindow = window;
//      
//        break;
//    }
//
//    
    UIWindow *showWindow = [[[UIApplication  sharedApplication]windows]lastObject];
    showWindow.hidden = NO;
    
    [showWindow insertSubview:self atIndex:1];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(showWindow).insets(UIEdgeInsetsZero);
    }];
    
    [self layoutSubviewsWithType:type];
    
    
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0;
    [UIView animateWithDuration:.3 animations:^{
        self.alpha = 1.0;
    }];
}

- (void)layoutSubviewsWithType:(DeviceType)type
{
    curType = type;
    
    UIView *bgV = [[UIView alloc] init];
    bgV.backgroundColor = [UIColor whiteColor];
    bgV.layer.cornerRadius = 4.f;
    bgV.layer.masksToBounds = YES;
    [self addSubview:bgV];
    [bgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.mas_width).offset(-60);
        make.height.equalTo(self.mas_width);
        make.center.equalTo(self);
    }];
    
    label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    [bgV addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgV);
        make.centerX.equalTo(bgV);
    }];
    
    NSArray *array = @[@[@"开",@"关"],
                       @[@"开关",@"摇头"],
                       @[@"待机",@"声音+",@"声音-"],
                       @[@"电源",@"声音+",@"声音-"],
                       @[@"电源",@"声音+",@"声音-"],
                       @[@"电源",@"静音"],
                       @[@"开",@"温度+",@"温度－"],
                       @[@"开关",@"温度+",@"温度－"],
                       @[@"开关",@"自动"],
                       @[@"拍照"]];
    
    NSArray *group = array[type];

    
    float dis_H = (UI_SCREEN_WIDTH-30*2-60* group.count)/( group.count+1);
    for(int i=0;i<group.count;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"pub_btn_n"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"pub_btn_h"] forState:UIControlStateHighlighted];
        [btn setTitle:array[type][i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bgV addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 60));
            make.left.equalTo(bgV).with.offset(i*(60+dis_H)+dis_H);
            make.top.equalTo(bgV).with.offset(50);
        }];
        if(type==DeviceTypePJT)
        {
            btn.tag = i*2+1;
        }
        else if(type==DeviceTypeFan)
        {
            if(i==0)btn.tag = 1;
            if(i==1)btn.tag = 5;
        }
        else if(type==DeviceTypeTVBox)
        {
            if(i==0)btn.tag = 1;
            if(i==1)btn.tag = 37;
            if(i==2)btn.tag = 39;
        }
        else if(type==DeviceTypeTV)
        {
            if(i==0)btn.tag = 11;
            if(i==1)btn.tag = 9;
            if(i==2)btn.tag = 1;
        }
        else if(type==DeviceTypeIPTV)
        {
            if(i==0)btn.tag = 1;
            if(i==1)btn.tag = 5;
            if(i==2)btn.tag = 7;
        }
        else if(type==DeviceTypeDVD)
        {
            if(i==0)btn.tag = 11;
            if(i==1)btn.tag = 13;
        }
        else if(type==DeviceTypeARC)
        {
            if(i==0)btn.tag = 0x77;
            if(i==1)btn.tag = 0x06;
            if(i==2)btn.tag = 0x07;
        }
        else if(type==DeviceTypeWheater)
        {
            if(i==0)btn.tag = 1;
            if(i==1)btn.tag = 5;
            if(i==2)btn.tag = 7;
        }
        else if(type==DeviceTypeAir)
        {
            if(i==0)btn.tag = 1;
            if(i==1)btn.tag = 3;
        }
        else if(type==DeviceTypeSLR)
        {
            if(i==0)btn.tag = 1;
        }
    }
    
    UIButton *btn_exit = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_exit.backgroundColor = [UIColor darkGrayColor];
    [btn_exit setTitle:@"退出" forState:UIControlStateNormal];
    [btn_exit addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    [bgV addSubview:btn_exit];
    [btn_exit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgV);
        make.right.equalTo(bgV);
        make.height.equalTo(@40);
        make.bottom.equalTo(bgV).offset(-10);
    }];
    
    UIButton *btn_save = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_save.backgroundColor = [UIColor darkGrayColor];
    [btn_save addTarget:self action:@selector(saveBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [btn_save setTitle:@"保存" forState:UIControlStateNormal];
    [bgV addSubview:btn_save];
    [btn_save mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgV);
        make.right.equalTo(bgV);
        make.height.equalTo(@40);
        make.bottom.equalTo(btn_exit.mas_top).offset(-10);
    }];
    
    UIButton *btn_pre = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_pre.backgroundColor = [UIColor darkGrayColor];
    [btn_pre setTitle:@"上一组" forState:UIControlStateNormal];
    [btn_pre addTarget:self action:@selector(preBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [bgV addSubview:btn_pre];
    [btn_pre mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgV);
        make.right.equalTo(bgV);
        make.height.equalTo(@40);
        make.bottom.equalTo(btn_save.mas_top).offset(-10);
    }];
    
    UIButton *btn_next = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_next.backgroundColor = [UIColor darkGrayColor];
    [btn_next setTitle:@"下一组" forState:UIControlStateNormal];
    [btn_next addTarget:self action:@selector(nextBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [bgV addSubview:btn_next];
    [btn_next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgV);
        make.right.equalTo(bgV);
        make.height.equalTo(@40);
        make.bottom.equalTo(btn_pre.mas_top).offset(-10);
    }];
}
- (void)saveBtnClicked
{
    [self exit];
    if(self.ctrBtnClicked)
    {
        self.ctrBtnClicked(0);
    }
}

- (void)preBtnClicked
{
    if(self.ctrBtnClicked)
    {
        self.ctrBtnClicked(2);
    }
}

- (void)nextBtnClicked
{
    if(self.ctrBtnClicked)
    {
        self.ctrBtnClicked(1);
    }
}

- (void)btnClicked:(id)sender;
{
    if(self.testBtnClicked)
    {
        UIButton *btn = (UIButton *)sender;
        self.testBtnClicked(curType,btn.tag);
    }
}

- (void)exit
{
    [UIView animateWithDuration:.3 animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}

- (void)setLabelCur:(NSInteger)cnt totelCount:(NSInteger)totel
{
    label.text = [NSString stringWithFormat:@"当前第%ld/%ld组",(long)cnt+1,(long)totel];
}

@end
