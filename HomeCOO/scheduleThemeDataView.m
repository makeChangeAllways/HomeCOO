//
//  scheduleThemeDataView.m
//  HomeCOO
//
//  Created by app on 2016/11/23.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "scheduleThemeDataView.h"
#import "LZXDataCenter.h"
#import "spaceDeviceCollectionViewCell.h"
#import "deviceMessage.h"
#import "deviceMessageTool.h"
#import "deviceSpaceMessageModel.h"
#import "deviceSpaceMessageTool.h"
#import "spaceMessageModel.h"
#import "spaceMessageTool.h"

#import "themMessageModel.h"
#import "themeMessageTool.h"
#import "ControlMethods.h"
#import "PacketMethods.h"
#define daterConterViewWidth  [UIScreen  mainScreen].bounds.size.width/1.3
#define daterConterViewHeight   [UIScreen  mainScreen].bounds.size.height /1.4
#define hcbtnedage    (picker.frame.size.height - 80)/3
#define hclabWidth    50

@interface scheduleThemeDataView ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    
    UIView *daterContentView;
    
    UIButton *onedayBtn;
    UIButton *everyWeakBtn;
    LZXDataCenter *dataCenter;
    UILabel *stateLab;
    UILabel *timelab;
    
    UILabel *firstDayLab;
    UILabel *secondDaylab;
    UILabel *thirthDayLab;
    UILabel *fourthDaylab;
    UILabel *fridayLab;
    UILabel *saturdaylab;
    UILabel *sundayLab;
    
    NSArray *proTimeList;
    NSArray *proTitleList;
    NSMutableArray *btaTag;
    NSString *time;
    
    UIDatePicker * picker;
    UIPickerView *timeView;
    
    UIButton *firstDayBtn;
    UIButton *secondDayBtn;
    UIButton *thirthDayBtn;
    UIButton *fourthDayBtn;
    UIButton *fridayBtn;
    UIButton *saturdayBtn;
    UIButton *sundayBtn;
   
    UIButton *cancelBtn;
    UIButton *sureBtn;
    
}

@end

@implementation scheduleThemeDataView

#pragma mark - init初始化
- (void)initViews{
    
    self.frame=[UIScreen mainScreen].bounds;
    self.backgroundColor=RGBA(0, 0, 0, 0.3);
    
    dataCenter = [LZXDataCenter defaultDataCenter];
    
    self.currentTag = 1;
    
    [self controlThemeCommand];

    daterContentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,daterConterViewWidth , daterConterViewHeight)];
    
    daterContentView.center = self.center;
    
    [self addSubview:daterContentView];
    daterContentView.layer.masksToBounds=YES;
    daterContentView.layer.cornerRadius=8;
    daterContentView.backgroundColor = RGBA(226,186,88,1.0);
    
    onedayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    onedayBtn.frame = CGRectMake(0, 0, daterContentView.frame.size.width/2, 40);
    [onedayBtn setTitle:@"单 次" forState:UIControlStateNormal];
    onedayBtn.showsTouchWhenHighlighted=YES;
    
    [onedayBtn setTitleColor:[UIColor  orangeColor] forState:UIControlStateHighlighted];
    [onedayBtn addTarget:self action:@selector(oneAction:) forControlEvents:UIControlEventTouchUpInside];
    onedayBtn.backgroundColor=[UIColor lightGrayColor];
    
    [daterContentView addSubview:onedayBtn];
    everyWeakBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    everyWeakBtn.frame = CGRectMake(CGRectGetMaxX(onedayBtn.frame), 0, daterContentView.frame.size.width/2, 40);
    [everyWeakBtn setTitle:@"每 周" forState:UIControlStateNormal];
    everyWeakBtn.showsTouchWhenHighlighted=YES;
    
    [everyWeakBtn addTarget:self action:@selector(everyAction:) forControlEvents:UIControlEventTouchUpInside];
    [everyWeakBtn setTitleColor:[UIColor  orangeColor] forState:UIControlStateHighlighted];
    
    everyWeakBtn.backgroundColor=[UIColor lightGrayColor];
    
    [daterContentView addSubview:everyWeakBtn];
    
    stateLab=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(onedayBtn.frame), daterContentView.w, 60)];
    stateLab.textAlignment = 0;
    stateLab.text = dataCenter.theme_Name;
    stateLab.font = [UIFont  systemFontOfSize:15];
    [daterContentView addSubview:stateLab];
    
    timelab=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(stateLab.frame), 100, 40)];
    timelab.textAlignment = 1;
    timelab.text = @"设定定时时间:";
    timelab.font = [UIFont  systemFontOfSize:15];
    
    [daterContentView addSubview:timelab];
    
    picker=[[UIDatePicker alloc]initWithFrame:CGRectMake(CGRectGetMaxX(timelab.frame)+5, CGRectGetMaxY(stateLab.frame), daterConterViewWidth-95,daterConterViewHeight-50- CGRectGetMaxY(stateLab.frame))];
    [daterContentView addSubview:picker];
    
    
    timeView = [[UIPickerView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(picker.frame)-picker.frame.size.width/2, CGRectGetMaxY(stateLab.frame), picker.frame.size.width/3, picker.frame.size.height)];
    // 显示选中框
    timeView.showsSelectionIndicator=YES;
    timeView.dataSource = self;
    timeView.delegate = self;
    timeView.hidden = YES;
    //timeView.backgroundColor  =[UIColor  redColor];
    proTitleList  = [[NSArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",nil];
    proTimeList = [[NSArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",nil];
    
    btaTag  = [[NSMutableArray alloc]initWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0",@"0"]];
    
    self.hour = @"1";
    self.munite = @"1";
    [daterContentView addSubview:timeView];
    
    firstDayBtn = [[UIButton  alloc]initWithFrame:CGRectMake(CGRectGetMinX(timeView.frame) -140, CGRectGetMaxY(stateLab.frame), 20, 20)];
    [firstDayBtn  setImage:[UIImage  imageNamed:@"checkOff.jpg"] forState:UIControlStateNormal];
    [firstDayBtn  setImage:[UIImage  imageNamed:@"checkOn.jpg"] forState:UIControlStateSelected];
    [firstDayBtn  addTarget:self action:@selector(checkBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    firstDayBtn.tag = 100;
    [daterContentView addSubview:firstDayBtn];
    
    secondDayBtn = [[UIButton  alloc]initWithFrame:CGRectMake(CGRectGetMinX(timeView.frame) -140,CGRectGetMaxY(firstDayBtn.frame) +hcbtnedage, 20, 20)];
    [secondDayBtn  setImage:[UIImage  imageNamed:@"checkOff.jpg"] forState:UIControlStateNormal];
    [secondDayBtn  setImage:[UIImage  imageNamed:@"checkOn.jpg"] forState:UIControlStateSelected];
    [secondDayBtn  addTarget:self action:@selector(checkBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    secondDayBtn.tag = 200;
    [daterContentView addSubview:secondDayBtn];
    
    thirthDayBtn = [[UIButton  alloc]initWithFrame:CGRectMake(CGRectGetMinX(timeView.frame) -140, CGRectGetMaxY(secondDayBtn.frame) +hcbtnedage, 20, 20)];
    [thirthDayBtn  setImage:[UIImage  imageNamed:@"checkOff.jpg"] forState:UIControlStateNormal];
    [thirthDayBtn  setImage:[UIImage  imageNamed:@"checkOn.jpg"] forState:UIControlStateSelected];
    [thirthDayBtn  addTarget:self action:@selector(checkBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    thirthDayBtn.tag = 300;
    [daterContentView addSubview:thirthDayBtn];
    
    fourthDayBtn = [[UIButton  alloc]initWithFrame:CGRectMake(CGRectGetMinX(timeView.frame) -140, CGRectGetMaxY(thirthDayBtn.frame) +hcbtnedage, 20, 20)];
    [fourthDayBtn  setImage:[UIImage  imageNamed:@"checkOff.jpg"] forState:UIControlStateNormal];
    [fourthDayBtn  setImage:[UIImage  imageNamed:@"checkOn.jpg"] forState:UIControlStateSelected];
    [fourthDayBtn  addTarget:self action:@selector(checkBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    fourthDayBtn.tag = 400;
    [daterContentView addSubview:fourthDayBtn];
    
    fridayBtn = [[UIButton  alloc]initWithFrame:CGRectMake(CGRectGetMaxX(firstDayBtn.frame)+hclabWidth, CGRectGetMaxY(firstDayBtn.frame), 20, 20)];
    [fridayBtn  setImage:[UIImage  imageNamed:@"checkOff.jpg"] forState:UIControlStateNormal];
    [fridayBtn  setImage:[UIImage  imageNamed:@"checkOn.jpg"] forState:UIControlStateSelected];
    [fridayBtn  addTarget:self action:@selector(checkBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    fridayBtn.tag = 500;
    [daterContentView addSubview:fridayBtn];
    
    saturdayBtn = [[UIButton  alloc]initWithFrame:CGRectMake(CGRectGetMaxX(firstDayBtn.frame)+hclabWidth, CGRectGetMaxY(secondDayBtn.frame), 20, 20)];
    [saturdayBtn  setImage:[UIImage  imageNamed:@"checkOff.jpg"] forState:UIControlStateNormal];
    [saturdayBtn  setImage:[UIImage  imageNamed:@"checkOn.jpg"] forState:UIControlStateSelected];
    [saturdayBtn  addTarget:self action:@selector(checkBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    saturdayBtn.tag = 600;
    [daterContentView addSubview:saturdayBtn];
    
    sundayBtn = [[UIButton  alloc]initWithFrame:CGRectMake(CGRectGetMaxX(firstDayBtn.frame)+hclabWidth, CGRectGetMaxY(thirthDayBtn.frame), 20, 20)];
    [sundayBtn  setImage:[UIImage  imageNamed:@"checkOff.jpg"] forState:UIControlStateNormal];
    [sundayBtn  setImage:[UIImage  imageNamed:@"checkOn.jpg"] forState:UIControlStateSelected];
    [sundayBtn  addTarget:self action:@selector(checkBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    sundayBtn.tag = 700;
    
    [daterContentView addSubview:sundayBtn];
    
    firstDayLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(firstDayBtn.frame), CGRectGetMaxY(stateLab.frame), hclabWidth, 20)];
    firstDayLab.textAlignment = 1;
    firstDayLab.text = @"星期一";
    //stateLab.backgroundColor = [UIColor  blueColor];
    firstDayLab.font = [UIFont  systemFontOfSize:10];
    
    [daterContentView addSubview:firstDayLab];
    
    secondDaylab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(firstDayBtn.frame), CGRectGetMaxY(firstDayLab.frame)+hcbtnedage, hclabWidth, 20)];
    secondDaylab.textAlignment = 1;
    secondDaylab.text = @"星期二";
    // secondDaylab.backgroundColor = [UIColor  blueColor];
    secondDaylab.font = [UIFont  systemFontOfSize:10];
    
    [daterContentView addSubview:secondDaylab];
    
    
    thirthDayLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(firstDayBtn.frame), CGRectGetMaxY(secondDaylab.frame)+hcbtnedage, hclabWidth, 20)];
    thirthDayLab.textAlignment = 1;
    thirthDayLab.text = @"星期三";
    
    thirthDayLab.font = [UIFont  systemFontOfSize:10];
    
    [daterContentView addSubview:thirthDayLab];
    
    fourthDaylab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(firstDayBtn.frame), CGRectGetMaxY(thirthDayLab.frame)+hcbtnedage, hclabWidth, 20)];
    fourthDaylab.textAlignment = 1;
    fourthDaylab.text = @"星期四";
    //stateLab.backgroundColor = [UIColor  blueColor];
    fourthDaylab.font = [UIFont  systemFontOfSize:10];
    [daterContentView addSubview:fourthDaylab];
    
    fridayLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(fridayBtn.frame), CGRectGetMaxY(firstDayLab.frame), hclabWidth, 20)];
    fridayLab.textAlignment = 1;
    fridayLab.text = @"星期五";
    
    fridayLab.font = [UIFont  systemFontOfSize:10];
    
    [daterContentView addSubview:fridayLab];
    
    saturdaylab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(fridayBtn.frame), CGRectGetMaxY(fridayLab.frame)+hcbtnedage, hclabWidth, 20)];
    saturdaylab.textAlignment = 1;
    saturdaylab.text = @"星期六";
    
    saturdaylab.font = [UIFont  systemFontOfSize:10];
    
    [daterContentView addSubview:saturdaylab];
    
    sundayLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(fridayBtn.frame), CGRectGetMaxY(saturdaylab.frame)+hcbtnedage, hclabWidth, 20)];
    sundayLab.textAlignment = 1;
    sundayLab.text = @"星期日";
    sundayLab.font = [UIFont  systemFontOfSize:10];
    
    [daterContentView addSubview:sundayLab];
    firstDayBtn.hidden = YES;
    firstDayLab.hidden = YES;
    secondDaylab.hidden = YES;
    secondDayBtn.hidden = YES;
    thirthDayBtn.hidden = YES;
    thirthDayLab.hidden = YES;
    fourthDaylab.hidden = YES;
    fourthDayBtn.hidden = YES;
    fridayBtn.hidden = YES;
    fridayLab.hidden = YES;
    saturdaylab.hidden = YES;
    saturdayBtn.hidden = YES;
    sundayLab.hidden = YES;
    sundayBtn.hidden = YES;
    
    cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, daterConterViewHeight-50, daterContentView.frame.size.width/2, 50);
    
    [cancelBtn setTitle:@"取 消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    self.cancleBtn = cancelBtn;
    [daterContentView addSubview:cancelBtn];
    cancelBtn.backgroundColor=[UIColor lightGrayColor];
    
    sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(CGRectGetMaxX(cancelBtn.frame),daterConterViewHeight-50, daterContentView.frame.size.width/2, 50);
    [sureBtn setTitle:@"确 定" forState:UIControlStateNormal];
    
    [sureBtn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    self.sureBtn = sureBtn;
    [daterContentView addSubview:sureBtn];
    sureBtn.backgroundColor=[UIColor lightGrayColor];
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        
        [self initViews];
        
        
        
    }
    return self;
}



#pragma mark - Public Methods
- (void)showInView:(UIView *)aView animated:(BOOL)animated{
    [aView addSubview:self];
    if (animated) {
        [self fadeIn];
    }
}

-(void)hiddenInView:(UIView *)aView animated:(BOOL)animated{
    
    if (animated) {
        [self fadeOut];
    }
    
}



#pragma mark - Private Methods
- (void)fadeIn{
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
    }];
    
}
- (void)fadeOut{
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 0.0;
    }completion:^(BOOL finished) {
        if (finished){
            [self removeFromSuperview];
        }
    }];
}


#pragma mark - delegate
- (void)sureAction:(UIButton *)sender{

    NSDate *theDate =picker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];//返回一个日期格式对象
    dateFormatter.dateFormat = @"YYYYMMddHHmm";//该属性用于设置日期格式为YYYY-MM-dd HH-mm-ss
    time = [dateFormatter stringFromDate:theDate];
    //NSLog(@"time %@",time);
    self.dateStr = [dateFormatter stringFromDate:theDate];
    
    NSString *hour = [time  substringWithRange:NSMakeRange(8, 2)];
    NSString *munite = [time substringWithRange:NSMakeRange(10, 2)];
    NSString *string1;
    NSString *string2;
    
    NSString *years =  [time  substringWithRange:NSMakeRange(0, 4)];
    NSString *months = [time  substringWithRange:NSMakeRange(4, 2)];
    NSString *day = [time  substringWithRange:NSMakeRange(6, 2)];
    NSString *string4 = [years stringByAppendingString:@"-"];
    NSString *string5 = [string4  stringByAppendingString:months];
    NSString *string6 = [string5 stringByAppendingString:@"-"];
    NSString *date = [string6  stringByAppendingString:day];
    
    if (picker.hidden == YES) {
        
        string1 = [self.hour  stringByAppendingString:@":"];
        string2 = [string1 stringByAppendingString:self.munite];
        
    }else{
        string1 = [hour  stringByAppendingString:@":"];
        string2 = [string1 stringByAppendingString:munite];
    }
    
    self.shijian = [string2 stringByAppendingString:@":00"];
    self.riqi = date;

    if (self.currentTag ==1) {
        
        self.state = @"1";
        self.stratege  =@"1";
        
        
    }else{
        self.state = @"0";
        self.stratege  =@"2";

      
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(makeSureClicked:)]) {
        
        [self.delegate makeSureClicked:self];
    }

    [self fadeOut];
    
}
- (void)cancelAction:(UIButton *)sender{
    
    [self fadeOut];
}

-(void)controlThemeCommand{
    
    NSString *dev_type;
    
    
    if ([dataCenter.device_No  isEqualToString:@"00000000"]) {//如果是自定义情景
        
        dev_type = @"0100";//自定义情景 任意填 硬件情景就是202 CA00
        
    }else{//如果是硬件情景
        
        dev_type = @"CA00";//自定义情景 任意填 硬件情景就是202 CA00
        
    }
    
    NSString *header = @"42424141";//发送给服务器的报头
    
    NSString *stamp = @"00000000";//没有用到的字段
    
    NSString *gw_id = dataCenter.gatewayNo;
    
    NSString *dev_id = dataCenter.device_No;
    
    NSString *data_type = @"0d00";//控制情景 13
    
    NSString *data_len = @"0010";
    
    NSString *theme_no = dataCenter.theme_No;
    
    NSString *theme_state = [ControlMethods  transThemeCoding:dataCenter.theme_State];
    
    NSString *data = [theme_no stringByAppendingString:theme_state];
    
    //拼接发送报文
    NSString *packet = [PacketMethods  devicePacket:header getStamp:stamp getGw_id:gw_id getDev_id:dev_id getDev_type:dev_type getData_type:data_type getData_len:data_len getData:data];
    
    
    NSString *deviceControlPacketStr = [packet stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
    self.packData = deviceControlPacketStr;
    
}

-(void)oneAction:(UIButton *)sender{
    self.currentTag = 1;
    timeView.hidden = YES;
    picker.hidden = NO;
    timelab.hidden = NO;
    firstDayBtn.hidden = YES;
    firstDayLab.hidden = YES;
    secondDaylab.hidden = YES;
    secondDayBtn.hidden = YES;
    thirthDayBtn.hidden = YES;
    thirthDayLab.hidden = YES;
    fourthDaylab.hidden = YES;
    fourthDayBtn.hidden = YES;
    fridayBtn.hidden = YES;
    fridayLab.hidden = YES;
    saturdaylab.hidden = YES;
    saturdayBtn.hidden = YES;
    sundayLab.hidden = YES;
    sundayBtn.hidden = YES;
    daterContentView.backgroundColor = RGBA(226,186,88,1.0);


}

-(void)everyAction:(UIButton *)sender{
    
    self.currentTag = 2;
    
    picker.hidden = YES;
    timeView.hidden = NO;
    timelab.hidden = YES;
    firstDayBtn.hidden = NO;
    firstDayLab.hidden = NO;
    secondDaylab.hidden = NO;
    secondDayBtn.hidden = NO;
    thirthDayBtn.hidden = NO;
    thirthDayLab.hidden = NO;
    fourthDaylab.hidden = NO;
    fourthDayBtn.hidden = NO;
    fridayBtn.hidden = NO;
    fridayLab.hidden = NO;
    saturdaylab.hidden = NO;
    saturdayBtn.hidden = NO;
    sundayLab.hidden = NO;
    sundayBtn.hidden = NO;
    daterContentView.backgroundColor = RGBA(208,251,120,1.0);
    
}

-(void)checkBtnAction:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    switch (sender.tag) {
            
        case 100:
            if (sender.selected) {
                [btaTag replaceObjectAtIndex:0 withObject:@"1"];
            }else{
                
                [btaTag replaceObjectAtIndex:0 withObject:@"0"];
            }
            
            break;
        case 200:
            if (sender.selected) {
                [btaTag replaceObjectAtIndex:1 withObject:@"1"];
            }else{
                [btaTag replaceObjectAtIndex:1 withObject:@"0"];
            }
            
            break;
            
        case 300:
            if (sender.selected) {
                [btaTag replaceObjectAtIndex:2 withObject:@"1"];
            }else{
                [btaTag replaceObjectAtIndex:2 withObject:@"0"];
            }
            
            break;
            
        case 400:
            if (sender.selected) {
                [btaTag replaceObjectAtIndex:3 withObject:@"1"];
            }else{
                [btaTag replaceObjectAtIndex:3 withObject:@"0"];
            }
            
            break;
            
        case 500:
            if (sender.selected) {
                [btaTag replaceObjectAtIndex:4 withObject:@"1"];
            }else{
                [btaTag replaceObjectAtIndex:4 withObject:@"0"];
            }
            
            break;
            
        case 600:
            if (sender.selected) {
                [btaTag replaceObjectAtIndex:5 withObject:@"1"];
            }else{
                [btaTag replaceObjectAtIndex:5 withObject:@"0"];
            }
            
            break;
            
        case 700:
            if (sender.selected) {
                [btaTag replaceObjectAtIndex:6 withObject:@"1"];
            }else{
                [btaTag replaceObjectAtIndex:6 withObject:@"0"];
            }
            
            break;
            
    }
    
    NSString * xingqi = [NSString stringWithFormat:@""];
    
    for (int  i = 0; i < [btaTag count] ; i ++ ) {
        xingqi  = [xingqi stringByAppendingString:[btaTag objectAtIndex:i]];
    }
    
    self.xingqi = xingqi;
   
}


#pragma mark - UIpickView delegate
//设置列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    
    return 2;
}

//给每列设置行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0) {
        return [proTitleList count];
    }
    return [proTimeList count];
}

//设置每一行的内容
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (component == 0) {
        return [proTitleList objectAtIndex:row];
    } else {
        return [proTimeList objectAtIndex:row];
    }
}

//当某一列选中的行数发生变化时调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    NSString  *_proNameStr;
    NSString  *_proTimeStr;
    
    if (component == 0) {
        _proNameStr = [proTitleList objectAtIndex:row];
        //NSLog(@"nameStr=%@",_proNameStr);
        self.hour = _proNameStr;
    } else {
        _proTimeStr = [proTimeList objectAtIndex:row];
        self.munite = _proTimeStr;
        //NSLog(@"_proTimeStr=%@",_proTimeStr);
    }
    
}


@end
@implementation UIView (Category)

#pragma mark-- setter,getter方法(深度赋值，取值)--
- (void) setX:(CGFloat)x{
    CGRect frame=self.frame;
    frame=CGRectMake(x, frame.origin.y, frame.size.width, frame.size.height);
    self.frame=frame;
}
- (CGFloat)x{
    return self.frame.origin.x;
}
- (void) setY:(CGFloat)y{
    CGRect frame=self.frame;
    frame=CGRectMake(frame.origin.x, y, frame.size.width, frame.size.height);
    self.frame=frame;
}
- (CGFloat)y{
    return self.frame.origin.y;
}
- (void) setW:(CGFloat)w{
    CGRect frame=self.frame;
    frame=CGRectMake(frame.origin.x, frame.origin.y, w, frame.size.height);
    self.frame=frame;
}
- (CGFloat)w{
    return self.frame.size.width;
}
- (void) setH:(CGFloat)h{
    CGRect frame=self.frame;
    frame=CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, h);
    self.frame=frame;
}
- (CGFloat)h{
    return self.frame.size.height;
}

@end
