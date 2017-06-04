//
//  SettingBaseItem.m
//  SeekPath
//
//  Created by mac on 15/7/8.
//
//

#import "SettingBaseItem.h"

@implementation SettingBaseItem
+ (instancetype)settingViewWithIcon:(NSString *)icon AndTitle:(NSString *)title
{
    SettingBaseItem *base = [[self alloc] init];
    base.icon = icon;
    base.title = title;
    return base;
}
@end
