//
//  alertViewModel.m
//  HomeCOO
//
//  Created by tgbus on 16/5/16.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "alertViewModel.h"

@implementation alertViewModel


-(id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...{
    
    self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    
    if (self != nil) {
        
        // 初始化自定义控件
        
        // createTextField函数用来初始化UITextField控件
        self.gatewayID = [self createTextField:@"网关ID"
                                  withFrame:CGRectMake(22, 45, 20, 20)];
        [self addSubview:self.gatewayID];
        
        self.gatewayIP = [self createTextField:@"网关IP"
                                     withFrame:CGRectMake(22, 90, 20, 20)];
        [self addSubview:self.gatewayIP];
        
        self.gatewayPwd =[self  createTextField:@"网关密码" withFrame:CGRectMake(22, 135, 20, 20)];
        
        [self addSubview:self.gatewayPwd];
    }
    
    return self;

}


-(UITextField *)createTextField:(NSString *)placeholder  withFrame:(CGRect)frame{

    UITextField  *textField = [[UITextField alloc ]initWithFrame:frame];
    
    textField.placeholder = placeholder;
    textField.backgroundColor = [UIColor  redColor];
    
    return textField;

}

- (void)layoutSubviews {
    [super layoutSubviews]; // 当override父类的方法时，要注意一下是否需要调用父类的该方法
    
    for (UIView* view in self.subviews) {
        
        // 搜索AlertView底部的按钮，然后将其位置下移
        
        if ([view isKindOfClass:[UIButton class]] ||
            [view isKindOfClass:NSClassFromString(@"UIThreePartButton")]) {
            CGRect btnBounds = view.frame;
            btnBounds.origin.y = self.gatewayPwd.frame.origin.y + self.gatewayPwd.frame.size.height + 7;
            view.frame = btnBounds;
        }
    }
    
    // 定义AlertView的大小
    CGRect bounds = self.frame;
    bounds.size.height = 260;
    self.frame = bounds;
}

@end
