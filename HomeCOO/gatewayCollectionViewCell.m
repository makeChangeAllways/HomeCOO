//
//  gatewayCollectionViewCell.m
//  HomeCOO
//
//  Created by tgbus on 16/6/18.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "gatewayCollectionViewCell.h"

@implementation gatewayCollectionViewCell

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
        self.gatewayMessageLable = [[UILabel  alloc]initWithFrame:CGRectMake(0, 0, oneSwitchW/2, 40)];
        
        self.gatewayMessageLable.clipsToBounds = YES;
        self.gatewayMessageLable.layer.cornerRadius = 8.0;//设置边框圆角
        self.gatewayMessageLable.text = @"";//默认位置待定
        self.gatewayMessageLable.font =[UIFont  systemFontOfSize:12];
        //self.gatewayMessageLable.backgroundColor = [UIColor  blueColor];
        [self.imgView   addSubview:self.gatewayMessageLable];
        
        //添加第四个开关按钮
        self.button = [[UIButton alloc]init];
        
        CGFloat switch4X =CGRectGetMaxX(self.imgView.frame)-40;
        CGFloat switch4Y = 0;
        CGFloat switch4W =40;
        CGFloat switch4H =40;
        
        
        self.button.frame = CGRectMake(switch4X, switch4Y, switch4W, switch4H);
        
        [self.button  setImage:[UIImage   imageNamed:@"down_set.jpg"] forState:UIControlStateNormal];
//        [self.button  setImage:[UIImage  imageNamed:@"button_on.png"] forState:UIControlStateSelected];
        
        self.button.tag = 400;

        [self.imgView addSubview:self.button];
        
        self.button1 = [[UIButton alloc]init];
        CGFloat switch3X =CGRectGetMaxX(self.gatewayMessageLable.frame)+25;
        CGFloat switch3Y = 0;
        CGFloat switch3W =40;
        CGFloat switch3H =40;
        
        self.button1.frame = CGRectMake(switch3X, switch3Y, switch3W, switch3H);
        
        [self.button1  setImage:[UIImage   imageNamed:@"0ff.png"] forState:UIControlStateNormal];
        [self.button1  setImage:[UIImage  imageNamed:@"on.png"] forState:UIControlStateSelected];
        
        [self.imgView addSubview:self.button1];

        
        
        
        //向contentView中添加
        [self.contentView  addSubview:self.imgView];
        
        
    }
    
    
    return self;
}



@end
