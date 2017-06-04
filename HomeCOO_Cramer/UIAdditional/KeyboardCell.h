//
//  KeyboardCell.h
//  2cu
//
//  Created by guojunyi on 14-4-26.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyboardCell : UITableViewCell
@property (nonatomic, strong) NSString *leftText;
@property (nonatomic, strong) NSString *rightText;

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@end
