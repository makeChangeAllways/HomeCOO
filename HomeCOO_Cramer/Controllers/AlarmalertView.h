//
//  AlarmalertView.h
//  2cu
//
//  Created by mac on 15/5/22.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//

#import "CustomAlertView.h"

@interface AlarmalertView : CustomAlertView<UITextFieldDelegate,UITextViewDelegate>
-(id)initWithFrame:(CGRect)frame withtypestr:(NSString *)typestr withcid:(NSString *)contactid;
@property(nonatomic,retain)UIButton *canclebtn;
@property (strong, nonatomic) UILabel *title;


@end
