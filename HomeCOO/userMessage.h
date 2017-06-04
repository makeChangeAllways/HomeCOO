//
//  userMessage.h
//  HomeCOO
//
//  Created by tgbus on 16/6/26.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface userMessage : NSObject

@property  NSInteger  user_ID;
/**
 *  用户编号
 */
@property(nonatomic,strong)  NSString *phone_Num;
/**
 *  手机号
 */
@property(nonatomic,strong)  NSString *password;
/**
 *  真实姓名
 */
@property(nonatomic,strong)  NSString  *real_Nname;
/**
 *  邮件
 */
@property(nonatomic,strong)  NSString  *email;
/**
 *  网关识别码
 */
@property(nonatomic,strong)  NSString *gateway_NO;
/**
 *  家庭地址
 */
@property(nonatomic,strong)  NSString *address;
/**
 *  是否在线
 */
@property(nonatomic,strong)  NSString *is_Online;
/**
 *  创建时间
 */
@property(nonatomic,strong)  NSString *create_Time;


@end
