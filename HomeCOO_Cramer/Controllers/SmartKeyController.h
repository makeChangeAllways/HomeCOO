//
//  SmartKeyController.h
//  2cu
//
//  Created by guojunyi on 14-9-5.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDAsyncUdpSocket.h"
#define ALERT_TAG_SET_FAILED 0
#define ALERT_TAG_SET_SUCCESS 1
@interface SmartKeyController : UIViewController<UIAlertViewDelegate>
@property (nonatomic,strong) UITextField *field1;
@property (nonatomic,strong) UITextField *field2;
@property (nonatomic,strong) UITextField *field3;
@property (nonatomic) BOOL isCheckingRoute;
@property (nonatomic) BOOL isSendingCmd;
@property (nonatomic) BOOL isWaiting;
@property (nonatomic) BOOL isSmartKeyOK;
@property (nonatomic,strong) UIView *smartKeyPromptView;
@property (nonatomic,strong) UIImageView *insertContent;
@property (nonatomic,strong) UIView *setWifiContent;
@property (nonatomic,strong) UIImageView *waitingContent;

@property (assign) BOOL isRun;
@property (assign) BOOL isPrepared;
@property (strong, nonatomic) GCDAsyncUdpSocket *socket;
@property (nonatomic) BOOL isShowSuccessAlert;
@property (nonatomic) BOOL isFinish;

@end
