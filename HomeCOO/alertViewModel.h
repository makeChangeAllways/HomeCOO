//
//  alertViewModel.h
//  HomeCOO
//
//  Created by tgbus on 16/5/16.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface alertViewModel : UIAlertView

@property(nonatomic, retain) UITextField*  gatewayID;    // 旧密码输入框
@property(nonatomic, retain) UITextField*  gatewayIP;  // 新密码输入框
@property(nonatomic, retain) UITextField*  gatewayPwd;    // 新密码确认框


@end
