//
//  spaceMessageTool.h
//  HomeCOO
//
//  Created by tgbus on 16/6/23.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@class spaceMessageModel;

@interface spaceMessageTool : NSObject

/**
 *  添加新空间
 */

+ (void)addSpace:( spaceMessageModel*)space;

/**
 *  在t_spaceTbale 表中查找已经添加的空间
 *
 *  @return 返回空间
 */
+(NSArray *)queryWithspaces:(spaceMessageModel *)space;

/**
 *  删除空间
 *
 *  @param space 空间
 */
+(void)delete:(spaceMessageModel *)space;
+(NSArray *)queryWithspacesNo:(spaceMessageModel *)space;

+(NSArray *)queryWithspacesDevicePostion:(spaceMessageModel *)space;

+(void)updateSpaceMessage:(spaceMessageModel *)space;
@end
