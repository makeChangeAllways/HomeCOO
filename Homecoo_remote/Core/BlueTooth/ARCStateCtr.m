//
//  ARCStateCtr.m
//  IRBT
//
//  Created by wsz on 16/10/8.
//  Copyright © 2016年 wsz. All rights reserved.
//

#import "ARCStateCtr.h"

@implementation ARCStateCtr

- (void)resetState
{
    self.temperature = 0x19;
    self.volume = 0x01;
    self.manual = 0x02;
    self.autos = 0x01;
    
    self.mode = 0x02;
}

- (void)chageStateByType:(ARCStateType)type
{
    if(type==ARCStateTypeTmpAdd)
    {
        self.temperature++;
        if(self.temperature>0x1E)
        {
            self.temperature = 0x1E;
        }

    }
    else if(type==ARCStateTypeTmpRdu)
    {
        self.temperature--;
        if(self.temperature<0x13)
        {
            self.temperature = 0x13;
        }
    }
    else if(type==ARCStateTypeVle)
    {
        self.volume++;
        if(self.volume>0x04)
        {
            self.volume = 0x01;
        }
    }
    else if(type==ARCStateTypeMnl)
    {
        self.manual++;
        if(self.manual>0x03)
        {
            self.manual = 0x01;
        }
    }
    else if(type==ARCStateTypeAto)
    {
        self.autos++;
        if(self.autos>0x01)
        {
            self.autos=0x00;
        }
    }
    else if(type==ARCStateTypeMod)
    {
        self.mode++;
        if(self.mode>0x05)
        {
            self.mode = 0x01;
        }
    }
}

/* 7B0: 其中第0个字节：数据为对应空调的温度：19－30度(0x14-0x1F),默认：25度;十六进制,与显示对应,通过温度加减键调节 */
/* 7B1:其中第1个字节：风量数据：自动：01,低：02,中：03,高：04,与显示对应：默认：01,相关显示符号参考样机） */
/* 7B2:其中第2个字节：手动风向：向下：03,中：02,向上：01,默认02,与显示对应; */
/* 7B3:其中第3个字节：自动风向：01,打开,00,关,默认开:01,与显示对应 */
/* 7B4:其中第4个字节：开关数据：开机时：0x01,关机时：0x00,通过按开关机（电源）键实现,开机后,其它键才有效,相关符号才显示) */
/* 7B5:其中第5个字节：键名对应数据,电源：0x01,模式：0x02,风量：0x03,手动风向：0x04, */
/*       自动风向：0x05,温度加：0x06,  温度减：0x07, // 表示当前按下的是哪个键 */
/* 7B6:其中第6个字节：模式对应数据和显示：自动（默认）：0x01,制冷：0X02,抽湿：0X03,送风：0x04;制热：0x05,这些值按模式键实现 */

- (NSData *)get7B_DataWithTag:(NSInteger)tag
{
    NSInteger keyValue = 0x0;
    if(tag==0x77||tag==0x88)//开、关
    {
        keyValue = 0x01;
    }
    else
    {
        keyValue = tag;
        if(tag==0x02)
        {
            [self chageStateByType:ARCStateTypeMod];
        }
        else if(tag==0x03)
        {
            [self chageStateByType:ARCStateTypeVle];
        }
        else if(tag==0x04)
        {
            [self chageStateByType:ARCStateTypeMnl];
        }
        else if(tag==0x05)
        {
            [self chageStateByType:ARCStateTypeAto];
        }
        else if(tag==0x06)
        {
            [self chageStateByType:ARCStateTypeTmpAdd];
        }
        else if(tag==0x07)
        {
            [self chageStateByType:ARCStateTypeTmpRdu];
        }
    }
    
    NSMutableData *data = [NSMutableData new];
    [data appendData:[NSData dataWithBytes:&_temperature length:1]]; //7B0
    [data appendData:[NSData dataWithBytes:&_volume length:1]];      //7B1
    [data appendData:[NSData dataWithBytes:&_manual length:1]];      //7B2
    [data appendData:[NSData dataWithBytes:&_autos length:1]];       //7B3
    
    int switchState = 0x01;
    if(tag==0x88)
    {
        switchState = 0x00;
    }
    [data appendData:[NSData dataWithBytes:&switchState length:1]];       //7B4
    [data appendData:[NSData dataWithBytes:&keyValue length:1]];          //7B5
    [data appendData:[NSData dataWithBytes:&_mode length:1]];             //7B6
    
    return data;
}

@end
