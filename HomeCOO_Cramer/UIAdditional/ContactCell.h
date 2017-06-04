//
//  ContactCell.h
//  2cu
//
//  Created by guojunyi on 14-4-12.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"
#import "YProgressView.h"
#import "LocalDevice.h"
typedef void(^SetBlock)();
typedef void(^resetBlk)(LocalDevice *);

@protocol OnClickDelegate
-(void)onClick:(NSInteger)position contact:(Contact*)contact;

@end

@class Contact;
@interface ContactCell : UITableViewCell
@property (strong, nonatomic) Contact *contact;

@property (strong, nonatomic) UIButton *headView;
@property(nonatomic,strong)UIImageView *headimageView;
@property(nonatomic,strong)UIImageView *headIconView;
@property(nonatomic,strong)UIImageView *defenceStateImageView;



@property (strong, nonatomic) UIImageView *typeView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *stateLabel;

@property (strong, nonatomic) UIButton *defenceStateView;
@property (strong, nonatomic) YProgressView *defenceProgressView;

@property (strong, nonatomic) UIImageView *messageCountView;

@property (strong, nonatomic) id<OnClickDelegate> delegate;
@property (nonatomic) NSInteger position;
@property (strong, nonatomic) UIView *cellbg;


@property(nonatomic,strong)UIButton *settingBtn;

@property(nonatomic,strong)SetBlock settingblock;
@property(nonatomic,strong)UIView *shadow_View;

@property(nonatomic,strong)LocalDevice *loc;

@property(nonatomic,strong)resetBlk resetBlock;



@end
