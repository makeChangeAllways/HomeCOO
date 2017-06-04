//
//  SettingBaseItem.h
//  SeekPath
//
//  Created by mac on 15/7/8.
//
//
typedef void (^settingBlock)();
#import <Foundation/Foundation.h>

@interface SettingBaseItem : NSObject

@property (nonatomic,copy) NSString *icon;

@property (nonatomic,copy) NSString *title;


@property(nonatomic,strong)settingBlock block1;

//目标控制器
@property (nonatomic,assign) NSString *destVc;
+(instancetype)settingViewWithIcon:(NSString *)icon AndTitle:(NSString *)title;


@end
