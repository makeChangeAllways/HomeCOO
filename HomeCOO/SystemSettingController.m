//
//  SystemSettingController.m
//  HomeCOO
//
//  Created by app on 2016/10/22.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "SystemSettingController.h"
#import "ControlMethods.h"
#import "HCaccount.h"
#import "HCaccountTool.h"
#import "SocketManager.h"
#import "PrefixHeader.pch"
#import "UIView+Extension.h"
#import "LZXDataCenter.h"
#import "AFNetworkings.h"
#import "MBProgressHUD+MJ.h"
#import "userMessage.h"
#import "userMessageTool.h"
#import "LoginViewController.h"
#define HomeCOOHeight   40

#define HomeCOOEdage   30

#define HomeCOOEdage4   20

#define HomeCOOEdage3   10

@interface SystemSettingController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
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
@property(nonatomic,strong) NSArray *cellTitle;
@property(nonatomic,strong)  LZXDataCenter *dataCenter;

@end

@implementation SystemSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置背景
    [self setFullscreenView];
    
    //创建一个导航栏
    [self setNavBar];
    
    LZXDataCenter *dataCenter = [LZXDataCenter  defaultDataCenter];
    self.dataCenter = dataCenter;
    
    [self  setWhiteBackground];
    
    NSArray *title = @[@"注销账号"];
    
    self.cellTitle = title;
    //创建一个UITableView 控件
    [self  addTableView];
    
    [self configureHostLable];

    
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
    
    CGFloat  configureLableX = CGRectGetMaxX(self.WhiteBackgroundLable.frame) +20 ;
    CGFloat  configureLableY = 50 ;
    CGFloat  configureLableW =   [UIScreen  mainScreen].bounds.size.width/1.8;
    CGFloat  configureLableH = [UIScreen  mainScreen].bounds.size.height /1.3;
    configureLable.frame = CGRectMake(configureLableX, configureLableY, configureLableW, configureLableH);
    
    configureLable.backgroundColor = [UIColor  whiteColor];
    configureLable.userInteractionEnabled = YES;
    configureLable.clipsToBounds = YES;
    configureLable.layer.cornerRadius = 8.0;//设置边框圆角
    self.configureLable = configureLable;
    
    [self.fullscreenView addSubview:configureLable];
    
    //[self  versionUpdate];
}

//-(void)versionUpdate{
//
//    UILabel *versionLable = [[UILabel  alloc]initWithFrame:CGRectMake(_configureLable.width/2-50, 20, 100, 20)];
//    
//    versionLable.text = @"当前版本1.0";
//    //versionLable.backgroundColor = [UIColor  redColor];
//    versionLable.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
//    versionLable.textColor = [UIColor  blackColor];
//    versionLable.textAlignment = 1;
//    
//    
//    [self.configureLable  addSubview:versionLable];
//    
//}


/**
 * 返回多少个rows
 *
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.cellTitle.count;
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
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//cell 显示向右的箭头
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.cellTitle[indexPath.row];
    
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

    if (indexPath.row ==0) {
        
        UIAlertView * alert = [[UIAlertView  alloc]initWithTitle:@"温馨提示" message:@"确定要注销账号吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alert show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

   
    if(buttonIndex ==1){//点击的是确定按键
        
        if (_dataCenter.networkStateFlag == 0) {
            
            [MBProgressHUD  showError:@"请切换到远程网络!"];
            
        }else{
            
            [self cancelAccountMethods];
            
        }
       
    }

}

/**
 注销账号
 */
-(void)cancelAccountMethods{
    
    //创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager  manager];
    mgr.responseSerializer = [AFJSONResponseSerializers  serializer];
    
    //配置请求超时时间
    mgr.requestSerializer.timeoutInterval = 60;
    
    //设置请求参数
    NSMutableDictionary  *params = [NSMutableDictionary  dictionary];
    params[@"phonenum"] = _dataCenter.userPhoneNum;
    
    NSString  *urlStr =[NSString  stringWithFormat:@"%@/appCancelUser" ,HomecooServiceURL];
    NSString *url = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
    
    [mgr  POST:url parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        //打印日志
        //NSLog(@"请求成功--%@",responseObject);
        NSString  *result = [responseObject[@"result"]description];
        NSString *message = [responseObject[@"messageInfo"]description];
    
        if ([result  isEqual:@"success"]) {
            
            [MBProgressHUD  showSuccess:[NSString  stringWithFormat:@"%@",message]];
            //删除用户表 不能登录进来
            [userMessageTool deleteUserTable];
            
            [self presentViewController:[[LoginViewController alloc]init] animated:YES completion:nil];
            
        } if ([result  isEqual:@"failed"]) {
            
            [MBProgressHUD  showError:[NSString  stringWithFormat:@"%@",message]];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD  showError:@"网络繁忙，请稍后再试"];
        
    }];
    
    
    


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
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"系统设置"];
    
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
@end
