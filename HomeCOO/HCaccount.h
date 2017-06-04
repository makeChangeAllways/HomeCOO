//
//  HCaccount.h
//  HomeCOO
//
//  Created by app on 16/10/6.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCaccount : NSObject<NSCoding>

@property(nonatomic,copy) NSString * AccountGatewayID ;

@property(nonatomic,copy) NSString * AccountGatewayPwd ;

@property(nonatomic,copy) NSString * AccountRouterName ;

@property(nonatomic,copy) NSString * AccountRouterPwd ;

+(instancetype)accountWithDict:(NSDictionary *)dict;
@end
