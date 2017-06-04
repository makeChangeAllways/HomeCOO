//
//  HSAddspaceDaterView.m
//  HomeCOO
//
//  Created by app on 2016/10/18.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "HSAddspaceDaterView.h"

#define daterConterViewWidth  [UIScreen  mainScreen].bounds.size.width /2.5
#define daterConterViewHeight   [UIScreen  mainScreen].bounds.size.height /2.2


@interface HSAddspaceDaterView ()<UITextFieldDelegate>{
    
    //UIView *gatewayContentView;
    UIScrollView   *spaceContentView;
    UILabel *mainTitle;
    UILabel *secondaryTitle;
   
    UITextField *secondaryField;
   
    UIButton *cancelBtn;
    UIButton *sureBtn;
    
}
@end

@implementation HSAddspaceDaterView
#pragma mark - init初始化
- (void)initViews{
    self.frame=[UIScreen mainScreen].bounds;
    self.backgroundColor=RGBA(0, 0, 0, 0.3);
    
    spaceContentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,daterConterViewWidth , daterConterViewHeight)];
    spaceContentView.scrollEnabled  =NO;
    spaceContentView.userInteractionEnabled = YES;
    spaceContentView.center = self.center;
    
    [self addSubview:spaceContentView];
    spaceContentView.layer.masksToBounds=YES;
    spaceContentView.layer.cornerRadius=8;
    spaceContentView.backgroundColor = [UIColor whiteColor];
    
    mainTitle=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, spaceContentView.w, daterConterViewHeight/3+6)];
    
    mainTitle.backgroundColor = [UIColor grayColor];
    
    mainTitle.font= [UIFont systemFontOfSize:14];
    mainTitle.textColor = [UIColor whiteColor];
    
    mainTitle.textAlignment=1;
    self.mainTitle = mainTitle;
    
    [spaceContentView addSubview:mainTitle];
    
    secondaryTitle =[[UILabel alloc]initWithFrame:CGRectMake(0, mainTitle.h+1, spaceContentView.w/4, daterConterViewHeight/3-2)];
    
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
    
    secondaryField = [[UITextField alloc]initWithFrame:CGRectMake(secondaryTitle.w, mainTitle.h+1, spaceContentView.w-secondaryTitle.w, daterConterViewHeight/3-2)];
    secondaryField.backgroundColor = [UIColor  whiteColor];
    secondaryField.textColor = [UIColor blackColor];
    secondaryField.font = [UIFont  systemFontOfSize:14];
    secondaryField.layer.borderColor=[[UIColor grayColor]CGColor];
    secondaryField.delegate = self;
    secondaryField.clearButtonMode = UITextFieldViewModeWhileEditing;
    secondaryField.layer.borderWidth= 0.2f;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    secondaryField.leftView = paddingView;
    secondaryField.leftViewMode = UITextFieldViewModeAlways;
    self.secondaryField = secondaryField;
    
    [spaceContentView addSubview:secondaryField];
    [spaceContentView addSubview:secondaryTitle];
    
    
    cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, mainTitle.h*2-6, spaceContentView.frame.size.width/2, mainTitle.h-4);
    [cancelBtn setTitle:@"取 消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    self.cancleBtn = cancelBtn;
    [spaceContentView addSubview:cancelBtn];
    
    cancelBtn.backgroundColor=[UIColor lightGrayColor];
    
    sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(CGRectGetMaxX(cancelBtn.frame), mainTitle.h*2-6, spaceContentView.frame.size.width/2, mainTitle.h-4);
    [sureBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    self.sureBtn = sureBtn;
    [spaceContentView addSubview:sureBtn];
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
    
    [spaceContentView setContentOffset:offset animated:YES];
    
    
    return YES;
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)),  dispatch_get_main_queue(), ^{
        
        NSInteger key = [UIScreen  mainScreen].bounds.size.height - CGRectGetMaxY(textField.frame)-CGRectGetMinY(spaceContentView.frame);
        
        NSInteger keyBounds = self.keyBoardHeight -key  ;
        
        
        //    NSLog(@" gatewayContentView = %f  keyBounds = %ld  key = %ld  textField.frame =  %f  self.keyBoardHeight = %ld  "  ,CGRectGetMinY(gatewayContentView.frame),(long)keyBounds,(long)key,CGRectGetMaxY(textField.frame),(long)self.keyBoardHeight);
        
        if (keyBounds<0) {//不做处理
            
        }else{
            CGPoint offset =  CGPointMake(0.0f, keyBounds);
            [spaceContentView setContentOffset:offset animated:YES];
        }
        
        
    });
    
}
#pragma mark - Public Methods
- (void)showGatewayView:(UIView *)aView animated:(BOOL)animated{
    [aView addSubview:self];
    if (animated) {
        [self fadeIn];
    }
}

-(void)hiddenGatewayView:(UIView *)aView animated:(BOOL)animated{
    
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(makeSureViewClicked:)]) {
        
        [self.delegate makeSureViewClicked:self];
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
