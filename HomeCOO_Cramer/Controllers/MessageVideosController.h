//
//  MessageVideosController.h
//  2cu
//
//  Created by mac on 15/10/27.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//  消息录像

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@class Alarm;
@class Contact;
@interface MessageVideosController : BaseViewController

@property(nonatomic,strong)Alarm *alarm;
@property(nonatomic,strong)Contact *contact;


@end
