//
//  ARCStateCtr.h
//  IRBT
//
//  Created by wsz on 16/10/8.
//  Copyright © 2016年 wsz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,ARCStateType) {
    ARCStateTypeTmpAdd, //温度＋
    ARCStateTypeTmpRdu, //温度－
    ARCStateTypeVle,    //风量
    ARCStateTypeMnl,    //手动
    ARCStateTypeAto,    //自动
    ARCStateTypeMod     //模式
};

@interface ARCStateCtr : NSObject

@property (nonatomic,assign)NSInteger temperature; //温度
@property (nonatomic,assign)NSInteger volume;      //风量
@property (nonatomic,assign)NSInteger manual;      //手动
@property (nonatomic,assign)NSInteger autos;       //自动
@property (nonatomic,assign)NSInteger mode;        //模式
@property (nonatomic,assign)BOOL powerOn;

//重置状态
- (void)resetState;

//空调7B数据组装
- (NSData *)get7B_DataWithTag:(NSInteger)tag;

@end
