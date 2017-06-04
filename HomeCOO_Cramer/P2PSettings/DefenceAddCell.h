//
//  DefenceAddCell.h
//  2cu
//
//  Created by mac on 15/11/10.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ADD_BLOCK)();

@interface DefenceAddCell : UITableViewCell

@property(nonatomic,strong)ADD_BLOCK add_block;


@end
