//
//  SettingArrowItem.m
//  SeekPath
//
//  Created by mac on 15/7/8.
//
//

#import "SettingArrowItem.h"

@implementation SettingArrowItem



+(instancetype)settingItemWithIcon:(NSString *)icon AndTitle:(NSString *)title ToDestViewControl:(NSString *)destVc
{
    SettingArrowItem *arrow = [[SettingArrowItem alloc] init];
    arrow.icon = icon;
    arrow.title = title;
    arrow.destVc = destVc;
    return arrow;
}
@end
