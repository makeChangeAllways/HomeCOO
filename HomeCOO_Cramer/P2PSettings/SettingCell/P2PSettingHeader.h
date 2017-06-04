//
//  P2PSettingHeader.h
//  2cu
//
//  Created by mac on 15/6/17.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HeaderViewDelegate <NSObject>
@optional
-(void)headerViewDidClickBtn:(UITableViewHeaderFooterView*) view;
@end

@interface P2PSettingHeader : UITableViewHeaderFooterView

@property (nonatomic, strong) UIButton* button;
@property (nonatomic, strong) id<HeaderViewDelegate> delegate;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic,assign) int flag;

+(instancetype)headerViewWithTableView:(UITableView *)tableView;
-(void) setName:(NSString*)name;
@end
