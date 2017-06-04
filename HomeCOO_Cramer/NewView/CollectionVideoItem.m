//
//  CollectionVideoItem.m
//  2cu
//
//  Created by mac on 15/10/21.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//

#import "CollectionVideoItem.h"

@interface CollectionVideoItem ()

@property (retain, nonatomic) IBOutlet UIImageView *video_iconView;

@property (retain, nonatomic) IBOutlet UILabel *video_Label;

@end

@implementation CollectionVideoItem

- (void)awakeFromNib {
    // Initialization code
}

//- (void)dealloc {
//    [_video_iconView release];
//    [_video_Label release];
//    [super dealloc];
//}

- (void)setHeadImg:(UIImage *)headImg
{
    _headImg = headImg;
    self.video_iconView.image = headImg;
}


- (void)setTime_str:(NSString *)time_str
{
    _time_str = time_str;
    if (self.no_sub.length) {
        self.video_Label.text = time_str;
        
    }else{
        NSString *sub_str = [time_str substringFromIndex:10];
        self.video_Label.text = sub_str;
    }
    
}

@end
