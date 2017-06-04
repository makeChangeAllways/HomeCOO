//
//  infraMessageModel.h
//  HomeCOO
//
//  Created by tgbus on 16/7/23.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface infraMessageModel : NSObject

@property(nonatomic,copy) NSString * deviceNo;

@property(nonatomic,copy) NSString *deviceState_cmd;

@property(nonatomic,copy) NSString *gatewayNum;

@property(nonatomic,copy) NSString *infraCtr_name;

@property(nonatomic,copy) NSString *infraType_id;

@property(nonatomic,copy) NSString *themeNo;


@end
