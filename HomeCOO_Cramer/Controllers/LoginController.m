

#import "LoginController.h"
#import "Constants.h"
#import "Utils.h"
#import "Toast+UIView.h"
#import "NetManager.h"
#import "MBProgressHUD.h"
#import "MainController.h"
#import "LoginResult.h"
#import "UDManager.h"
#import "AppDelegate.h"
#import "TopBar.h"
#import "AccountResult.h"
#import "Toast+UIView.h"
#import "ChooseCountryController.h"
#import "EmailRegisterController.h"
#import "BindPhoneController.h"
#import "CheckNewMessageResult.h"
#import "GetContactMessageResult.h"
#import "Message.h"
#import "MessageDAO.h"
#import "FListManager.h"
#import "ContactDAO.h"
#import "NewRegisterController.h"
#import "PrefixHeader.pch"

@interface LoginController ()

@end

@implementation LoginController

-(void)dealloc{
    [self.usernameField1 release];
    [self.passwrodField1 release];
    [self.progressAlert release];
    [self.leftLabel release];
    [self.rightLabel release];
    [self.countryCode release];
    [self.countryName release];
    [self.lastRegisterId release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    /*
     *设置通知监听者，监听键盘的显示、收起通知
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    /*
     *手机号登录时，设置国码和国名字
     */
    if(!self.countryCode||!self.countryCode.length>0){
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        
        if([language hasPrefix:@"zh"]){
            self.countryCode = @"86";
            self.countryName = NSLocalizedString(@"china", nil);
        }else{
            self.countryCode = @"1";
            self.countryName = NSLocalizedString(@"america", nil);
        }
        
    }
    
    /*
     *将已经存在的注册ID显示在用户名区
     */
    if(self.lastRegisterId&&self.lastRegisterId.length>0){
        self.usernameField1.text = self.lastRegisterId;
    }
    
    /*
     *leftLabel显示国码
     *rightLabel显示国家名字
     */
    self.leftLabel.text = [NSString stringWithFormat:@"+%@",self.countryCode];
    self.rightLabel.text = self.countryName;
    
    /*
     *没有理解？
     */
    if(self.isSessionIdError){
        self.isSessionIdError = !self.isSessionIdError;
        [self.view makeToast:NSLocalizedString(@"session_error", nil) duration:2.0 position:@"center"];
        
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    /*
     *移除对键盘将要显示、收起的监听
     */
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*
     *初始化用户登录的类型，分别是邮箱登录、手机号登录
     *0表示邮箱登录；1表示手机号登录
     */
    self.loginType = [[NSUserDefaults standardUserDefaults] integerForKey:@"LOGIN_TYPE"];
    self.loginType = 1;
    [self initComponent];
    
    
   
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
 *设置登录按钮的 iPhone和iPad的高度
 */
#define LOGIN_BTN_HEIGHT (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 60:38)
#define SEGMENT_HEIGHT (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 60:38)
/*
 *设置注册图标的 宽 和 高
 */
#define REGISTER_ICON_WIDTH_AND_HEIGHT 24
/*
 *设置匿名登录按钮的 iPhone、iPad高 和 宽
 */
#define ANONYMOUS_BTN_HEIGHT (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 50:30)
#define ANONYMOUS_BTN_WIDTH (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 100:100)

-(void)initComponent{
    [self.view setBackgroundColor:ColorWithRGB(232, 232, 232)];

    /*
     *第三方类MBProgressHUD:
     *没有理解这个语句的意义
     *类MBProgressHUD的作用是什么？
     */
    self.progressAlert = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
    

    CGRect rect = [AppDelegate getScreenSize:YES isHorizontal:NO];
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    /*
     *TopBar(继承UIView)
     *自定义一个假的导航，显示在导航栏位置
     */
    TopBar *topBar = [[TopBar alloc] initWithFrame:CGRectMake(0, 0, width, NAVIGATION_BAR_HEIGHT)];
    [topBar setTitle:NSLocalizedString(@"account_login",nil)];
    [self.view addSubview:topBar];
    topBar.rightButton.hidden=NO;
    [topBar.rightButton setTitle:NSLocalizedString(@"register",nil) forState:UIControlStateNormal];
    [topBar.rightButton addTarget:self action:@selector(onRegisterPress) forControlEvents:UIControlEventTouchUpInside];
    [topBar.rightButton setTitleColor:[UIColor colorWithRed:0x00/255.0 green:0x99/255.0 blue:0xd7/255.0 alpha:1] forState:UIControlStateNormal];
    [topBar release];
    
//    UIView*titleview=[[UIView alloc]init];
//    [self.view addSubview:titleview];
//    titleview.frame=CGRectMake(0, 0, width, NAVIGATION_BAR_HEIGHT);
//    titleview.backgroundColor=[UIColor colorWithRed:0x00/255.0 green:0x99/255.0 blue:0xd7/255.0 alpha:1];
//    
//    UILabel*titlab=[[UILabel alloc]init];
//    titlab.textColor=[UIColor whiteColor];
//    [titleview addSubview:titlab];
//    titlab.text=@"用户登录";
//    titlab.textAlignment=NSTextAlignmentCenter;
//    titlab.frame=CGRectMake(100, 0, width-200, NAVIGATION_BAR_HEIGHT);
//    
//    UIButton*registerbtn=[[UIButton alloc]init];
//    [titleview addSubview:registerbtn];
//    [registerbtn setTitle:@"注册" forState:UIControlStateNormal];
//    [registerbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    registerbtn.titleLabel.font=[UIFont systemFontOfSize:11];
//    registerbtn.frame=CGRectMake(WidthForView(titleview)-60, 10, 50, NAVIGATION_BAR_HEIGHT);
//    [registerbtn addTarget:self action:@selector(onRegisterPress) forControlEvents:UIControlEventTouchUpInside];
    
    
//
//    
//    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[NSLocalizedString(@"email_id_login", nil),NSLocalizedString(@"phone_login", nil)]];
//    [segment addTarget:self action:@selector(onLoginTypeChange:) forControlEvents:UIControlEventValueChanged];
//    segment.frame = CGRectMake(30, NAVIGATION_BAR_HEIGHT+20, width-30*2, SEGMENT_HEIGHT);
//    segment.segmentedControlStyle = UISegmentedControlStyleBar;
//    segment.selectedSegmentIndex = self.loginType;
//    [self.view addSubview:segment];
//    [segment release];
    
    
    
    
    /*
     *mainView1表示邮箱登录界面
     */
//    UIView *mainView1 = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT+20+SEGMENT_HEIGHT, width, height-NAVIGATION_BAR_HEIGHT-SEGMENT_HEIGHT-20)];
//    
//    
//    
//    UITextField *field1 = [[UITextField alloc] initWithFrame:CGRectMake(BAR_BUTTON_MARGIN_LEFT_AND_RIGHT, 20, width-BAR_BUTTON_MARGIN_LEFT_AND_RIGHT*2, TEXT_FIELD_HEIGHT)];
//    if(CURRENT_VERSION>=7.0){
//        field1.layer.borderWidth = 1;
//        field1.layer.borderColor = [[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor];
//        field1.layer.cornerRadius = 5.0;
//    }
//    field1.textAlignment = NSTextAlignmentLeft;
//    field1.placeholder = NSLocalizedString(@"input_username", nil);
//    field1.borderStyle = UITextBorderStyleRoundedRect;
//    field1.returnKeyType = UIReturnKeyDone;
//    field1.autocapitalizationType = UITextAutocapitalizationTypeNone;
//    field1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    [field1 addTarget:self action:@selector(onKeyBoardDown:) forControlEvents:UIControlEventEditingDidEndOnExit];
//    field1.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"USER_NAME"];
//    [mainView1 addSubview:field1];
//    self.usernameField1 = field1;
//    [field1 release];
//    
//
//    
//    UITextField *field2 = [[UITextField alloc] initWithFrame:CGRectMake(BAR_BUTTON_MARGIN_LEFT_AND_RIGHT, 20*2+TEXT_FIELD_HEIGHT, width-BAR_BUTTON_MARGIN_LEFT_AND_RIGHT*2, TEXT_FIELD_HEIGHT)];
//    if(CURRENT_VERSION>=7.0){
//        field2.layer.borderWidth = 1;
//        field2.layer.borderColor = [[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor];
//        field2.layer.cornerRadius = 5.0;
//    }
//    field2.textAlignment = NSTextAlignmentLeft;
//    field2.placeholder = NSLocalizedString(@"input_password", nil);
//    field2.borderStyle = UITextBorderStyleRoundedRect;
//    field2.returnKeyType = UIReturnKeyDone;
//    field2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    [field2 addTarget:self action:@selector(onKeyBoardDown:) forControlEvents:UIControlEventEditingDidEndOnExit];
//    field2.secureTextEntry = YES;
//    [mainView1 addSubview:field2];
//    self.passwrodField1 = field2;
//    [field2 release];
//    
//    
//    /* 登陆button */
//    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [loginBtn setTitle:NSLocalizedString(@"login", nil) forState:UIControlStateNormal];
//    loginBtn.frame = CGRectMake(NORMAL_BUTTON_MARGIN_LEFT_AND_RIGHT,TEXT_FIELD_HEIGHT*2+20*3, width-NORMAL_BUTTON_MARGIN_LEFT_AND_RIGHT*2, LOGIN_BTN_HEIGHT);
//    UIImage *loginBtnBackImg = [UIImage imageNamed:@"bg_button.png"];
//    loginBtnBackImg = [loginBtnBackImg stretchableImageWithLeftCapWidth:loginBtnBackImg.size.width*0.5 topCapHeight:loginBtnBackImg.size.height*0.5];
//    
//    UIImage *loginBtnBackImg_p = [UIImage imageNamed:@"bg_button_p.png"];
//    loginBtnBackImg_p = [loginBtnBackImg_p stretchableImageWithLeftCapWidth:loginBtnBackImg_p.size.width*0.5 topCapHeight:loginBtnBackImg_p.size.height*0.5];
//    
//    [loginBtn setBackgroundImage:loginBtnBackImg forState:UIControlStateNormal];
//    [loginBtn setBackgroundImage:loginBtnBackImg_p forState:UIControlStateHighlighted];
//    [loginBtn addTarget:self action:@selector(onLoginPress:) forControlEvents:UIControlEventTouchUpInside];
//    [mainView1 addSubview:loginBtn];
//    
//    
//    /* 新用户注册button */
////    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
////    [registerBtn setTitle:NSLocalizedString(@"new_account_register", nil) forState:UIControlStateNormal];
////    registerBtn.frame = CGRectMake(NORMAL_BUTTON_MARGIN_LEFT_AND_RIGHT,loginBtn.frame.origin.y+LOGIN_BTN_HEIGHT+20, width-NORMAL_BUTTON_MARGIN_LEFT_AND_RIGHT*2, LOGIN_BTN_HEIGHT);
////    UIImage *registerBtnBackImg = [UIImage imageNamed:@"bg_button.png"];
////    registerBtnBackImg = [registerBtnBackImg stretchableImageWithLeftCapWidth:registerBtnBackImg.size.width*0.5 topCapHeight:registerBtnBackImg.size.height*0.5];
////    
////    UIImage *registerBtnBackImg_p = [UIImage imageNamed:@"bg_button_p.png"];
////    registerBtnBackImg_p = [registerBtnBackImg_p stretchableImageWithLeftCapWidth:registerBtnBackImg_p.size.width*0.5 topCapHeight:registerBtnBackImg_p.size.height*0.5];
////    
////    [registerBtn setBackgroundImage:registerBtnBackImg forState:UIControlStateNormal];
////    [registerBtn setBackgroundImage:registerBtnBackImg_p forState:UIControlStateHighlighted];
////    [registerBtn addTarget:self action:@selector(onRegisterPress) forControlEvents:UIControlEventTouchUpInside];
////    [mainView1 addSubview:registerBtn];
//    
//    
//    
//    CGFloat label1TextWidth = [Utils getStringWidthWithString:NSLocalizedString(@"register_type_phone", nil) font:XFontBold_14 maxWidth:width];
//    UIButton *labelButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    labelButton1.frame = CGRectMake(width-BAR_BUTTON_MARGIN_LEFT_AND_RIGHT-label1TextWidth-REGISTER_ICON_WIDTH_AND_HEIGHT, TEXT_FIELD_HEIGHT*2+20*4+LOGIN_BTN_HEIGHT, REGISTER_ICON_WIDTH_AND_HEIGHT+label1TextWidth, TEXT_FIELD_HEIGHT);
//    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0,0,labelButton1.frame.size.width,labelButton1.frame.size.height)];
//    label1.textAlignment = NSTextAlignmentRight;
//    label1.textColor = XBlack;
//    label1.backgroundColor = XBGAlpha;
//    label1.text = NSLocalizedString(@"register_type_phone", nil);
//    label1.font = XFontBold_14;
//    [labelButton1 addTarget:self action:@selector(onPhoneRegisterPress) forControlEvents:UIControlEventTouchUpInside];
//    
//
//    UIImageView *label1IconView = [[UIImageView alloc] initWithFrame:CGRectMake(label1.frame.size.width-label1TextWidth-REGISTER_ICON_WIDTH_AND_HEIGHT, (label1.frame.size.height-REGISTER_ICON_WIDTH_AND_HEIGHT)/2, REGISTER_ICON_WIDTH_AND_HEIGHT, REGISTER_ICON_WIDTH_AND_HEIGHT)];
//    label1IconView.image = [UIImage imageNamed:@"ic_register_type_phone.png"];
//    [label1 addSubview:label1IconView];
//    [label1IconView release];
//    
//    [labelButton1 addSubview:label1];
////    [mainView1 addSubview:labelButton1];
//    [label1 release];
//    
//    
//    CGFloat label2TextWidth = [Utils getStringWidthWithString:NSLocalizedString(@"register_type_email", nil) font:XFontBold_14 maxWidth:width];
//    UIButton *labelButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    labelButton2.frame = CGRectMake(width-BAR_BUTTON_MARGIN_LEFT_AND_RIGHT-label2TextWidth-REGISTER_ICON_WIDTH_AND_HEIGHT, TEXT_FIELD_HEIGHT*3+20*4+LOGIN_BTN_HEIGHT, REGISTER_ICON_WIDTH_AND_HEIGHT+label2TextWidth, TEXT_FIELD_HEIGHT);
//    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0,0,labelButton2.frame.size.width,labelButton2.frame.size.height)];
//    label2.textAlignment = NSTextAlignmentRight;
//    label2.textColor = XBlack;
//    label2.backgroundColor = XBGAlpha;
//    label2.text = NSLocalizedString(@"register_type_email", nil);
//    label2.font = XFontBold_14;
//    
//    [labelButton2 addTarget:self action:@selector(onEmailRegisterPress) forControlEvents:UIControlEventTouchUpInside];
//    
//
//    UIImageView *label2IconView = [[UIImageView alloc] initWithFrame:CGRectMake(label2.frame.size.width-label2TextWidth-REGISTER_ICON_WIDTH_AND_HEIGHT, (label2.frame.size.height-REGISTER_ICON_WIDTH_AND_HEIGHT)/2, REGISTER_ICON_WIDTH_AND_HEIGHT, REGISTER_ICON_WIDTH_AND_HEIGHT)];
//    label2IconView.image = [UIImage imageNamed:@"ic_register_type_email.png"];
//    [label2 addSubview:label2IconView];
//    [label2IconView release];
//    
//    [labelButton2 addSubview:label2];
////    [mainView1 addSubview:labelButton2];
//    [label2 release];
//    
//    CGFloat forgetLabelWidth1 = [Utils getStringWidthWithString:NSLocalizedString(@"forget_password", nil) font:XFontBold_14 maxWidth:width];
//    
//    UIButton *forgetButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    forgetButton1.frame = CGRectMake(width-BAR_BUTTON_MARGIN_LEFT_AND_RIGHT-forgetLabelWidth1, labelButton2.frame.origin.y+TEXT_FIELD_HEIGHT+20, forgetLabelWidth1, TEXT_FIELD_HEIGHT);
//    UILabel *forgetLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0,0,forgetButton1.frame.size.width,forgetButton1.frame.size.height)];
//    forgetLabel1.textAlignment = NSTextAlignmentRight;
//    forgetLabel1.textColor = XBlack;
//    forgetLabel1.backgroundColor = XBGAlpha;
//    forgetLabel1.text = NSLocalizedString(@"forget_password", nil);
//    forgetLabel1.font = XFontBold_14;
//    [forgetButton1 addSubview:forgetLabel1];
//    [forgetLabel1 release];
//    [forgetButton1 addTarget:self action:@selector(onForgetPassword:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [mainView1 addSubview:forgetButton1];
//    
//    UIButton *anonymousLoginBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    anonymousLoginBtn1.frame = CGRectMake(10,forgetButton1.frame.origin.y+(forgetButton1.frame.size.height-ANONYMOUS_BTN_HEIGHT)/2,ANONYMOUS_BTN_WIDTH,ANONYMOUS_BTN_HEIGHT);
//    UIImage *anonymousLoginBtnBackImg = [UIImage imageNamed:@"bg_button.png"];
//    anonymousLoginBtnBackImg = [anonymousLoginBtnBackImg stretchableImageWithLeftCapWidth:anonymousLoginBtnBackImg.size.width*0.5 topCapHeight:anonymousLoginBtnBackImg.size.height*0.5];
//    
//    UIImage *anonymousLoginBtnBackImg_p = [UIImage imageNamed:@"bg_button_p.png"];
//    anonymousLoginBtnBackImg_p = [anonymousLoginBtnBackImg_p stretchableImageWithLeftCapWidth:anonymousLoginBtnBackImg_p.size.width*0.5 topCapHeight:anonymousLoginBtnBackImg_p.size.height*0.5];
//    
//    [anonymousLoginBtn1 setBackgroundImage:anonymousLoginBtnBackImg forState:UIControlStateNormal];
//    [anonymousLoginBtn1 setBackgroundImage:anonymousLoginBtnBackImg_p forState:UIControlStateHighlighted];
//    [anonymousLoginBtn1 addTarget:self action:@selector(onAnonymousLoginPress:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UILabel *anonymousLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, anonymousLoginBtn1.frame.size.width, anonymousLoginBtn1.frame.size.height)];
//    anonymousLabel1.textAlignment = NSTextAlignmentCenter;
//    anonymousLabel1.textColor = XWhite;
//    anonymousLabel1.text = NSLocalizedString(@"anonymous_login", nil);
//    anonymousLabel1.font = [UIFont systemFontOfSize:10.0];
//    anonymousLabel1.backgroundColor = [UIColor clearColor];
//    
//    [anonymousLoginBtn1 addSubview:anonymousLabel1];
//    [anonymousLabel1 release];
//    //[mainView1 addSubview:anonymousLoginBtn1];
//    
//    
//    
//    self.mainView1 = mainView1;
//    [self.view addSubview:mainView1];
//    [mainView1 release];
    
    
    /*
     *mainView2表示手机号登录界面
     */
//    UIView *mainView2 = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT+20+SEGMENT_HEIGHT, width, height-NAVIGATION_BAR_HEIGHT-SEGMENT_HEIGHT-20)];
    UIView *mainView2 = [[UIView alloc] initWithFrame:CGRectMake(0, BottomForView(topBar)+20, width, height-NAVIGATION_BAR_HEIGHT-SEGMENT_HEIGHT-20)];
    
//    UIButton *chooseCountryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    chooseCountryBtn.frame = CGRectMake(BAR_BUTTON_MARGIN_LEFT_AND_RIGHT, 20, width-BAR_BUTTON_MARGIN_LEFT_AND_RIGHT*2, TEXT_FIELD_HEIGHT);
//    chooseCountryBtn.layer.cornerRadius = 2.0;
//    chooseCountryBtn.layer.borderWidth = 1.0;
//    chooseCountryBtn.layer.borderColor = [[UIColor grayColor] CGColor];
//    chooseCountryBtn.backgroundColor = XWhite;
//    [chooseCountryBtn addTarget:self action:@selector(onChooseCountryPress:) forControlEvents:UIControlEventTouchUpInside];
//    [chooseCountryBtn addTarget:self action:@selector(lightButton:) forControlEvents:UIControlEventTouchDown];
//    [chooseCountryBtn addTarget:self action:@selector(normalButton:) forControlEvents:UIControlEventTouchCancel];
//    [chooseCountryBtn addTarget:self action:@selector(normalButton:) forControlEvents:UIControlEventTouchDragOutside];
//    [chooseCountryBtn addTarget:self action:@selector(normalButton:) forControlEvents:UIControlEventTouchUpOutside];
//    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, chooseCountryBtn.frame.size.width/3, chooseCountryBtn.frame.size.height)];
//    leftLabel.textAlignment = NSTextAlignmentCenter;
//    leftLabel.backgroundColor = XBGAlpha;
//    leftLabel.textColor = XBlack;
//    leftLabel.font = XFontBold_16;
//    self.leftLabel = leftLabel;
//    [leftLabel release];
//    [chooseCountryBtn addSubview:self.leftLabel];
//    
//    UIImageView *separator = [[UIImageView alloc] initWithFrame:CGRectMake(chooseCountryBtn.frame.size.width/3, 1, 0.5, chooseCountryBtn.frame.size.height-2)];
//    separator.backgroundColor = [UIColor grayColor];
//    [chooseCountryBtn addSubview:separator];
//    [separator release];
//    
//    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(chooseCountryBtn.frame.size.width/3+0.5, 0, chooseCountryBtn.frame.size.width/3*2-0.5, chooseCountryBtn.frame.size.height)];
//    rightLabel.textAlignment = NSTextAlignmentCenter;
//    rightLabel.backgroundColor = XBGAlpha;
//    rightLabel.textColor = XBlack;
//    rightLabel.font = XFontBold_16;
//    self.rightLabel = rightLabel;
//    [rightLabel release];
//    [chooseCountryBtn addSubview:self.rightLabel];
//    
//    [mainView2 addSubview: chooseCountryBtn];

//    UITextField *field3 = [[UITextField alloc] initWithFrame:CGRectMake(BAR_BUTTON_MARGIN_LEFT_AND_RIGHT, chooseCountryBtn.frame.origin.y+20+TEXT_FIELD_HEIGHT, width-BAR_BUTTON_MARGIN_LEFT_AND_RIGHT*2, TEXT_FIELD_HEIGHT)];
    
    
    
    
    
    UIImageView*headimg=[[UIImageView alloc]init];
    [headimg setFrame:CGRectMake((width-80)/2, 10, 80, 80)];
    headimg.image=[UIImage imageNamed:@"AppIcon60x60@2x"];//login_head
    [mainView2 addSubview:headimg];
    
    
    UILabel*label=[[UILabel alloc]init];
    [mainView2 addSubview:label];
    
    label.text=NSLocalizedString(@"account", nil);
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    label.textAlignment = NSTextAlignmentRight;
    if ([language isEqualToString:@"en"]) {
        [label setFrame:CGRectMake(20, BottomForView(headimg)+20, 80, TEXT_FIELD_HEIGHT)];
        label.textAlignment = NSTextAlignmentRight;
    }else
    {
        [label setFrame:CGRectMake(30, BottomForView(headimg)+20, 50, TEXT_FIELD_HEIGHT)];
        label.textAlignment = NSTextAlignmentCenter;
    }
    
    UIView *View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"login_account"]];
    [imageView setFrame:CGRectMake(5, 5, 20 ,20)];
//    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [View addSubview:imageView];
    

    
    
     UITextField *field3 = [[UITextField alloc] initWithFrame:CGRectMake(RightForView(label) + 5, YForView(label), width-RightForView(label)-30, TEXT_FIELD_HEIGHT-5)];
    if(CURRENT_VERSION>=7.0){
//        field3.layer.borderWidth = 1;
//        field3.layer.borderColor = [[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor];
//        field3.layer.cornerRadius = 5.0;
    }
    field3.textAlignment = NSTextAlignmentLeft;
    field3.placeholder = NSLocalizedString(@"input_phone", nil);
//    field3.borderStyle = UITextBorderStyleBezel;
    field3.backgroundColor=[UIColor whiteColor];
    field3.returnKeyType = UIReturnKeyDone;
    field3.layer.borderWidth=1.0;
    field3.layer.borderColor = [[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor];
    field3.clearButtonMode=UITextFieldViewModeWhileEditing;
    field3.autocapitalizationType = UITextAutocapitalizationTypeNone;
    field3.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [field3 addTarget:self action:@selector(onKeyBoardDown:) forControlEvents:UIControlEventEditingDidEndOnExit];
    field3.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    field3.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"PHONE_NUMBER"];
    
    NSString *userstr=[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_NAME"];
    if (userstr.length>0) {
        field3.text=userstr;
    }
    
    [mainView2 addSubview:field3];
    [field3 setLeftViewMode:UITextFieldViewModeAlways];
    [field3 setLeftView:View];
//      field3.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    field3.layer.cornerRadius=5.0;
    self.usernameField2 = field3;
    
    
    UILabel*label2=[[UILabel alloc]init];
    [mainView2 addSubview:label2];
    
    
    label2.text=NSLocalizedString(@"password", nil);
    if ([language isEqualToString:@"en"]) {
        [label2 setFrame:CGRectMake(XForView(label), BottomForView(field3)+20, 80, TEXT_FIELD_HEIGHT)];
        label2.textAlignment = NSTextAlignmentRight;
    }else
    {
        [label2 setFrame:CGRectMake(XForView(label), BottomForView(field3)+20, 50, TEXT_FIELD_HEIGHT)];
        label2.textAlignment = NSTextAlignmentCenter;
    }
    
    View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"login_password"]];
    [imageView setFrame:CGRectMake(5, 5, 20,20)];
    [View addSubview:imageView];

    
//    UITextField *field4 = [[UITextField alloc] initWithFrame:CGRectMake(BAR_BUTTON_MARGIN_LEFT_AND_RIGHT, field3.frame.origin.y+20+TEXT_FIELD_HEIGHT ,width-BAR_BUTTON_MARGIN_LEFT_AND_RIGHT*2, TEXT_FIELD_HEIGHT)];
    UITextField *field4 = [[UITextField alloc] initWithFrame:CGRectMake(RightForView(label2) + 5, BottomForView(field3)+20 ,WidthForView(field3), HeightForView(field3))];
    if(CURRENT_VERSION>=7.0){
//        field4.layer.borderWidth = 1;
//        field4.layer.borderColor = [[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor];
//        field4.layer.cornerRadius = 5.0;
    }
    field4.textAlignment = NSTextAlignmentLeft;
    field4.placeholder = NSLocalizedString(@"input_password", nil);
//    field4.borderStyle = UITextBorderStyleRoundedRect;
    field4.returnKeyType = UIReturnKeyDone;
    field4.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [field4 addTarget:self action:@selector(onKeyBoardDown:) forControlEvents:UIControlEventEditingDidEndOnExit];
    field4.secureTextEntry = YES;
    field4.backgroundColor=[UIColor whiteColor];
    [mainView2 addSubview:field4];
    [field4 setLeftViewMode:UITextFieldViewModeAlways];
    field4.layer.borderWidth=1.0;
    field4.layer.borderColor = [[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor];
    [field4 setLeftView:View];
    field4.delegate=self;
    field4.layer.cornerRadius=5.0;
    self.passwrodField2 = field4;
    
    
    
    UIButton *loginBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn2 setTitle:NSLocalizedString(@"login", nil) forState:UIControlStateNormal];
    loginBtn2.frame = CGRectMake(NORMAL_BUTTON_MARGIN_LEFT_AND_RIGHT,field4.frame.origin.y+20+TEXT_FIELD_HEIGHT, RightForView(field3)-NORMAL_BUTTON_MARGIN_LEFT_AND_RIGHT, LOGIN_BTN_HEIGHT);
//    UIImage *loginBtnBackImg2 = [UIImage imageNamed:@"bg_button.png"];
//    loginBtnBackImg2 = [loginBtnBackImg2 stretchableImageWithLeftCapWidth:loginBtnBackImg2.size.width*0.5 topCapHeight:loginBtnBackImg2.size.height*0.5];
//    
//    UIImage *loginBtnBackImg_p2 = [UIImage imageNamed:@"bg_button_p.png"];
//    loginBtnBackImg_p2 = [loginBtnBackImg_p2 stretchableImageWithLeftCapWidth:loginBtnBackImg_p2.size.width*0.5 topCapHeight:loginBtnBackImg_p2.size.height*0.5];
//    
//    [loginBtn2 setBackgroundImage:loginBtnBackImg2 forState:UIControlStateNormal];
//    [loginBtn2 setBackgroundImage:loginBtnBackImg_p2 forState:UIControlStateHighlighted];
    loginBtn2.backgroundColor=[UIColor colorWithRed:58/255.0 green:180/255.0 blue:243/255.0 alpha:1];
    [loginBtn2 addTarget:self action:@selector(onLoginPress:) forControlEvents:UIControlEventTouchUpInside];
    [mainView2 addSubview:loginBtn2];

    
    [field3 release];
    [field4 release];
    
    /* mainView2 注册button*/
    UIButton *registerBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerBtn2 setTitle:NSLocalizedString(@"new_account_register", nil) forState:UIControlStateNormal];
    registerBtn2.frame = CGRectMake(NORMAL_BUTTON_MARGIN_LEFT_AND_RIGHT,loginBtn2.frame.origin.y+LOGIN_BTN_HEIGHT+20, width-NORMAL_BUTTON_MARGIN_LEFT_AND_RIGHT*2, LOGIN_BTN_HEIGHT);
    UIImage *registerBtnBackImg2 = [UIImage imageNamed:@"bg_button.png"];
    registerBtnBackImg2 = [registerBtnBackImg2 stretchableImageWithLeftCapWidth:registerBtnBackImg2.size.width*0.5 topCapHeight:registerBtnBackImg2.size.height*0.5];
    
    UIImage *registerBtnBackImg_p2 = [UIImage imageNamed:@"bg_button_p.png"];
    registerBtnBackImg_p2 = [registerBtnBackImg_p2 stretchableImageWithLeftCapWidth:registerBtnBackImg_p2.size.width*0.5 topCapHeight:registerBtnBackImg_p2.size.height*0.5];
    
    [registerBtn2 setBackgroundImage:registerBtnBackImg2 forState:UIControlStateNormal];
    [registerBtn2 setBackgroundImage:registerBtnBackImg_p2 forState:UIControlStateHighlighted];
    [registerBtn2 addTarget:self action:@selector(onRegisterPress) forControlEvents:UIControlEventTouchUpInside];
//    [mainView2 addSubview:registerBtn2];

    
    
    CGFloat label3TextWidth = [Utils getStringWidthWithString:NSLocalizedString(@"register_type_phone", nil) font:XFontBold_14 maxWidth:width];
    UIButton *labelButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    labelButton3.frame = CGRectMake(width-BAR_BUTTON_MARGIN_LEFT_AND_RIGHT-label3TextWidth-REGISTER_ICON_WIDTH_AND_HEIGHT, loginBtn2.frame.origin.y+20+LOGIN_BTN_HEIGHT, REGISTER_ICON_WIDTH_AND_HEIGHT+label3TextWidth, TEXT_FIELD_HEIGHT);
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0,0,labelButton3.frame.size.width,labelButton3.frame.size.height)];
    label3.textAlignment = NSTextAlignmentRight;
    label3.textColor = XBlack;
    label3.backgroundColor = XBGAlpha;
    label3.text = NSLocalizedString(@"register_type_phone", nil);
    label3.font = XFontBold_14;
    
    [labelButton3 addTarget:self action:@selector(onPhoneRegisterPress) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIImageView *label3IconView = [[UIImageView alloc] initWithFrame:CGRectMake(label3.frame.size.width-label3TextWidth-REGISTER_ICON_WIDTH_AND_HEIGHT, (label3.frame.size.height-REGISTER_ICON_WIDTH_AND_HEIGHT)/2, REGISTER_ICON_WIDTH_AND_HEIGHT, REGISTER_ICON_WIDTH_AND_HEIGHT)];
    label3IconView.image = [UIImage imageNamed:@"ic_register_type_phone.png"];
    [label3 addSubview:label3IconView];
    [label3IconView release];
    
    [labelButton3 addSubview:label3];
//    [mainView2 addSubview:labelButton3];
    
    
    
    CGFloat label4TextWidth = [Utils getStringWidthWithString:NSLocalizedString(@"register_type_email", nil) font:XFontBold_14 maxWidth:width];
    UIButton *labelButton4 = [UIButton buttonWithType:UIButtonTypeCustom];
    labelButton4.frame = CGRectMake(width-BAR_BUTTON_MARGIN_LEFT_AND_RIGHT-label4TextWidth-REGISTER_ICON_WIDTH_AND_HEIGHT, labelButton3.frame.origin.y+TEXT_FIELD_HEIGHT, REGISTER_ICON_WIDTH_AND_HEIGHT+label4TextWidth, TEXT_FIELD_HEIGHT);
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(0,0,labelButton4.frame.size.width,labelButton4.frame.size.height)];
    label4.textAlignment = NSTextAlignmentRight;
    label4.textColor = XBlack;
    label4.backgroundColor = XBGAlpha;
    label4.text = NSLocalizedString(@"register_type_email", nil);
    label4.font = XFontBold_14;
    
    [labelButton4 addTarget:self action:@selector(onEmailRegisterPress) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *label4IconView = [[UIImageView alloc] initWithFrame:CGRectMake(label4.frame.size.width-label4TextWidth-REGISTER_ICON_WIDTH_AND_HEIGHT, (label4.frame.size.height-REGISTER_ICON_WIDTH_AND_HEIGHT)/2, REGISTER_ICON_WIDTH_AND_HEIGHT, REGISTER_ICON_WIDTH_AND_HEIGHT)];
    label4IconView.image = [UIImage imageNamed:@"ic_register_type_email.png"];
    [label4 addSubview:label4IconView];
    [label4IconView release];
    
    [labelButton4 addSubview:label4];
//    [mainView2 addSubview:labelButton4];
    
    [label3 release];
    [label4 release];
    
    
    CGFloat forgetLabelWidth2 = [Utils getStringWidthWithString:NSLocalizedString(@"forget_password", nil) font:XFontBold_14 maxWidth:width];
    
    UIButton *forgetButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    forgetButton2.frame = CGRectMake(width-BAR_BUTTON_MARGIN_LEFT_AND_RIGHT-forgetLabelWidth2, registerBtn2.frame.origin.y+20+LOGIN_BTN_HEIGHT, forgetLabelWidth2, TEXT_FIELD_HEIGHT);
     forgetButton2.frame = CGRectMake(width-BAR_BUTTON_MARGIN_LEFT_AND_RIGHT-forgetLabelWidth2, BottomForView(loginBtn2), forgetLabelWidth2, TEXT_FIELD_HEIGHT);
    UILabel *forgetLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0,0,forgetButton2.frame.size.width,forgetButton2.frame.size.height)];
    forgetLabel2.textAlignment = NSTextAlignmentRight;
    forgetLabel2.textColor = XBlack;
    forgetLabel2.backgroundColor = XBGAlpha;
    forgetLabel2.text = NSLocalizedString(@"forget_password", nil);
    forgetLabel2.font = XFontBold_14;
    [forgetButton2 addSubview:forgetLabel2];
    [forgetLabel2 release];
    [forgetButton2 addTarget:self action:@selector(onForgetPassword:) forControlEvents:UIControlEventTouchUpInside];
    
    [mainView2 addSubview:forgetButton2];
    
    /*
     *匿名登录按钮
     */
    UIButton *anonymousLoginBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    anonymousLoginBtn2.frame = CGRectMake(10,forgetButton2.frame.origin.y+(forgetButton2.frame.size.height-ANONYMOUS_BTN_HEIGHT)/2,ANONYMOUS_BTN_WIDTH,ANONYMOUS_BTN_HEIGHT);
    UIImage *anonymousLoginBtnBackImg2 = [UIImage imageNamed:@"bg_button.png"];
    anonymousLoginBtnBackImg2 = [anonymousLoginBtnBackImg2 stretchableImageWithLeftCapWidth:anonymousLoginBtnBackImg2.size.width*0.5 topCapHeight:anonymousLoginBtnBackImg2.size.height*0.5];
    
    UIImage *anonymousLoginBtnBackImg_p2 = [UIImage imageNamed:@"bg_button_p.png"];
    anonymousLoginBtnBackImg_p2 = [anonymousLoginBtnBackImg_p2 stretchableImageWithLeftCapWidth:anonymousLoginBtnBackImg_p2.size.width*0.5 topCapHeight:anonymousLoginBtnBackImg_p2.size.height*0.5];
    
    [anonymousLoginBtn2 setBackgroundImage:anonymousLoginBtnBackImg2 forState:UIControlStateNormal];
    [anonymousLoginBtn2 setBackgroundImage:anonymousLoginBtnBackImg_p2 forState:UIControlStateHighlighted];
    [anonymousLoginBtn2 addTarget:self action:@selector(onAnonymousLoginPress:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *anonymousLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, anonymousLoginBtn2.frame.size.width, anonymousLoginBtn2.frame.size.height)];
    anonymousLabel2.textAlignment = NSTextAlignmentCenter;
    anonymousLabel2.textColor = XWhite;
    anonymousLabel2.text = NSLocalizedString(@"anonymous_login", nil);
    anonymousLabel2.font = [UIFont systemFontOfSize:10.0];
    anonymousLabel2.backgroundColor = [UIColor clearColor];
    
    [anonymousLoginBtn2 addSubview:anonymousLabel2];
    [anonymousLabel2 release];
    //[mainView2 addSubview:anonymousLoginBtn2];
    
    
    self.mainView2 = mainView2;
    [self.view addSubview:mainView2];
//    [mainView2 release];
    
    /*
     *初始化默认的登录界面
     */
    if(self.loginType==0){
        [self.mainView1 setHidden:NO];
        [self.mainView2 setHidden:YES];
    }else{
        [self.mainView1 setHidden:YES];
        [self.mainView2 setHidden:NO];
    }
    [self.view addSubview:self.progressAlert];
    
    
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];

    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.3f animations:^{
        self.view.frame=CGRectMake(0, self.view.frame.origin.y-100, VIEWWIDTH,  VIEWHEIGHT);
    }];
    
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.3f animations:^{
        self.view.frame=CGRectMake(0, 0, VIEWWIDTH,  VIEWHEIGHT);
    }];
    
}

#pragma mark - 监听键盘
#pragma mark 键盘将要显示时，调用
-(void)onKeyBoardWillShow:(NSNotification*)notification{
//    NSDictionary *userInfo = [notification userInfo];
//    CGRect rect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    DLog(@"%f",rect.size.height);
//    CGRect windowRect = [AppDelegate getScreenSize:YES isHorizontal:NO];
//    CGFloat width = windowRect.size.width;
//    CGFloat height = windowRect.size.height;
//    
//    [UIView transitionWithView:self.view duration:0.2 options:UIViewAnimationCurveEaseInOut
//                    animations:^{
//                        CGFloat offset1 = self.mainView2.frame.size.height-(self.passwrodField2.frame.origin.y+self.passwrodField2.frame.size.height);
//                        CGFloat finalOffset;
//                        if(offset1-rect.size.height<0){
//                            finalOffset = rect.size.height-offset1+20;
//                        }else if(offset1-rect.size.height>=0){
//                            if(offset1-rect.size.height>=20){
//                                finalOffset = 0;
//                            }else{
//                                finalOffset = 20-(offset1-rect.size.height);
//                            }
//                            
//                        }
//                        self.view.transform = CGAffineTransformMakeTranslation(0, -finalOffset);
//                    }
//                    completion:^(BOOL finished) {
//                        
//                    }
//     ];
//    [UIView animateWithDuration:0.3f animations:^{
//        self.view.frame=CGRectMake(0, self.view.frame.origin.y-50, VIEWWIDTH,  VIEWHEIGHT);
//    }];
}

#pragma mark 键盘将要收起时，调用
-(void)onKeyBoardWillHide:(NSNotification*)notification{
//    DLog(@"onKeyBoardWillHide");
//    
//    NSDictionary *userInfo = [notification userInfo];
//    CGRect rect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    DLog(@"%f",rect.size.height);
//    
//    [UIView transitionWithView:self.view duration:0.2 options:UIViewAnimationCurveEaseInOut
//                    animations:^{
//                        self.view.transform = CGAffineTransformMakeTranslation(0, 0);
//                    }
//                    completion:^(BOOL finished) {
//                        
//                    }
//     ];
//    [UIView animateWithDuration:0.3f animations:^{
//        self.view.frame=CGRectMake(0, 0, VIEWWIDTH,  VIEWHEIGHT);
//    }];
}

-(void)onKeyBoardDown:(id)sender{
    [sender resignFirstResponder];
}

-(void)onProgressAlertExit{
    sleep(1.5);
    [self.view makeToast:NSLocalizedString(@"user_unexist", nil)];
}

-(void)lightButton:(UIView*)view{
    view.backgroundColor = XBlue;
}

-(void)normalButton:(UIView*)view{
    view.backgroundColor = XWhite;
}

-(void)onForgetPassword:(id)sender{
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://cloudlinks.cn/pw/"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.cloudlinks.cn/pw/"]];
    
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://6sci.com.cn/pw/"]];
}

#pragma mark - 调用时，进入国家选择界面
-(void)onChooseCountryPress:(UIButton*)button{
    [self normalButton:button];
    ChooseCountryController *chooseCountryController = [[ChooseCountryController alloc] init];
    chooseCountryController.loginController = self;
    [self presentViewController:chooseCountryController animated:YES completion:nil];
    [chooseCountryController release];
}

#pragma mark - 选择登录界面：邮箱登录和手机号登录
-(void)onLoginTypeChange:(UISegmentedControl*)control{
    
//    self.loginType = control.selectedSegmentIndex;
    
//    if(self.loginType==0){
//        [self.mainView1 setHidden:NO];
//        [self.mainView2 setHidden:YES];
//    }else{
//        [self.mainView1 setHidden:YES];
//        [self.mainView2 setHidden:NO];
//    }
}

#pragma mark - 进入手机号码注册界面
-(void)onPhoneRegisterPress{
    BindPhoneController *bindPhoneController = [[BindPhoneController alloc] init];
    bindPhoneController.isRegister = YES;
    bindPhoneController.loginController = self;
    [self.navigationController pushViewController:bindPhoneController animated:YES];
    [bindPhoneController release];
}

#pragma mark - 进入邮箱注册界面
-(void)onEmailRegisterPress{
    EmailRegisterController *emailRegisterController = [[EmailRegisterController alloc] init];
    emailRegisterController.loginController = self;
    [self.navigationController pushViewController:emailRegisterController animated:YES];
    [emailRegisterController release];
}

#pragma mark - 进入匿名登录界面
-(void)onAnonymousLoginPress:(id)sender{
    [UDManager setIsLogin:YES];
    LoginResult *loginResult = [[LoginResult alloc] init];
    loginResult.contactId = @"0517400";
    loginResult.rCode1 = @"0";
    loginResult.rCode2 = @"0";
    loginResult.sessionId = @"0";

    [UDManager setLoginInfo:loginResult];
    [loginResult release];
    
    MainController *mainController = [[MainController alloc] init];
    self.view.window.rootViewController = mainController;
    [[AppDelegate sharedDefault] setMainController:mainController];
    [mainController release];
}
-(BOOL)isphonenumber:(NSString *)mobileNum  {  //判读是否为手机号
    
    NSLog(@"%@",mobileNum);
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobileNum];
}
#pragma mark - 点击登录按钮
-(void)onLoginPress:(id)sender{
    

    NSLog(@"沙盒===%@", NSHomeDirectory());
    
    if (![self isphonenumber:self.usernameField2.text]) { //如果不是手机号 登录类型为邮箱 或者id
        self.loginType=0; // 不是手机号登录
    }
    
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    
    if (IOS8_OR_LATER) {
        if (![currentLanguage containsString:@"zh-Hans"]) { // 不是简体中文 不能手机登录
            if ([self isphonenumber:self.usernameField2.text]) { // 非简体下 手机不能登录
                [self.view makeToast:NSLocalizedString(@"unInputUsername", nil)];
                return;
            }
        }
    }else
    {
        if (![currentLanguage isEqualToString:@"zh-Hans"]) { // 不是简体中文 不能手机登录
            if ([self isphonenumber:self.usernameField2.text]) { // 非简体下 手机不能登录
                [self.view makeToast:NSLocalizedString(@"unInputUsername", nil)];
                return;
            }
        }
    }
    

    if(self.loginType==0){
//    NSString *username = self.usernameField1.text;
//    NSString *password = self.passwrodField1.text;
        
        NSString *username = self.usernameField2.text;
        NSString *password = self.passwrodField2.text;

    /*
     *根据用户输入的信息完整程度，给出相应的提示
     */
    if(!username||!username.length>0){
        
        [self.view makeToast:NSLocalizedString(@"input_username", nil)];
        return;
    }
    
    if([username isValidateNumber]){
        if([username characterAtIndex:0]!='0'){
            self.progressAlert.dimBackground = YES;
            [self.progressAlert showWhileExecuting:@selector(onProgressAlertExit) onTarget:self withObject:Nil animated:YES];
                        return;
        }
    }
    if(!password||!password.length>0){
        
        [self.view makeToast:NSLocalizedString(@"unInputPassword", nil)];
        return;
    }
    
    
		
	self.progressAlert.dimBackground = YES;
    
    [self.progressAlert show:YES];
    
    [[NetManager sharedManager] loginWithUserName:username password:password token:[AppDelegate sharedDefault].token callBack:^(id result){
        
        LoginResult *loginResult = (LoginResult*)result;
        [self.progressAlert hide:YES];
        
        
        
        switch(loginResult.error_code){//002
            case NET_RET_LOGIN_SUCCESS:
            {
                if (CURRENT_VERSION<9.3) {
                    if(CURRENT_VERSION>=8.0){//8.0以后使用这种方法来注册推送通知
                        
                        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
                        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
                        [[UIApplication sharedApplication] registerForRemoteNotifications];
                        
                    }else{
                        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
                    }
                }

                NSLog(@"contactId:%@",loginResult.contactId);
                NSLog(@"Email:%@",loginResult.email);
                NSLog(@"Phone:%@",loginResult.phone);
                NSLog(@"CountryCode:%@",loginResult.countryCode);
                NSLog(@"sessionId:%@",loginResult.sessionId);// 这个值 经常为空
                //loginResult.sessionId = @"1619090650";
                [UDManager setIsLogin:YES];
                [UDManager setLoginInfo:loginResult];
                [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"USER_NAME"];
                [[NSUserDefaults standardUserDefaults] setInteger:self.loginType forKey:@"LOGIN_TYPE"];
                MainController *mainController = [[MainController alloc] init];
                self.view.window.rootViewController = mainController;
                [[AppDelegate sharedDefault] setMainController:mainController];
                [mainController release];
                
                [[NetManager sharedManager] getAccountInfo:loginResult.contactId sessionId:loginResult.sessionId callBack:^(id JSON){
                    AccountResult *accountResult = (AccountResult*)JSON;
                    loginResult.email = accountResult.email;
                    loginResult.phone = accountResult.phone;
                    loginResult.countryCode = accountResult.countryCode;
                    [UDManager setLoginInfo:loginResult];
                }];
                
                [[NetManager sharedManager] checkNewMessage:loginResult.contactId sessionId:loginResult.sessionId callBack:^(id JSON){
                    CheckNewMessageResult *checkNewMessageResult = (CheckNewMessageResult*)JSON;
                    if(checkNewMessageResult.error_code==NET_RET_CHECK_NEW_MESSAGE_SUCCESS){
                        if(checkNewMessageResult.isNewContactMessage){
                            DLog(@"have new");
                            [[NetManager sharedManager] getContactMessageWithUsername:loginResult.contactId sessionId:loginResult.sessionId callBack:^(id JSON){
                                NSArray *datas = [NSArray arrayWithArray:JSON];
                                if([datas count]<=0){
                                    return;
                                }
                                BOOL haveContact = NO;
                                for(GetContactMessageResult *result in datas){
                                    DLog(@"%@",result.message);
                                    ContactDAO *contactDAO = [[ContactDAO alloc] init];
                                    Contact *contact = [contactDAO isContact:result.contactId];
                                    if(nil!=contact){
                                        haveContact = YES;
                                    }
                                    [contactDAO release];
                                    
                                    MessageDAO *messageDAO = [[MessageDAO alloc] init];
                                    Message *message = [[Message alloc] init];
                                    
                                    message.fromId = result.contactId;
                                    message.toId = loginResult.contactId;
                                    message.message = [NSString stringWithFormat:@"%@",result.message];
                                    message.state = MESSAGE_STATE_NO_READ;
                                    message.time = [NSString stringWithFormat:@"%@",result.time];
                                    message.flag = result.flag;
                                    [messageDAO insert:message];
                                    [message release];
                                    [messageDAO release];
                                    int lastCount = [[FListManager sharedFList] getMessageCount:result.contactId];
                                    [[FListManager sharedFList] setMessageCountWithId:result.contactId count:lastCount+1];
                                    
                                }
                                if(haveContact){
                                    [Utils playMusicWithName:@"message" type:@"mp3"];
                                }
                                
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMessage"
                                                                                    object:self
                                                                                  userInfo:nil];
                            }];
                        }
                    }else{
                        
                    }
                }];

            }
                break;
            case NET_RET_LOGIN_USER_UNEXIST:
            {
                [self.view makeToast:NSLocalizedString(@"user_unexist", nil)];
            }
                break;
            case NET_RET_LOGIN_PWD_ERROR:
            {
                [self.view makeToast:NSLocalizedString(@"password_error", nil)];
            }
                break;
            case NET_RET_LOGIN_EMAIL_FORMAT_ERROR:
            {
                [self.view makeToast:NSLocalizedString(@"user_unexist", nil)];
            }
                break;
                
            default:
            {
                
                [self.view makeToast:[NSString stringWithFormat:@"%@:%i",NSLocalizedString(@"login_failure", nil),loginResult.error_code]];
            }
                break;
        }
        
    }];
    
    }else{
        NSString *phone = self.usernameField2.text;
        NSString *password = self.passwrodField2.text;
        
        if(!phone||!phone.length>0){
            
            [self.view makeToast:NSLocalizedString(@"input_phone", nil)];
            return;
        }
        
        
        if(!password||!password.length>0){
            
            [self.view makeToast:NSLocalizedString(@"unInputPassword", nil)];
            return;
        }
        
        
		
        self.progressAlert.dimBackground = YES;
        [self.progressAlert show:YES];
        NSString *username = [NSString stringWithFormat:@"+%@-%@",self.countryCode,phone];
        DLog(@"%@",username);///////////////
//        [[NetManager sharedManager] loginWithUserName:username password:password token:[AppDelegate sharedDefault].token callBack:^(id result){
//            
//            LoginResult *loginResult = (LoginResult*)result;
//            [self.progressAlert hide:YES];
//            
//            
//            switch(loginResult.error_code){
//                case NET_RET_LOGIN_SUCCESS:
//                {
//                    
//                    DLog(@"contactId:%@",loginResult.contactId);
//                    DLog(@"Email:%@",loginResult.email);
//                    DLog(@"Phone:%@",loginResult.phone);
//                    DLog(@"CountryCode:%@",loginResult.countryCode);
//                    [UDManager setIsLogin:YES];
//                    [UDManager setLoginInfo:loginResult];
//                    [[NSUserDefaults standardUserDefaults] setObject:phone forKey:@"PHONE_NUMBER"];
//                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"USER_NAME"];
//                    [[NSUserDefaults standardUserDefaults] setInteger:self.loginType forKey:@"LOGIN_TYPE"];
//                    MainController *mainController = [[MainController alloc] init];
//                    self.view.window.rootViewController = mainController;
//                    [[AppDelegate sharedDefault] setMainController:mainController];
//                    [mainController release];
//                    
//                    
//                    
//                }
//                    break;
//                case NET_RET_LOGIN_USER_UNEXIST:
//                {
//                    [self.view makeToast:NSLocalizedString(@"user_unexist", nil)];
//                }
//                    break;
//                case NET_RET_LOGIN_PWD_ERROR:
//                {
//                    [self.view makeToast:NSLocalizedString(@"password_error", nil)];
//                }
//                    break;
//                case NET_RET_UNKNOWN_ERROR:
//                {
//                    [self.view makeToast:NSLocalizedString(@"login_failure", nil)];
//                }
//                    break;
//                    
//                default:
//                {
//                    [self.view makeToast:NSLocalizedString(@"login_failure", nil)];
//                }
//                    break;
//            }
//            
//        }];
    }
}

-(void)onRegisterPress{
    
    NewRegisterController *newRegisterController = [[NewRegisterController alloc]init];
    newRegisterController.loginController = self;
    [self.navigationController pushViewController:newRegisterController animated:YES];
    [newRegisterController release];
    
}

-(BOOL)shouldAutorotate{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interface {
    return (interface == UIInterfaceOrientationPortrait );//UIInterfaceOrientationPortrait UIInterfaceOrientationLandscapeLeft
}

#ifdef IOS6

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;//UIInterfaceOrientationPortrait;UIInterfaceOrientationLandscapeLeft
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;//UIInterfaceOrientationMaskPortrait;UIInterfaceOrientationMaskLandscape
}
#endif

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;//UIInterfaceOrientationMaskPortrait;UIInterfaceOrientationMaskLandscape
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;//UIInterfaceOrientationPortrait;UIInterfaceOrientationLandscapeLeft
}
@end
