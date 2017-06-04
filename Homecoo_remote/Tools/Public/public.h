//
//  public.h
//  IRBT
//
//  Created by wsz on 16/9/26.
//  Copyright © 2016年 wsz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface public : NSObject

unsigned char int2char(unsigned char k);
unsigned char char2int(unsigned char k);

NSString *hex2str(NSData *data);
NSData *str2Hex(NSString *str);

@end
