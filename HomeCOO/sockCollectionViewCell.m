//
//  sockCollectionViewCell.m
//  HomeCOO
//
//  Created by tgbus on 16/6/14.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "sockCollectionViewCell.h"

@implementation sockCollectionViewCell
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
        
        [self  layoutChild];
        
        [self  changeBtn:self.button4];
        
    }
    
    
    return self;
}
-(void)layoutChild{
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
    self.messageLable = [[UILabel  alloc]initWithFrame:CGRectMake(0, 0, oneSwitchW/2, 40)];
    
    self.messageLable.clipsToBounds = YES;
    self.messageLable.layer.cornerRadius = 8.0;//设置边框圆角
    self.messageLable.text = @"位置待定";//默认位置待定
    self.messageLable.font =[UIFont  systemFontOfSize:14];
    
    [self.imgView   addSubview:self.messageLable];
    
    //添加第四个开关按钮
    self.button4 = [[UIButton alloc]init];
    
    CGFloat switch4X =CGRectGetMaxX(self.imgView.frame)-70;
    CGFloat switch4Y = 7;
    CGFloat switch4W =60;
    CGFloat switch4H =26;
    
    
    self.button4.frame = CGRectMake(switch4X, switch4Y, switch4W, switch4H);
    
    [self.button4  setImage:[UIImage   imageNamed:@"button_off.png"] forState:UIControlStateNormal];
    [self.button4  setImage:[UIImage  imageNamed:@"button_on.png"] forState:UIControlStateSelected];
    
    self.button4.tag = 400;
    //            [self.button4  addTarget:self action:@selector(checkboxClick1:) forControlEvents:UIControlEventTouchUpInside];
    //
    
    
    [self.imgView addSubview:self.button4];
    
    //向contentView中添加
    [self.contentView  addSubview:self.imgView];
    
    


}

-(void)changeBtn:(UIButton *)btn{
    
    [btn  setImage:[UIImage   imageNamed:@"button_on.png"] forState:UIControlStateNormal];
    [btn  setImage:[UIImage  imageNamed:@"button_off.png"] forState:UIControlStateSelected];
    
}
@end
