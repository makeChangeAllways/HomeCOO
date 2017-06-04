//
//  MessageDetailController.h
//  2cu
//
//  Created by mac on 15/5/15.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Alarm.h"
@class Contact;
@interface MessageDetailController : UIViewController
@property (strong, nonatomic) Alarm *alarm;
@property (strong, nonatomic) Contact *contact;

@end
