//
//  FullScreenView.h
//  2cu
//
//  Created by mac on 15/6/1.
//  Copyright (c) 2015年 guojunyi. All rights reserved.
//

#import "CustomAlertView.h"

@interface FullScreenView : CustomAlertView
-(id)initWithFrame:(CGRect)frame withtypestr:(NSString *)typestr withcid:(NSString *)contactid;
@property(nonatomic,retain)UIButton *canclebtn;
@property(nonatomic,retain)UIButton *callbtn;
@property(nonatomic,assign)  SystemSoundID soundID;
@end
