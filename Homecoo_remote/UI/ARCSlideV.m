//
//  ARCSlideV.m
//  IRBT
//
//  Created by wsz on 16/9/27.
//  Copyright © 2016年 wsz. All rights reserved.
//

#import "ARCSlideV.h"
#import "PrefixHeader.pch"
#define SlideV_Center_X (self.bounds.size.width/2.0)
#define SlideV_Center_Y (self.bounds.size.height/2.0)

#define SlideV_Circle_radius 120.0

#define SlideV_Circle_Start_Radian (M_PI*(5.0/8.0))
#define SlideV_Circle_End_Radian   (M_PI*(19.0/8.0))

@interface ARCSlideV ()

//@property (nonatomic,strong)CAShapeLayer *shapLayer; width
//@property (nonatomic,strong)UIImageView  *indicator;height


@end

@implementation ARCSlideV

- (void)layoutIfNeeded
{
    [super layoutIfNeeded];
    
    //[self bglayer];
    
    [self disLabel];
   // [self indicator];
}


- (void)bglayer
{
    CAShapeLayer *bgLayer = [CAShapeLayer layer];
    bgLayer.path = [self getBezierPathWithRadian:SlideV_Circle_End_Radian].CGPath;
    bgLayer.lineCap = kCALineCapRound;
    bgLayer.strokeColor = [UIColor colorWithRed:103.0/255.0 green:181.0/255.0 blue:245.0/255.0 alpha:1.0].CGColor;
    bgLayer.lineWidth = 10;
    bgLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:bgLayer];
}

//- (CAShapeLayer *)shapLayer
//{
//    if(!_shapLayer)
//    {
//        _shapLayer = [CAShapeLayer layer];
//        _shapLayer.path = [self getBezierPathWithRadian:1].CGPath;
//        _shapLayer.lineCap = kCALineCapRound;
//        _shapLayer.strokeColor = [UIColor colorWithRed:17.0/255.0 green:129.0/255.0 blue:1.0 alpha:1.0].CGColor;
//        _shapLayer.lineWidth = 10;
//        _shapLayer.fillColor = [UIColor clearColor].CGColor;
//        [self.layer addSublayer:_shapLayer];
//    }
//    
//    return _shapLayer;
//}
//
//- (UIImageView *)indicator
//{
//    if(!_indicator)
//    {
//        _indicator = [[UIImageView alloc] init];
//        _indicator.image = [UIImage imageNamed:@"pointer_small"];
//        [self addSubview:_indicator];
//        [self bringSubviewToFront:_indicator];
//        [_indicator mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake((self.bounds.size.width/2.0-60)*2+320, (self.bounds.size.width/2.0-60)*2+320));
//            make.center.mas_equalTo(self);
//        }];
//        
//        _indicator.transform = CGAffineTransformRotate(self.indicator.transform, -(M_PI*(7.0/8.0)));
//    }
//    return _indicator;
//}

- (UILabel *)disLabel
{
    if(!_disLabel)
    {
        _disLabel = [[UILabel alloc] init];
        //_disLabel.font = [UIFont fontWithName:@"DS-Digital-Italic" size:80];
        _disLabel.textColor = [UIColor colorWithRed:17.0/255.0 green:129.0/255.0 blue:1.0 alpha:1.0];
        
        [self addSubview:_disLabel];
       
        [_disLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.equalTo(self);
//            make.height.equalTo(self.mas_height);
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).with.offset(-30);
           
        }];
    }
    return _disLabel;
}

- (UIBezierPath *)getBezierPathWithRadian:(CGFloat)radian
{
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(SlideV_Center_X, SlideV_Center_Y)
                                                        radius:SlideV_Circle_radius
                                                    startAngle:SlideV_Circle_Start_Radian
                                                      endAngle:radian
                                                     clockwise:YES];
    return path;
}

- (NSString *)getTextByRadian:(float)radian
{
    return [NSString stringWithFormat:@"%d",(int)round((radian-SlideV_Circle_Start_Radian)/M_PI*8)+16];
}

- (CGPoint)getIndicatorCenterWithTouchPoint:(CGPoint)point
{
    float scale = (SlideV_Circle_radius+5)/powf(powf((point.x-SlideV_Center_X), 2)+powf((point.y-SlideV_Center_Y), 2), 0.5);
    return CGPointMake(scale*point.x, scale*point.y);
}

#pragma mark -
#pragma mark -

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    CGPoint point = [touch  locationInView:self];
//    [self driveUIWithPoint:point];
//}
//
//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    CGPoint point = [touch  locationInView:self];
//    
//    if([self pointInside:point withEvent:event])
//    {
//        [self driveUIWithPoint:point];
//    }
//}
//
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    self.didSelecTemperature([self.disLabel.text integerValue]);
//}

//- (void)driveUIWithPoint:(CGPoint)point
//{
//    float distanceX = point.x-SlideV_Center_X;
//    float distanceY = point.y-SlideV_Center_Y;
//    
//
//    float dis = pow(pow(distanceX, 2)+pow(distanceY, 2), 0.5);
//    if(dis-SlideV_Circle_radius<-60||dis-SlideV_Circle_radius>40)
//    {
//        return;
//    }
//    
//    float radian = 0.0;
//
//    if(distanceX<=0&&distanceY>=0)
//    {
//        radian = atanf(fabs(distanceX)/fabs(distanceY));
//        radian = M_PI/2.0+radian;
//        if(radian<SlideV_Circle_Start_Radian)return;
//    }
//    else if(distanceX<=0&&distanceY<=0)
//    {
//        radian = atanf(fabs(distanceY)/fabs(distanceX));
//        radian = M_PI+radian;
//    }
//    else if(distanceX>=0&&distanceY<=0)
//    {
//        radian = atanf(fabs(distanceX)/fabs(distanceY));
//        radian = M_PI/2.0*3.0+radian;
//    }
//    else
//    {
//        radian = atanf(fabs(distanceY)/fabs(distanceX));
//        radian = M_PI/2.0*4.0+radian;
//        if(radian>SlideV_Circle_End_Radian)return;
//    }
//    self.shapLayer.path = [self getBezierPathWithRadian:radian].CGPath;
//    [self.shapLayer setNeedsDisplay];
//    
//    self.disLabel.text = [self getTextByRadian:radian];
//    self.indicator.transform = CGAffineTransformMakeRotation(radian+M_PI/2);
//}


@end
