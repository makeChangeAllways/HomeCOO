//
//  versionMessageModel.h
//  HomeCOO
//
//  Created by tgbus on 16/7/21.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface versionMessageModel : NSObject

/**网关编号*/
@property(nonatomic,copy) NSString *gatewayNum;
/**用户手机号*/
@property(nonatomic,copy) NSString *phoneNum;
/**版本描述*/
@property(nonatomic,copy) NSString *versionDescription;
/**版本号*/
@property(nonatomic,copy) NSString *versionCode;
/**更新时间*/
@property(nonatomic,copy) NSString *updateTime;
/**版本类型
*  1:app版本  2: 设备版本 3: 空间版本  4: 情景版本 5:  情景音乐版本  6: 网关版本
*/
@property(nonatomic,copy) NSString *versionType;






@end
