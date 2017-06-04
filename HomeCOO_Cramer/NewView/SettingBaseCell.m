//
//  SettingBaseCell.m
//  2cu
//
//  Created by mac on 15/10/19.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//

#import "SettingBaseCell.h"
#import "SettingBaseItem.h"
#import "SettingArrowItem.h"
#import "SettingSwitchItem.h"
#import "PrefixHeader.pch"
@interface SettingBaseCell ()

// cell左边的文字
@property (retain, nonatomic) IBOutlet UILabel *title_Label;

// cell 提示文字
@property (retain, nonatomic) IBOutlet UILabel *Place_label;

// 箭号 -- 是否隐藏
@property (retain, nonatomic) IBOutlet UIImageView *arrow_icon;


@property(nonatomic,strong)UISwitch *Cell_switch;  // 开关


@end


@implementation SettingBaseCell

- (void)awakeFromNib
{
    [super awakeFromNib];
//    self.arrow_icon.hidden = YES;
    
    
}

- (UISwitch *)Cell_switch
{
    if (_Cell_switch == nil) {
        _Cell_switch = [[UISwitch alloc] init];
        [self.contentView addSubview:_Cell_switch];
        _Cell_switch.frame = CGRectMake(VIEWWIDTH - 60, 5 , 50, 34);
        _Cell_switch.hidden = YES;
        [_Cell_switch addTarget:self action:@selector(switchValueChange) forControlEvents:UIControlEventValueChanged];
        
    }
    return _Cell_switch;
}

// 开关值 改变
- (void)switchValueChange
{
    if (self.switch_blk) {
        self.switch_blk(_row,_section);
    }
}



// 设置数据
- (void)setItem:(SettingBaseItem *)item
{
    _item = item;
    if ([item isKindOfClass:[SettingArrowItem class]]) {  // 箭号
        self.Cell_switch.hidden = YES;
        self.Place_label.hidden = NO;
        self.arrow_icon.hidden = NO;
        if (item.icon.length) {
            self.Place_label.text = item.icon;
        }else
        {
            self.Place_label.text = @"未绑定";
        }
        self.title_Label.text = item.title;
        
        if ([item.destVc isEqualToString:@"Dontshow"]) {  // 隐藏 未绑定
            self.Place_label.text = @"";
        }
    }else if ([item isKindOfClass:[SettingSwitchItem class]]){
        self.Cell_switch.hidden = NO;
        self.arrow_icon.hidden = YES;
        self.Place_label.hidden = YES;
        self.title_Label.text = item.title;
        
        
        
    }
    
    
    
    
    
}

@end
