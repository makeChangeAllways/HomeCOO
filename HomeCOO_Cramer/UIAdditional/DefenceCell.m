//
//  DefenceCell.m
//  2cu
//
//  Created by gwelltime on 14-11-13.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import "DefenceCell.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "PrefixHeader.pch"
@interface DefenceCell ()




@end

@implementation DefenceCell



-(void)dealloc{
    [self.leftButton release];
    [self.indexLabel release];
    [self.delImageView release];
    [self.learnCodeLabel release];
    [self.index release];
    [self.progressView release];
    [self.progressView2 release];
    [super dealloc];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#define LEFT_BUTTON_WIDTH 100
#define INDEX_LABEL_WIDTH 20
#define LEARN_CODE_WIDTH 100
#define PROGRESS_WIDTH_HEIGHT 32
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat cellWidth = self.backgroundView.frame.size.width;
    CGFloat cellHeight = self.backgroundView.frame.size.height;
    
    /*
    // 未知
    if (!self.leftButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(30, 0, LEFT_BUTTON_WIDTH, BAR_BUTTON_HEIGHT);
        [button setImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"2"] forState:UIControlStateSelected];
        button.selected = self.isSelectedButton;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        self.leftButton = button;
        [self.leftButton setHidden:self.isLeftButtonHidden];
    }else{
        self.leftButton.frame = CGRectMake(30, 0, LEFT_BUTTON_WIDTH, BAR_BUTTON_HEIGHT);
        [self.leftButton setImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
        [self.leftButton setImage:[UIImage imageNamed:@"2"] forState:UIControlStateSelected];
        self.leftButton.selected = self.isSelectedButton;
        [self.leftButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.leftButton = self.leftButton;
        [self.contentView addSubview:self.leftButton];
        [self.leftButton setHidden:self.isLeftButtonHidden];
    }
     
     */
    
    
    // 防区的名字
    if (!self.indexLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        if (self.isLeftButtonHidden && self.isProgressViewHidden) {
            label.frame = CGRectMake(30, 0, LEFT_BUTTON_WIDTH, BAR_BUTTON_HEIGHT);
        }else{
           label.frame = CGRectMake(30, 0, LEFT_BUTTON_WIDTH, BAR_BUTTON_HEIGHT);
        }
        label.backgroundColor = [UIColor clearColor];
        label.text = self.index;
        label.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:label];
        self.indexLabel = label;
        [label release];
        
    }else{
        
        if (self.isLeftButtonHidden && self.isProgressViewHidden) {
            self.indexLabel.frame = CGRectMake(30, 0, LEFT_BUTTON_WIDTH, BAR_BUTTON_HEIGHT);
        }else{
            self.indexLabel.frame = CGRectMake(30, 0, LEFT_BUTTON_WIDTH, BAR_BUTTON_HEIGHT);
        }
        self.indexLabel.backgroundColor = [UIColor clearColor];
        self.indexLabel.text =self.index;
        self.indexLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.indexLabel];
    }
    
    // 对码
    if (!self.learnCodeLabel) {
//        UILabel *learnLabel = [[UILabel alloc] initWithFrame:CGRectMake(cellWidth-120, 0, LEARN_CODE_WIDTH, BAR_BUTTON_HEIGHT)];
         UILabel *learnLabel = [[UILabel alloc] initWithFrame:CGRectMake(cellWidth-90, 8, 60, 30)];
        
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *current_language = [languages objectAtIndex:0];
        if ([current_language isEqualToString:@"en"]) { // english
            
            learnLabel.frame = CGRectMake(cellWidth - 120, 8, 90, 30);
        }
        learnLabel.backgroundColor = [UIColor clearColor];
//        learnLabel.text = NSLocalizedString(@"learn_code", nil);
        learnLabel.text = NSLocalizedString(@"对码", nil);
        learnLabel.textColor=[UIColor colorWithRed:109/255.0 green:161/255.0 blue:219/255.0 alpha:1.0];
        learnLabel.layer.borderWidth=0.5;
        learnLabel.layer.borderColor=[UIColor colorWithRed:109/255.0 green:161/255.0 blue:219/255.0 alpha:1.0].CGColor;
        learnLabel.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:learnLabel];
        self.learnCodeLabel = learnLabel;
        [learnLabel release];
        [self.learnCodeLabel setHidden:self.isLearnCodeLabelHidden];
    }else{
//        self.learnCodeLabel.frame = CGRectMake(cellWidth-120, 0, LEARN_CODE_WIDTH, BAR_BUTTON_HEIGHT);
        self.learnCodeLabel.frame = CGRectMake(cellWidth-90, 8, 60, 30);
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *current_language = [languages objectAtIndex:0];
        if ([current_language isEqualToString:@"en"]) { // english
            
            self.learnCodeLabel.frame = CGRectMake(cellWidth - 120, 8, 90, 30);
        }
        self.learnCodeLabel.backgroundColor = [UIColor clearColor];
//        self.learnCodeLabel.text = NSLocalizedString(@"learn_code", nil);
        self.learnCodeLabel.text = NSLocalizedString(@"对码", nil);
        self.learnCodeLabel.textColor=[UIColor colorWithRed:109/255.0 green:161/255.0 blue:219/255.0 alpha:1.0];
        self.learnCodeLabel.layer.borderWidth=0.5;
        self.learnCodeLabel.layer.borderColor=[UIColor colorWithRed:109/255.0 green:161/255.0 blue:219/255.0 alpha:1.0].CGColor;
        self.learnCodeLabel.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:self.learnCodeLabel];
        [self.learnCodeLabel setHidden:self.isLearnCodeLabelHidden];
    }
    
    
    /*
    // 未知
    if (!self.delImageView) {
        UIImage *image = [UIImage imageNamed:@"3"];
        
        UIImageView *delImageView = [[UIImageView alloc] initWithFrame:CGRectMake(cellWidth-image.size.width-30, (cellHeight-image.size.height)/2, image.size.width, image.size.height)];
        delImageView.image = image;
        [self.contentView addSubview:delImageView];
        self.delImageView = delImageView;
        [delImageView release];
        [self.delImageView setHidden:self.isDelImageViewHidden];
    }else{
         UIImage *image = [UIImage imageNamed:@"3"];
        
        self.delImageView.frame = CGRectMake(cellWidth-image.size.width-30, (cellHeight-image.size.height)/2, image.size.width, image.size.height);
        self.delImageView.image = image;
        [self.contentView addSubview:self.delImageView];
        [self.delImageView setHidden:self.isDelImageViewHidden];
    }
     
     */
    
    /*
    // 未知
    if(!self.isProgressViewHidden){
        if(!self.progressView){
            UIActivityIndicatorView *progressView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            progressView.frame = CGRectMake(30, 0, LEFT_BUTTON_WIDTH, BAR_BUTTON_HEIGHT);
            [progressView setHidden:self.isProgressViewHidden];
            [self.contentView addSubview:progressView];
            [progressView startAnimating];
            self.progressView = progressView;
            [progressView release];
            [self.progressView setHidden:self.isProgressViewHidden];
        }else{
            self.progressView.frame = CGRectMake(30, 0, LEFT_BUTTON_WIDTH, BAR_BUTTON_HEIGHT);
            [self.progressView setHidden:self.isProgressViewHidden];
            [self.contentView addSubview:self.progressView];
            [self.progressView startAnimating];
        }
        
    }else{
        [self.progressView removeFromSuperview];
        self.progressView = nil;
    }
     
     */
    
    
    // 点击对码后 对码那里的 菊花
    if(!self.isProgressViewHidden2){
        UIImage *image = [UIImage imageNamed:@"3"];
        if(!self.progressView2){
            UIActivityIndicatorView *progressView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            progressView.frame = CGRectMake(cellWidth-image.size.width-30, (cellHeight-image.size.height)/2, image.size.width, image.size.height);
            [progressView setHidden:self.isProgressViewHidden2];
            [self.contentView addSubview:progressView];
            [progressView startAnimating];
            self.progressView2 = progressView;
            [progressView release];
            [self.progressView2 setHidden:self.isProgressViewHidden2];
        }else{
            self.progressView2.frame = CGRectMake(cellWidth-image.size.width-30, (cellHeight-image.size.height)/2, image.size.width, image.size.height);
            [self.progressView2 setHidden:self.isProgressViewHidden2];
            [self.contentView addSubview:self.progressView2];
            [self.progressView2 startAnimating];
        }
        
    }else{
        [self.progressView2 removeFromSuperview];
        self.progressView2 = nil;
    }
     
    
    UIImageView*img=[[UIImageView alloc]init];
    img.backgroundColor=XBgColor;
    img.frame=CGRectMake(0, BAR_BUTTON_HEIGHT-1,VIEWWIDTH,0.5);
    [self.contentView addSubview:img];
    
    
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    
    
    // 设置名称
    if (!self.setname) {
        
       
        
        UIButton *learnLabel = [[UIButton alloc] init];
        
        if ([currentLanguage isEqualToString:@"en"]) { // 英文
            
            learnLabel.frame = CGRectMake(cellWidth-170, 8, 150, 30);
        }else
        {
            learnLabel.frame = CGRectMake(cellWidth-150, 8, 90, 30);
        }
        learnLabel.backgroundColor = [UIColor clearColor];
        [learnLabel setTitleColor:[UIColor colorWithRed:109/255.0 green:161/255.0 blue:219/255.0 alpha:1.0] forState:UIControlStateNormal];
        [learnLabel setTitle:NSLocalizedString(@"设置名称", nil) forState:UIControlStateNormal];
        learnLabel.layer.borderWidth=0.5;
        learnLabel.layer.borderColor=[UIColor colorWithRed:109/255.0 green:161/255.0 blue:219/255.0 alpha:1.0].CGColor;
        [self.contentView addSubview:learnLabel];
        [learnLabel addTarget:self action:@selector(setname:) forControlEvents:UIControlEventTouchUpInside];
        self.setname = learnLabel;
        [self.setname setHidden:self.isSetnameHidden];
    }else{
        UIButton *learnLabel = [[UIButton alloc] init];
        
        if ([currentLanguage isEqualToString:@"en"]) { // 英文
            
            learnLabel.frame = CGRectMake(cellWidth-170, 8, 150, 30);
        }else
        {
            learnLabel.frame = CGRectMake(cellWidth-150, 8, 90, 30);
        }
        self.setname.backgroundColor = [UIColor clearColor];
        //        self.learnCodeLabel.text = NSLocalizedString(@"learn_code", nil);
        [self.setname setTitle:NSLocalizedString(@"设置名称", nil) forState:UIControlStateNormal];
        [self.setname setTitleColor:[UIColor colorWithRed:109/255.0 green:161/255.0 blue:219/255.0 alpha:1.0] forState:UIControlStateNormal];
//        self.setname.textColor=[UIColor colorWithRed:109/255.0 green:161/255.0 blue:219/255.0 alpha:1.0];
        self.setname.layer.borderWidth=0.5;
        self.setname.layer.borderColor=[UIColor colorWithRed:109/255.0 green:161/255.0 blue:219/255.0 alpha:1.0].CGColor;
        [self.contentView addSubview:self.setname];
        [self.setname addTarget:self action:@selector(setname:) forControlEvents:UIControlEventTouchUpInside];
        [self.setname setHidden:self.isSetnameHidden];
        
    }
     
     
     

    
}
-(void)setname:(UIButton*)button{
    if (self.delegate) {
        [self.delegate setname:self section:self.section row:self.row];
    }

}
-(void)setSetnameHidden:(BOOL)hidden{
    
    self.isSetnameHidden = hidden;
    if (self.setname) {
        [self.setname setHidden:hidden];
    }

}
-(void)buttonClick:(UIButton *)button{
    if (self.delegate) {
        [self.delegate defenceCell:self section:self.section row:self.row];
    }
}

-(void)setLeftButtonHidden:(BOOL)hidden{
    self.isLeftButtonHidden = hidden;
    if (self.leftButton) {
        [self.leftButton setHidden:hidden];
    }
}
-(void)setDelImageViewHidden:(BOOL)hidden
{
    self.isDelImageViewHidden = hidden;
    if (self.delImageView) {
        [self.delImageView setHidden:hidden];
    }
}
-(void)setLearnCodeLabelHidden:(BOOL)hidden{
    self.isLearnCodeLabelHidden = hidden;
    if (self.learnCodeLabel) {
        [self.learnCodeLabel setHidden:hidden];
    }
}
-(void)setProgressViewHidden:(BOOL)hidden{
    self.isProgressViewHidden = hidden;
    if(self.progressView){
        [self.progressView setHidden:hidden];
        
    }
}
-(void)setProgressViewHidden2:(BOOL)hidden{
    self.isProgressViewHidden2 = hidden;
    if(self.progressView2){
        [self.progressView2 setHidden:hidden];
        
    }
}

@end
