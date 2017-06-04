//
//  P2PTimeSettingCell.m
//  2cu
//
//  Created by guojunyi on 14-5-14.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import "P2PSettingCell.h"
#import "Constants.h"
@implementation P2PSettingCell
-(void)dealloc{
    [self.leftLabelText release];
    [self.leftLabelView release];
    [self.rightLabelText release];
    [self.rightLabelView release];
    [self.customView release];
    [self.progressView release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#define LEFT_LABEL_WIDTH 150
#define PROGRESS_WIDTH_HEIGHT 32
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat cellWidth = self.backgroundView.frame.size.width;
    CGFloat cellHeight = self.backgroundView.frame.size.height;
    
    if(!self.leftLabelView){
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, LEFT_LABEL_WIDTH, BAR_BUTTON_HEIGHT)];
        textLabel.textAlignment = NSTextAlignmentLeft;
        textLabel.textColor = XBlack;
        textLabel.backgroundColor = XBGAlpha;
        [textLabel setFont:XFontBold_16];
        textLabel.text = self.leftLabelText;
        [self.contentView addSubview:textLabel];
        self.leftLabelView = textLabel;
     //   [textLabel release];
        [self.leftLabelView setHidden:self.isLeftLabelHidden];
    }else{
        self.leftLabelView.frame = CGRectMake(30, 0, LEFT_LABEL_WIDTH, BAR_BUTTON_HEIGHT);
        self.leftLabelView.textAlignment = NSTextAlignmentLeft;
        self.leftLabelView.textColor = XBlack;
        self.leftLabelView.backgroundColor = XBGAlpha;
        [self.leftLabelView setFont:XFontBold_16];
        self.leftLabelView.text = self.leftLabelText;
        [self.contentView addSubview:self.leftLabelView];
        [self.leftLabelView setHidden:self.isLeftLabelHidden];
    }
    
    
    if(!self.rightLabelView){
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(30+LEFT_LABEL_WIDTH, 0, cellWidth-30*2-LEFT_LABEL_WIDTH, BAR_BUTTON_HEIGHT)];
        textLabel.textAlignment = NSTextAlignmentRight;
        textLabel.textColor = XBlue;
        textLabel.backgroundColor = XBGAlpha;
        [textLabel setFont:XFontBold_14];
        textLabel.text = self.rightLabelText;
        [self.contentView addSubview:textLabel];
        self.rightLabelView = textLabel;
       // [textLabel release];
        [self.rightLabelView setHidden:self.isRightLabelHidden];
    }else{
        self.rightLabelView.frame = CGRectMake(30+LEFT_LABEL_WIDTH, 0, cellWidth-30*2-LEFT_LABEL_WIDTH, BAR_BUTTON_HEIGHT);
        self.rightLabelView.textAlignment = NSTextAlignmentRight;
        self.rightLabelView.textColor = XBlue;
        self.rightLabelView.backgroundColor = XBGAlpha;
        [self.rightLabelView setFont:XFontBold_14];
        self.rightLabelView.text = self.rightLabelText;
        [self.contentView addSubview:self.rightLabelView];
        [self.rightLabelView setHidden:self.isRightLabelHidden];
    }
    
    if(!self.customView){
        DLog(@"%f %f",cellWidth,cellHeight);
        UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(30,5, cellWidth-30*2, cellHeight-5*2)];
        self.customView = customView;
      //  [customView release];
        [self.contentView addSubview:self.customView];
        
        [self.customView setHidden:self.isCustomViewHidden];
    }else{
        
        self.customView.frame = CGRectMake(30,5, cellWidth-30*2, cellHeight-5*2);
        [self.contentView addSubview:self.customView];
        
        [self.customView setHidden:self.isCustomViewHidden];
        
    }
    if(!self.isProgressViewHidden){
        if(!self.progressView){
            UIActivityIndicatorView *progressView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            progressView.frame = CGRectMake(cellWidth-30-PROGRESS_WIDTH_HEIGHT, (cellHeight-PROGRESS_WIDTH_HEIGHT)/2, PROGRESS_WIDTH_HEIGHT, PROGRESS_WIDTH_HEIGHT);
            [self.contentView addSubview:progressView];
            [progressView startAnimating];
            self.progressView = progressView;
            //[progressView release];
            [self.progressView setHidden:self.isProgressViewHidden];
        }else{
            self.progressView.frame = CGRectMake(cellWidth-30-PROGRESS_WIDTH_HEIGHT, (cellHeight-PROGRESS_WIDTH_HEIGHT)/2, PROGRESS_WIDTH_HEIGHT, PROGRESS_WIDTH_HEIGHT);
            [self.contentView addSubview:self.progressView];
            [self.progressView startAnimating];
            [self.progressView setHidden:self.isProgressViewHidden];
        }
    }else{
        [self.progressView removeFromSuperview];
        self.progressView = nil;
    }
    
}

-(void)setProgressViewHidden:(BOOL)hidden{
    self.isProgressViewHidden = hidden;
    if(self.progressView){
        [self.progressView setHidden:hidden];
    }
}

-(void)setLeftLabelHidden:(BOOL)hidden{
    self.isLeftLabelHidden = hidden;
    if(self.leftLabelView){
        [self.leftLabelView setHidden:hidden];
    }
}

-(void)setRightLabelHidden:(BOOL)hidden{
    self.isRightLabelHidden = hidden;
    if(self.rightLabelView){
        [self.rightLabelView setHidden:hidden];
    }
}

-(void)setCustomViewHidden:(BOOL)hidden{
    self.isCustomViewHidden = hidden;
    if(self.customView){
        [self.customView setHidden:hidden];
    }
}

-(void)fill{
    if (_isOpen == NO) {
        _isOpen = YES;
        
        CGRect rec = [UIScreen mainScreen].bounds;
        UITextField *old = [[UITextField alloc]initWithFrame:CGRectMake(50, 60, rec.size.width - 100, 28)];
        old.layer.borderColor = [[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor];
        old.layer.cornerRadius = 1.0;
        old.textAlignment = NSTextAlignmentLeft;
        
        old.placeholder = NSLocalizedString(@"input_original_password", nil);
        old.borderStyle = UITextBorderStyleRoundedRect;
        old.returnKeyType = UIReturnKeyDone;
        old.secureTextEntry = YES;
        old.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        old.autocapitalizationType = UITextAutocapitalizationTypeNone;
        old.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.contentView addSubview:old];
        _oldpassword = old;
        //[old release];
        
        UITextField *new = [[UITextField alloc]initWithFrame:CGRectMake(50, 95, rec.size.width - 100, 28)];
        new.layer.borderColor = [[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor];
        new.layer.cornerRadius = 1.0;
        new.textAlignment = NSTextAlignmentLeft;
        
        new.placeholder = NSLocalizedString(@"input_new_password", nil);
        new.borderStyle = UITextBorderStyleRoundedRect;
        new.returnKeyType = UIReturnKeyDone;
        new.secureTextEntry = YES;
        new.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        new.autocapitalizationType = UITextAutocapitalizationTypeNone;
        new.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.contentView addSubview:new];
        _newpassword = new;
       // [new release];
        
        UITextField *re = [[UITextField alloc]initWithFrame:CGRectMake(50, 130, rec.size.width - 100, 28)];
        re.layer.borderColor = [[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor];
        re.layer.cornerRadius = 1.0;
        re.textAlignment = NSTextAlignmentLeft;
        
        re.placeholder = NSLocalizedString(@"confirm_input", nil);
        re.borderStyle = UITextBorderStyleRoundedRect;
        re.returnKeyType = UIReturnKeyDone;
        re.secureTextEntry = YES;
        re.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        re.autocapitalizationType = UITextAutocapitalizationTypeNone;
        re.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.contentView addSubview:re];
        _repassword = re;
       // [re release];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(130, 165, rec.size.width - 260, 28)];
        button.layer.cornerRadius = 3.5;
        [button setTitle:@"修改" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor blueColor];
        [self.contentView addSubview:button];
        _savebutton = button;
       // [button release];
        
        NSLog(@"this is fill1 ");
    }
}
//关闭打开隐藏的控件
-(void)openHidden{
    _oldpassword.hidden = YES;
    _newpassword.hidden = YES;
    _repassword.hidden = YES;
    _savebutton.hidden = YES;
    NSLog(@"this is open1 ");
}
-(void)closeHidden{
    
    _oldpassword.hidden = NO;
    _newpassword.hidden = NO;
    _repassword.hidden = NO;
    _savebutton.hidden = NO;
    NSLog(@"this is close1 ");
}

-(void)fill2{
    if (_isOpen2 == NO) {
        _isOpen2 = YES;
        
        CGRect rec = [UIScreen mainScreen].bounds;
        UITextField *old = [[UITextField alloc]initWithFrame:CGRectMake(50, 60, rec.size.width - 100, 28)];
        old.layer.borderColor = [[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor];
        old.layer.cornerRadius = 1.0;
        old.textAlignment = NSTextAlignmentLeft;
        
        old.placeholder = NSLocalizedString(@"input_original_password", nil);
        old.borderStyle = UITextBorderStyleRoundedRect;
        old.returnKeyType = UIReturnKeyDone;
        old.secureTextEntry = YES;
        old.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        old.autocapitalizationType = UITextAutocapitalizationTypeNone;
        old.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.contentView addSubview:old];
        _password = old;
       // [old release];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(130, 100, rec.size.width - 260, 28)];
        button.layer.cornerRadius = 3.5;
        [button setTitle:@"修改" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor blueColor];
        [self.contentView addSubview:button];
        _button = button;
       // [button release];
        
        NSLog(@"this is fill2 ");
    }
}
//关闭打开隐藏的控件
-(void)openHidden2{
    _password.hidden = YES;
    _button.hidden = YES;
    
    NSLog(@"this is open2 ");
}
-(void)closeHidden2{
    _password.hidden = NO;
    _button.hidden = NO;
    
    NSLog(@"this is close2 ");
}

@end
