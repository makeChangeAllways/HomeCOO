//
//  NewRegisterController.h
//  2cu
//
//  Created by Jie on 14/12/6.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBProgressHUD;
@class LoginController;
@class MyTextField;
@interface NewRegisterController : UIViewController<UITextFieldDelegate>{

    int countTimer ;
    
    NSTimer *timer;
}
@property (assign) NSInteger registerType;

@property (strong, nonatomic) UIView *mainView1;
@property (strong, nonatomic) UIView *mainView2;

@property (strong,nonatomic) UILabel *leftLabel;
@property (strong,nonatomic) UILabel *rightLabel;
@property (strong,nonatomic) LoginController *loginController;

@property (nonatomic, strong) MyTextField *field1;
@property (nonatomic, strong) MyTextField *yanzhentf;
@property (nonatomic, strong) MyTextField *pw1tf;
@property (nonatomic, strong) MyTextField *pw2tf;
@property (nonatomic, strong) MyTextField *emailField1;
@property (nonatomic, strong) MyTextField *emailField2;
@property (nonatomic, strong) MyTextField *emailField3;
@property (strong, nonatomic) MBProgressHUD *progressAlert;

@property (strong,nonatomic) NSString *countryCode;
@property (strong,nonatomic) NSString *countryName;
@property (strong,nonatomic) UIButton *yanzhenbtn;

@end
