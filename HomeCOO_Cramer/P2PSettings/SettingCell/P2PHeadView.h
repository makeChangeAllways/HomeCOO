//
//  P2PHeadView.h
//  2cu
//
//  Created by mac on 15/6/2.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"
#import "Utils.h"
#import "MBProgressHUD.h"
#import "P2PClient.h"
@interface P2PHeadView : UIView
@property (strong, nonatomic) NSString *imagestr;
@property (strong, nonatomic) UIButton *rigthbtn;
@property (strong, nonatomic) UIImageView *leftIconView;
@property (strong, nonatomic) Contact *contact;
-(id)initWithFrame:(CGRect)frame with:(Contact*)contact;
@property (strong, nonatomic) MBProgressHUD *progressAlert;
@end
