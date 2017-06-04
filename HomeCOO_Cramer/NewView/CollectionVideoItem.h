//
//  CollectionVideoItem.h
//  2cu
//
//  Created by mac on 15/10/21.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionVideoItem : UICollectionViewCell

@property(nonatomic,strong)UIImage *headImg; // 图像

@property(nonatomic,strong)NSString *time_str;

@property(nonatomic,copy)NSString *no_sub; // 判断时间是否需要截取


@end
