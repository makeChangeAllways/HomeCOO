//
//  MessageCell.m
//  2cu
//
//  Created by mac on 15/10/23.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//

#import "MessageCell.h"
#import "Alarm.h"
#import "Utils.h"
#import "FListManager.h"
#import "Contact.h"

@interface MessageCell ()

// 报警头像
@property (retain, nonatomic) IBOutlet UIImageView *alarm_icon;

//报警设备id
@property (retain, nonatomic) IBOutlet UILabel *alarm_id;

// 报警%@
@property (retain, nonatomic) IBOutlet UILabel *typeLabel;

// 设备%@
@property (retain, nonatomic) IBOutlet UILabel *contact_event;

// 早上或者下午label
@property (retain, nonatomic) IBOutlet UILabel *morning_affternoon;

// 时间Label
@property (retain, nonatomic) IBOutlet UILabel *time_L;

@property(nonatomic,assign)int alarmType; // 报警类型

// 红色标点
@property (retain, nonatomic) IBOutlet UIButton *red_btn;

@end


@implementation MessageCell

- (void)awakeFromNib {
    // Initialization code
    
    self.red_btn.layer.cornerRadius = 2.5f;
    self.red_btn.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAlarm:(Alarm *)alarm
{
    _alarm = alarm;
    
    
    
//    self.alarm_id =
    self.alarmType = alarm.alarmType;
    
    // 报警%@
    if (self.alarmType==1){
        self.typeLabel.text = [NSString stringWithFormat:@"(%@:%@)",NSLocalizedString(@"event", nil),NSLocalizedString(@"extern_alarm", nil)];
    }else if (self.alarmType==2){
        self.typeLabel.text = [NSString stringWithFormat:@"(%@:%@)",NSLocalizedString(@"event", nil),NSLocalizedString(@"motion_dect_alarm", nil)];
        
    }else if (self.alarmType==3){
        self.typeLabel.text = [NSString stringWithFormat:@"(%@:%@)",NSLocalizedString(@"event", nil),NSLocalizedString(@"emergency_alarm", nil)];
        
    }else if (self.alarmType==4){
        self.typeLabel.text = [NSString stringWithFormat:@"(%@:%@)",NSLocalizedString(@"event", nil),NSLocalizedString(@"debug_alarm", nil)];
        
    }else if (self.alarmType==5){
        self.typeLabel.text = [NSString stringWithFormat:@"(%@:%@)",NSLocalizedString(@"event", nil),NSLocalizedString(@"ext_line_alarm", nil)];
        
    }else if (self.alarmType==6){
        self.typeLabel.text = [NSString stringWithFormat:@"(%@:%@)",NSLocalizedString(@"event", nil),NSLocalizedString(@"low_vol_alarm", nil)];
        
    }else if (self.alarmType==7){
        self.typeLabel.text = [NSString stringWithFormat:@"(%@:%@)",NSLocalizedString(@"event", nil),NSLocalizedString(@"pir_alarm", nil)];
        
    }else if (self.alarmType==8){
        self.typeLabel.text = [NSString stringWithFormat:@"(%@:%@)",NSLocalizedString(@"event", nil),NSLocalizedString(@"defence_alarm", nil)];
        
    }else if (self.alarmType==9){
        self.typeLabel.text = [NSString stringWithFormat:@"(%@:%@)",NSLocalizedString(@"event", nil),NSLocalizedString(@"defence_disable_alarm", nil)];
        
    }else if (self.alarmType==10){
        self.typeLabel.text = [NSString stringWithFormat:@"(%@:%@)",NSLocalizedString(@"event", nil),NSLocalizedString(@"battery_low_vol", nil)];
        
    }else if (self.alarmType==11){
        self.typeLabel.text = [NSString stringWithFormat:@"(%@:%@)",NSLocalizedString(@"event", nil),NSLocalizedString(@"update_to_ser", nil)];
    }else if (self.alarmType==12){
        self.typeLabel.text = [NSString stringWithFormat:@"(%@:%@)",NSLocalizedString(@"event", nil),NSLocalizedString(@"TH_ALARM", nil)];
    }else if (self.alarmType==14){
        self.typeLabel.text = [NSString stringWithFormat:@"(%@:%@)",NSLocalizedString(@"event", nil),NSLocalizedString(@"FORCE_FROM_KEYPRESS_ALARM", nil)];
    }else if (self.alarmType==16){
        self.typeLabel.text = [NSString stringWithFormat:@"(%@:%@)",NSLocalizedString(@"event", nil),NSLocalizedString(@"EMAIL_TOO_OFTEN_ALARM", nil)];
    }else if (self.alarmType==17){
        self.typeLabel.text = [NSString stringWithFormat:@"(%@:%@)",NSLocalizedString(@"event", nil),NSLocalizedString(@"UART_INPUT_ALARM", nil)];
    }else if (self.alarmType==18){
        self.typeLabel.text = [NSString stringWithFormat:@"(%@:%@)",NSLocalizedString(@"event", nil),NSLocalizedString(@"FIRE_PROBER_ALARM", nil)];
    }else if (self.alarmType==19){
        self.typeLabel.text = [NSString stringWithFormat:@"(%@:%@)",NSLocalizedString(@"event", nil),NSLocalizedString(@"GAS_PROBER_ALARM", nil)];
    }else if (self.alarmType==20){
        self.typeLabel.text = [NSString stringWithFormat:@"(%@:%@)",NSLocalizedString(@"event", nil),NSLocalizedString(@"STEAL_PROBER_ALARM", nil)];
    }else if (self.alarmType==21){
        self.typeLabel.text = [NSString stringWithFormat:@"(%@:%@)",NSLocalizedString(@"event", nil),NSLocalizedString(@"AROUND_PROBER_ALARM", nil)];
    }else if (self.alarmType==23){
        self.typeLabel.text = [NSString stringWithFormat:@"(%@:%@)",NSLocalizedString(@"event", nil),NSLocalizedString(@"I20_PROBER_ALARM", nil)];
    }else if (self.alarmType==24){
        self.typeLabel.text = [NSString stringWithFormat:@"(%@:%@)",NSLocalizedString(@"event", nil),NSLocalizedString(@"PREVENTDISCONNECT_PROBER_ALARM", nil)];
    }else if (self.alarmType==25){
        self.typeLabel.text = [NSString stringWithFormat:@"(%@:%@)",NSLocalizedString(@"event", nil),NSLocalizedString(@"COMMUNICATION_TIMING_PROBER_ALARM", nil)];
    }else if (self.alarmType==26){
        self.typeLabel.text = [NSString stringWithFormat:@"(%@:%@)",NSLocalizedString(@"event", nil),NSLocalizedString(@"LOW_POWER_PROBER_ALARM", nil)];
    }else if (self.alarmType==27){
        self.typeLabel.text = [NSString stringWithFormat:@"(%@:%@)",NSLocalizedString(@"event", nil),NSLocalizedString(@"LOW_POWER_RECOVERY_PROBER_ALARM", nil)];
    }else if (self.alarmType==28){
        self.typeLabel.text = [NSString stringWithFormat:@"(%@:%@)",NSLocalizedString(@"event", nil),NSLocalizedString(@"POWERONPROBER_ALARM", nil)];
    }else if (self.alarmType==29){
        self.typeLabel.text = [NSString stringWithFormat:@"(%@:%@)",NSLocalizedString(@"event", nil),NSLocalizedString(@"POWEROFF_PROBER_ALARM", nil)];
    }else if (self.alarmType==30){
        self.typeLabel.text = [NSString stringWithFormat:@"(%@:%@)",NSLocalizedString(@"event", nil),NSLocalizedString(@"DEF_PROBER_ALARM", nil)];
    }else if (self.alarmType==31){
        self.typeLabel.text = [NSString stringWithFormat:@"(%@:%@)",NSLocalizedString(@"event", nil),NSLocalizedString(@"DEFDIS_PROBER_ALARM", nil)];
    }else if (self.alarmType==32){
        self.typeLabel.text = [NSString stringWithFormat:@"(%@:%@)",NSLocalizedString(@"event", nil),NSLocalizedString(@"EXT_PROBER_ALARM", nil)];
    }else if (self.alarmType==33){
        self.typeLabel.text = [NSString stringWithFormat:@"(%@:%@)",NSLocalizedString(@"event", nil),NSLocalizedString(@"PROBER_ALARM", nil)];
    }
    
    // 增加报警%@格式
    
    
    
     
     /*
     *  12 - 33 alarm message translations  (6 15 10 13 15 11 12 16 25 useless )
    
    "TH_ALARM" = "温度湿报警"; // 12
    "FORCE_FROM_KEYPRESS_ALARM" = "紧急报警"; // 14
    "EMAIL_TOO_OFTEN_ALARM" = "邮箱发送过于频繁"; // 16
    "UART_INPUT_ALARM" = "串口输入报警"; // 17
    "FIRE_PROBER_ALARM" = "防火报警"; // 18
    "GAS_PROBER_ALARM" = "煤气泄漏"; // 19
    "STEAL_PROBER_ALARM" = "防盗报警"; // 20
    "AROUND_PROBER_ALARM" = "周界报警"; // 21
    "I20_PROBER_ALARM" = "医疗求救"; // 23
    "PREVENTDISCONNECT_PROBER_ALARM" = "防拆报警"; // 24
    "COMMUNICATION_TIMING_PROBER_ALARM" = "定时通讯"; // 25
    "LOW_POWER_PROBER_ALARM" = "低电报告"; // 26
    "LOW_POWER_RECOVERY_PROBER_ALARM" = "恢复地电"; // 27
    "POWERONPROBER_ALARM" = "开机报告"; // 28
    "POWEROFF_PROBER_ALARM" = "关机报告"; // 29
    "DEF_PROBER_ALARM" = "布防"; // 30
    "DEFDIS_PROBER_ALARM" = "撤防"; // 31
    "EXT_PROBER_ALARM" = "门磁报警"; // 32
     "PROBER_ALARM" = "探测器"; // 33
     */
    
    // 设备号
    NSArray *contacts = [[[FListManager sharedFList] getContacts] mutableCopy];
    for (Contact *contact in contacts) {
        if ([alarm.deviceId isEqualToString:contact.contactId]) {
            self.alarm_id.text = [NSString stringWithFormat:@"%@",contact.contactName];
        }
    }
    

    
    // 判断图片 设备%@
    if ( alarm.alarmType==8||alarm.alarmType==9 || alarm.alarmType == 30 || alarm.alarmType == 31) {
        self.alarm_icon.image = [UIImage imageNamed:@"message_removalblue.png"];
        
        if (alarm.alarmType == 8 || alarm.alarmType == 30) {
            self.contact_event.text = NSLocalizedString(@"设备已布防", nil);
        }else
        {
            self.contact_event.text = NSLocalizedString(@"设备已撤防", nil);
        }
    }else{
        self.alarm_icon.image = [UIImage imageNamed:@"message_police"];
        self.contact_event.text = NSLocalizedString(@"监控区域发生变化", nil);
    }
    
    // 判断时间
    // 日期格式
//    NSDateFormatter *format = [[NSDateFormatter alloc] init];
//    [format setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//    // 转化出的时间
//    NSDate *time_date = [NSDate dateWithTimeIntervalSince1970:[alarm.alarmTime doubleValue]];
//    NSString *time = [format stringFromDate:time_date];
    
     NSString *time = [Utils convertTimeByInterval:alarm.alarmTime];
//    NSLog(@"%@",time);
    // 时间
    NSString *time_str = [time substringFromIndex:11];
    self.time_L.text = time_str;
    
    // 上午 下午
    NSString *af = [time_str substringToIndex:2];
    if ([af intValue] >=12) {
        self.morning_affternoon.text = NSLocalizedString(@"下午", nil);
    }else
    {
        self.morning_affternoon.text = NSLocalizedString(@"上午", nil);
    }

    
    // 红点
    if (alarm.isRead == 1) {
        [self.red_btn setBackgroundColor:[UIColor clearColor]];
    }else
    {
        [self.red_btn setBackgroundColor:[UIColor redColor]];
    }
    

    
}



@end
