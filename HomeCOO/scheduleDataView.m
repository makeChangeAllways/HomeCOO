//
//  scheduleDataView.m
//  HomeCOO
//
//  Created by app on 2016/11/15.
//  Copyright © 2016年 Jiaoda. All rights reserved.
//

#import "scheduleDataView.h"
#import "LZXDataCenter.h"
#import "spaceDeviceCollectionViewCell.h"
#import "deviceMessage.h"
#import "deviceMessageTool.h"
#import "deviceSpaceMessageModel.h"
#import "deviceSpaceMessageTool.h"
#import "spaceMessageModel.h"
#import "spaceMessageTool.h"

#import "ControlMethods.h"
#import "PacketMethods.h"
#define daterConterViewWidth  [UIScreen  mainScreen].bounds.size.width/1.3
#define daterConterViewHeight   [UIScreen  mainScreen].bounds.size.height /1.4
#define hcbtnedage    (picker.frame.size.height - 80)/3
#define hclabWidth    50

@interface scheduleDataView ()<UIPickerViewDelegate,UIPickerViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{

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
   
    UICollectionViewFlowLayout *flowLayout;
    UICollectionView  *CollectionView;
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
    spaceDeviceCollectionViewCell *cell;
    UIButton *cancelBtn;
    UIButton *sureBtn;
    
}

@end
static NSString *string = @"spaceDeviceCollectionViewCell";
static char arry[4] = {'0','0','0','0'};

@implementation scheduleDataView

#pragma mark - init初始化
- (void)initViews{
    self.frame=[UIScreen mainScreen].bounds;
    self.backgroundColor=RGBA(0, 0, 0, 0.3);
   
    dataCenter = [LZXDataCenter defaultDataCenter];
    self.currentTag = 1;
   
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
    
    stateLab=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(onedayBtn.frame), 100, 60)];
    stateLab.textAlignment = 1;
    stateLab.text = @"设定设备状态:";
    stateLab.font = [UIFont  systemFontOfSize:15];
    [daterContentView addSubview:stateLab];
    
    flowLayout=[[UICollectionViewFlowLayout alloc] init];
    
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    CollectionView = [[UICollectionView  alloc]initWithFrame:CGRectMake(CGRectGetMaxX(stateLab.frame), CGRectGetMaxY(onedayBtn.frame), daterContentView.w-100, 60) collectionViewLayout:flowLayout];
    CollectionView.bounces = NO;//没有效果
    CollectionView.dataSource=self;
    CollectionView.delegate=self;
    CollectionView.backgroundColor = [UIColor  clearColor];
    [CollectionView registerClass:[spaceDeviceCollectionViewCell class] forCellWithReuseIdentifier:string];
    [daterContentView  addSubview:CollectionView];

    timelab=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(stateLab.frame), 100, 40)];
    timelab.textAlignment = 1;
    timelab.text = @"设定定时时间:";
    //timelab.backgroundColor = [UIColor  redColor];
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
   
    firstDayLab.font = [UIFont  systemFontOfSize:10];
    
    [daterContentView addSubview:firstDayLab];
    
    secondDaylab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(firstDayBtn.frame), CGRectGetMaxY(firstDayLab.frame)+hcbtnedage, hclabWidth, 20)];
    secondDaylab.textAlignment = 1;
    secondDaylab.text = @"星期二";

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
   
    self.riqi = date;
    self.shijian =[string2 stringByAppendingString:@":00"];
    
    deviceMessage *devicess = [[deviceMessage alloc]init];
    
    devicess.DEVICE_NO = dataCenter.scheduleDeviceId;
    devicess.GATEWAY_NO = dataCenter.gatewayNo;
    
    deviceMessage *device =  [deviceMessageTool queryWithDeviceNumDevices:devicess]
    [0];
    
    if (device.DEVICE_TYPE_ID==1 |device.DEVICE_TYPE_ID==2|device.DEVICE_TYPE_ID==3|device.DEVICE_TYPE_ID==4|device.DEVICE_TYPE_ID==5|device.DEVICE_TYPE_ID==6|device.DEVICE_TYPE_ID==8|device.DEVICE_TYPE_ID==11|device.DEVICE_TYPE_ID==110|device.DEVICE_TYPE_ID==113|device.DEVICE_TYPE_ID==115|device.DEVICE_TYPE_ID==118|device.DEVICE_TYPE_ID==202|device.DEVICE_TYPE_ID ==105) {
        if (device.DEVICE_TYPE_ID ==105) {
            
            self.state = @"4";
            if (self.currentTag ==1) {
                self.stratge =@"1";
            }else{
                 self.stratge =@"2";
            }
            
        }else{
            if (self.currentTag ==1) {
                self.state =@"1";
                self.stratge =@"1";
            }else{
                self.state =@"0";
                self.stratge =@"2";
            }
            
           
        }
    }else{
        self.state =@"3";
        if (self.currentTag ==1) {
             self.stratge =@"1";
        }else{
         
            self.stratge =@"2";
        }
       
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(makeSureClicked:)]) {
        
        [self.delegate makeSureClicked:self];
    }
    [self fadeOut];
    
}
- (void)cancelAction:(UIButton *)sender{
    
  
    [self fadeOut];
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

#pragma mark - UICollectionView delegate
/**
 *  决定cell的个数
 *
 *  @param collectionView 容器
 *  @param section        章节
 *
 *  @return cell
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    deviceMessage *device = [[deviceMessage alloc]init];
    
    device.GATEWAY_NO = dataCenter.gatewayNo;
    device.DEVICE_NO = dataCenter.scheduleDeviceId;
    
    return  [deviceMessageTool queryWithDeviceNumDevices:device].count;
    
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    cell = [CollectionView dequeueReusableCellWithReuseIdentifier:string forIndexPath:indexPath];
   
    cell.button1.hidden = NO;
    cell.button2.hidden = NO;
    cell.button3.hidden = NO;
    cell.button4.hidden = NO;
    cell.button5.hidden = NO;
    cell.button6.hidden = NO;
    cell.button7.hidden = NO;
    cell.button8.hidden = NO;
    cell.process.hidden = NO;
    cell.button9.hidden = NO;
    cell.button1.selected = NO;
    cell.button2.selected = NO;
    cell.button3.selected = NO;
    cell.button4.selected = NO;
    cell.button5.enabled = YES;
    cell.button6.enabled = YES;
    cell.button7.enabled = YES;
    cell.button8.selected = NO;
    cell.button9.selected = NO;
    
    //先取出模型里的数据
    deviceMessage *devicess = [[deviceMessage alloc]init];
    
    devicess.DEVICE_NO = dataCenter.scheduleDeviceId;
    devicess.GATEWAY_NO = dataCenter.gatewayNo;
    
    deviceMessage *device =  [deviceMessageTool queryWithDeviceNumDevices:devicess]
[indexPath.row];
   
   
    self.deviceName = device.DEVICE_NAME;
    deviceSpaceMessageModel *deviceSpace = [[deviceSpaceMessageModel alloc]init];
    
    deviceSpace.device_no = device.DEVICE_NO;
    deviceSpace.phone_num = dataCenter.userPhoneNum;
    
    NSArray *deviceSpaceAry = [deviceSpaceMessageTool queryWithspacesDeviceNoAndPhonenum:deviceSpace];
    
    if (deviceSpaceAry.count ==0) {
        
        cell.messageLable.text =[NSString  stringWithFormat:@"  位置待定/%@",device.DEVICE_NAME];
        
    }else{
        
        deviceSpaceMessageModel *device_Name = deviceSpaceAry[0];
        
        spaceMessageModel *deviceNameModel = [[spaceMessageModel  alloc]init];
        
        deviceNameModel.space_Num = device_Name.space_no;
        
        spaceMessageModel *deviceName = [spaceMessageTool queryWithspacesDevicePostion:deviceNameModel][0];
        //显示设备位置和设备名称
        cell.messageLable.text =[NSString  stringWithFormat:@"  %@/%@",deviceName.space_Name,device_Name.device_name];
        
    }
    
    if ((device.DEVICE_TYPE_ID ==110)|(device.DEVICE_TYPE_ID ==113)|(device.DEVICE_TYPE_ID ==115)|(device.DEVICE_TYPE_ID ==118)) {
        
        if (dataCenter.scheduleDeviceState==nil) {
            self.arr=device.DEVICE_STATE;
        }else{
        
            self.arr=dataCenter.scheduleDeviceState;
        }
        
    }else{
        if (dataCenter.scheduleDeviceState==nil) {
            self.arr = device.DEVICE_STATE;
        }else{
        
            self.arr = dataCenter.scheduleDeviceState;
        }
        
    
    }
    
    //根据DEVICE_TYPE_ID显示开关个数
    switch (device.DEVICE_TYPE_ID  ) {
            
        case 1:
           
            cell.process.hidden = YES;
            cell.button1.hidden = YES;
            cell.button2.hidden = YES;
            cell.button3.hidden = YES;
            cell.button5.hidden = YES;
            cell.button6.hidden = YES;
            cell.button7.hidden = YES;
            cell.button8.hidden = YES;
            cell.button9.hidden = YES;
            if ([self.arr isEqualToString:@"0"]) {
                
                cell.button4.selected = YES;
                
            }
            
            break;
            
        case 2:
            
            if ([self.arr  isEqualToString:@"00"]) {
                
                cell.button3.selected = YES;
                cell.button4.selected = YES;
                
                
            }
            
            if ([self.arr  isEqualToString:@"10"]) {
                cell.button4.selected = YES;
                
            }
            
            if ([self.arr  isEqualToString:@"01"]) {
                cell.button3.selected = YES;
                
            }
            
            cell.button1.hidden = YES;
            cell.button2.hidden = YES;
            cell.button5.hidden = YES;
            cell.button6.hidden = YES;
            cell.button7.hidden = YES;
            cell.button8.hidden = YES;
            cell.button9.hidden = YES;
            cell.process.hidden = YES;
            break;
            
        case 3:
            
            
            if ([self.arr  isEqualToString:@"100"]) {
                
                cell.button3.selected = YES;
                cell.button4.selected = YES;
                
                
            }
            
            if ([self.arr  isEqualToString:@"101"]) {
                
                cell.button3.selected = YES;
  
            }
            
            if ([self.arr  isEqualToString:@"110"]) {
                cell.button4.selected = YES;
                
            }
            
            if ([self.arr  isEqualToString:@"000"]) {
                
                cell.button2.selected = YES;
                cell.button3.selected = YES;
                cell.button4.selected = YES;
                
                
            }
            
            if ([self.arr  isEqualToString:@"010"]) {
                cell.button2.selected = YES;
                cell.button4.selected = YES;
                
            }
            
            if ([self.arr  isEqualToString:@"001"]) {
                cell.button2.selected =YES;
                cell.button3.selected = YES;
                
            }
            
            if ([self.arr  isEqualToString:@"011"]) {
                
                cell.button2.selected = YES;
                
                
            }
            cell.process.hidden = YES;
            cell.button1.hidden = YES;
            cell.button5.hidden = YES;
            cell.button6.hidden = YES;
            cell.button7.hidden = YES;
            cell.button8.hidden = YES;
            cell.button9.hidden = YES;
            break;
            
        case 4:
            
            if ([self.arr  isEqualToString:@"1011"]) {
                
            
                cell.button2.selected = YES;
                
            }
            
            if ([self.arr  isEqualToString:@"1010"]) {
                cell.button2.selected = YES;
                
                cell.button4.selected = YES;
                
            }
            
            if ([self.arr  isEqualToString:@"1001"]) {
                
                cell.button2.selected = YES;
                cell.button3.selected = YES;
                
                
            }
            if ([self.arr  isEqualToString:@"1000"]) {
                
                cell.button2.selected = YES;
                cell.button3.selected = YES;
                cell.button4.selected = YES;
                
            }
            
            if ([self.arr  isEqualToString:@"0000"]) {
                cell.button1.selected = YES;
                cell.button2.selected = YES;
                cell.button3.selected = YES;
                cell.button4.selected = YES;
            }
            if ([self.arr  isEqualToString:@"1110"]) {
                
                cell.button4.selected = YES;
            }
            
            
            if ([self.arr  isEqualToString:@"1101"]) {
                
                cell.button3.selected = YES;
                
                
            }
            
            if ([self.arr  isEqualToString:@"1100"]) {
                
                cell.button3.selected = YES;
                cell.button4.selected = YES;
                
            }
            if ([self.arr  isEqualToString:@"0011"]) {
                
                cell.button1.selected = YES;
                cell.button2.selected = YES;
                
                
            }
            
            if ([self.arr isEqualToString:@"0010"]) {
                
                cell.button1.selected = YES;
                cell.button2.selected = YES;
                
                cell.button4.selected = YES;
                
            }
            
            if ([self.arr  isEqualToString:@"0001"]) {
                
                cell.button1.selected = YES;
                cell.button2.selected = YES;
                cell.button3.selected = YES;
                
                
            }
            
            
            if ([self.arr  isEqualToString:@"0111"]) {
                
                cell.button1.selected = YES;
                
                
            }
            
            if ([self.arr  isEqualToString:@"0110"]) {
                
                cell.button1.selected = YES;
                
                cell.button4.selected = YES;
            }
            
            if ([self.arr  isEqualToString:@"0101"]) {
                
                cell.button1.selected = YES;
                
                cell.button3.selected = YES;
                
                
            }
            
            if ([self.arr  isEqualToString:@"0100"]) {
                
                cell.button1.selected = YES;
                
                cell.button3.selected = YES;
                cell.button4.selected = YES;
                
            }
            cell.process.hidden = YES;
            cell.button5.hidden = YES;
            cell.button6.hidden = YES;
            cell.button7.hidden = YES;
            cell.button8.hidden = YES;
            cell.button9.hidden = YES;
            break;
            
        case 5:
            
            cell.button1.hidden = YES;
            cell.button2.hidden = YES;
            cell.button3.hidden = YES;
            cell.button4.hidden = YES;
            cell.button5.hidden = YES;
            cell.button6.hidden = YES;
            cell.button7.hidden = YES;
            cell.button8.hidden = YES;
            cell.button9.hidden = YES;
        
            cell.process.value = [self.arr intValue];
            
            break;
        case 6:
            
            cell.button1.hidden = YES;
            cell.button2.hidden = YES;
            cell.button3.hidden = YES;
            cell.button4.hidden = YES;
            cell.button8.hidden = YES;
            cell.process.hidden = YES;
            cell.button9.hidden = YES;
            if ([self.arr  isEqualToString:@"00"]) {//暂停
                
                cell.button6.enabled = NO;
                
            }
            if ([self.arr  isEqualToString:@"01"]) {//关
                
                cell.button7.enabled = NO;
                
            }
            
            if ([self.arr  isEqualToString:@"10"]) {//开
                
                cell.button5.enabled = NO;
                
            }
            
            break;
        case 11:
           
            cell.button1.hidden = YES;
            cell.button2.hidden = YES;
            cell.button3.hidden = YES;
            cell.button4.hidden = YES;
            cell.button8.hidden = YES;
            cell.process.hidden = YES;
            cell.button9.hidden = YES;
            if ([self.arr  isEqualToString:@"00"]) {//暂停
                
                cell.button6.enabled = NO;
                
            }
            if ([self.arr  isEqualToString:@"01"]) {//关
                
                cell.button7.enabled = NO;
                
            }
            
            if ([self.arr  isEqualToString:@"10"]) {//开
                
                cell.button5.enabled = NO;
                
            }
            
            break;
        case 8:
            
            cell.button1.hidden = YES;
            cell.button2.hidden = YES;
            cell.button3.hidden = YES;
            cell.button4.hidden = YES;
            cell.button5.hidden = YES;
            cell.button6.hidden = YES;
            cell.button7.hidden = YES;
            cell.process.hidden = YES;
            cell.button9.hidden = YES;
            if ([self.arr  isEqualToString:@"0"]) {
                
                cell.button8.selected = YES;
                
            }
             
            break;
        case 51:
            
            cell.button1.hidden = YES;
            cell.button2.hidden = YES;
            cell.button3.hidden = YES;
            cell.button4.hidden = YES;
            cell.button5.hidden = YES;
            cell.button6.hidden = YES;
            cell.button7.hidden = YES;
            cell.process.hidden = YES;
            cell.button8.hidden = YES;
            
            if ([self.arr  isEqualToString:@"0"]) {
                
                cell.button9.selected = YES;
                
            }
            
            break;
        case 110:
           
            cell.button1.hidden = YES;
            cell.button2.hidden = YES;
            cell.button3.hidden = YES;
            cell.button4.hidden = YES;
            cell.button5.hidden = YES;
            cell.button6.hidden = YES;
            cell.button7.hidden = YES;
            cell.process.hidden = YES;
            cell.button8.hidden = YES;
            
            if ([[self.arr substringToIndex:2] isEqualToString:@"00"]|[[self.arr substringToIndex:2] isEqualToString:@"10"]) {
                
                cell.button9.selected = YES;
                
            }
            
            break;
            
        case 113:
            
            cell.button1.hidden = YES;
            cell.button2.hidden = YES;
            cell.button3.hidden = YES;
            cell.button4.hidden = YES;
            cell.button5.hidden = YES;
            cell.button6.hidden = YES;
            cell.button7.hidden = YES;
            cell.process.hidden = YES;
            cell.button8.hidden = YES;
            if ([[self.arr substringToIndex:2] isEqualToString:@"00"]|[[self.arr substringToIndex:2] isEqualToString:@"10"]) {
                
                cell.button9.selected = YES;
                
            }
            break;
        case 115:
           
            cell.button1.hidden = YES;
            cell.button2.hidden = YES;
            cell.button3.hidden = YES;
            cell.button4.hidden = YES;
            cell.button5.hidden = YES;
            cell.button6.hidden = YES;
            cell.button7.hidden = YES;
            cell.process.hidden = YES;
            cell.button8.hidden = YES;
            if ([[self.arr substringToIndex:2] isEqualToString:@"10"]|[[self.arr substringToIndex:2] isEqualToString:@"00"]) {
                
                cell.button9.selected = YES;
                
            }
            break;
            
        case 118:
           
            cell.button1.hidden = YES;
            cell.button2.hidden = YES;
            cell.button3.hidden = YES;
            cell.button4.hidden = YES;
            cell.button5.hidden = YES;
            cell.button6.hidden = YES;
            cell.button7.hidden = YES;
            cell.process.hidden = YES;
            cell.button8.hidden = YES;
            if ([[self.arr substringToIndex:2] isEqualToString:@"10"]|[[self.arr substringToIndex:2] isEqualToString:@"00"]) {
                
                cell.button9.selected = YES;
                
            }
            break;
            
    }
    //调用按钮监听方法
    [self  ListeningButtonMethod];
    [self  remoteSwitchOnAction];
    return cell;
}
/**
 *  将字符串数组转换成NSStiring型
 *
 *  @param string 字符串型数组
 *
 *  @return 返回NSString型
 */
-(NSString *)transArryToStr:(char *)string{
    
    NSString *str = [NSString stringWithCString:string encoding:NSASCIIStringEncoding];
    
    return str;
    
}
/**
 *  监听按钮点击事件方法
 */
-(void)ListeningButtonMethod{
    
    //监听按钮点击事件
    [cell.button1  addTarget:self action:@selector(enterChangeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.button2  addTarget:self action:@selector(enterChangeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.button3  addTarget:self action:@selector(enterChangeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.button4  addTarget:self action:@selector(enterChangeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.button5  addTarget:self action:@selector(enterChangeWindowsButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.button6  addTarget:self action:@selector(enterChangeWindowsButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.button7  addTarget:self action:@selector(enterChangeWindowsButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.button8  addTarget:self action:@selector(enterChangeButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell.button9  addTarget:self action:@selector(enterChangeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.process addTarget:self action:@selector(enterChangeProcess:) forControlEvents:UIControlEventValueChanged];
    
}
/**
 *  门窗类开关
 *
 *  @param btn
 */
- (void)enterChangeWindowsButton:(UIButton *)btn {
    
  
    deviceMessage *devicess = [[deviceMessage alloc]init];
    
    devicess.DEVICE_NO = dataCenter.scheduleDeviceId;
    devicess.GATEWAY_NO = dataCenter.gatewayNo;
    
    //取出当前cell的设备信息
    deviceMessage  *dev = [deviceMessageTool queryWithDeviceNumDevices:devicess]
    [0];
    
    btn.enabled = !btn.enabled;
    if (dev.DEVICE_TYPE_ID ==6) {
        switch (btn.tag) {
                
            case 500:
                
                if (!btn.enabled) {
                    
                    
                    arry[0]='1';
                    arry[1]='0';
                    
                    UIButton *myButton1 = (UIButton *)[cell  viewWithTag:600];
                    
                    myButton1.enabled = YES;
                    UIButton *myButton2 = (UIButton *)[cell viewWithTag:700];
                    
                    myButton2.enabled = YES;
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 2)];
                    self.arr = arr;
                    
                }
                
                
                break;
                
            case 600:
                if (!btn.enabled) {
                    
                    arry[0]='0';
                    arry[1]='0';
                    UIButton *myButton1 = (UIButton *)[cell viewWithTag:500];
                    
                    myButton1.enabled = YES;
                    
                    
                    UIButton *myButton2 = (UIButton *)[cell viewWithTag:700];
                    myButton2.enabled = YES;
                    
                    NSString *arr1 =[self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 2)];
                    
                    self.arr = arr;
                  
                }
                
                
                break;
            case 700:
                if (!btn.enabled) {
                    
                    arry[0]='0';
                    arry[1]='1';
                    UIButton *myButton1 = (UIButton *)[cell viewWithTag:600];
                    
                    myButton1.enabled = YES;
                    
                    UIButton *myButton2 = (UIButton *)[cell viewWithTag:500];
                    
                    myButton2.enabled = YES;
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 2)];
                    self.arr = arr;
                   
                }
                
                break;
                
        }
        
    }
    
    if (dev.DEVICE_TYPE_ID ==11) {
        switch (btn.tag) {
                
            case 500:
                
                if (!btn.enabled) {
                    
                    arry[0]='1';
                    arry[1]='0';
                    UIButton *myButton1 = (UIButton *)[cell  viewWithTag:600];
                    
                    myButton1.enabled = YES;
                    
                    UIButton *myButton2 = (UIButton *)[cell viewWithTag:700];
                    
                    
                    myButton2.enabled = YES;
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 2)];
                    self.arr = arr;
                    
                }
                
                
                break;
                
            case 600:
                if (!btn.enabled) {
                    
                    arry[0]='0';
                    arry[1]='0';
                    UIButton *myButton1 = (UIButton *)[cell viewWithTag:500];
                    myButton1.enabled = YES;
                    UIButton *myButton2 = (UIButton *)[cell viewWithTag:700];
                    myButton2.enabled = YES;
                    NSString *arr1 =[self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 2)];
                    
                    self.arr = arr;
                   
                }
                
                break;
            case 700:
                if (!btn.enabled) {
                    
                    arry[0]='0';
                    arry[1]='1';
                    UIButton *myButton1 = (UIButton *)[cell viewWithTag:600];
                    
                    myButton1.enabled = YES;
                    UIButton *myButton2 = (UIButton *)[cell viewWithTag:500];
                    
                    myButton2.enabled = YES;
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 2)];
                    
                    self.arr = arr;
                  
                }
                
                break;
                
        }
        
    }
    [self   remoteSwitchOnAction];
}

/**
 *  调光开关
 *
 *  @param
 */
-(void)enterChangeProcess:(UISlider *)pro{
    
    NSInteger process = pro.value;

    self.arr = [NSString stringWithFormat:@"%ld",(long)process];
 
    [self  remoteSwitchOnAction];
}

/**
 *  按钮监听事件
 *
 *  @param btn
 */
-(void)enterChangeButton:(UIButton *)btn{
    
    deviceMessage *devicess = [[deviceMessage alloc]init];
    
    devicess.DEVICE_NO = dataCenter.scheduleDeviceId;
    devicess.GATEWAY_NO = dataCenter.gatewayNo;
    
    //取出当前cell的设备信息
    //取出当前cell的设备信息
    deviceMessage  *dev = [deviceMessageTool queryWithDeviceNumDevices:devicess]
    [0];
    
    btn.selected = !btn.selected;
    
    if (dev.DEVICE_TYPE_ID ==1) {
        
        switch (btn.tag) {
                
            case 400:
                
                if (!btn.selected) {
                    
                    
//                    memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    memcpy(arry, [self.arr cStringUsingEncoding:NSASCIIStringEncoding],self.arr.length);
                    
                    
                    if (arry[0] == '1') {
                        arry[0] = '0';
                    }
                    else{
                    
                        arry[0] = '1';
                        
                    }
                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 1)];
                    self.arr = arr;
                    
                

                    
                }else{
                    
//                    memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    memcpy(arry, [self.arr cStringUsingEncoding:NSASCIIStringEncoding],self.arr.length);
                    
                    if (arry[0] == '0') {
                        arry[0] = '1';
                    }
                    else{
                    
                        arry[0] = '0';
                        
                    }
                    
                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 1)];
                    self.arr = arr;
                   
                    
                }
                
                break;
                
        }
        
    }
    
    if (dev.DEVICE_TYPE_ID ==2) {
        switch (btn.tag) {
                
            case 400:
                
                if (!btn.selected) {
                    
//                    memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                     memcpy(arry, [self.arr cStringUsingEncoding:NSASCIIStringEncoding],self.arr.length);
                    
                    if (arry[1] == '1') {
                        arry[1] = '0';
                    }
                    else{
                    
                        arry[1] = '1';
                        
                    }
                    
                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 2)];
                    self.arr = arr;
                   
                }else{
//                    memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    memcpy(arry, [self.arr cStringUsingEncoding:NSASCIIStringEncoding],self.arr.length);
                    
                    if (arry[1] == '0') {
                        arry[1] = '1';
                    }
                    else{
                    
                        arry[1] = '0';
                        
                    }
                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 2)];
                    self.arr = arr;
                    
                    
                }
                
                break;
                
            case 300:
                if (!btn.selected) {
                    
//                    memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    memcpy(arry, [self.arr cStringUsingEncoding:NSASCIIStringEncoding],self.arr.length);
                    
                    if (arry[0] == '1') {
                        arry[0] = '0';
                    }
                    else{
                    
                        arry[0] = '1';
                        
                    }
                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 2)];
                    
                    self.arr = arr;
                   
                }else{
//                    memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    memcpy(arry, [self.arr cStringUsingEncoding:NSASCIIStringEncoding],self.arr.length);
                    
                    
                    if (arry[0] == '0') {
                        
                        arry[0] = '1';
                        
                    }
                    else{
                    
                        arry[0] = '0';
                        
                    }
                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 2)];
                    self.arr = arr;
                   
                }
                
            
                break;
                
        }
        
    }
    
    if (dev.DEVICE_TYPE_ID ==3) {
        
        switch (btn.tag) {
                
            case 400:
                
                if (!btn.selected) {
                    
//                    memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],4);
                    memcpy(arry, [self.arr cStringUsingEncoding:NSASCIIStringEncoding],self.arr.length);
                    
                    
                    if (arry[2] == '1') {
                        arry[2] = '0';
                    }
                    else{
                    
                        arry[2] = '1';
                        
                    }
                    
                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 3)];
                    self.arr = arr;
                    
                    
                }else{
                    
//                    memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    memcpy(arry, [self.arr cStringUsingEncoding:NSASCIIStringEncoding],self.arr.length);
                    
                    if (arry[2] == '0') {
                        arry[2] = '1';
                    }
                    else{
                    
                        arry[2] = '0';
                        
                    }
                    
                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 3)];
                    self.arr = arr;
                    
                }
                
                break;
                
            case 300:
                
                if (!btn.selected) {
//                    memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    memcpy(arry, [self.arr cStringUsingEncoding:NSASCIIStringEncoding],self.arr.length);
                    
                    if (arry[1] == '1') {
                        arry[1] = '0';
                    }
                    else{
                    
                        arry[1] = '1';
                        
                    }
                    
                    
                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 3)];
                    
                    self.arr = arr;
                   
                }else{
                    
//                    memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    memcpy(arry, [self.arr cStringUsingEncoding:NSASCIIStringEncoding],self.arr.length);
                    
                    if (arry[1] == '0') {
                        arry[1] = '1';
                    }
                    else{
                    
                        arry[1] = '0';
                        
                    }
                    
                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 3)];
                    self.arr = arr;
                    
                }
                
                break;
            case 200:
                if (!btn.selected) {
                    
//                    memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    memcpy(arry, [self.arr cStringUsingEncoding:NSASCIIStringEncoding],self.arr.length);
                    
                    
                    if (arry[0] == '1') {
                        arry[0] = '0';
                    }
                    else{
                    
                        arry[0] = '1';
                        
                    }
   
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 3)];
                    self.arr = arr;
                   
                }else{
//                    memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    memcpy(arry, [self.arr cStringUsingEncoding:NSASCIIStringEncoding],self.arr.length);
                    
                    if (arry[0] == '0') {
                        arry[0] = '1';
                    }
                    else{
                    
                        arry[0] = '0';
                        
                    }
                    
                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 3)];
                    self.arr = arr;
                    
                }
                
                break;
        }
        
        
    }
    
    if (dev.DEVICE_TYPE_ID ==4) {
        
        
        
        switch (btn.tag) {
                
            case 400:
                
                if (!btn.selected) {
                    
//                    memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    memcpy(arry, [self.arr cStringUsingEncoding:NSASCIIStringEncoding],self.arr.length);
                    
                    
                    
                    if (arry[3] == '1') {
                        arry[3] = '0';
                        
                    }else{
                    
                        arry[3] = '1';
                        
                    }
                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 4)];
                    self.arr = arr;
                   
                }else{
                    
//                    memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    memcpy(arry, [self.arr cStringUsingEncoding:NSASCIIStringEncoding],self.arr.length);
                    
                    
                    if (arry[3] == '0') {
                        
                        arry[3] = '1';
                        
                    }else{
                    
                        arry[3] = '0';
                        
                    }
                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 4)];
                    self.arr = arr;
                    
                }
                
                break;
                
            case 300:
                
                if (!btn.selected) {
                    
//                    memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    
                    memcpy(arry, [self.arr cStringUsingEncoding:NSASCIIStringEncoding],self.arr.length);
                    
                    if (arry[2] == '1') {
                        arry[2] = '0';
                        
                    }else{
                    
                        arry[2] = '1';
                        
                    }
                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 4)];
                    
                    self.arr = arr;
                   
                }else{
//                    memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    memcpy(arry, [self.arr cStringUsingEncoding:NSASCIIStringEncoding],self.arr.length);
                    
                    
                    if (arry[2] == '0') {
                        arry[2] = '1';
                        
                    }else{
                    
                        arry[2] = '0';
                        
                    }

                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 4)];
                    self.arr = arr;
                    
                }
                
                
                break;
            case 200:
                if (!btn.selected) {
//                    memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    memcpy(arry, [self.arr cStringUsingEncoding:NSASCIIStringEncoding],self.arr.length);
                    
                    
                    if (arry[1] == '1') {
                        arry[1] = '0';
                        
                    }else{
                    
                        arry[1] = '1';
                        
                    }
                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 4)];
                    self.arr = arr;
                   
                }else{
//                    memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    memcpy(arry, [self.arr cStringUsingEncoding:NSASCIIStringEncoding],self.arr.length);
                    
                    if (arry[1] == '0') {
                        arry[1] = '1';
                        
                    }else{
                    
                        arry[1] = '0';
                        
                    }
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 4)];
                    self.arr = arr;
                   
                }
                
                break;
            case 100:
                if (!btn.selected) {
                    
//                    memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    memcpy(arry, [self.arr cStringUsingEncoding:NSASCIIStringEncoding],self.arr.length);
                    
                    if (arry[0] == '1') {
                        
                        arry[0] = '0';
                        
                    }else{
                        
                        arry[0] = '1';
                        
                    }
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 4)];
                    self.arr = arr;
                   
                }else{
//                    memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    memcpy(arry, [self.arr cStringUsingEncoding:NSASCIIStringEncoding],self.arr.length);
                    
                    
                    if (arry[0] == '0') {
                        
                        arry[0] = '1';
                        
                    }else{
                    
                        arry[0] = '0';
                        
                    }
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 4)];
                    self.arr = arr;
                    
                }
                
                break;
                
        }
        
    }
    
    if (dev.DEVICE_TYPE_ID == 8) {
        
        if (!btn.selected) {
            
            //获取数据库中最新的设备状态，将它赋值给当前数组
//            memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
//
            memcpy(arry, [self.arr cStringUsingEncoding:NSASCIIStringEncoding],self.arr.length);
            
            if (arry[0] == '1') {
                
                arry[0] = '0';
            }
            else{
            
                arry[0] = '1';
                
            }
            
            NSString *arr1 = [self  transArryToStr:arry];
            NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 1)];
            self.arr = arr;
            
        }else{
            
//            memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
            memcpy(arry, [self.arr cStringUsingEncoding:NSASCIIStringEncoding],self.arr.length);
            
            if (arry[0] == '0') {
                
                arry[0] = '1';
                
            }
            
            else{
            
                arry[0] = '0';
                
            }
            
            NSString *arr1 = [self  transArryToStr:arry];
            NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 1)];
            self.arr = arr;
            
        }
        
    }
    
    if (dev.DEVICE_TYPE_ID==51) {
        switch (btn.tag) {
                
            case 900:
                
                if (!btn.selected) {
                    
                    //获取数据库中最新的设备状态，将它赋值给当前数组
                    //            memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    //
                    memcpy(arry, [self.arr cStringUsingEncoding:NSASCIIStringEncoding],self.arr.length);
                    
                    if (arry[0] == '1') {
                        
                        arry[0] = '0';
                    }
                    else{
                        
                        arry[0] = '1';
                        
                    }
                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 1)];
                    self.arr = arr;
                    
                }else{
                    
                    //            memcpy(arry, [dev.DEVICE_STATE cStringUsingEncoding:NSASCIIStringEncoding],[dev.DEVICE_STATE length]);
                    //
                    memcpy(arry, [self.arr cStringUsingEncoding:NSASCIIStringEncoding],self.arr.length);
                    
                    if (arry[0] == '0') {
                        
                        arry[0] = '1';
                        
                    }
                    
                    else{
                        
                        arry[0] = '0';
                        
                    }
                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [arr1  substringWithRange:NSMakeRange(0, 1)];
                    self.arr = arr;
                }
                 break;
        
        }
        
    }
        
    if ((dev.DEVICE_TYPE_ID==110)|(dev.DEVICE_TYPE_ID==113)|(dev.DEVICE_TYPE_ID==115)|(dev.DEVICE_TYPE_ID==118)) {
        
        switch (btn.tag) {
            case 900:
                if (btn.selected) {
                    
                    //获取数据库中最新的设备状态，将它赋值给当前数组
                    //            memcpy(arry, [[dev.DEVICE_STATE substringToIndex:2] cStringUsingEncoding:NSASCIIStringEncoding],2);
                    memcpy(arry, [[self.arr substringToIndex:2]  cStringUsingEncoding:NSASCIIStringEncoding],2);
                    
                    
                    if (arry[0]=='0' & arry[1]=='0') {
                        arry[0] = '1';
                        arry[1] ='0';
                    }else if (arry[0]=='0' & arry[1]=='1') {
                        arry[0] = '1';
                        arry[1] ='0';
                    }else if (arry[0]=='1' & arry[1]=='1') {
                        arry[0] = '1';
                        arry[1] ='0';
                    }else if (arry[0]=='1' & arry[1]=='0') {
                        arry[0] = '1';
                        arry[1] ='1';
                    }
                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [[arr1  substringWithRange:NSMakeRange(0, 2)]  stringByAppendingString:@"000000"];
                    self.arr = arr;
                }else{
                    
                    //            memcpy(arry, [[dev.DEVICE_STATE substringToIndex:2] cStringUsingEncoding:NSASCIIStringEncoding],2);
                    memcpy(arry, [[self.arr substringToIndex:2]  cStringUsingEncoding:NSASCIIStringEncoding],2);
                    
                    if (arry[0]=='0' & arry[1]=='0') {
                        arry[0] = '1';
                        arry[1] ='0';
                    }else if (arry[0]=='0' & arry[1]=='1') {
                        arry[0] = '1';
                        arry[1] ='0';
                    }else if (arry[0]=='1' & arry[1]=='1') {
                        arry[0] = '1';
                        arry[1] ='0';
                    }else if (arry[0]=='1' & arry[1]=='0') {
                        arry[0] = '1';
                        arry[1] ='1';
                    }
                    
                    NSString *arr1 = [self  transArryToStr:arry];
                    NSString *arr = [[arr1  substringWithRange:NSMakeRange(0, 2)]  stringByAppendingString:@"000000"];
                    self.arr = arr;
                }
                
                break;
            
        }
        
    }
    
    [self remoteSwitchOnAction];
    
}

-(void)remoteSwitchOnAction{
    
    NSString *hex16;
    NSString *devType;
    NSString *datalen;
    NSString *data ;
    //取出当前cell的设备信息
    deviceMessage *devicess = [[deviceMessage alloc]init];
    
    devicess.DEVICE_NO = dataCenter.scheduleDeviceId;
    devicess.GATEWAY_NO = dataCenter.gatewayNo;
    
    deviceMessage *dev =  [deviceMessageTool queryWithDeviceNumDevices:devicess][0];
       //将int 型转换为byte型
    
    switch (dev.DEVICE_TYPE_ID) {
            
        case 5:
            
            hex16 = [ControlMethods  ToHex:dev.DEVICE_TYPE_ID];
            devType = [NSString  stringWithFormat:@"%@00",hex16];
            datalen = @"0001";
            data =[ControlMethods  ToHex:[self.arr integerValue]];
            
            break;
        case 6:
            
            hex16 = [ControlMethods  ToHex:dev.DEVICE_TYPE_ID];
            devType = [NSString  stringWithFormat:@"%@00",hex16];
            datalen = @"0002";
            data =[ControlMethods  transCoding:self.arr];
            
            break;
            
        case 8:
            hex16 = [ControlMethods  ToHex:dev.DEVICE_TYPE_ID];
            devType = [NSString  stringWithFormat:@"%@00",hex16];
            datalen = @"0001";
            data =[ControlMethods  transCoding:self.arr];
            

            break;
        case 11:
            hex16 = [ControlMethods  ToHex:dev.DEVICE_TYPE_ID];
            devType = [NSString  stringWithFormat:@"%@00",hex16];
            datalen = @"0002";
            data =[ControlMethods  transCoding:self.arr];
            
            break;
        case 51:
            
            hex16 = [ControlMethods  ToHex:dev.DEVICE_TYPE_ID];
            devType = [NSString  stringWithFormat:@"%@00",hex16];
            datalen = @"0001";
            data =[ControlMethods  transCoding:self.arr];
            
            break;
        case 110:
            
            hex16 = [ControlMethods  ToHex:dev.DEVICE_TYPE_ID];
            devType = [NSString  stringWithFormat:@"%@00",hex16];
            datalen = @"0002";
            if([self.arr isEqualToString:@"00000000"]){
            
                self.arr = @"10000000";
            }
            data =[ControlMethods  transCoding:[self.arr substringToIndex:2]];
            
            break;
        case 113:
            
            hex16 = [ControlMethods  ToHex:dev.DEVICE_TYPE_ID];
            devType = [NSString  stringWithFormat:@"%@00",hex16];
            datalen = @"0002";
            if([self.arr isEqualToString:@"00000000"]){
                
                self.arr = @"10000000";
            }

            data =[ControlMethods  transCoding:[self.arr substringToIndex:2]];
            
            break;
        case 115:
            
            hex16 = [ControlMethods  ToHex:dev.DEVICE_TYPE_ID];
            devType = [NSString  stringWithFormat:@"%@00",hex16];
            datalen = @"0002";
            if([self.arr isEqualToString:@"00000000"]){
                
                self.arr = @"10000000";
            }

            data =[ControlMethods  transCoding:[self.arr substringToIndex:2]];
            
            break;
        case 118:
            
            hex16 = [ControlMethods  ToHex:dev.DEVICE_TYPE_ID];
            devType = [NSString  stringWithFormat:@"%@00",hex16];
            datalen = @"0002";
            if([self.arr isEqualToString:@"00000000"]){
                
                self.arr = @"10000000";
            }

            data =[ControlMethods  transCoding:[self.arr substringToIndex:2]];
            
            break;
        default:
            
            hex16 = [ControlMethods  ToHex:dev.DEVICE_TYPE_ID];
            devType = [NSString  stringWithFormat:@"%@00",hex16];
            datalen = [NSString  stringWithFormat:@"00%@",hex16];
            data =[ControlMethods  transCoding:self.arr];
            
            break;
    }
    //拆报文
    NSString *head = @"42424141";
    NSString *stamp = @"00000000";
    NSString *gw_id = dataCenter.gatewayNo;
    NSString *dev_id = dataCenter.scheduleDeviceId;
    NSString *dev_type = devType;
    NSString *data_type = @"0200";
    NSString *data_len = datalen;
    //拼接发送报文
    NSString *packet = [PacketMethods  devicePacket:head getStamp:stamp getGw_id:gw_id getDev_id:dev_id getDev_type:dev_type getData_type:data_type getData_len:data_len getData:data];
    
    
    NSString *deviceControlPacketStr = [packet stringByReplacingOccurrencesOfString:@" " withString:@""];//除掉空格
    self.packData = deviceControlPacketStr;
    
}

/**
 *  定义每个UICollectionView 的大小
 *
 *  @param CGSize 一个cell的宽度
 *
 *  @return 返回设置后的结果
 */

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return CGSizeMake(collectionView.frame.size.width, 60);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(10, 0, 0, 0);
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
       // NSLog(@"_proTimeStr=%@",_proTimeStr);
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
