//
//  SettingChangeEmailController.m
//  2cu
//
//  Created by mac on 15/10/19.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//

#import "SettingChangeEmailController.h"
#import "PrefixHeader.pch"
@interface SettingChangeEmailController ()
@property(nonatomic,strong)UITextField *email_field;

@end

@implementation SettingChangeEmailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self UI_init];
    [self DATA_init];
    
}


#pragma mark --- UI
- (void)UI_init
{
    self.view.backgroundColor = ColorWithRGB(238, 238, 238);
    
    self.topBar.titleLabel.text = @"修改邮箱";
    [self.topBar.rightButton setHidden:NO];
    [self.topBar.rightButtonIconView setHidden:YES];
    [self.topBar.rightButtonLabel setHidden:YES];
    [self.topBar.rightButton setBackgroundColor:[UIColor colorWithRed:87/255.0 green:194/255.0 blue:244/255.0 alpha:1.0]];
    [self.topBar.rightButton setTitle:@"下一步" forState:UIControlStateNormal];
    self.topBar.rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.topBar.rightButton addTarget:self action:@selector(next_stup) forControlEvents:UIControlEventTouchUpInside];
    

    UITextField *email_field = [[UITextField alloc] initWithFrame:CGRectMake(10, BottomForView(self.topBar) + 10, VIEWWIDTH - 20, 30)];
    [self.view addSubview:email_field];
    email_field.placeholder = self.pre_email;
    email_field.borderStyle = UITextBorderStyleRoundedRect;
    self.email_field = email_field;
    
    
}
#pragma mark --- DATA
-(void)DATA_init
{
    
}



#pragma mark - 点击下一步
-(void)next_stup
{
    NSString *email = [NSString stringWithFormat:@"下一步 --- %@",self.email_field.text];
    ALERTSHOW(NSLocalizedString(@"提示", nil), NSLocalizedString(@"next", nil));
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
