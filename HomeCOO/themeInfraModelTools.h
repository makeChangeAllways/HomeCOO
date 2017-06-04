//
//  themeInfraModelTools.h
//  HomeCOO
//
//  Created by app on 2016/10/19.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@class themeInfraModel;

@interface themeInfraModelTools : NSObject

//向遥控情景表中 插入数据
+(void)addThemeInfraDevice:(themeInfraModel *)device;
    
+(NSArray *)querWithInfraDevices:(themeInfraModel*)device;
+(void)updateInfraDeviceState:(themeInfraModel *)device;
+(NSArray *)querWithInfraThemes:(themeInfraModel*)device;
+(void)deleteThemeInfraDevice:(themeInfraModel*)device;
+(NSArray *)querWithInfraThemesByGW:(themeInfraModel*)device;
+(void)deleteAllThemeInfraDevice:(themeInfraModel*)device;
@end
