//
//  ScreenshotController.m
//  2cu
//
//  Created by guojunyi on 14-4-3.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import "ScreenshotController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "Toast+UIView.h"
#import "Utils.h"
#import "UDManager.h"
#import "LoginResult.h"
#import "ScreenshotCell.h"
#import "TopBar.h"

#import "LineLayout.h"
@interface ScreenshotController ()

@end

@implementation ScreenshotController

-(void)dealloc{
    [self.screenshotFiles release];
    [self.tableView release];
    [self.detailImageView release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.imgTempStack = [[Stack alloc] init];
    LoginResult *loginResult = [UDManager getLoginInfo];
    NSArray *datas = [NSArray arrayWithArray:[Utils getScreenshotFilesWithId:loginResult.contactId]];
    
    self.screenshotFiles = [[NSMutableArray alloc] initWithCapacity:0];
    
    int count = 0;
    if(([datas count]%3)==0){
        count = [datas count]/3;
    }else{
        count = [datas count]/3 + 1;
    }
    
    for(int i=0;i<count;i++){
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
        if(i!=(count-1)){
            [array addObject:[NSString stringWithFormat:@"%@",[datas objectAtIndex:i*3]]];
            [array addObject:[NSString stringWithFormat:@"%@",[datas objectAtIndex:i*3+1]]];
            [array addObject:[NSString stringWithFormat:@"%@",[datas objectAtIndex:i*3+2]]];
        }else{
            int value = [datas count]%3;
            if(value==0){
                [array addObject:[NSString stringWithFormat:@"%@",[datas objectAtIndex:i*3]]];
                [array addObject:[NSString stringWithFormat:@"%@",[datas objectAtIndex:i*3+1]]];
                [array addObject:[NSString stringWithFormat:@"%@",[datas objectAtIndex:i*3+2]]];
            }else if(value==1){
                [array addObject:[NSString stringWithFormat:@"%@",[datas objectAtIndex:i*3]]];
                [array addObject:@""];
                [array addObject:@""];
            }else if(value==2){
                [array addObject:[NSString stringWithFormat:@"%@",[datas objectAtIndex:i*3]]];
                [array addObject:[NSString stringWithFormat:@"%@",[datas objectAtIndex:i*3+1]]];
                [array addObject:@""];
            }
        }
        
        [self.screenshotFiles addObject:array];
        [array release];
        
    }
    [self initComponent];
    
    	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    MainController *mainController = [AppDelegate sharedDefault].mainController;
    [mainController setBottomBarHidden:YES];
    
}

-(void)viewWillDisappear:(BOOL)animated{

}
-(void)viewDidAppear:(BOOL)animated{


}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#define ITEM_HEIGHT (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 150:90)
#define ITEM_MARGIN 10
-(void)initComponent{
    CGRect rect = [AppDelegate getScreenSize:YES isHorizontal:NO];
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    [self.view setBackgroundColor:XBgColor];
    TopBar *topBar = [[TopBar alloc] initWithFrame:CGRectMake(0, 0, width, NAVIGATION_BAR_HEIGHT)];
    [topBar setBackButtonHidden:NO];
    [topBar setRightButtonHidden:NO];
    [topBar setRightButtonIcon:[UIImage imageNamed:@"ic_bar_btn_clear.png"]];
    [topBar.backButton addTarget:self action:@selector(onBackPress) forControlEvents:UIControlEventTouchUpInside];
    [topBar.rightButton addTarget:self action:@selector(onRightButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [topBar setTitle:NSLocalizedString(@"screenshot",nil)];
    [self.view addSubview:topBar];
    [topBar release];
    if(CURRENT_VERSION>=7.0){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

//    CGFloat itemWith = (width-(NUMBER_OF_ITEM_IN_ROW+1)*ITEM_MARGIN)/NUMBER_OF_ITEM_IN_ROW;
//    CGFloat itemHeight = itemWith*3/4;
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    layout.minimumLineSpacing = 1.0;
//    layout.itemSize = CGSizeMake(itemWith, itemHeight);
//    layout.sectionInset = UIEdgeInsetsMake(10.0, ITEM_MARGIN, 10.0, ITEM_MARGIN);
//    
//    
//    layout.minimumLineSpacing = 10.0;
//    
//    layout.headerReferenceSize = CGSizeMake(width, 1);
//    layout.footerReferenceSize = CGSizeMake(width, 1);
//    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, width, height-NAVIGATION_BAR_HEIGHT) collectionViewLayout:layout];
//    [collectionView registerClass:[ScreenshotCell class] forCellWithReuseIdentifier:@"ScreenshotCell"];
//    collectionView.delegate = self;
//    collectionView.dataSource = self;
//    [collectionView setBackgroundColor:XBgColor];
//    [self.view addSubview:collectionView];
//    
//    [layout release];
//    [collectionView release];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, width, height-NAVIGATION_BAR_HEIGHT) style:UITableViewStylePlain];
    [tableView setBackgroundColor:XBgColor];
    if(CURRENT_VERSION>=7.0){
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [tableView release];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.screenshotFiles count];
   
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ITEM_HEIGHT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ScreenshotCell";
    ScreenshotCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell==nil){
        cell = [[[ScreenshotCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    
    
    UIImageView *backImageView = [[UIImageView alloc] init];
    UIImageView *backImageView_p = [[UIImageView alloc] init];
    backImageView.backgroundColor = XBgColor;
    backImageView_p.backgroundColor = XBgColor;
    [cell setBackgroundView:backImageView];
    [cell setSelectedBackgroundView:backImageView_p];
    [backImageView release];
    [backImageView_p release];
    LoginResult *loginResult = [UDManager getLoginInfo];
    
    
    
    NSString *name1 = [[self.screenshotFiles objectAtIndex:indexPath.row] objectAtIndex:0];
    NSString *name2 = [[self.screenshotFiles objectAtIndex:indexPath.row] objectAtIndex:1];
    NSString *name3 = [[self.screenshotFiles objectAtIndex:indexPath.row] objectAtIndex:2];

    
    NSString *filePath1 = [Utils getScreenshotFilePathWithName:name1 contactId:loginResult.contactId];
    NSString *filePath2 = [Utils getScreenshotFilePathWithName:name2 contactId:loginResult.contactId];
    NSString *filePath3 = [Utils getScreenshotFilePathWithName:name3 contactId:loginResult.contactId];
    [cell setRow:indexPath.row];
    cell.delegate = self;
    if(!name1||[name1 isEqualToString:@""]){
        [cell setFilePath1:@""];
    }else{
        [cell setFilePath1:filePath1];
    }
    
    if(!name2||[name2 isEqualToString:@""]){
        [cell setFilePath2:@""];
    }else{
        [cell setFilePath2:filePath2];
    }
    
    if(!name3||[name3 isEqualToString:@""]){
        [cell setFilePath3:@""];
    }else{
        [cell setFilePath3:filePath3];
    }
    
    return cell;
}

-(void)onItemPress:(ScreenshotCell *)screenshotCell row:(NSInteger)row index:(NSInteger)index{
    if(self.isShowDetail){
        return;
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (button.frame.size.height-button.frame.size.width)/2, button.frame.size.width, button.frame.size.width*3/4)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    LoginResult *loginResult = [UDManager getLoginInfo];
    NSString *name = [[self.screenshotFiles objectAtIndex:row] objectAtIndex:index];
    NSString *filePath = [Utils getScreenshotFilePathWithName:name contactId:loginResult.contactId];
    button.backgroundColor = XBlack;
    imageView.image = [UIImage imageWithContentsOfFile:filePath];
    [button addSubview:imageView];
    [imageView release];
    self.detailImageView = button;
    [self.view addSubview:self.detailImageView];
    self.isShowDetail = YES;
    self.detailImageView.transform = CGAffineTransformMakeScale(0.3, 0.3);
    self.detailImageView.alpha = 0.1;
    [UIView transitionWithView:button duration:0.2 options:UIViewAnimationCurveEaseInOut
                    animations:^{
                        self.detailImageView.alpha = 1.0;
                        self.detailImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    }
                    completion:^(BOOL finished) {
        
                    }
    ];
    
    [self.detailImageView addTarget:self action:@selector(onClearDetailImage) forControlEvents:UIControlEventTouchUpInside];
}

-(void)onBackPress{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onClearDetailImage{
    self.isShowDetail = NO;
    [UIView transitionWithView:self.detailImageView duration:0.2 options:UIViewAnimationCurveEaseInOut
                    animations:^{
                        self.detailImageView.alpha = 0.1;
                        self.detailImageView.transform = CGAffineTransformMakeScale(0.3, 0.3);
                    }
                    completion:^(BOOL finished) {
                        [self.detailImageView removeFromSuperview];
                        self.detailImageView = nil;
                    }
     ];
}

-(void)onRightButtonPress{
    UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"sure_to_clear", nil) message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"ok", nil),nil];
    deleteAlert.tag = ALERT_TAG_CLEAR;
    [deleteAlert show];
    [deleteAlert release];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch(alertView.tag){
        case ALERT_TAG_CLEAR:
        {
            if(buttonIndex==1){
                LoginResult *loginResult = [UDManager getLoginInfo];
                NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                NSString *filePath = [NSString stringWithFormat:@"%@/screenshot/%@",rootPath,loginResult.contactId];
                
                NSFileManager *manager = [NSFileManager defaultManager];
                NSError *error;
                
                [manager removeItemAtPath:filePath error:&error];
                if(error){
                    //DLog(@"%@",error);
                }
                
                [self.screenshotFiles removeAllObjects];
                [self.tableView reloadData];
                [self.view makeToast:NSLocalizedString(@"operator_success", nil)];
                
                
            }
        }
            break;
    }
}

-(BOOL)shouldAutorotate{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interface {
    return (interface == UIInterfaceOrientationPortrait );
}

#ifdef IOS6

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
#endif

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}
@end
