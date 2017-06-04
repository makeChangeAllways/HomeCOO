//
//  CommonFunction.m
//  yh8
//
//  Created by ppl on 12-9-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommonFunction.h"
//#import "MainViewController.h"
#import "NavigationViewController.h"
#import "PrefixHeader.pch"


static UIAlertView *gProgressBackgroundView = nil;

@implementation CommonFunction

+ (void)pushViewController:(UIViewController *)viewController
{
    [[NavigationViewController sharedNavigationViewController] pushViewController:viewController animated:YES];
}

+ (void)pushViewControllerAnimated:(UIViewController *)viewController animated:(BOOL)animated
{

    [[NavigationViewController sharedNavigationViewController] pushViewController:viewController animated:animated];
}

+ (void)popViewController
{

    [[NavigationViewController sharedNavigationViewController] popViewControllerAnimated:YES];
}
+ (void)popToRootViewController
{
    
    [[NavigationViewController sharedNavigationViewController] popToRootViewControllerAnimated:YES];
}
+ (void)popViewControllerAnimated:(BOOL)animated
{

    [[NavigationViewController sharedNavigationViewController] popViewControllerAnimated:animated];
}

+ (void)popToViewController:(UIViewController *)viewController
{

    [[NavigationViewController sharedNavigationViewController] popToViewController:viewController animated:YES];
}

+ (void)presentModalViewController:(UIViewController *)viewController
{
    [[NavigationViewController sharedNavigationViewController] presentViewController:viewController animated:YES completion:nil];
}

+ (void)dismissModalViewController
{
    [[NavigationViewController sharedNavigationViewController] dismissViewControllerAnimated:NO completion:nil ];
}

+ (NSArray *)viewControllers
{
    return [[NavigationViewController sharedNavigationViewController] viewControllers];
}

+ (void)reLogin
{
    [CommonFunction popToRootViewController];
}

+ (void)showMessageBox:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

+ (void)showProgressView
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请稍候..." message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [alertView show];
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [indicatorView setCenter:CGPointMake(alertView.bounds.size.width/2.0f, 60)];
    [indicatorView startAnimating];
    [alertView addSubview:indicatorView];
    gProgressBackgroundView = alertView ;
}

+ (void)dismissProgressView
{
    [gProgressBackgroundView dismissWithClickedButtonIndex:0 animated:YES];
    gProgressBackgroundView = nil;
}


+ (NSString*)encodeURL:(NSString *)string
{
	NSString *newString = (__bridge NSString *)(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
	if (newString) {
		return newString;
	}
	return @"";
}

+ (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)validatePureInt:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    
    return [scan scanInt:&val] && [scan isAtEnd];
}

+ (NSString *)dateToString:(NSDate *)date
{
    if (date == nil)
    {
        return @"";
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormat stringFromDate:date];
}

+ (NSString *)dateToStrings:(NSDate *)date
{
    if (date == nil)
    {
        return @"";
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    return [dateFormat stringFromDate:date];
}

+ (NSDate *)stringtoDateTime:(NSString *)str
{
    if (str.length == 0)
    {
        return [NSDate date];
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormat dateFromString:str];
}

+ (NSDate *)stringtoDate:(NSString *)str
{
    if (str.length == 0)
    {
        return [NSDate date];
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    return [dateFormat dateFromString:str];
}

+ (NSString *)dateToTime:(NSString *)date
{
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:[date intValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    return [formatter stringFromDate:timeDate];
}

+ (NSString *)dateToTimes:(NSString *)date
{
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:[date intValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:timeDate];
}

+ (int)ageWithDate:(NSDate *)date
{
    if (date == nil)
    {
        return 0;
    }
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSYearCalendarUnit;
    
    NSDateComponents *dc = [cal components:unitFlags fromDate:date];
    NSDateComponents *curDc = [cal components:unitFlags fromDate:[NSDate date]];
    
    return curDc.year - dc.year;
}

+ (int)dayWithDate:(NSDate *)date
{
    if (date == nil)
    {
        return 0;
    }
    
    NSTimeInterval secondsBetweenDates = [date timeIntervalSinceDate:
                                          [NSDate date]];
    return secondsBetweenDates / 3600 / 24;
   
}

+ (NSString *)constellationWithDate:(NSDate *)date
{
    NSString *dayRange[] = {
        @"01-20",
        @"02-19",
        @"03-21",
        @"04-20",
        @"05-21",
        @"06-22",
        @"07-23",
        @"08-23",
        @"09-23",
        @"10-24",
        @"11-23",
        @"12-22",
        @"12-32"
    };
    
    NSString *constellations[] = {
        @"魔羯座",
        @"水瓶座",
        @"双鱼座",
        @"白羊座",
        @"金牛座",
        @"双子座",
        @"巨蟹座",
        @"狮子座",
        @"处女座",
        @"天秤座",
        @"天蝎座",
        @"射手座",
        @"魔羯座",
    };
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd"];
    NSString *dateString = [dateFormat stringFromDate:date];
    
    for (int i = 0; i < 13; i++)
    {
        if ([dateString compare:dayRange[i]] < 0)
        {
            return constellations[i];
        }
    }
    
    return @"";
}

//压缩图片
+ (UIImage *)imageWithImageSimple:(UIImage *)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

+ (NSString *)saveTmpImage:(UIImage *)image name:(NSString *)name
{
    NSString *fullPathToFile = [NSTemporaryDirectory() stringByAppendingPathComponent:name];

    NSData* imageData = UIImageJPEGRepresentation(image, 1.0);
 
    NSInteger picstate=[[NSUserDefaults standardUserDefaults] integerForKey:@"picstate"];
    switch (picstate) {
        case 0:
            imageData = UIImageJPEGRepresentation(image, 0.5);
            break;
        case 1:
            imageData = UIImageJPEGRepresentation(image, 1.0);
            break;
        default:
            break;
    }
    
    [imageData writeToFile:fullPathToFile atomically:NO];
    
    return fullPathToFile;
}

+(BOOL)clearFile:(NSString *)path{
    NSFileManager * filem=[NSFileManager defaultManager];
   return [filem removeItemAtPath:path error:nil];
}

+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

//修改图片大小
+(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    
    UIGraphicsBeginImageContext(size);
    
    [img drawInRect:CGRectMake(0, 0,size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}

+(long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
+(NSData *) dataforPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [manager contentsAtPath:filePath];
    }
    return nil;
}
+ (BOOL)toM4a:(NSString *)mediaURL{
    BOOL succes = YES;
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:mediaURL] options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality]){
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                              presetName:AVAssetExportPresetLowQuality];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:mediaURL error:nil];
        
        exportSession.outputURL = [NSURL fileURLWithPath: mediaURL];
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputFileType = AVFileTypeAppleM4A;
        //exportSession.outputFileType = AVFileTypeQuickTimeMovie;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void){
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed:
                    NSLog(@"AVAssetExportSessionStatusFailed!");
                    break;
                case AVAssetExportSessionStatusCancelled:
                    NSLog(@"AVAssetExportSessionStatusCancelled!");
                    break;
                case AVAssetExportSessionStatusCompleted:{
                    NSLog(@"Successful!");
                    break;
                }
                default:
                    break;
            }
        }];
        while (succes) {
            if(exportSession.status==AVAssetExportSessionStatusCompleted){
                succes=NO;
                return YES;
            }
        }
    }
    return NO;
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSLog(@"%@",mobileNum);
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     * 虚拟：147
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9]|4[7]|7[8])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188，147，178
     12         */
    NSString * Ali = @"^1(7[0])\\d{8}$";
    /**
     10         * 阿里：
     11         * 170
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278]|7[6]|4[5])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56]|7[7])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
     NSPredicate *regextestAli = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Ali];
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES
            ||[regextestAli  evaluateWithObject:mobileNum]))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


+ (NSUInteger)occurenceOfString:(NSString *)substring {
    NSUInteger cnt = 0, length = [substring length];
    NSRange range = NSMakeRange(0, length);
    while(range.location != NSNotFound)
    {
        range = [substring rangeOfString: @"<img " options:0 range:range];
        if(range.location != NSNotFound)
        {
            range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
            cnt++; 
        }
    }
    return cnt;
}

/*
+ (NSString *)HTMLString:(NSString *)html
{
    html = [html stringByReplacingOccurrencesOfString:@"<br />" withString:@"\r\n"];
    html = [html stringByReplacingOccurrencesOfString:@"<div align=\"center\">" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"<div align=\"right\">" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"<div align=\"left\">" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"</div>" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"<b>" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"</b>" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"<p style=\"text-indent: 2em;\">" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
    return html;
}
*/

+(NSString *)HTMLToString:(NSString *)html {
    
    NSScanner *theScanner;
    NSString *text = nil;
    
    html = [html stringByReplacingOccurrencesOfString:@"</p>" withString:@"</p>\n\n"];
    
    theScanner = [NSScanner scannerWithString:html];
    
    while ([theScanner isAtEnd] == NO) {        
        
        [theScanner scanUpToString:@"<" intoString:NULL] ;
                
        [theScanner scanUpToString:@">" intoString:&text] ;
        
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
                [ NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
        
    }
	return html;
    
}
+(NSString *)datetobbsString:(NSString*)date{
    long long nowdate=[[NSDate new] timeIntervalSince1970];
    long long logdate=[date longLongValue];
 long long  lostdate=nowdate -logdate;
    if (lostdate>=(60*60*24*2)) {
        return [[self class] dateToTime:date];
    }
    else if (lostdate>(60*60*24)){
    return @"一天前";
    }else if (lostdate>(60*60)){
        int h=(int)lostdate/(60*60);
        return [NSString stringWithFormat:@"%d 小时前",h];
    }else if (lostdate>(60)){
        int m=(int)lostdate/(60);
        return [NSString stringWithFormat:@"%d 分钟前",m];
    }else{
        return [NSString stringWithFormat:@"%lld 秒前",lostdate];
    }
}

//  计算字符宽高
+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(VIEWWIDTH - 20, MAXFLOAT)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    
    return rect.size;
}

+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return localeDate;
}
@end
