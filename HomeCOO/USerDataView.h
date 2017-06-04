//
//  USerDataView.h
//  HomeCOO
//
//  Created by app on 2016/10/23.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//
#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a/1.0]

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


#import <UIKit/UIKit.h>

@class USerDataView;

@protocol USerDataViewDelegate <NSObject>

//点击确定 调用的代理方法
- (void)sureButtonlicked:(USerDataView *)daterView;

//点击button 代理方法
-(void)checkButtonClick:(USerDataView *)dataView;

@end

@interface USerDataView : UIView

@property (nonatomic, assign) id<USerDataViewDelegate> delegate;

@property (nonatomic,strong) NSIndexPath *currentIndexPath;

@property (nonatomic,strong) NSArray *titleArray;

@property (nonatomic,strong) UILabel *mainTitle;

@property (nonatomic,strong) UILabel *secondaryTitle;

@property (nonatomic,strong) UILabel *thirdTitle;


@property NSInteger keyBoardHeight;

@property (nonatomic,strong) UITextField *secondaryField;
@property (nonatomic,strong) UITextField *thirdField;

@property (nonatomic,strong) UIButton *clickBtn;

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
