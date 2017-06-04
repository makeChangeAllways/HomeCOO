//
//  MutiClickBtn.h
//  IRBT
//
//  Created by wsz on 16/9/28.
//  Copyright © 2016年 wsz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MutiClickBtn : UIButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType;

- (void)addTarget:(id)target
 shortPressAction:(SEL)shortAction
  longPressAction:(SEL)longAction
 forControlEvents:(UIControlEvents)controlEvents;

- (void)defalutUI;

@end
