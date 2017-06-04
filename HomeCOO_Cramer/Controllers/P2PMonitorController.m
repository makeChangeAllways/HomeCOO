///
//  P2PMonitorController.m
//  2cu
//
//  Created by guojunyi on 14-3-26.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import "P2PMonitorController.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "P2PClient.h"
#import "Toast+UIView.h"
#import "AppDelegate.h"
#import "PAIOUnit.h"
#import "UDManager.h"
#import "LoginResult.h"
#import "Utils.h"
#import "TouchButton.h"
#import "FListManager.h"
#import "PrefixHeader.pch"
@interface P2PMonitorController ()

@property(nonatomic,strong)Contact *mycontact;

@end

@implementation P2PMonitorController



-(void)dealloc{
    [self.remoteView release];
    [self.controllerBar release];
    [self.pressView release];
    [self.controllerRight release];
    [self.numberViewer release];
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

-(void)onClick{
    [self dismissViewControllerAnimated:YES completion:^{
    
    }];
    [[P2PClient sharedClient] p2pHungUp];
}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePlayingCommand:) name:RECEIVE_PLAYING_CMD object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [NSThread detachNewThreadSelector:@selector(renderView) toTarget:self withObject:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    self.isReject = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.remoteView setCaptureFinishScreen:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RECEIVE_PLAYING_CMD object:nil];
}

- (void)receivePlayingCommand:(NSNotification *)notification{
    NSDictionary *parameter = [notification userInfo];
    int value  = [[parameter valueForKey:@"value"] intValue];
    
    P2PClient*aa=[[P2PClient alloc]init];
    aa=[notification object];
    
     NSMutableArray *contantarry = [[[FListManager sharedFList] getContacts] mutableCopy];
    
    NSLog(@"contantarry=%@",contantarry);
    
    
    /*
    self.mycontact=[[Contact alloc]init];
    
    
    for (Contact *contact in contantarry) {
        if ([aa.callId isEqualToString:contact.contactId]) {
            self.mycontact=contact;
        }
    }
     
     */
     
    
    /*
    TouchButton *controllerBtn = (TouchButton *)[self.controllerBar viewWithTag:66];

    
    if(self.mycontact.defenceState==DEFENCE_STATE_WARNING_NET||self.mycontact.defenceState==DEFENCE_STATE_WARNING_PWD){
        //                [button setBackgroundImage:[UIImage imageNamed:@"video_lock"] forState:UIControlStateNormal];
        
    }else if(self.mycontact.defenceState==DEFENCE_STATE_ON){
        [controllerBtn setBackgroundImage:[UIImage imageNamed:@"equipment_lock"] forState:UIControlStateNormal];

    }else if(self.mycontact.defenceState==DEFENCE_STATE_OFF){
        
         dispatch_async(dispatch_get_main_queue(), ^{
             [controllerBtn setBackgroundImage:[UIImage imageNamed:@"video_lock"] forState:UIControlStateNormal];
             });
        
    }else if(self.mycontact.defenceState==DEFENCE_STATE_NO_PERMISSION){
        [controllerBtn setBackgroundImage:[UIImage imageNamed:@"ic_defence_limit.png"] forState:UIControlStateNormal];
    }
     */
    

    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.number = value;
        
        self.numberViewer.text = [NSString stringWithFormat:@"%@ %i",NSLocalizedString(@"number_viewer", nil),self.number];
    });
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isShowControllerBar = YES;
    self.isVideoModeHD = NO;
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    [[PAIOUnit sharedUnit] setMuteAudio:NO];
    [[PAIOUnit sharedUnit] setSpeckState:YES];
    [self initComponent];
}

- (void)renderView
{
    
    
    GAVFrame * m_pAVFrame ;
    //    [_remoteView setInitialized:YES];
    while (!self.isReject)
    {
        
        if(fgGetVideoFrameToDisplay(&m_pAVFrame))
        {
            //DLog(@"%i:%i",m_pAVFrame->width,m_pAVFrame->height);
            [self.remoteView render:m_pAVFrame];
            vReleaseVideoFrame();

        }
        usleep(10000);
        
        
    }
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (TouchButton *)getControllerButton
{
    TouchButton *button = [TouchButton buttonWithType:UIButtonTypeCustom];
    
    [button setFrame:CGRectMake(0, 0, 50, 38)];
//    [button setAlpha:0.5];
//    [button setOpaque:YES];
    [button setBackgroundColor:[UIColor darkGrayColor]];
//    [button.layer setBorderColor:[[UIColor blackColor] CGColor]];
//    [button.layer setBorderWidth:2.0f];
    return button;
}

#define CONTROLLER_BAR_HEIGHT (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 62:38)
#define CONTROLLER_BAR_BUTTON_WIDTH (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 82:50)
#define PRESS_LAYOUT_WIDTH_AND_HEIGHT 38
#define CONTROLLER_RIGHT_ITEM_WIDTH 70
#define CONTROLLER_RIGHT_ITEM_HEIGHT 40
#define NUMBER_VIEW_LABEL_WIDTH (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 170:150)
#define NUMBER_VIEW_LABEL_HEIGHT 25
#define CONTROLLER_BTN_COUNT 4

#define CONTROLLER_BTN_TAG_HUNGUP 0
#define CONTROLLER_BTN_TAG_SOUND 1
#define CONTROLLER_BTN_TAG_SCREENSHOT 2
#define CONTROLLER_BTN_TAG_PRESS_TALK 3
#define CONTROLLER_BTN_TAG_HD 4
#define CONTROLLER_BTN_TAG_SD 5
#define CONTROLLER_BTN_TAG_LD 6
-(void)initComponent{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    CGRect rect = [AppDelegate getScreenSize:NO isHorizontal:YES];
    CGFloat width = rect.size.width;
    
    CGFloat height = rect.size.height;
    if(CURRENT_VERSION<7.0){
        height +=20;
    }
    
    [self.view setBackgroundColor:XBlack];
    
    OpenGLView *glView = [[OpenGLView alloc] init];
    
    BOOL is16B9 = [[P2PClient sharedClient] is16B9];
    if(is16B9){
        CGFloat finalWidth = height*16/9;
        CGFloat finalHeight = height;
        if(finalWidth>width){
            finalWidth = width;
            finalHeight = width*9/16;
        }else{
            finalWidth = height*16/9;
            finalHeight = height;
        }
        glView.frame = CGRectMake((width-finalWidth)/2, (height-finalHeight)/2, finalWidth, finalHeight);

    }else{
        glView.frame = CGRectMake((width-height*4/3)/2, 0, height*4/3, height);
    }
    
    self.remoteView = glView;
    self.remoteView.delegate = self;
    [self.remoteView.layer setMasksToBounds:YES];
    [self.view addSubview:self.remoteView];
    [glView release];
    
    UIView *pressView = [[UIView alloc] initWithFrame:CGRectMake(10, height-10-PRESS_LAYOUT_WIDTH_AND_HEIGHT, PRESS_LAYOUT_WIDTH_AND_HEIGHT/2, PRESS_LAYOUT_WIDTH_AND_HEIGHT)];
    
    UIImageView *pressLeftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, PRESS_LAYOUT_WIDTH_AND_HEIGHT/2, PRESS_LAYOUT_WIDTH_AND_HEIGHT)];
    pressLeftView.image = [UIImage imageNamed:@"ic_voice.png"];
    [pressView addSubview:pressLeftView];
    
    UIImageView *pressRightView = [[UIImageView alloc] initWithFrame:CGRectMake(PRESS_LAYOUT_WIDTH_AND_HEIGHT/2, 0, PRESS_LAYOUT_WIDTH_AND_HEIGHT/2, PRESS_LAYOUT_WIDTH_AND_HEIGHT)];
    NSArray *imagesArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"amp1.png"],[UIImage imageNamed:@"amp2.png"],[UIImage imageNamed:@"amp3.png"],[UIImage imageNamed:@"amp4.png"],[UIImage imageNamed:@"amp5.png"],[UIImage imageNamed:@"amp6.png"],[UIImage imageNamed:@"amp7.png"],[UIImage imageNamed:@"amp4.png"],[UIImage imageNamed:@"amp5.png"],[UIImage imageNamed:@"amp6.png"],[UIImage imageNamed:@"amp3.png"],[UIImage imageNamed:@"amp5.png"],[UIImage imageNamed:@"amp6.png"],[UIImage imageNamed:@"amp6.png"],[UIImage imageNamed:@"amp3.png"],[UIImage imageNamed:@"amp4.png"],[UIImage imageNamed:@"amp5.png"],[UIImage imageNamed:@"amp5.png"],nil];
   
    pressRightView.animationImages = imagesArray;
    pressRightView.animationDuration = ((CGFloat)[imagesArray count])*200.0f/1000.0f;
    pressRightView.animationRepeatCount = 0;
    [pressRightView startAnimating];
    
    [pressView addSubview:pressRightView];
    [self.view addSubview:pressView];
    [pressView setHidden:YES];
    self.pressView = pressView;
    
    [pressView release];
    [pressLeftView release];
    [pressRightView release];
    
    UITapGestureRecognizer *doubleTapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTap)];
    doubleTapG.delegate = self;
    [doubleTapG setNumberOfTapsRequired:2];
    [self.remoteView addGestureRecognizer:doubleTapG];
    
    UITapGestureRecognizer *singleTapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap)];
    singleTapG.delegate = self;
    [singleTapG setNumberOfTapsRequired:1];
    [singleTapG requireGestureRecognizerToFail:doubleTapG];
    [self.remoteView addGestureRecognizer:singleTapG];
    
    UISwipeGestureRecognizer *swipeGestureUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp:)];
    [swipeGestureUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [swipeGestureUp setCancelsTouchesInView:YES];
    [swipeGestureUp setDelaysTouchesEnded:YES];
    [_remoteView addGestureRecognizer:swipeGestureUp];
    
    UISwipeGestureRecognizer *swipeGestureDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown:)];
    [swipeGestureDown setDirection:UISwipeGestureRecognizerDirectionDown];
    
    [swipeGestureDown setCancelsTouchesInView:YES];
    [swipeGestureDown setDelaysTouchesEnded:YES];
    [_remoteView addGestureRecognizer:swipeGestureDown];
    
    UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    [swipeGestureLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeGestureLeft setCancelsTouchesInView:YES];
    [swipeGestureLeft setDelaysTouchesEnded:YES];
    [_remoteView addGestureRecognizer:swipeGestureLeft];
    
    UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    [swipeGestureRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [swipeGestureRight setCancelsTouchesInView:YES];
    [swipeGestureRight setDelaysTouchesEnded:YES];
    [_remoteView addGestureRecognizer:swipeGestureRight];
    
    [doubleTapG release];
    [singleTapG release];
    [swipeGestureUp release];
    [swipeGestureDown release];
    [swipeGestureLeft release];
    [swipeGestureRight release];
    
//    UIView *controllBar = [[UIView alloc] initWithFrame:CGRectMake((width-CONTROLLER_BAR_BUTTON_WIDTH*CONTROLLER_BTN_COUNT)/2, height-20-CONTROLLER_BAR_HEIGHT, CONTROLLER_BAR_BUTTON_WIDTH*CONTROLLER_BTN_COUNT, CONTROLLER_BAR_HEIGHT)];
     UIView *controllBar = [[UIView alloc] initWithFrame:CGRectMake(0, height-CONTROLLER_BAR_HEIGHT, width, CONTROLLER_BAR_HEIGHT)];
//    controllBar.layer.cornerRadius = 8.0f;
//    [controllBar.layer setBorderWidth:2];
//    [controllBar.layer setMasksToBounds:YES];
    controllBar.backgroundColor=[UIColor grayColor];
    
    controllBar.alpha=0.5;
    for(int i=0;i<6;i++){
        TouchButton *controllerBtn = [self getControllerButton];
        
        if(i==4){
            controllerBtn.tag = CONTROLLER_BTN_TAG_SOUND;
//            [controllerBtn setBackgroundImage:[UIImage imageNamed:@"ic_ctl_sound_on.png"] forState:UIControlStateNormal];
            [controllerBtn setBackgroundImage:[UIImage imageNamed:@"video_volume"] forState:UIControlStateNormal];
            
        }else if(i==2){
            controllerBtn.tag = CONTROLLER_BTN_TAG_SCREENSHOT;
//            [controllerBtn setBackgroundImage:[UIImage imageNamed:@"ic_ctl_screenshot.png"] forState:UIControlStateNormal];
            [controllerBtn setBackgroundImage:[UIImage imageNamed:@"video_camera"] forState:UIControlStateNormal];
        }else if(i==0){
            controllerBtn.tag = CONTROLLER_BTN_TAG_HUNGUP;
//            [controllerBtn setBackgroundImage:[UIImage imageNamed:@"ic_ctl_hungup.png"] forState:UIControlStateNormal];
             [controllerBtn setBackgroundImage:[UIImage imageNamed:@"video_return"] forState:UIControlStateNormal];
           
//            UIColor *bgRedColor = [UIColor colorWithRed:0.82 green:0.22 blue:0.20 alpha:1.0];
//            [controllerBtn setBackgroundColor:bgRedColor];
        }else if(i==5){
            controllerBtn.tag = CONTROLLER_BTN_TAG_PRESS_TALK;
//            [controllerBtn setBackgroundImage:[UIImage imageNamed:@"ic_ctl_send_audio.png"] forState:UIControlStateNormal];
            [controllerBtn setBackgroundImage:[UIImage imageNamed:@"video_voice.png"] forState:UIControlStateNormal];
        }else if (i==3){
            controllerBtn.tag=66;
            
//            [controllerBtn setBackgroundImage:[UIImage imageNamed:@"equipment_lock"] forState:UIControlStateNormal];
            if (self.contact.defenceState == DEFENCE_STATE_ON) {
                [controllerBtn setBackgroundImage:[UIImage imageNamed:@"equipment_lock"] forState:UIControlStateNormal];
            }else if(self.contact.defenceState==DEFENCE_STATE_NO_PERMISSION){
                [controllerBtn setBackgroundImage:[UIImage imageNamed:@"ic_defence_limit.png"] forState:UIControlStateNormal];
            }else
            {
                [controllerBtn setBackgroundImage:[UIImage imageNamed:@"video_lock"] forState:UIControlStateNormal];
            }
            
            // @"equipment_lock"
            // @"video_lock"
            
        }else if(i==1){
            controllerBtn.tag=99;
            //            [controllerBtn setBackgroundImage:[UIImage imageNamed:@"ic_ctl_screenshot.png"] forState:UIControlStateNormal];
            [controllerBtn setBackgroundImage:[UIImage imageNamed:@"video_set"] forState:UIControlStateNormal];
        }
        
        if(i==5){
            controllerBtn.delegate = self;
        }else{
            
            [controllerBtn addTarget:self action:@selector(onControllerBtnPress:) forControlEvents:UIControlEventTouchUpInside];
            
            
        }
        
//        controllerBtn.frame = CGRectMake(CONTROLLER_BAR_BUTTON_WIDTH*i, 0, CONTROLLER_BAR_BUTTON_WIDTH,CONTROLLER_BAR_HEIGHT);
        controllerBtn.frame = CGRectMake(([UIScreen mainScreen].bounds.size.height/6)*i+30, 5, 35,28);
        NSLog(@"===%f",([UIScreen mainScreen].bounds.size.height/6)*i);
        controllerBtn.backgroundColor=[UIColor clearColor];
        [controllBar addSubview:controllerBtn];
    }
    
    
    [self.view addSubview:controllBar];
    self.controllerBar = controllBar;
    [controllBar release];
    int rightItemCount = 0;
    if(is16B9){
        rightItemCount = 3;
    }else{
        rightItemCount = 2;
    }
    
//    UIView *controllerRight = [[UIView alloc] initWithFrame:CGRectMake(width-CONTROLLER_RIGHT_ITEM_WIDTH-10, (height-CONTROLLER_RIGHT_ITEM_HEIGHT*rightItemCount)/2, CONTROLLER_RIGHT_ITEM_WIDTH, CONTROLLER_RIGHT_ITEM_HEIGHT*rightItemCount)];
       UIView *controllerRight = [[UIView alloc] initWithFrame:CGRectMake(width/6+15, height-CONTROLLER_RIGHT_ITEM_HEIGHT*rightItemCount - 40  , CONTROLLER_RIGHT_ITEM_WIDTH, CONTROLLER_RIGHT_ITEM_HEIGHT*rightItemCount)];
    
//    controllerRight.layer.cornerRadius = 2.0f;
//    [controllerRight.layer setBorderWidth:1];
    [controllerRight.layer setMasksToBounds:YES];

    
    for(int i=0;i<rightItemCount;i++){
        TouchButton *button = [self getControllerButton];
        button.frame = CGRectMake(0, CONTROLLER_RIGHT_ITEM_HEIGHT*i, CONTROLLER_RIGHT_ITEM_WIDTH, CONTROLLER_RIGHT_ITEM_HEIGHT);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, button.frame.size.width, button.frame.size.height)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = XWhite;
        label.font = XFontBold_14;
        
        if(rightItemCount==2){
            if(i==0){
                label.text = NSLocalizedString(@"SD", nil);
                button.tag = CONTROLLER_BTN_TAG_SD;
            }else if(i==1){
                label.text = NSLocalizedString(@"LD", nil);
                button.tag = CONTROLLER_BTN_TAG_LD;
                button.backgroundColor = XBlue;
            }
        }else if(rightItemCount==3){
            if(i==0){
                label.text = NSLocalizedString(@"HD", nil);
                button.tag = CONTROLLER_BTN_TAG_HD;
            }else if(i==1){
                label.text = NSLocalizedString(@"SD", nil);
                button.tag = CONTROLLER_BTN_TAG_SD;
                button.backgroundColor = XBlue;
            }else if(i==2){
                label.text = NSLocalizedString(@"LD", nil);
                button.tag = CONTROLLER_BTN_TAG_LD;
                //
                
            }
        }
        [button addSubview:label];
        [label release];
        [button addTarget:self action:@selector(onControllerBtnPress:) forControlEvents:UIControlEventTouchUpInside];
        [controllerRight addSubview:button];
    }
    
    [self.view addSubview:controllerRight];
    self.controllerRight = controllerRight;
    controllerRight.hidden=YES;
    [controllerRight release];
    
    
    if (is16B9) {
        UILabel *label11 = [[UILabel alloc] initWithFrame:CGRectMake(width-NUMBER_VIEW_LABEL_WIDTH-15, 5, NUMBER_VIEW_LABEL_WIDTH, NUMBER_VIEW_LABEL_HEIGHT)];
        label11.backgroundColor = [UIColor blackColor];
        label11.alpha = 0.5;
        label11.textAlignment = NSTextAlignmentCenter;
        label11.textColor = [UIColor whiteColor];
        label11.font = XFontBold_16;
        label11.text = [NSString stringWithFormat:@"%@ %i",NSLocalizedString(@"number_viewer", nil),self.number];
        
        [self.remoteView addSubview:label11];
        self.numberViewer = label11;
        [label11 release];
    }
    
}




-(void)onBegin:(TouchButton *)touchButton widthTouches:(NSSet *)touches withEvent:(UIEvent *)event{
    DLog(@"onBegin");
    [self.pressView setHidden:NO];
    [[PAIOUnit sharedUnit] setSpeckState:NO];
}

-(void)onCancelled:(TouchButton *)touchButton widthTouches:(NSSet *)touches withEvent:(UIEvent *)event{
    DLog(@"onCancelled");
    [self.pressView setHidden:YES];
    [[PAIOUnit sharedUnit] setSpeckState:YES];
}

-(void)onEnded:(TouchButton *)touchButton widthTouches:(NSSet *)touches withEvent:(UIEvent *)event{
    DLog(@"onEnded");
    [self.pressView setHidden:YES];
    [[PAIOUnit sharedUnit] setSpeckState:YES];
}

-(void)onMoved:(TouchButton *)touchButton widthTouches:(NSSet *)touches withEvent:(UIEvent *)event{
    DLog(@"onMoved");
}

-(void)onControllerBtnPress:(id)sender{
    UIButton *button = (UIButton*)sender;
    switch(button.tag){
        case CONTROLLER_BTN_TAG_HUNGUP:      //挂断
        {
            if(!self.isReject){
                self.isReject = !self.isReject;
                [[P2PClient sharedClient] p2pHungUp];
                MainController *mainController = [AppDelegate sharedDefault].mainController;
                [mainController dismissP2PView];
                
                [[NSNotificationCenter defaultCenter] removeObserver:self name:RECEIVE_PLAYING_CMD object:nil];
            }
            
        }
            break;
        case CONTROLLER_BTN_TAG_SOUND:      //静音
        {
            
            BOOL isMute = [[PAIOUnit sharedUnit] muteAudio];
            
            
            DLog(@"onControllerBtnPress:CONTROLLER_BTN_TAG_SOUND");
            if(isMute){
                [[PAIOUnit sharedUnit] setMuteAudio:NO];
//                [sender setBackgroundImage:[UIImage imageNamed:@"ic_ctl_sound_on.png"] forState:UIControlStateNormal];
                  [sender setBackgroundImage:[UIImage imageNamed:@"video_volume"] forState:UIControlStateNormal];
            }else{
                
                [[PAIOUnit sharedUnit] setMuteAudio:YES];
                [sender setBackgroundImage:[UIImage imageNamed:@"voice_no_sound"] forState:UIControlStateNormal];
            }
        }
            break;
        case CONTROLLER_BTN_TAG_HD:
        {
            [[P2PClient sharedClient] sendCommandType:USR_CMD_VIDEO_CTL andOption:7];
            [self updateRightButtonState:CONTROLLER_BTN_TAG_HD];
            
        }
            break;
        case CONTROLLER_BTN_TAG_SD:
        {
            [[P2PClient sharedClient] sendCommandType:USR_CMD_VIDEO_CTL andOption:5];
            [self updateRightButtonState:CONTROLLER_BTN_TAG_SD];
        }
            break;
        case CONTROLLER_BTN_TAG_LD:
        {
            [[P2PClient sharedClient] sendCommandType:USR_CMD_VIDEO_CTL andOption:6];
            [self updateRightButtonState:CONTROLLER_BTN_TAG_LD];
        }
            break;
        case CONTROLLER_BTN_TAG_SCREENSHOT:    //截图
        {

            [self.remoteView setIsScreenShotting:YES];
        }
            break;
        case CONTROLLER_BTN_TAG_PRESS_TALK:
        {
            
        }
            break;
        case 66:{

            [[FListManager sharedFList] setIsClickDefenceStateBtnWithId:self.mycontact.contactId isClick:YES];
            if(self.mycontact.defenceState==DEFENCE_STATE_WARNING_NET||self.mycontact.defenceState==DEFENCE_STATE_WARNING_PWD){
                [[P2PClient sharedClient] getDefenceState:self.mycontact.contactId password:self.mycontact.contactPassword];
                
//                [button setBackgroundImage:[UIImage imageNamed:@"video_lock"] forState:UIControlStateNormal];
                
            }else if(self.contact.defenceState==DEFENCE_STATE_ON){
                [[P2PClient sharedClient] setRemoteDefenceWithId:self.contact.contactId password:self.contact.contactPassword state:SETTING_VALUE_REMOTE_DEFENCE_STATE_OFF];
                self.contact.defenceState = DEFENCE_STATE_OFF;
                [button setBackgroundImage:[UIImage imageNamed:@"video_lock"] forState:UIControlStateNormal];
                
            }else if(self.contact.defenceState==DEFENCE_STATE_OFF){
                [[P2PClient sharedClient] setRemoteDefenceWithId:self.contact.contactId password:self.contact.contactPassword state:SETTING_VALUE_REMOTE_DEFENCE_STATE_ON];
                self.contact.defenceState = DEFENCE_STATE_ON;
                [button setBackgroundImage:[UIImage imageNamed:@"equipment_lock"] forState:UIControlStateNormal];
                
            }else if(self.contact.defenceState==DEFENCE_STATE_NO_PERMISSION){
                [self.view makeToast:NSLocalizedString(@"no_permission", nil)];
                
                [button setBackgroundImage:[UIImage imageNamed:@"ic_defence_limit.png"] forState:UIControlStateNormal];
            }
            
        }
            break;
        case 99:{
            self.controllerRight.hidden=!self.controllerRight.hidden;
        }
            break;
    }
}


// 将截好的图片保存
-(void)onScreenShotted:(UIImage *)image{
    UIImage *tempImage = [[UIImage alloc] initWithCGImage:image.CGImage];
    LoginResult *loginResult = [UDManager getLoginInfo];
    NSData *imgData = [NSData dataWithData:UIImagePNGRepresentation(tempImage)];
    [Utils saveScreenshotFileWithId:loginResult.contactId data:imgData];
    
    NSLog(@"%@",loginResult.contactId);
    
    [tempImage release];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view makeToast:NSLocalizedString(@"screenshot_success", nil)];
    });
    
}

#pragma mark - 设置高清、标清选中
-(void)updateRightButtonState:(NSInteger)tag{
    UIButton *button = (UIButton*)[self.controllerRight viewWithTag:tag];
    for(UIView *view in self.controllerRight.subviews){
        view.backgroundColor = [UIColor darkGrayColor];
    }
    
    button.backgroundColor = XBlue;
    
}

- (void)swipeUp:(id)sender {
    [[P2PClient sharedClient] sendCommandType:USR_CMD_PTZ_CTL
                                                 andOption:USR_CMD_OPTION_PTZ_TURN_DOWN];
}

- (void)swipeDown:(id)sender {
    [[P2PClient sharedClient] sendCommandType:USR_CMD_PTZ_CTL
                                                 andOption:USR_CMD_OPTION_PTZ_TURN_UP];
}

- (void)swipeLeft:(id)sender {
    [[P2PClient sharedClient] sendCommandType:USR_CMD_PTZ_CTL
                                                 andOption:USR_CMD_OPTION_PTZ_TURN_LEFT];
}

- (void)swipeRight:(id)sender {
    [[P2PClient sharedClient] sendCommandType:USR_CMD_PTZ_CTL
                                                 andOption:USR_CMD_OPTION_PTZ_TURN_RIGHT];
}

-(void)onSingleTap{
    
    if (self.isShowControllerBar) {
        self.isShowControllerBar = !self.isShowControllerBar;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [self.controllerBar setAlpha:0.0];
        self.controllerRight.hidden = YES;
        [UIView commitAnimations];
    }else{
        self.isShowControllerBar = !self.isShowControllerBar;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [self.controllerBar setAlpha:0.5];
        self.controllerRight.hidden = YES;
        [UIView commitAnimations];
    }
}

-(void)onDoubleTap{
    
    BOOL is16B9 = [[P2PClient sharedClient] is16B9];
    if(!is16B9){
        CGRect rect = [AppDelegate getScreenSize:NO isHorizontal:YES];
        CGFloat width = rect.size.width;
        CGFloat height = rect.size.height;
        if(CURRENT_VERSION<7.0){
            height +=20;
        }
        DLog(@"screen-size: %f-%f",width,height);
        if (self.isFullScreen) {
            self.isFullScreen = !self.isFullScreen;
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.2];
            CGAffineTransform transform;
            transform = CGAffineTransformMakeScale(1.0, 1.0f);
            self.remoteView.transform = transform;
            [UIView commitAnimations];
        }else{
            self.isFullScreen = !self.isFullScreen;
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.2];
            if (CURRENT_VERSION>=8.0) {
                CGAffineTransform transform = CGAffineTransformMakeScale(height/(width*4/3),1.0f);
                self.remoteView.transform = transform;
            }else{
                CGAffineTransform transform = CGAffineTransformMakeScale(width/(height*4/3),1.0f);
                self.remoteView.transform = transform;
            }
//            CGAffineTransform transform = CGAffineTransformMakeScale(width/(height*4/3),1.0f);
//            self.remoteView.transform = transform;
            [UIView commitAnimations];
        }
    }
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(BOOL)shouldAutorotate{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interface {
    return (interface == UIInterfaceOrientationLandscapeRight );
}

#ifdef IOS6

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight;
}
#endif

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeRight;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeRight;
}
@end
