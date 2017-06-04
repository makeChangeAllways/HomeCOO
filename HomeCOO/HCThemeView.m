//
//  HCThemeView.m
//  HomeCOO
//
//  Created by app on 2016/10/20.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "HCThemeView.h"
#define daterConterViewWidth  [UIScreen  mainScreen].bounds.size.width /2
#define daterConterViewHeight   [UIScreen  mainScreen].bounds.size.height /1.8


@interface HCThemeView ()<UITextFieldDelegate>{
    
    //UIView *gatewayContentView;
    UIScrollView   *gatewayContentView;
    UILabel *mainTitle;
    UILabel *secondaryTitle;
    UILabel *lableDescription;
    
    UITextField *firstField;
    UITextField *secondaryField;
    UITextField *thirdField;
    UITextField *fourthField;
    
    UIButton *cancelBtn;
    UIButton *sureBtn;
    
}
@end

@implementation HCThemeView
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
    
    mainTitle=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, gatewayContentView.w, gatewayContentView.h/5)];
    
    mainTitle.backgroundColor = [UIColor grayColor];
    
    mainTitle.font= [UIFont systemFontOfSize:14];
    mainTitle.textColor = [UIColor whiteColor];
    
    mainTitle.textAlignment=1;
    self.mainTitle = mainTitle;
    
    [gatewayContentView addSubview:mainTitle];
    
    
    secondaryTitle =[[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(mainTitle.frame), gatewayContentView.w-5, mainTitle.h)];
    
    secondaryTitle.backgroundColor = [UIColor whiteColor];
    
    secondaryTitle.text = @"情景名称 :";
    if ([UIScreen  mainScreen].bounds.size.width == 568) {
        secondaryTitle.font= [UIFont systemFontOfSize:12];
    }else{
        
        secondaryTitle.font= [UIFont systemFontOfSize:14];
    }
    //secondaryTitle.layer.borderColor = [UIColor grayColor].CGColor;//边框颜色,要为CGColor
    //secondaryTitle.layer.borderWidth = 0.2f;//边框宽度
    
    secondaryTitle.textColor = [UIColor blackColor];
    secondaryTitle.textAlignment=0;
    self.secondaryTitle = secondaryTitle;
    
    [gatewayContentView addSubview:secondaryTitle];
    
    firstField =[[UITextField alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(secondaryTitle.frame), gatewayContentView.w/4, mainTitle.h)];
    
    firstField.backgroundColor = [UIColor whiteColor];
    if ([UIScreen  mainScreen].bounds.size.width == 568) {
        firstField.font= [UIFont systemFontOfSize:12];
    }else{
        
        firstField.font= [UIFont systemFontOfSize:14];
    }
    
    firstField.textColor = [UIColor blackColor];
    firstField.layer.cornerRadius = 8.0f;
    firstField.layer.borderColor = [UIColor grayColor].CGColor;//边框颜色,要为CGColor
    firstField.layer.borderWidth = 0.2f;//边框宽度
    firstField.delegate = self;
    firstField.textAlignment=1;
    firstField.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    firstField.leftView = paddingView1;
    firstField.leftViewMode = UITextFieldViewModeAlways;
    self.firstField = firstField;
    [gatewayContentView  addSubview:firstField];
    
    
    secondaryField =[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(firstField.frame), CGRectGetMaxY(secondaryTitle.frame), gatewayContentView.w/4, mainTitle.h)];
    
    secondaryField.backgroundColor = [UIColor whiteColor];
    if ([UIScreen  mainScreen].bounds.size.width == 568) {
        secondaryField.font= [UIFont systemFontOfSize:12];
    }else{
        
        secondaryField.font= [UIFont systemFontOfSize:14];
    }
    
    secondaryField.textColor = [UIColor blackColor];
    secondaryField.layer.cornerRadius = 8.0f;
    secondaryField.layer.borderColor = [UIColor grayColor].CGColor;//边框颜色,要为CGColor
    secondaryField.layer.borderWidth = 0.2f;//边框宽度
    secondaryField.delegate = self;
    secondaryField.textAlignment=1;
    secondaryField.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    secondaryField.leftView = paddingView2;
    secondaryField.leftViewMode = UITextFieldViewModeAlways;
    self.secondaryField = secondaryField;
    [gatewayContentView  addSubview:secondaryField];
    
    thirdField =[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(secondaryField.frame), CGRectGetMaxY(secondaryTitle.frame), gatewayContentView.w/4, mainTitle.h)];
    
    thirdField.backgroundColor = [UIColor whiteColor];
    if ([UIScreen  mainScreen].bounds.size.width == 568) {
        thirdField.font= [UIFont systemFontOfSize:12];
    }else{
        
        thirdField.font= [UIFont systemFontOfSize:14];
    }
    
    thirdField.textColor = [UIColor blackColor];
    thirdField.layer.cornerRadius = 8.0f;
    thirdField.layer.borderColor = [UIColor grayColor].CGColor;//边框颜色,要为CGColor
    thirdField.layer.borderWidth = 0.2f;//边框宽度
    thirdField.delegate = self;
    thirdField.textAlignment=1;
    thirdField.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    thirdField.leftView = paddingView3;
    thirdField.leftViewMode = UITextFieldViewModeAlways;
    self.thirdField = thirdField;
    [gatewayContentView  addSubview:thirdField];
    
    fourthField =[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(thirdField.frame), CGRectGetMaxY(secondaryTitle.frame), gatewayContentView.w/4, mainTitle.h)];
    
    fourthField.backgroundColor = [UIColor whiteColor];
    if ([UIScreen  mainScreen].bounds.size.width == 568) {
        fourthField.font= [UIFont systemFontOfSize:12];
    }else{
        
        fourthField.font= [UIFont systemFontOfSize:14];
    }
    
    fourthField.textColor = [UIColor blackColor];
    fourthField.layer.cornerRadius = 8.0f;
    fourthField.layer.borderColor = [UIColor grayColor].CGColor;//边框颜色,要为CGColor
    fourthField.layer.borderWidth = 0.2f;//边框宽度
    fourthField.delegate = self;
    fourthField.textAlignment=1;
    fourthField.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIView *paddingView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    fourthField.leftView = paddingView4;
    fourthField.leftViewMode = UITextFieldViewModeAlways;
    self.fourthField = fourthField;
    [gatewayContentView  addSubview:fourthField];
    
    lableDescription =[[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(fourthField.frame), gatewayContentView.w-5, mainTitle.h)];
    
    lableDescription.backgroundColor = [UIColor whiteColor];
    
    lableDescription.text = @"说明:请按硬件情景开关上的顺序，依次输入情景名称!!!";
    if ([UIScreen  mainScreen].bounds.size.width == 568) {
        
        lableDescription.font= [UIFont systemFontOfSize:10];
        
    }else{
        
        lableDescription.font= [UIFont systemFontOfSize:12];
    }
    
    lableDescription.textColor = [UIColor blueColor];
    lableDescription.textAlignment=0;
   
    [gatewayContentView addSubview:lableDescription];
    

    cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, CGRectGetMaxY(lableDescription.frame), gatewayContentView.frame.size.width/2, mainTitle.h);
    [cancelBtn setTitle:@"取 消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    self.cancleBtn = cancelBtn;
    [gatewayContentView addSubview:cancelBtn];
    
    cancelBtn.backgroundColor=[UIColor lightGrayColor];
    
    sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(CGRectGetMaxX(cancelBtn.frame), CGRectGetMaxY(lableDescription.frame), gatewayContentView.frame.size.width/2, mainTitle.h);
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
- (void)sureAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(makeSureThemeViewClicked:)]) {
        
        [self.delegate makeSureThemeViewClicked:self];
    }
    
    [self fadeOut];
}
- (void)cancelAction:(UIButton *)sender{
    [self fadeOut];
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
