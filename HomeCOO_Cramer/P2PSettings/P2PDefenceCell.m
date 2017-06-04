//
//  P2PDefenceCell.m
//  2cu
//
//  Created by mac on 15/11/10.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//

#import "P2PDefenceCell.h"
#import "PrefixHeader.pch"
@interface P2PDefenceCell ()
// 对码按钮
@property (retain, nonatomic) IBOutlet UIButton *Learn_Btn;
// 设置名称按钮
@property (retain, nonatomic) IBOutlet UIButton *set_Name;
// 编号Label
@property (retain, nonatomic) IBOutlet UILabel *No_Label;
// 点击对码按钮 -- 学习
- (IBAction)Learn_Click:(UIButton *)sender;
// 点击设置名称 -- 改变子设备名字
- (IBAction)set_Name_Click:(id)sender;

@end

@implementation P2PDefenceCell

- (void)awakeFromNib {
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // todo - setName
    self.set_Name.hidden = YES;
    
    self.Learn_Btn.layer.borderWidth = 1.0f;
    self.Learn_Btn.layer.borderColor = ColorWithRGB(67, 130, 231).CGColor;
    self.Learn_Btn.layer.cornerRadius = 5.0f;
    self.Learn_Btn.clipsToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_Learn_Btn release];
    [_set_Name release];
    [_No_Label release];
    [super dealloc];
}


#pragma mark - setData 

-(void)setIndex:(int)index
{
    _index = index;
    self.No_Label.text = [NSString stringWithFormat:@"%d",index];
}


#pragma mark - Btn - Action
- (IBAction)Learn_Click:(UIButton *)sender {
    
    // 对码 学习
}

- (IBAction)set_Name_Click:(id)sender {
}
@end
