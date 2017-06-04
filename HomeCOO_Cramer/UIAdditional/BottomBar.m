//
//  BottomBar.m
//  2cu
//
//  Created by guojunyi on 14-4-11.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import "BottomBar.h"
#import "Constants.h"
#import "AlarmDAO.h"
#import "PrefixHeader.pch"

@implementation BottomBar

-(void)dealloc{
    [self.items release];
    [self.backViews release];
    [self.iconViews release];
    [self.labelViews release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UPDATE_RED_POINT" object:nil];
    
    [super dealloc];
}

#define ITEM_COUNT 4
#define ICON_MARGIN 6
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // ===
        // 2015 - 10 - 28 新增小红点功能
        
        // 用于外面对小红点的操作
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setRedPoint) name:@"UPDATE_RED_POINT" object:nil];
        
        
        //===
        
        
        
        self.items = [NSMutableArray arrayWithCapacity:0];
        self.iconViews = [NSMutableArray arrayWithCapacity:0];
        self.backViews = [NSMutableArray arrayWithCapacity:0];
        self.labelViews = [NSMutableArray arrayWithCapacity:0];
        self.selectedIndex = 0;
        CGFloat itemWidth = frame.size.width/ITEM_COUNT;
        
         NSArray * btnTitles = @[NSLocalizedString(@"steward",nil),NSLocalizedString(@"iesag",nil),NSLocalizedString(@"image",nil),NSLocalizedString(@"ietting",nil)];

        for(int i=0;i<ITEM_COUNT;i++){
            
            UIButton *item = [[UIButton alloc] init];
            item.frame = CGRectMake(itemWidth*i, 0, itemWidth, frame.size.height);
            item.backgroundColor=[UIColor whiteColor];
            
            UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, item.frame.size.width+5, item.frame.size.height-10)];
//            UIImage *backImg = [UIImage imageNamed:@"bg_tab_item.png"];
//            backImg = [backImg stretchableImageWithLeftCapWidth:backImg.size.width*0.5 topCapHeight:backImg.size.height*0.5];
//            backView.image = backImg;
            [item addSubview:backView];
            backView.backgroundColor=[UIColor whiteColor];
            
//            [item setImageEdgeInsets: UIEdgeInsetsMake(-8, 0, 0, 0)];
            
            UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake((backView.frame.size.width-backView.frame.size.height+ICON_MARGIN*2)/2, ICON_MARGIN, backView.frame.size.height-ICON_MARGIN*2, backView.frame.size.height-ICON_MARGIN*2)];
            
            NSLog(@"iconView.frame = %@",NSStringFromCGRect(iconView.frame));
            
            UIImage *iconImg = nil;
            switch(i){
                case 0:
                {
//                    iconImg = [UIImage imageNamed:@"ic_tab_item_contact_p.png"];
                    iconImg = [UIImage imageNamed:@"main_my_press_cn"];
                    iconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, ICON_MARGIN, 56, backView.frame.size.height-ICON_MARGIN*2)];
                    
                    //                    iconView = [[UIImageView alloc] initWithFrame:CGRectMake((backView.frame.size.width-backView.frame.size.height+ICON_MARGIN*2)/2+3, ICON_MARGIN, backView.frame.size.height-ICON_MARGIN*2-5, backView.frame.size.height-ICON_MARGIN*2)];
                    NSLog(@"00000000>iconView.frame = %@",NSStringFromCGRect(iconView.frame));
//                    iconView.backgroundColor = [UIColor redColor];
                }
                    break;
                case 1:
                {
//                    iconImg = [UIImage imageNamed:@"ic_tab_item_keyboard.png"];
                    iconImg = [UIImage imageNamed:@"main_mess-_cn"];
//                    iconView.backgroundColor = [UIColor greenColor];
                    
                    
                    // ===
                    // 2015 - 10 - 28 新增小红点功能
                    UIButton *red_point = [[UIButton alloc] init];
                    [iconView addSubview:red_point];
                    red_point.frame = CGRectMake(WidthForView(iconView) + 10, 0, 7, 7);
                    red_point.layer.cornerRadius = 3.5;
                    red_point.clipsToBounds = YES;
                    [red_point setBackgroundColor:[UIColor redColor]];
                    self.red_point = red_point;
                    red_point.hidden = YES;
                    // 判断是否已读
                    [self setRedPoint];
                   
                    // ===
                    
                    NSLog(@"------>iconView.frame = %@",NSStringFromCGRect(iconView.frame));
                    
                }
                    break;
                case 2:
                {
//                    iconImg = [UIImage imageNamed:@"ic_tab_toolbox.png"];
                    iconImg = [UIImage imageNamed:@"main_video_cn"];
//                    iconView = [[UIImageView alloc] initWithFrame:CGRectMake((backView.frame.size.width-backView.frame.size.height+ICON_MARGIN*2)/2, ICON_MARGIN-5, (backView.frame.size.height-ICON_MARGIN*2)+5, backView.frame.size.height-ICON_MARGIN*2+10)];
                    NSLog(@"------>iconView.frame = %@",NSStringFromCGRect(iconView.frame));
//                    iconView.backgroundColor = [UIColor yellowColor];
                }
                    break;
                case 3:
                {
//                    iconImg = [UIImage imageNamed:@"ic_tab_item_setting.png"];
                    iconImg = [UIImage imageNamed:@"main_setting_cn"];
//                    iconView.backgroundColor = [UIColor blackColor];
                    NSLog(@"------>iconView.frame = %@",NSStringFromCGRect(iconView.frame));
                }
                    break;
//                case 4:
//                {
//                    iconImg = [UIImage imageNamed:@"ic_tab_item_setting.png"];
//                }
//                    break;
            }
//            iconImg = [iconImg stretchableImageWithLeftCapWidth:iconImg.size.width*0.5 topCapHeight:iconImg.size.height*0.5];
            iconView.image = iconImg;
            [backView addSubview:iconView];
//            iconView.backgroundColor = [UIColor redColor];
//            NSLog(@"------>iconView.frame = %@",NSStringFromCGRect(iconView.frame));
            [self.iconViews addObject:iconView];
            [self.backViews addObject:backView];
            [iconView release];
            [backView release];
            
            [self addSubview:item];
            [self.items addObject:item];
            [item release];
            
            UILabel *texttitle=[[UILabel alloc] init];
            texttitle.backgroundColor=[UIColor clearColor];
            texttitle.textAlignment=NSTextAlignmentCenter;
            texttitle.font=[UIFont systemFontOfSize:11];
            
            texttitle.frame=CGRectMake(0, frame.size.height-15, WidthForView(item)+5, 15);
            if (i == 0)
            {
                iconView.center = CGPointMake(texttitle.center.x, iconView.center.y);
            }
            texttitle.tag=1000;
            texttitle.text=btnTitles[i];
            [self.labelViews addObject:texttitle];
            [item addSubview:texttitle];
            texttitle.textColor=[UIColor grayColor];

        }
        
    }
    return self;
}

// ===
// 2015 - 10 - 28 新增小红点功能
- (void)setRedPoint
{
    // 查询数据库 是否存在未读message
    AlarmDAO *alarmDao = [[AlarmDAO alloc] init];
    NSMutableArray *allarr = [alarmDao findAll];
    if (allarr.count) {
        for (Alarm *alarm in allarr) {
            if (alarm.isRead == 0) { // 直到有未读消息
                self.red_point.hidden = NO;
                return;
            }
        }
        // 如果走到这里就说明 没有未读消息
        self.red_point.hidden = YES;
    }else // 数据库没有数据
    {
        self.red_point.hidden = YES;
    }
    
}
//===




-(void)updateItemIcon:(NSInteger)willSelectedIndex{
    
//    UIImageView *backView = [self.backViews objectAtIndex:self.selectedIndex];
    UIImageView *iconView = [self.iconViews objectAtIndex:self.selectedIndex];
    
//    UIImageView *willBackView = [self.backViews objectAtIndex:willSelectedIndex];
    UIImageView *willIconView = [self.iconViews objectAtIndex:willSelectedIndex];
    
    UILabel *label = [self.labelViews objectAtIndex:self.selectedIndex];
     UILabel *willlabel = [self.labelViews objectAtIndex:willSelectedIndex];
    
//    UIImage *backImg = [UIImage imageNamed:@"bg_tab_item.png"];
//    backImg = [backImg stretchableImageWithLeftCapWidth:backImg.size.width*0.5 topCapHeight:backImg.size.height*0.5];
//    backView.image = backImg;
//    [backView setImage:backImg];
//    
//    UIImage *willBackImg = [UIImage imageNamed:@"bg_tab_item_p.png"];
//    willBackImg = [willBackImg stretchableImageWithLeftCapWidth:willBackImg.size.width*0.5 topCapHeight:willBackImg.size.height*0.5];
//    willBackView.image = willBackImg;
//    [willBackView setImage:willBackImg];
    
    switch(self.selectedIndex){
        case 0:
        {
//            UIImage *iconImg = [UIImage imageNamed:@"ic_tab_item_contact.png"];
            UIImage *iconImg = [UIImage imageNamed:@"main_my_cn"];
//            iconImg = [iconImg stretchableImageWithLeftCapWidth:iconImg.size.width*0.5 topCapHeight:iconImg.size.height*0.5];
            [iconView setImage:iconImg];
//            iconView.contentMode = UIViewContentModeScaleAspectFit;
            label.textColor=[UIColor grayColor];
        }
            break;
        case 1:
        {
//            UIImage *iconImg = [UIImage imageNamed:@"ic_tab_item_keyboard.png"];
            UIImage *iconImg = [UIImage imageNamed:@"main_mess-_cn"];
//            iconImg = [iconImg stretchableImageWithLeftCapWidth:iconImg.size.width*0.5 topCapHeight:iconImg.size.height*0.5];
            [iconView setImage:iconImg];
            iconView.contentMode = UIViewContentModeScaleAspectFit;
            label.textColor=[UIColor grayColor];
        }
            break;
        case 2:
        {
//            UIImage *iconImg = [UIImage imageNamed:@"ic_tab_toolbox.png"];
            UIImage *iconImg = [UIImage imageNamed:@"main_video_cn"];
//            iconImg = [iconImg stretchableImageWithLeftCapWidth:iconImg.size.width*0.5 topCapHeight:iconImg.size.height*0.5];
            [iconView setImage:iconImg];
            iconView.contentMode = UIViewContentModeScaleAspectFit;
            label.textColor=[UIColor grayColor];
        }
            break;
        case 3:
        {
//            UIImage *iconImg = [UIImage imageNamed:@"ic_tab_item_setting.png"];
            UIImage *iconImg = [UIImage imageNamed:@"main_setting_cn"];
//            iconImg = [iconImg stretchableImageWithLeftCapWidth:iconImg.size.width*0.5 topCapHeight:iconImg.size.height*0.5];
            [iconView setImage:iconImg];
            iconView.contentMode = UIViewContentModeScaleAspectFit;
            label.textColor=[UIColor grayColor];
        }
            break;
//        case 4:
//        {
//            UIImage *iconImg = [UIImage imageNamed:@"ic_tab_item_setting.png"];
//            iconImg = [iconImg stretchableImageWithLeftCapWidth:iconImg.size.width*0.5 topCapHeight:iconImg.size.height*0.5];
//            [iconView setImage:iconImg];
//        }
//            break;
    }
    
    switch(willSelectedIndex){
        case 0:
        {
//            UIImage *iconImg = [UIImage imageNamed:@"ic_tab_item_contact_p.png"];
             UIImage *iconImg = [UIImage imageNamed:@"main_my_press_cn"];
//            iconImg = [iconImg stretchableImageWithLeftCapWidth:iconImg.size.width*0.5 topCapHeight:iconImg.size.height*0.5];
            [willIconView setImage:iconImg];
//            willIconView.contentMode = UIViewContentModeScaleAspectFit;
            willlabel.textColor=[UIColor colorWithRed:236/255.0 green:120/255.0 blue:33/255.0 alpha:1.0];
        }
            break;
        case 1:
        {
//            UIImage *iconImg = [UIImage imageNamed:@"ic_tab_item_keyboard_p.png"];
             UIImage *iconImg = [UIImage imageNamed:@"main_mess_press-_cn"];
//            iconImg = [iconImg stretchableImageWithLeftCapWidth:iconImg.size.width*0.5 topCapHeight:iconImg.size.height*0.5];
            [willIconView setImage:iconImg];
            willIconView.contentMode = UIViewContentModeScaleAspectFit;
            willlabel.textColor=[UIColor colorWithRed:236/255.0 green:120/255.0 blue:33/255.0 alpha:1.0];
        }
            break;
        case 2:
        {
//            UIImage *iconImg = [UIImage imageNamed:@"ic_tab_toolbox_p.png"];
             UIImage *iconImg = [UIImage imageNamed:@"main_video_press_cn"];
//            iconImg = [iconImg stretchableImageWithLeftCapWidth:iconImg.size.width*0.5 topCapHeight:iconImg.size.height*0.5];
            [willIconView setImage:iconImg];
            willIconView.contentMode = UIViewContentModeScaleAspectFit;
            willlabel.textColor=[UIColor colorWithRed:236/255.0 green:120/255.0 blue:33/255.0 alpha:1.0];
        }
            break;
        case 3:
        {
//            UIImage *iconImg = [UIImage imageNamed:@"ic_tab_item_setting_p.png"];
             UIImage *iconImg = [UIImage imageNamed:@"main_setting_press_cn"];
//            iconImg = [iconImg stretchableImageWithLeftCapWidth:iconImg.size.width*0.5 topCapHeight:iconImg.size.height*0.5];
            [willIconView setImage:iconImg];
            willIconView.contentMode = UIViewContentModeScaleAspectFit;
            willlabel.textColor=[UIColor colorWithRed:236/255.0 green:120/255.0 blue:33/255.0 alpha:1.0];
            
        }
            break;
//        case 4:
//        {
//            UIImage *iconImg = [UIImage imageNamed:@"ic_tab_item_setting_p.png"];
//            iconImg = [iconImg stretchableImageWithLeftCapWidth:iconImg.size.width*0.5 topCapHeight:iconImg.size.height*0.5];
//            [willIconView setImage:iconImg];
//        }
//            break;
    }
    
    self.selectedIndex = willSelectedIndex;
}
@end
