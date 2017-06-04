//
//  themeMicroView.m
//  HomeCOO
//
//  Created by app on 16/8/17.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "themeMicroView.h"

@implementation themeMicroView

-(instancetype)initWithFrame:(CGRect)frame{

    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self  layoutChildViews];
        [self  changeBox:self.button5];
        [self  changeBtn:self.button4];
        
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
    CGFloat  oneSwitchW = ([UIScreen  mainScreen].bounds.size.width/2) - 20;
    CGFloat  oneSwitchH =40;
    self.imgView.frame = CGRectMake(oneSwitchX, oneSwitchY, oneSwitchW, oneSwitchH);
    
    self.imgView.image = [UIImage  imageNamed:@"照明_bg.png"];
    self.imgView.userInteractionEnabled = YES;
    
    //添加设备详细信息标签
    self.messageLable = [[UILabel  alloc]initWithFrame:CGRectMake(18, 0, oneSwitchW/1.6 - 30, 40)];
    
    self.messageLable.clipsToBounds = YES;
    self.messageLable.layer.cornerRadius = 8.0;//设置边框圆角
    self.messageLable.text = @"位置待定";//默认位置待定
    self.messageLable.font =[UIFont  systemFontOfSize:14];
    
    
    [self.imgView   addSubview:self.messageLable];
    
    
    //添加第五个开关按钮
    self.button5 = [[UIButton alloc]init];
    
    CGFloat switch5X =0;
    CGFloat switch5Y = 7;
    CGFloat switch5W =26;
    CGFloat switch5H =26;
    
    
    self.button5.frame = CGRectMake(switch5X, switch5Y, switch5W, switch5H);
    
    [self.button5  setImage:[UIImage   imageNamed:@"false.png"] forState:UIControlStateNormal];
    [self.button5  setImage:[UIImage  imageNamed:@"right.png"] forState:UIControlStateSelected];
    
    self.button5.tag = 500;
    
    
    //添加第四个开关按钮
    self.button4 = [[UIButton alloc]init];
    
    CGFloat switch4X =CGRectGetMaxX(self.imgView.frame)-33;
    CGFloat switch4Y = 7;
    CGFloat switch4W =26;
    CGFloat switch4H =26;
    
    self.button4.frame = CGRectMake(switch4X, switch4Y, switch4W, switch4H);
    
    [self.button4  setImage:[UIImage   imageNamed:@"button_off_s.png"] forState:UIControlStateNormal];
    [self.button4  setImage:[UIImage  imageNamed:@"button_on_s.png"] forState:UIControlStateSelected];
    
    self.button4.tag = 400;
    
    [self.imgView addSubview:self.button5];
    [self.imgView addSubview:self.button4];
    
    //向contentView中添加
    [self.contentView  addSubview:self.imgView];
    
}
-(void)changeBtn:(UIButton *)btn{
    
    [btn  setImage:[UIImage   imageNamed:@"button_on_s.png"] forState:UIControlStateNormal];
    [btn  setImage:[UIImage  imageNamed:@"button_off_s.png"] forState:UIControlStateSelected];
    
}

-(void)changeBox:(UIButton *)btn{
    
    [btn  setImage:[UIImage   imageNamed:@"right.png"] forState:UIControlStateNormal];
    [btn  setImage:[UIImage  imageNamed:@"false.png"] forState:UIControlStateSelected];
    
}

@end
