//
//  CustomNavVC.m
//  Pikate
//
//  Created by wsz on 16/1/17.
//  Copyright © 2016年 ZDSC. All rights reserved.
//

#import "CustomNavVC.h"

@interface CustomNavVC ()

@end

@implementation CustomNavVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:@"nav_green.png"];
    image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:0];
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setShadowImage:[UIImage imageNamed:@"tabbar_empty"]];
}

+(UILabel *)setNavgationItemTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    label.text = title;
    [label sizeToFit];
    label.font = [UIFont systemFontOfSize:19.0];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

+(UIBarButtonItem *)getLeftBarButtonItemWithTarget:(id)taget action:(SEL)sel titile:(NSString *)title;
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 57, 40);
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [button addTarget:taget action:sel forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+(UIBarButtonItem *)getRightBarButtonItemWithTarget:(id)taget action:(SEL)sel titile:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 57, 40);
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, -15)];
    button.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [button addTarget:taget action:sel forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

//left buttonItem2
+(UIBarButtonItem *)getLeftBarButtonItemWithTarget:(id)taget action:(SEL)sel
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 48, 48);
    [button setImage:[UIImage imageNamed:@"custom_back"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"custom_back"] forState:UIControlStateHighlighted];
    [button setImageEdgeInsets:UIEdgeInsetsMake(1, -13, -1, 13)];
    [button addTarget:taget action:sel forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

//left buttonItem3
+(UIBarButtonItem *)getLeftBarButtonItemWithTarget:(id)taget
                                            action:(SEL)sel
                                         normalImg:(UIImage *)imageN
                                        hilightImg:(UIImage *)imageH
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:imageN forState:UIControlStateNormal];
    [button setImage:imageH forState:UIControlStateHighlighted];
    button.frame = CGRectMake(0, 0, 45, 45);
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 12)];
    [button addTarget:taget action:sel forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor= [UIColor clearColor];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

//left buttonItem4
+(UIBarButtonItem *)getLeftBarButtonItemWithTargetText:(id)taget
                                                action:(SEL)sel
                                             normalImg:(UIImage *)imageN
                                            hilightImg:(UIImage *)imageH
                                                 title:(NSString *)str
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:imageN forState:UIControlStateNormal];
    [button setImage:imageH forState:UIControlStateHighlighted];
    button.frame = CGRectMake(0, 0, 58, 45);
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 12)];
    [button addTarget:taget action:sel forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor= [UIColor clearColor];
    button.titleLabel.font =[UIFont systemFontOfSize:15];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    [button setTitle:str forState:0];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

//right buttonItem2
+(UIBarButtonItem *)getRightBarButtonItemWithTarget:(id)taget
                                             action:(SEL)sel
                                          normalImg:(UIImage *)imageN
                                         hilightImg:(UIImage *)imageH
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 48, 48);
    [button setImage:imageN forState:UIControlStateNormal];
    [button setImage:imageH forState:UIControlStateHighlighted];
    [button setImageEdgeInsets:UIEdgeInsetsMake(1, 16, -1, -16)];
    [button addTarget:taget action:sel forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    [super presentViewController:viewControllerToPresent animated:YES completion:nil];
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
-(BOOL)shouldAutorotate{
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interface {
    return (interface == UIInterfaceOrientationPortrait );
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}
@end
