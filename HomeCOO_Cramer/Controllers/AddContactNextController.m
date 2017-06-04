//
//  AddContactNextController.m
//  2cu
//
//  Created by guojunyi on 14-4-12.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import "AddContactNextController.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "Contact.h"
#import "FListManager.h"
#import "MainController.h"
#import "Toast+UIView.h"
#import "PrefixHeader.pch"
#define NUMBERS   @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

@interface AddContactNextController () <UITextFieldDelegate>

@end


@implementation AddContactNextController
-(void)dealloc{
    [self.contactId release];
    [self.contactNameField release];
    [self.contactPasswordField release];
    [self.modifyContact release];
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

-(void)viewWillAppear:(BOOL)animated{
    MainController *mainController = [AppDelegate sharedDefault].mainController;
    [mainController setBottomBarHidden:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ack_receiveRemoteMessage:) name:ACK_RECEIVE_REMOTE_MESSAGE object:nil];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ACK_RECEIVE_REMOTE_MESSAGE object:nil];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField==self.contactPasswordField) {

    
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS]invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
    BOOL canChange = [string isEqualToString:filtered];
        
        if(!canChange){
            
             [[[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"password_number_format_error", nil) delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
            
            return NO;
            
        }
        
        
    
    return YES;
    }
    
    if (textField == self.contactNameField) {
        
        
        // Check for total length
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if (proposedNewLength > 12) return NO;//限制长度
        NSLog(@"NO"); return YES;
    }
    
    
    return YES ;
}






- (void)ack_receiveRemoteMessage:(NSNotification *)notification{
    NSDictionary *parameter = [notification userInfo];
    int key   = [[parameter valueForKey:@"key"] intValue];
    int result   = [[parameter valueForKey:@"result"] intValue];
//    NSString *contactId = [parameter valueForKey:@"contactId"];
    switch(key){
        case ACK_RET_SET_DEVICE_PASSWORD:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(result==1){
//                    [self.progressAlert hide:YES];
                    [self.view makeToast:NSLocalizedString(@"original_password_error", nil)];
                    
                }else if(result==2){
                    DLog(@"resend set device password");
//                    [[P2PClient sharedClient] setDevicePasswordWithId:self.contact.contactId password:self.lastSetOriginPassowrd newPassword:self.lastSetNewPassowrd];
                }
                
                
            });
    
            DLog(@"ACK_RET_SET_DEVICE_PASSWORD:%i",result);
        }
            break;
            
        case ACK_RET_GET_NPC_SETTINGS:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(result==1){
//                    [self.view makeToast:NSLocalizedString(@"device_password_error", nil)];
                    NSLog(@"密码错误");
                    ALERTSHOW(NSLocalizedString(@"提示", nil),NSLocalizedString(@"device_password_error",nil));
                    
                }else if (result == 2)
                {
//                    self.topBar.rightButton.enabled = YES;
                    [self.view makeToast:NSLocalizedString(@"net_exception", nil)];
                }
                else if((result==0)||(result==4)){
                    
                if (self.isModifyContact) {   //修改
                    self.modifyContact.contactName = self.contactNameField.text;
                    if([self.contactId characterAtIndex:0]!='0'){
                        NSString *password = self.contactPasswordField.text;
                        if([password characterAtIndex:0]=='0'){
                            [self.view makeToast:NSLocalizedString(@"password_zero_format_error", nil)];
                            return;
                        }
                        
                        if(password.length>10){
                            [self.view makeToast:NSLocalizedString(@"device_password_too_long", nil)];
                            return;
                        }
                        self.modifyContact.contactPassword = password;
                    }
                    [[FListManager sharedFList] update:self.modifyContact];
                    [self.navigationController popToRootViewControllerAnimated:YES];

                }else{    //添加
                    
                Contact *contact = [[Contact alloc] init];
                contact.contactId = self.contactId;
                contact.contactName = self.contactNameField.text;
                contact.contactPassword=self.contactPasswordField.text;
                    
                [[FListManager sharedFList] insert:contact];
                    
                    
                    [[P2PClient sharedClient] setInitPasswordWithId:self.contactId initPassword:self.contactPasswordField.text];
                    // 添加成功
                    NSMutableDictionary *mutdic = [NSMutableDictionary dictionary];
                    [mutdic setObject:contact forKey:@"contactName"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"DEVICE_BIND_SUCCESS" object:nil userInfo:mutdic];
                    
                [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                }else {
                    [self.view makeToast:NSLocalizedString(@"add_error", nil)];
                }
            });
            DLog(@"ACK_RET_GET_NPC_SETTINGS:%i",result);
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
    
    self.topBar = [[TopBar alloc] initWithFrame:CGRectMake(0, 0, width, NAVIGATION_BAR_HEIGHT)];
    [self.topBar setBackButtonHidden:NO];
    [self.topBar setRightButtonHidden:NO];
    [self.topBar setRightButtonText:NSLocalizedString(@"save", nil)];
    [self.topBar.backButton addTarget:self action:@selector(onBackPress) forControlEvents:UIControlEventTouchUpInside];
    [self.topBar.rightButton addTarget:self action:@selector(onSavePress) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.modifyContact) {
         [self.topBar setTitle:self.modifyContact.contactId];
    }else
    {
         [self.topBar setTitle:self.contactId];
    }
    
   
    [self.view addSubview:self.topBar];
    [self.topBar release];
    
    [self.view setBackgroundColor:XBgColor];
    
    Contact *contact = [[Contact alloc] init];
    contact.contactId = self.contactId;
    contact.contactName = self.contactNameField.text;

    
    P2PHeadView*headview=[[P2PHeadView alloc]init];
    
    if(self.isModifyContact){  //修改的
    
    headview=[[P2PHeadView alloc]initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT+10, VIEWWIDTH, BAR_BUTTON_HEIGHT*2+10) with:self.modifyContact];
    }else{   //添加的
    headview=[[P2PHeadView alloc]initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT+10, VIEWWIDTH, BAR_BUTTON_HEIGHT*2+10) with:contact];
    }
    [headview setContentMode:UIViewContentModeScaleAspectFill];
    headview.rigthbtn.hidden = YES;
    [self.view addSubview:headview];
    
    
//    UITextField *field1 = [[UITextField alloc] initWithFrame:CGRectMake(BAR_BUTTON_MARGIN_LEFT_AND_RIGHT, NAVIGATION_BAR_HEIGHT+20, width-BAR_BUTTON_MARGIN_LEFT_AND_RIGHT*2, TEXT_FIELD_HEIGHT)];
    
    
    UILabel *contact_Name = [[UILabel alloc] initWithFrame:CGRectMake(BAR_BUTTON_MARGIN_LEFT_AND_RIGHT, BottomForView(headview) +10, 200, 30)];
    contact_Name.text = NSLocalizedString(@"设备昵称", nil);
    contact_Name.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:contact_Name];
    
    UITextField *field1 = [[UITextField alloc] initWithFrame:CGRectMake(BAR_BUTTON_MARGIN_LEFT_AND_RIGHT, BottomForView(contact_Name) + 5, width-BAR_BUTTON_MARGIN_LEFT_AND_RIGHT*2, TEXT_FIELD_HEIGHT)];
    
    if(CURRENT_VERSION>=7.0){
        field1.layer.borderWidth = 1;
        field1.layer.borderColor = [[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor];
//        field1.layer.cornerRadius = 5.0;
    }
    field1.textAlignment = NSTextAlignmentLeft;
    field1.placeholder = NSLocalizedString(@"input_contact_name", nil);
    field1.borderStyle = UITextBorderStyleRoundedRect;
    field1.returnKeyType = UIReturnKeyDone;
    field1.delegate = self;
    field1.autocapitalizationType = UITextAutocapitalizationTypeNone;
    field1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [field1 addTarget:self action:@selector(onKeyBoardDown:) forControlEvents:UIControlEventEditingDidEndOnExit];
    if(self.isModifyContact){
        field1.text = self.modifyContact.contactName;
    }else{
        field1.text = [NSString stringWithFormat:@"Cam%@",self.contactId];
    }
    [self.view addSubview:field1];
    self.contactNameField = field1;
    [field1 release];
    
    if([self.contactId characterAtIndex:0]!='0'){
//    UITextField *field2 = [[UITextField alloc] initWithFrame:CGRectMake(BAR_BUTTON_MARGIN_LEFT_AND_RIGHT, NAVIGATION_BAR_HEIGHT+20*2+TEXT_FIELD_HEIGHT, width-BAR_BUTTON_MARGIN_LEFT_AND_RIGHT*2, TEXT_FIELD_HEIGHT)];
        
        UILabel *contact_ps = [[UILabel alloc] initWithFrame:CGRectMake(BAR_BUTTON_MARGIN_LEFT_AND_RIGHT, BottomForView(field1) +5, 200, 30)];
        contact_ps.text = NSLocalizedString(@"设备密码", nil);
        contact_ps.font = [UIFont systemFontOfSize:15];
        [self.view addSubview:contact_ps];
        
        
        UITextField *field2 = [[UITextField alloc] initWithFrame:CGRectMake(BAR_BUTTON_MARGIN_LEFT_AND_RIGHT, BottomForView(contact_ps)+5, width-BAR_BUTTON_MARGIN_LEFT_AND_RIGHT*2, TEXT_FIELD_HEIGHT)];
    
    if(CURRENT_VERSION>=7.0){
        field2.layer.borderWidth = 1;
        field2.layer.borderColor = [[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor];
//        field2.layer.cornerRadius = 5.0;
    }
    field2.textAlignment = NSTextAlignmentLeft;
    field2.placeholder = NSLocalizedString(@"input_contact_password", nil);
    field2.borderStyle = UITextBorderStyleRoundedRect;
    field2.returnKeyType = UIReturnKeyDone;
    field2.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    field2.delegate=self;
    field2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    [field2 addTarget:self action:@selector(onKeyBoardDown:) forControlEvents:UIControlEventEditingDidEndOnExit];
    field2.secureTextEntry = YES;
        if(self.isModifyContact){
            field2.text = self.modifyContact.contactPassword;
        }
    [self.view addSubview:field2];
    self.contactPasswordField = field2;
    [field2 release];
    }
    
}

-(void)onKeyBoardDown:(id)sender{
    [sender resignFirstResponder];
}

-(void)onBackPress{
    if(self.isPopRoot){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)onSavePress{
    if(!self.contactNameField||!self.contactNameField.text.length>0){
        [self.view makeToast:NSLocalizedString(@"input_contact_name", nil)];
        return;
    }
    
    if([self.contactId characterAtIndex:0]!='0'){
        if(!self.contactPasswordField||!self.contactPasswordField.text.length>0){
            [self.view makeToast:NSLocalizedString(@"input_contact_password", nil)];
            return;
        }
    }
    
    if(self.isModifyContact){
//        self.modifyContact.contactName = self.contactNameField.text;
        if([self.contactId characterAtIndex:0]!='0'){
            NSString *password = self.contactPasswordField.text;
            if([password characterAtIndex:0]=='0'){
                [self.view makeToast:NSLocalizedString(@"password_zero_format_error", nil)];
                return;
            }
            
            if(password.length>10){
                [self.view makeToast:NSLocalizedString(@"device_password_too_long", nil)];
                return;
            }
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0-9]*$"];
            if([predicate evaluateWithObject:password]==NO){
                [self.view makeToast:NSLocalizedString(@"password_number_format_error", nil)];
                return;
            }
            
            [[P2PClient sharedClient] getNpcSettingsWithId:self.modifyContact.contactId password:password];
            
        }
//            self.modifyContact.contactPassword = password;
//        }
        self.modifyContact.contactName = self.contactNameField.text;
        [[FListManager sharedFList] update:self.modifyContact];

        
    }else{ // 添加成功
        
        Contact *contact = [[Contact alloc] init];
        contact.contactId = self.contactId;
        contact.contactName = self.contactNameField.text;
        
        if([self.contactId characterAtIndex:0]!='0'){
            
            NSString *password = self.contactPasswordField.text;
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0-9]*$"];
            if([predicate evaluateWithObject:password]==NO){
                [self.view makeToast:NSLocalizedString(@"password_number_format_error", nil)];
                return;
            }
            
            if([password characterAtIndex:0]=='0'){
                [self.view makeToast:NSLocalizedString(@"password_zero_format_error", nil)];
                return;
            }
            
            if(password.length>10){
                [self.view makeToast:NSLocalizedString(@"device_password_too_long", nil)];
                return;
            }
            
            contact.contactPassword = password;
            contact.contactType = CONTACT_TYPE_UNKNOWN;
        }else{
            contact.contactType = CONTACT_TYPE_PHONE;
        }

         [[P2PClient sharedClient] getNpcSettingsWithId:contact.contactId password:contact.contactPassword];
        

    }
}

-(BOOL)shouldAutorotate{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interface {
    return (interface == UIInterfaceOrientationPortrait );
}


#pragma mark - TextField Delegate 




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
