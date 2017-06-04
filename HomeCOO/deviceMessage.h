//
//  deviceMessage.h
//  HomeCOO
//
//  Created by tgbus on 16/5/22.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface deviceMessage : NSObject

@property   NSInteger DEVICE_ID;

@property   NSInteger DEVICE_GATEGORY_ID;

@property(nonatomic,strong)  NSString *DEVICE_GATEGORY_NAME;

@property(nonatomic,strong)  NSString *DEVICE_NAME;

@property(nonatomic,strong)  NSString *DEVICE_NO;

@property(nonatomic,strong)  NSString *DEVICE_STATE;

@property   NSInteger DEVICE_TYPE_ID;

@property(nonatomic,strong)  NSString *DEVICE_TYPE_NAME;

@property(nonatomic,strong)  NSString *GATEWAY_NO;

@property(nonatomic,strong)  NSString *PHONE_NUM;

@property(nonatomic,strong)  NSString *SPACE_NO;

@property  NSInteger SPACE_TYPE_ID;



@end
