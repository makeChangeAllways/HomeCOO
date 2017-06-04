//
//  SMMchTestV.h
//  IRBT
//
//  Created by wsz on 16/10/9.
//  Copyright © 2016年 wsz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceM.h"

@interface SMMchTestV : UIView

@property (nonatomic,copy)void(^testBtnClicked)(DeviceType type,NSInteger tag);
@property (nonatomic,copy)void(^ctrBtnClicked)(NSInteger tag);
- (void)showWithDeviceType:(DeviceType)type;
- (void)setLabelCur:(NSInteger)cnt totelCount:(NSInteger)totel;
@end
