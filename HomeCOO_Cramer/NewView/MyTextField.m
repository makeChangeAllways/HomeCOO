//
//  MyTextField.m
//  2cu
//
//  Created by mac on 15/10/15.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//

#import "MyTextField.h"

@implementation MyTextField

//控制文本所在的的位置，左右缩 10
- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 10, 0);
}

//控制编辑文本时所在的位置，左右缩 10
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 10, 0);
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.tintColor=SysNavColor;
        self.layer.cornerRadius=2.0;
    }
    
    return self;
}


@end
