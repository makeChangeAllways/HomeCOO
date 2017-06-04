//
//  UnBindPhoneController.m
//  2cu
//
//  Created by mac on 15/10/19.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//

#import "UnBindPhoneController.h"
#import "PrefixHeader.pch"

@interface UnBindPhoneController ()

@end

@implementation UnBindPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UI_init];
    
}



#pragma mark --- UI
- (void)UI_init
{
    // base setting
    self.topBar.titleLabel.text = @"绑定手机号码";
    
    self.view.backgroundColor = ColorWithRGB(238, 238, 238);
    
    // 手机号码label
    UILabel *phone_label = [[UILabel alloc] init];
    phone_label.text = self.pre_phone;
    CGSize text_size = [self sizeWithString:self.pre_phone font:[UIFont systemFontOfSize:15]];
    phone_label.font = [UIFont systemFontOfSize:15];
    phone_label.frame = (CGRect){{(VIEWWIDTH - text_size.width) / 2,BottomForView(self.topBar) + 10 },text_size};
    [self.view addSubview:phone_label];
    
    
    // 解除绑定按钮
    UIButton *un_bind_btn = [[UIButton alloc] init];
    CGFloat btn_w = 120;
    un_bind_btn.frame = CGRectMake( (VIEWWIDTH - btn_w ) / 2, BottomForView(phone_label) + 10, btn_w, 40);
    [un_bind_btn setBackgroundColor:ColorWithRGB(218, 241, 251)];
    un_bind_btn.layer.borderWidth = 1.5f;
    un_bind_btn.layer.borderColor = ColorWithRGB(187, 219, 241).CGColor;
    [un_bind_btn setTitle:@"解除绑定" forState:UIControlStateNormal];
    [un_bind_btn setTitleColor:ColorWithRGB(111, 178, 223) forState:UIControlStateNormal];
    [un_bind_btn addTarget:self action:@selector(UN_Bind) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:un_bind_btn];
    
    
    
}
#pragma mark --- DATA

-(void)UN_Bind
{
    ALERTSHOW(NSLocalizedString(@"提示", nil),NSLocalizedString(@"解除绑定", nil));
}


-(void)DATA_init
{
    
}

//  计算字符宽高
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(VIEWWIDTH - 20, MAXFLOAT)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    
    return rect.size;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
