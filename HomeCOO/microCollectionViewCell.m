//
//  microCollectionViewCell.m
//  HomeCOO
//
//  Created by tgbus on 16/7/24.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "microCollectionViewCell.h"

@implementation microCollectionViewCell
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
        
        [self  changeBtn:self.button];
        
        
    }
    
    
    return self;
}

/**
 *  自定义子控件
 */
-(void)layoutChildViews{
    
    self.imgView = [[UIImageView  alloc]init];
    
    CGFloat  oneSwitchX = 0;
    CGFloat  oneSwitchY =0;
    CGFloat  oneSwitchW = ([UIScreen  mainScreen].bounds.size.width/2) - 40;
    CGFloat  oneSwitchH =40;
    self.imgView.frame = CGRectMake(oneSwitchX, oneSwitchY, oneSwitchW, oneSwitchH);
   
    self.imgView.image = [UIImage  imageNamed:@"照明_bg.png"];
    self.imgView.userInteractionEnabled = YES;
    
    //添加设备详细信息标签
    self.messageLable = [[UILabel  alloc]initWithFrame:CGRectMake(0, 0, oneSwitchW/1.5, 40)];
    
    self.messageLable.clipsToBounds = YES;
    self.messageLable.layer.cornerRadius = 8.0;//设置边框圆角
    self.messageLable.text = @"位置待定";//默认位置待定
    self.messageLable.font =[UIFont  systemFontOfSize:14];
    //self.messageLable.backgroundColor = [UIColor  redColor];
    
    
    [self.imgView   addSubview:self.messageLable];
    
    //添加第四个开关按钮
    self.button = [[UIButton alloc]init];
    
    CGFloat switch4X =CGRectGetMaxX(self.imgView.frame)-40;
    CGFloat switch4Y = 5;
    CGFloat switch4W =30;
    CGFloat switch4H =30;
       
    self.button.frame = CGRectMake(switch4X, switch4Y, switch4W, switch4H);
    
    [self.button  setImage:[UIImage   imageNamed:@"button_off_s.png"] forState:UIControlStateNormal];
    [self.button  setImage:[UIImage  imageNamed:@"button_on_s.png"] forState:UIControlStateSelected];
    
    self.button.tag = 400;
    
    [self.imgView addSubview:self.button];
    
    //向contentView中添加
    [self.contentView  addSubview:self.imgView];
    
}


-(void)changeBtn:(UIButton *)btn{
    
    [btn  setImage:[UIImage   imageNamed:@"button_on_s.png"] forState:UIControlStateNormal];
    [btn  setImage:[UIImage  imageNamed:@"button_off_s.png"] forState:UIControlStateSelected];
    
}




@end

