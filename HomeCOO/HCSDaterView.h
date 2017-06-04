//
//  HCSDaterView.h
//  HomeCOO
//
//  Created by app on 2016/10/17.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a/1.0]

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


#import <UIKit/UIKit.h>

@class HCSDaterView;

@protocol HCSDaterViewDelegate <NSObject>

- (void)daterViewClicked:(HCSDaterView *)daterView;


@end


@interface HCSDaterView : UIView

@property (nonatomic, assign) id<HCSDaterViewDelegate> delegate;

@property (nonatomic,strong) NSIndexPath *currentIndexPath;

@property (nonatomic,strong) NSArray *titleArray;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,strong) UIButton *sureBtn;

@property (nonatomic,strong) UIButton *cancleBtn;

- (void)showInView:(UIView *)aView animated:(BOOL)animated;

- (void)hiddenInView:(UIView *)aView animated:(BOOL)animated;

@end
@interface UIView (Category)
@property (nonatomic,assign) CGFloat x;
@property (nonatomic,assign) CGFloat y;
@property (nonatomic,assign) CGFloat w;
@property (nonatomic,assign) CGFloat h;

@end
