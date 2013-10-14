//
//  AppDelegate.h
//  CET4Lite
//
//  Created by Seven Lee on 12-2-24.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSStackedViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "SevenTabBar.h"
#import "ASIHTTPRequest.h"
#import "UINavigationController+Rotation_IOS6.h"
#import "SVLocationHandler.h"
#define XAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
@interface AppDelegate : UIResponder <UIApplicationDelegate,UIScrollViewDelegate,SVLocationHandlerDelegate>{
    UIPageControl * pageControll;
    UIView * myView;
//    UIScrollView * scroll
    PSStackedViewController * _stackController;
    UINavigationController * _navigation;
    ASIHTTPRequest * _getNewRequest;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) IBOutlet  SevenTabBar * tabbarController;
@property (strong, nonatomic) IBOutlet UINavigationController *navigationController;
@property (nonatomic, strong, readonly)PSStackedViewController * stackController;
//@property (strong, nonatomic) IBOutlet UIWindow *iphone5window;

+ (BOOL)isPad;
@end
