//
//  AlarmalertView.m
//  2cu
//
//  Created by mac on 15/5/22.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//

#import "AlarmalertView.h"
#import "PrefixHeader.pch"
@implementation AlarmalertView

-(id)initWithFrame:(CGRect)frame withtypestr:(NSString *)typestr withcid:(NSString *)contactid{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
    
        UIView*headview=[[UIView alloc]init];
        [self addSubview:headview];
        headview.backgroundColor=[UIColor colorWithRed:98/255.0 green:165/255.0 blue:231/255.0 alpha:1];
        headview.frame=CGRectMake(0, 0, frame.size.width, frame.size.height/2);
        
        
        UIImageView*headimg=[[UIImageView alloc]init];
        [headview addSubview:headimg];
        [headimg setFrame:CGRectMake((WidthForView(headview)-80)/2, (HeightForView(headview)-35)/2, 80, 35)];
        headimg.image=[UIImage imageNamed:@"message_removal"];
        
        
        
        
        UIButton*button=[[UIButton alloc]init];
        [headview addSubview:button];
        [button setImage:[UIImage imageNamed:@"bounced_delete.png"] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(RightForView(headview)-35, 2, 30, 30)];
        self.canclebtn=button;
        
    
        
        UILabel*label2=[[UILabel alloc]init];
        [self addSubview:label2];
        label2.text=[NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"event", nil),typestr];
        label2.frame=CGRectMake(0, BottomForView(headview), VIEWWIDTH, 30);
        label2.textColor=[UIColor blackColor];
        label2.textAlignment = NSTextAlignmentCenter;
        label2.font=[UIFont systemFontOfSize:19];
        
        UILabel*label1=[[UILabel alloc]init];
        [self addSubview:label1];
        label1.text=[NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"device", nil),contactid];
        label1.frame=CGRectMake(0, BottomForView(label2), VIEWWIDTH, 30);
        label1.textAlignment = NSTextAlignmentCenter;
        label1.textColor=[UIColor grayColor];
        
        
        UILabel *timeL = [[UILabel alloc] init];
        [headview addSubview:timeL];
        
        
        NSString *dateStr = [CommonFunction dateToString:[NSDate date]];
        CGSize size3 = [CommonFunction sizeWithString:dateStr font:[UIFont systemFontOfSize:18]];
        CGFloat time_H = size3.height < 40 ? size3.height : 40;
        timeL.font = [UIFont systemFontOfSize:18];
        timeL.text = dateStr;
        timeL.textColor = [UIColor grayColor];
        timeL.numberOfLines = 0;
        timeL.textAlignment = NSTextAlignmentCenter;
        CGFloat time_X = 0;
        CGFloat time_Y = BottomForView(label1);
        CGFloat time_W =VIEWWIDTH;
        timeL.frame = CGRectMake(time_X, time_Y, time_W, time_H);
        
        
    }
    return self;
}

@end
