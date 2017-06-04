//
//  ARCSlideV.h
//  IRBT
//
//  Created by wsz on 16/9/27.
//  Copyright © 2016年 wsz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ARCSlideV : UIView

@property (nonatomic,retain)UILabel *disLabel;

@property (nonatomic,copy) void(^didSelecTemperature)(NSInteger temprature);

@end
