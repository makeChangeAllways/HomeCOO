//
//  ScreenshotCell.m
//  2cu
//
//  Created by guojunyi on 14-4-3.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import "ScreenshotCell.h"
#import "Constants.h"
#import "UDManager.h"
#import "LoginResult.h"
#import "PrefixHeader.pch"
@implementation ScreenshotCell
-(void)dealloc{
    [self.filePath1 release];
    [self.filePath2 release];
    [self.filePath3 release];
    [self.backImgView1 release];
    [self.backImgView2 release];
    [self.backImgView3 release];
    [self.backButton1 release];
    [self.backButton2 release];
    [self.backButton3 release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
#define BORDER_WIDTH 5
#define VERTICAL_MARGIN 10
-(void)layoutSubviews{ // 排列
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor redColor];
    
    CGFloat width = self.frame.size.width; // cell 宽
    CGFloat height = self.frame.size.height; // cell 高
    CGFloat itemHeight = height-VERTICAL_MARGIN*2; // 按钮高度
    CGFloat itemWidth = itemHeight*4/3;  // 按钮宽度
    CGFloat horizontalMargin = (width-itemWidth*3)/4; // 水平每个item 间距
    DLog(@"%@",self.filePath1);
    // 判断 button1 
    if(!self.backButton1){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 0;
        button.backgroundColor = [UIColor clearColor];
        // 按钮背景
        button.frame = CGRectMake(horizontalMargin*3+itemWidth*2, VERTICAL_MARGIN, itemWidth, itemHeight);
        UIImage *buttonBackImg_p = [UIImage imageNamed:@"bg_normal_cell_p.png"];
        buttonBackImg_p = [buttonBackImg_p stretchableImageWithLeftCapWidth:buttonBackImg_p.size.width*0.5 topCapHeight:buttonBackImg_p.size.height*0.5];
        
        [button setBackgroundImage:buttonBackImg_p forState:UIControlStateHighlighted];
        button.frame = CGRectMake(horizontalMargin, VERTICAL_MARGIN, itemWidth, itemHeight);
        [button addTarget:self action:@selector(onButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        self.backButton1 = button;
        
        // 图片
        UIImageView *backImgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(BORDER_WIDTH,BORDER_WIDTH, itemWidth-BORDER_WIDTH*2, itemHeight-BORDER_WIDTH*5)];
        
        backImgView1.contentMode = UIViewContentModeScaleAspectFit;
        [self loading1];
        [self.backButton1 addSubview:backImgView1];
        self.backImgView1 = backImgView1;
        [backImgView1 release];
        
        // 描述Label
        UILabel *desc_label = [[UILabel alloc] init];
        self.descLabel1 = desc_label;
        desc_label.numberOfLines = 0 ;
        desc_label.textAlignment = NSTextAlignmentCenter;
        desc_label.frame = CGRectMake(XForView(backImgView1), BottomForView(backImgView1), itemWidth-BORDER_WIDTH*2, 20);
        desc_label.font = [UIFont systemFontOfSize:8];
        [self.backButton1 addSubview:desc_label];
        desc_label.text = @"1552436 2015-09-30 17:24:45";
        
        
        
        [self.contentView addSubview:self.backButton1];
    }else{
//        self.backButton1.frame = CGRectMake(horizontalMargin, VERTICAL_MARGIN, itemWidth, itemHeight);
//        self.backImgView1.frame = CGRectMake(BORDER_WIDTH,0, itemWidth-BORDER_WIDTH*2, itemHeight-BORDER_WIDTH*2);
//        self.backImgView1.image = [UIImage imageWithContentsOfFile:self.filePath1];
////        [self loading1];
//        NSString *show_str1 = [self GetImageDescFromFilePath:self.filePath1];
//        self.descLabel1.text = show_str1;

//        [self.contentView addSubview:self.backButton1];
        
    }
    
    if(!self.backButton2){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 1;
        button.backgroundColor = [UIColor clearColor];
        button.frame = CGRectMake(horizontalMargin*3+itemWidth*2, VERTICAL_MARGIN, itemWidth, itemHeight);
        UIImage *buttonBackImg_p = [UIImage imageNamed:@"bg_normal_cell_p.png"];
        buttonBackImg_p = [buttonBackImg_p stretchableImageWithLeftCapWidth:buttonBackImg_p.size.width*0.5 topCapHeight:buttonBackImg_p.size.height*0.5];
        
        [button setBackgroundImage:buttonBackImg_p forState:UIControlStateHighlighted];
        button.frame = CGRectMake(horizontalMargin*2+itemWidth, VERTICAL_MARGIN, itemWidth, itemHeight);
        [button addTarget:self action:@selector(onButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        self.backButton2 = button;
        
        UIImageView *backImgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(BORDER_WIDTH,BORDER_WIDTH, itemWidth-BORDER_WIDTH*2, itemHeight-BORDER_WIDTH*5)];
        backImgView2.contentMode = UIViewContentModeScaleAspectFit;
        //backImgView2.image = [UIImage imageWithContentsOfFile:self.filePath2];
        [self loading2];
        [self.backButton2 addSubview:backImgView2];
        self.backImgView2 = backImgView2;
        [backImgView2 release];
        
        // 描述Label
        UILabel *desc_label = [[UILabel alloc] init];
         self.descLabel2 = desc_label;
        desc_label.frame = CGRectMake(XForView(backImgView2), BottomForView(backImgView2), itemWidth-BORDER_WIDTH*2, 20);
        desc_label.numberOfLines = 0;
        desc_label.textAlignment = NSTextAlignmentCenter;
        desc_label.font = [UIFont systemFontOfSize:8];
        [self.backButton2 addSubview:desc_label];
        desc_label.text = @"1552436 2015-09-30 17:24:45";
        

    }else{
//        self.backButton2.frame = CGRectMake(horizontalMargin*2+itemWidth, VERTICAL_MARGIN, itemWidth, itemHeight);
//        self.backImgView2.frame = CGRectMake(BORDER_WIDTH,0, itemWidth-BORDER_WIDTH*2, itemHeight-BORDER_WIDTH*2);
//        self.backImgView2.image = [UIImage imageWithContentsOfFile:self.filePath2];
//        [self loading2];
        
//        NSString *show_str2 = [self GetImageDescFromFilePath:self.filePath2];
//        self.descLabel2.text = show_str2;
    }
    
    if(!self.backButton3){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 2;
        button.backgroundColor = [UIColor clearColor];
        button.frame = CGRectMake(horizontalMargin*3+itemWidth*2, VERTICAL_MARGIN, itemWidth, itemHeight);
        UIImage *buttonBackImg_p = [UIImage imageNamed:@"bg_normal_cell_p.png"];
        buttonBackImg_p = [buttonBackImg_p stretchableImageWithLeftCapWidth:buttonBackImg_p.size.width*0.5 topCapHeight:buttonBackImg_p.size.height*0.5];
        
        [button setBackgroundImage:buttonBackImg_p forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(onButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        self.backButton3 = button;
        
        UIImageView *backImgView3 = [[UIImageView alloc] initWithFrame:CGRectMake(BORDER_WIDTH,BORDER_WIDTH, itemWidth-BORDER_WIDTH*2, itemHeight-BORDER_WIDTH*5)];
        backImgView3.contentMode = UIViewContentModeScaleAspectFit;
        //backImgView3.image = [UIImage imageWithContentsOfFile:self.filePath3];
        [self loading3];
        [self.backButton3 addSubview:backImgView3];
        self.backImgView3 = backImgView3;
        [backImgView3 release];
        
        
        // 描述Label
        UILabel *desc_label = [[UILabel alloc] init];
        self.descLabel3 = desc_label;
        desc_label.textAlignment = NSTextAlignmentCenter;
        desc_label.frame = CGRectMake(XForView(backImgView3), BottomForView(backImgView3), itemWidth-BORDER_WIDTH*2, 20);
        desc_label.numberOfLines = 0 ;
        desc_label.font = [UIFont systemFontOfSize:8];
        [self.backButton3 addSubview:desc_label];
        desc_label.text = @"1552436 2015-09-30 17:24:45";
        
       
    }else{
//        self.backButton3.frame = CGRectMake(horizontalMargin*3+itemWidth*2, VERTICAL_MARGIN, itemWidth, itemHeight);
//        self.backImgView3.frame = CGRectMake(BORDER_WIDTH,0, itemWidth-BORDER_WIDTH*2, itemHeight-BORDER_WIDTH*2);
//        self.backImgView3.image = [UIImage imageWithContentsOfFile:self.filePath3];
////        [self loading3];  //重用问题
//        NSString *show_str3 = [self GetImageDescFromFilePath:self.filePath3];
//        self.descLabel3.text = show_str3;
    }
    
    
    [self.contentView addSubview:self.backButton2];
    [self.contentView addSubview:self.backButton3];
    
    if(!self.filePath1||[self.filePath1 isEqualToString:@""]){
        [self.backButton1 setHidden:YES];
    }else{
        [self.backButton1 setHidden:NO];
    }
    
    if(!self.filePath2||[self.filePath2 isEqualToString:@""]){
        [self.backButton2 setHidden:YES];
    }else{
        [self.backButton2 setHidden:NO];
    }
    
    if(!self.filePath3||[self.filePath3 isEqualToString:@""]){
        [self.backButton3 setHidden:YES];
    }else{
        [self.backButton3 setHidden:NO];
    }
}


-(void)onButtonPress:(UIButton*)button{ // 点击图片
    if(self.delegate){
        [self.delegate onItemPress:self row:self.row index:button.tag];
    }
}

-(void)loading1{
    if(!self.isLoading1){
        self.isLoading1 = YES;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [UIImage imageWithContentsOfFile:self.filePath1];
            NSString *show_str1 = [self GetImageDescFromFilePath:self.filePath1];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.backImgView1.image = image;
                self.descLabel1.text = show_str1;
            });
        });
    }
}


- (NSString *)GetImageDescFromFilePath:(NSString *)filePath
{
    
    if (filePath.length) {
        NSRange range = [filePath rangeOfString:@"/screenshot/" options:NSBackwardsSearch];
        LoginResult *loginResult = [UDManager getLoginInfo];
        NSString *login_id = loginResult.contactId;
        int login_id_length = (int)login_id.length;
        // 裁剪 用户id
        NSRange clip_userid_range = NSMakeRange(range.location + range.length, login_id_length);
//        NSString *user_id = [filePath substringWithRange:clip_userid_range];
        
        NSRange clip_contact_range = NSMakeRange(range.location + range.length + login_id_length + 1, 7);
        NSString *contact_str = [filePath substringWithRange:clip_contact_range];
        
        NSRange clip_time_range = NSMakeRange(clip_contact_range.location + 7, 10);
        NSString *time_str = [filePath substringWithRange:clip_time_range];
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
        [format setTimeZone:timeZone];
        [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time_str.doubleValue];
        
        NSString *time = [format stringFromDate:date];
        
//        NSString *time = [Utils convertTimeByInterval:time_str];
        
        NSString *show_str = [NSString stringWithFormat:@"%@ %@",contact_str,time];
        return show_str;

    }
    return @"";
    
}


//  /var/mobile/Applications/03C0949B-443E-4831-9AC8-E4FDE203FD77/Documents/screenshot/0711574/1445310712.png

-(void)loading2{
    if(!self.isLoading2){
        self.isLoading2 = YES;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [UIImage imageWithContentsOfFile:self.filePath2];
             NSString *show_str2 = [self GetImageDescFromFilePath:self.filePath2];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.backImgView2.image = image;
                self.descLabel2.text = show_str2;
            });
        });
    }
}

-(void)loading3{
    if(!self.isLoading3){
        self.isLoading3 = YES;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [UIImage imageWithContentsOfFile:self.filePath3];
             NSString *show_str3 = [self GetImageDescFromFilePath:self.filePath3];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.backImgView3.image = image;
                self.descLabel3.text = show_str3;
            });
        });
    }
}
@end
