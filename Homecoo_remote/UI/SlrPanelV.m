//
//  SlrPanelV.m
//  IRBT
//
//  Created by wsz on 16/8/28.
//  Copyright © 2016年 wsz. All rights reserved.
//

#import "SlrPanelV.h"
#import "MutiClickBtn.h"
#import "View+MASAdditions.h"
@implementation SlrPanelV

- (void)layoutIfNeeded
{
    [super layoutIfNeeded];
    
    MutiClickBtn *btn = [MutiClickBtn buttonWithType:UIButtonTypeCustom];
    [btn defalutUI];
    [btn addTarget:self
  shortPressAction:@selector(btnClicked:)
   longPressAction:@selector(btnClicked:)
  forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"拍照" forState:UIControlStateNormal];
    [self addSubview:btn];
    btn.tag = 1;
  
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

- (void)btnClicked:(id)sender
{
    if(self.panelBtnClicked)
    {
        self.panelBtnClicked([self class],sender);
    }
}

@end
