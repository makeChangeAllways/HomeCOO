//
//  DefenceNameDAO.m
//  2cu
//
//  Created by mac on 15/11/5.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//

#import "DefenceNameDAO.h"
#import "UDManager.h"
#import "Defence.h"
#import "LoginResult.h"
#import "PrefixHeader.pch"
@implementation DefenceNameDAO


//  创表
-(id)init{
    if([super init]){
        if([self openDB]){
            char *errMsg;
            
            if(sqlite3_exec(self.db, [[self getCreateTableString] UTF8String], NULL, NULL, &errMsg)!=SQLITE_OK){
                NSLog(@"Table Defence failed to create.");
                sqlite3_free(errMsg);
            }
            [self closeDB];
        }
    }
    return self;
}

// db表存的路径
-(NSString*)dbPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    path = [path stringByAppendingPathComponent:DB_NAME];
    return path;
}

// 创表语句
-(NSString *)getCreateTableString{
    return @"CREATE TABLE IF NOT EXISTS DEFENCENAME(ID INTEGER PRIMARY KEY AUTOINCREMENT,activeUser Text,deviceId Text,SECTION Text,ROW Text,NAME Text,isLearn integer default 0)";
}

// 打开db表
-(BOOL)openDB{
    BOOL result = NO;
    if(sqlite3_open([[self dbPath] UTF8String], &_db)==SQLITE_OK){
        result = YES;
    }else{
        result = NO;
        NSLog(@"Failed to open database");
    }
    
    return result;
};


// 关闭db 表
-(BOOL)closeDB{
    if(sqlite3_close(self.db)==SQLITE_OK){
        return YES;
    }else{
        return NO;
    }
}


// 插入数据
-(BOOL)insert:(Defence*)defence{
    if(![UDManager isLogin]){
        return NO;
    }
    LoginResult *loginResult = [UDManager getLoginInfo];
    
    char *errMsg;
    BOOL result = NO;
    if([self openDB]){
        NSString *SQL = [NSString stringWithFormat:@"INSERT INTO DEFENCENAME(activeUser,deviceId,SECTION,ROW,NAME) VALUES(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",loginResult.contactId,defence.ContactId,defence.Section,defence.Row,defence.defenceName];
        
        if(sqlite3_exec(self.db, [SQL UTF8String], NULL, NULL, &errMsg)==SQLITE_OK){
            result = YES;
        }else{
            NSLog(@"Failed to insert defence.");
            sqlite3_free(errMsg);
            result = NO;
        }
        
        [self closeDB];
        
    }
    return result;
}



// 更新数据
-(BOOL)update:(Defence*)defence{
    if(![UDManager isLogin]){
        return NO;
    }
    //    LoginResult *loginResult = [UDManager getLoginInfo];
    
    char *errMsg;
    BOOL result = NO;
    if([self openDB]){
        NSString *SQL = [NSString stringWithFormat:@"UPDATE DEFENCENAME SET NAME = \"%@\" WHERE  ACTIVEUSER = \"%@\" and DEVICEID = \"%@\" and SECTION = \"%@\" and ROW = \"%@\"",defence.userId,defence.ContactId,defence.defenceName,defence.Section,defence.Row];
        
        if(sqlite3_exec(self.db, [SQL UTF8String], NULL, NULL, &errMsg)==SQLITE_OK){
            result = YES;
        }else{
            NSLog(@"Failed to Update Alarm.");
            sqlite3_free(errMsg);
            result = NO;
        }
        
        [self closeDB];
        
    }
    return result;
}
 


// 找出 某个设备 某一组 某一行 的数据
- (Defence *)findDefenceNameWithContactId:(NSString *)ContactId Section:(NSString *)Section Row:(NSString *)Row
{
    Defence *data = [[Defence alloc] init];
    if(![UDManager isLogin]){
        return data;
    }
    
    LoginResult *loginResult = [UDManager getLoginInfo];
    sqlite3_stmt *statement;
    
    
    if([self openDB]){
        NSString *SQL = [NSString stringWithFormat:@"SELECT ID,DEVICEID,activeUser,SECTION,ROW,NAME,isLearn FROM DEFENCENAME WHERE ACTIVEUSER = \"%@\" and DEVICEID = \"%@\" and SECTION = \"%@\" and ROW = \"%@\"",loginResult.contactId,ContactId,Section,Row];
        NSLog(@"%@",SQL);
        if(sqlite3_prepare_v2(self.db, [SQL UTF8String], -1, &statement, NULL)==SQLITE_OK){
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                data.ContactId = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 1)];
                data.userId = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 2)];
                data.Section = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 3)];
                data.Row = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 4)];
                data.defenceName = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 5)];
                data.isLearn = sqlite3_column_int(statement, 6);
//                [data release];
            }
        }else{
            NSLog(@"Failed to find Message:%s",sqlite3_errmsg(self.db));
        }
        
        sqlite3_finalize(statement);
        [self closeDB];
    }
    return data;
    
}





// 移除 某个 设备 某一组 某一行的数据
- (BOOL)removeSection:(NSString *)Section Row:(NSString *)Row ContactId:(NSString *)ContactId
{
    sqlite3_stmt *statement;
    BOOL result = YES;
    LoginResult *loginResult = [UDManager getLoginInfo];
    if([self openDB]){
        NSString *SQL = [NSString stringWithFormat:@"DELETE FROM DEFENCENAME WHERE SECTION = \"%@\" and ROW = \"%@\" and DEVICEID = \"%@\" and ACTIVEUSER = \"%@\"",Section,Row,ContactId,loginResult.contactId];
        if(sqlite3_prepare_v2(self.db, [SQL UTF8String], -1, &statement, NULL)!=SQLITE_OK){
            NSLog(@"Failed to find Alarm:%s",sqlite3_errmsg(self.db));
            result = NO;
        }
        
        if(sqlite3_step(statement)!=SQLITE_DONE){
            NSLog(@"Failed to delete Alarm:%s",sqlite3_errmsg(self.db));
            result = NO;
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);
        [self closeDB];
    }
    
    return result;
}


//按照时间顺序，取出所有设备的所有记录
- (NSArray *)findWithContactId:(NSString *)ContactId
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    if(![UDManager isLogin]){
        return array;
    }
    
    LoginResult *loginResult = [UDManager getLoginInfo];
    sqlite3_stmt *statement;
    
    if([self openDB]){
        NSString *SQL = [NSString stringWithFormat:@"SELECT ID,DEVICEID,activeUser,SECTIONROW,NAME,isLearn FROM DEFENCENAME WHERE ACTIVEUSER = \"%@\" and DEVICEID = \"%@\"",loginResult.contactId,ContactId];
        DLog(@"%@",SQL);
        if(sqlite3_prepare_v2(self.db, [SQL UTF8String], -1, &statement, NULL)==SQLITE_OK){
            while(sqlite3_step(statement)==SQLITE_ROW){
                Defence *data = [[Defence alloc] init];
                data.ContactId = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 1)];
                data.userId = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 2)];
                data.Section = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 3)];
                data.Row = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 4)];
                data.defenceName = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 5)];
                data.isLearn = sqlite3_column_int(statement, 6);
                [array addObject:data];
//                [data release];
                
            }
        }else{
            NSLog(@"Failed to find Message:%s",sqlite3_errmsg(self.db));
        }
        
        sqlite3_finalize(statement);
        [self closeDB];
    }
    
    return array;
}

//某设备 某 组的数据
- (NSArray *)findWithContactId:(NSString *)ContactId Section:(NSString *)Section
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    if(![UDManager isLogin]){
        return array;
    }
    
    LoginResult *loginResult = [UDManager getLoginInfo];
    sqlite3_stmt *statement;
    
    if([self openDB]){
        NSString *SQL = [NSString stringWithFormat:@"SELECT ID,DEVICEID,activeUser,SECTIONROW,NAME,isLearn FROM DEFENCENAME WHERE ACTIVEUSER = \"%@\" and DEVICEID = \"%@\" and Section = \"%@\"",loginResult.contactId,ContactId,Section];
        DLog(@"%@",SQL);
        if(sqlite3_prepare_v2(self.db, [SQL UTF8String], -1, &statement, NULL)==SQLITE_OK){
            while(sqlite3_step(statement)==SQLITE_ROW){
                Defence *data = [[Defence alloc] init];
                data.ContactId = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 1)];
                data.userId = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 2)];
                data.Section = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 3)];
                data.Row = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 4)];
                data.defenceName = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 5)];
                data.isLearn = sqlite3_column_int(statement, 6);
                [array addObject:data];
//                [data release];
                
            }
        }else{
            NSLog(@"Failed to find Message:%s",sqlite3_errmsg(self.db));
        }
        
        sqlite3_finalize(statement);
        [self closeDB];
    }
    
    return array;
}


@end
