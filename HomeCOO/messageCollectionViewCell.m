//
//  messageCollectionViewCell.m
//  HomeCOO
//
//  Created by app on 16/8/28.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "messageCollectionViewCell.h"

@implementation messageCollectionViewCell
/**
 *  初始化开关样式
 *
 *  @param frame 开关样式大小
 *
 *  @return 返回开关样式
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self  layoutChildViews];
        
    }
    
    
    return self;
}

/**
 *  初始化子控件
 */
-(void)layoutChildViews{
    
    self.imgView = [[UIImageView  alloc]init];
    
    CGFloat  oneSwitchX = 0;
    CGFloat  oneSwitchY =0;
    CGFloat  oneSwitchW = ([UIScreen  mainScreen].bounds.size.width) - 70;
    CGFloat  oneSwitchH =45;
    self.imgView.frame = CGRectMake(oneSwitchX, oneSwitchY, oneSwitchW, oneSwitchH);
    // oneSwitch.backgroundColor = [UIColor colorWithPatternImage:[UIImage  imageNamed:@"照明_bg.png"]];
    
     //self.imgView.backgroundColor = [UIColor  redColor];
    self.imgView.image = [UIImage  imageNamed:@"照明_bg.png"];
    self.imgView.userInteractionEnabled = YES;
    
    //添加设备详细信息标签
    self.alarmMessageLable = [[UILabel  alloc]initWithFrame:CGRectMake(8, 0, oneSwitchW, 45)];
    
    self.alarmMessageLable.clipsToBounds = YES;
    self.alarmMessageLable.layer.cornerRadius = 8.0;//设置边框圆角
    self.alarmMessageLable.textAlignment = NSTextAlignmentLeft;
    self.alarmMessageLable.font =[UIFont  systemFontOfSize:12];
    //self.alarmMessageLable.backgroundColor = [UIColor  blueColor];
    [self.imgView   addSubview:self.alarmMessageLable];
   
    //向contentView中添加
    [self.contentView  addSubview:self.imgView];
    
}


@end
