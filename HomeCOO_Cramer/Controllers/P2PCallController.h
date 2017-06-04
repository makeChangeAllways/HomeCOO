//
//  P2PCallController.h
//  2cu
//
//  Created by guojunyi on 14-3-26.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "P2PClient.h"
@interface P2PCallController : UIViewController
{
    
    int countTimer;
    
    int percent;
    
    NSTimer *timer;
}

@property (nonatomic) BOOL isReject;
@property (nonatomic) BOOL isAccept;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *contactName;
@property (strong, nonatomic) UIImageView *circle_img;
@property (strong, nonatomic) UILabel *circle_label;
@end
