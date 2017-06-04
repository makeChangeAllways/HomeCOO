//
//  P2PHeadView.m
//  2cu
//
//  Created by mac on 15/6/2.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//

#import "P2PHeadView.h"
#import "PrefixHeader.pch"
@implementation P2PHeadView
-(id)initWithFrame:(CGRect)frame with:(Contact *)contact{
    
    self = [super initWithFrame:frame];
    self.contact=contact;
    
    if (self) {
    CGFloat cellWidth = frame.size.width;
    CGFloat cellHeight = frame.size.height-10;
    
    self.backgroundColor=[UIColor whiteColor];
    
    

    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,120, cellHeight-20)];
//    leftView.contentMode = UIViewContentModeScaleAspectFit;
    NSString *filePath = [Utils getHeaderFilePathWithId:contact.contactId];
    UIImage *headImg = [UIImage imageWithContentsOfFile:filePath];
    if(headImg==nil){
        headImg = [UIImage imageNamed:@"bgImageBig.jpg"];
    }
    leftView.image = headImg;
    [self addSubview:leftView];
    self.leftIconView = leftView;
    
    
    
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(RightForView(self.leftIconView)+10, 10, cellWidth-RightForView(self.leftIconView)-30, (cellHeight-20)/2)];
    textLabel.textAlignment = NSTextAlignmentLeft;
    textLabel.textColor = [UIColor blackColor];
    textLabel.text = contact.contactName;
    [self addSubview:textLabel];
    textLabel.font=[UIFont systemFontOfSize:15];
    
    UILabel *textLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(XForView(textLabel), BottomForView(textLabel), 100, HeightForView(textLabel)-5)];
    textLabel2.textAlignment = NSTextAlignmentLeft;
    textLabel2.textColor = [UIColor grayColor];
    textLabel2.text = [NSString stringWithFormat:@"(%@ID:%@)",NSLocalizedString(@"device", nil),contact.contactId];
    textLabel2.font=[UIFont systemFontOfSize:11];
    [self addSubview:textLabel2];
    
    UIButton*btn=[[UIButton alloc]init];
    [self addSubview:btn];
    [btn setFrame:CGRectMake(RightForView(textLabel2), YForView(textLabel2), cellWidth-RightForView(textLabel2)-5, HeightForView(textLabel))];
    [btn setTitle:NSLocalizedString(@"device_info", nil) forState:UIControlStateNormal];
    btn.backgroundColor=[UIColor colorWithRed:109/255.0 green:161/255.0 blue:219/255.0 alpha:1.0];
    [btn addTarget:self action:@selector(onViewDeviceInfoButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font=[UIFont systemFontOfSize:11];
    self.rigthbtn=btn;
        
    
    UIImageView*bottomview=[[UIImageView alloc]init];
    [self addSubview:bottomview];
    bottomview.frame=CGRectMake(0, HeightForView(self)-10, cellWidth, 10);
    bottomview.backgroundColor=[UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1.0];

    }
    return self;
}
-(void)onViewDeviceInfoButtonPress:(UIButton*)button{
    self.progressAlert.dimBackground = YES;
    [self.progressAlert show:YES];
    [[P2PClient sharedClient] getDeviceInfoWithId:self.contact.contactId password:self.contact.contactPassword];
}
@end
