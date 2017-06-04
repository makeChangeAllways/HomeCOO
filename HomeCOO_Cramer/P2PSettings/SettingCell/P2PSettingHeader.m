//
//  P2PSettingHeader.m
//  2cu
//
//  Created by mac on 15/6/17.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//

#import "P2PSettingHeader.h"
#import "PrefixHeader.pch"
@implementation P2PSettingHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(instancetype)headerViewWithTableView:(UITableView *)tableView{
    static NSString *ID=@"headerView";
    P2PSettingHeader *headerView=[tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (headerView==nil) {
        headerView=[[P2PSettingHeader alloc]initWithReuseIdentifier:ID];
    }
    return headerView;
}

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.backgroundView = [[UIImageView alloc] initWithFrame:self.frame];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        btn.imageView.contentMode=UIViewContentModeCenter;
//        [btn setImage:[UIImage imageNamed:@"call_guan"] forState:UIControlStateNormal];
        btn.imageView.clipsToBounds=NO;
        btn.contentEdgeInsets=UIEdgeInsetsMake(0, 10, 0, 0);
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, VIEWWIDTH-50, 0, 10)];
        btn.titleLabel.font=[UIFont systemFontOfSize:15];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        self.button = btn;
        
        
    }
    return self;
}

-(void)setName:(NSString *)name{
    if ([name compare:NSLocalizedString(@"modify_visitor_password",nil)]) {
        _flag = 0;
    }else{
        _flag = 1;
    }
    [self.button setTitle:name forState:UIControlStateNormal];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    //此处frame和bounds的y值是不同的，此处因为我们的x和y始终是0，所以用bounds
    self.button.frame=self.bounds;
    
}

-(void)clickBtn:(UIButton *)btn{
    self.isOpen = !self.isOpen;
    if ([self.delegate respondsToSelector:@selector(headerViewDidClickBtn:)]) {
        [self.delegate headerViewDidClickBtn:self];
    }
}




@end
