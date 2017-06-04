//
//  themeModelViewCell.m
//  HomeCOO
//
//  Created by tgbus on 16/7/5.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "themeModelViewCell.h"

@implementation themeModelViewCell
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
    CGFloat  oneSwitchW = ([UIScreen  mainScreen].bounds.size.width/2) - 40;
    CGFloat  oneSwitchH =40;
    self.imgView.frame = CGRectMake(oneSwitchX, oneSwitchY, oneSwitchW, oneSwitchH);
    // oneSwitch.backgroundColor = [UIColor colorWithPatternImage:[UIImage  imageNamed:@"照明_bg.png"]];
    
    //oneSwitch.backgroundColor = [UIColor  redColor];
    self.imgView.image = [UIImage  imageNamed:@"照明_bg.png"];
    self.imgView.userInteractionEnabled = YES;
    
    //添加设备详细信息标签
    self.themeMessageLable = [[UILabel  alloc]initWithFrame:CGRectMake(0, 0, oneSwitchW/1.3, 40)];
    
    self.themeMessageLable.clipsToBounds = YES;
    self.themeMessageLable.layer.cornerRadius = 8.0;//设置边框圆角
    self.themeMessageLable.text = @"";//默认位置待定
    self.themeMessageLable.textAlignment = NSTextAlignmentCenter;
    self.themeMessageLable.font =[UIFont  systemFontOfSize:12];
    
    //self.themeMessageLable.backgroundColor = [UIColor  blueColor];
   
    [self.imgView   addSubview:self.themeMessageLable];
    
    //添加第四个开关按钮
    self.button = [[UIButton alloc]init];
    
    CGFloat switch4X =CGRectGetMaxX(self.imgView.frame)-56;
    CGFloat switch4Y = 0;
    CGFloat switch4W =40;
    CGFloat switch4H =40;
    
    
    self.button.frame = CGRectMake(switch4X, switch4Y, switch4W, switch4H);
    
    [self.button  setImage:[UIImage   imageNamed:@"0ff.png"] forState:UIControlStateNormal];
    [self.button  setImage:[UIImage  imageNamed:@"on.png"] forState:UIControlStateDisabled];
    
    self.button.tag = 400;
    
    [self.imgView addSubview:self.button];
    
    //向contentView中添加
    [self.contentView  addSubview:self.imgView];
    
}


@end
