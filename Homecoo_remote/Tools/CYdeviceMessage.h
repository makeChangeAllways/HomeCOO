//
//  CYdeviceMessage.h
//  HomeCOO
//
//  Created by app on 2017/1/3.
//  Copyright © 2017年 Jiaoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYdeviceMessage : NSObject
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *type;
//当前选定的码组
@property(nonatomic,copy) NSData *setCode;
//当前的设备类型
@property(nonatomic,copy) NSString *currentType;

//当前的红外转发器设备编号设备类型
@property(nonatomic,copy) NSString *currentDeviceNo;
@end
