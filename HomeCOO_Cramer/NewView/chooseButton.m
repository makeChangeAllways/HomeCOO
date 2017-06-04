//
//  chooseButton.m
//  2cu
//
//  Created by mac on 15/10/21.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//

#import "chooseButton.h"
#import "PrefixHeader.pch"
@implementation chooseButton

- (instancetype)init
{
    if (self = [super init]) {
        
        UIView *LineView = [[UIView alloc] init];
        LineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:LineView];
        LineView.frame = CGRectMake(2, 39, (VIEWWIDTH - 60)/2 - 4 ,  0.5);
        
        
        self.imageView.contentMode =  UIViewContentModeScaleAspectFit ;
        
    }
    return self;
}


- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat img_W = 20;
    CGFloat img_H = 20;
    CGFloat img_X = contentRect.size.width - 30;
    CGFloat img_Y = 10;
    CGRect img_R = CGRectMake(img_X, img_Y, img_W, img_H);
    return img_R;
}


- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat title_X = 10;
    CGFloat title_Y = 10;
    CGFloat title_H = 20;
    CGFloat title_W = contentRect.size.width - 30 - 10;
    CGRect title_R = CGRectMake(title_X, title_Y, title_W, title_H);
    return title_R;
}



@end
