//
//  BindingPhonoController.m
//  2cu
//
//  Created by mac on 15/10/19.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//

#import "BindingPhonoController.h"
#import "BindPhoneCaptchaController.h"
#import "PrefixHeader.pch"
@interface BindingPhonoController () <UITextFieldDelegate>

@property(nonatomic,strong)UITextField *phone_field;

@end

@implementation BindingPhonoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self UI_init];
}

- (void)UI_init
{
    
    self.view.backgroundColor = ColorWithRGB(238, 238, 238);
    
    self.topBar.titleLabel.text = @"绑定手机号码";
    [self.topBar.rightButton setHidden:NO];
    [self.topBar.rightButtonIconView setHidden:YES];
    [self.topBar.rightButtonLabel setHidden:YES];
    [self.topBar.rightButton setBackgroundColor:[UIColor colorWithRed:87/255.0 green:194/255.0 blue:244/255.0 alpha:1.0]];
    [self.topBar.rightButton setTitle:@"下一步" forState:UIControlStateNormal];
    self.topBar.rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.topBar.rightButton addTarget:self action:@selector(next_stup) forControlEvents:UIControlEventTouchUpInside];
    
    UITextField *phone_field = [[UITextField alloc] initWithFrame:CGRectMake(10, BottomForView(self.topBar) + 10, VIEWWIDTH - 20, 30)];
    phone_field.delegate = self;
    self.phone_field = phone_field;
    [self.view addSubview:phone_field];
    phone_field.placeholder = self.pre_phone;
    phone_field.borderStyle = UITextBorderStyleRoundedRect;

}

#pragma mark - 点击下一步
-(void)next_stup
{
    if (self.phone_field.text.length == 11) {
        BindPhoneCaptchaController *bing_capt = [[BindPhoneCaptchaController alloc] init];
        bing_capt.bind_phone = self.phone_field.text;
        [self.navigationController pushViewController:bing_capt animated:YES];
    }else
    {
        /*
        ALERTSHOW(@"请输入11位手机号码")
         */
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 判断只输入文字和限制长度
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    // Check for non-numeric characters
    NSUInteger lengthOfString = string.length;
    for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {//只允许数字输入
        unichar character = [string characterAtIndex:loopIndex];
        if (character < 48) return NO; // 48 unichar for 0
        if (character > 57) return NO; // 57 unichar for 9
    }
    // Check for total length
    NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
    if (proposedNewLength > 11) return NO;//限制长度
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
