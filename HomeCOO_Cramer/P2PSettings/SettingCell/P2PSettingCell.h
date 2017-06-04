//
//  P2PTimeSettingCell.h
//  2cu
//
//  Created by guojunyi on 14-5-14.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface P2PSettingCell : UITableViewCell

@property (strong, nonatomic) NSString *leftLabelText;
@property (strong, nonatomic) NSString *rightLabelText;

@property (strong, nonatomic) UILabel *leftLabelView;
@property (strong, nonatomic) UILabel *rightLabelView;

@property (strong, nonatomic) UIView *customView;
@property (strong, nonatomic) UIActivityIndicatorView *progressView;
@property (assign) BOOL isCustomViewHidden;
@property (assign) BOOL isLeftLabelHidden;
@property (assign) BOOL isRightLabelHidden;
@property (assign) BOOL isProgressViewHidden;

-(void)setLeftLabelHidden:(BOOL)hidden;
-(void)setRightLabelHidden:(BOOL)hidden;
-(void)setCustomViewHidden:(BOOL)hidden;
-(void)setProgressViewHidden:(BOOL)hidden;

//new control
@property (strong, nonatomic) UITextField *oldpassword;
@property (strong, nonatomic) UITextField *newpassword;
@property (strong, nonatomic) UITextField *repassword;
@property (strong, nonatomic) UIButton *savebutton;

@property (strong, nonatomic) UITextField *password;
@property (strong, nonatomic) UIButton *button;

@property (assign, nonatomic) BOOL isOpen;
@property (assign, nonatomic) BOOL isOpen2;

-(void) fill;
-(void) openHidden;
-(void) closeHidden;

//访客密码

-(void) fill2;
-(void) openHidden2;
-(void) closeHidden2;

@end
