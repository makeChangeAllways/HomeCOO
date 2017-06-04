//
//  HCaccount.m
//  HomeCOO
//
//  Created by app on 16/10/6.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "HCaccount.h"

@implementation HCaccount


+(instancetype)accountWithDict:(NSDictionary *)dict{

    HCaccount *account = [[self alloc]init];
    
    account.AccountGatewayID = dict[@"AccountGatewayID"];
    account.AccountGatewayPwd = dict[@"AccountGatewayPwd"];
    account.AccountRouterName = dict[@"AccountRouterName"];
    account.AccountRouterPwd = dict[@"AccountRouterPwd"];

    return account;

}
/**当一个对象要归档进沙盒时，就会调用这个方法
 * 目的：在这个方法中说明这个对象的哪些属性要进沙盒
 */
-(void)encodeWithCoder:(NSCoder *)enCoder{
    [enCoder  encodeObject:self.AccountGatewayID forKey:@"AccountGatewayID"];
    [enCoder  encodeObject:self.AccountGatewayPwd forKey:@"AccountGatewayPwd"];
    [enCoder  encodeObject:self.AccountRouterName forKey:@"AccountRouterName"];
    [enCoder  encodeObject:self.AccountRouterPwd forKey:@"AccountRouterPwd"];
}

/**从沙盒中解档一个对象时（从沙盒中加载一个对象时），就会调用这个方法
 *目的：在这个方法中说明沙盒中的属性该怎么解析
 */

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        
        self.AccountGatewayID = [decoder decodeObjectForKey:@"AccountGatewayID"];
        self.AccountGatewayPwd = [decoder decodeObjectForKey:@"AccountGatewayPwd"];
        self.AccountRouterName = [decoder decodeObjectForKey:@"AccountRouterName"];
        self.AccountRouterPwd = [decoder decodeObjectForKey:@"AccountRouterPwd"];
        
    }
    return self;
}


@end
