//
//  MessageCell.h
//  2cu
//
//  Created by mac on 15/10/23.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Alarm;
@interface MessageCell : UITableViewCell

@property(nonatomic,strong)Alarm *alarm; // 


@property(nonatomic,assign)BOOL isSingle;

@end
