//
//  TVPanelV.m
//  IRBT
//
//  Created by wsz on 16/9/28.
//  Copyright © 2016年 wsz. All rights reserved.
//

#import "TVPanelV.h"
#import "PrefixHeader.pch"
#import "LZXDataCenter.h"
@implementation TVPanelV

- (void)layoutIfNeeded
{
    [super layoutIfNeeded];
    
    NSArray *array = @[@"声音-",
                       @"频道＋",
                       @"菜单",
                       @"频道－",
                       @"声音+",
                       @"电源",
                       @"静音",
                       @"1",
                       @"2",
                       @"3",
                       @"4",
                       @"5",
                       @"6",
                       @"7",
                       @"8",
                       @"9",
                       @"--/-",
                       @"0",
                       @"AV/TV",
                       @"返回",
                       @"确定",
                       @"上",
                       @"左",
                       @"右",
                       @"下"];
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
            
            if(i==0)
            {
                if(i==0)
                {
                    make.centerX.equalTo(self);
                }
                make.bottom.equalTo(self.mas_centerY).offset(-2*(60+dis_v)-1*dis_v-30);
            }
            else
            {
                make.left.equalTo(self).offset(dis_h+((i+3)%4)*(60+dis_h));
                
                int k = (i+3)/4;
                if(k==1)
                {
                    make.bottom.equalTo(self.mas_centerY).offset(-1*(60+dis_v)-1*dis_v-30);
                }
                else if(k==2)
                {
                    make.bottom.equalTo(self.mas_centerY).offset(-1*dis_v-30);
                }
                else if(k==3)
                {
                    make.centerY.equalTo(self);
                }
                else if(k==4)
                {
                    make.top.equalTo(self.mas_centerY).offset(1*dis_v+30);
                }
                else if(k==5)
                {
                    make.top.equalTo(self.mas_centerY).offset(1*(60+dis_v)+1*dis_v+30);
                }
                else if(k==6)
                {
                    make.top.equalTo(self.mas_centerY).offset(2*(60+dis_v)+1*dis_v+30);
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
