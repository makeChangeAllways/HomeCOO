//
//  AddContactNextController.h
//  2cu
//
//  Created by guojunyi on 14-4-12.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopBar.h"
@class  Contact;

@interface AddContactNextController : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) UITextField *contactNameField;
@property (strong, nonatomic) UITextField *contactPasswordField;


@property (retain, nonatomic) NSString *contactId;

@property(strong, nonatomic) Contact *modifyContact;
@property (nonatomic) BOOL isModifyContact;
@property (nonatomic) BOOL isPopRoot;

@property (nonatomic) BOOL isInFromLocalDeviceList;
@property (nonatomic) BOOL isInFromManuallAdd;
@property (nonatomic) BOOL isInFromQRCodeNextController;

@property (nonatomic,assign) int inType;//多出的
@property(nonatomic,strong)TopBar *topBar;
@property(strong, nonatomic) UIView *pwdStrengthView;//password strength

//@property (nonatomic, assign) id<P2PClientDelegate> delegate;
@end
