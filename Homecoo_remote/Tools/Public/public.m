//
//  public.m
//  IRBT
//
//  Created by wsz on 16/9/26.
//  Copyright © 2016年 wsz. All rights reserved.
//

#import "public.h"

@implementation public

unsigned char int2char(unsigned char k)
{
    if(k>=0x0&&k<=0x9)
    {
        return k+48;
    }
    else if(k>=0xa&&k<=0xf)
    {
        return k+87;
    }
    return 0;
}

unsigned char char2int(unsigned char k)
{
    if(k>='0'&&k<='9')
    {
        return k-48;
    }
    else if(k>='a'&&k<='f')
    {
        return k-87;
    }
    else if(k>='A'&&k<='F')
    {
        return k-55;
    }
    return 0;
}

NSString *hex2str(NSData *data)
{
    if(![data length])return nil;
    
    NSMutableString *str = [NSMutableString new];
    for(int i=0;i<[data length];i++)
    {
        uint8_t tmp=0;
        [data getBytes:&tmp range:NSMakeRange(i, 1)];
    
        unsigned char h = (tmp&0xf0)>>4;
        unsigned char l = (tmp&0x0f);
        
        [str appendString:[NSString stringWithFormat:@"0x%c%c,",int2char(h),int2char(l)]];
    }
    [str substringToIndex:[str length]-1];
    return str;
}

NSData *str2Hex(NSString *str)
{
    if(![str length])return nil;
    str = [str stringByReplacingOccurrencesOfString:@"0x" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"," withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if([str length]%2==0)
    {
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableData *mutiData = [NSMutableData new];
        for(int i=0;i<[data length];i+=2)
        {
            unsigned char k[2] = {0x0};
            [data getBytes:k range:NSMakeRange(i, 2)];
            unsigned char w = char2int(k[0])*16+char2int(k[1]);
            NSData *data = [NSData dataWithBytes: &w length: 1];
            [mutiData appendData:data];
        }
        return mutiData;
    }
    else
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"xxxx" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ac = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:NULL];
            [alert addAction:ac];
            //[self presentViewController:alert animated:YES completion:NULL];
        });
    }
    return nil;
}


@end
