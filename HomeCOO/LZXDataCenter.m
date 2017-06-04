//
//  LZXDataCenter.m
//  Demo_传值
//
//  Created by LZXuan on 15-3-23.
//  Copyright (c) 2015年 LZXuan. All rights reserved.
//

#import "LZXDataCenter.h"

@implementation LZXDataCenter

+ (LZXDataCenter *)defaultDataCenter {
    
    static LZXDataCenter *dataCenter  = nil;
    @synchronized(self){//同步 -》考虑线程安全
        
        if (!dataCenter) {
            
            dataCenter = [[LZXDataCenter alloc] init];
        }
    }
    return dataCenter;
}
@end
