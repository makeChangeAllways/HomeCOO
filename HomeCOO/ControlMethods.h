//
//  ControlMethods.h
//  HomeCOO
//
//  Created by tgbus on 16/5/19.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ControlMethods : NSObject
+(NSString *)transCoding:(NSString *)string;
//+(NSString *)transCoding:(char *)string;
+(void)controlDeviceHTTPmethods:(NSString *)packets;
+(NSString *)transThemeCoding:(NSString *)string;
+(NSString *)stringToByte:(NSString *)string;
+ (NSString *)ToHex:(uint16_t)tmpid;
+(NSString *)stringFromHexString:(NSString *)hexString;
+ (NSString *)chineseStringToByte:(NSString *)string;
+(NSString *)chineseWithHexString:(NSString *)chinese;
+(NSString *)intToByte:(int)number;
/**
 *  获取当前的时间 longlong型
 *
 *  @return
 */
+(NSString *)getCurrentTime;

/**
 *  室内室外布防 控制报文
 */
+(void)indoorAndOutdoorSecurity:(NSString *)gatewayNo  deviceNo:(NSString *)deviceNo deviceTypeId:(NSInteger)DeviceTypeId  data:(NSString *)datas;
/**
 *  将毫秒时间转换成 现在的年月日时间格式；
 *
 *  @param timeStr
 *
 *  @return
 */
+(NSString *)getTimeToShowWithTimestamp:(NSString *)timeStr;
+(NSData*) hexToBytes:(NSString *)str;
+(NSString *)NSdataToString:(NSData*)data;
+(NSString *)chineseTostring:(NSString *)str;
@end
