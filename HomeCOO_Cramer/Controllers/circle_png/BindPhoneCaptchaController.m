//
//  BindPhoneCaptchaController.m
//  2cu
//
//  Created by mac on 15/10/20.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//

#import "BindPhoneCaptchaController.h"
#import "PrefixHeader.pch"
@interface BindPhoneCaptchaController ()

@property(nonatomic,strong)UIButton *captcha_btn; // 获取验证码按钮

@end

@implementation BindPhoneCaptchaController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self UI_init];
    
}


#pragma mark - 初始化UI
- (void)UI_init
{
    // base setting
    self.view.backgroundColor = ColorWithRGB(238, 238, 238);
    
    self.topBar.titleLabel.text = @"绑定手机号码";
    [self.topBar.rightButton setHidden:NO];
    [self.topBar.rightButtonIconView setHidden:YES];
    [self.topBar.rightButtonLabel setHidden:YES];
    [self.topBar.rightButton setBackgroundColor:[UIColor colorWithRed:87/255.0 green:194/255.0 blue:244/255.0 alpha:1.0]];
    [self.topBar.rightButton setTitle:@"下一步" forState:UIControlStateNormal];
    self.topBar.rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.topBar.rightButton addTarget:self action:@selector(next_stup) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 验证码 label
    UILabel *captcha_l = [[UILabel alloc] initWithFrame:CGRectMake(10, BottomForView(self.topBar) + 20, 200, 20)];
    [self.view addSubview:captcha_l];
    captcha_l.text = @"验证码已经发送至";
    captcha_l.textColor = ColorWithRGB(133, 183, 222);
    [self.view addSubview:captcha_l];
    
    // 手机号码label
    UILabel *phone_l = [[UILabel alloc] initWithFrame:CGRectMake(XForView(captcha_l), BottomForView(captcha_l) + 20, 200, 20)];
    phone_l.textColor = ColorWithRGB(133, 183, 222);
    phone_l.text = [NSString stringWithFormat:@"+86 %@",self.bind_phone];
    [self.view addSubview:phone_l];
    
    
    // 验证码 输入框
    UITextField *captcha_field = [[UITextField alloc] initWithFrame:CGRectMake(XForView(captcha_l), BottomForView(phone_l) + 20, 100, 30)];
    captcha_field.placeholder = @"验证码";
    captcha_field.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:captcha_field];
    
    
    // 重获验证码btn
    UIButton *get_captcha_btn = [[UIButton alloc] initWithFrame:CGRectMake(RightForView(captcha_field) + 10, YForView(captcha_field) , 150, 30)];
    [get_captcha_btn addTarget:self action:@selector(send_captcha:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:get_captcha_btn];
    get_captcha_btn.layer.borderWidth = 1.0f;
    get_captcha_btn.layer.borderColor = ColorWithRGB(185, 218, 240).CGColor;
    [get_captcha_btn setBackgroundColor:ColorWithRGB(218, 241, 251)];
    [get_captcha_btn setTitleColor:ColorWithRGB(136, 192, 229) forState:UIControlStateNormal];
    self.captcha_btn = get_captcha_btn;
    [self startTime:get_captcha_btn];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)send_captcha:(UIButton *)capt_btn
{
    [self startTime:capt_btn]; // 倒计时
    ALERTSHOW(NSLocalizedString(@"提示",nil),NSLocalizedString(@"发送验证码",nil));
}


// 倒计时
-(void)startTime:(UIButton *)securityBtn
{
    __block int timeout= 180; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [securityBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                securityBtn.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 181;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [securityBtn setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                securityBtn.userInteractionEnabled = NO;
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
}


-(void)next_stup
{
    ALERTSHOW(NSLocalizedString(@"提示", nil),NSLocalizedString(@"next", nil));
}


@end
