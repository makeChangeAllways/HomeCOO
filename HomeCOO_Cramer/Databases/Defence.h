//
//  Defence.h
//  2cu
//
//  Created by mac on 15/11/5.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Defence : NSObject

@property(nonatomic,copy)NSString *userId; // 用户ID

@property(nonatomic,copy)NSString *defenceName; // 防区命名

@property(nonatomic,copy)NSString *ContactId; // 设备ID

@property(nonatomic,copy)NSString *Section; // 组

@property(nonatomic,copy)NSString *Row; // 行

@property(nonatomic,assign)int isLearn; // 是否学习

@end
