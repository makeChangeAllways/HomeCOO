//
//  BLTManager.h
//  IRBT
//
//  Created by wsz on 16/9/26.
//  Copyright © 2016年 wsz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARCStateCtr.h"

typedef NS_ENUM(NSInteger,BideOrderType)
{
    BideOrderTypeLearn,//学习指令
    BideOrderTypeMatch //匹配指令
};


typedef void (^DidConnPeripheral)(void);           

typedef void (^LearnCodeCallBack)(NSData *data);
typedef void (^MatchCodeCallBack)(NSData *data);

@interface BLTManager : NSObject

@property (nonatomic,copy) LearnCodeCallBack learnCB;//学习回调
@property (nonatomic,copy) MatchCodeCallBack matchCB;//一键匹配回调

@property (nonatomic,assign)BOOL isconnected;//连接状态

@property (nonatomic,strong)ARCStateCtr *arcCtr;


+ (BLTManager *)shareInstance;


- (void)bideOrderBytype:(BideOrderType)type;//控制指令发送（比如按键学习指令）

- (void)sendData:(NSData *)data;  //空调外的数据发送
- (void)sendLearnedData:(NSData *)data; //学习到的数据发送
- (void)sendARCData:(NSData *)data withTag:(NSInteger)tag;//空调数据发送



@end
