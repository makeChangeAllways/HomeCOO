//
//  scheduleCollectionViewCell.m
//  HomeCOO
//
//  Created by app on 2016/11/22.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "scheduleCollectionViewCell.h"

@implementation scheduleCollectionViewCell
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
    self.imgView.image = [UIImage  imageNamed:@"照明_bg.png"];
    self.imgView.userInteractionEnabled = YES;
    
    //添加设备详细信息标签
    self.alarmMessageLable = [[UILabel  alloc]initWithFrame:CGRectMake(8, 0, oneSwitchW-100, 45)];
    
    self.alarmMessageLable.clipsToBounds = YES;
    self.alarmMessageLable.layer.cornerRadius = 8.0;//设置边框圆角
    self.alarmMessageLable.textAlignment = NSTextAlignmentLeft;
    self.alarmMessageLable.font =[UIFont  systemFontOfSize:12];
   // self.alarmMessageLable.backgroundColor = [UIColor  blueColor];
    
    [self.imgView   addSubview:self.alarmMessageLable];
    
    //添加第四个开关按钮
    self.buttonTag = [[UIButton alloc]init];
    
    CGFloat switch4X =CGRectGetMaxX(self.imgView.frame)-40;
    CGFloat switch4Y = 0;
    CGFloat switch4W =40;
    CGFloat switch4H =40;
    
    self.buttonTag.frame = CGRectMake(switch4X, switch4Y, switch4W, switch4H);
    //self.buttonTag.backgroundColor = [UIColor redColor];
    [self.buttonTag  setImage:[UIImage   imageNamed:@"down_set.jpg"] forState:UIControlStateNormal];
    self.buttonTag.tag = 900;
    [self.imgView addSubview:self.buttonTag];
    
    self.process = [[UISlider  alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.buttonTag.frame )-100, 0, 100, 40)];
    
    self.process.minimumValue = 0;
    self.process.maximumValue = 9;
   
    self.process.continuous = NO;
    self.process.userInteractionEnabled = YES;
    
    [self.imgView  addSubview:self.process];
    
    //添加第四个开关按钮
    self.button4 = [[UIButton alloc]init];
    CGFloat switch9X =CGRectGetMinX(self.buttonTag.frame)-33;
    CGFloat switch9Y = 7;
    CGFloat switch9W =26;
    CGFloat switch9H =26;
    
    self.button4.frame = CGRectMake(switch9X, switch9Y, switch9W, switch9H);
    [self.button4  setImage:[UIImage   imageNamed:@"button_off_s.png"] forState:UIControlStateSelected];
    [self.button4  setImage:[UIImage  imageNamed:@"button_on_s.png"] forState:UIControlStateNormal];
    self.button4.tag = 400;
    [self.imgView addSubview:self.button4];
    

    //添加第三个开关按钮
    self.button3 = [[UIButton alloc]init];
    CGFloat switch3X =CGRectGetMinX(self.button4.frame)-33;
    CGFloat switch3Y = 7;
    CGFloat switch3W =26;
    CGFloat switch3H =26;
    self.button3.frame = CGRectMake(switch3X, switch3Y, switch3W, switch3H);
    [self.button3  setImage:[UIImage   imageNamed:@"button_off_s.png"] forState:UIControlStateSelected];
    [self.button3  setImage:[UIImage  imageNamed:@"button_on_s.png"] forState:UIControlStateNormal];
    
    self.button3.tag = 300;
   
    [self.imgView addSubview:self.button3];
       //添加第二个开关按钮
    self.button2 = [[UIButton alloc]init];
    CGFloat switch2X =CGRectGetMinX(self.button3.frame)-33;
    CGFloat switch2Y = 7;
    CGFloat switch2W =26;
    CGFloat switch2H =26;
    
    self.button2.frame = CGRectMake(switch2X, switch2Y, switch2W, switch2H);
    [self.button2  setImage:[UIImage   imageNamed:@"button_off_s.png"] forState:UIControlStateSelected];
    [self.button2  setImage:[UIImage  imageNamed:@"button_on_s.png"] forState:UIControlStateNormal];
    
    self.button2.tag = 200;
   
    [self.imgView addSubview:self.button2];
    

    //添加第一个开关按钮
    self.button1 = [[UIButton alloc]init];
    CGFloat switch1X =CGRectGetMinX(self.button2.frame)-33;
    CGFloat switch1Y = 7;
    CGFloat switch1W =26;
    CGFloat switch1H =26;
    
    self.button1.frame = CGRectMake(switch1X, switch1Y, switch1W, switch1H);
    [self.button1  setImage:[UIImage   imageNamed:@"button_off_s.png"] forState:UIControlStateSelected];
    [self.button1  setImage:[UIImage  imageNamed:@"button_on_s.png"] forState:UIControlStateNormal];
    self.button1.tag = 100;
    [self.imgView addSubview:self.button1];
   
    //添加第四个开关按钮
    self.button5 = [[UIButton alloc]init];
    CGFloat button5X =CGRectGetMinX(self.buttonTag.frame)-35;
    CGFloat button5Y = 7;
    CGFloat button5W =26;
    CGFloat button5H =26;
    self.button5.frame = CGRectMake(button5X, button5Y, button5W, button5H);
    [self.button5  setImage:[UIImage   imageNamed:@"on0.png"] forState:UIControlStateNormal];
    [self.button5  setImage:[UIImage  imageNamed:@"on1.png"] forState:UIControlStateDisabled];
    
    self.button5.tag = 500;
   
    [self.imgView addSubview:self.button5];
    
    //添加第三个开关按钮
    self.button6 = [[UIButton alloc]init];
    CGFloat button6X =CGRectGetMinX(self.button5.frame)-26;
    CGFloat button6Y = 7;
    CGFloat button6W =26;
    CGFloat button6H =26;
    
    self.button6.frame = CGRectMake(button6X, button6Y, button6W, button6H);
    [self.button6  setImage:[UIImage   imageNamed:@"pause0.png"] forState:UIControlStateNormal];
    [self.button6  setImage:[UIImage  imageNamed:@"pause1.png"] forState:UIControlStateDisabled];
    self.button6.tag = 600;
   
    [self.imgView addSubview:self.button6];
    
    //添加第二个开关按钮
    self.button7 = [[UIButton alloc]init];
    CGFloat button7X =CGRectGetMinX(self.button6.frame)-26;
    CGFloat button7Y = 7;
    CGFloat button7W =26;
    CGFloat button7H =26;
    
    self.button7.frame = CGRectMake(button7X, button7Y, button7W, button7H);
    [self.button7  setImage:[UIImage   imageNamed:@"off0.png"] forState:UIControlStateNormal];
    [self.button7  setImage:[UIImage  imageNamed:@"off1.png"] forState:UIControlStateDisabled];
    self.button7.tag = 700;
    [self.imgView addSubview:self.button7];
    //插座
    self.button8 = [[UIButton alloc]init];
    CGFloat button8X =CGRectGetMinX(self.buttonTag.frame)-70;
    CGFloat button8Y = 7;
    CGFloat button8W =60;
    CGFloat button8H =26;

    self.button8.frame = CGRectMake(button8X, button8Y, button8W, button8H);
    [self.button8  setImage:[UIImage   imageNamed:@"button_off.png"] forState:UIControlStateSelected];
    [self.button8  setImage:[UIImage  imageNamed:@"button_on.png"] forState:UIControlStateNormal];
    self.button8.tag = 800;
    
    [self.imgView addSubview:self.button8];
    
    //向contentView中添加
    [self.contentView  addSubview:self.imgView];
    
}

@end
