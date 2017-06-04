//
//  NavigationViewController.m
//  yh8
//
//  Created by ppl on 12-10-22.
//
//

#import "NavigationViewController.h"
#import "CommonFunction.h"

static NavigationViewController *navigationViewController = nil;

@interface NavigationViewController ()

@end

@implementation NavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIImage *title_bg = [UIImage imageNamed:@"TitleBackground.png"];  //获取图片
        
        CGSize titleSize = self.navigationBar.bounds.size;  //获取Navigation Bar的位置和大小
        title_bg = [CommonFunction scaleToSize:title_bg size:titleSize];//设置图片的大小与Navigation Bar相同
      
//        [self.navigationBar setBackgroundColor:[UIColor colorWithRed:66/255.0 green:202/255.0 blue:184/255.0 alpha:1]];
//        
//      
//        self.navigationBar.tintColor = [UIColor colorWithRed:0.0/255  green:0.0/255  blue:0.0/255  alpha:1];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

+ (NavigationViewController *)sharedNavigationViewController
{
    if (navigationViewController == nil)
    {
        navigationViewController = [[NavigationViewController alloc] init];
        
    }
    navigationViewController.navigationBarHidden=YES;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    [navigationViewController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_navbar.png"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    return navigationViewController;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

@end
