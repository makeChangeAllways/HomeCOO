//
//  P2PStringNew.m
//  2cu
//
//  Created by mac on 15/6/17.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//

#import "P2PStringNew.h"
#import "PrefixHeader.pch"
@implementation P2PStringNew

- (void)awakeFromNib {
    // Initialization code
}
+ (instancetype)p2pstringnewmanager:(UITableView *)tableView{
    static NSString *ID=@"friend1";
    P2PStringNew *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[P2PStringNew alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}
+ (instancetype)p2pstringnewvisitor:(UITableView *)tableView{
    static NSString *ID=@"friend2";
    P2PStringNew *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[P2PStringNew alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}
- (void)fill{
    [_oldpassword removeFromSuperview];
    CGRect rec = [UIScreen mainScreen].bounds;
    UITextField *old = [[UITextField alloc]initWithFrame:CGRectMake(50, 10, rec.size.width - 100, 35)];
    old.layer.borderColor = [[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor];
//    old.layer.cornerRadius = 1.0;
    old.textAlignment = NSTextAlignmentLeft;
    
    old.placeholder = NSLocalizedString(@"input_original_password", nil);
//    old.borderStyle = UITextBorderStyleBezel;
    old.layer.borderWidth=1.0;
    old.delegate=self;
    old.layer.borderColor=XBgColor.CGColor;
    old.returnKeyType = UIReturnKeyDone;
    old.secureTextEntry = YES;
    old.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    old.autocapitalizationType = UITextAutocapitalizationTypeNone;
    old.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.contentView addSubview:old];
    _oldpassword = old;
    [old release];
    
    
    [_newpassword removeFromSuperview];
    UITextField *new = [[UITextField alloc]initWithFrame:CGRectMake(50, BottomForView(old)+10, rec.size.width - 100, HeightForView(old))];
    new.layer.borderColor = [[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor];
    new.textAlignment = NSTextAlignmentLeft;
    
    new.placeholder = NSLocalizedString(@"input_new_password", nil);
//    new.borderStyle = UITextBorderStyleNone;
    new.layer.borderColor=XBgColor.CGColor;
    new.layer.borderWidth=1.0;
    new.returnKeyType = UIReturnKeyDone;
    new.secureTextEntry = YES;
    new.delegate=self;
    new.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    new.autocapitalizationType = UITextAutocapitalizationTypeNone;
    new.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.contentView addSubview:new];
    _newpassword = new;
    [new release];
    
    
    [_repassword removeFromSuperview];
    UITextField *re = [[UITextField alloc]initWithFrame:CGRectMake(50, BottomForView(new)+10, rec.size.width - 100, HeightForView(old))];
    re.layer.borderColor = [[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor];
    re.textAlignment = NSTextAlignmentLeft;
    
    re.placeholder = NSLocalizedString(@"confirm_input", nil);
//    re.borderStyle = UITextBorderStyleRoundedRect;
    re.layer.borderWidth=1.0;
    re.delegate=self;
    re.layer.borderColor=XBgColor.CGColor;
    re.returnKeyType = UIReturnKeyDone;
    re.secureTextEntry = YES;
    re.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    re.autocapitalizationType = UITextAutocapitalizationTypeNone;
    re.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.contentView addSubview:re];
    _repassword = re;
    [re release];
    
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(70, 95, rec.size.width - 140, 28)];
//    button.layer.cornerRadius = 3.5;
//    [button setTitle:NSLocalizedString(@"save", nil) forState:UIControlStateNormal];
//    button.backgroundColor =[UIColor colorWithRed:109/255.0 green:161/255.0 blue:219/255.0 alpha:1.0];
//    [self.contentView addSubview:button];
//    _savebutton = button;
//    [button release];
    
    if(!self.savebutton){
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(70, BottomForView(re)+10, rec.size.width - 140, 30)];
        [button setTitle:NSLocalizedString(@"save", nil) forState:UIControlStateNormal];
        button.backgroundColor =[UIColor colorWithRed:109/255.0 green:161/255.0 blue:219/255.0 alpha:1.0];
        [self.contentView addSubview:button];
        _savebutton = button;

    }else{
        self.savebutton=[[UIButton alloc] initWithFrame:CGRectMake(70, BottomForView(re)+10, rec.size.width - 140, 30)];
        [self.savebutton setTitle:NSLocalizedString(@"save", nil) forState:UIControlStateNormal];
        self.savebutton.backgroundColor =[UIColor colorWithRed:109/255.0 green:161/255.0 blue:219/255.0 alpha:1.0];
        [self.contentView addSubview:self.savebutton];

    }

}

-(void)fill2{
    [_visitorpassword removeFromSuperview];
    CGRect rec = [UIScreen mainScreen].bounds;
    UITextField *old = [[UITextField alloc]initWithFrame:CGRectMake(50, 10, rec.size.width - 100, 35)];
    old.layer.borderColor = [[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor];
//    old.layer.cornerRadius = 1.0;
    old.textAlignment = NSTextAlignmentLeft;
    
    old.placeholder = NSLocalizedString(@"input_new_visitor_password", nil);
    old.layer.borderColor=XBgColor.CGColor;
    old.layer.borderWidth=1.0;
    old.returnKeyType = UIReturnKeyDone;
    old.secureTextEntry = YES;
    old.delegate=self;
    old.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    old.autocapitalizationType = UITextAutocapitalizationTypeNone;
    old.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.contentView addSubview:old];
    _visitorpassword = old;
    [old release];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(70, BottomForView(old)+10, rec.size.width - 140, 30)];
    [button setTitle:NSLocalizedString(@"save", nil) forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithRed:109/255.0 green:161/255.0 blue:219/255.0 alpha:1.0];
    [self.contentView addSubview:button];
    _savebutton = button;
    [button release];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
