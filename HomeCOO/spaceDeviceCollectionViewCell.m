//
//  spaceDeviceCollectionViewCell.m
//  HomeCOO
//
//  Created by app on 16/8/16.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "spaceDeviceCollectionViewCell.h"

@implementation spaceDeviceCollectionViewCell
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
        
        [self changeBtn:self.button4];
        [self changeBtn:self.button3];
        [self changeBtn:self.button2];
        [self changeBtn:self.button1];
        [self changBtn:self.button8];
        [self changeBtn:self.button9];
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
    
    //oneSwitch.backgroundColor = [UIColor  redColor];
    self.imgView.image = [UIImage  imageNamed:@"照明_bg.png"];
    self.imgView.userInteractionEnabled = YES;
    
    //添加设备详细信息标签
    self.messageLable = [[UILabel  alloc]initWithFrame:CGRectMake(0, 0, oneSwitchW/1.6, 40)];
    //self.messageLable.backgroundColor = [UIColor redColor];
    self.messageLable.clipsToBounds = YES;
    self.messageLable.layer.cornerRadius = 8.0;//设置边框圆角
    self.messageLable.text = @"位置待定";//默认位置待定
    self.messageLable.font =[UIFont  systemFontOfSize:14];
    
    [self.imgView   addSubview:self.messageLable];
    
    self.process = [[UISlider  alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.messageLable.frame )-20, 0, oneSwitchW/2.4, 40)];
    
    self.process.minimumValue = 0;
    self.process.maximumValue = 9;
    //self.process.value = 5 ;
    self.process.continuous = NO;
    self.process.userInteractionEnabled = YES;
    
    [self.imgView  addSubview:self.process];
    
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
    
    //添加第三个开关按钮
    self.button3 = [[UIButton alloc]init];
    
    CGFloat switch3X =CGRectGetMinX(self.button4.frame)-33;
    CGFloat switch3Y = 7;
    CGFloat switch3W =26;
    CGFloat switch3H =26;
    
    self.button3.frame = CGRectMake(switch3X, switch3Y, switch3W, switch3H);
    [self.button3  setImage:[UIImage   imageNamed:@"button_off_s.png"] forState:UIControlStateNormal];
    [self.button3  setImage:[UIImage  imageNamed:@"button_on_s.png"] forState:UIControlStateSelected];
    
    self.button3.tag = 300;
    //            [self.button3  addTarget:self action:@selector(checkboxClick2:) forControlEvents:UIControlEventTouchUpInside];
    //
    
    //添加第二个开关按钮
    self.button2 = [[UIButton alloc]init];
    
    CGFloat switch2X =CGRectGetMinX(self.button3.frame)-33;
    CGFloat switch2Y = 7;
    CGFloat switch2W =26;
    CGFloat switch2H =26;
    
    self.button2.frame = CGRectMake(switch2X, switch2Y, switch2W, switch2H);
    [self.button2  setImage:[UIImage   imageNamed:@"button_off_s.png"] forState:UIControlStateNormal];
    [self.button2  setImage:[UIImage  imageNamed:@"button_on_s.png"] forState:UIControlStateSelected];
    
    self.button2.tag = 200;
    //            [self.button2  addTarget:self action:@selector(checkboxClick3:) forControlEvents:UIControlEventTouchUpInside];
    //
    //添加第一个开关按钮
    self.button1 = [[UIButton alloc]init];
    
    CGFloat switch1X =CGRectGetMinX(self.button2.frame)-33;
    CGFloat switch1Y = 7;
    CGFloat switch1W =26;
    CGFloat switch1H =26;
    
    self.button1.frame = CGRectMake(switch1X, switch1Y, switch1W, switch1H);
    [self.button1  setImage:[UIImage   imageNamed:@"button_off_s.png"] forState:UIControlStateNormal];
    [self.button1  setImage:[UIImage  imageNamed:@"button_on_s.png"] forState:UIControlStateSelected];
    
    self.button1.tag = 100;
   
    //添加第四个开关按钮
    self.button5 = [[UIButton alloc]init];
    
    CGFloat button5X =CGRectGetMaxX(self.imgView.frame)-35;
    CGFloat button5Y = 7;
    CGFloat button5W =26;
    CGFloat button5H =26;
    
    self.button5.frame = CGRectMake(button5X, button5Y, button5W, button5H);
    
    [self.button5  setImage:[UIImage   imageNamed:@"on0.png"] forState:UIControlStateNormal];
    [self.button5  setImage:[UIImage  imageNamed:@"on1.png"] forState:UIControlStateDisabled];
    
    self.button5.tag = 500;
    //            [self.button4  addTarget:self action:@selector(checkboxClick1:) forControlEvents:UIControlEventTouchUpInside];
    //
    
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
    // [self.button3  addTarget:self action:@selector(checkboxClick2:) forControlEvents:UIControlEventTouchUpInside];
    //
    
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
    
    //插座
    self.button8 = [[UIButton alloc]init];
    
    CGFloat button8X =CGRectGetMaxX(self.imgView.frame)-70;
    CGFloat button8Y = 7;
    CGFloat button8W =60;
    CGFloat button8H =26;
    
    
    self.button8.frame = CGRectMake(button8X, button8Y, button8W, button8H);
    
    [self.button8  setImage:[UIImage   imageNamed:@"button_off.png"] forState:UIControlStateNormal];
    [self.button8  setImage:[UIImage  imageNamed:@"button_on.png"] forState:UIControlStateSelected];
    
    self.button8.tag = 800;
    
    
    self.button9 =[[UIButton  alloc]initWithFrame:CGRectMake(switch4X, switch4Y, switch4W, switch4H)];
    
    [self.button9  setImage:[UIImage   imageNamed:@"button_off_s.png"] forState:UIControlStateNormal];
    [self.button9  setImage:[UIImage  imageNamed:@"button_on_s.png"] forState:UIControlStateSelected];
    self.button9.tag = 900;

    [self.imgView addSubview:self.button1];
    [self.imgView addSubview:self.button2];
    [self.imgView addSubview:self.button3];
    [self.imgView addSubview:self.button4];
    [self.imgView addSubview:self.button5];
    [self.imgView addSubview:self.button6];
    [self.imgView addSubview:self.button7];
    [self.imgView addSubview:self.button8];
    [self.imgView addSubview:self.button9];
    //向contentView中添加开关
    [self.contentView  addSubview:self.imgView];
    
    
}
//开关
-(void)changeBtn:(UIButton *)btn{
    
    [btn  setImage:[UIImage   imageNamed:@"button_on_s.png"] forState:UIControlStateNormal];
    [btn  setImage:[UIImage  imageNamed:@"button_off_s.png"] forState:UIControlStateSelected];
    
}
//插座
-(void)changBtn:(UIButton *)btn{
    
    [btn  setImage:[UIImage   imageNamed:@"button_on.png"] forState:UIControlStateNormal];
    [btn  setImage:[UIImage  imageNamed:@"button_off.png"] forState:UIControlStateSelected];
    
}

@end
