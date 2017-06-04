//
//  DVDPanelV.m
//  IRBT
//
//  Created by wsz on 16/9/28.
//  Copyright © 2016年 wsz. All rights reserved.
//

#import "DVDPanelV.h"
#import "PrefixHeader.pch"
#import "LZXDataCenter.h"

@implementation DVDPanelV

- (void)layoutIfNeeded
{
    [super layoutIfNeeded];
    
    NSArray *array = @[@"左",
                       @"上",
                       @"ok",
                       @"下",
                       @"右",
                       @"电源",
                       @"静音",
                       @"快倒",
                       @"播放",
                       @"快进",
                       @"上一曲",
                       @"停止",
                       @"下一曲",
                       @"制式",
                       @"暂停",
                       @"标题",
                       @"开关仓",
                       @"菜单",
                       @"返回"];
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
            
            if(i==0||i==1||i==2)
            {
                if(i==0)
                {
                    make.left.equalTo(self).offset(dis_h);
                }
                else if(i==1)
                {
                    make.centerX.equalTo(self);
                }
                else if(i==2)
                {
                    make.right.equalTo(self).offset(-dis_h);
                }
                make.bottom.equalTo(self.mas_centerY).offset(-1*(60+dis_v)-dis_v-30);
            }
            else
            {
                make.left.equalTo(self).offset(dis_h+((i+1)%4)*(60+dis_h));
                
                int k = (i+1)/4;
                if(k==1)
                {
                    make.bottom.equalTo(self.mas_centerY).offset(-dis_v-30);
                }
                else if(k==2)
                {
                    make.centerY.equalTo(self);
                }
                else if(k==3)
                {
                    make.top.equalTo(self.mas_centerY).offset(dis_v+30);
                }
                else if(k==4)
                {
                    make.top.equalTo(self.mas_centerY).offset(1*(60+dis_v)+dis_v+30);
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
