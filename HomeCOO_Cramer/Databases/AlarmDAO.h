//
//  AlarmDAO.h
//  2cu
//
//  Created by Jie on 14-10-21.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Alarm.h"
#import "sqlite3.h"
#define DB_NAME @"2cu.sqlite"

@interface AlarmDAO : NSObject
@property (nonatomic) sqlite3 *db;


-(BOOL)insert:(Alarm*)alarm;



-(NSMutableArray*)findAll;//获取所有设备的，且排好序的报警记录
-(NSMutableArray *)get20AlarmRecordsWithStartIndex:(NSInteger)startIndex;

-(NSMutableArray*)findAllWithDeviceID:(NSString *)deviceID;//获取某个设备的，且排好序的报警记录
-(NSMutableArray *)get20AlarmRecordsWithDeviceID:(NSString *)deviceID startIndex:(NSInteger)startIndex;

-(NSMutableArray*)findAllUnsortedWithDeviceID:(NSString *)deviceID;//获取某个设备的，且没有排好序的报警记录

-(BOOL)delete:(Alarm*)alarm;

-(BOOL)clear;

-(BOOL)clearWithDeviceID:(NSString *)deviceID;
-(NSMutableArray*)findAll:(NSString*)deviceID;//获取所有设备的，且排好序的报警记录
-(NSMutableArray *)get20AlarmRecordsWithStartIndex:(NSInteger)startIndex with:(NSString*)deviceID;


// == 2015 - 10 - 29 新增
// 设置已读

- (BOOL)update; // 更新所有数据

-(BOOL)update:(Alarm*)alarm; // 更新单条数据

-(BOOL)updateWithDeviceID:(NSString *)deviceID; // 更新某个设备的所有数据

// ===

@end
