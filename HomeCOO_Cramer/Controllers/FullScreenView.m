//
//  FullScreenView.m
//  2cu
//
//  Created by mac on 15/6/1.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//

#import "FullScreenView.h"
#import "FListManager.h"
#import "PrefixHeader.pch"
@interface FullScreenView ()

@property(nonatomic,strong)Contact *contact;


@end


@implementation FullScreenView
-(id)initWithFrame:(CGRect)frame withtypestr:(NSString *)typestr withcid:(NSString *)contactid{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        Contact *contact = nil;
        for (Contact *cont in [[[FListManager sharedFList] getContacts] mutableCopy]) {
            if ([cont.contactId isEqualToString:contactid]) {
                contact = cont;
            }
        }
        
        self.contact = contact;
        
        self.backgroundColor=[UIColor colorWithRed:98/255.0 green:165/255.0 blue:231/255.0 alpha:1];
        
        UIView*headview=[[UIView alloc]init];
        [self addSubview:headview];
        headview.backgroundColor=[UIColor colorWithRed:59/255.0 green:121/255.0 blue:185/255.0 alpha:1];
        headview.frame=CGRectMake(0, 0, frame.size.width, VIEWHEIGHT/3 - 20);
        
        
        UILabel*label1=[[UILabel alloc]init];
        [headview addSubview:label1];
        label1.text=[NSString stringWithFormat:@"%@",contact.contactName];
        CGSize size = [CommonFunction sizeWithString:contact.contactName font:[UIFont systemFontOfSize:18]];
        CGFloat contactName_H = size.height < 40 ? size.height : 40;
        label1.frame=CGRectMake(20, 40, 180, contactName_H);
        label1.textColor=[UIColor whiteColor];
        label1.font=[UIFont systemFontOfSize:18];
        label1.textAlignment = NSTextAlignmentLeft;
        label1.numberOfLines = 0;
        
        
        UILabel*label2=[[UILabel alloc]init];
        [headview addSubview:label2];
        label2.text=[NSString stringWithFormat:@"%@",typestr];
        CGSize size2 = [CommonFunction sizeWithString:typestr font:[UIFont systemFontOfSize:18]];
        CGFloat ContactId_H = size2.height < 40 ? size2.height : 40;
        label2.frame=CGRectMake(XForView(label1), BottomForView(label1), 200, ContactId_H);
        label2.textColor=[UIColor whiteColor];
        label2.numberOfLines = 0;
        label2.textAlignment = NSTextAlignmentLeft;
        label2.font = [UIFont systemFontOfSize:18];

        
        UILabel *timeL = [[UILabel alloc] init];
        [headview addSubview:timeL];
        NSString *dateStr = [CommonFunction dateToString:[NSDate date]];
        CGSize size3 = [CommonFunction sizeWithString:dateStr font:[UIFont systemFontOfSize:18]];
        CGFloat time_H = size3.height < 40 ? size3.height : 40;
        timeL.font = [UIFont systemFontOfSize:18];
        timeL.text = dateStr;
        timeL.textColor = [UIColor whiteColor];
        timeL.numberOfLines = 0;
        timeL.textAlignment = NSTextAlignmentLeft;
        CGFloat time_X = XForView(label1);
        CGFloat time_Y = BottomForView(label2);
        CGFloat time_W = 200 ;
        timeL.frame = CGRectMake(time_X, time_Y, time_W, time_H);
     
        
        
        UIButton *bufang_Btn = [[UIButton alloc] init];
        [headview addSubview:bufang_Btn];
        bufang_Btn.frame = CGRectMake(VIEWWIDTH - 80, YForView(label1), 60, 60);
        [bufang_Btn setImage:[UIImage imageNamed:@"yibufang"] forState:UIControlStateNormal];
        bufang_Btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [bufang_Btn addTarget:self action:@selector(bufangClick:) forControlEvents:UIControlEventTouchUpInside];
        bufang_Btn.tag  = contact.defenceState;
        if (contact.defenceState == DEFENCE_STATE_OFF)
        {
            [bufang_Btn setImage:[UIImage imageNamed:@"bufang"] forState:UIControlStateNormal];
            
            
        }else
        {
            [bufang_Btn setImage:[UIImage imageNamed:@"yibufang"] forState:UIControlStateNormal];
            
        }
        
        UILabel *alarm = [[UILabel alloc] init];
        alarm.frame = CGRectMake(VIEWWIDTH - 80, BottomForView(bufang_Btn), 60, 30);
        alarm.text = NSLocalizedString(@"报警来电", nil);
        [headview addSubview:alarm];
        alarm.textColor = [UIColor whiteColor];
        alarm.font = [UIFont systemFontOfSize:13];
        
        
        
        UIImageView *show_img = [[UIImageView alloc] init];
        [self addSubview:show_img];
        NSString *filePath = [Utils getHeaderFilePathWithId:contactid];
        
        UIImage *headImg = [UIImage imageWithContentsOfFile:filePath];
        if(headImg==nil){
            headImg = [UIImage imageNamed:@"bgImageBig.jpg"];
        }
        show_img.image = headImg;
        show_img.frame = CGRectMake(10, BottomForView(headview) + 15, VIEWWIDTH - 20, 200);
        
        
        UIButton*button=[[UIButton alloc]init];
        [self addSubview:button];
        [button setFrame:CGRectMake((VIEWWIDTH-260)/2, VIEWHEIGHT - 125, 80, 125)];
        self.callbtn=button;
        

        UIButton*button2=[[UIButton alloc]init];
        [self addSubview:button2];
        [button2 setFrame:CGRectMake(VIEWWIDTH-(VIEWWIDTH-260)/2-WidthForView(button), YForView(button), WidthForView(button), 125)];
        self.canclebtn=button2;
        
        
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *currentLanguage = [languages objectAtIndex:0];
        if (IOS8_OR_LATER) {
            if ([currentLanguage containsString:@"zh-Hans"]) {
                [button setImage:[UIImage imageNamed:@"hang_up_ch"] forState:UIControlStateNormal];
                [button2 setImage:[UIImage imageNamed:@"hang_off_ch"] forState:UIControlStateNormal];
            }else if ([currentLanguage containsString:@"en"]) { // 英文
                [button setImage:[UIImage imageNamed:@"hang_up_eng"] forState:UIControlStateNormal];
                [button2 setImage:[UIImage imageNamed:@"hang_off_eng"] forState:UIControlStateNormal];
            }else
            {
                [button setImage:[UIImage imageNamed:@"hang_up_fanti"] forState:UIControlStateNormal];
                [button2 setImage:[UIImage imageNamed:@"hang_off_fanti"] forState:UIControlStateNormal];
            }
        }else
        {
            if ([currentLanguage isEqualToString:@"zh-Hans"]) {
                [button setImage:[UIImage imageNamed:@"hang_up_ch"] forState:UIControlStateNormal];
                [button2 setImage:[UIImage imageNamed:@"hang_off_ch"] forState:UIControlStateNormal];
            }else if ([currentLanguage isEqualToString:@"en"]) { // 英文
                [button setImage:[UIImage imageNamed:@"hang_up_eng"] forState:UIControlStateNormal];
                [button2 setImage:[UIImage imageNamed:@"hang_off_eng"] forState:UIControlStateNormal];
            }else
            {
                [button setImage:[UIImage imageNamed:@"hang_up_fanti"] forState:UIControlStateNormal];
                [button2 setImage:[UIImage imageNamed:@"hang_off_fanti"] forState:UIControlStateNormal];
            }
        }
        
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        button2.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
    }
     _soundID = [Utils rePlayMusicWithName:@"alrm" andType:@"mp3"];
    return self;
}


- (void)bufangClick:(UIButton *)bfBtn
{
    if (bfBtn.tag == DEFENCE_STATE_OFF) {  // 开锁
        
        bfBtn.tag = DEFENCE_STATE_ON;
        
        [[P2PClient sharedClient] setRemoteDefenceWithId:self.contact.contactId password:self.contact.contactPassword state:SETTING_VALUE_REMOTE_DEFENCE_STATE_ON];
        [bfBtn setImage:[UIImage imageNamed:@"yibufang"] forState:UIControlStateNormal];
    }else
    {
        bfBtn.tag = DEFENCE_STATE_OFF;
        [[P2PClient sharedClient] setRemoteDefenceWithId:self.contact.contactId password:self.contact.contactPassword state:SETTING_VALUE_REMOTE_DEFENCE_STATE_OFF];
        [bfBtn setImage:[UIImage imageNamed:@"bufang"] forState:UIControlStateNormal];
    }
}


@end;
