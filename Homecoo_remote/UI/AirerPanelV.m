//
//  AirerPanelV.m
//  IRBT
//
//  Created by wsz on 16/8/28.
//  Copyright © 2016年 wsz. All rights reserved.
//

#import "AirerPanelV.h"
#import "PrefixHeader.pch"
#import "LZXDataCenter.h"
@implementation AirerPanelV

- (void)layoutIfNeeded
{
    [super layoutIfNeeded];
    
    NSArray *array = @[@"开关",
                       @"自动",
                       @"风量",
                       @"定时",
                       @"模式",
                       @"负离子",
                       @"舒适",
                       @"静音"];
    
    self.btnNameArray = array;
    
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
            
            if(i==0||i==1)
            {
                if(i==0)
                {
                    make.left.equalTo(self).offset(dis_h);
                }
                else
                {
                    make.left.equalTo(self).offset(dis_h+2*(60+dis_h));
                }
                make.bottom.equalTo(self.mas_centerY).offset(-dis_v-30);
            }
            else
            {
                make.left.equalTo(self).offset(dis_h+((i+1)%3)*(60+dis_h));
                int k = (i+1)/3;
                if(k==1)
                {
                    make.centerY.equalTo(self);
                }
                else if(k==2)
                {
                    make.top.equalTo(self.mas_centerY).offset(dis_v+30);
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
