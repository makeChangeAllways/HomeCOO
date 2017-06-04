//
//  HCProductView.h
//  HomeCOO
//
//  Created by app on 2016/10/19.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//
#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a/1.0]

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


#import <UIKit/UIKit.h>

@class HCProductView;

@protocol HCProductViewDelegate <NSObject>

//点击确定 调用的代理方法
- (void)makeSureViewClicked:(HCProductView *)daterView;

//点击位置button 条用代理方法
- (void)postionViewClicked:(HCProductView *)daterView;


@end


@interface HCProductView : UIView

@property (nonatomic, assign) id<HCProductViewDelegate> delegate;

@property (nonatomic,strong) NSIndexPath *currentIndexPath;

@property (nonatomic,strong) NSArray *titleArray;

@property (nonatomic,strong) UILabel *mainTitle;

@property (nonatomic,strong) UILabel *secondaryTitle;

@property (nonatomic,strong) UILabel *thirdTitle;

@property (nonatomic,strong) UILabel *fourthTitle;

@property NSInteger keyBoardHeight;

@property (nonatomic,strong) UITextField *secondaryField;
@property (nonatomic,strong) UIButton *thirdButton;
@property (nonatomic,strong) UILabel *outdoorTitle;
@property (nonatomic,strong) UILabel *indoorTitle;
@property (nonatomic,strong) UIButton *sureBtn;

@property (nonatomic,strong) UIButton *cancleBtn;
@property (nonatomic,strong) UIButton *outdoorBtn;
@property (nonatomic,strong) UIButton *indoorBtn;
@property (nonatomic,strong) UIButton * button;

- (void)showView:(UIView *)aView animated:(BOOL)animated;

- (void)hiddenView:(UIView *)aView animated:(BOOL)animated;

@end

@interface UIView (Category)

@property (nonatomic,assign) CGFloat x;
@property (nonatomic,assign) CGFloat y;
@property (nonatomic,assign) CGFloat w;
@property (nonatomic,assign) CGFloat h;

@end
