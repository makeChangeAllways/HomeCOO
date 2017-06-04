//
//  ContactCell.m
//  2cu
//
//  Created by guojunyi on 14-4-12.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import "ContactCell.h"
#import "Utils.h"
#import "Constants.h"
#import "Contact.h"
#import "P2PClient.h"
#import "FListManager.h"

@implementation ContactCell

-(void)dealloc{
    [self.headView release];
    [self.typeView release];
    [self.nameLabel release];
    [self.stateLabel release];
    [self.contact release];
    [self.messageCountView release];
    [self.defenceStateView release];
    [super dealloc];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#define CONTACT_HEADER_VIEW_MARGIN 6
#define CONTACT_TYPE_ICON_WIDTH_AND_HEIGHT 16
#define CONTACT_STATE_LABEL_WIDTH 50
#define MESSAHE_COUNT_VIEW_WIDTH_AND_HEIGHT 24
#define HEADER_ICON_VIEW_HEIGHT_WIDTH 50
#define DEFENCE_STATE_VIEW_WIDTH_HEIGHT 24
-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat width = self.backgroundView.frame.size.width;
    CGFloat height = self.backgroundView.frame.size.height-25;
    
    if (self.contact.onLineState==STATE_ONLINE) {
        self.headIconView.image = [UIImage imageNamed:@"equipment_suspended"];
    }else{
        self.headIconView.image = [UIImage imageNamed:@"equipment_no"];
    }
    if(self.contact.contactType==CONTACT_TYPE_UNKNOWN||self.contact.contactType==CONTACT_TYPE_PHONE){
        [self.headIconView setHidden:YES];
    }else{
        [self.headIconView setHidden:NO];
    }
    
    NSString *filePath = [Utils getHeaderFilePathWithId:self.contact.contactId];
    
    UIImage *headImg = [UIImage imageWithContentsOfFile:filePath];
    if(headImg==nil){
        headImg = [UIImage imageNamed:@"bgImageBig.jpg"];
    }
//    headImg = [headImg stretchableImageWithLeftCapWidth:headImg.size.width*0.5 topCapHeight:headImg.size.height*0.5];
    self.headimageView.image = headImg;
   
    
    if(!self.typeView){
        UIImageView *typeView = [[UIImageView alloc] initWithFrame:CGRectMake(self.headView.frame.origin.x+self.headView.frame.size.width+CONTACT_HEADER_VIEW_MARGIN, height/2+CONTACT_HEADER_VIEW_MARGIN, CONTACT_TYPE_ICON_WIDTH_AND_HEIGHT, CONTACT_TYPE_ICON_WIDTH_AND_HEIGHT)];
        if(self.contact.contactType==CONTACT_TYPE_NPC){
            UIImage *typeImg = [UIImage imageNamed:@"ic_contact_type_npc.png"];
            typeView.image = typeImg;
        }else if(self.contact.contactType==CONTACT_TYPE_IPC){
            UIImage *typeImg = [UIImage imageNamed:@"ic_contact_type_ipc.png"];
            typeView.image = typeImg;
        }if(self.contact.contactType==CONTACT_TYPE_PHONE){
            UIImage *typeImg = [UIImage imageNamed:@"ic_contact_type_phone.png"];
            typeView.image = typeImg;
        }if(self.contact.contactType==CONTACT_TYPE_UNKNOWN){
            UIImage *typeImg = [UIImage imageNamed:@"ic_contact_type_unknown.png"];
            typeView.image = typeImg;
        }
        
        
        [self.contentView addSubview:typeView];
        self.typeView = typeView;

    }else{
        self.typeView.frame = CGRectMake(self.headView.frame.origin.x+self.headView.frame.size.width+CONTACT_HEADER_VIEW_MARGIN, height/2+CONTACT_HEADER_VIEW_MARGIN, CONTACT_TYPE_ICON_WIDTH_AND_HEIGHT, CONTACT_TYPE_ICON_WIDTH_AND_HEIGHT);
       
        if(self.contact.contactType==CONTACT_TYPE_NPC){
            UIImage *typeImg = [UIImage imageNamed:@"ic_contact_type_npc.png"];
            self.typeView.image = typeImg;
        }else if(self.contact.contactType==CONTACT_TYPE_IPC){
            UIImage *typeImg = [UIImage imageNamed:@"ic_contact_type_ipc.png"];
            self.typeView.image = typeImg;
        }if(self.contact.contactType==CONTACT_TYPE_PHONE){
            UIImage *typeImg = [UIImage imageNamed:@"ic_contact_type_phone.png"];
            self.typeView.image = typeImg;
        }if(self.contact.contactType==CONTACT_TYPE_UNKNOWN){
            UIImage *typeImg = [UIImage imageNamed:@"ic_contact_type_unknown.png"];
            self.typeView.image = typeImg;
        }
        
        [self.contentView addSubview:self.typeView];
        self.typeView.hidden=YES;
    }
    
    if(!self.stateLabel){
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.typeView.frame.origin.x+self.typeView.frame.size.width+5,self.typeView.frame.origin.y,width-5-CONTACT_HEADER_VIEW_MARGIN*2-self.typeView.frame.size.width-self.headView.frame.size.width,20)];
        
        textLabel.textAlignment = NSTextAlignmentLeft;
        textLabel.backgroundColor = XBGAlpha;
        [textLabel setFont:XFontBold_14];
        if(self.contact.onLineState==STATE_ONLINE){
            
            textLabel.textColor = XBlue;
            textLabel.text = NSLocalizedString(@"online", nil);
        }else{
            textLabel.textColor = XBlack;
            textLabel.text = NSLocalizedString(@"offline", nil);
        }
        [self.contentView addSubview:textLabel];
        self.stateLabel = textLabel;
        self.stateLabel.hidden=YES;
        [textLabel release];
    }else{
        self.stateLabel.frame = CGRectMake(self.typeView.frame.origin.x+self.typeView.frame.size.width+5,self.typeView.frame.origin.y,width-5-CONTACT_HEADER_VIEW_MARGIN*2-self.typeView.frame.size.width-self.headView.frame.size.width,20);
        self.stateLabel.textAlignment = NSTextAlignmentLeft;
        self.stateLabel.backgroundColor = XBGAlpha;
        [self.stateLabel setFont:XFontBold_14];
        
        if(self.contact.onLineState==STATE_ONLINE){
            
            self.stateLabel.textColor = XBlue;
            self.stateLabel.text = NSLocalizedString(@"online", nil);
        }else{
            self.stateLabel.textColor = XBlack;
            self.stateLabel.text = NSLocalizedString(@"offline", nil);
        }
        
        [self.contentView addSubview:self.stateLabel];
    }
    
//    if(!self.nameLabel){
//         UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0,200,30)];
//        textLabel.textAlignment = NSTextAlignmentLeft;
//        textLabel.textColor = XBlack;
//        textLabel.backgroundColor = XBGAlpha;
//        [textLabel setFont:XFontBold_18];
//        
//        textLabel.text = self.contact.contactName;
//        
//        [self.contentView addSubview:textLabel];
//        self.nameLabel = textLabel;
//        [textLabel release];
//    }else{
//        self.nameLabel.frame = CGRectMake(10,0,200,30);
//        self.nameLabel.textAlignment = NSTextAlignmentLeft;
//        self.nameLabel.textColor = XBlack;
//        self.nameLabel.backgroundColor = XBGAlpha;
//        [self.nameLabel setFont:[UIFont systemFontOfSize:11]];
//        
//        self.nameLabel.text = self.contact.contactName;
//        
//        [self.contentView addSubview:self.nameLabel];
//        self.nameLabel.hidden=YES;
//    }
    
    if(!self.messageCountView){
        UIImageView *messageCountView = [[UIImageView alloc] initWithFrame:CGRectMake(self.headView.frame.origin.x+self.headView.frame.size.width, self.headView.frame.origin.y+3, MESSAHE_COUNT_VIEW_WIDTH_AND_HEIGHT, MESSAHE_COUNT_VIEW_WIDTH_AND_HEIGHT)];
        messageCountView.image = [UIImage imageNamed:@"bg_message_count.png"];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, messageCountView.frame.size.width, messageCountView.frame.size.height-5)];
        if(self.contact.messageCount>10){
            label.text = @"10+";
        }else{
           label.text = [NSString stringWithFormat:@"%i",self.contact.messageCount];
        }
        
        label.textAlignment = NSTextAlignmentCenter;
        label.font = XFontBold_12;
        label.backgroundColor = XBGAlpha;
        label.textColor = XWhite;
        [messageCountView addSubview:label];
        [label release];
        
        self.messageCountView = messageCountView;
        [self.contentView addSubview:messageCountView];
        [messageCountView release];
        
        if(self.contact.messageCount>0){
            [self.messageCountView setHidden:NO];
        }else{
            [self.messageCountView setHidden:YES];
        }
    }else{
        self.messageCountView.frame = CGRectMake(self.headView.frame.origin.x+self.headView.frame.size.width, self.headView.frame.origin.y+3, MESSAHE_COUNT_VIEW_WIDTH_AND_HEIGHT, MESSAHE_COUNT_VIEW_WIDTH_AND_HEIGHT);
        
        UILabel *label = [self.messageCountView.subviews objectAtIndex:0];
        label.frame = CGRectMake(0, 0, self.messageCountView.frame.size.width, self.messageCountView.frame.size.height-5);
        if(self.contact.messageCount>10){
            label.text = @"10+";
        }else{
            label.text = [NSString stringWithFormat:@"%i",self.contact.messageCount];
        }
        
        
        [self.contentView addSubview:self.messageCountView];
        if(self.contact.messageCount>0){
            [self.messageCountView setHidden:NO];
        }else{
            [self.messageCountView setHidden:YES];
        }
    }
    
//    // 背景条
    if(!self.cellbg){
        UIView *imagebg = [[UIView alloc] initWithFrame:CGRectMake(0, 180, VIEWWIDTH, 45)];
        
        imagebg.backgroundColor = [UIColor blackColor];
        imagebg.alpha = 0.4;
        
        
        [self.contentView addSubview:imagebg];
        self.cellbg = imagebg;
    }else{
        self.cellbg.frame = CGRectMake(0, 180, VIEWWIDTH, 45);
        self.stateLabel.backgroundColor = [UIColor grayColor];
        self.stateLabel.alpha = 0.1;
        [self.contentView addSubview:self.cellbg];
    }

    
    
    if(!self.defenceStateView){
        UIButton *defenceStateView = [UIButton buttonWithType:UIButtonTypeCustom];

       
        
        UIImageView *imageView = [[UIImageView alloc] init];
        self.defenceStateImageView = imageView;

        switch(self.contact.defenceState){
            case DEFENCE_STATE_ON:
            {
                imageView.image = [UIImage imageNamed:@"equipment_lock"];
            }
                break;
                
            case DEFENCE_STATE_OFF:
            {
                imageView.image = [UIImage imageNamed:@"video_lock"];
            }
                break;
                
            case DEFENCE_STATE_LOADING:
            {
                
            }
                break;
                
            case DEFENCE_STATE_WARNING_NET:
            {
                imageView.image = [UIImage imageNamed:@"ic_defence_warning.png"];
            }
                break;
                
            case DEFENCE_STATE_WARNING_PWD:
            {
                imageView.image = [UIImage imageNamed:@"ic_defence_warning.png"];
            }
                break;
            case DEFENCE_STATE_NO_PERMISSION:
            {
                imageView.image = [UIImage imageNamed:@"ic_defence_limit.png"];
            }
                break;
        }
        
        
        [defenceStateView addSubview:imageView];
        [imageView release];
        self.defenceStateView = defenceStateView;
        [self.contentView addSubview:self.defenceStateView];
        
        
    }else{
        UIImageView *imageView = self.defenceStateImageView;

        switch(self.contact.defenceState){
            case DEFENCE_STATE_ON:
            {
                imageView.image = [UIImage imageNamed:@"equipment_lock"];
            }
                break;
                
            case DEFENCE_STATE_OFF:
            {
                imageView.image = [UIImage imageNamed:@"video_lock"];
            }
                break;
                
            case DEFENCE_STATE_LOADING:
            {
                
            }
                break;
                
            case DEFENCE_STATE_WARNING_NET:
            {
                imageView.image = [UIImage imageNamed:@"ic_defence_warning.png"];
            }
                break;
                
            case DEFENCE_STATE_WARNING_PWD:
            {
                imageView.image = [UIImage imageNamed:@"ic_defence_warning.png"];
            }
                break;
            case DEFENCE_STATE_NO_PERMISSION:
            {
                imageView.image = [UIImage imageNamed:@"ic_defence_limit.png"];
            }
                break;
        }
       
        [self.contentView addSubview:self.defenceStateView];
        
    }
    
    if(!self.defenceProgressView){
        
         YProgressView *progressView = [[YProgressView alloc] initWithFrame:CGRectMake(width-10-DEFENCE_STATE_VIEW_WIDTH_HEIGHT, 190, DEFENCE_STATE_VIEW_WIDTH_HEIGHT, DEFENCE_STATE_VIEW_WIDTH_HEIGHT)];
        progressView.backgroundView.image = [UIImage imageNamed:@"ic_progress_arrow.png"];
        
        self.defenceProgressView = progressView;
        [progressView release];
        [self.contentView addSubview:self.defenceProgressView];
        
        
    }else{
//        self.defenceProgressView.frame = CGRectMake(width-10-DEFENCE_STATE_VIEW_WIDTH_HEIGHT, (height-DEFENCE_STATE_VIEW_WIDTH_HEIGHT)/2, DEFENCE_STATE_VIEW_WIDTH_HEIGHT, DEFENCE_STATE_VIEW_WIDTH_HEIGHT);
        self.defenceProgressView.frame = CGRectMake(width-10-DEFENCE_STATE_VIEW_WIDTH_HEIGHT, 190, DEFENCE_STATE_VIEW_WIDTH_HEIGHT, DEFENCE_STATE_VIEW_WIDTH_HEIGHT);
        self.defenceProgressView.backgroundView.image = [UIImage imageNamed:@"ic_progress_arrow.png"];
        [self.contentView addSubview:self.defenceProgressView];
    }
    
   
    if (!self.settingBtn) {
        UIButton *setBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 190, DEFENCE_STATE_VIEW_WIDTH_HEIGHT, DEFENCE_STATE_VIEW_WIDTH_HEIGHT)];
        [setBtn setBackgroundImage:[UIImage imageNamed:@"equipment_Set"] forState:UIControlStateNormal];
        self.settingBtn = setBtn;
        [setBtn release];
        [self.contentView addSubview:setBtn];
    }else
    {
        self.settingBtn.frame = CGRectMake(10, 190, DEFENCE_STATE_VIEW_WIDTH_HEIGHT, DEFENCE_STATE_VIEW_WIDTH_HEIGHT);
        [self.settingBtn setBackgroundImage:[UIImage imageNamed:@"equipment_Set"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.settingBtn];
    }
    
    [self.settingBtn addTarget:self action:@selector(settingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    if (!self.shadow_View) {
        UIView *shadow_View = [[UIView alloc] init];
        [self addSubview:shadow_View];
        self.shadow_View = shadow_View;
        shadow_View.backgroundColor = [UIColor blackColor];
        shadow_View.alpha = 0.4;
    }else
    {
        self.shadow_View.frame = self.bounds;
        [self addSubview:self.shadow_View];
        self.shadow_View.backgroundColor = [UIColor blackColor];
        self.shadow_View.alpha = 0.4;
    }
    

    [self updateDefenceStateView];
    [self.defenceStateView addTarget:self action:@selector(onDefencePress:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)onHeadClick:(id)sender{
    DLog(@"HEAD CLICK");
    if (self.delegate) {
        
        [self.delegate onClick:self.position contact:self.contact];
        
        NSUserDefaults *user_default = [NSUserDefaults standardUserDefaults];
        [user_default setObject:self.contact.contactId forKey:@"Current_Contact"];
        [user_default synchronize];
        
    }
}

-(void)onDefencePress:(UIButton*)button{
//    UIImageView *imageView = [[button subviews] objectAtIndex:0];
    [[FListManager sharedFList] setIsClickDefenceStateBtnWithId:self.contact.contactId isClick:YES];
    if(self.contact.defenceState==DEFENCE_STATE_WARNING_NET||self.contact.defenceState==DEFENCE_STATE_WARNING_PWD){ // 其他状态
        self.contact.defenceState = DEFENCE_STATE_LOADING;
        [self updateDefenceStateView];
        
        if (self.loc) { // 有loc
            if (self.loc.flag == 0) { // 重置
                
                if (self.resetBlock) {
                    self.resetBlock(self.loc);
                }
                
            }else
            {
                [[P2PClient sharedClient] getDefenceState:self.contact.contactId password:self.contact.contactPassword];
                if (self.resetBlock) {
                    self.resetBlock(nil);
                }
            }
            
        }else
        {
        [[P2PClient sharedClient] getDefenceState:self.contact.contactId password:self.contact.contactPassword];
            if (self.resetBlock) {
                self.resetBlock(nil);
            }
        }
        
    }else if(self.contact.defenceState==DEFENCE_STATE_ON){  // 撤防
        self.contact.defenceState = DEFENCE_STATE_LOADING;
        [self updateDefenceStateView];
        [[P2PClient sharedClient] setRemoteDefenceWithId:self.contact.contactId password:self.contact.contactPassword state:SETTING_VALUE_REMOTE_DEFENCE_STATE_OFF];
        [[P2PClient sharedClient] getAlarmInfoWithId:self.contact.contactId password:self.contact.contactPassword];
    }else if(self.contact.defenceState==DEFENCE_STATE_OFF){ // 布防
        self.contact.defenceState = DEFENCE_STATE_LOADING;
        [self updateDefenceStateView];
        [[P2PClient sharedClient] setRemoteDefenceWithId:self.contact.contactId password:self.contact.contactPassword state:SETTING_VALUE_REMOTE_DEFENCE_STATE_ON];
        [[P2PClient sharedClient] getAlarmInfoWithId:self.contact.contactId password:self.contact.contactPassword];
    }else if(self.contact.defenceState==DEFENCE_STATE_NO_PERMISSION){
        [self makeToast:NSLocalizedString(@"no_permission", nil)];
    }
}


// === 修改布局错乱 ====

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIButton *headButton = [[UIButton alloc] init];
        UIImageView *headImageView = [[UIImageView alloc] init];
        NSString *filePath = [Utils getHeaderFilePathWithId:self.contact.contactId];
        
        UIImage *headImg = [UIImage imageWithContentsOfFile:filePath];
        if(headImg==nil){
            headImg = [UIImage imageNamed:@"bgImageBig.jpg"];
        }
        headImg = [headImg stretchableImageWithLeftCapWidth:headImg.size.width*0.5 topCapHeight:headImg.size.height*0.5];
        headImageView.image = headImg;
        headImageView.contentMode = UIViewContentModeScaleToFill;
        [headButton addSubview:headImageView];
        UIImageView *headIconView = [[UIImageView alloc] init];
        [headButton addSubview:headIconView];
        if(self.contact.contactType==CONTACT_TYPE_UNKNOWN||self.contact.contactType==CONTACT_TYPE_PHONE){
            [headIconView setHidden:YES];
        }else{
            [headIconView setHidden:NO];
        }
        [headIconView release];
        
        [self.contentView addSubview:headButton];
        self.headView = headButton;
        self.headimageView = headImageView;
        self.headIconView = headIconView;
        [headButton addTarget:self action:@selector(onHeadClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)setContact:(Contact *)contact
{
    _contact = contact;
    
    CGFloat width = VIEWWIDTH;
    CGFloat height = 200;
    self.headView.frame = CGRectMake(0, 30, VIEWWIDTH, 170);
    self.headimageView.frame = CGRectMake(0, 10, width, height-CONTACT_HEADER_VIEW_MARGIN*2-5);
    self.headIconView.frame = CGRectMake((width-HEADER_ICON_VIEW_HEIGHT_WIDTH)/2, 200/2 - 25, HEADER_ICON_VIEW_HEIGHT_WIDTH, HEADER_ICON_VIEW_HEIGHT_WIDTH);
    
    self.defenceStateView.frame = CGRectMake(width-DEFENCE_STATE_VIEW_WIDTH_HEIGHT-20, 225-DEFENCE_STATE_VIEW_WIDTH_HEIGHT-20, DEFENCE_STATE_VIEW_WIDTH_HEIGHT+20, DEFENCE_STATE_VIEW_WIDTH_HEIGHT+20);
    self.defenceStateImageView.frame = CGRectMake(10, 10, self.defenceStateView.frame.size.width-20, self.defenceStateView.frame.size.height-20);
    
}

// === 修改布局错乱 ====
-(void)updateDefenceStateView{
    if(self.contact.onLineState==STATE_ONLINE){
        if(self.contact.defenceState==DEFENCE_STATE_LOADING){
            [self.defenceStateView setHidden:YES];
            [self.defenceProgressView setHidden:NO];
            [self.defenceProgressView start];
            
        }else{
            [self.defenceStateView setHidden:NO];
            [self.defenceProgressView setHidden:YES];
            [self.defenceProgressView stop];
        }
        
    }else{
        [self.defenceStateView setHidden:YES];
        [self.defenceProgressView setHidden:YES];
        [self.defenceProgressView stop];
    }
    
    
    if (self.contact.onLineState == STATE_OFFLINE) {
        self.settingBtn.hidden = YES;
        self.shadow_View.hidden = NO;
        
    }else
    {
        self.shadow_View.hidden = YES;
        self.settingBtn.hidden = NO;
        NSLog(@"%d",self.contact.defenceState);
        if (self.loc) {
            if (self.loc.flag == 0) {
                self.settingBtn.userInteractionEnabled = YES;
            }else
            {
                if(self.contact.defenceState == DEFENCE_STATE_WARNING_NET){
                    self.settingBtn.userInteractionEnabled = NO;
                }else
                {
                    self.settingBtn.userInteractionEnabled = YES;
                }
            }
        }else{
        if(self.contact.defenceState == DEFENCE_STATE_WARNING_NET){
            self.settingBtn.userInteractionEnabled = NO;
        }else
        {
            self.settingBtn.userInteractionEnabled = YES;
        }
        }
    }
}

/**
 *  建议你不要看 自己重新写- 
 *  setIsClickDefenceStateBtnWithId : 设置点击的设备ID 
 *  resetBlock 弹框出重置选择框
 *  loc  LocalDevice 对象 - flag 用于判断是否初始化
 *  settingblock - 跳转设置界面 
 */
- (void)settingBtnClick
{
    
    NSLog(@"9999");
    [[FListManager sharedFList] setIsClickDefenceStateBtnWithId:self.contact.contactId isClick:YES];
    if (!self.loc) {
        if (self.contact.defenceState == DEFENCE_STATE_WARNING_PWD ) {
            [[P2PClient sharedClient] getDefenceState:self.contact.contactId password:self.contact.contactPassword];
            if (self.resetBlock) {
                self.resetBlock(nil);
            }
            return;
        }else if(self.contact.defenceState==DEFENCE_STATE_NO_PERMISSION){
            [self makeToast:NSLocalizedString(@"no_permission", nil)];
        }
    }
   
    
    if (self.loc) {
        if (self.loc.flag == 0) {
            if (self.resetBlock) {
                self.resetBlock(self.loc);
            }
        }else
        {
            if (self.contact.defenceState == DEFENCE_STATE_WARNING_PWD) {
                [[P2PClient sharedClient] getDefenceState:self.contact.contactId password:self.contact.contactPassword];
                if (self.resetBlock) {
                    self.resetBlock(nil);
                }
            }else if(self.contact.defenceState==DEFENCE_STATE_NO_PERMISSION){
                [self makeToast:NSLocalizedString(@"no_permission", nil)];
            } else
            {
                if (self.settingblock) {
                    self.settingblock();
                }
                if (self.resetBlock) {
                    self.resetBlock(nil);
                }
            }
            
        }
    }else{
        if (self.contact.defenceState == DEFENCE_STATE_WARNING_PWD) {
            [[P2PClient sharedClient] getDefenceState:self.contact.contactId password:self.contact.contactPassword];
            if (self.resetBlock) {
                self.resetBlock(nil);
            }
        }else if(self.contact.defenceState==DEFENCE_STATE_NO_PERMISSION){
            [self makeToast:NSLocalizedString(@"no_permission", nil)];
        }
        else
        {
            if (self.settingblock) {
                self.settingblock();
            }
            if (self.resetBlock) {
                self.resetBlock(nil);
            }
        }
       
        
    }
}
@end
