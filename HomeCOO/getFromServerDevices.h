//
//  getFromServerDevices.h
//  HomeCOO
//
//  Created by tgbus on 16/7/17.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface getFromServerDevices : NSObject

@property   NSInteger deviceId;

@property   NSInteger deviceCategoryId;

//@property(nonatomic,weak)  NSString *DEVICE_GATEGORY_NAME;

@property(nonatomic,weak)  NSString *deviceName;

@property(nonatomic,weak)  NSString *deviceNo;

@property(nonatomic,weak)  NSString *deviceStateCmd;

@property   NSInteger deviceTypeId;

//@property(nonatomic,weak)  NSString *DEVICE_TYPE_NAME;

@property(nonatomic,weak)  NSString *gatewayNo;

@property(nonatomic,weak)  NSString *phoneNum;

@property(nonatomic,weak)  NSString *spaceNo;

@property  NSInteger spaceTypeId;


@end
