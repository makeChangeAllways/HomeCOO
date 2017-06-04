//
//  P2PMonitorController.h
//  2cu
//
//  Created by guojunyi on 14-3-26.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "P2PClient.h"
#import <AVFoundation/AVFoundation.h>
#import "TouchButton.h"
#import "OpenGLView.h"
@class Contact;
@interface P2PMonitorController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate,UIGestureRecognizerDelegate,TouchButtonDelegate,OpenGLViewDelegate>
@property (nonatomic, strong) OpenGLView *remoteView;
@property (nonatomic) BOOL isReject;
@property (nonatomic) BOOL isFullScreen;
@property (nonatomic) BOOL isShowControllerBar;
@property (nonatomic) BOOL isVideoModeHD;

@property (strong, nonatomic) UIView *controllerBar;
@property (strong, nonatomic) UIView *pressView;

@property (strong, nonatomic) UIView *controllerRight;

@property (strong, nonatomic) UILabel * numberViewer;
@property (nonatomic) int number;

@property(nonatomic,strong)Contact *contact;


@end
