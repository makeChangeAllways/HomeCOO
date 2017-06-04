//
//  XFDateView.m
//  XFPickerViewDemo

//  Copyright © 2016年 BigFly. All rights reserved.
//


#import "XFMusicDaterView.h"

#define daterConterViewWidth  [UIScreen  mainScreen].bounds.size.width /2.5
#define daterConterViewHeight   [UIScreen  mainScreen].bounds.size.height /2

@interface XFMusicDaterView ()<UITableViewDelegate,UITableViewDataSource>{
    UIView *daterContentView;
    UILabel *daterLab;
    UITableView *myTableView;
    
    UIButton *sureBtn;
    UIButton *cancelBtn;
   
}

@end

@implementation XFMusicDaterView

#pragma mark - init初始化
- (void)initViews{
    
    self.frame=[UIScreen mainScreen].bounds;
    self.backgroundColor=RGBA(0, 0, 0, 0.3);
    daterContentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,daterConterViewWidth , daterConterViewHeight)];
                        
    daterContentView.center = self.center;
    daterContentView.backgroundColor = [UIColor grayColor];
    [self addSubview:daterContentView];
    daterContentView.layer.masksToBounds=YES;
    daterContentView.layer.cornerRadius=8;
    
    daterLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, daterContentView.w, daterConterViewHeight/5)];
    
    daterLab.backgroundColor = [UIColor grayColor];
    
    daterLab.font= [UIFont systemFontOfSize:14];
    daterLab.textColor = [UIColor whiteColor];
    
    daterLab.textAlignment=1;
    [daterContentView addSubview:daterLab];
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, daterLab.h, daterContentView.w, daterLab.h*3)];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.scrollEnabled = NO;
    
    [daterContentView addSubview:myTableView];
    
    sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(0,CGRectGetMaxY(myTableView.frame), daterContentView.frame.size.width/2, daterLab.h);
    
    [sureBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    [daterContentView addSubview:sureBtn];
    sureBtn.backgroundColor=[UIColor lightGrayColor];
    
    
    cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame =  CGRectMake(CGRectGetMaxX(sureBtn.frame), CGRectGetMaxY(myTableView.frame), daterContentView.frame.size.width/2, daterLab.h);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [daterContentView addSubview:cancelBtn];
    cancelBtn.backgroundColor=[UIColor lightGrayColor];
    
}

- (void)setTitle:(NSString *)title{
    
    _title = title;
    
    daterLab.text = title;
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

#pragma mark TableViewDelegate TableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = self.titleArray[indexPath.row];
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return myTableView.h/self.titleArray.count;//关键
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.currentIndexPath = indexPath;
    

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryNone;

}

- (void)setTitleArray:(NSArray *)titleArray {
    
    _titleArray = titleArray;
    
    [myTableView reloadData];
}

#pragma mark - delegate
- (void)sureAction:(UIButton *)sender{
    
    [self fadeOut];
    
    UITableViewCell *cell = [myTableView cellForRowAtIndexPath:self.currentIndexPath];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(daterViewDidClicked:)]) {
        
        [self.delegate daterViewDidClicked:self];
        
    }
    
    
    
}
- (void)cancelAction:(UIButton *)sender{
       [self fadeOut];
    UITableViewCell *cell = [myTableView cellForRowAtIndexPath:self.currentIndexPath];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
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
