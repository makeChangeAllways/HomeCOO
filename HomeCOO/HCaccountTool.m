//
//  HCaccountTool.m
//  HomeCOO
//
//  Created by app on 16/10/6.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "HCaccountTool.h"

@implementation HCaccountTool
+(void)saveAccount:(HCaccount *)account{
    
    //沙盒路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [doc  stringByAppendingPathComponent:@"account.archive"];
    
    [NSKeyedArchiver  archiveRootObject:account toFile:path];
    
}


+(HCaccount *)account{
    
    //沙盒路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [doc  stringByAppendingPathComponent:@"account.archive"];
    
    //加载模型
    HCaccount  *account = [NSKeyedUnarchiver  unarchiveObjectWithFile:path];
    
    return account;
    
}

@end
