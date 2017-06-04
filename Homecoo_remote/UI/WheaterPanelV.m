//
//  WheaterPanelV.m
//  IRBT
//
//  Created by wsz on 16/8/28.
//  Copyright © 2016年 wsz. All rights reserved.
//

#import "WheaterPanelV.h"
#import "PrefixHeader.pch"
#import "LZXDataCenter.h"
@implementation WheaterPanelV

- (void)layoutIfNeeded
{
    [super layoutIfNeeded];
    
    NSArray *array = @[@"开关",
                       @"设置",
                       @"温度＋",
                       @"温度－",
                       @"模式",
                       @"确定",
                       @"定时",
                       @"预约",
                       @"时间",
                       @"保温"];
    self.btnNameArray =array;
    CGFloat dis_h = (UI_SCREEN_WIDTH-60*3)/4;
    CGFloat dis_v = dis_h-20;
    
    for(int i=0;i<array.count;i++)
    {
        MutiClickBtn *btn = [MutiClickBtn buttonWithType:UIButtonTypeCustom];
        [btn defalutUI];
        [btn addTarget:self
      shortPressAction:@selector(btnClicked:)
       longPressAction:@selector(btnClicked:)
      forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [self addSubview:btn];
        btn.tag = i*2+1;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 60));
            
            if(i==0)
            {
                make.centerX.equalTo(self);
                make.bottom.equalTo(self.mas_centerY).offset(-1*(60+dis_v)-0.5*dis_v);
            }
            else
            {
                make.left.equalTo(self).offset(dis_h+((i+2)%3)*(60+dis_h));
                int k = (i+2)/3;
                
                if(k==1)
                {
                    make.bottom.equalTo(self.mas_centerY).offset(-0.5*dis_v);
                }
                else if(k==2)
                {
                    make.top.equalTo(self.mas_centerY).offset(0.5*dis_v);
                }
                else if(k==3)
                {
                    make.top.equalTo(self.mas_centerY).offset(1*(60+dis_v)+0.5*dis_v);
                }
            }
        }];
    }
}

- (void)btnClicked:(id)sender
{
    if(self.panelBtnClicked)
    {
        UIButton *btn = (UIButton *)sender;
        [LZXDataCenter defaultDataCenter].btnName = self.btnNameArray[(btn.tag-1)/2];
        self.panelBtnClicked([self class],sender);
    }
}

@end
