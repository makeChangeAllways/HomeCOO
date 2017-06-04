//
//  InfraredRemoteController.h
//  2cu
//
//  Created by guojunyi on 14-7-24.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YButton.h"
@interface InfraredRemoteController : UIViewController<YButtonDelegate>
@property (nonatomic,strong) UITextField *wifiPwdField;
@property (nonatomic,strong) UITextField *devicePwdField;
@property (nonatomic,strong) UITextField *ssidField;
@property (nonatomic,strong) UIButton *setWifiView;

@property (nonatomic,strong) UIView *inputView;
@end
