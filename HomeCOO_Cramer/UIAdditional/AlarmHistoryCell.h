//
//  AlarmHistoryCell.h
//  2cu
//
//  Created by Jie on 14-10-22.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlarmHistoryCell : UITableViewCell

@property (strong, nonatomic) UILabel *deviceLabel;
@property (strong, nonatomic) UILabel *typeLabel;
@property (strong, nonatomic) UILabel *timeLabel;

@property (strong, nonatomic) UILabel *deviceLabelText;
@property (strong, nonatomic) UILabel *typeLabelText;

@property (strong, nonatomic) NSString *deviceId;
@property (strong, nonatomic) NSString *alarmTime;

@property (strong, nonatomic) UIImageView *leftview;
@property (strong, nonatomic) UIImage *leftimg;
@property (nonatomic) int alarmType;

@end
