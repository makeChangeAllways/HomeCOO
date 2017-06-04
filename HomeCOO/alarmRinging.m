//
//  alarmRinging.m
//  HomeCOO
//
//  Created by app on 16/9/17.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "alarmRinging.h"

@implementation alarmRinging

 SystemSoundID soundID;


/**
 *  报警时 弹出视图时的铃声
 */
+(void)alarmMessageBells{


    [self systemShake];

    [self createSystemSoundWithName:@"alarm" soundType:@"caf"];

    [self   playSound];
}
//调用震动
+(void)systemShake
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

//调用系统铃声
+(void)createSystemSoundWithName:(NSString *)soundName soundType:(NSString *)soundType
{
    
    NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@",soundName,soundType];
    if (path) {
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
        AudioServicesPlaySystemSound(soundID);
        
    }
    
}

/**
 *  播放音乐
 */
+(void)playSound{
    
    AudioServicesPlaySystemSound(soundID);
    
}


@end
