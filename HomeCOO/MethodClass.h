//
//  MethodClass.h
//  HomeCOO
//
//  Created by tgbus on 16/5/5.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//


#import <Foundation/Foundation.h>
#import<UIKit/UIKit.h>


@interface MethodClass : NSObject

+(void)setButton:(UIButton *)button   setNormalImage:(NSString *)normalimage  setHighlightedImage:(NSString *) highlightedImage setNormalTitle:(NSString *)normaltitle setHightedTitle:(NSString *) highlightedtitle;

+(void)setButton:(UIButton *)button setNormalImage:(NSString *)normalimage setHighlightedImage:(NSString *)highlightedImage;
+(void)setButton:(UIButton *)button   setNormalImage:(NSString *)normalimage  setSelectedImage:(NSString *) selectedImage setNormalTitle:(NSString *)normaltitle setSelectedTitle:(NSString *) selectedtitle;

+(void)setButton1:(UIButton *)button   setNormalImage:(NSString *)normalimage  setSelectedImage:(NSString *) selectedImage setNormalTitle:(NSString *)normaltitle setSelectedTitle:(NSString *) selectedtitle;
@end
