//
//  scheduleInfraDataView.h
//  HomeCOO
//
//  Created by app on 2017/1/7.
//  Copyright © 2017年 Jiaoda. All rights reserved.
//
#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a/1.0]

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


#import <UIKit/UIKit.h>

@class scheduleInfraDataView ;
@class deviceMessage;
@protocol scheduleInfraDataViewDelegate <NSObject>

- (void)makeSureClicked:(scheduleInfraDataView *)daterView;
- (void)infraClicked:(scheduleInfraDataView *)daterView;

@end

@interface scheduleInfraDataView : UIView

@property (nonatomic, assign) id<scheduleInfraDataViewDelegate> delegate;

@property(nonatomic,strong) NSString *arr;

@property(nonatomic,strong) NSString *dateStr;

@property(nonatomic,strong) deviceMessage *device;

@property(nonatomic,strong) NSString *hour;

@property(nonatomic,strong) NSString *shij;

@property(nonatomic,strong) NSString *riqi;

@property(nonatomic,strong) NSString *xingqi;
@property(nonatomic,strong) NSString *strategy;
@property(nonatomic,strong) NSString *packData;
@property(nonatomic,strong) NSString *scheduleName;

@property   NSInteger  currentTag;
@property(nonatomic,strong) NSString *munite;
@property char arry;
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
