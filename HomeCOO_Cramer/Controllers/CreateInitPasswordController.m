//
//  CreateInitPasswordController.m
//  2cu
//
//  Created by guojunyi on 14-5-26.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import "CreateInitPasswordController.h"
#import "ContactDAO.h"
#import "Contact.h"
#import "AppDelegate.h"
#import "MainController.h"
#import "Constants.h"
#import "P2PClient.h"
#import "FListManager.h"
#import "Toast+UIView.h"
#import "TopBar.h"
#import "MBProgressHUD.h"
@interface CreateInitPasswordController ()

@end

@implementation CreateInitPasswordController
-(void)dealloc{
    [self.address release];
    [self.contactId release];
    [self.contactNameField release];
    [self.contactPasswordField release];
    [self.progressAlert release];
    [self.contentView release];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
    MainController *mainController = [AppDelegate sharedDefault].mainController;
    [mainController setBottomBarHidden:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRemoteMessage:) name:RECEIVE_REMOTE_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ack_receiveRemoteMessage:) name:ACK_RECEIVE_REMOTE_MESSAGE object:nil];
   
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RECEIVE_REMOTE_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ACK_RECEIVE_REMOTE_MESSAGE object:nil];
}




- (void)receiveRemoteMessage:(NSNotification *)notification{
    NSDictionary *parameter = [notification userInfo];
    int key = [[parameter valueForKey:@"key"] intValue];
    switch(key){
       
        case RET_SET_INIT_PASSWORD:
        {
            int result = [[parameter valueForKey:@"result"] intValue];
            if(result==0){
                ContactDAO *contactDAO = [[ContactDAO alloc] init];
                Contact *contact = [contactDAO isContact:self.contactId];
                [contactDAO release];
                
                if(contact!=nil){
                    contact.contactName = self.contactNameField.text;
                    
                    [[FListManager sharedFList] update:contact];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.progressAlert hide:YES];
                        [self.view makeToast:NSLocalizedString(@"operator_success", nil)];
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            usleep(800000);
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self onBackPress];
                            });
                        });
                    });
                }else{
                    Contact *contact = [[Contact alloc] init];
                    contact.contactId = self.contactId;
                    contact.contactName = self.contactNameField.text;
                    
                    contact.contactPassword = self.contactPasswordField.text;
                    contact.contactType = CONTACT_TYPE_UNKNOWN;
                    [[FListManager sharedFList] insert:contact];
                    
                    
                    [[P2PClient sharedClient] getContactsStates:[NSArray arrayWithObject:contact.contactId]];
                    [[P2PClient sharedClient] getDefenceState:contact.contactId password:contact.contactPassword];
                    [contact release];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.progressAlert hide:YES];
                        [self.view makeToast:NSLocalizedString(@"operator_success", nil)];
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            usleep(800000);
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self onBackPress];
                            });
                        });
                    });
                    
                }
                
            }else if(result==43){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.progressAlert hide:YES];
                    [self.view makeToast:NSLocalizedString(@"device_already_exist_password", nil)];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.progressAlert hide:YES];
                    [self.view makeToast:NSLocalizedString(@"operator_failure", nil)];
                });
            }
        }
            break;
    }
    
}

- (void)ack_receiveRemoteMessage:(NSNotification *)notification{
    NSDictionary *parameter = [notification userInfo];
    int key   = [[parameter valueForKey:@"key"] intValue];
    int result   = [[parameter valueForKey:@"result"] intValue];
    switch(key){
        case ACK_RET_SET_INIT_PASSWORD:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(result==1){
                    [self.progressAlert hide:YES];
                    [self.view makeToast:NSLocalizedString(@"device_password_error", nil)];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        usleep(800000);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self onBackPress];
                        });
                    });
                }else if(result==2){
                    DLog(@"resend set init password");
                    if(self.address&&[self.address length]>0){
                        NSArray *array = [self.address componentsSeparatedByString:@"."];
                        
                        [[P2PClient sharedClient] setInitPasswordWithId:[array objectAtIndex:3] initPassword:self.lastSetPassword];
                    }else{
                        [[P2PClient sharedClient] setInitPasswordWithId:self.contactId initPassword:self.lastSetPassword];
                    }
                    
                }
                
                
            });
            
            
            
            
            
            DLog(@"ACK_RET_SET_INIT_PASSWORD:%i",result);
        }
            break;
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initComponent];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initComponent{
    CGRect rect = [AppDelegate getScreenSize:YES isHorizontal:NO];
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    TopBar *topBar = [[TopBar alloc] initWithFrame:CGRectMake(0, 0, width, NAVIGATION_BAR_HEIGHT)];
    [topBar setBackButtonHidden:NO];
    [topBar setRightButtonHidden:NO];
    [topBar setRightButtonText:NSLocalizedString(@"save", nil)];
    [topBar.backButton addTarget:self action:@selector(onBackPress) forControlEvents:UIControlEventTouchUpInside];
    [topBar.rightButton addTarget:self action:@selector(onSavePress) forControlEvents:UIControlEventTouchUpInside];
    [topBar setTitle:self.contactId];
    [self.view addSubview:topBar];
    [topBar release];
    
    [self.view setBackgroundColor:XBgColor];
    
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, width, height-NAVIGATION_BAR_HEIGHT)];
    self.contentView = contentView;
    
    UITextField *field1 = [[UITextField alloc] initWithFrame:CGRectMake(BAR_BUTTON_MARGIN_LEFT_AND_RIGHT, 20, width-BAR_BUTTON_MARGIN_LEFT_AND_RIGHT*2, TEXT_FIELD_HEIGHT)];
    
    if(CURRENT_VERSION>=7.0){
        field1.layer.borderWidth = 1;
        field1.layer.borderColor = [[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor];
        field1.layer.cornerRadius = 5.0;
    }
    field1.textAlignment = NSTextAlignmentLeft;
    field1.placeholder = NSLocalizedString(@"input_contact_name", nil);
    field1.borderStyle = UITextBorderStyleRoundedRect;
    field1.returnKeyType = UIReturnKeyDone;
    field1.autocapitalizationType = UITextAutocapitalizationTypeNone;
    field1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [field1 addTarget:self action:@selector(onKeyBoardDown:) forControlEvents:UIControlEventEditingDidEndOnExit];
    ContactDAO *contactDAO = [[ContactDAO alloc] init];
    Contact *contact = [contactDAO isContact:self.contactId];
    [contactDAO release];
    if(contact!=nil){
        field1.text = contact.contactName;
    }else{
        field1.text = [NSString stringWithFormat:@"Cam%@",self.contactId];
    }
    [contentView addSubview:field1];
    self.contactNameField = field1;
    [field1 release];
    
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.frame = CGRectMake(BAR_BUTTON_MARGIN_LEFT_AND_RIGHT, field1.frame.origin.y+20+TEXT_FIELD_HEIGHT, width-BAR_BUTTON_MARGIN_LEFT_AND_RIGHT*2, TEXT_FIELD_HEIGHT);
    promptLabel.backgroundColor = XBGAlpha;
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.font = XFontBold_16;
    promptLabel.textColor = [UIColor redColor];
    promptLabel.text = NSLocalizedString(@"create_init_password_prompt", nil);
    promptLabel.lineBreakMode = UILineBreakModeWordWrap;
    promptLabel.numberOfLines = 0;
    [contentView addSubview:promptLabel];
    [promptLabel release];
    
    
    UITextField *field2 = [[UITextField alloc] initWithFrame:CGRectMake(BAR_BUTTON_MARGIN_LEFT_AND_RIGHT, promptLabel.frame.origin.y+20+TEXT_FIELD_HEIGHT, width-BAR_BUTTON_MARGIN_LEFT_AND_RIGHT*2, TEXT_FIELD_HEIGHT)];
    
    if(CURRENT_VERSION>=7.0){
        field2.layer.borderWidth = 1;
        field2.layer.borderColor = [[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor];
        field2.layer.cornerRadius = 5.0;
    }
    field2.textAlignment = NSTextAlignmentLeft;
    field2.placeholder = NSLocalizedString(@"input_contact_password", nil);
    field2.borderStyle = UITextBorderStyleRoundedRect;
    field2.returnKeyType = UIReturnKeyDone;
    field2.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    field2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [field2 addTarget:self action:@selector(onKeyBoardDown:) forControlEvents:UIControlEventEditingDidEndOnExit];
    field2.secureTextEntry = YES;
    
    [contentView addSubview:field2];
    self.contactPasswordField = field2;
    
    
    
    UITextField *field3 = [[UITextField alloc] initWithFrame:CGRectMake(BAR_BUTTON_MARGIN_LEFT_AND_RIGHT, field2.frame.origin.y+20+TEXT_FIELD_HEIGHT, width-BAR_BUTTON_MARGIN_LEFT_AND_RIGHT*2, TEXT_FIELD_HEIGHT)];
    
    if(CURRENT_VERSION>=7.0){
        field3.layer.borderWidth = 1;
        field3.layer.borderColor = [[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor];
        field3.layer.cornerRadius = 5.0;
    }
    field3.textAlignment = NSTextAlignmentLeft;
    field3.placeholder = NSLocalizedString(@"confirm_input", nil);
    field3.borderStyle = UITextBorderStyleRoundedRect;
    field3.returnKeyType = UIReturnKeyDone;

    field3.keyboardType = UIKeyboardTypeNumbersAndPunctuation;

    field3.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [field3 addTarget:self action:@selector(onKeyBoardDown:) forControlEvents:UIControlEventEditingDidEndOnExit];
    field3.secureTextEntry = YES;
    
    [contentView addSubview:field3];
    self.confirmPasswordField = field3;
    [field3 release];
    
    [field2 release];
    self.progressAlert = [[[MBProgressHUD alloc] initWithView:contentView] autorelease];
    [contentView addSubview:self.progressAlert];
    
    
    [self.view addSubview:contentView];
    [contentView release];
    
}

-(void)onKeyBoardDown:(id)sender{
    [self.contactNameField resignFirstResponder];
    [self.contactPasswordField resignFirstResponder];
}

#pragma mark - 监听到键盘将要显示、收起通知时，调用
#pragma mark 键盘将要显示
-(void)onKeyBoardWillShow:(NSNotification*)notification{
    NSDictionary *userInfo = [notification userInfo];
    CGRect rect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    DLog(@"%f",rect.size.height);
    CGRect windowRect = [AppDelegate getScreenSize:YES isHorizontal:NO];
    CGFloat width = windowRect.size.width;
    CGFloat height = windowRect.size.height;
    
    [UIView transitionWithView:self.view duration:0.2 options:UIViewAnimationCurveEaseInOut
                    animations:^{
                        CGFloat offset1 = self.contentView.frame.size.height-(self.confirmPasswordField.frame.origin.y+self.confirmPasswordField.frame.size.height);
                        CGFloat finalOffset;
                        if(offset1-rect.size.height<0){
                            finalOffset = rect.size.height-offset1+20;
                        }else if(offset1-rect.size.height>=0){
                            if(offset1-rect.size.height>=20){
                                finalOffset = 0;
                            }else{
                                finalOffset = 20-(offset1-rect.size.height);
                            }
                            
                        }
                        self.view.transform = CGAffineTransformMakeTranslation(0, -finalOffset);
                    }
                    completion:^(BOOL finished) {
                        
                    }
     ];
}

#pragma mark 键盘将要收起
-(void)onKeyBoardWillHide:(NSNotification*)notification{
    DLog(@"onKeyBoardWillHide");
    
    NSDictionary *userInfo = [notification userInfo];
    CGRect rect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    DLog(@"%f",rect.size.height);
    
    [UIView transitionWithView:self.view duration:0.2 options:UIViewAnimationCurveEaseInOut
                    animations:^{
                        self.view.transform = CGAffineTransformMakeTranslation(0, 0);
                    }
                    completion:^(BOOL finished) {
                        
                    }
     ];
}

-(void)onBackPress{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RECEIVE_REMOTE_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ACK_RECEIVE_REMOTE_MESSAGE object:nil];
    if(self.isPopRoot){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)onSavePress{
    NSString *newPassword = self.contactPasswordField.text;
    NSString *confirmPassword = self.confirmPasswordField.text;
    if (self.contact) {
        [self updateContact];
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0-9]*$"];
    
    if(!self.contactNameField||!self.contactNameField.text.length>0){
        [self.view makeToast:NSLocalizedString(@"input_contact_name", nil)];
        return;
    }
    
    
    if(!newPassword||!newPassword.length>0){
        [self.view makeToast:NSLocalizedString(@"input_contact_password", nil)];
        return;
    }
    
    
    if([predicate evaluateWithObject:newPassword]==NO){
        [self.view makeToast:NSLocalizedString(@"password_number_format_error", nil)];
        return;
    }
    
    if([newPassword characterAtIndex:0]=='0'){
        [self.view makeToast:NSLocalizedString(@"password_zero_format_error", nil)];
        return;
    }
    
    if(newPassword.length>10){
        [self.view makeToast:NSLocalizedString(@"device_password_too_long", nil)];
        return;
    }
    
    
    if(!confirmPassword||!confirmPassword.length>0){
        [self.view makeToast:NSLocalizedString(@"confirm_input", nil)];
        return;
    }
    
    if(![newPassword isEqualToString:confirmPassword]){
        [self.view makeToast:NSLocalizedString(@"two_passwords_not_match", nil)];
        return;
    }
    
    self.lastSetPassword = self.contactPasswordField.text;
    
    self.progressAlert.dimBackground = YES;
    [self.progressAlert show:YES];
    
    [self onKeyBoardDown:nil];
    
    if(self.address&&[self.address length]>0){
        NSArray *array = [self.address componentsSeparatedByString:@"."];
        
        [[P2PClient sharedClient] setInitPasswordWithId:[array objectAtIndex:3] initPassword:self.lastSetPassword];
    }else{
        [[P2PClient sharedClient] setInitPasswordWithId:self.contactId initPassword:self.lastSetPassword];
    }
    
    
}

- (void)updateContact
{
    self.contact.contactPassword = self.contactPasswordField.text;
    [[FListManager sharedFList] update:self.contact];
}

-(BOOL)shouldAutorotate{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interface {
    return (interface == UIInterfaceOrientationPortrait );
}

#ifdef IOS6

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
#endif

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}
@end
