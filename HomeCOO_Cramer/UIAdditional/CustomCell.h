//
//  CustomCell.h
//  2cu
//
//  Created by guojunyi on 14-3-29.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell

@property (nonatomic) NSString *leftIcon;
@property (nonatomic) NSString *rightIcon;
@property (nonatomic) NSString *labelText;

@property (strong, nonatomic) UIImageView *leftIconView;
@property (strong, nonatomic) UIImageView *leftIconView_p;

@property (strong, nonatomic) UILabel *textLabelView;
@property (strong, nonatomic) UILabel *textLabelView_p;

@property (strong, nonatomic) UIImageView *rightIconView;
@property (strong, nonatomic) UIImageView *rightIconView_p;


@end
