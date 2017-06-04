//
//  AlarmHistoryCell.m
//  2cu
//
//  Created by Jie on 14-10-22.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import "AlarmHistoryCell.h"
#import "Constants.h"
#import "PrefixHeader.pch"
@implementation AlarmHistoryCell

-(void)dealloc{
    [self.typeLabel release];
    [self.typeLabelText release];
    [self.deviceLabel release];
    [self.deviceLabelText release];
    [self.timeLabel release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#define LABEL_WIDTH 165
#define TYPE_LABEL_WIDTH 220
#define LABEL_HEIGHT 25
#define TIME_LABEL_WIDTH 150
#define TEXT_LABERL_WIDTH 150

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat width = self.backgroundView.frame.size.width;
    CGFloat height = self.backgroundView.frame.size.height;
    
    
    if (!self.leftview) {
        UIImageView*imageview=[[UIImageView alloc]init];
        imageview.frame=CGRectMake(5, 5, 1.25*(HeightForView(self.contentView)-10), HeightForView(self.contentView)-10);
        [self.contentView addSubview:imageview];
        imageview.image=self.leftimg;
        self.leftview=imageview;
    }else{
        self.leftview=[[UIImageView alloc]init];
        self.leftview.frame=CGRectMake(5, 5, 1.25*(HeightForView(self.contentView)-10), HeightForView(self.contentView)-10);
        [self.contentView addSubview:self.leftview];
        self.leftview.image=self.leftimg;
    }
    
    
    
    if (!self.deviceLabel) {
//        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 3, LABEL_WIDTH, LABEL_HEIGHT)];
         UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 3, LABEL_WIDTH, LABEL_HEIGHT)];
        textLabel.textAlignment = NSTextAlignmentLeft;
        textLabel.textColor = XBlack;
        textLabel.backgroundColor = XBGAlpha;
        [textLabel setFont:XFontBold_16];
        textLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"alarm_device", nil),self.deviceId];
        
        
        [self.contentView addSubview:textLabel];
        self.deviceLabel = textLabel;
        [textLabel release];
    }else{
//        self.deviceLabel.frame = CGRectMake(5, 3, LABEL_WIDTH, LABEL_HEIGHT);
        self.deviceLabel.frame = CGRectMake(75, 3, LABEL_WIDTH, LABEL_HEIGHT);
        self.deviceLabel.textAlignment = NSTextAlignmentLeft;
        self.deviceLabel.textColor = XBlack;
        self.deviceLabel.backgroundColor = XBGAlpha;
        [self.deviceLabel setFont:XFontBold_16];
        self.deviceLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"alarm_device", nil),self.deviceId];
        
        [self.contentView addSubview:self.deviceLabel];
    }
    
    if (!self.typeLabel) {
//        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 3+LABEL_HEIGHT+10, TYPE_LABEL_WIDTH, LABEL_HEIGHT)];
        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 3+LABEL_HEIGHT+10, TYPE_LABEL_WIDTH, LABEL_HEIGHT)];
        textLabel.textAlignment = NSTextAlignmentLeft;
        textLabel.textColor = XBlack;
        textLabel.backgroundColor = XBGAlpha;
        [textLabel setFont:XFontBold_16];
        if (self.alarmType==1){
            textLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"alarm_type", nil),NSLocalizedString(@"extern_alarm", nil)];
        }else if (self.alarmType==2){
            textLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"alarm_type", nil),NSLocalizedString(@"motion_dect_alarm", nil)];
            
        }else if (self.alarmType==3){
            textLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"alarm_type", nil),NSLocalizedString(@"emergency_alarm", nil)];
            
        }else if (self.alarmType==4){
            textLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"alarm_type", nil),NSLocalizedString(@"debug_alarm", nil)];
            
        }else if (self.alarmType==5){
            textLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"alarm_type", nil),NSLocalizedString(@"ext_line_alarm", nil)];
            
        }else if (self.alarmType==6){
            textLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"alarm_type", nil),NSLocalizedString(@"low_vol_alarm", nil)];
            
        }else if (self.alarmType==7){
            textLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"alarm_type", nil),NSLocalizedString(@"pir_alarm", nil)];
            
        }else if (self.alarmType==8){
            textLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"alarm_type", nil),NSLocalizedString(@"defence_alarm", nil)];
            
        }else if (self.alarmType==9){
            textLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"alarm_type", nil),NSLocalizedString(@"defence_disable_alarm", nil)];
            
        }else if (self.alarmType==10){
            textLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"alarm_type", nil),NSLocalizedString(@"battery_low_vol", nil)];
            
        }else if (self.alarmType==11){
            textLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"alarm_type", nil),NSLocalizedString(@"update_to_ser", nil)];
            
        }

        
        [self.contentView addSubview:textLabel];
        self.typeLabel = textLabel;
        [textLabel release];
    }else{
//        self.typeLabel.frame = CGRectMake(5, 3+LABEL_HEIGHT+10, TYPE_LABEL_WIDTH, LABEL_HEIGHT);
        self.typeLabel.frame = CGRectMake(75, 3+LABEL_HEIGHT+10, TYPE_LABEL_WIDTH, LABEL_HEIGHT);
        self.typeLabel.textAlignment = NSTextAlignmentLeft;
        self.typeLabel.textColor = XBlack;
        self.typeLabel.backgroundColor = XBGAlpha;
        [self.typeLabel setFont:XFontBold_16];
        if (self.alarmType==1){
            self.typeLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"alarm_type", nil),NSLocalizedString(@"extern_alarm", nil)];
        }else if (self.alarmType==2){
            self.typeLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"alarm_type", nil),NSLocalizedString(@"motion_dect_alarm", nil)];
            
        }else if (self.alarmType==3){
            self.typeLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"alarm_type", nil),NSLocalizedString(@"emergency_alarm", nil)];
            
        }else if (self.alarmType==4){
            self.typeLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"alarm_type", nil),NSLocalizedString(@"debug_alarm", nil)];
            
        }else if (self.alarmType==5){
            self.typeLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"alarm_type", nil),NSLocalizedString(@"ext_line_alarm", nil)];
            
        }else if (self.alarmType==6){
            self.typeLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"alarm_type", nil),NSLocalizedString(@"low_vol_alarm", nil)];
            
        }else if (self.alarmType==7){
            self.typeLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"alarm_type", nil),NSLocalizedString(@"pir_alarm", nil)];
            
        }else if (self.alarmType==8){
            self.typeLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"alarm_type", nil),NSLocalizedString(@"defence_alarm", nil)];
            
        }else if (self.alarmType==9){
            self.typeLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"alarm_type", nil),NSLocalizedString(@"defence_disable_alarm", nil)];
            
        }else if (self.alarmType==10){
            self.typeLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"alarm_type", nil),NSLocalizedString(@"battery_low_vol", nil)];
            
        }else if (self.alarmType==11){
            self.typeLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"alarm_type", nil),NSLocalizedString(@"update_to_ser", nil)];
            
        }

        
        [self.contentView addSubview:self.typeLabel];
    }

    if (!self.timeLabel) {
        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(VIEWWIDTH-100-5, 3, 90, 57)];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = XBlack;
        textLabel.backgroundColor = XBGAlpha;
        [textLabel setFont:XFontBold_16];
        textLabel.text = self.alarmTime;
        textLabel.numberOfLines=0;

        
        [self.contentView addSubview:textLabel];
        self.timeLabel = textLabel;
        [textLabel release];
    }else{
//        self.timeLabel.frame = CGRectMake(VIEWWIDTH-LABEL_WIDTH-5, 3, TIME_LABEL_WIDTH, LABEL_HEIGHT);
        self.timeLabel.frame = CGRectMake(VIEWWIDTH-100-5, 3, 90, 57);
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        self.timeLabel.textColor = XBlack;
        self.timeLabel.backgroundColor = XBGAlpha;
        [self.timeLabel setFont:XFontBold_16];
        self.timeLabel.text = self.alarmTime;
        self.timeLabel.numberOfLines=0;
        
        [self.contentView addSubview:self.timeLabel];
    }

//    if (!self.deviceLabelText) {
//        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.deviceLabel.frame.origin.x+LABEL_WIDTH+3, 3+LABEL_HEIGHT+10, TEXT_LABERL_WIDTH, LABEL_HEIGHT)];
//        
//        textLabel.textAlignment = NSTextAlignmentLeft;
//        textLabel.textColor = XBlack;
//        textLabel.backgroundColor = XBGAlpha;
//        [textLabel setFont:XFontBold_16];
//        textLabel.text = self.deviceId;
//        
//        [self.contentView addSubview:textLabel];
//        self.deviceLabelText = textLabel;
//        [textLabel release];
//    }else{
//        self.deviceLabelText.frame = CGRectMake(self.deviceLabel.frame.origin.x+LABEL_WIDTH+3, 3+LABEL_HEIGHT+10, TEXT_LABERL_WIDTH, LABEL_HEIGHT);
//        self.deviceLabelText.textAlignment = NSTextAlignmentLeft;
//        self.deviceLabelText.textColor = XBlack;
//        self.deviceLabelText.backgroundColor = XBGAlpha;
//        [self.deviceLabelText setFont:XFontBold_16];
//        self.deviceLabelText.text = self.deviceId;
//        
//        [self.contentView addSubview:self.deviceLabelText];
//    }
    
//    if (!self.typeLabelText) {
//        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.typeLabel.frame.origin.x+LABEL_WIDTH+3, 3+LABEL_HEIGHT+10, TEXT_LABERL_WIDTH, LABEL_HEIGHT)];
//        
//        textLabel.textAlignment = NSTextAlignmentLeft;
//        textLabel.textColor = XBlack;
//        textLabel.backgroundColor = XBGAlpha;
//        [textLabel setFont:XFontBold_16];
//        if (self.alarmType==1){
//            textLabel.text = NSLocalizedString(@"extern_alarm", nil);
//            
//        }else if (self.alarmType==2){
//            textLabel.text = NSLocalizedString(@"motion_dect_alarm", nil);
//            
//        }else if (self.alarmType==3){
//            textLabel.text = NSLocalizedString(@"emergency_alarm", nil);
//            
//        }else if (self.alarmType==5){
//            textLabel.text = NSLocalizedString(@"ext_line_alarm", nil);
//            
//        }else if (self.alarmType==6){
//            textLabel.text = NSLocalizedString(@"low_vol_alarm", nil);
//            
//        }else if (self.alarmType==7){
//            textLabel.text = NSLocalizedString(@"pir_alarm", nil);
//            
//        }
//        
//        [self.contentView addSubview:textLabel];
//        self.typeLabelText = textLabel;
//        [textLabel release];
//    }else{
//        self.typeLabelText.frame = CGRectMake(self.typeLabel.frame.origin.x+LABEL_WIDTH+3, 3+LABEL_HEIGHT+10, TEXT_LABERL_WIDTH, LABEL_HEIGHT);
//        self.typeLabelText.textAlignment = NSTextAlignmentLeft;
//        self.typeLabelText.textColor = XBlack;
//        self.typeLabelText.backgroundColor = XBGAlpha;
//        [self.typeLabelText setFont:XFontBold_16];
//        if (self.alarmType==1){
//            self.typeLabelText.text = NSLocalizedString(@"extern_alarm", nil);
//            
//        }else if (self.alarmType==2){
//            self.typeLabelText.text = NSLocalizedString(@"motion_dect_alarm", nil);
//            
//        }else if (self.alarmType==3){
//            self.typeLabelText.text = NSLocalizedString(@"emergency_alarm", nil);
//            
//        }else if (self.alarmType==5){
//            self.typeLabelText.text = NSLocalizedString(@"ext_line_alarm", nil);
//
//        }else if (self.alarmType==6){
//            self.typeLabelText.text = NSLocalizedString(@"low_vol_alarm", nil);
//
//        }else if (self.alarmType==7){
//            self.typeLabelText.text = NSLocalizedString(@"pir_alarm", nil);
//
//        }
//        
//        [self.contentView addSubview:self.typeLabelText];
//    }

}

@end
