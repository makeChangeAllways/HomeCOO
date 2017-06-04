//
//  P2PStringNew.h
//  2cu
//
//  Created by mac on 15/6/17.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface P2PStringNew : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *oldpassword;
@property (nonatomic, strong) UITextField *newpassword;
@property (nonatomic, strong) UITextField *repassword;
@property (nonatomic, strong) UITextField *visitorpassword;
@property (nonatomic, strong) UIButton *savebutton;

//初始化
+(instancetype)p2pstringnewmanager:(UITableView *)tableView;
+(instancetype)p2pstringnewvisitor:(UITableView *)tableView;

-(void)fill;
-(void)fill2;

@end
