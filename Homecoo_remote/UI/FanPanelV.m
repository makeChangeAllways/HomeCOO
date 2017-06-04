//
//  FanPanelV.m
//  IRBT
//
//  Created by wsz on 16/8/28.
//  Copyright © 2016年 wsz. All rights reserved.
//

#import "FanPanelV.h"
#import "PrefixHeader.pch"
#import "LZXDataCenter.h"
@implementation FanPanelV

- (void)layoutIfNeeded
{
    [super layoutIfNeeded];
    
    NSArray *array = @[@"开关",
                       @"风速",
                       @"摇头",
                       @"风类",
                       @"定时",
                       @"灯光",
                       @"负离子",
                       @"1",
                       @"2",
                       @"3",
                       @"4",
                       @"5",
                       @"6",
                       @"7",
                       @"8",
                       @"9",
                       @"睡眠",
                       @"制冷",
                       @"风量",
                       @"低速",
                       @"中速",
                       @"高速",];
    self.btnNameArray =array;
    CGFloat dis_h = (UI_SCREEN_WIDTH-60*4)/5;
    CGFloat dis_v = dis_h-10;
    
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
            
            if(i==0||i==1)
            {
                if(i==0)
                {
                    make.left.equalTo(self).offset(dis_h);
                }
                else if(i==1)
                {
                    make.left.equalTo(self).offset(dis_h+3*(60+dis_h));
                }
                make.bottom.equalTo(self.mas_centerY).offset(-2*(60+dis_v)-0.5*dis_v);
            }
            else
            {
                make.left.equalTo(self).offset(dis_h+((i-2)%4)*(60+dis_h));
                
                int k = (i+2)/4;
                if(k==1)
                {
                    make.bottom.equalTo(self.mas_centerY).offset(-1*(60+dis_v)-0.5*dis_v);
                }
                else if(k==2)
                {
                    make.bottom.equalTo(self.mas_centerY).offset(-0.5*dis_v);
                }
                else if(k==3)
                {
                    make.top.equalTo(self.mas_centerY).offset(0.5*dis_v);
                }
                else if(k==4)
                {
                    make.top.equalTo(self.mas_centerY).offset(1*(60+dis_v)+0.5*dis_v);
                }
                else if(k==5)
                {
                    make.top.equalTo(self.mas_centerY).offset(2*(60+dis_v)+0.5*dis_v);
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
