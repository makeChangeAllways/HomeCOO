//
//  chooseListView.m
//  2cu
//
//  Created by mac on 15/10/21.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//

#import "chooseListView.h"
#import "chooseButton.h"
#import "Contact.h"
#import "PrefixHeader.pch"

@interface chooseListView ()

@end


@implementation chooseListView


- (NSMutableArray *)contactBtns
{
    if (_contactBtns == nil) {
        _contactBtns = [NSMutableArray array];
    }
    return _contactBtns;
}

- (NSMutableArray *)dateArray_temp
{
    if (_dateArray_temp == nil) {
        _dateArray_temp = [NSMutableArray array];
    }
    return _dateArray_temp;
}

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}


- (void)setListArrayData:(NSArray *)ListArrayData
{
    _ListArrayData = ListArrayData;
    
    [self.contactBtns removeAllObjects];
    if (ListArrayData.count) {
        for (int index = 0; index < ListArrayData.count; index ++) {
            chooseButton *choose_btn = [[chooseButton alloc] init];
            [self addSubview:choose_btn];
            
            [self.contactBtns addObject:choose_btn];
            Contact *cont = [ListArrayData objectAtIndex:index];
            [choose_btn setTitle:cont.contactName forState:UIControlStateNormal];
            [choose_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            choose_btn.titleLabel.font = [UIFont systemFontOfSize:14];
            choose_btn.tag = index;
            choose_btn.frame = CGRectMake(0, 40 * index, (VIEWWIDTH - 60)/2, 40);
            [choose_btn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}


- (void)updateContacts:(NSArray *)contacts
{
    int i = 0;
    for (int index = 0; index < self.subviews.count; index ++) {
        UIView *subView = self.subviews[index];
        if ([subView isKindOfClass:[chooseButton class]]) {
            i ++;
        }
    }
    
    for (int index = 0; index < i; index ++) {
        Contact *cont = contacts[index];
        chooseButton *chooseBtn = self.subviews[index];
        if (cont.onLineState == STATE_ONLINE) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [chooseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            });
            
        }else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [chooseBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            });
            
        }
    }
}



- (void)setDateArray:(NSArray *)DateArray
{
    _DateArray = DateArray;
   
    if (DateArray.count) {
        for (int index = 0; index < DateArray.count; index ++) {
            
            chooseButton *choose_btn = [[chooseButton alloc] init];
            [self.dateArray_temp addObject:choose_btn];
            [self addSubview:choose_btn];
            NSString *cont = [DateArray objectAtIndex:index];
            [choose_btn setTitle:cont forState:UIControlStateNormal];
            [choose_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            choose_btn.titleLabel.font = [UIFont systemFontOfSize:14];
            choose_btn.tag = index;
            choose_btn.frame = CGRectMake(0, 40 * index, (VIEWWIDTH - 60)/2, 40);
            [choose_btn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}




-(void)chooseBtnClick:(chooseButton *)chose_btn
{
    if (self.clikcBlk) {
        self.clikcBlk((int)chose_btn.tag);
    }
}

@end
