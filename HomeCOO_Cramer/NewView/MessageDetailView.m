//
//  MessageDetailView.m
//  2cu
//
//  Created by mac on 15/10/29.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//

#import "MessageDetailView.h"
#include "MessageDetailView.h"
#import "Alarm.h"
#import "Utils.h"
#import "FListManager.h"
#import "PrefixHeader.pch"
#define RGC173 ColorWithRGB(173, 173, 173)
@interface MessageDetailView ()

@property (retain, nonatomic) IBOutlet UILabel *Alarm_Event;

@property (retain, nonatomic) IBOutlet UILabel *Contact_Name;

@property (retain, nonatomic) IBOutlet UILabel *Contact_ID;

@property (retain, nonatomic) IBOutlet UILabel *time_L;

@property (retain, nonatomic) IBOutlet UILabel *Alarm_Content;

@end

@implementation MessageDetailView

- (void)awakeFromNib
{
    self.Alarm_Event.font = [UIFont systemFontOfSize:19];
    self.Alarm_Event.font = [UIFont boldSystemFontOfSize:19];
    
    
    self.Contact_Name.textColor = RGC173;
    self.Contact_Name.textColor = RGC173;
    self.time_L.textColor = RGC173;
    self.Alarm_Content.textColor = RGC173;
}

- (void)setAlarm:(Alarm *)alarm
{
    // 判断 报警类型
    _alarm = alarm;
    
    // 报警%@
    if (self.alarm.alarmType==1){
        self.Alarm_Event.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"event", nil),NSLocalizedString(@"extern_alarm", nil)];
    }else if (self.alarm.alarmType==2){
        self.Alarm_Event.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"event", nil),NSLocalizedString(@"motion_dect_alarm", nil)];
        
    }else if (self.alarm.alarmType==3){
        self.Alarm_Event.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"event", nil),NSLocalizedString(@"emergency_alarm", nil)];
        
    }else if (self.alarm.alarmType==4){
        self.Alarm_Event.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"event", nil),NSLocalizedString(@"debug_alarm", nil)];
        
    }else if (self.alarm.alarmType==5){
        self.Alarm_Event.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"event", nil),NSLocalizedString(@"ext_line_alarm", nil)];
        
    }else if (self.alarm.alarmType==6){
        self.Alarm_Event.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"event", nil),NSLocalizedString(@"low_vol_alarm", nil)];
        
    }else if (self.alarm.alarmType==7){
        self.Alarm_Event.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"event", nil),NSLocalizedString(@"pir_alarm", nil)];
        
    }else if (self.alarm.alarmType==8){
        self.Alarm_Event.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"event", nil),NSLocalizedString(@"defence_alarm", nil)];
        
    }else if (self.alarm.alarmType==9){
        self.Alarm_Event.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"event", nil),NSLocalizedString(@"defence_disable_alarm", nil)];
        
    }else if (self.alarm.alarmType==10){
        self.Alarm_Event.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"event", nil),NSLocalizedString(@"battery_low_vol", nil)];
        
    }else if (self.alarm.alarmType==11){
        self.Alarm_Event.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"event", nil),NSLocalizedString(@"update_to_ser", nil)];
    }else if (self.alarm.alarmType==12){
        self.Alarm_Event.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"event", nil),NSLocalizedString(@"TH_ALARM", nil)];
    }else if (self.alarm.alarmType==14){
        self.Alarm_Event.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"event", nil),NSLocalizedString(@"FORCE_FROM_KEYPRESS_ALARM", nil)];
    }else if (self.alarm.alarmType==16){
        self.Alarm_Event.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"event", nil),NSLocalizedString(@"EMAIL_TOO_OFTEN_ALARM", nil)];
    }else if (self.alarm.alarmType==17){
        self.Alarm_Event.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"event", nil),NSLocalizedString(@"UART_INPUT_ALARM", nil)];
    }else if (self.alarm.alarmType==18){
        self.Alarm_Event.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"event", nil),NSLocalizedString(@"FIRE_PROBER_ALARM", nil)];
    }else if (self.alarm.alarmType==19){
        self.Alarm_Event.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"event", nil),NSLocalizedString(@"GAS_PROBER_ALARM", nil)];
    }else if (self.alarm.alarmType==20){
        self.Alarm_Event.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"event", nil),NSLocalizedString(@"STEAL_PROBER_ALARM", nil)];
    }else if (self.alarm.alarmType==21){
        self.Alarm_Event.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"event", nil),NSLocalizedString(@"AROUND_PROBER_ALARM", nil)];
    }else if (self.alarm.alarmType==23){
        self.Alarm_Event.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"event", nil),NSLocalizedString(@"I20_PROBER_ALARM", nil)];
    }else if (self.alarm.alarmType==24){
        self.Alarm_Event.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"event", nil),NSLocalizedString(@"PREVENTDISCONNECT_PROBER_ALARM", nil)];
    }else if (self.alarm.alarmType==25){
        self.Alarm_Event.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"event", nil),NSLocalizedString(@"COMMUNICATION_TIMING_PROBER_ALARM", nil)];
    }else if (self.alarm.alarmType==26){
        self.Alarm_Event.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"event", nil),NSLocalizedString(@"LOW_POWER_PROBER_ALARM", nil)];
    }else if (self.alarm.alarmType==27){
        self.Alarm_Event.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"event", nil),NSLocalizedString(@"LOW_POWER_RECOVERY_PROBER_ALARM", nil)];
    }else if (self.alarm.alarmType==28){
        self.Alarm_Event.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"event", nil),NSLocalizedString(@"POWERONPROBER_ALARM", nil)];
    }else if (self.alarm.alarmType==29){
        self.Alarm_Event.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"event", nil),NSLocalizedString(@"POWEROFF_PROBER_ALARM", nil)];
    }else if (self.alarm.alarmType==30){
        self.Alarm_Event.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"event", nil),NSLocalizedString(@"DEF_PROBER_ALARM", nil)];
    }else if (self.alarm.alarmType==31){
        self.Alarm_Event.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"event", nil),NSLocalizedString(@"DEFDIS_PROBER_ALARM", nil)];
    }else if (self.alarm.alarmType==32){
        self.Alarm_Event.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"event", nil),NSLocalizedString(@"EXT_PROBER_ALARM", nil)];
    }else if (self.alarm.alarmType==33){
        self.Alarm_Event.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"event", nil),NSLocalizedString(@"PROBER_ALARM", nil)];
    }
    
    
    // 设备名
    NSMutableArray *contacts = [[NSMutableArray alloc] initWithArray:[[FListManager sharedFList] getContacts]];
    for (Contact *cont in contacts) {
        if ([cont.contactId isEqualToString:alarm.deviceId]) {
            self.Contact_Name.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"device", nil),cont.contactName];
        }
    }
    
    // 设备ID
    self.Contact_ID.text = [NSString stringWithFormat:@"%@ID:%@",NSLocalizedString(@"device", nil),alarm.deviceId];
    
    // 时间
    self.time_L.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"时间", nil),[Utils convertTimeByInterval:alarm.alarmTime]];
    
    
    if (alarm.alarmType==8) {
        self.Alarm_Content.text = NSLocalizedString(@"内容详情:设备已布防", nil);
        
    }else if(alarm.alarmType==9){
         self.Alarm_Content.text = NSLocalizedString(@"内容详情:设备已撤防", nil);
    }else
    {
         self.Alarm_Content.text = NSLocalizedString(@"内容详情:监控区域发生变化", nil);
    }
    
    

}
@end
