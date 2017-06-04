//
//  configureWirelessController.m
//  HomeCOO
//
//  Created by app on 16/10/6.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "configureWirelessController.h"
#import "ControlMethods.h"
#import "HCaccount.h"
#import "HCaccountTool.h"
#import "SocketManager.h"
#import "PrefixHeader.pch"
#import "MBProgressHUD+MJ.h"
#import "UIView+Extension.h"
#define HomeCOOHeight   40

#define HomeCOOEdage   30

#define HomeCOOEdage4   20

#define HomeCOOEdage3   10


@interface configureWirelessController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>
/**设置背景图片*/
@property(nonatomic,weak)  UIImageView  * fullscreenView;

/**设置导航栏*/
@property(nonatomic,weak)  UINavigationBar *navBar;

@property(nonatomic,weak) UILabel  *WhiteBackgroundLable;

@property(nonatomic,weak) UILabel  *configureLable;
@property(nonatomic,weak) UITextField  *gatewayIDField;
@property(nonatomic,weak) UITextField  *gatewaypwdField;
@property(nonatomic,weak) UITextField  *routerLableField;
@property(nonatomic,weak) UITextField  *routerPwdField;
@property(nonatomic,strong)  UIScrollView   *scrollView;
@property NSInteger keyBoardHeight;

@end

@implementation configureWirelessController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置背景
    [self setFullscreenView];
    
    //创建一个导航栏
    [self setNavBar];
    
    [self  setWhiteBackground];
    
    [self addUIScrollView];
    
    [self registerKeyBoardNotification];
    [self TapGestureRecognizer];
    
    //创建一个UITableView 控件
    [self  addTableView];
    
    [self configureHostLable];
  
    [self configureHostContents];
}

//添加点按击手势监听器 解决touch事件被uiscrollview截获
-(void)TapGestureRecognizer{
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapUiscrollView)];
    //设置手势属性
    tapGesture.delegate = self;
    tapGesture.numberOfTapsRequired=1;//设置点按次数，默认为1，注意在iOS中很少用双击操作
    tapGesture.numberOfTouchesRequired=1;//点按的手指数
    [self.fullscreenView addGestureRecognizer:tapGesture];
    
}

-(void)tapUiscrollView{
    
    CGPoint offset =  CGPointMake(0.0f, 0.0f);
    
    [self.scrollView setContentOffset:offset animated:YES];
   
    if (![_gatewayIDField isExclusiveTouch]) {
        [_gatewayIDField resignFirstResponder];
    }
    if (![_gatewaypwdField isExclusiveTouch]) {
        [_gatewaypwdField resignFirstResponder];
    }
    if (![_routerLableField isExclusiveTouch]) {
        [_routerLableField resignFirstResponder];
    }
    if (![_routerPwdField isExclusiveTouch]) {
        [_routerPwdField resignFirstResponder];
    }
    
}

/**
 *  添加 UIScrollView
 */

-(void)addUIScrollView{
    
    UIScrollView   *scrollView = [[UIScrollView alloc]init];
    
    CGFloat  scrollViewX = CGRectGetMaxX(self.WhiteBackgroundLable.frame) +20 ;
    CGFloat  scrollViewY = 50 ;
    CGFloat  scrollViewW =   [UIScreen  mainScreen].bounds.size.width/1.8;
    CGFloat  scrollViewH = [UIScreen  mainScreen].bounds.size.height /1.3;
    scrollView.frame = CGRectMake(scrollViewX, scrollViewY, scrollViewW, scrollViewH);
   
    [self.fullscreenView  addSubview:scrollView];

    scrollView.contentSize = CGSizeMake(0,scrollView.height);
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.delegate = self;
    scrollView.userInteractionEnabled = YES;
    self.scrollView = scrollView;
    scrollView.alwaysBounceVertical =NO;
    scrollView.scrollEnabled = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8* NSEC_PER_SEC)),  dispatch_get_main_queue(), ^{
        
        NSInteger key = self.view.height - CGRectGetMaxY(textField.frame)-CGRectGetMinY(self.scrollView.frame);
        
        NSInteger keyBounds = self.keyBoardHeight -key  ;
        
        
        //        NSLog(@"   keyBounds = %ld  key = %ld  %f %f self.keyBoardHeight = %ld"  ,(long)keyBounds,(long)key,CGRectGetMaxY(textField.frame),CGRectGetMinY(self.loginBackGroundView.frame),(long)self.keyBoardHeight);
        //
        if (keyBounds<0) {
            
        }else{
            CGPoint offset =  CGPointMake(0.0f, keyBounds);
            [self.scrollView setContentOffset:offset animated:YES];
        }
    });
    
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

/**
 *设置纯白背景底色
 */
-(void)setWhiteBackground{
    
    
    UILabel  *WhiteBackgroundLable= [[UILabel  alloc]init];
    
    CGFloat  WhiteBackgroundLableX = 15 ;
    CGFloat  WhiteBackgroundLableY = 50 ;
    CGFloat  WhiteBackgroundLableW = [UIScreen mainScreen].bounds.size.width/2.8;
    CGFloat  WhiteBackgroundLableH = [UIScreen  mainScreen].bounds.size.height /1.3;
    WhiteBackgroundLable.frame = CGRectMake(WhiteBackgroundLableX, WhiteBackgroundLableY, WhiteBackgroundLableW, WhiteBackgroundLableH);
    
    WhiteBackgroundLable.backgroundColor = [UIColor  whiteColor];
    
    WhiteBackgroundLable.clipsToBounds = YES;
     WhiteBackgroundLable.layer.cornerRadius = 8.0;//设置边框圆角
    self.WhiteBackgroundLable = WhiteBackgroundLable;
    
    [self.fullscreenView addSubview:WhiteBackgroundLable];
    
}

/**
 *  创建一个UITableView 控件
 */
-(void)addTableView{
    
    //创建一个UITableView 对象
    UITableView *tableView = [[UITableView  alloc]init];
    
    CGFloat  tableViewX = 20;
    CGFloat  tableViewY = 55;
    CGFloat  tableViewW = [UIScreen mainScreen].bounds.size.width/3;
    CGFloat  tableViewH = [UIScreen  mainScreen].bounds.size.height/1.4;

    tableView.frame = CGRectMake(tableViewX, tableViewY, tableViewW, tableViewH);
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    tableView.backgroundColor = [UIColor  whiteColor];
    tableView.scrollEnabled = NO;
    tableView.dataSource=self;
    tableView.delegate = self;
   
    [self.fullscreenView  addSubview:tableView];
    
    
}
/**
 *  设置界面
 */


-(void)configureHostLable{
   
    UILabel  *configureLable= [[UILabel  alloc]init];
    
    CGFloat  configureLableX = 0;//CGRectGetMaxX(self.WhiteBackgroundLable.frame) +20 ;
    CGFloat  configureLableY = 0;//50 ;
    CGFloat  configureLableW =   [UIScreen  mainScreen].bounds.size.width/1.8;
    CGFloat  configureLableH = [UIScreen  mainScreen].bounds.size.height /1.3;
    configureLable.frame = CGRectMake(configureLableX, configureLableY, configureLableW, configureLableH);

    configureLable.backgroundColor = [UIColor  whiteColor];

    configureLable.clipsToBounds = YES;
    configureLable.layer.cornerRadius = 8.0;//设置边框圆角
    self.configureLable = configureLable;

    [self.scrollView addSubview:configureLable];

}
/**
 *  配置主机内容
 */
-(void)configureHostContents{


    //从沙盒子中取信息
    HCaccount *account = [HCaccountTool account];
   
    CGFloat  homecoo ;
    
    if ([UIScreen  mainScreen].bounds.size.width == 568) {//4.0寸屏幕
        
        homecoo = CGRectGetMinX(self.configureLable.frame)+HomeCOOEdage4;
        
    }else if ([UIScreen  mainScreen].bounds.size.width == 480){//3.5寸屏幕
        
        homecoo = CGRectGetMinX(self.configureLable.frame)+HomeCOOEdage3;

    }else{
        
        homecoo = CGRectGetMinX(self.configureLable.frame)+HomeCOOEdage;

        
    }

     UILabel *gatewayID = [[UILabel  alloc]initWithFrame:CGRectMake(homecoo, CGRectGetMinY(self.configureLable.frame)+20, 100, HomeCOOHeight)];

    [gatewayID  setText:@"主 机 编 号"];
    [gatewayID  setTextAlignment:NSTextAlignmentCenter ];
    
    gatewayID.font = [UIFont  systemFontOfSize:15];
        
 
    
   // gatewayID.backgroundColor = [UIColor  redColor];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    
  
    UITextField  *gatewayIDField = [[UITextField  alloc]init];
    
    CGFloat  gatewayIDX = CGRectGetMaxX(gatewayID.frame)+5;
    CGFloat  gatewayIDY =CGRectGetMinY(self.configureLable.frame)+20;
    CGFloat  gatewayIDW =self.configureLable.frame.size.width/2;
    CGFloat  gatewayIDH = HomeCOOHeight;
    
    gatewayIDField.frame = CGRectMake(gatewayIDX, gatewayIDY, gatewayIDW, gatewayIDH);
    gatewayIDField.clipsToBounds = YES;
    gatewayIDField.layer.cornerRadius = 8.0;
    gatewayIDField.delegate = self;
    gatewayIDField.layer.borderColor=[[UIColor grayColor]CGColor];
    gatewayIDField.layer.borderWidth= 1.0f;
    gatewayIDField.placeholder = @"请输入主机编号";
  
    if(account){
    
        gatewayIDField.text = account.AccountGatewayID;
    
    }
    self.gatewayIDField = gatewayIDField;
    if ([UIScreen  mainScreen].bounds.size.width == 480){//3.5寸屏幕
        
        gatewayIDField.font = [UIFont  systemFontOfSize:13];
        
    }else{
        
        gatewayIDField.font = [UIFont  systemFontOfSize:15];
    }
    gatewayIDField.leftView = paddingView;
    
    gatewayIDField.leftViewMode = UITextFieldViewModeAlways;
    gatewayIDField.clearButtonMode = UITextFieldViewModeWhileEditing;

    UILabel *gatewaypwd = [[UILabel  alloc]initWithFrame:CGRectMake(homecoo, CGRectGetMaxY(gatewayID.frame)+5, 100, HomeCOOHeight)];
    
    [gatewaypwd  setText:@"主 机 密 码"];
    [gatewaypwd  setTextAlignment:NSTextAlignmentCenter ];
    
    gatewaypwd.font = [UIFont  systemFontOfSize:15];
   
   // gatewaypwd.backgroundColor = [UIColor  redColor];
    //添加产品名称文本框
    
    UITextField  *gatewaypwdField = [[UITextField  alloc]init];
    
    CGFloat  gatewaypwdFieldX = CGRectGetMaxX(gatewayID.frame)+5;
    CGFloat  gatewaypwdFieldY =CGRectGetMaxY(gatewayID.frame)+5;
    CGFloat  gatewaypwdFieldW =self.configureLable.frame.size.width/2;
    CGFloat  gatewaypwdFieldH = HomeCOOHeight;
    
    gatewaypwdField.frame = CGRectMake(gatewaypwdFieldX, gatewaypwdFieldY, gatewaypwdFieldW, gatewaypwdFieldH);
    gatewaypwdField.clipsToBounds = YES;
    gatewaypwdField.layer.cornerRadius = 8.0;
    gatewaypwdField.delegate = self;
    gatewaypwdField.secureTextEntry = YES;
    gatewaypwdField.layer.borderColor=[[UIColor grayColor]CGColor];
    gatewaypwdField.layer.borderWidth= 1.0f;
    gatewaypwdField.placeholder = @"请输入主机密码";
   
    if(account){
        
        gatewaypwdField.text = account.AccountGatewayPwd;
        
    }
    self.gatewaypwdField = gatewaypwdField;
    if ([UIScreen  mainScreen].bounds.size.width == 480){//3.5寸屏幕
        
        gatewaypwdField.font = [UIFont  systemFontOfSize:13];
        
    }else{
        
        gatewaypwdField.font = [UIFont  systemFontOfSize:15];
    }
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    gatewaypwdField.leftView = paddingView1;
    
    gatewaypwdField.leftViewMode = UITextFieldViewModeAlways;
    gatewaypwdField.clearButtonMode = UITextFieldViewModeWhileEditing;
    UILabel *routerLable = [[UILabel  alloc]initWithFrame:CGRectMake(homecoo, CGRectGetMaxY(gatewaypwd.frame)+5, 100, HomeCOOHeight)];
    
    [routerLable  setText:@"路由无线名称"];
    [routerLable  setTextAlignment:NSTextAlignmentCenter ];
    
    routerLable.font = [UIFont  systemFontOfSize:15];
        
    
    
    //routerLable.backgroundColor = [UIColor  redColor];
    //添加产品名称文本框
    UITextField  *routerLableField = [[UITextField  alloc]init];
    
    CGFloat  routerLableFieldX = CGRectGetMaxX(gatewayID.frame)+5;
    CGFloat  routerLableFieldY =CGRectGetMaxY(gatewaypwd.frame)+5;
    CGFloat  routerLableFieldW =self.configureLable.frame.size.width/2;
    CGFloat  routerLableFieldH = HomeCOOHeight;
    
    routerLableField.frame = CGRectMake(routerLableFieldX, routerLableFieldY, routerLableFieldW, routerLableFieldH);
    routerLableField.clipsToBounds = YES;
    routerLableField.layer.cornerRadius = 8.0;
    routerLableField.delegate = self;
    routerLableField.layer.borderColor=[[UIColor grayColor]CGColor];
    routerLableField.layer.borderWidth= 1.0f;
    routerLableField.placeholder = @"请输入路由无线名称";
   
    if(account){
        
        routerLableField.text = account.AccountRouterName;
        
    }
     self.routerLableField = routerLableField;
    if ([UIScreen  mainScreen].bounds.size.width == 480){//3.5寸屏幕
        
      routerLableField.font = [UIFont  systemFontOfSize:13];
        
    }else{
        
      routerLableField.font = [UIFont  systemFontOfSize:15];
    }
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    routerLableField.leftView = paddingView2;
    
    routerLableField.leftViewMode = UITextFieldViewModeAlways;
    routerLableField.clearButtonMode = UITextFieldViewModeWhileEditing;
    UILabel *routerPwd = [[UILabel  alloc]initWithFrame:CGRectMake(homecoo, CGRectGetMaxY(routerLable.frame)+5, 100, HomeCOOHeight)];
    
    [routerPwd  setText:@"路由无线密码"];
    [routerPwd  setTextAlignment:NSTextAlignmentCenter ];
    
   
    routerPwd.font = [UIFont  systemFontOfSize:15];
   
   // routerPwd.backgroundColor = [UIColor  redColor];
    //添加产品名称文本框
    UITextField  *routerPwdField = [[UITextField  alloc]init];
    
    CGFloat  routerPwdX = CGRectGetMaxX(gatewayID.frame)+5;
    CGFloat  routerPwdY =CGRectGetMaxY(routerLable.frame)+5;
    CGFloat  routerPwdW =self.configureLable.frame.size.width/2;
    CGFloat  routerPwdH = HomeCOOHeight;
    
    routerPwdField.frame = CGRectMake(routerPwdX, routerPwdY, routerPwdW, routerPwdH);
    routerPwdField.clipsToBounds = YES;
    routerPwdField.layer.cornerRadius = 8.0;
    routerPwdField.delegate = self;
    routerPwdField.secureTextEntry = YES;
    routerPwdField.layer.borderColor=[[UIColor grayColor]CGColor];
    routerPwdField.layer.borderWidth= 1.0f;
    routerPwdField.placeholder = @"请输入路由无线密码";
   
    if(account){
        
        routerPwdField.text = account.AccountRouterPwd;
        
    }
    self.routerPwdField = routerPwdField;

    if ([UIScreen  mainScreen].bounds.size.width == 480){//3.5寸屏幕
        
        routerPwdField.font = [UIFont  systemFontOfSize:13];
        
    }else{
        
        routerPwdField.font = [UIFont  systemFontOfSize:15];
    }
    
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    routerPwdField.leftView = paddingView3;
    
    routerPwdField.leftViewMode = UITextFieldViewModeAlways;
    routerPwdField.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIButton  *ConfirmBtn = [[UIButton  alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.configureLable.frame)+self.configureLable.frame.size.width/2-25, CGRectGetMaxY(routerPwd.frame)+15, 55, 30)];
    [ConfirmBtn  setTitle:@"确定" forState:UIControlStateNormal];
    
    [ConfirmBtn  setTitle:@"确定" forState:UIControlStateHighlighted];
    [ConfirmBtn  setTitleColor:[UIColor  blackColor] forState:UIControlStateNormal];
    
    [ConfirmBtn  setTitleColor:[UIColor  whiteColor] forState:UIControlStateHighlighted];
    //[updateDeviceBtn  setFont:[UIFont  systemFontOfSize:18]];
    ConfirmBtn.titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:17];
    [ConfirmBtn  addTarget:self action:@selector(ConfirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
    ConfirmBtn.backgroundColor = [UIColor grayColor];
    [self.scrollView  addSubview:ConfirmBtn];
    [self.scrollView  addSubview:routerPwd];
    [self.scrollView  addSubview:routerPwdField];
    
    [self.scrollView  addSubview:routerLable];
    [self.scrollView  addSubview:routerLableField];

    [self.scrollView  addSubview:gatewaypwd];
    [self.scrollView  addSubview:gatewaypwdField];

    
    [self.scrollView  addSubview:gatewayID];
    [self.scrollView  addSubview:gatewayIDField];

}

/**
 *  配置主机无线
 */
-(void)ConfirmBtnAction{

    SocketManager *socket = [SocketManager shareSocketManager];
    
    HCaccount *account = [[HCaccount alloc]init];
    
    NSString *head = @"41414444";
    NSString *stamp = @"00000000";
    NSString *gatewayID =  [ControlMethods stringToByte:self.gatewayIDField.text];
    NSString *packetOthers = @"303030303030303032006b000042";
    NSString *wifiName = [ControlMethods stringToByte:self.routerLableField.text];
    NSString *wifiNameLength = [ControlMethods ToHex:[wifiName length]/2];
    
    NSString *stateAdded = @"";
    for (int i = 0; i<32-[wifiName length]/2; i ++) {
        NSString *test = [ControlMethods ToHex:0];
        
        stateAdded = [NSString  stringWithFormat:@"%@%@",stateAdded,test];
        
    }

    NSString *wifiPwd =[ControlMethods stringToByte:self.routerPwdField.text];
    NSString *routerPwdLength =  [ControlMethods ToHex:[wifiPwd length]/2];

    NSString *stateAddedd = @"";
    for (int i = 0; i<32-[wifiPwd length]/2; i ++) {
        NSString *test = [ControlMethods ToHex:0];
        
        stateAddedd = [NSString  stringWithFormat:@"%@%@",stateAddedd,test];
        
    }
    
    NSString *string1 = [head  stringByAppendingString:stamp];
    NSString *string2 = [string1  stringByAppendingString:gatewayID];
    NSString *string3 = [string2 stringByAppendingString:packetOthers];
    NSString *string4 = [string3 stringByAppendingString:wifiNameLength];
    NSString *string5 = [string4 stringByAppendingString:wifiName];
    NSString *string6 = [string5 stringByAppendingString:stateAdded];
    NSString *string7 = [string6 stringByAppendingString:routerPwdLength];
    NSString *string8 = [string7 stringByAppendingString:wifiPwd];
    NSString *data = [string8  stringByAppendingString:stateAddedd];
    
    
    NSString *heads = @"4141444430303030";
    NSString *datas = [@"000000000000000032001C000008"  stringByAppendingString:[ControlMethods stringToByte:self.gatewaypwdField.text]];
    NSString *gatewayConnectStr1 = [heads  stringByAppendingString:gatewayID];
    NSString *gatewayConnectStr = [gatewayConnectStr1 stringByAppendingString:datas];
    
    [socket startConnectHost:@"192.168.7.1" WithPort:9091];
    
    //NSLog(@"   gatewayConnectStr = %@   ",gatewayConnectStr);
    //主机认证
    [socket  sendMsg:gatewayConnectStr];
    
     //NSLog(@"   data = %@   ",data);
    
    [socket  receiveMsg:^(NSString *receiveInfo) {
        NSLog(@"  %@ ",receiveInfo);
        
        if ([[receiveInfo  substringFromIndex:receiveInfo.length -10] isEqualToString:@"4300000100"]) {
            //发送配置无线请求报文
            [socket sendMsg:data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                   
                [MBProgressHUD showSuccess:@"配置无线成功 ！"];
                
            });
            
        }
        
        [MBProgressHUD  loginHideHUD];
        
        
    }];
    account.AccountGatewayID = self.gatewayIDField.text;
    account.AccountGatewayPwd = self.gatewaypwdField.text;
    account.AccountRouterName = self.routerLableField.text;
    account.AccountRouterPwd = self.routerPwdField.text;
 
    //存入沙盒文档
    [HCaccountTool  saveAccount:account];

}
/**
 * 返回多少个rows
 *
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return 1;
}

/**
 *  UITableView 的代理方法
 *
 *  @param tableView 容器
 *  @param indexPath 索引
 *
 *  @return 返回cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static  NSString  *ID = @"cell";
    
    //创建cell 重用
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID ];
    if (!cell) {
        
        cell = [[UITableViewCell  alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        
    }
    //cell种显示的内容
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = [UIImage  imageNamed:@"wifi_router.png"];
    cell.textLabel.text = @"主机路由器无线连接";
    
    if ([UIScreen  mainScreen].bounds.size.width == 568) {//4.0寸屏幕
        
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        
    }else if ([UIScreen  mainScreen].bounds.size.width == 480){//3.5寸屏幕

        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
    }else{
        
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    
    }
    return cell;
    
}


/**
 *  UITableView  的代理方法
 *
 *  @param tableView 容器
 *  @param indexPath 索引
 */

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
   //NSLog(@"   indexPath = %ld  ",(long)indexPath.row);
    
}



/**
 *设置导背景图片
 */
-(void)setFullscreenView{
    
    UIImageView  *fullscreenView = [[UIImageView  alloc]init];
    UIImage  *image = [UIImage imageNamed:@"bg_title.jpg"];
    
    /**设置背景图片的大小*/
    fullscreenView.image = image;
    fullscreenView.userInteractionEnabled = YES;
    fullscreenView.contentMode = UIViewContentModeScaleToFill;
    CGFloat fullscreenViewW = [UIScreen  mainScreen].bounds.size.width;
    CGFloat fullscreenViewH = [UIScreen  mainScreen].bounds.size.height;
    fullscreenView.frame = CGRectMake(0, 0, fullscreenViewW, fullscreenViewH);
    self.fullscreenView = fullscreenView;
    [self.view  addSubview:fullscreenView];
    
}
/**
 *设置导航栏
 */
-(void)setNavBar{
    
    
    CGFloat navBarW = [UIScreen  mainScreen].bounds.size.width;
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0,navBarW, 40)];
    
    //创建一个导航栏集合
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"无线设置"];
    
    [[UINavigationBar appearance]setTitleTextAttributes:
     @{ NSFontAttributeName: [UIFont systemFontOfSize:16.0]}];
    
    //创建一个左边按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleBordered target:self action:@selector(backAction)];
    //给按钮添加图片
    
    leftButton.title = @"返回";
    leftButton.tintColor = [UIColor  blackColor];
    
    //设置字体大小
    [[UIBarButtonItem appearance] setTitleTextAttributes:
     @{ NSFontAttributeName: [UIFont systemFontOfSize:15.0],} forState:UIControlStateNormal];
    
    
    //创建一个右边按钮
//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleDone target:self action:@selector(finshedAction)];
//    rightButton.title = @"完成";
//    rightButton.tintColor = [UIColor  blackColor];
    //把导航栏集合添加到导航栏中，设置动画关闭
    [navBar pushNavigationItem:navItem animated:NO];
    
    //把左右两个按钮添加到导航栏集合中去
    [navItem setLeftBarButtonItem:leftButton];
    //[navItem setRightBarButtonItem:rightButton];
    
    //将标题栏中的内容全部添加到主视图当中
    [self.fullscreenView addSubview:navBar];
    
}

//返回登录界面
-(void)backAction{

 [self  dismissViewControllerAnimated:YES completion:nil];


}
-(BOOL)shouldAutorotate{
    return YES;
}



-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}
@end
