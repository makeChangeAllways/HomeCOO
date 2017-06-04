//
//  musicModelDBTools.h
//  HomeCOO
//
//  Created by app on 2016/12/9.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@class musicModelDB;
@interface musicModelDBTools : NSObject

+(void)addMusicList:(musicModelDB *)music;

+(void)updateMusicList:(musicModelDB *)music;

+(NSArray *)queryWithDeviceNumDevices;
+(NSArray *)querWithThemeNoMusic:(musicModelDB*)music;
+(void)deleteMusicTable;
@end
