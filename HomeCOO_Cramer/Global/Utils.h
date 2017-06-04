//
//  Utils.h
//  2cu
//
//  Created by guojunyi on 14-3-21.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>


#define  DWORD        unsigned int
#define  BYTE         unsigned char

@interface Utils:NSObject
+(Utils *)shareInstance;
+(UILabel*)getTopBarTitleView;
+(long)getCurrentTimeInterval;
+(NSString*)convertTimeByInterval:(NSString*)timeInterval;
+(NSArray*)getScreenshotFilesWithId:(NSString*)contactId;

+(void)saveScreenshotFileWithId:(NSString*)contactId data:(NSData*)data;
+(NSString*)getScreenshotFilePathWithName:(NSString*)fileName contactId:(NSString*)contactId;

+(void)saveHeaderFileWithId:(NSString*)contactId data:(NSData*)data;
+(NSString*)getHeaderFilePathWithId:(NSString*)contactId;

+(NSDateComponents*)getNowDateComponents;
+(NSDateComponents*)getDateComponentsByDate:(NSDate*)date;
+(NSString*)getPlaybackTime:(UInt64)time;
+(NSDate*)dateFromString:(NSString*)dateString;
+(NSDate*)dateFromString2:(NSString*)dateString;
+(NSString*)stringFromDate:(NSDate*)date;

+(NSString*)getDeviceTimeByIntValue:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute;

+(NSString*)getPlanTimeByIntValue:(NSInteger)planTime;

+(CGFloat)getStringWidthWithString:(NSString*)string font:(UIFont*)font maxWidth:(CGFloat)maxWidth;
+(CGFloat)getStringHeightWithString:(NSString*)string font:(UIFont*)font maxWidth:(CGFloat)maxWidth;

+(void)playMusicWithName:(NSString*)name type:(NSString*)type;
+(SystemSoundID)rePlayMusicWithName:(NSString *)name andType:(NSString *)type;
+(void)stopRePlayMusicWithSoundID:(SystemSoundID)soundID;
//@property(nonatomic,assign)SystemSoundID soundID;
+(NSTimer *)shockPhoneWithTarget:(id)aTarget selector:(SEL)aSelector;
@property(nonatomic,strong)NSTimer *shockTimer;
@end

@interface NSString(Utils)


- (NSString *)getMd5_32Bit_String;
- (BOOL) isValidateNumber;


@end
