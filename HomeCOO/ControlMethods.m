//
//  ControlMethods.m
//  HomeCOO
//
//  Created by tgbus on 16/5/19.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "ControlMethods.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworkings.h"
#import "PrefixHeader.pch"
#import "PacketMethods.h"
#import "SocketManager.h"
#import "LZXDataCenter.h"
@implementation ControlMethods

/**
 *  0 -00 1-64 转码
 *
 *  @param string 字符数组
 *
 *  @return 字符串
 */
+(NSString *)transCoding:(NSString *)string{
    
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
        case 1:
            s1 = [devicePacket substringWithRange:NSMakeRange(0, 1)];
            
            if ([s1 isEqualToString:@"1"]) {
                NSRange range = NSMakeRange(0, 1);
                
                string_1 =   [s1  stringByReplacingCharactersInRange:range withString:@"64"];
                
                
            }
            if ([s1 isEqualToString:@"0"]) {
                
                NSRange range = NSMakeRange(0, 1);
                string_1 =   [s1  stringByReplacingCharactersInRange:range withString:@"00"];
                
            }
            str = string_1;
            
            break;
        case 2:
            
            s1 = [devicePacket substringWithRange:NSMakeRange(0, 1)];
            s2 = [devicePacket substringWithRange:NSMakeRange(1, 1)];
            if ([s1 isEqualToString:@"1"]) {
                NSRange range = NSMakeRange(0, 1);
                
                string_1 =   [s1  stringByReplacingCharactersInRange:range withString:@"64"];
                
                
            }
            if ([s1 isEqualToString:@"0"]) {
                
                NSRange range = NSMakeRange(0, 1);
                string_1 =   [s1  stringByReplacingCharactersInRange:range withString:@"00"];
                
            }
            
            if ([s2 isEqualToString:@"1"]) {
                NSRange range = NSMakeRange(0, 1);
                
                string_2 =   [s2  stringByReplacingCharactersInRange:range withString:@"64"];
                
            }if ([s2 isEqualToString:@"0"]) {
                
                NSRange range = NSMakeRange(0, 1);
                string_2 =   [s2  stringByReplacingCharactersInRange:range withString:@"00"];
                
                
            }
            
            str1 = [string_1  stringByAppendingString:string_2];
            str =str1;
           
            break;
        case 3:
            
            s1 = [devicePacket substringWithRange:NSMakeRange(0, 1)];
            s2 = [devicePacket substringWithRange:NSMakeRange(1, 1)];
            s3 = [devicePacket substringWithRange:NSMakeRange(2, 1)];
            
            if ([s1 isEqualToString:@"1"]) {
                NSRange range = NSMakeRange(0, 1);
                
                string_1 =   [s1  stringByReplacingCharactersInRange:range withString:@"64"];
                
                
            }
            if ([s1 isEqualToString:@"0"]) {
                
                NSRange range = NSMakeRange(0, 1);
                string_1 =   [s1  stringByReplacingCharactersInRange:range withString:@"00"];
                
            }
            
            if ([s2 isEqualToString:@"1"]) {
                NSRange range = NSMakeRange(0, 1);
                
                string_2 =   [s2  stringByReplacingCharactersInRange:range withString:@"64"];
                
            }if ([s2 isEqualToString:@"0"]) {
                
                NSRange range = NSMakeRange(0, 1);
                string_2 =   [s2  stringByReplacingCharactersInRange:range withString:@"00"];
                
                
            }
            if ([s3 isEqualToString:@"1"]) {
                
                NSRange range = NSMakeRange(0, 1);
                
                string_3 =   [s3  stringByReplacingCharactersInRange:range withString:@"64"];
                
            }if ([s3 isEqualToString:@"0"]) {
                
                NSRange range = NSMakeRange(0, 1);
                string_3 =   [s3  stringByReplacingCharactersInRange:range withString:@"00"];
                
            }
            
            str1 = [string_1  stringByAppendingString:string_2];
            str = [str1  stringByAppendingString:string_3];
            
            break;
        case 4:
            
            s1 = [devicePacket substringWithRange:NSMakeRange(0, 1)];
            s2 = [devicePacket substringWithRange:NSMakeRange(1, 1)];
            s3 = [devicePacket substringWithRange:NSMakeRange(2, 1)];
            s4 = [devicePacket substringWithRange:NSMakeRange(3, 1)];
            
            if ([s1 isEqualToString:@"1"]) {
                NSRange range = NSMakeRange(0, 1);
                
                string_1 =   [s1  stringByReplacingCharactersInRange:range withString:@"64"];
                
                
            }
            if ([s1 isEqualToString:@"0"]) {
                
                NSRange range = NSMakeRange(0, 1);
                string_1 =   [s1  stringByReplacingCharactersInRange:range withString:@"00"];
                
            }
            
            if ([s2 isEqualToString:@"1"]) {
                NSRange range = NSMakeRange(0, 1);
                
                string_2 =   [s2  stringByReplacingCharactersInRange:range withString:@"64"];
                
            }if ([s2 isEqualToString:@"0"]) {
                
                NSRange range = NSMakeRange(0, 1);
                string_2 =   [s2  stringByReplacingCharactersInRange:range withString:@"00"];
                
                
            }
            if ([s3 isEqualToString:@"1"]) {
                
                NSRange range = NSMakeRange(0, 1);
                
                string_3 =   [s3  stringByReplacingCharactersInRange:range withString:@"64"];
                
            }if ([s3 isEqualToString:@"0"]) {
                
                NSRange range = NSMakeRange(0, 1);
                string_3 =   [s3  stringByReplacingCharactersInRange:range withString:@"00"];
                
            }
            if ([s4 isEqualToString:@"1"]) {
                
                NSRange range = NSMakeRange(0, 1);
                
                string_4 =   [s4  stringByReplacingCharactersInRange:range withString:@"64"];
                
            }if ([s4 isEqualToString:@"0"]) {
                
                NSRange range = NSMakeRange(0, 1);
                string_4 =   [s4  stringByReplacingCharactersInRange:range withString:@"00"];
                
            }
            str1 = [string_1  stringByAppendingString:string_2];
            str2  = [str1  stringByAppendingString:string_3];
            str =[str2  stringByAppendingString:string_4];
            
            break;
        default:
            break;
    }

    return str;
    
}

/**
 *  0 -00 1-64 转码
 *
 *  @param string 字符数组
 *
 *  @return 字符串
 */
+(NSString *)transThemeCoding:(NSString *)string{
    
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
        
        case 8:
            
            s1 = [devicePacket substringWithRange:NSMakeRange(0, 1)];
            s2 = [devicePacket substringWithRange:NSMakeRange(1, 1)];
            s3 = [devicePacket substringWithRange:NSMakeRange(2, 1)];
            s4 = [devicePacket substringWithRange:NSMakeRange(3, 1)];
            s5 = [devicePacket substringWithRange:NSMakeRange(4, 1)];
            s6 = [devicePacket substringWithRange:NSMakeRange(5, 1)];
            s7 = [devicePacket substringWithRange:NSMakeRange(6, 1)];
            s8 = [devicePacket substringWithRange:NSMakeRange(7, 1)];

            if ([s1 isEqualToString:@"1"]) {
                NSRange range = NSMakeRange(0, 1);
                
                string_1 =   [s1  stringByReplacingCharactersInRange:range withString:@"64"];
                
                
            }
            if ([s1 isEqualToString:@"0"]) {
                
                NSRange range = NSMakeRange(0, 1);
                string_1 =   [s1  stringByReplacingCharactersInRange:range withString:@"00"];
                
            }
            
            if ([s2 isEqualToString:@"1"]) {
                NSRange range = NSMakeRange(0, 1);
                
                string_2 =   [s2  stringByReplacingCharactersInRange:range withString:@"64"];
                
            }if ([s2 isEqualToString:@"0"]) {
                
                NSRange range = NSMakeRange(0, 1);
                string_2 =   [s2  stringByReplacingCharactersInRange:range withString:@"00"];
                
                
            }
            if ([s3 isEqualToString:@"1"]) {
                
                NSRange range = NSMakeRange(0, 1);
                
                string_3 =   [s3  stringByReplacingCharactersInRange:range withString:@"64"];
                
            }if ([s3 isEqualToString:@"0"]) {
                
                NSRange range = NSMakeRange(0, 1);
                string_3 =   [s3  stringByReplacingCharactersInRange:range withString:@"00"];
                
            }
            if ([s4 isEqualToString:@"1"]) {
                
                NSRange range = NSMakeRange(0, 1);
                
                string_4 =   [s4  stringByReplacingCharactersInRange:range withString:@"64"];
                
            }if ([s4 isEqualToString:@"0"]) {
                
                NSRange range = NSMakeRange(0, 1);
                string_4 =   [s4  stringByReplacingCharactersInRange:range withString:@"00"];
                
            }
            if ([s5 isEqualToString:@"1"]) {
                
                NSRange range = NSMakeRange(0, 1);
                
                string_5 =   [s5  stringByReplacingCharactersInRange:range withString:@"64"];
                
            }if ([s5 isEqualToString:@"0"]) {
                
                NSRange range = NSMakeRange(0, 1);
                string_5 =   [s5  stringByReplacingCharactersInRange:range withString:@"00"];
                
            }
            if ([s6 isEqualToString:@"1"]) {
                
                NSRange range = NSMakeRange(0, 1);
                
                string_6 =   [s6  stringByReplacingCharactersInRange:range withString:@"64"];
                
            }if ([s6 isEqualToString:@"0"]) {
                
                NSRange range = NSMakeRange(0, 1);
                string_6 =   [s6  stringByReplacingCharactersInRange:range withString:@"00"];
                
            }
            if ([s7 isEqualToString:@"1"]) {
                
                NSRange range = NSMakeRange(0, 1);
                
                string_7 =   [s7 stringByReplacingCharactersInRange:range withString:@"64"];
                
            }if ([s7 isEqualToString:@"0"]) {
                
                NSRange range = NSMakeRange(0, 1);
                string_7 =   [s7  stringByReplacingCharactersInRange:range withString:@"00"];
                
            }
            if ([s8 isEqualToString:@"1"]) {
                
                NSRange range = NSMakeRange(0, 1);
                
                string_8 =   [s8  stringByReplacingCharactersInRange:range withString:@"64"];
                
            }if ([s8 isEqualToString:@"0"]) {
                
                NSRange range = NSMakeRange(0, 1);
                string_8 =   [s8  stringByReplacingCharactersInRange:range withString:@"00"];
                
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

/**
 *  网关编码
 *
 *  @param string 输入字符串类型
 *
 *  @return 返回字符串类型
 */
+(NSString *)stringToByte:(NSString *)string
{
    NSString * data = @"";
    NSData *testData = [string dataUsingEncoding: NSUTF8StringEncoding];
    Byte *testByte = (Byte *)[testData bytes];
    for(int i=0;i<[testData length];i++){
        
        NSString *test=   [self  ToHex:testByte[i]];
        data  =[NSString stringWithFormat:@"%@%@",data,test];
        
    }
    
    // NSLog(@"====编码后======= %@",data);
    
    return data;
    
}

/**
 *  解码
 */
+(NSString *)stringFromHexString:(NSString *)hexString { //
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    // NSLog(@"------字符串=======%@",unicodeString);
    
    return unicodeString;
}
/**
 *  将情景名称转换成字节然后封装成nsstring型 例如回家 转换后
 ==3232394031353540313538403232394031373440313832000000000000000000000000000000000000000000000000000000000000000000
 *  @param string
 */

+ (NSString *)chineseStringToByte:(NSString *)string{
    
    NSString * data = @"";
    NSString *dataStr = @"";
    NSData *testData = [string dataUsingEncoding: NSUTF8StringEncoding];
    Byte *testByte = (Byte *)[testData bytes];
    for(int i=0;i<[testData length];i++){
        
        NSString *test=   [self  ToHex:testByte[i]];
        data  =[NSString stringWithFormat:@"%@%@",data,test];
        
    }
    
    dataStr = data;
    for (int j = 0; j<56-[data length]/2; j ++) {
        
        NSString *test = [self ToHex:0];
        
        dataStr = [NSString  stringWithFormat:@"%@%@",dataStr,test];
    }
    // NSLog(@"情景名称转换成字节 == %@",dataStr);
    
    return dataStr;
    
}

/**
 *  将nsstring类型转换成byte字节型 然后将字节型的封装成nsstring型
 *
 *  @param chinese
 */
+(NSString *)chineseWithHexString:(NSString *)chinese
{
    NSString * data = @"";
    NSData *testData = [chinese dataUsingEncoding: NSUTF8StringEncoding];
    Byte *testByte = (Byte *)[testData bytes];
    for(int i=0;i<[testData length];i++){
        
        NSString *test = [NSString stringWithFormat:@"%hhu",testByte[i]];
        
        data  =[NSString stringWithFormat:@"%@@%@",data,test];
       
    }
    
    
    NSRange  range = NSMakeRange(1, [data  length]-1);
    
    NSString *toString = [data  substringWithRange:range];
    
   // NSLog(@"情景名称转码后 == %@",data);
    
    // NSString *themeNameLegthIntToByte =  [self  intToByte:[data length]-1];
    
    //NSLog(@"长度转换为字节 == %@",themeNameLegthIntToByte);
    
    return  toString;
}

/**
 *  229@155@158@229@174@182(调用chineseWithHexString方法) 返回 回家
 *
 *  @param str
 *
 *  @return
 */
+(NSString *)chineseTostring:(NSString *)str{

    NSArray *array = [str componentsSeparatedByString:@"@"];
    
    NSInteger arrayCount = array.count;
    Byte byte[arrayCount] ;
    
    for (int i = 0; i < arrayCount; i++) {
        byte[i] = [array[i] integerValue];
    }
    
    NSData *adata = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
   
    NSString *aString = [[NSString alloc] initWithData:adata encoding:NSUTF8StringEncoding];
    
  
    return aString;

}
/**
 *  NSString中删除特定字符串
 *
 *  @param str
 *
 *  @return
 */
+(NSString *) stringDeleteString:(NSString *)str
{
    NSMutableString *str1 = [NSMutableString stringWithString:str];
    for (int i = 0; i < str1.length; i++) {
        unichar c = [str1 characterAtIndex:i];
        NSRange range = NSMakeRange(i, 1);
        if (  c == '@') { //此处可以是任何字符
            [str1 deleteCharactersInRange:range];
            --i;
        }
    }
    NSString *newstr = [NSString stringWithString:str1];
    return newstr;
}

/**
 *  10进制转换为16进制
 */
+(NSString *)ToHex:(uint16_t)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    uint16_t ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"a";break;
            case 11:
                nLetterValue =@"b";break;
            case 12:
                nLetterValue =@"c";break;
            case 13:
                nLetterValue =@"d";break;
            case 14:
                nLetterValue =@"e";break;
            case 15:
                nLetterValue =@"f";break;
            default:
                nLetterValue = [NSString stringWithFormat:@"%u",ttmpig];
                
        }
        
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            
            break;
        }
        
    }
    
    if ([str length] == 2) {
        return str;
    }else{
        
        NSString *string = [@"0" stringByAppendingString: str];
        
        return string;
    }
    
}


/**
 *  int 转换成byte
 *
 *  @param number
 */
+(NSString *)intToByte:(int)number{
    
    NSString *data = @"";
    Byte abyte[4];
    // "&" 与（AND），对两个整型操作数中对应位执行布尔代数，两个位都为1时输出1，否则0。
    abyte[0] = (Byte) (0xff & number);
    // ">>"右移位，若为正数则高位补0，若为负数则高位补1
    abyte[1] = (Byte) ((0xff00 & number) >> 8);
    abyte[2] = (Byte) ((0xff0000 & number) >> 16);
    abyte[3] = (Byte) ((0xff000000 & number) >> 24);
    
    for(int i=0;i<4;i++){
        
        NSString *test=   [self  ToHex:abyte[i]];
        data  =[NSString stringWithFormat:@"%@%@",data,test];
        
    }
    
    return data;
    
}


/**
 *  获取当前的时间 longlong型 1970年到现在的毫秒时间
 *
 *  @return
 */
+(NSString *)getCurrentTime{
    
    NSTimeInterval getCurrentMilliseconds=[[NSDate date] timeIntervalSince1970]*1000;
    
    long long longTime = [[NSNumber numberWithDouble:getCurrentMilliseconds] longLongValue];// 将double转为long long型
    NSString *CurrentTime = [NSString stringWithFormat:@"%llu",longTime];
    
    return CurrentTime;
}

/**
 *  将毫秒时间转换成 现在的年月日时间格式
 *
 *  @param timeStr
 *
 *  @return
 */
+(NSString *)getTimeToShowWithTimestamp:(NSString *)timeStr{
    
    long long time=[timeStr longLongValue];
    
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy年-MM月-dd日-HH时-mm分-ss秒"];
    
    NSString*timeString=[formatter stringFromDate:d];
    
    return timeString;
    
}

/**
 *  将nsstring 转换成 bytes型
 *
 *  @param str
 *
 *  @return nsdata 型
 */
+(NSData*) hexToBytes:(NSString *)str {
    
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= str.length; idx+=2) {
        
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [str  substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
        
    }
    
    return data;
    
}

/**
 *  将nsdata型转换成 字符型输出（不改变内容）
 *
 *  @param data
 *
 *  @return
 */

+(NSString *)NSdataToString:(NSData*)data{
    
    NSString *str = @"";
    NSUInteger len = [data length];
    Byte *byteData = (Byte*)malloc(len);
    memcpy(byteData, [data bytes], len);
    for (int i = 0; i<len; i++) {
        NSString *test=   [self  ToHex:byteData[i]];
        str  =[NSString stringWithFormat:@"%@%@",str,test];
    }
    
    return  str;
}


/**
 *  控制设备http请求方法
 *
 *  @param packets 控制设备信息封装报文
 *
 *  @return 无
 */
+(void)controlDeviceHTTPmethods:(NSString *)packets{

    //创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager  manager];
    mgr.responseSerializer = [AFJSONResponseSerializers  serializer];

    //配置请求超时时间
    mgr.requestSerializer.timeoutInterval = 60;


    //设置请求参数
    NSMutableDictionary  *params = [NSMutableDictionary  dictionary];
    params[@"devicePacketJson"] = packets;

    NSString  *urlStr =[NSString  stringWithFormat:@"%@/appDeviceController" ,HomecooServiceURL];
    NSString *url = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格

    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        //打印日志
        // NSLog(@"请求成功--%@",responseObject);
        
        NSString  *result = [responseObject[@"result"]description];
        
        //NSString *message = [responseObject[@"messageInfo"]description];
        
        if ([result  isEqual:@"success"]) {//成功获取验证码
            
            
            
            //[MBProgressHUD  showSuccess:[NSString  stringWithFormat:@"%@",message]];
            
            NSLog(@"=======发送命令成功=======");

            
        }
        if ([result  isEqual:@"failed"]) {
            
            [MBProgressHUD  hideHUD];//隐藏蒙版
            
            //[MBProgressHUD  showError:[NSString  stringWithFormat:@"%@",message]];
            NSLog(@"=======发送命令失败失败=======");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD  hideHUD];//隐藏蒙版
        [MBProgressHUD  showError:@"网络繁忙，请稍后再试"];
    }];
    
}

/**
 *  室内室外布防 控制报文
 */
+(void)indoorAndOutdoorSecurity:(NSString *)gatewayNo  deviceNo:(NSString *)deviceNo deviceTypeId:(NSInteger)DeviceTypeId  data:(NSString *)datas{
   
    LZXDataCenter *dataCenter = [LZXDataCenter  defaultDataCenter];
    SocketManager *socket = [SocketManager shareSocketManager];
    //拆报文
    NSString *head = @"42424141";
    NSString *stamp = @"00000000";
    NSString *gw_id = gatewayNo;
    NSString *dev_id = deviceNo;
    NSString *dev_type = [[self  ToHex:DeviceTypeId]  stringByAppendingString:@"00"];
    NSString *data_type = @"0200";
    
    NSString *data =[self  transCoding: datas];
    NSString *data_len = [@"000" stringByAppendingString:[NSString  stringWithFormat:@"%u",[data  length]/2]];
    
    //拼接发送报文
    NSString *packet = [PacketMethods  devicePacket:head getStamp:stamp getGw_id:gw_id getDev_id:dev_id getDev_type:dev_type getData_type:data_type getData_len:data_len getData:data];
    
    NSString *deviceControlPacketStr = [packet stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
    //打印报文
    
    
    if (dataCenter.networkStateFlag == 0) {//内网
        
         NSString *localControlMessage = [deviceControlPacketStr  stringByReplacingCharactersInRange:NSMakeRange(0, 8) withString:@"41414444"];
        [socket sendMsg:localControlMessage];
       
        NSLog(@" 内网 localControlMessage is ===== %@",localControlMessage);

    }else{//外网

        //发送报文到对应设备
        [self  controlDeviceHTTPmethods:deviceControlPacketStr ];
    
        NSLog(@" 外网 deviceControlPacketStr is ===== %@",deviceControlPacketStr);
    }
}
@end
