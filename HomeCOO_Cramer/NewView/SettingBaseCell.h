//
//  SettingBaseCell.h
//  2cu
//
//  Created by mac on 15/10/19.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SettingBaseItem;
typedef void(^switch_changeblock)(int row,int section);  // 开关状态改变block
@interface SettingBaseCell : UITableViewCell

@property(nonatomic,strong)SettingBaseItem *item;  // 每行的数据

@property(nonatomic,assign)int row;  // 行

@property(nonatomic,assign)int section;  // 组


@property(nonatomic,strong)switch_changeblock switch_blk; // 开关状态改变block

@end
