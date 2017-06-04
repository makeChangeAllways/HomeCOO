//
//  AlarmViewController.h
//  2cu
//
//  Created by mac on 15/5/18.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainController.h"

@interface AlarmViewController : UIViewController
@property (strong, nonatomic) NSString *typestr;
@property (strong, nonatomic) NSString *contactid;
@property (strong, nonatomic) MainController *mainController;
@end
