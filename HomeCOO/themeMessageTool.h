//
//  themeMessageTool.h
//  HomeCOO
//
//  Created by tgbus on 16/7/4.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@class themMessageModel;

@interface themeMessageTool : NSObject

/**
 *  添加情景
 *
 *  @param theme 情景
 */

+(void)addTheme:(themMessageModel *)theme;

+(void)deleteThemeTable;

+(NSArray *)queryWiththemes:(themMessageModel *)theme;

+(void)delete:(themMessageModel *)theme;

+(NSArray *)queryWiththeme:(themMessageModel *)theme;


+(void)updateThemeName:(themMessageModel *)theme;
/**
 *  根据themeno 在theme表中查是否已经存在该themeno的情景
 *
 *  @return
 */
+(NSArray *)queryWiththemeNo:(themMessageModel *)theme;
/**
 *  更换安防类情景的themeno （仅限于安防类情景  themetype = 3）
 *
 *  @param
 */
+(void)updateSensorThemeNo:(themMessageModel *)theme;
/**
 *  根据themeNo 在theme表中查是否有对应的情景名称
 *
 *  @return
 */
+(NSArray *)queryThemeWithThemeNum:(themMessageModel *)theme;
@end
