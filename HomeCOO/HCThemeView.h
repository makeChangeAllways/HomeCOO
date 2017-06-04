//
//  HCThemeView.h
//  HomeCOO
//
//  Created by app on 2016/10/20.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a/1.0]

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@class HCThemeView;

@protocol HCThemeViewDelegate <NSObject>

//点击确定 调用的代理方法
- (void)makeSureThemeViewClicked:(HCThemeView *)daterView;

@end

@interface HCThemeView : UIView

@property (nonatomic, assign) id<HCThemeViewDelegate> delegate;

@property (nonatomic,strong) NSIndexPath *currentIndexPath;

@property (nonatomic,strong) NSArray *titleArray;

@property (nonatomic,strong) UILabel *mainTitle;

@property (nonatomic,strong) UILabel *secondaryTitle;

@property NSInteger keyBoardHeight;

@property (nonatomic,strong) UITextField *firstField;
@property (nonatomic,strong) UITextField *secondaryField;
@property (nonatomic,strong) UITextField *thirdField;
@property (nonatomic,strong) UITextField *fourthField;

@property (nonatomic,strong) UIButton *sureBtn;
@property (nonatomic,strong) UIButton *cancleBtn;

- (void)showView:(UIView *)aView animated:(BOOL)animated;

- (void)hiddenView:(UIView *)aView animated:(BOOL)animated;

@end

@interface UIView (Category)

@property (nonatomic,assign) CGFloat x;
@property (nonatomic,assign) CGFloat y;
@property (nonatomic,assign) CGFloat w;
@property (nonatomic,assign) CGFloat h;

@end
