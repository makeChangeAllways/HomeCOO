//
//  transCodingMethods.m
//  HomeCOO
//
//  Created by tgbus on 16/7/17.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "transCodingMethods.h"

@implementation transCodingMethods

/**
 *  00 -0 64-1 转码
 *
 *  @param string 字符数组
 *
 *  @return 字符串
 */
+(NSString *)transCodingFromServer:(NSString *)string{
    
    //将字符数组转换成string
    NSString *devicePacket =string; //[NSString stringWithCString:string encoding:NSASCIIStringEncoding];
    
    //NSLog(@"devicePacket is %@", devicePacket);
    //取出每个字符串
    NSString *s1;
    NSString *s2;
    NSString *s3;
    NSString *s4;
    
    //将字符串转成00 或者64
    NSString * string_1;
    NSString * string_2;
    NSString * string_3;
    NSString * string_4;
    
    //拼接字符串
    NSString  *str;
    NSString  *str1;
    NSString  *str2;
    
    
    NSUInteger length=  [devicePacket  length];
    switch (length) {
        case 2:
            s1 = [devicePacket substringWithRange:NSMakeRange(0, 2)];
            
            if ([s1 isEqualToString:@"64"]) {
                NSRange range = NSMakeRange(0, 2);
                
                string_1 =   [s1  stringByReplacingCharactersInRange:range withString:@"1"];
                
                
            }
            if ([s1 isEqualToString:@"00"]) {
                
                NSRange range = NSMakeRange(0, 2);
                string_1 =   [s1  stringByReplacingCharactersInRange:range withString:@"0"];
                
            }
            str = string_1;
            
            break;
        case 4:
            
            s1 = [devicePacket substringWithRange:NSMakeRange(0, 2)];
            s2 = [devicePacket substringWithRange:NSMakeRange(2, 2)];
            if ([s1 isEqualToString:@"64"]) {
                NSRange range = NSMakeRange(0, 2);
                
                string_1 =   [s1  stringByReplacingCharactersInRange:range withString:@"1"];
                
                
            }
            if ([s1 isEqualToString:@"00"]) {
                
                NSRange range = NSMakeRange(0, 2);
                string_1 =   [s1  stringByReplacingCharactersInRange:range withString:@"0"];
                
            }
            
            if ([s2 isEqualToString:@"64"]) {
                NSRange range = NSMakeRange(0, 2);
                
                string_2 =   [s2  stringByReplacingCharactersInRange:range withString:@"1"];
                
            }if ([s2 isEqualToString:@"00"]) {
                
                NSRange range = NSMakeRange(0, 2);
                string_2 =   [s2  stringByReplacingCharactersInRange:range withString:@"0"];
                
                
            }
            
            str1 = [string_1  stringByAppendingString:string_2];
            str =str1;
            
            break;
        case 6:
            
            s1 = [devicePacket substringWithRange:NSMakeRange(0, 2)];
            s2 = [devicePacket substringWithRange:NSMakeRange(2, 2)];
            s3 = [devicePacket substringWithRange:NSMakeRange(4, 2)];
            
            if ([s1 isEqualToString:@"64"]) {
                NSRange range = NSMakeRange(0, 2);
                
                string_1 =   [s1  stringByReplacingCharactersInRange:range withString:@"1"];
                
                
            }
            if ([s1 isEqualToString:@"00"]) {
                
                NSRange range = NSMakeRange(0, 2);
                string_1 =   [s1  stringByReplacingCharactersInRange:range withString:@"0"];
                
            }
            
            if ([s2 isEqualToString:@"64"]) {
                NSRange range = NSMakeRange(0, 2);
                
                string_2 =   [s2  stringByReplacingCharactersInRange:range withString:@"1"];
                
            }if ([s2 isEqualToString:@"00"]) {
                
                NSRange range = NSMakeRange(0, 2);
                string_2 =   [s2  stringByReplacingCharactersInRange:range withString:@"0"];
                
                
            }
            if ([s3 isEqualToString:@"64"]) {
                
                NSRange range = NSMakeRange(0, 2);
                
                string_3 =   [s3  stringByReplacingCharactersInRange:range withString:@"1"];
                
            }if ([s3 isEqualToString:@"00"]) {
                
                NSRange range = NSMakeRange(0, 2);
                string_3 =   [s3  stringByReplacingCharactersInRange:range withString:@"0"];
                
            }
            
            str1 = [string_1  stringByAppendingString:string_2];
            str = [str1  stringByAppendingString:string_3];
            
            break;
        case 8:
            
            s1 = [devicePacket substringWithRange:NSMakeRange(0, 2)];
            s2 = [devicePacket substringWithRange:NSMakeRange(2, 2)];
            s3 = [devicePacket substringWithRange:NSMakeRange(4, 2)];
            s4 = [devicePacket substringWithRange:NSMakeRange(6, 2)];
            
            if ([s1 isEqualToString:@"64"]) {
                NSRange range = NSMakeRange(0, 2);
                
                string_1 =   [s1  stringByReplacingCharactersInRange:range withString:@"1"];
                
            }
            if ([s1 isEqualToString:@"00"]) {
                
                NSRange range = NSMakeRange(0, 2);
                string_1 =   [s1  stringByReplacingCharactersInRange:range withString:@"0"];
                
            }
            
            if ([s2 isEqualToString:@"64"]) {
                NSRange range = NSMakeRange(0, 2);
                
                string_2 =   [s2  stringByReplacingCharactersInRange:range withString:@"1"];
                
            }if ([s2 isEqualToString:@"00"]) {
                
                NSRange range = NSMakeRange(0, 2);
                string_2 =   [s2  stringByReplacingCharactersInRange:range withString:@"0"];
                
                
            }
            if ([s3 isEqualToString:@"64"]) {
                
                NSRange range = NSMakeRange(0, 2);
                
                string_3 =   [s3  stringByReplacingCharactersInRange:range withString:@"1"];
                
            }if ([s3 isEqualToString:@"00"]) {
                
                NSRange range = NSMakeRange(0, 2);
                
                string_3 =   [s3  stringByReplacingCharactersInRange:range withString:@"0"];
                
            }
            if ([s4 isEqualToString:@"64"]) {
                
                NSRange range = NSMakeRange(0, 2);
                string_4 =   [s4  stringByReplacingCharactersInRange:range withString:@"1"];
                
            }if ([s4 isEqualToString:@"00"]) {
                
                NSRange range = NSMakeRange(0, 2);
                string_4 =   [s4  stringByReplacingCharactersInRange:range withString:@"0"];
                
            }
            
            str1 = [string_1  stringByAppendingString:string_2];
            str2  = [str1  stringByAppendingString:string_3];
            str =[str2  stringByAppendingString:string_4];
            
            break;

            
    }
    
    return str;
    
}


/**
 *  00 -0 64-1 转码
 *
 *  @param string 字符数组
 *
 *  @return 字符串
 */
+(NSString *)transThemeCodingFromServer:(NSString *)string{
    
    //将字符数组转换成string
    NSString *devicePacket =string;
    
    // NSLog(@"devicePacket is %@", devicePacket);
    
    //取出每个字符串
    NSString *s1;
    NSString *s2;
    NSString *s3;
    NSString *s4;
    NSString *s5;
    NSString *s6;
    NSString *s7;
    NSString *s8;
    
    //将字符串转成00 或者64
    NSString * string_1;
    NSString * string_2;
    NSString * string_3;
    NSString * string_4;
    NSString * string_5;
    NSString * string_6;
    NSString * string_7;
    NSString * string_8;
    
    //拼接字符串
    NSString  *str;
    NSString  *str1;
    NSString  *str2;
    NSString  *str3;
    NSString  *str4;
    NSString  *str5;
    NSString  *str6;
    
    
    NSUInteger length=  [devicePacket  length];
    switch (length) {
            
        case 16:
            
            s1 = [devicePacket substringWithRange:NSMakeRange(0, 2)];
            s2 = [devicePacket substringWithRange:NSMakeRange(2, 2)];
            s3 = [devicePacket substringWithRange:NSMakeRange(4, 2)];
            s4 = [devicePacket substringWithRange:NSMakeRange(6, 2)];
            s5 = [devicePacket substringWithRange:NSMakeRange(8, 2)];
            s6 = [devicePacket substringWithRange:NSMakeRange(10,2)];
            s7 = [devicePacket substringWithRange:NSMakeRange(12,2)];
            s8 = [devicePacket substringWithRange:NSMakeRange(14,2)];
            
            if ([s1 isEqualToString:@"64"]) {
                NSRange range = NSMakeRange(0, 2);
                
                string_1 =   [s1  stringByReplacingCharactersInRange:range withString:@"1"];
                
                
            }
            if ([s1 isEqualToString:@"00"]) {
                
                NSRange range = NSMakeRange(0, 2);
                string_1 =   [s1  stringByReplacingCharactersInRange:range withString:@"0"];
                
            }
            
            if ([s2 isEqualToString:@"64"]) {
                NSRange range = NSMakeRange(0, 2);
                
                string_2 =   [s2  stringByReplacingCharactersInRange:range withString:@"1"];
                
            }if ([s2 isEqualToString:@"00"]) {
                
                NSRange range = NSMakeRange(0, 2);
                string_2 =   [s2  stringByReplacingCharactersInRange:range withString:@"0"];
                
                
            }
            if ([s3 isEqualToString:@"64"]) {
                
                NSRange range = NSMakeRange(0, 2);
                
                string_3 =   [s3  stringByReplacingCharactersInRange:range withString:@"1"];
                
            }if ([s3 isEqualToString:@"00"]) {
                
                NSRange range = NSMakeRange(0, 2);
                string_3 =   [s3  stringByReplacingCharactersInRange:range withString:@"0"];
                
            }
            if ([s4 isEqualToString:@"64"]) {
                
                NSRange range = NSMakeRange(0, 2);
                
                string_4 =   [s4  stringByReplacingCharactersInRange:range withString:@"1"];
                
            }if ([s4 isEqualToString:@"00"]) {
                
                NSRange range = NSMakeRange(0, 2);
                string_4 =   [s4  stringByReplacingCharactersInRange:range withString:@"0"];
                
            }
            if ([s5 isEqualToString:@"64"]) {
                
                NSRange range = NSMakeRange(0, 2);
                
                string_5 =   [s5  stringByReplacingCharactersInRange:range withString:@"1"];
                
            }if ([s5 isEqualToString:@"00"]) {
                
                NSRange range = NSMakeRange(0, 2);
                string_5 =   [s5  stringByReplacingCharactersInRange:range withString:@"0"];
                
            }
            if ([s6 isEqualToString:@"64"]) {
                
                NSRange range = NSMakeRange(0, 2);
                
                string_6 =   [s6  stringByReplacingCharactersInRange:range withString:@"1"];
                
            }if ([s6 isEqualToString:@"00"]) {
                
                NSRange range = NSMakeRange(0, 2);
                string_6 =   [s6  stringByReplacingCharactersInRange:range withString:@"0"];
                
            }
            if ([s7 isEqualToString:@"64"]) {
                
                NSRange range = NSMakeRange(0, 2);
                
                string_7 =   [s7 stringByReplacingCharactersInRange:range withString:@"1"];
                
            }if ([s7 isEqualToString:@"00"]) {
                
                NSRange range = NSMakeRange(0, 2);
                string_7 =   [s7  stringByReplacingCharactersInRange:range withString:@"0"];
                
            }
            if ([s8 isEqualToString:@"64"]) {
                
                NSRange range = NSMakeRange(0, 2);
                
                string_8 =   [s8  stringByReplacingCharactersInRange:range withString:@"1"];
                
            }if ([s8 isEqualToString:@"00"]) {
                
                NSRange range = NSMakeRange(0, 2);
                string_8 =   [s8  stringByReplacingCharactersInRange:range withString:@"0"];
                
            }
            
            
            
            str1 = [string_1  stringByAppendingString:string_2];
            str2 = [str1  stringByAppendingString:string_3];
            str3 = [str2 stringByAppendingString:string_4];
            str4 = [str3 stringByAppendingString:string_5];
            str5 = [str4 stringByAppendingString:string_6];
            str6 = [str5 stringByAppendingString:string_7];
            str =[str6  stringByAppendingString:string_8];
            
            break;
        default:
            break;
    }
    
    return str;
    
}


@end
