//
//  DefenceAddCell.m
//  2cu
//
//  Created by mac on 15/11/10.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//

#import "DefenceAddCell.h"

@interface DefenceAddCell ()

- (IBAction)Add_Click:(UIButton *)sender;


@end

@implementation DefenceAddCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)Add_Click:(UIButton *)sender {
    if (self.add_block) {
        self.add_block();
    }
    
}
@end
