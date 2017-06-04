//
//  DefenceNameDAO.h
//  2cu
//
//  Created by mac on 15/11/5.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//  存储防区命名

#import <Foundation/Foundation.h>
#import "Defence.h"
#import "sqlite3.h"
#define DB_NAME @"2cu.sqlite"

@interface DefenceNameDAO : NSObject
@property (nonatomic) sqlite3 *db;

// 插入数据
-(BOOL)insert:(Defence*)defence;

// 更新数据 (更新某 section 某 row 的 NAME)
-(BOOL)update:(Defence*)defence;

// 取出记录
- (Defence *)findDefenceNameWithContactId:(NSString *)ContactId Section:(NSString *)Section Row:(NSString *)Row;


// 删除记录
- (BOOL)removeSection:(NSString *)Section Row:(NSString *)Row ContactId:(NSString *)ContactId;

// 找出某设备的存储的的数据
- (NSArray *)findWithContactId:(NSString *)ContactId;

// 取出 某个设备 某一组的数据
- (NSArray *)findWithContactId:(NSString *)ContactId Section:(NSString *)Section;
@end
