//
//  SettingGroup.h
//  SeekPath
//
//  Created by mac on 15/7/8.
//
//  用于TableView Group

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SettingGroup : NSObject
@property (nonatomic,strong) NSArray *items;

@property(nonatomic,strong)UIView *header;

@property(nonatomic,strong)UIView *footer;

@end
