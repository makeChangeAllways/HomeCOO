//
//  CommonFunction.h
//  yh8
//
//  Created by ppl on 12-9-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "NavigationViewController.h"

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@interface CommonFunction : NSObject

+ (void)pushViewController:(UIViewController *)viewController;
+ (void)pushViewControllerAnimated:(UIViewController *)viewController animated:(BOOL)animated;
+ (void)popViewController;
+ (void)popToRootViewController;
+ (void)popViewControllerAnimated:(BOOL)animated;
+ (void)popToViewController:(UIViewController *)viewController;
+ (void)presentModalViewController:(UIViewController *)viewController;
+ (void)dismissModalViewController;
+ (NSArray *)viewControllers;

+ (void)reLogin;

+ (void)showMessageBox:(NSString *)msg;

+ (void)showProgressView;
+ (void)dismissProgressView;

+ (NSString *)encodeURL:(NSString *)string;

+ (BOOL)validateEmail:(NSString *)email;
+ (BOOL)validatePureInt:(NSString*)string;

+ (NSString *)dateToString:(NSDate *)date;
+ (NSString *)dateToStrings:(NSDate *)date;
+ (NSDate *)stringtoDateTime:(NSString *)str;
+ (NSDate *)stringtoDate:(NSString *)str;

+ (int)ageWithDate:(NSDate *)date;
+ (int)dayWithDate:(NSDate *)date;
+ (NSString *)constellationWithDate:(NSDate *)date;

+ (UIImage *)imageWithImageSimple:(UIImage *)image scaledToSize:(CGSize)newSize;
+ (NSString *)saveTmpImage:(UIImage *)image name:(NSString *)name;

+ (UIImage *)createImageWithColor:(UIColor *)color;

+(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;

+ (NSString *)dateToTime:(NSString *)date;

+ (NSString *)dateToTimes:(NSString *)date;

+(long long) fileSizeAtPath:(NSString*) filePath;

+ (BOOL)toM4a:(NSString *)mediaURL;

+ (BOOL)isMobileNumber:(NSString *)mobileNum;

+ (NSUInteger)occurenceOfString:(NSString *)substring;

+ (NSString *)HTMLToString:(NSString *)html;
+(NSData *) dataforPath:(NSString*) filePath;
/*
 *清除指定路径文件
 */
+(BOOL)clearFile:(NSString *)path;
/*
 *论坛时间转换
 */
+(NSString *)datetobbsString:(NSString*)date;

+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font;
+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate;
@end
