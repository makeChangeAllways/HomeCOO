//
//  SettingArrowItem.h
//  SeekPath
//
//  Created by mac on 15/7/8.
//
//

#import "SettingBaseItem.h"

@interface SettingArrowItem : SettingBaseItem



/**创建一个ArrowItem */
/** 这里Placehoder用icon代替 */
+(instancetype)settingItemWithIcon:(NSString *)icon AndTitle:(NSString *)title ToDestViewControl:(NSString *)destVc;
@end
