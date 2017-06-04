//
//  PanelBaseV.h
//  IRBT
//
//  Created by wsz on 16/9/28.
//  Copyright © 2016年 wsz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MutiClickBtn.h"
#import "KeyBoardMap.h"

@interface PanelBaseV : UIView

@property (nonatomic,copy)void(^panelBtnClicked)(Class cls, id sender);

@end
