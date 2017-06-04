//
//  MutiClickBtn.m
//  IRBT
//
//  Created by wsz on 16/9/28.
//  Copyright © 2016年 wsz. All rights reserved.
//

#import "MutiClickBtn.h"

@implementation MutiClickBtn

+ (instancetype)buttonWithType:(UIButtonType)buttonType
{
    UIButton * btn = [super buttonWithType:buttonType];
    return (MutiClickBtn *)btn;
}

- (void)addTarget:(id)target
 shortPressAction:(SEL)shortAction
  longPressAction:(SEL)longAction
 forControlEvents:(UIControlEvents)controlEvents
{
    [self addTarget:target action:shortAction forControlEvents:controlEvents];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:target
                                                                                            action:longAction];
    longPress.minimumPressDuration = 0.7;
    [self addGestureRecognizer:longPress];
}

- (void)defalutUI
{
    [self setBackgroundImage:[UIImage imageNamed:@"pub_btn_n"] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"pub_btn_h"] forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:15.f];
}

@end
