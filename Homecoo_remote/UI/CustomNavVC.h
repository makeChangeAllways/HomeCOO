//
//  CustomNavVC.h
//  Pikate
//
//  Created by wsz on 16/1/17.
//  Copyright © 2016年 ZDSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomNavVC : UINavigationController

//title
+(UILabel *)setNavgationItemTitle:(NSString *)title;
//left buttonItem1
+(UIBarButtonItem *)getLeftBarButtonItemWithTarget:(id)taget action:(SEL)sel titile:(NSString *)title;
//right buttonItem1
+(UIBarButtonItem *)getRightBarButtonItemWithTarget:(id)taget action:(SEL)sel titile:(NSString *)title;

//left buttonItem2
+(UIBarButtonItem *)getLeftBarButtonItemWithTarget:(id)taget action:(SEL)sel;
+(UIBarButtonItem *)getLeftBarButtonItemWithTarget:(id)taget
                                            action:(SEL)sel
                                         normalImg:(UIImage *)imageN
                                        hilightImg:(UIImage *)imageH;

+(UIBarButtonItem *)getLeftBarButtonItemWithTargetText:(id)taget
                                                action:(SEL)sel
                                             normalImg:(UIImage *)imageN
                                            hilightImg:(UIImage *)imageH
                                                 title:(NSString *)str;
//right buttonItem2
+(UIBarButtonItem *)getRightBarButtonItemWithTarget:(id)taget
                                             action:(SEL)sel
                                          normalImg:(UIImage *)imageN
                                         hilightImg:(UIImage *)imageH;

@end
