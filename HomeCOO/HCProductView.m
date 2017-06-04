//
//  HCProductView.m
//  HomeCOO
//
//  Created by app on 2016/10/19.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "HCProductView.h"
#import "LZXDataCenter.h"
#define daterConterViewWidth  [UIScreen  mainScreen].bounds.size.width /2.3
#define daterConterViewHeight   [UIScreen  mainScreen].bounds.size.height /2

@interface HCProductView ()<UITextFieldDelegate>{
    
    //UIView *gatewayContentView;
    UIScrollView   *gatewayContentView;
    UILabel *mainTitle;
    UILabel *secondaryTitle;
    UILabel *thirdTitle;
    UILabel *fourthTitle;
    
    UITextField *secondaryField;
    UIButton *thirdButton;
    
    
    UILabel *outdoorTitle;
    UILabel *indoorTitle;
    
    UIButton *outdoorBtn;
    UIButton *indoorBtn;
    
    UIButton *cancelBtn;
    UIButton *sureBtn;
    
}
@end

@implementation HCProductView
#pragma mark - init初始化
- (void)initViews{
    self.frame=[UIScreen mainScreen].bounds;
    self.backgroundColor=RGBA(0, 0, 0, 0.3);
    
    gatewayContentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,daterConterViewWidth , daterConterViewHeight)];
    gatewayContentView.scrollEnabled  =NO;
    gatewayContentView.userInteractionEnabled = YES;
    gatewayContentView.center = self.center;
    
    [self addSubview:gatewayContentView];
    gatewayContentView.layer.masksToBounds=YES;
    gatewayContentView.layer.cornerRadius=8;
    gatewayContentView.backgroundColor = [UIColor whiteColor];
    
    mainTitle=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, gatewayContentView.w, daterConterViewHeight/5)];
    
    mainTitle.backgroundColor = [UIColor grayColor];
    
    mainTitle.font= [UIFont systemFontOfSize:14];
    mainTitle.textColor = [UIColor whiteColor];
    
    mainTitle.textAlignment=1;
    self.mainTitle = mainTitle;
    
    [gatewayContentView addSubview:mainTitle];
    
    
    secondaryTitle =[[UILabel alloc]initWithFrame:CGRectMake(0, mainTitle.h, gatewayContentView.w/4, daterConterViewHeight/5)];
    
    secondaryTitle.backgroundColor = [UIColor whiteColor];
    
    
    if ([UIScreen  mainScreen].bounds.size.width == 568) {
        secondaryTitle.font= [UIFont systemFontOfSize:12];
    }else{
        
        secondaryTitle.font= [UIFont systemFontOfSize:14];
    }
    secondaryTitle.layer.borderColor = [UIColor grayColor].CGColor;//边框颜色,要为CGColor
    secondaryTitle.layer.borderWidth = 0.2f;//边框宽度
    
    secondaryTitle.textColor = [UIColor blackColor];
    secondaryTitle.textAlignment=1;
    self.secondaryTitle = secondaryTitle;
    
    secondaryField = [[UITextField alloc]initWithFrame:CGRectMake(secondaryTitle.w, mainTitle.h, gatewayContentView.w-secondaryTitle.w, daterConterViewHeight/5)];
    secondaryField.backgroundColor = [UIColor  whiteColor];
    secondaryField.textColor = [UIColor blackColor];
    secondaryField.font = [UIFont  systemFontOfSize:14];
    secondaryField.layer.borderColor=[[UIColor grayColor]CGColor];
    secondaryField.delegate = self;
    secondaryField.layer.borderWidth= 0.5;
    secondaryField.layer.masksToBounds = YES;
    secondaryField.layer.cornerRadius = 8.0f;
    secondaryField.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    secondaryField.leftView = paddingView;
    secondaryField.leftViewMode = UITextFieldViewModeAlways;
    self.secondaryField = secondaryField;
    
    [gatewayContentView addSubview:secondaryField];
    [gatewayContentView addSubview:secondaryTitle];
    
    thirdTitle =[[UILabel alloc]initWithFrame:CGRectMake(0, mainTitle.h*2, gatewayContentView.w/4, daterConterViewHeight/5)];
    
    thirdTitle.backgroundColor = [UIColor whiteColor];
    if ([UIScreen  mainScreen].bounds.size.width == 568) {
        thirdTitle.font= [UIFont systemFontOfSize:12];
    }else{
        
        thirdTitle.font= [UIFont systemFontOfSize:14];
    }
    
    thirdTitle.textColor = [UIColor blackColor];
    thirdTitle.layer.borderColor = [UIColor grayColor].CGColor;//边框颜色,要为CGColor
    thirdTitle.layer.borderWidth = 0.2f;//边框宽度
    
    thirdTitle.textAlignment=1;
    self.thirdTitle = thirdTitle;
    
    thirdButton = [UIButton buttonWithType:UIButtonTypeCustom];
    thirdButton.frame = CGRectMake(thirdTitle.w, mainTitle.h*2, gatewayContentView.w-thirdTitle.w, daterConterViewHeight/5);
    [thirdButton setTitle:@"位置待定" forState:UIControlStateNormal];
    [thirdButton addTarget:self action:@selector(postionAction:) forControlEvents:UIControlEventTouchUpInside];
    thirdButton.backgroundColor = [UIColor  grayColor];
    if ([UIScreen  mainScreen].bounds.size.width == 568) {
        
       thirdButton.titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:12];
    }else{
        
       thirdButton.titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:14];
    }
    
    [thirdButton.layer setMasksToBounds:YES];
    [thirdButton.layer setCornerRadius:8.0];
   // [thirdButton setTitle:[NSString  stringWithFormat:@"位置待定"] forState:UIControlStateNormal];
    
    self.thirdButton = thirdButton;
    [gatewayContentView addSubview:thirdButton];
    
    [gatewayContentView addSubview:thirdTitle];
    
    fourthTitle =[[UILabel alloc]initWithFrame:CGRectMake(0, mainTitle.h*3, gatewayContentView.w/4, daterConterViewHeight/5)];
    
    fourthTitle.backgroundColor = [UIColor whiteColor];
    

    if ([UIScreen  mainScreen].bounds.size.width == 568) {
        fourthTitle.font= [UIFont systemFontOfSize:12];
    }else{
        
        fourthTitle.font= [UIFont systemFontOfSize:14];
    }
    //fourthTitle.layer.borderColor = [UIColor grayColor].CGColor;//边框颜色,要为CGColor
    //fourthTitle.layer.borderWidth = 0.2f;//边框宽度
    
    fourthTitle.textColor = [UIColor blackColor];
    
    fourthTitle.textAlignment=1;
    self.fourthTitle = fourthTitle;
    
    [gatewayContentView addSubview:fourthTitle];
    
    outdoorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    outdoorBtn.frame = CGRectMake(secondaryTitle.w, mainTitle.h*3, (gatewayContentView.w-secondaryTitle.w)/4, mainTitle.h);
    //[outdoorBtn setTitle:@"室外" forState:UIControlStateNormal];
    [outdoorBtn addTarget:self action:@selector(CheckButton:) forControlEvents:UIControlEventTouchUpInside];
    outdoorBtn.backgroundColor=[UIColor clearColor];
    [outdoorBtn  setImage:[UIImage  imageNamed:@"outdoor.png"] forState:UIControlStateNormal];
    [outdoorBtn  setImage:[UIImage  imageNamed:@"indoor.png"] forState:UIControlStateDisabled];
    outdoorBtn.tag = 100;
    self.outdoorBtn = outdoorBtn;
    [gatewayContentView addSubview:outdoorBtn];
    
    outdoorTitle= [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(outdoorBtn.frame), mainTitle.h*3, (gatewayContentView.w-secondaryTitle.w)/4, daterConterViewHeight/5)];
    outdoorTitle.backgroundColor = [UIColor  clearColor];
    outdoorTitle.textColor = [UIColor blackColor];
    outdoorTitle.font = [UIFont  systemFontOfSize:14];
    outdoorTitle.textAlignment=1;
    self.outdoorTitle = outdoorTitle;
    
    [gatewayContentView addSubview:outdoorTitle];
   
    indoorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    indoorBtn.frame = CGRectMake(CGRectGetMaxX(outdoorTitle.frame), mainTitle.h*3, (gatewayContentView.w-secondaryTitle.w)/4, mainTitle.h);
    //[indoorBtn setTitle:@"室内" forState:UIControlStateNormal];
    indoorBtn.backgroundColor=[UIColor clearColor];
    [indoorBtn  setImage:[UIImage  imageNamed:@"outdoor.png"] forState:UIControlStateNormal];
    [indoorBtn  setImage:[UIImage  imageNamed:@"indoor.png"] forState:UIControlStateDisabled];
    
    [indoorBtn addTarget:self action:@selector(CheckButton:) forControlEvents:UIControlEventTouchUpInside];
    indoorBtn.tag = 200;
    self.indoorBtn = indoorBtn;
    [gatewayContentView addSubview:indoorBtn];
    
    
    indoorTitle= [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(indoorBtn.frame), mainTitle.h*3, (gatewayContentView.w-secondaryTitle.w)/4, daterConterViewHeight/5)];
    indoorTitle.backgroundColor = [UIColor  clearColor];
    indoorTitle.textColor = [UIColor blackColor];
    indoorTitle.font = [UIFont  systemFontOfSize:14];
    indoorTitle.textAlignment=1;
    self.indoorTitle = indoorTitle;
    
    [gatewayContentView addSubview:indoorTitle];
    

    cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, mainTitle.h*4, gatewayContentView.frame.size.width/2, mainTitle.h);
    [cancelBtn setTitle:@"取 消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    self.cancleBtn = cancelBtn;
    [gatewayContentView addSubview:cancelBtn];
    
    cancelBtn.backgroundColor=[UIColor lightGrayColor];
    
    sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(CGRectGetMaxX(cancelBtn.frame), mainTitle.h*4, gatewayContentView.frame.size.width/2, mainTitle.h);
    [sureBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    self.sureBtn = sureBtn;
    [gatewayContentView addSubview:sureBtn];
    sureBtn.backgroundColor=[UIColor lightGrayColor];
    
    [self registerKeyBoardNotification];
    
}


- (void)registerKeyBoardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBoardAction:) name:UIKeyboardWillShowNotification object:nil];
    
}

- (void)handleKeyBoardAction:(NSNotification *)notification {
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSInteger keyBoardHeight = keyboardRect.size.height;
    self.keyBoardHeight = keyBoardHeight;
    
}
- (instancetype)initWithFrame:(CGRect)frame{
    
    self=[super initWithFrame:frame];
    if (self) {
        
        [self initViews];
        
    }
    return self;
}


#pragma mark - UITextFieldDelegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    CGPoint offset =  CGPointMake(0.0f, 0.0f);
    
    [gatewayContentView setContentOffset:offset animated:YES];
    
    
    return YES;
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)),  dispatch_get_main_queue(), ^{
        
        NSInteger key = [UIScreen  mainScreen].bounds.size.height - CGRectGetMaxY(textField.frame)-CGRectGetMinY(gatewayContentView.frame);
        
        NSInteger keyBounds = self.keyBoardHeight -key  ;
        
        
        //    NSLog(@" gatewayContentView = %f  keyBounds = %ld  key = %ld  textField.frame =  %f  self.keyBoardHeight = %ld  "  ,CGRectGetMinY(gatewayContentView.frame),(long)keyBounds,(long)key,CGRectGetMaxY(textField.frame),(long)self.keyBoardHeight);
        
        if (keyBounds<0) {//不做处理
            
        }else{
            CGPoint offset =  CGPointMake(0.0f, keyBounds);
            [gatewayContentView setContentOffset:offset animated:YES];
        }
        
    });
    
}
#pragma mark - Public Methods
- (void)showView:(UIView *)aView animated:(BOOL)animated{
    [aView addSubview:self];
    if (animated) {
        [self fadeIn];
    }
}

-(void)hiddenView:(UIView *)aView animated:(BOOL)animated{
    
    if (animated) {
        [self fadeOut];
    }
    
}



#pragma mark - Private Methods
- (void)fadeIn{
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
    }];
    
}
- (void)fadeOut{
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 0.0;
    }completion:^(BOOL finished) {
        if (finished){
            [self removeFromSuperview];
        }
    }];
}


#pragma mark - delegate

- (void)CheckButton:(UIButton *)btn{
    
    //待解决的问题
    LZXDataCenter *dataCenter = [LZXDataCenter  defaultDataCenter];
   
    
    self.indoorBtn.enabled = YES;
    self.outdoorBtn.enabled = YES;

    btn.enabled = !btn.enabled;
    
    switch (btn.tag) {
            
        case 200:
            
            dataCenter.devcieSpaceTypeID = 1;
            
            break;
            
        case 100:
            
            dataCenter.devcieSpaceTypeID = 2;
            
            break;
            
    }
    
}

- (void)sureAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(makeSureViewClicked:)]) {
        
        [self.delegate makeSureViewClicked:self];
    }
    
    [self fadeOut];
}
- (void)cancelAction:(UIButton *)sender{
    [self fadeOut];
}

- (void)postionAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(postionViewClicked:)]) {
        
        [self.delegate postionViewClicked:self];
    }
    
    
}



@end
@implementation UIView (Category)

#pragma mark-- setter,getter方法(深度赋值，取值)--

- (void) setX:(CGFloat)x{
    CGRect frame=self.frame;
    frame=CGRectMake(x, frame.origin.y, frame.size.width, frame.size.height);
    self.frame=frame;
}
- (CGFloat)x{
    return self.frame.origin.x;
}
- (void) setY:(CGFloat)y{
    CGRect frame=self.frame;
    frame=CGRectMake(frame.origin.x, y, frame.size.width, frame.size.height);
    self.frame=frame;
}
- (CGFloat)y{
    return self.frame.origin.y;
}
- (void) setW:(CGFloat)w{
    CGRect frame=self.frame;
    frame=CGRectMake(frame.origin.x, frame.origin.y, w, frame.size.height);
    self.frame=frame;
}
- (CGFloat)w{
    return self.frame.size.width;
}
- (void) setH:(CGFloat)h{
    CGRect frame=self.frame;
    frame=CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, h);
    self.frame=frame;
}
- (CGFloat)h{
    return self.frame.size.height;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
