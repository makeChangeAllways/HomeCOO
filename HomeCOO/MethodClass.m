//
//  MethodClass.m
//  HomeCOO
//
//  Created by tgbus on 16/5/5.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//
#import "MethodClass.h"

@implementation MethodClass

/**
 *抽取底部按钮共同的方法
 */
+(void)setButton:(UIButton *)button   setNormalImage:(NSString *)normalimage  setHighlightedImage:(NSString *) highlightedImage setNormalTitle:(NSString *)normaltitle setHightedTitle:(NSString *) highlightedtitle{
    
    [button  setImage:[UIImage  imageNamed:normalimage] forState:UIControlStateNormal];
    [button  setImage:[UIImage  imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    [button  setTitle:normaltitle forState:UIControlStateNormal];
    [button  setTitleColor:[UIColor  blackColor] forState:UIControlStateNormal];
    [button  setTitle:highlightedtitle forState:UIControlStateHighlighted];
    [button  setTitleColor:[UIColor  colorWithRed:0.29 green:0.57 blue:0.53 alpha:1.0] forState:UIControlStateHighlighted];
    //[button  setFont:[UIFont  systemFontOfSize:13]];
    button.titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:15];
    [button  setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    
}

/**
 *抽取主系统子控件方法
 */

+(void)setButton:(UIButton *)button setNormalImage:(NSString *)normalimage setHighlightedImage:(NSString *)highlightedImage{
    
    [button  setImage:[UIImage  imageNamed:normalimage] forState:UIControlStateNormal];
    [button  setImage:[UIImage  imageNamed:highlightedImage] forState:UIControlStateHighlighted];

}
//
+(void)setButton:(UIButton *)button   setNormalImage:(NSString *)normalimage  setSelectedImage:(NSString *) selectedImage setNormalTitle:(NSString *)normaltitle setSelectedTitle:(NSString *) selectedtitle{
    
    [button  setImage:[UIImage  imageNamed:normalimage] forState:UIControlStateNormal];
    [button  setImage:[UIImage  imageNamed:selectedImage] forState:UIControlStateSelected];
    [button  setTitle:normaltitle forState:UIControlStateNormal];
    [button  setTitleColor:[UIColor  blackColor] forState:UIControlStateNormal];
    [button  setTitle:selectedtitle forState:UIControlStateSelected];
    [button  setTitleColor:[UIColor  colorWithRed:0.29 green:0.57 blue:0.53 alpha:1.0] forState:UIControlStateSelected];
    //[button  setFont:[UIFont  systemFontOfSize:13]];
    button.titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:15];
    [button  setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    
}

+(void)setButton1:(UIButton *)button   setNormalImage:(NSString *)normalimage  setSelectedImage:(NSString *) selectedImage setNormalTitle:(NSString *)normaltitle setSelectedTitle:(NSString *) selectedtitle{
    
    [button  setImage:[UIImage  imageNamed:normalimage] forState:UIControlStateNormal];
    [button  setImage:[UIImage  imageNamed:selectedImage] forState:UIControlStateSelected];
    [button  setTitle:normaltitle forState:UIControlStateNormal];
    [button  setTitleColor:[UIColor  blackColor] forState:UIControlStateSelected];
    [button  setTitle:selectedtitle forState:UIControlStateSelected];
    [button  setTitleColor:[UIColor  colorWithRed:0.29 green:0.57 blue:0.53 alpha:1.0] forState:UIControlStateNormal];
    //[button  setFont:[UIFont  systemFontOfSize:13]];
    button.titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:15];
    [button  setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    
}
@end
