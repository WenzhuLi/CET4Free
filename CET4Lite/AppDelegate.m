//
//  AppDelegate.m
//  CET4Lite
//
//  Created by Seven Lee on 12-2-24.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "database.h"
#import "Flurry.h"
#import "CET4Constents.h"
//#import "Renren.h"
#import "UserInfo.h"
#import "MenuRootViewController.h"
#import "RegexKitLite.h"
#import "AudioDownloader.h"
#import "SBJSON.h"
#import "NSString+SBJSON.h"
#import "CETNewsViewController.h"
#import "SVBlog.h"
#import "NSString+MD5.h"
#include <sys/xattr.h>
#import "SFHFKeychainUtils.h"
#define kNewestBlogProtocol @"http://api.iyuba.com.cn/v2/api.iyuba?protocol=20006&pageCounts=1&id=242141&sign=80f18af1258564617afa4ca32c62d571&pageNumber=1"
#define kNewestBlogProtocolTest @"http://api.iyuba.com.cn/v2/api.iyuba?protocol=20006&pageCounts=1&id=15554&sign=57d65f4b0c4731d4a1e10ec263ec2d36&pageNumber=1"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabbarController;
@synthesize navigationController = _navigationController;
@synthesize stackController = _stackController;

+ (BOOL)isPad {
	BOOL isPad = NO;
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 30200)
	isPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
#endif
	return isPad;
}
- (void)iPhoneInit{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIImageView * backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Librarybg.png"]];
    backgroundImage.frame = IS_IPHONE_5 ? self.window.bounds : CGRectMake(self.window.bounds.origin.x, self.window.bounds.origin.y - 30, self.window.bounds.size.width, self.window.bounds.size.height + 30);
    [self.window addSubview:backgroundImage];
    self.window.rootViewController = self.tabbarController;
    [self.window makeKeyAndVisible];
//    [self.tabbarController setBadgeValue:@"2" atIndex:3];
    /*
    if (IS_IPHONE_5) {
        UIImageView * backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Librarybg.png"]];
//        backgroundImage.frame = CGRectMake(self.window.bounds.origin.x, self.window.bounds.origin.y - 30, self.window.bounds.size.width, self.window.bounds.size.height + 30) ;
        backgroundImage.frame = self.iphone5window.bounds;
        self.iphone5window.rootViewController = tabbarController;
        [self.iphone5window addSubview:backgroundImage];
        [self.iphone5window addSubview:tabbarController.view];
        
        [self.iphone5window makeKeyAndVisible];
        NSLog(@"iphone5window");
    }
    else{
        UIImageView * backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Librarybg.png"]];
        backgroundImage.frame = CGRectMake(self.window.bounds.origin.x, self.window.bounds.origin.y - 30, self.window.bounds.size.width, self.window.bounds.size.height + 30) ;
        [self.window addSubview:backgroundImage];
        self.window.rootViewController = tabbarController;
//        [self.window addSubview:tabbarController.view];
        [self.window makeKeyAndVisible];
    }
     */
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
	[Flurry startSession:kMYFLURRY_KEY];
    
}
CGRect XYWidthHeightRectSwap(CGRect rect) {
    CGRect newRect;
    newRect.origin.x = rect.origin.y;
    newRect.origin.y = rect.origin.x;
    newRect.size.width = rect.size.height;
    newRect.size.height = rect.size.width;
    return newRect;
}

CGRect FixOriginRotation(CGRect rect, UIInterfaceOrientation orientation, int parentWidth, int parentHeight) {
    CGRect newRect;
    switch(orientation)
    {
        case UIInterfaceOrientationLandscapeLeft:
            newRect = CGRectMake(parentWidth - (rect.size.width + rect.origin.x), rect.origin.y, rect.size.width, rect.size.height);
            break;
        case UIInterfaceOrientationLandscapeRight:
            newRect = CGRectMake(rect.origin.x, parentHeight - (rect.size.height + rect.origin.y), rect.size.width, rect.size.height);
            break;
        case UIInterfaceOrientationPortrait:
            newRect = rect;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            newRect = CGRectMake(parentWidth - (rect.size.width + rect.origin.x), parentHeight - (rect.size.height + rect.origin.y), rect.size.width, rect.size.height);
            break;
    }
    return newRect;
}
- (void)iPadInit{
//    UIImageView * backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"windowBG.png"]];
//    backgroundImage.frame = self.window.bounds;
    MenuRootViewController * menu = [[MenuRootViewController alloc] initWithNibName:nil bundle:nil];
    _stackController = [[PSStackedViewController alloc] initWithRootViewController:menu];
    _stackController.enableShadows = NO;
    _stackController.enableBounces = NO;
    _stackController.reduceAnimations = NO;
    _navigationController = [[UINavigationController alloc] initWithRootViewController:_stackController];
    _stackController.navigationController.navigationBarHidden = YES;
//    [self.window addSubview:backgroundImage];
    self.window.rootViewController = _navigationController;
//    CGRect frame = self.window.frame;
//    if (IS_IOS7) {
//        frame.origin.y = 20;
//        frame.size.height -= 20;
//        frame = XYWidthHeightRectSwap(frame);
//        frame = FixOriginRotation(frame, , <#int parentWidth#>, <#int parentHeight#>)
//        self.window.frame = frame;
//        
//    }
    
    [self.window makeKeyAndVisible];
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
	[Flurry startSession:kMYFLURRY_KEY];
}
- (void)drawHelpViewOniPad{
    
}
- (void)drawHelpViewOniPhone{
    UIScrollView * scroll = [[UIScrollView alloc] initWithFrame:self.window.bounds];
    pageControll = [[UIPageControl alloc] initWithFrame:CGRectMake(141, 430, 38, 36)];
    [pageControll setNumberOfPages:5];
    scroll.pagingEnabled = YES;
    scroll.showsVerticalScrollIndicator = NO;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.scrollEnabled = YES;
    scroll.clipsToBounds = YES;
    scroll.backgroundColor = [UIColor colorWithRed:0.294 green:0.129 blue:0.047 alpha:1];
    scroll.delegate = self;
    CGFloat pointX = 0;
    CGFloat pointY = 0;
    CGFloat width = scroll.frame.size.width;
    CGFloat height = scroll.frame.size.height;
    for (int i = 0; i < 5; i++) {
        NSString * name = [NSString stringWithFormat:@"Help%d.png",i+1];
        UIImageView * helpImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
        CGRect frame = CGRectMake(pointX, pointY, width, height);
        helpImg.frame = frame;
        [scroll addSubview:helpImg];
        pointX += width;
    }
    scroll.contentSize = CGSizeMake(pointX, height);
    myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height)];
    [myView setBackgroundColor:[UIColor blackColor]];
    [myView addSubview:scroll];
    [myView addSubview:pageControll];
    [self.window addSubview:myView];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    BOOL _firstLaunch = NO;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kCurrentVersion] == nil) {
//        [[Renren sharedRenren] logout:nil];
        _firstLaunch = YES;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:kVersionNo] forKey:kCurrentVersion];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kLoggedUserID] == nil || [[NSUserDefaults standardUserDefaults] objectForKey:kLoggedUserKey] == nil)
    {
        [UserInfo setLoggedUserID:@""];
        [UserInfo setLoggedUserName:@""];
        [UserInfo setIsVIP:NO];
        [UserInfo setVIPExpireTime:0.0];
//        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kLoggedUserID];
//        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kLoggedUserKey];

        
    }
    if ([AppDelegate isPad]) {
        [self iPadInit];

    }
    else {
        [self iPhoneInit];
        if (_firstLaunch) {
            [self drawHelpViewOniPhone];
        }
    }
//    backgroundImage.frame = self.window.bounds;
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
    [self initializeShare];
    NSFileManager * fm = [NSFileManager defaultManager];
    NSString * oldpath = [database oldAudioFileDirectory];
    BOOL isDir;
//    if(!application.enabledRemoteNotificationTypes){
    NSLog(@"oldpath:%@",oldpath);
    if ([fm fileExistsAtPath:[database oldAudioFileDirectory] isDirectory:&isDir]) {
        NSError * err = nil;
        [fm moveItemAtPath:[database oldAudioFileDirectory] toPath:[database AudioFileDirectory] error:&err];
        if (err) {
            NSLog(@"move to new directory failed:%@",err);
        }
        
    }
    [fm createDirectoryAtPath:[database AudioFileDirectory] withIntermediateDirectories:YES attributes:nil error:nil];
    [self addSkipBackupAttributeToItemAtURL:[[NSURL alloc] initFileURLWithPath:[database AudioFileDirectory] isDirectory:isDir]];
    [self getNewBlog];
    [[SVLocationHandler sharedHandler] getUserLocationDelegate:nil];
    
    return YES;
}
- (void)getNewBlog{
    _getNewRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:kNewestBlogProtocol]];
    _getNewRequest.timeOutSeconds = 30;
    _getNewRequest.numberOfTimesToRetryOnTimeout = 2;
    [_getNewRequest setFailedBlock:^{
        NSLog(@"failed...");
    }];
    __weak AppDelegate * weakSelf = self;
    __weak ASIHTTPRequest * weakRequest = _getNewRequest;
    [_getNewRequest setCompletionBlock:^{
        NSString * response = weakRequest.responseString;
        NSDictionary * result = [response JSONValue];
        if ([[result objectForKey:@"result"] integerValue] == 251) {
            NSArray * data = [result objectForKey:@"data"];
            if ([data isKindOfClass:[NSArray class]] && data.count > 0) {
                NSDictionary * blog = [data objectAtIndex:0];
                SVBlog * savedBlog = [CETNewsViewController theNewestBlogSaved];
                if (!savedBlog || ![savedBlog.blogId isEqualToString:[blog objectForKey:@"blogid"]]) {
                    [CETNewsViewController setHasNew:YES];
                    if ([AppDelegate isPad]) {
                        UIViewController * controller = weakSelf.stackController.rootViewController;
                        if ([controller isKindOfClass:[MenuRootViewController class]]) {
                            MenuRootViewController * root = (MenuRootViewController *) controller;
                            [root setNewsBadgeText:@"N"];
                        }
                    }
                    else{
                        [weakSelf.tabbarController setBadgeValue:@"N" atIndex:3];
                        
                    }
                }
            }
        }
    }];
    [_getNewRequest startAsynchronous];
}
- (void)initializeShare{
    //注册shareSDK
    [ShareSDK registerApp:ShareSDKID];
    [ShareSDK ssoEnabled:NO];
    //添加新浪微博应用
    [ShareSDK connectSinaWeiboWithAppKey:WB_APP_KEY
                               appSecret:WB_APP_SEC
                             redirectUri:WB_URI];
    //添加腾讯微博应用
    [ShareSDK connectTencentWeiboWithAppKey:TCWB_APP_KEY
                                  appSecret:TCWB_APP_SEC
                                redirectUri:TCWB_URL];
    //添加人人网应用
    [ShareSDK connectRenRenWithAppKey:RR_API_Key
                            appSecret:RR_APP_SEC];
    //添加微信
    [ShareSDK connectWeChatWithAppId:WX_APPID wechatCls:[WXApi class]];
}
/**
 *  注册推送成功时调用
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString * tokenAsString = [[[deviceToken description]
                                 stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]
                                stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[NSUserDefaults standardUserDefaults] setObject:tokenAsString forKey:kMyPushTokenKey];

    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"pushToken"]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"pushToken"];
        [self pushToken:tokenAsString];
    }
}
//#if __IPAD_OS_VERSION_MAX_ALLOWED >= __IPAD_6_0

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if ([AppDelegate isPad]) {
        return UIInterfaceOrientationMaskAll;
    }
    else{
        return UIInterfaceOrientationMaskPortrait;
    }
} 
//#endif
/**
 *  注册推送失败
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"error:regist failture:%@",error);
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"pushToken"];
}
//Flurry捕获异常
void uncaughtExceptionHandler(NSException *exception) {
	[Flurry logError:@"Uncaught" message:@"Crash!" exception:exception];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [application setApplicationIconBadgeNumber:0];
    
    if ([AudioDownloader isDownloading]) {
        UIApplication  *app = [UIApplication sharedApplication];
        UIBackgroundTaskIdentifier bgTask = 0;
#if DEBUG
        NSTimeInterval ti = [[UIApplication sharedApplication]backgroundTimeRemaining];
        NSLog(@"backgroundTimeRemaining: %f", ti); // just for debug
#endif
        bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
        }];
    }
}
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    NSLog(@"handleOpenURL-----%@",url);
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    NSLog(@"openURL------%@",url);
    NSLog(@"sourceApplication----%@",sourceApplication);
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = sender.frame.size.width;
    int page = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControll.currentPage = page;
    if (sender.contentOffset.x>(pageWidth*4.2)) {
        [myView removeFromSuperview];
    }
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

#pragma mark - Http connect
- (void)pushToken:(NSString *) token
{
    NSString *url = [NSString stringWithFormat:@"http://apps.iyuba.com/voa/phoneToken.jsp?token=%@&appID=%@",token,kMyAppleID];
    NSLog(@"token:%@", url);
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.delegate = self;
    [request setUsername:@"token"];
    [request setTimeOutSeconds:30];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    NSData *myData = [request responseData];
    NSString *returnData = [[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding];
    for (NSString *matchOne in [returnData componentsMatchedByRegex:@"\\d"]) {
        //        NSLog(@"request:%i",[matchOne integerValue]);
        if ([matchOne integerValue] > 0) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"pushToken"];
            NSLog(@"da");
        } else {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"pushToken"];
            NSLog(@"xiao");
        }
    }
}
#pragma mark ------iCloud--------
// not to back up to iCloud
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    const char* filePath = [[URL path] fileSystemRepresentation];
	
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
	
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}

@end
