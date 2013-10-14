//
//  MenuRootViewController.m
//  CET4Lite
//
//  Created by Seven Lee on 12-9-14.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "MenuRootViewController.h"
#import "NewWordsViewController_iPad.h"
#import "LibNFavViewController.h"
#import "IASKAppSettingsViewController.h"
#import "QuestionsViewController.h"
#import "FeedbackViewController.h"
#import "ScoreViewController.h"
#import "FavorateViewController_iPad.h"
#import "UserInfo.h"
#import "CETNewsViewController_iPad.h"
#import "UIImageView+WebCache.h"
#import "CETNewsViewController.h"
#import "JSBadgeView.h"

@interface MenuRootViewController ()
@property (nonatomic, strong) JSBadgeView * newsBadge;
@end

@implementation MenuRootViewController
@synthesize userPicture = _userPicture;
@synthesize backgroundImg = _backgroundImg;
@synthesize slideIn = _slideIn;
@synthesize settingsNav = _settingsNav;
@synthesize userName = _userName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        Tapped = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IS_IOS7 && !IS_IPAD) {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wood_pattern_bg"]];
    self.navigationController.navigationBar.translucent = NO;
    // Do any additional setup after loading the view from its nib.
    [self refreshUserName];
    self.newsBadge = [[JSBadgeView alloc] initWithParentView:self.newsButton alignment:JSBadgeViewAlignmentTopRight];

    [self.newsBadge setBadgeText:@""];
    
}

- (void)refreshUserName{
    if ([UserInfo userLoggedIn]) {
        self.userName.text = [UserInfo loggedUserName];
        [self.userPicture setImageWithURL:[NSURL URLWithString:[UserInfo loggedUserAvatarURL]] placeholderImage:[UIImage imageNamed:@"defaultPic"]];
    }
    else {
        self.userName.text = @"尚未登录";
        [self.userPicture setImage:[UIImage imageNamed:@"defaultPic"]];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    UIInterfaceOrientation o = (UIInterfaceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(o)) {
        self.backgroundImg.image = [UIImage imageNamed:@"windowBG-Landscape.png"];
    }
    else {
        self.backgroundImg.image = [UIImage imageNamed:@"windowBG-Portrait.png"];
    }
}
- (void)viewDidAppear:(BOOL)animated{
    if (!Tapped) {
        [self libraryTapped:self.libButton];
        Tapped = YES;
    }
}
- (void)viewDidUnload
{
    [self setBackgroundImg:nil];
    [self setUserPicture:nil];
    [self setUserName:nil];
    [self setLibButton:nil];
    [self setFavButton:nil];
    [self setWordsButton:nil];
    [self setScoreButton:nil];
//    [self setHelpImgView:nil];
    [self setNewsButton:nil];
    [super viewDidUnload];
    self.slideIn = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
//}
//-(NSUInteger)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskLandscape;
//    
//}
//- (BOOL)shouldAutorotate
//{
//    return NO;
//}
/*
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        self.backgroundImg.image = [UIImage imageNamed:@"windowBG-Landscape.png"];
//        if (_slideIn) {
//            _slideIn.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
//            NSLog(@"frame:(%.1f,%.1f,%.1f,%.1f)",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
////            _slideIn.center = CGPointMake(1024 / 2, 748 / 2);
//        }
    }
    else {
        self.backgroundImg.image = [UIImage imageNamed:@"windowBG-Portrait.png"];
//        if (_slideIn) {
////            _slideIn.center = CGPointMake(768 / 2, 1004 / 2);
//            _slideIn.frame = self.view.bounds;
//             NSLog(@"frame:(%.1f,%.1f,%.1f,%.1f)",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
//        }
    }
    if (_slideIn) {
        _slideIn.frame = CGRectMake(0, 0, self.view.frame.size.height + 20, self.view.frame.size.width + 20);
//        NSLog(@"frame:(%.1f,%.1f,%.1f,%.1f)",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
        //            _slideIn.center = CGPointMake(1024 / 2, 748 / 2);
    }
    
}
 */
- (void)selectButton:(UIButton *)button{
    self.libButton.selected = NO;
    self.favButton.selected = NO;
    self.scoreButton.selected = NO;
    self.wordsButton.selected = NO;
    self.newsButton.selected = NO;
    button.selected = YES;
}
- (IBAction)wordsTapped:(id)sender {
    UIButton * button = (UIButton *)sender;
    [self selectButton:button];
    [XAppDelegate.stackController popToRootViewControllerAnimated:YES];
    NewWordsViewController_iPad * newWords = [[NewWordsViewController_iPad alloc] initWithNibName:nil bundle:nil];
    [XAppDelegate.stackController pushViewController:newWords fromViewController:nil animated:YES];
}

- (IBAction)libraryTapped:(id)sender {
    UIButton * button = (UIButton *)sender;
//    self.helpImgView.hidden = NO;
    [self selectButton:button];
    [XAppDelegate.stackController popToRootViewControllerAnimated:YES];
    LibNFavViewController * libController = [[LibNFavViewController alloc] initWithType:LibViewControllerTypeLib];
    [XAppDelegate.stackController pushViewController:libController fromViewController:nil animated:YES];
}

- (IBAction)favorateTapped:(id)sender {
    UIButton * button = (UIButton *)sender;
//    self.helpImgView.hidden = YES;
    [self selectButton:button];
    [XAppDelegate.stackController popToRootViewControllerAnimated:YES];
    FavorateViewController_iPad * fav = [[FavorateViewController_iPad alloc] initWithNibName:nil bundle:nil];
    [XAppDelegate.stackController pushViewController:fav fromViewController:nil animated:YES];
}

- (IBAction)scoreTapped:(id)sender {
    UIButton * button = (UIButton *)sender;
//    self.helpImgView.hidden = YES;
    [self selectButton:button];
    ScoreViewController * score = [[ScoreViewController alloc] init];
    [XAppDelegate.stackController popToRootViewControllerAnimated:YES];
    [XAppDelegate.stackController pushViewController:score animated:YES];
}

- (IBAction)accountTapped:(id)sender {
    LoginViewController *myLog = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [myLog setHidesBottomBarWhenPushed:YES];
    _settingsNav = [[UINavigationController alloc] initWithRootViewController:myLog];
    
    //        UINavigationItem * item = [[UINavigationItem alloc] initWithTitle:@"用户登录"];
    _settingsNav.navigationBar.tintColor = (IS_IOS7 && !IS_IPAD) ? [UIColor whiteColor] : [UIColor colorWithRed:0.682 green:0.329 blue:0.0 alpha:1];
    _settingsNav.navigationBar.translucent = NO;
    _settingsNav.navigationItem.title = @"用户登录";
    _settingsNav.view.bounds = CGRectMake(0, 0, 400, 480);
    //        NSArray * array = [NSArray arrayWithObject:item];
    //        [navBar setItems:array];
    //        [myLog.view addSubview:navBar];
    myLog.view.frame = CGRectMake(0, -40, 400, 520);
//    myLog.PresOrPush = YES;
    self.slideIn = [[SVSlideInView alloc] initWithSuperView:XAppDelegate.navigationController.view ContentView:_settingsNav.view];
    self.slideIn.delegate = self;
    [self.slideIn showWithType:SVSlideInTypeBottom];
}

- (IBAction)feedbackTapped:(id)sender {
    FeedbackViewController * feedback = [[FeedbackViewController alloc] init];
    self.settingsNav = [[UINavigationController alloc] initWithRootViewController:feedback];
    self.settingsNav.view.bounds = CGRectMake(0, 0, 400, 480);
//    feedback.navigationController.navigationBarHidden = YES;
    self.slideIn = [[SVSlideInView alloc] initWithSuperView:XAppDelegate.stackController.view ContentView:self.settingsNav.view];
    [self.slideIn showWithType:SVSlideInTypeBottom];
}

- (IBAction)settingTapped:(id)sender {
//    UIButton * button = (UIButton *)sender;
    UIInterfaceOrientation o = [[UIApplication sharedApplication] statusBarOrientation];
    IASKAppSettingsViewController * settings = [[IASKAppSettingsViewController alloc] initWithNibName:@"IASKAppSettingsView" bundle:nil];
    
    self.settingsNav = [[UINavigationController alloc] initWithRootViewController:settings];
    UIColor * color = (IS_IOS7 && !IS_IPAD) ? [UIColor whiteColor] : [UIColor colorWithRed:0.682 green:0.329 blue:0.0 alpha:1.0];
    settings.view.backgroundColor = color;
    self.settingsNav.navigationBar.tintColor = color;
    self.settingsNav.navigationBar.translucent = NO;
    self.settingsNav.view.bounds = UIInterfaceOrientationIsLandscape(o) ? CGRectMake(0, 0, 400, 480) : CGRectMake(0, 0, 320, 480);
    _slideIn = [[SVSlideInView alloc] initWithSuperView:XAppDelegate.stackController.view ContentView:self.settingsNav.view];
    _slideIn.delegate = self;
    [_slideIn showWithType:SVSlideInTypeBottom];
//    UIView * settingsView = [[UIView alloc] initWithFrame:XAppDelegate.stackController.view.frame];
//    UIView * background = [[UIView alloc] initWithFrame:XAppDelegate.stackController.view.frame];
////    background.alpha = 0.5;
//    background.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmiss:)];
//    tap.numberOfTapsRequired = 1;
//    [background addGestureRecognizer:tap];
//    [settingsView addSubview:background];
//    [settingsView addSubview:self.settingsNav.view];
////    [background addSubview:controller.view];
//    [XAppDelegate.stackController.view addSubview:settingsView];
//    self.popover = [[UIPopoverController alloc] initWithContentViewController:controller];
//    [self.popover presentPopoverFromRect:button.frame inView:XAppDelegate.stackController.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//    [XAppDelegate.navigationController presentPopupViewController:settings animationType:MJPopupViewAnimationSlideBottomBottom];
//    QuestionsViewController * settings = [[QuestionsViewController alloc] initWithYear:200612 andSec:1];
//    [XAppDelegate.navigationController pushViewController:settings animated:YES];
//    SVPopupView * popup = [[SVPopupView alloc] initWithController:controller];
//    [popup showOnView:XAppDelegate.navigationController.view animationType:SVPopupAnimationBottom];
}
- (void)setNewsBadgeText:(NSString *)text{
    [self.newsBadge setBadgeText:text];
}
- (IBAction)newsTapped:(UIButton *)sender {
    [self selectButton:sender];
    CETNewsViewController_iPad * news = [[CETNewsViewController_iPad alloc] init];
    [XAppDelegate.stackController popToRootViewControllerAnimated:YES];
    [XAppDelegate.stackController pushViewController:news animated:YES];
    [self.newsBadge setBadgeText:@""];
}
- (void)dissmiss:(UIGestureRecognizer*)ges{
    [ges.view.superview removeFromSuperview];
}
- (void)SVSlideInViewDidDisapper:(SVSlideInView *)slideInView{
    [self refreshUserName];
}
@end
