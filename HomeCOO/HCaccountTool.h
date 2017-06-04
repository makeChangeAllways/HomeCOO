//
//  HCaccountTool.h
//  HomeCOO
//
//  Created by app on 16/10/6.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HCaccount;

@interface HCaccountTool : NSObject

/**
 *存取账号信息
 *
 */
+(void)saveAccount:(HCaccount *)account;

/**
 *返回账号信息
 *
 */
+(HCaccount *)account;

@end
