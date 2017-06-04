//
//  SmartKeyController.m
//  2cu
//
//  Created by guojunyi on 14-9-5.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import "SmartKeyController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "TopBar.h"
#import <AudioUnit/AudioUnit.h>
#import "YAudioStreamPlayer.h"
#import "FListManager.h"
#import <AudioToolbox/AudioToolbox.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import "YProgressView.h"
#import "Toast+UIView.h"
#import "PrefixHeader.pch"
@interface SmartKeyController ()

@end

@implementation SmartKeyController

-(void)dealloc{
    [self.smartKeyPromptView release];
    [self.insertContent release];
    [self.setWifiContent release];
    [self.field1 release];
    [self.field2 release];
    [self.field3 release];
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

-(void)viewWillDisappear:(BOOL)animated{
    [[YAudioStreamPlayer sharedDefault] stop];
    self.isCheckingRoute = NO;
    self.isSendingCmd = NO;
    self.isWaiting = NO;
    self.isFinish = YES;
    self.isRun = NO;
    if(self.socket){
        [self.socket close];
        self.socket=nil;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    MainController *mainController = [AppDelegate sharedDefault].mainController;
    [mainController setBottomBarHidden:YES];
    [[YAudioStreamPlayer sharedDefault] start];
    NSDictionary *ifs = [self fetchSSIDInfo];
    NSLog(@"ifs:%@",ifs);
    NSString *ssid = [ifs objectForKey:@"SSID"];
    NSLog(@"ssid：%@",ssid);
    if(nil==ssid){
        self.field1.text = @"";
    }else{
        self.field1.text = ssid;
    }
    
    self.isFinish = NO;
    self.isCheckingRoute = YES;
    self.isSmartKeyOK = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while(self.isCheckingRoute){
            if(!self.isWaiting){
                if(![self checkSmartKey]){
                    self.isSmartKeyOK = NO;
                    self.isSendingCmd = NO;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.setWifiContent setHidden:YES];
                        [self.insertContent setHidden:NO];
                        [self.smartKeyPromptView setHidden:NO];
                    });
                    
                }else{
                    self.isSmartKeyOK = YES;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.insertContent setHidden:YES];
                        if([self.setWifiContent isHidden]){
                            [self.smartKeyPromptView setHidden:YES];
                        }
                    });
                    
                }
                if(self.isSendingCmd){
                    [[YAudioStreamPlayer sharedDefault] playWIFI:self.field1.text wifiPassword:self.field2.text devicePassword:self.field3.text];
                }
            }
            
            
            usleep(1000000);
        }
    });
    
}

-(void)viewDidAppear:(BOOL)animated{
    self.isRun = YES;
    self.isPrepared = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while(self.isRun){
            if(!self.isPrepared){
                [self prepareSocket];
            }
            usleep(1000000);
        }
    });
    
    
}

-(BOOL)prepareSocket{
    GCDAsyncUdpSocket *socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    NSError *error = nil;
    
    
    if (![socket bindToPort:9988 error:&error])
    {
        //NSLog(@"Error binding: %@", [error localizedDescription]);
        return NO;
    }
    if (![socket beginReceiving:&error])
    {
        NSLog(@"Error receiving: %@", [error localizedDescription]);
        return NO;
    }
    
    if (![socket enableBroadcast:YES error:&error])
    {
        NSLog(@"Error enableBroadcast: %@", [error localizedDescription]);
        return NO;
    }
    
    self.socket = socket;
    self.isPrepared = YES;
    return YES;
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

#define FIELD_ITEM_HEIGHT 40
#define NEXT_BUTTON_WIDTH 138
#define NEXT_BUTTON_HEIGHT 40
#define INSERT_CONTENT_VIEW_WIDTH 288
#define INSERT_CONTENT_VIEW_HEIGHT 300
#define SET_WIFI_CONTENT_VIEW_WIDTH 288
#define SET_WIFI_CONTENT_VIEW_HEIGHT 388
#define SET_WIFI_CONTENT_BOTTOM_BUTTON_WIDTH 68
#define SET_WIFI_CONTENT_BOTTOM_BUTTON_HEIGHT 32
#define WAITING_CONTENT_VIEW_WIDTH 288
#define WAITING_CONTENT_VIEW_HEIGHT 300
-(void)initComponent{
    [self.view setBackgroundColor:XBgColor];
    CGRect rect = [AppDelegate getScreenSize:YES isHorizontal:NO];
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    TopBar *topBar = [[TopBar alloc] initWithFrame:CGRectMake(0, 0, width, NAVIGATION_BAR_HEIGHT)];
    [topBar setTitle:NSLocalizedString(@"smart_key",nil)];
    [topBar setBackButtonHidden:NO];
    [topBar.backButton addTarget:self action:@selector(onBackPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:topBar];
    [topBar release];
    
    
    UIView *fieldView = [[UIView alloc] initWithFrame:CGRectMake(10, NAVIGATION_BAR_HEIGHT+20, width-20, FIELD_ITEM_HEIGHT*3+2)];
    
    fieldView.layer.borderWidth = 1.0;
    fieldView.layer.borderColor = [[UIColor blackColor] CGColor];
    fieldView.layer.cornerRadius = 5.0;
    
    UIView *separator1 = [[UIView alloc] initWithFrame:CGRectMake(0, FIELD_ITEM_HEIGHT, fieldView.frame.size.width, 1)];
    separator1.backgroundColor = [UIColor blackColor];
    UIView *separator2 = [[UIView alloc] initWithFrame:CGRectMake(0, FIELD_ITEM_HEIGHT*2+1, fieldView.frame.size.width, 1)];
    separator2.backgroundColor = [UIColor blackColor];
    
    [fieldView addSubview:separator1];
    [fieldView addSubview:separator2];
    [separator1 release];
    [separator2 release];
    
    UITextField *field1 = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, fieldView.frame.size.width-20, FIELD_ITEM_HEIGHT)];
    field1.backgroundColor = [UIColor clearColor];
    field1.textAlignment = NSTextAlignmentLeft;
    field1.borderStyle = UITextBorderStyleNone;
    field1.font = XFontBold_16;
    field1.returnKeyType = UIReturnKeyDone;
    field1.placeholder = NSLocalizedString(@"input_ssid", nil);
    field1.autocapitalizationType = UITextAutocapitalizationTypeNone;
    field1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [fieldView addSubview:field1];
    [field1 addTarget:self action:@selector(onKeyBoardDown:) forControlEvents:UIControlEventEditingDidEndOnExit];
    self.field1 = field1;
    [field1 release];
    
    UITextField *field2 = [[UITextField alloc] initWithFrame:CGRectMake(10, FIELD_ITEM_HEIGHT+1, fieldView.frame.size.width-20, FIELD_ITEM_HEIGHT)];
    field2.backgroundColor = [UIColor clearColor];
    field2.textAlignment = NSTextAlignmentLeft;
    field2.borderStyle = UITextBorderStyleNone;
    field2.font = XFontBold_16;
    field2.returnKeyType = UIReturnKeyDone;
    field2.placeholder = NSLocalizedString(@"input_wifi_password_sk", nil);
    field2.autocapitalizationType = UITextAutocapitalizationTypeNone;
    field2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [fieldView addSubview:field2];
    [field2 addTarget:self action:@selector(onKeyBoardDown:) forControlEvents:UIControlEventEditingDidEndOnExit];
    self.field2 = field2;
    [field2 release];
    
    UITextField *field3 = [[UITextField alloc] initWithFrame:CGRectMake(10, FIELD_ITEM_HEIGHT*2+2, fieldView.frame.size.width-20, FIELD_ITEM_HEIGHT)];
    field3.backgroundColor = [UIColor clearColor];
    field3.textAlignment = NSTextAlignmentLeft;
    field3.borderStyle = UITextBorderStyleNone;
    field3.font = XFontBold_16;
    field3.returnKeyType = UIReturnKeyDone;
    field3.placeholder = NSLocalizedString(@"input_device_password_sk", nil);
    field3.autocapitalizationType = UITextAutocapitalizationTypeNone;
    field3.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [fieldView addSubview:field3];
    [field3 addTarget:self action:@selector(onKeyBoardDown:) forControlEvents:UIControlEventEditingDidEndOnExit];
    self.field3 = field3;
    [field3 release];
    
    [self.view addSubview:fieldView];
    
    
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton addTarget:self action:@selector(onNextPress) forControlEvents:UIControlEventTouchUpInside];
    nextButton.frame = CGRectMake((width-NEXT_BUTTON_WIDTH)/2, fieldView.frame.origin.y+fieldView.frame.size.height+20, NEXT_BUTTON_WIDTH, NEXT_BUTTON_HEIGHT);
    UIImage *nextButtonImage = [UIImage imageNamed:@"bg_blue_button.png"];
    UIImage *nextButtonImage_p = [UIImage imageNamed:@"bg_blue_button_p.png"];
    nextButtonImage = [nextButtonImage stretchableImageWithLeftCapWidth:nextButtonImage.size.width*0.5 topCapHeight:nextButtonImage.size.height*0.5];
    nextButtonImage_p = [nextButtonImage_p stretchableImageWithLeftCapWidth:nextButtonImage_p.size.width*0.5 topCapHeight:nextButtonImage_p.size.height*0.5];
    [nextButton setBackgroundImage:nextButtonImage forState:UIControlStateNormal];
    [nextButton setBackgroundImage:nextButtonImage_p forState:UIControlStateHighlighted];
    [nextButton setTitle:NSLocalizedString(@"next", nil) forState:UIControlStateNormal];
    
    [self.view addSubview:nextButton];
    [fieldView release];
    
    
    UIView *smartKeyPromptView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, width, height-NAVIGATION_BAR_HEIGHT)];
    smartKeyPromptView.backgroundColor = XBlack_128;
    
    //INSERT CONTENT
    UIImageView *insertContent = [[UIImageView alloc] initWithFrame:CGRectMake((smartKeyPromptView.frame.size.width-INSERT_CONTENT_VIEW_WIDTH)/2, (smartKeyPromptView.frame.size.height-INSERT_CONTENT_VIEW_HEIGHT)/2, INSERT_CONTENT_VIEW_WIDTH, INSERT_CONTENT_VIEW_HEIGHT)];
    UIImage *insertContentImage = [UIImage imageNamed:@"bg_smart_key_prompt.png"];
    insertContentImage = [insertContentImage stretchableImageWithLeftCapWidth:insertContentImage.size.width*0.5 topCapHeight:insertContentImage.size.height*0.5];
    insertContent.image = insertContentImage;
    [smartKeyPromptView addSubview:insertContent];
    
    UIImageView *insertContentTop = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, insertContent.frame.size.width-20*2, insertContent.frame.size.height/2)];
    insertContentTop.contentMode = UIViewContentModeScaleAspectFit;
    insertContentTop.image = [UIImage imageNamed:@"img_insert_smart_key.png"];
    [insertContent addSubview:insertContentTop];
    [insertContentTop release];
    
    UILabel *insertContentBottom = [[UILabel alloc] initWithFrame:CGRectMake(20, insertContent.frame.size.height/2, insertContent.frame.size.width-20*2, 50)];
    insertContentBottom.backgroundColor = [UIColor clearColor];
    insertContentBottom.textColor = XBlack;
    insertContentBottom.textAlignment = NSTextAlignmentCenter;
    insertContentBottom.text = NSLocalizedString(@"input_smart_key_prompt", nil);
    insertContentBottom.font = XFontBold_14;
    insertContentBottom.numberOfLines = 0;
    insertContentBottom.lineBreakMode = NSLineBreakByCharWrapping;
    [insertContent addSubview:insertContentBottom];
    [insertContentBottom release];
    
    self.insertContent = insertContent;
    [insertContent release];
    
    //SET WIFI CONTENT
    UIView *setWifiContent = [[UIView alloc] initWithFrame:CGRectMake((smartKeyPromptView.frame.size.width-SET_WIFI_CONTENT_VIEW_WIDTH)/2, (smartKeyPromptView.frame.size.height-SET_WIFI_CONTENT_VIEW_HEIGHT)/2, SET_WIFI_CONTENT_VIEW_WIDTH, SET_WIFI_CONTENT_VIEW_HEIGHT)];
    
    UIImageView *setWifiBackView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, setWifiContent.frame.size.width, setWifiContent.frame.size.height)];
    UIImage *setWifiContentImage = [UIImage imageNamed:@"bg_smart_key_prompt.png"];
    setWifiContentImage = [setWifiContentImage stretchableImageWithLeftCapWidth:setWifiContentImage.size.width*0.5 topCapHeight:setWifiContentImage.size.height*0.5];
    setWifiBackView.image = setWifiContentImage;
    [setWifiContent addSubview:setWifiBackView];
    [setWifiBackView release];
    [smartKeyPromptView addSubview:setWifiContent];
    
    
    
    UIView *setWifiContentTop = [[UIView alloc] initWithFrame:CGRectMake(20, 20, setWifiContent.frame.size.width-20*2, 120)];
    setWifiContentTop.backgroundColor = [UIColor clearColor];
    [setWifiContent addSubview:setWifiContentTop];
    
    UILabel *topLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, setWifiContentTop.frame.size.width, 20)];
    topLabel1.backgroundColor = [UIColor clearColor];
    topLabel1.textColor = XBlack;
    topLabel1.textAlignment = NSTextAlignmentLeft;
    topLabel1.numberOfLines = 0;
    topLabel1.lineBreakMode = NSLineBreakByCharWrapping;
    topLabel1.text = NSLocalizedString(@"set_wifi_content_prompt1", nil);
    topLabel1.font = XFontBold_14;
    [setWifiContentTop addSubview:topLabel1];
    
    UILabel *topLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, topLabel1.frame.origin.y+topLabel1.frame.size.height, setWifiContentTop.frame.size.width, 50)];
    topLabel2.backgroundColor = [UIColor clearColor];
    topLabel2.textColor = XBlack;
    topLabel2.textAlignment = NSTextAlignmentLeft;
    topLabel2.numberOfLines = 0;
    topLabel2.lineBreakMode = NSLineBreakByCharWrapping;
    topLabel2.text = NSLocalizedString(@"set_wifi_content_prompt2", nil);
    topLabel2.font = XFontBold_14;
    [setWifiContentTop addSubview:topLabel2];
    
    UILabel *topLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(0, topLabel2.frame.origin.y+topLabel2.frame.size.height, setWifiContentTop.frame.size.width, 50)];
    topLabel3.backgroundColor = [UIColor clearColor];
    topLabel3.textColor = XBlack;
    topLabel3.textAlignment = NSTextAlignmentLeft;
    topLabel3.numberOfLines = 0;
    topLabel3.lineBreakMode = NSLineBreakByCharWrapping;
    topLabel3.text = NSLocalizedString(@"set_wifi_content_prompt3", nil);
    topLabel3.font = XFontBold_14;
    [setWifiContentTop addSubview:topLabel3];
    
    [topLabel1 release];
    [topLabel2 release];
    [topLabel3 release];
    
    UIImageView *setWifiContentCenter = [[UIImageView alloc] initWithFrame:CGRectMake(20, setWifiContentTop.frame.origin.y+setWifiContentTop.frame.size.height, setWifiContent.frame.size.width-20*2, 160)];
    setWifiContentCenter.contentMode = UIViewContentModeScaleAspectFit;
    setWifiContentCenter.image = [UIImage imageNamed:@"img_set_wifi.png"];
    [setWifiContent addSubview:setWifiContentCenter];
    
    UIView *setWifiContentBottom = [[UIView alloc] initWithFrame:CGRectMake(20, setWifiContentCenter.frame.origin.y+setWifiContentCenter.frame.size.height, setWifiContent.frame.size.width-20*2, setWifiContent.frame.size.height-(setWifiContentCenter.frame.origin.y+setWifiContentCenter.frame.size.height))];
    
    UIButton *bottomButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomButton1 addTarget:self action:@selector(onBottomButtom1Press) forControlEvents:UIControlEventTouchUpInside];
    bottomButton1.frame = CGRectMake((setWifiContentBottom.frame.size.width-SET_WIFI_CONTENT_BOTTOM_BUTTON_WIDTH*2-20)/2, (setWifiContentBottom.frame.size.height-SET_WIFI_CONTENT_BOTTOM_BUTTON_HEIGHT)/2, SET_WIFI_CONTENT_BOTTOM_BUTTON_WIDTH, SET_WIFI_CONTENT_BOTTOM_BUTTON_HEIGHT);
    UIImage *bottomButton1Image = [UIImage imageNamed:@"bg_blue_button.png"];
    UIImage *bottomButton1Image_p = [UIImage imageNamed:@"bg_blue_button_p.png"];
    bottomButton1Image = [bottomButton1Image stretchableImageWithLeftCapWidth:bottomButton1Image.size.width*0.5 topCapHeight:bottomButton1Image.size.height*0.5];
    bottomButton1Image_p = [bottomButton1Image_p stretchableImageWithLeftCapWidth:bottomButton1Image_p.size.width*0.5 topCapHeight:bottomButton1Image_p.size.height*0.5];
    [bottomButton1 setBackgroundImage:bottomButton1Image forState:UIControlStateNormal];
    [bottomButton1 setBackgroundImage:bottomButton1Image_p forState:UIControlStateHighlighted];
    [bottomButton1 setTitle:NSLocalizedString(@"heard", nil) forState:UIControlStateNormal];
    
    UIButton *bottomButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomButton2 addTarget:self action:@selector(onBottomButtom2Press) forControlEvents:UIControlEventTouchUpInside];
    bottomButton2.frame = CGRectMake(bottomButton1.frame.origin.x+bottomButton1.frame.size.width+20, (setWifiContentBottom.frame.size.height-SET_WIFI_CONTENT_BOTTOM_BUTTON_HEIGHT)/2, SET_WIFI_CONTENT_BOTTOM_BUTTON_WIDTH, SET_WIFI_CONTENT_BOTTOM_BUTTON_HEIGHT);
    UIImage *bottomButton2Image = [UIImage imageNamed:@"bg_blue_button.png"];
    UIImage *bottomButton2Image_p = [UIImage imageNamed:@"bg_blue_button_p.png"];
    bottomButton2Image = [bottomButton2Image stretchableImageWithLeftCapWidth:bottomButton2Image.size.width*0.5 topCapHeight:bottomButton2Image.size.height*0.5];
    bottomButton2Image_p = [bottomButton2Image_p stretchableImageWithLeftCapWidth:bottomButton2Image_p.size.width*0.5 topCapHeight:bottomButton2Image_p.size.height*0.5];
    [bottomButton2 setBackgroundImage:bottomButton2Image forState:UIControlStateNormal];
    [bottomButton2 setBackgroundImage:bottomButton2Image_p forState:UIControlStateHighlighted];
    [bottomButton2 setTitle:NSLocalizedString(@"back", nil) forState:UIControlStateNormal];
    
    
    [setWifiContentBottom addSubview:bottomButton1];
    [setWifiContentBottom addSubview:bottomButton2];
    [setWifiContent addSubview:setWifiContentBottom];
    [setWifiContentBottom release];
    [setWifiContentCenter release];
    [setWifiContentTop release];
    self.setWifiContent = setWifiContent;
    [setWifiContent release];
    
    //WAITING CONTENT
    UIImageView *waitingContent = [[UIImageView alloc] initWithFrame:CGRectMake((smartKeyPromptView.frame.size.width-WAITING_CONTENT_VIEW_WIDTH)/2, (smartKeyPromptView.frame.size.height-WAITING_CONTENT_VIEW_HEIGHT)/2, WAITING_CONTENT_VIEW_WIDTH, WAITING_CONTENT_VIEW_HEIGHT)];
    UIImage *waitingContentImage = [UIImage imageNamed:@"bg_smart_key_prompt.png"];
    waitingContentImage = [waitingContentImage stretchableImageWithLeftCapWidth:waitingContentImage.size.width*0.5 topCapHeight:waitingContentImage.size.height*0.5];
    waitingContent.image = waitingContentImage;
    [smartKeyPromptView addSubview:waitingContent];
    
    UIImageView *waitingContentTop = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, waitingContent.frame.size.width-20*2, waitingContent.frame.size.height/2)];
    waitingContentTop.contentMode = UIViewContentModeScaleAspectFit;
    waitingContentTop.image = [UIImage imageNamed:@"img_waiting_set_wifi.png"];
    [waitingContent addSubview:waitingContentTop];
    [waitingContentTop release];
    
    
    YProgressView *yProgress = [[YProgressView alloc] initWithFrame:CGRectMake((waitingContent.frame.size.width-38)/2, waitingContent.frame.size.height/2+20+20, 38, 38)];
    yProgress.backgroundView.image = [UIImage imageNamed:@"ic_progress_blue.png"];
    [yProgress start];
    [waitingContent addSubview:yProgress];
    [yProgress release];
    
    UILabel *waitingContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, yProgress.frame.origin.y+yProgress.frame.size.height+10, waitingContent.frame.size.width-20*2, 50)];
    waitingContentLabel.backgroundColor = [UIColor clearColor];
    waitingContentLabel.textColor = XBlack;
    waitingContentLabel.textAlignment = NSTextAlignmentCenter;
    waitingContentLabel.text = NSLocalizedString(@"waiting_content_prompt", nil);
    waitingContentLabel.font = XFontBold_14;
    [waitingContent addSubview:waitingContentLabel];
    [waitingContentLabel release];
    
    self.waitingContent = waitingContent;
    [waitingContent release];
    
    [self.view addSubview:smartKeyPromptView];
    self.smartKeyPromptView = smartKeyPromptView;
    [smartKeyPromptView release];

    [self.insertContent setHidden:YES];
    [self.setWifiContent setHidden:YES];
    [self.waitingContent setHidden:YES];
    [self.smartKeyPromptView setHidden:YES];
    
}


-(void)onBackPress{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onNextPress{
    NSString *ssidString = self.field1.text;
    NSString *wifiPwd = self.field2.text;
    NSString *devicePwd = self.field3.text;
    
    if(ssidString.length<=0){
        [self.view makeToast:NSLocalizedString(@"input_ssid", nil)];
        return;
    }
    
    self.isSendingCmd = YES;
    [self.setWifiContent setHidden:NO];
    [self.smartKeyPromptView setHidden:NO];
    [self onKeyBoardDown:nil];
}

//点击“听到”了按钮
-(void)onBottomButtom1Press{
    DLog(@"onBottomButtom1Press");
    self.isWaiting = YES;
    self.isSendingCmd = NO;
    [self.insertContent setHidden:YES];
    [self.setWifiContent setHidden:YES];
    [self.waitingContent setHidden:NO];
    [self.smartKeyPromptView setHidden:NO];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        int index = 0;
        while(self.isWaiting){
            DLog(@"%i",index);
            index++;
            if(index>=60){
                break;
            }
            sleep(1.0);
        }
        
        
        if(![self.waitingContent isHidden]&&!self.isFinish){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.waitingContent setHidden:YES];
                [self.smartKeyPromptView setHidden:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"set_wifi_failed_title", nil) message:NSLocalizedString(@"set_wifi_failed_prompt", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil,nil];
                alert.tag = ALERT_TAG_SET_FAILED;
                [alert show];
                [alert release];
            });
            
        }
    });
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==ALERT_TAG_SET_FAILED) {
        if(buttonIndex==0){
            self.isWaiting = NO;
        }
    }else if(alertView.tag==ALERT_TAG_SET_SUCCESS){
        if(buttonIndex==0){
            self.isWaiting = NO;
            [self.navigationController popToRootViewControllerAnimated:YES];
            [[FListManager sharedFList] searchLocalDevices];
        }
    }
}

//点击“返回”按钮
-(void)onBottomButtom2Press{
    DLog(@"onBottomButtom2Press");
    [self.smartKeyPromptView setHidden:YES];
    [self.setWifiContent setHidden:YES];
    self.isSendingCmd = NO;
}
-(void)onKeyBoardDown:(id)sender{
    [self.field1 resignFirstResponder];
    [self.field2 resignFirstResponder];
    [self.field3 resignFirstResponder];
}

- (id)fetchSSIDInfo
{
    NSArray *ifs = (id)CNCopySupportedInterfaces();
    NSLog(@"%s: Supported interfaces: %@", __func__, ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (id)CNCopyCurrentNetworkInfo((CFStringRef)ifnam);
        if (info && [info count]) {
            break;
        }
        [info release];
    }
    [ifs release];
    return [info autorelease];
}

-(BOOL)checkSmartKey{
    #if TARGET_IPHONE_SIMULATOR
        return  NO;
    #endif
    CFStringRef route;
    UInt32 propertySize = sizeof(CFStringRef);
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propertySize, &route);
    
    if(NULL==route||CFStringGetLength(route)==0){
        return NO;
    }else{
        NSString *routeString = (NSString*)route;
        
        NSRange headphoneRange = [routeString rangeOfString:@"Headphone"];
        NSRange headsetRange = [routeString rangeOfString:@"Headset"];
        
        if(headphoneRange.location!=NSNotFound){
            return YES;
        }else if(headsetRange.location!=NSNotFound){
            return YES;
        }
    }
    
    return NO;
}


- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    NSLog(@"did send");
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error
{
    NSLog(@"error %@", error);
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext
{
    
    
    if (data) {
        Byte receiveBuffer[1024];
        [data getBytes:receiveBuffer length:1024];
        
        if(receiveBuffer[0]==1){
            NSString *host = nil;
            uint16_t port = 0;
            [GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
            
            int contactId = *(int*)(&receiveBuffer[16]);
            int type = *(int*)(&receiveBuffer[20]);
            int flag = *(int*)(&receiveBuffer[24]);
            DLog(@"%i:%i:%i",contactId,type,flag);
            if(self.isShowSuccessAlert){
                return;
            }
            if(self.isSendingCmd||self.isWaiting){
                self.isSendingCmd = NO;
                self.isWaiting = YES;
                self.isShowSuccessAlert = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.waitingContent setHidden:YES];
                    [self.setWifiContent setHidden:YES];
                    [self.smartKeyPromptView setHidden:YES];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"set_wifi_success_title", nil) message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil,nil];
                    alert.tag = ALERT_TAG_SET_SUCCESS;
                    [alert show];
                    [alert release];
                });
                
            }
        }
        
        
    }
    
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
