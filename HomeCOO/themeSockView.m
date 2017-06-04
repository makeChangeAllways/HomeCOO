//
//  themeSockView.m
//  HomeCOO
//
//  Created by tgbus on 16/7/15.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "themeSockView.h"

@implementation themeSockView


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
        
        [self  changeBtn:self.button4];
        [self  changeBox:self.button5];
        
    }
    
    
    return self;
}


/**
 *  封装开关样式
 */
-(void)layoutChildViews{

    self.imgView = [[UIImageView  alloc]init];
    
    CGFloat  oneSwitchX = 0;
    CGFloat  oneSwitchY =0;
    CGFloat  oneSwitchW = ([UIScreen  mainScreen].bounds.size.width/2) - 20;
    CGFloat  oneSwitchH =40;
    self.imgView.frame = CGRectMake(oneSwitchX, oneSwitchY, oneSwitchW, oneSwitchH);
    // oneSwitch.backgroundColor = [UIColor colorWithPatternImage:[UIImage  imageNamed:@"照明_bg.png"]];
    
    //oneSwitch.backgroundColor = [UIColor  redColor];
    self.imgView.image = [UIImage  imageNamed:@"照明_bg.png"];
    self.imgView.userInteractionEnabled = YES;
    
    //添加设备详细信息标签
    self.messageLable = [[UILabel  alloc]initWithFrame:CGRectMake(18, 0, oneSwitchW/1.6-30, 40)];
    //self.messageLable.backgroundColor = [UIColor redColor];
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
    
    [self.imgView addSubview:self.button5];

    [self.imgView addSubview:self.button4];
    
    //向contentView中添加
    [self.contentView  addSubview:self.imgView];
    


}
-(void)changeBox:(UIButton *)btn{
    
    [btn  setImage:[UIImage   imageNamed:@"right.png"] forState:UIControlStateNormal];
    [btn  setImage:[UIImage  imageNamed:@"false.png"] forState:UIControlStateSelected];
    
}
-(void)changeBtn:(UIButton *)btn{
    
    [btn  setImage:[UIImage   imageNamed:@"button_on.png"] forState:UIControlStateNormal];
    [btn  setImage:[UIImage  imageNamed:@"button_off.png"] forState:UIControlStateSelected];
    
}

@end
