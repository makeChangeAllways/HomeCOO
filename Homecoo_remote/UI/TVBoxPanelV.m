//
//  TVBoxPanelV.m
//  IRBT
//
//  Created by wsz on 16/9/28.
//  Copyright © 2016年 wsz. All rights reserved.
//

#import "TVBoxPanelV.h"
#import "PrefixHeader.pch"
#import "LZXDataCenter.h"
@implementation TVBoxPanelV

- (void)layoutIfNeeded
{
    [super layoutIfNeeded];
    
    NSArray *array = @[@"待机",
                       @"1",
                       @"2",
                       @"3",
                       @"4",
                       @"5",
                       @"6",
                       @"7",
                       @"8",
                       @"9",
                       @"导视",
                       @"0",
                       @"返回",
                       @"上",
                       @"左",
                       @"确定",
                       @"右",
                       @"下",
                       @"声音＋",
                       @"声音－",
                       @"频道＋",
                       @"频道－",
                       @"菜单"];
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
                make.bottom.equalTo(self.mas_centerY).offset(-2*(60+dis_v)-0.5*dis_v);
            }
            else
            {
                make.left.equalTo(self).offset(dis_h+((i+1)%4)*(60+dis_h));
                
                int k = (i+1)/4;
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
