//
//  Contact.h
//  2cu
//
//  Created by guojunyi on 14-4-14.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#define STATE_ONLINE 1
#define STATE_OFFLINE 0 

#define CONTACT_TYPE_UNKNOWN 0
#define CONTACT_TYPE_NPC 2
#define CONTACT_TYPE_PHONE 3
#define CONTACT_TYPE_DOORBELL 4
#define CONTACT_TYPE_IPC 7

#define DEFENCE_STATE_OFF 0
#define DEFENCE_STATE_ON 1
#define DEFENCE_STATE_LOADING 2
#define DEFENCE_STATE_WARNING_PWD 3
#define DEFENCE_STATE_WARNING_NET 4
#define DEFENCE_STATE_NO_PERMISSION 5

@interface Contact : NSObject
@property (nonatomic) int row;
@property (strong, nonatomic) NSString *contactId;
@property (strong, nonatomic) NSString *contactName;
@property (strong, nonatomic) NSString *contactPassword;
@property (nonatomic) NSInteger contactType;

@property (nonatomic) NSInteger onLineState;
@property (nonatomic) NSInteger messageCount;

@property (nonatomic) NSInteger defenceState;   //3密码错误  0打开 1关闭

@property (nonatomic) BOOL isClickDefenceStateBtn;
@end
