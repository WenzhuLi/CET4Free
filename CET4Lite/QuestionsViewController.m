//
//  QuestionsViewController.m
//  CET4Lite
//
//  Created by Seven Lee on 12-2-29.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "QuestionsViewController.h"
//#import "ROPublishFeedRequestParam.h"
#import "CET4Constents.h"
#import "AppDelegate.h"
#import "UserInfo.h"
#import "UIImage+Screenshot.h"
#import "NSString+MD5.h"
#define kAdviewHideSeconds 60

@interface QuestionsViewController ()

@end

@implementation QuestionsViewController
@synthesize slidIn;
@synthesize QNobtn;
@synthesize scroll;
@synthesize navTitle;
@synthesize NoLabel;
@synthesize AnswerC;
@synthesize CollectButton;
@synthesize RoundBack;
@synthesize answerSheet;
@synthesize ShowButton;
@synthesize ExplainBtn;
@synthesize LeftArrowImg;
@synthesize RightArrowImg;
//@synthesize PlayerView;

//初始化
- (id) initWithYear:(NSInteger)y andSec:(NSInteger)sec
{
    if ([AppDelegate isPad]) {
        self = [super initWithNibName:@"QuestionsViewController_iPad" bundle:nil];
        iPad = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    else {
        if (IS_IPHONE_5) {
            self = [super initWithNibName:@"QuestionsViewController_iPhone5" bundle:nil];
        }
        else
            self = [super initWithNibName:@"QuestionsViewController" bundle:nil];
        iPad = NO;
    }
    
    if (self) {
        // Custom initialization
        year = y;
        section = sec;
        self.answerSheet = nil;
        currentPage = 0;
        FirstAppear = YES;
        navBar = nil;
//        ipadTextReturn = NO;
        _adRemoved = NO;
    }
    return self;
}
- (void)displayAdview{
    [self setAdViewDisplay:YES];
}
- (void)hideAdview{
    [self setAdViewDisplay:NO];
}
- (void)setAdViewDisplay:(BOOL)display{
    if (adViewTimer) {
        [adViewTimer invalidate];
        adViewTimer = nil;
    }
    if (display) {
        adView.hidden = NO;
        adclosebutton.hidden = NO;
//        [adView loadRequest:[GADRequest request]];
    }
    else{
        adView.hidden = YES;
        adclosebutton.hidden = YES;
        adViewTimer = [NSTimer scheduledTimerWithTimeInterval:kAdviewHideSeconds target:self selector:@selector(displayAdview) userInfo:nil repeats:NO];
    }
}
- (void)addCloseButtonOnAd:(GADBannerView *)adview{
    if (adclosebutton) {
        return;
    }
    CGRect frame = adview.frame;
    adclosebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [adclosebutton setImage:[UIImage imageNamed:@"ad_closebutton"] forState:UIControlStateNormal];
    [adclosebutton sizeToFit];
    CGSize buttonSize = adclosebutton.size;
    CGPoint buttonCenter = CGPointMake(frame.origin.x + frame.size.width - buttonSize.width / 2, adView.frame.origin.y + buttonSize.height / 2);
    [adclosebutton addTarget:self action:@selector(hideAdview) forControlEvents:UIControlEventTouchUpInside];
    adclosebutton.center = buttonCenter;
    [adview.superview insertSubview:adclosebutton aboveSubview:adview];
}
- (void)addAdvertisement{
    if ([AppDelegate isPad]) {
        /*
         youmiView = [[YouMiView alloc] initWithContentSizeIdentifier:YouMiBannerContentSizeIdentifier728x90 delegate:nil];
         youmiView.appID = YOUMI_ID;
         youmiView.appSecret = YOUMI_SEC;
         youmiView.appVersion = YOUMI_APP_VER;
         CGRect rect = youmiView.frame;
         youmiView.center = CGPointMake(self.view.center.x, rect.size.height / 2);
         [youmiView start];
         [self.view insertSubview:youmiView atIndex:1];
         */
        adView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeLeaderboard];
        adView.rootViewController = self;
        adView.adUnitID = MY_GAD_ID;
        adView.delegate = self;
        CGRect rect = adView.frame;
        adView.center = CGPointMake(self.view.center.x,self.view.frame.size.height - rect.size.height / 2 - 20);
        //        [youmiView start];
        [self.view insertSubview:adView atIndex:1];
//        [self addCloseButtonOnAd:adView];
        [adView loadRequest:[GADRequest request]];
    }
    else{
        /*
         youmiView = [[YouMiView alloc] initWithContentSizeIdentifier:YouMiBannerContentSizeIdentifier320x50 delegate:nil];
         youmiView.appID = YOUMI_ID;
         youmiView.appSecret = YOUMI_SEC;
         youmiView.appVersion = YOUMI_APP_VER;
         CGRect rect = youmiView.frame;
         youmiView.center = CGPointMake(self.view.center.x, rect.size.height / 2);
         [youmiView start];
         [self.view insertSubview:youmiView atIndex:1];
         */
        adView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        adView.rootViewController = self;
        adView.adUnitID = MY_GAD_ID;
        CGRect rect = adView.frame;
        adView.center = CGPointMake(self.view.center.x, self.view.frame.size.height - rect.size.height / 2);
        //        [youmiView start];
        adView.delegate = self;
        [self.view insertSubview:adView belowSubview:self.answerSheet];
        [adView loadRequest:[GADRequest request]];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = navTitle;
    scroll.delegate = self;
    self.navigationController.delegate = self;
    
    [self.navigationController.navigationBar setTintColor:(IS_IOS7 && !IS_IPAD) ? [UIColor whiteColor] : [UIColor colorWithRed:0.682 green:0.329 blue:0.0 alpha:1]];
    self.navigationController.navigationBar.translucent = NO;
    shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton addTarget:self action:@selector(ShareThisQuestion:) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [shareButton sizeToFit];
    
//    UIBarButtonItem * share = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(ShareThisQuestion:)];
    UIBarButtonItem * shareItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    self.navigationItem.rightBarButtonItem = shareItem;
    self.navigationController.navigationBarHidden = NO;
    shareButton.enabled = NO;
    
//#if DEBUG
//    [self deleteAd:NO];
    CollectButton.alpha = 0;
    if (section != 3) {
        self.AnswerCScrollview_iPad.hidden = YES;
    }
//    self.navigationItem.hidesBackButton = YES;
//
//    UIButton * img = [UIButton buttonWithType:UIButtonTypeCustom];
//    [img setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
//    [img addTarget:self action:@selector(popController) forControlEvents:UIControlEventTouchUpInside];
//    img.frame = CGRectMake(0, 0, 52, 29);
//    UIBarButtonItem * backbutton = [[UIBarButtonItem alloc] initWithCustomView:img];
//    self.navigationItem.leftBarButtonItem = backbutton;
    
//    UIBarButtonItem * sheet = [[UIBarButtonItem alloc] initWithTitle:@"答题" style:UIBarButtonItemStylePlain target:self action:@selector(showAnswerSheet)];
//    UIBarButtonItem * sheet = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"RightTick.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showAnswerSheet)];
//    self.navigationItem.rightBarButtonItem = sheet;

}
- (void)viewWillAppear:(BOOL)animated{
//    UIInterfaceOrientation ori = [[UIDevice currentDevice] orientation];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    self.navigationController.navigationBarHidden = NO;
    UIInterfaceOrientation ori = [UIApplication sharedApplication].statusBarOrientation;
    if ( iPad && UIInterfaceOrientationIsPortrait(ori)) {
        self.scroll.frame = CGRectMake(179, 30, 410, 430);
        NSLog(@"UIInterfaceOrientationIsPortrait([[UIDevice currentDevice] orientation]) && [AppDelegate isPad]");
    }
     [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [self setAdViewDisplay:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    if (iPad) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    if (shareRequest) {
        [shareRequest clearDelegatesAndCancel];
        shareRequest = nil;
    }
    if (adViewTimer) {
        [adViewTimer invalidate];
        adViewTimer = nil;
    }
}
- (void) popController{

    [adpter StopPlayer];
    [WordExplainView RemoveView];
    if (down) {
        [down stopDownload];
        [down removeFromSuperview];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) removeViews{

    [adpter StopPlayer];
    [WordExplainView RemoveView];
    if (down) {
        [down stopDownload];
        [down removeFromSuperview];
    }
}
//- (void) showAnswerSheet{
//        if (self.answerSheet.alpha == 1) 
//            self.answerSheet.alpha = 0;
//        else {
//            [self.answerSheet setArray:[adpter myQuestionArray]];
//            self.answerSheet.alpha = 1;
//        }
//}
//界面出现后再加载题目
//- (void)BackbarbuttonItemPressed:(UIBarButtonItem *)item{
//    [self popController];
//}
- (void)viewDidAppear:(BOOL)animated{
    if (!FirstAppear) {
        return;
    }
    FirstAppear = NO;
    HUD = [[MBProgressHUD alloc] initWithView:self.view.window];
    [self.view.window addSubview:HUD];
	
    HUD.delegate = self;
    HUD.labelText = @"加载中...";
	HUD.removeFromSuperViewOnHide = YES;
    HUD.dimBackground = YES;
    [HUD showWhileExecuting:@selector(loadAll) onTarget:self withObject:nil animated:YES];
}

- (void)loadAll{
    //adpter初始化的过程即将题目加载完成且放入ScrollView中，题目存放在adpter的QuestionArray中
    adpter = [[CETAdapter alloc] initWithYear:year andSec:section scroll:self.scroll];
    adpter.delegate = self;
    //设置题号按钮显示的题号
    if (section < 3) {
        NSString * num = [NSString stringWithFormat:@"%d/%d",[adpter QuestioinNumberofIndex:0],[adpter LastNumber]];
        //        [QNobtn setTitle:num forState:UIControlStateNormal];
        NoLabel.text = num;
        LeftArrowImg.alpha = 0;
        if (iPad) {
            self.AnswerC.hidden = YES;
            ExplainBtn.frame = textButton.frame;
            textButton.frame = AnswerC.frame;
        }
    }
    else {
        NSString * num = [NSString stringWithFormat:@"%d-%d",[adpter QuestioinNumberofIndex:0],[adpter LastNumber]];
        //        [QNobtn setTitle:num forState:UIControlStateNormal];
        NoLabel.text = num;
        CollectButton.hidden = YES;
        //        adpter.AutoNext = YES;
    }
    if (section == 3) {
        //        QuestionCBtnsView * btns = [[QuestionCBtnsView alloc] initWithFrame:CGRectMake(10, scroll.frame.origin.y + scroll.frame.size.height + 10, 300, 150)];
        //        btns.dataSource = adpter;
        //        btns.answerHandler = adpter;
        //        [self.view addSubview:btns];
        AnswerC.hidden = NO;
        ExplainBtn.hidden = YES;
        [self.LeftArrowImg removeFromSuperview];
        [self.RightArrowImg removeFromSuperview];
        if (!iPad) {
            self.answerSheet = [[AnswerSheetC alloc] initWithFrame:CGRectMake(0, self.view.frame.origin.y - (IS_IPHONE_5 ? 768 : 460), 320, 460) Questions:[adpter myQuestionArray]];
            self.answerSheet.delegate = self;
            [self.view insertSubview:answerSheet belowSubview:self.ShowButton];
            //下面这个方法生成一个当前题目的QuestionCView
            QCView = [[QuestionCView alloc] initWithFrame:CGRectMake(0, scroll.frame.origin.y, 0, 0) andQArray:[adpter myQuestionArray]];
            QCView.delegate = adpter;
            QCView.answerHandler = adpter;
            QCView.collectDlegate = self;
            //先将其设为透明,为下面淡入淡出效果做准备
            QCView.alpha = 0;
            [self.view insertSubview:QCView belowSubview:answerSheet];
            
            
        }
    }
    else {
        self.answerSheet = [[AnswerSheetAB alloc] initWithFrame:CGRectMake(0 , -524, 320, 460) Questions:[adpter myQuestionArray]];
        self.answerSheet.delegate = self;
        if (iPad) {
            [self.view addSubview:answerSheet];
        }
        else {
            [self.view insertSubview:answerSheet belowSubview:self.ShowButton];
        }
       
    }
    textView = [adpter readTexts:[adpter QuestioinNumberofIndex:currentPage]];
    
    down = [[DownloaderView alloc] initWithFrame:self.view.bounds Array:[adpter myQuestionArray]];
    down.delegate = self;
    
    //由于子线程里不能对view进行操作，故将余下的工作移动到MBProgressHUDDelegate里面，在主线程中操作
}
- (void)viewDidUnload
{
    [self setAnswerCScrollview_iPad:nil];
    textButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.QNobtn = nil;
    self.NoLabel = nil;
    self.scroll = nil;
    self.AnswerC = nil;
    self.ExplainBtn = nil;
    self.CollectButton = nil;
    self.RoundBack = nil;
    self.ShowButton = nil;
    self.LeftArrowImg = nil;
    self.RightArrowImg = nil;
    navBar = nil;
    iPadPop = nil;
    cview = nil;
    HUD = nil;
    storeKit = nil;
//    youmiView = nil;
    adView = nil;
    shareButton = nil;
    adclosebutton = nil;
    if (adViewTimer) {
        [adViewTimer invalidate];
        adViewTimer = nil;
    }
    [super viewDidUnload];
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    if (iPad) {
//        return UIInterfaceOrientationIsLandscape(interfaceOrientation);
//    }
//    else {
//        return (interfaceOrientation == UIInterfaceOrientationPortrait);
//    }
//    
//}
//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration{
//    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
//        self.scroll.frame = CGRectMake(71, 71, 410, 430);
//        adpter.Player.center = CGPointMake(self.scroll.center.x, self.scroll.center.y + self.scroll.frame.size.height / 2 + adpter.Player.frame.size.height / 2) ;
//        CollectButton.center = CGPointMake(adpter.Player.center.x, adpter.Player.center.y + 30);
//        self.answerSheet.center = CGPointMake(720, self.scroll.center.y + 20);
//        if (down) {
//            down.frame = self.view.frame;
//            NSLog(@"frame:(%.1f,%.1f,%.1f,%.1f)",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
//        }
//    }
//    else {
//        self.scroll.frame = CGRectMake(179, 30, 410, 430);
//         adpter.Player.center = CGPointMake(self.scroll.center.x, self.scroll.center.y + self.scroll.frame.size.height / 2 + adpter.Player.frame.size.height / 2) ;
//        CollectButton.center = CGPointMake(adpter.Player.center.x, adpter.Player.center.y + 30);
//        self.answerSheet.center = CGPointMake(self.scroll.center.x, 800);
//        if (down) {
//            down.frame = self.view.frame;
//            NSLog(@"frame:(%.1f,%.1f,%.1f,%.1f)",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
//        }
//    }
//}
//点下原文时,从数据库中读取当前题目的原文
- (void) showExplain:(CGPoint) center{
    if (expView) //如果textView存在，则将其删除
        [expView removeFromSuperview];
    
    //下面这个方法生成一个当前题目的textView
    expView = [adpter readExplains:[adpter QuestioinNumberofIndex:currentPage]];
    
    //先将其设为透明,为下面淡入淡出效果做准备
    expView.alpha = 0;
    [self.view insertSubview:expView belowSubview:answerSheet];
    
    //设置两个View切换时的淡入淡出效果
    [UIView beginAnimations:@"Switch" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:.5];
    //            QNobtn.frame = sender.frame;
    //            QNobtn.hidden = NO;
    [RoundBack setCenter:center];
    scroll.alpha = 0;
    expView.alpha = 1;
    QCView.alpha = 0;
    adpter.Player.alpha = 1;
    if (textView) {
        textView.alpha = 0;
    }
    LeftArrowImg.alpha = 0;
    RightArrowImg.alpha = 0;
    [UIView commitAnimations];
}
- (void) showText:(CGPoint) center{
    if (textView) //如果textView存在，则将其删除
        [textView removeFromSuperview];
    
    //下面这个方法生成一个当前题目的textView
    textView = [adpter readTexts:[adpter QuestioinNumberofIndex:currentPage]];
    adpter.Player.SynchroID = textView;
    //先将其设为透明,为下面淡入淡出效果做准备
    textView.alpha = 0;
    [self.view insertSubview:textView belowSubview:answerSheet];
    
    //设置两个View切换时的淡入淡出效果
    [UIView beginAnimations:@"Switch" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:.5];
    //            QNobtn.frame = sender.frame;
    //            QNobtn.hidden = NO;
    [RoundBack setCenter:center];
    scroll.alpha = 0;
    textView.alpha = 1;
    expView.alpha = 0;
    QCView.alpha = 0;
    adpter.Player.alpha = 1;
    LeftArrowImg.alpha = 0;
    RightArrowImg.alpha = 0;
    [UIView commitAnimations];
}
- (IBAction)SeeTheText:(UIButton *)sender{
    if (QCView && sender.tag != 4) {
        [QCView willDisappear];
    }
    switch (sender.tag) {
        case 1://原文按钮按下时
//            if (year <= 200612 ||[SVStoreKit productPurchased:IAPIDText]) {
                [self showText:sender.center];
//            }
//            else {
//                UIAlertView * textAlert = [[UIAlertView alloc] initWithTitle:@"购买" message:@"购买所有原文并移除广告。重复购买不会扣费。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"购买",@"恢复购买", nil];
//                textAlert.tag = IAPAlertTagText;
//                [textAlert show];
//            }
            
            break;
        case 2://题目按钮按下时
            if (scroll.alpha == 1)
                //若当前显示的就是题目页面,则什么都不做
                break;
            else {
                //当前显示的是textView,则进行切换,同样的淡入淡出效果
                
                //                [sender setTitle:@"原文" forState:UIControlStateNormal];
                float alphaLeft = currentPage == 0? 0.0 : 1.0;
                float alphaRight = currentPage == [[adpter myQuestionArray] count] - 1 ? 0.0 : 1.0;
                [UIView beginAnimations:@"Switch" context:nil];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:.5];
                //                sender.hidden = YES;
                [RoundBack setCenter:sender.center];
                scroll.alpha = 1;
                textView.alpha = 0;
                expView.alpha = 0;
                QCView.alpha = 0;
                adpter.Player.alpha = 1;
                LeftArrowImg.alpha = alphaLeft;
                RightArrowImg.alpha = alphaRight;
                [UIView commitAnimations];
            }
            break;
        case 3://解析按下时，从数据库中读当前解析
            //            [self showBuyAlert];
//#if DEBUG
//            [self deleteAd:YES];
//#else
            if ([SVStoreKit productPurchased:IAPIDExplain] || [UserInfo isVIPValid]) {
                [self showExplain:sender.center];
            }
            else {
                UIAlertView * textAlert = [[UIAlertView alloc] initWithTitle:@"购买" message:@"\n✓获得所有解析\n✓VIP高速下载通道\n✓移除广告\n\n(重复购买不会扣费)" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"购买",@"恢复购买", nil];
                textAlert.tag = IAPAlertTagExplain;
                [textAlert show];
            }
//#endif
            break;
        case 4:
            
            //设置两个View切换时的淡入淡出效果
            [UIView beginAnimations:@"Switch" context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:.5];
            //            QNobtn.frame = sender.frame;
            //            QNobtn.hidden = NO;
            [RoundBack setCenter:sender.center];
            scroll.alpha = 0;
            QCView.alpha = 1;
            textView.alpha = 0;
            adpter.Player.alpha = 0;
            [UIView commitAnimations];
            [QCView willappear];
            break;
        default:
            break;
    }
}
- (IBAction)SeeTheTextIPAD:(UIButton *)sender{
    switch (sender.tag) {
        case 0: //原文
        {
//            if (year <= 200612 ||[SVStoreKit productPurchased:IAPIDText]) {
                //下面这个方法生成一个当前题目的textView
                textView = [adpter readTexts:[adpter QuestioinNumberofIndex:currentPage]];
                adpter.Player.SynchroID = textView;
                UIViewController * controller = [[UIViewController alloc] init];
                //            controller.view.bounds = CGRectMake(0, 0, 320, 480);
                controller.view = textView;
                //            [controller.view addSubview:textView];
                iPadPop = [[UIPopoverController alloc] initWithContentViewController:controller];
                iPadPop.popoverContentSize = textView.size;
                NSLog(@"text.width = %.1f height = %.1f",textView.frame.size.width,textView.frame.size.height);
                [iPadPop presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//            }
//            else {
//                UIAlertView * textAlert = [[UIAlertView alloc] initWithTitle:@"购买" message:@"购买所有原文并移除广告。重复购买不会扣费。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"购买",@"恢复购买", nil];
//                textAlert.tag = IAPAlertTagText;
//                [textAlert show];
//            }
            break;
        }
        case 1: //解析
        {
//#if DEBUG
//            [self deleteAd:YES];
//#endif
            if ([SVStoreKit productPurchased:IAPIDExplain] || [UserInfo isVIPValid]) {
                //下面这个方法生成一个当前题目的textView
                expView = [adpter readExplains:[adpter QuestioinNumberofIndex:currentPage]];
                UIViewController * controller = [[UIViewController alloc] init];
                //            controller.view.bounds = CGRectMake(0, 0, 320, 480);
                controller.view = expView;
                //            [controller.view addSubview:textView];
                iPadPop = [[UIPopoverController alloc] initWithContentViewController:controller];
                iPadPop.popoverContentSize = expView.size;
                //            NSLog(@"text.width = %.1f height = %.1f",textView.frame.size.width,textView.frame.size.height);
                [iPadPop presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
            else {
                UIAlertView * textAlert = [[UIAlertView alloc] initWithTitle:@"购买" message:@"\n✓获得所有解析\n✓VIP高速下载通道\n✓移除广告\n\n(重复购买不会扣费)" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"购买",@"恢复购买", nil];
                textAlert.tag = IAPAlertTagExplain;
                [textAlert show];
            }
            
            break;
        }
        case 2: //SectionC 答案
        {
            AnswerSheetC * sheetC = [[AnswerSheetC alloc]initWithFrame:CGRectMake(0, 0, 320, 480) Questions:adpter.myQuestionArray];
            [sheetC setUserName:[UserInfo loggedUserName]];
            sheetC.delegate = self;
//            [sheetC HandInAnswerSheet:nil];
            UIViewController * controller = [[UIViewController alloc] init];
            //            controller.view.bounds = CGRectMake(0, 0, 320, 480);
            controller.view = sheetC;
            //            [controller.view addSubview:textView];
            iPadPop = [[UIPopoverController alloc] initWithContentViewController:controller];
            iPadPop.popoverContentSize = sheetC.size;
            //            NSLog(@"text.width = %.1f height = %.1f",textView.frame.size.width,textView.frame.size.height);
            [iPadPop presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            break;
        }
        default:
            break;
    }
    
}
- (IBAction)RollScroll:(UIButton *)sender{
    CGRect frame = scroll.frame;
    frame.origin.x = frame.size.width * (currentPage + sender.tag);
    frame.origin.y = 0;
    [scroll scrollRectToVisible:frame animated:YES];
}
- (IBAction)NewCollection:(UIButton *)sender{
    if (iPad) {
        [adpter CurrentPageChanged:sender.tag - 36];
    }
    NSError * err = [adpter NewCollection];
    if (err) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"收藏失败。。。" message:err.domain delegate:nil cancelButtonTitle:@"好吧" otherButtonTitles: nil];
        [alert show];
    }
    else {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"收藏成功！" message:@"收藏成功，您可以在收藏目录下查看您已收藏的题目" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
}
- (IBAction)HideOrShowAnswerSheet:(UIButton *)sender{
    if (section == 3) {
        [adpter restoreCurrentAnswer:[QCView CurrentCustomAnswer]];
    }
    
    [answerSheet setArray:[adpter myQuestionArray]];

    [answerSheet setUserName:[[NSUserDefaults standardUserDefaults] objectForKey:@"LoggedUser"]];
    if (sender.selected) 
        [self HideAnswerSheet];
    else 
        [self ShowAnswerSheet];
}
- (void)ShowAnswerSheet{
    if (QCView) {
        
        [QCView willDisappear];
    }
    if (IS_IPHONE_5) {
        [UIView beginAnimations:@"Show" context:nil];
        [UIView setAnimationDuration:.5];
        //    answerSheet.frame = CGRectMake(self.ShowButton.frame.size.width, answerSheet.frame.origin.y, answerSheet.frame.size.width, answerSheet.frame.size.height);
        //    self.ShowButton.frame = CGRectMake(0, self.ShowButton.frame.origin.y, self.ShowButton.frame.size.width, self.ShowButton.frame.size.height);
        answerSheet.frame = CGRectMake(0, 0, answerSheet.frame.size.width, answerSheet.frame.size.height);
        self.ShowButton.frame = CGRectMake(self.ShowButton.frame.origin.x, 460 - self.ShowButton.frame.size.height, self.ShowButton.frame.size.width, self.ShowButton.frame.size.height);
//        self.navigationController.navigationBarHidden = YES;
        [UIView commitAnimations];
    }
    else{
        [UIView beginAnimations:@"Show" context:nil];
        [UIView setAnimationDuration:.5];
//    answerSheet.frame = CGRectMake(self.ShowButton.frame.size.width, answerSheet.frame.origin.y, answerSheet.frame.size.width, answerSheet.frame.size.height);
//    self.ShowButton.frame = CGRectMake(0, self.ShowButton.frame.origin.y, self.ShowButton.frame.size.width, self.ShowButton.frame.size.height);
        answerSheet.frame = CGRectMake(0, 0, answerSheet.frame.size.width, answerSheet.frame.size.height);
        self.ShowButton.frame = CGRectMake(self.ShowButton.frame.origin.x, 460 - self.ShowButton.frame.size.height, self.ShowButton.frame.size.width, self.ShowButton.frame.size.height);
        self.navigationController.navigationBarHidden = YES;
        [UIView commitAnimations];
    }
    self.ShowButton.selected = YES;
}
- (void)HideAnswerSheet{
    
    [UIView beginAnimations:@"Show" context:nil];
    [UIView setAnimationDuration:.5];
//    answerSheet.frame = CGRectMake(320, answerSheet.frame.origin.y, answerSheet.frame.size.width, answerSheet.frame.size.height);
//    self.ShowButton.frame = CGRectMake(320 - self.ShowButton.frame.size.width, self.ShowButton.frame.origin.y, self.ShowButton.frame.size.width, self.ShowButton.frame.size.height);
    answerSheet.frame = CGRectMake(0, -64 - answerSheet.frame.size.height, answerSheet.frame.size.width, answerSheet.frame.size.height);
//    self.ShowButton.frame = CGRectMake(self.ShowButton.frame.origin.x, 0, self.ShowButton.frame.size.width, self.ShowButton.frame.size.height);
    self.ShowButton.frame = CGRectMake(self.ShowButton.frame.origin.x, 0, self.ShowButton.frame.size.width, self.ShowButton.frame.size.height);
    self.navigationController.navigationBarHidden = NO;
    [UIView commitAnimations];
    self.ShowButton.selected = NO;
    if (QCView.alpha == 1) {
        [QCView willappear];
    }
}
- (void)ShareThisQuestion:(id)sender{
    if (QCView) {
        currentPage = [QCView CurrentIndex];
    }
    
//    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionAny];
    UIImage * screenshot = [UIImage screenshot];
    NSInteger number = [adpter QuestioinNumberofIndex:currentPage];
    NSArray * ABCArray = [NSArray arrayWithObjects:@"A",@"B",@"C", nil];
    NSString * url = [NSString stringWithFormat:@"http://apps.iyuba.com/newcet/cetListening.jsp?year=%d&testType=%d&level=6&number=%d",year,section,number];
    NSString * userid = [UserInfo loggedUserID];
    if (![userid isEqualToString:@""]) {
        url = [url stringByAppendingFormat:@"&shareId=%@",userid];
    }
    NSString * Message = [NSString stringWithFormat:@"英语四级%d年%d月真题Section%@第%d题",year/100,year%100,[ABCArray objectAtIndex:section - 1],number];
    NSString * WeiboContent = [NSString stringWithFormat:@"#四六级# %@%@ @爱语吧 ",Message,url];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:WeiboContent
                                       defaultContent:@""
                                                image:[ShareSDK jpegImageWithImage:screenshot quality:1.0]
                                                title:@"爱语吧四级听力"
                                                  url:kMyWebLink
                                          description:Message
                                            mediaType:SSPublishContentMediaTypeNews];
    //定制人人网信息
    [publishContent addRenRenUnitWithName:@"爱语吧四级听力"
                              description:@"原文,声音,答案,解析四位一体的全新听力练习模式"
                                      url:kMyWebLink
                                  message:@"大家一起都来听听，共同提高英语听力"
                                    image:INHERIT_VALUE
                                  caption:@"来自爱语吧四级听力iPhone应用的分享"];
    //定制QQ空间信息
//    [publishContent addQQSpaceUnitWithTitle:@"Hello QQ空间"
//                                        url:INHERIT_VALUE
//                                       site:nil
//                                    fromUrl:nil
//                                    comment:INHERIT_VALUE
//                                    summary:INHERIT_VALUE
//                                      image:INHERIT_VALUE
//                                       type:INHERIT_VALUE
//                                    playUrl:nil
//                                       nswb:nil];
    
    //定制微信好友信息
//    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
//                                         content:INHERIT_VALUE
//                                           title:@"爱语吧六级听力"
//                                             url:INHERIT_VALUE
//                                           image:INHERIT_VALUE
//                                    musicFileUrl:nil
//                                         extInfo:nil
//                                        fileData:nil
//                                    emoticonData:nil];
    
    //定制微信朋友圈信息
    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeMusic]
                                          content:@"原文,声音,答案,解析四位一体的全新听力练习模式,亲爱的们来试试吧~"
                                            title:@"爱语吧四级听力"
                                              url:url
                                            image:[ShareSDK jpegImageWithImage:screenshot quality:1.0]
                                     musicFileUrl:nil
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
    
    //定制QQ分享信息
    [publishContent addQQUnitWithType:INHERIT_VALUE
                              content:INHERIT_VALUE
                                title:@"Hello QQ!"
                                  url:url
                                image:INHERIT_VALUE];
    //定制邮件信息
    [publishContent addMailUnitWithSubject:@"【分享应用】英语四级听力真题"
                                   content:[NSString stringWithFormat:@"<p>✿ 历年真题免费体验。</p><p>✿ 简单易用。点击答案，自动涂卡，声音、原文、答案、解析四位一体。</p><p>✿ 科学实用。交卷后记录每次的考试成绩，分析正确率，助您发现自己的弱势并进行针对性训练。</p><p>✿ 权威解析。特邀四六级名师独家解析，每道题目都明明白白。</p><p>✿ 温故知新。将不会的题、做错的题加入收藏夹，反复练习。</p><p><a href= %@>点击下载苹果端应用 </a></p><p><a href = %@>点击下载安卓APK</a></p>",kMyWebLink,kMyAPKLink]
                                    isHTML:[NSNumber numberWithBool:YES]
                               attachments:INHERIT_VALUE
                                        to:nil
                                        cc:nil
                                       bcc:nil];
    
    //定制短信信息
//    [publishContent addSMSUnitWithContent:[NSString stringWithFormat:@"有个好应用介绍给你~提高四六级听力哦~快去下载吧%@",kMyWebLink]];
    NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeSinaWeibo, ShareTypeTencentWeibo, ShareTypeRenren,ShareTypeWeixiSession,ShareTypeWeixiTimeline, ShareTypeMail,nil];
//    if (iPad) {
        //创建弹出菜单容器
        id<ISSContainer> container = [ShareSDK container];
        [container setIPadContainerWithBarButtonItem:self.navigationItem.rightBarButtonItem arrowDirect:UIPopoverArrowDirectionAny];
//    }
    //创建弹出菜单容器
    //    UIBarButtonItem * item = self.navigationItem.rightBarButtonItem;
//    id<ISSContainer> container = [ShareSDK container];
    //    [container setIPadContainerWithBarButtonItem:sender arrowDirect:UIPopoverArrowDirectionAny];
//    [container setIPadContainerWithView:shareButton arrowDirect:UIPopoverArrowDirectionAny];
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: [ShareSDK defaultShareOptionsWithTitle:@"分享题目" oneKeyShareList:nil qqButtonHidden:YES wxSessionButtonHidden:NO wxTimelineButtonHidden:NO showKeyboardOnAppear:YES shareViewDelegate:nil friendsViewDelegate:nil picViewerViewDelegate:nil]
                            result:^(ShareType type, SSPublishContentState state,
                                     id<ISSStatusInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSPublishContentStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                    NSString * userID = [UserInfo loggedUserID];
                                    NSString * platform = nil;
                                    NSString * titleid = [NSString stringWithFormat:@"%d%d%d",year,section,number];
                                    switch (type) {
                                        case ShareTypeWeixiSession:
                                            platform = @"qq";
                                            break;
                                        case ShareTypeWeixiTimeline:
                                            platform = @"qq";
                                            break;
                                        case ShareTypeSinaWeibo:
                                            platform = @"weibo";
                                            break;
                                        case ShareTypeRenren:
                                            platform = @"renren";
                                            break;
                                        default:
                                            platform = @"qq";
                                            break;
                                    }
                                    if ([userID isEqualToString:@""]) {
                                        //NSLog(@"not logged");
                                        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"分享成功" message:@"登录爱语吧账号后再分享可获得爱语币哦～" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                        [alert show];
                                    }
                                    else {
                                        NSString * md5input = [NSString stringWithFormat:@"%@103ios%@%@1iyuba",userID,platform,titleid];
                                        NSString * md5output = [md5input MD5String];
                                        NSString * url = [NSString stringWithFormat:@"http://app.iyuba.com/share/doShare.jsp?userId=%@&appId=102&from=ios&to=%@&type=1&titleId=%@&sign=%@",userID,platform,titleid,md5output];
                                        NSLog(@"url:%@",url);
                                        shareRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
                                        shareRequest.delegate = self;
                                        [shareRequest startAsynchronous];
                                    }
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error
                                                                   errorCode], [error errorDescription]);
                                }
                            }];
    /*
    UIActionSheet * share = [[UIActionSheet alloc] initWithTitle:@"将当前题目分享至" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"新浪微博",@"人人网",@"腾讯微博", nil];
    [share showInView:self.view.window];
     */
    
    
    
}
#pragma mark GADBannerViewDelegate
- (void)adViewDidReceiveAd:(GADBannerView *)view{
    [self addCloseButtonOnAd:view];
}
#pragma mark ASIHTTPRequestDelegate
- (void)requestFailed:(ASIHTTPRequest *)request {
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"分享成功" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
    //    [self hide];
    NSLog(@"share failed");
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSData *myData = [request responseData];
    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:myData options:0 error:nil];
    NSArray *items = [doc nodesForXPath:@"response" error:nil];
    if (items) {
        for (DDXMLElement *obj in items) {
            int result = [[[obj elementForName:@"result"] stringValue] intValue];
            NSLog(@"result : %d",result);
            NSString *msg = [[obj elementForName:@"msg"] stringValue];
            NSLog(@"msg:%@",msg);
            if (result == 1) {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                alert.tag = request.tag;
                [alert show];
            }else {
//                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"分享成功" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                alert.tag = request.tag;
//                [alert show];
            }
        }
    }
    request.delegate = nil;
}
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)sender{
    
    //用户滑动题目时会响应这个事件
    
    if (!sender.pagingEnabled) {
        return;
    }
    
    //计算当前页面
    CGFloat pageWidth = sender.frame.size.width;
    int page = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    //滑过1/2时才更换新页面
    if (page == currentPage || page < 0 || page >= [adpter.myQuestionArray count]) {
        return;
    }
    currentPage = page;

    
    //更新currentPage的同时更新题号显示
    if (section < 3) {
        if (iPad) {
            self.navigationItem.title = [NSString stringWithFormat:@"%@ 第%d题",self.navTitle,[adpter QuestioinNumberofIndex:page]];
        }
        else {
            NSString * num = [NSString stringWithFormat:@"%d/%d",[adpter QuestioinNumberofIndex:page],[adpter LastNumber]];
            NoLabel.text = num;
        }
        
        [adpter CurrentPageChanged:currentPage];
//        [QNobtn setTitle:num forState:UIControlStateNormal];
        
        if (currentPage == 0) {
            LeftArrowImg.alpha = 0;
            RightArrowImg.alpha = 1;
        }
        else {
            if (currentPage == [[adpter myQuestionArray] count] - 1 ) {
                LeftArrowImg.alpha = 1;
                RightArrowImg.alpha = 0;
            }
            else {
                LeftArrowImg.alpha = 1;
                RightArrowImg.alpha = 1;
            }
        }
    }
    
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == IAPAlertTagText){
        switch (buttonIndex) {
            case 2: //恢复购买
                NSLog(@"恢复购买");
                HUD = [[MBProgressHUD alloc] initWithView:self.view];
                HUD.labelText = @"正在恢复，请稍候";
                [self.view addSubview:HUD];
                HUD.removeFromSuperViewOnHide = YES;
                [HUD show:YES];
                if (!storeKit) {
                    storeKit = [[SVStoreKit alloc] initWithDelegate:self];
                }
                [storeKit restorePurchase];
                break;
            case 1: //购买
            {
                HUD = [[MBProgressHUD alloc] initWithView:self.view];
                HUD.labelText = @"购买中";
                [self.view addSubview:HUD];
                HUD.removeFromSuperViewOnHide = YES;
                [HUD show:YES];
                NSLog(@"购买");
//                [self deleteAd:YES];
                storeKit = [[SVStoreKit alloc] initWithDelegate:self];
                [storeKit buyIdentifier:IAPIDText];
                storeKit.tag = IAPAlertTagText;
                
            }
                break;
            default:
                break;
        }
    }
    else if(alertView.tag == IAPAlertTagExplain){
        switch (buttonIndex) {
            case 1: //购买
            {
                NSLog(@"购买");
                HUD = [[MBProgressHUD alloc] initWithView:self.view];
                HUD.labelText = @"购买中";
                [self.view addSubview:HUD];
                HUD.removeFromSuperViewOnHide = YES;
                [HUD show:YES];
//#if DEBUG
//                [self deleteAd:YES];
//#else
                storeKit = [[SVStoreKit alloc] initWithDelegate:self];
                [storeKit buyIdentifier:IAPIDExplain];
                storeKit.tag = IAPAlertTagExplain;
                
//#endif
            }
                break;
            case 2: //恢复购买
                NSLog(@"恢复购买");
                HUD = [[MBProgressHUD alloc] initWithView:self.view];
                HUD.labelText = @"正在恢复，请稍候";
                HUD.removeFromSuperViewOnHide = YES;
                [self.view addSubview:HUD];
                [HUD show:YES];
                if (!storeKit) {
                    storeKit = [[SVStoreKit alloc] initWithDelegate:self];
                }
                [storeKit restorePurchase];
                break;
            default:
                break;
        }
    }
}


#pragma mark DownloaderViewDelegate
- (void) DowloaderViewDidFinishDownload:(DownloaderView *)downloaderView{
//    PlayerView = [[AudioPlayerView alloc] initWithFrame:CGRectMake(0,340, 320, 65 )];
//    
//    adpter.Player = PlayerView;
    [self addAdvertisement];
    [self ensureIAPandDeleteAd:YES];
    [adpter initPlayer];
    CollectButton.alpha = 1.0;
//    if (IS_IPHONE_5) {
        adpter.Player.center = CGPointMake(self.scroll.center.x, self.scroll.center.y + self.scroll.frame.size.height / 2 + adpter.Player.frame.size.height / 2) ;
//    }
    if (iPad) {
        adpter.Player.center = CGPointMake(self.scroll.center.x, self.scroll.center.y + self.scroll.frame.size.height / 2 + adpter.Player.frame.size.height / 2) ;
        CollectButton.center = CGPointMake(adpter.Player.center.x + adpter.Player.frame.size.width / 2 - 30, adpter.Player.center.y );
        if (section != 3) {
            [self.answerSheet setUserName:[UserInfo loggedUserName]];
            self.answerSheet.center = UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])? CGPointMake(740, self.scroll.center.y ) : CGPointMake(self.scroll.center.x, 800);
        }
        else{
            self.answerSheet = nil;
        }
    }
    [self.view insertSubview:adpter.Player belowSubview:CollectButton];
//    self.navigationItem.rightBarButtonItem.enabled = YES;
    shareButton.enabled = YES;
}
- (void) DowloaderViewDidFailedDownload:(DownloaderView *)downloaderView{
    [self popController];
}
- (void) DowloaderViewCancelled:(DownloaderView *)downloaderView{
    [self popController];
}
#pragma mark -
#pragma mark AnswerSheetDelegate
- (void) AnswerSheet:(AnswerSheet *) answersheet QuestionIndexTapped:(NSInteger)index{
    if (!iPad) {
        [self HideAnswerSheet];
    }
    
    if (section == 3) {
//        CGRect frame = CGRectMake(index * scroll.frame.size.width, 0, scroll.frame.size.width, scroll.frame.size.height);
        if (!iPad){
            [self SeeTheText:self.AnswerC];
            [QCView rollToIndex:index];
        }
        else {
            if (iPadPop) {
                [iPadPop dismissPopoverAnimated:YES];
            }
            for (UITextField * textfield in self.AnswerCScrollview_iPad.subviews) {
                if (textfield.tag == index + 36) {
                    [textfield becomeFirstResponder];
                    break;
                }
            }
//            cview = [[AnswerCViewController_iPad alloc] initWithQuestion:[[adpter myQuestionArray] objectAtIndex:index] adapter:adpter];
//            slidIn = [[SVSlideInView alloc] initWithSuperView:self.view ContentView:cview.view];
//            [slidIn showWithType:SVSlideInTypeBottom];
        }
    }
    else {
        [self SeeTheText:self.QNobtn];
        CGRect frame = CGRectMake(index * scroll.frame.size.width, 0, scroll.frame.size.width, scroll.frame.size.height);
        [scroll scrollRectToVisible:frame animated:YES];
    }
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (IS_IPAD) {
        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight );
    }
    else{
        return interfaceOrientation == UIInterfaceOrientationPortrait;
    }
    
}

-(NSUInteger)supportedInterfaceOrientations{
    if (IS_IPAD) {
        return UIInterfaceOrientationMaskLandscape;
    }
    else
        return UIInterfaceOrientationMaskPortrait;
    
}

- (BOOL)shouldAutorotate
{
    if (IS_IPAD) {
        return YES;
    }
    else
        return NO;
}
- (void) AnswerSheetHandedIn:(AnswerSheet *)answersheet{
    float score = [adpter HandInAnswerSheet];
    if (QCView)
        [QCView showRightOrWrongAndDisable];

}
- (void) AnswerSheetWannaLogin:(AnswerSheet *)answersheet{
    LoginViewController *myLog = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [myLog setHidesBottomBarWhenPushed:YES];
    //            UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:myLog];
    
    if (!iPad) {
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:myLog];
        SevenNavigationBar * _navBar = [[SevenNavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        UIBarButtonItem * back = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:myLog action:@selector(Cancel:)];
        //            navBar.backItem
        UINavigationItem * item = [[UINavigationItem alloc] initWithTitle:@"用户登录"];
        _navBar.translucent = NO;
        if (IS_IOS7 && !IS_IPAD) {
            _navBar.tintColor = [UIColor whiteColor];
        }
        else
            _navBar.tintColor = [UIColor colorWithRed:0.682 green:0.329 blue:0.0 alpha:1];
        item.leftBarButtonItem = back;
        NSArray * array = [NSArray arrayWithObject:item];
        myLog.view.frame = CGRectMake(0, 44, 320, 416);
        [_navBar setItems:array];
//        [myLog.view addSubview:_navBar];
        [nav.navigationBar addSubview:_navBar];
        myLog.PresOrPush = YES;
        [self presentModalViewController:nav animated:YES];
        [self HideAnswerSheet];

    }
    else {
        if (iPadPop) {
            [iPadPop dismissPopoverAnimated:YES];
        }
         navBar = [[UINavigationController alloc] initWithRootViewController:myLog];
        
//        UINavigationItem * item = [[UINavigationItem alloc] initWithTitle:@"用户登录"];
        navBar.navigationBar.translucent = NO;
        if (IS_IOS7 && !IS_IPAD) {
            navBar.navigationBar.tintColor = [UIColor whiteColor];
            navBar.navigationBar.barTintColor = [UIColor whiteColor];
            
        }
        else
            navBar.navigationBar.tintColor = [UIColor colorWithRed:0.682 green:0.329 blue:0.0 alpha:1];
        navBar.navigationItem.title = @"用户登录";
        navBar.view.bounds = CGRectMake(0, 0, 400, 480);
//        NSArray * array = [NSArray arrayWithObject:item];
//        [navBar setItems:array];
//        [myLog.view addSubview:navBar];
        myLog.view.frame = CGRectMake(0, -40, 400, 520);
//        myLog.PresOrPush = YES;
        self.slidIn = [[SVSlideInView alloc] initWithSuperView:self.view ContentView:navBar.view];
        self.slidIn.delegate = self;
        [self.slidIn showWithType:SVSlideInTypeBottom];
    }
}

#pragma mark QuestionCViewCollectDelegate
- (void) AddCurrentQuestionToFav:(NSInteger)index{
    [self NewCollection:nil];
}
//- (void) AnswerSheetWantsToHide:(AnswerSheet *)answersheet{
////    [answersheet setCenter:CGPointMake(320 + answersheet.frame.size.width / 2 - 38, answersheet.center.y)];
//    [self HideAnswerSheet];
//}
//- (void) AnswerSheetWantsToDisplay:(AnswerSheet *)answersheet{
////    [answersheet setCenter:CGPointMake(answersheet.frame.size.width / 2 , answersheet.center.y)];
//    [self ShowAnswerSheet];
//}
#pragma mark navigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([viewController isEqual:self]) {
        return;
    }
    [self removeViews];
}

#pragma mark MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud{
    [self.view addSubview:down];
    [down startDownload];
}
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    /*
    NSInteger number = [adpter QuestioinNumberofIndex:currentPage];
    NSArray * ABCArray = [NSArray arrayWithObjects:@"A",@"B",@"C", nil];
    NSString * url = [NSString stringWithFormat:@"http://apps.iyuba.com/newcet/cetListening.jsp?year=%d&testType=%d&level=6&number=%d",year,section,number];
    NSString * userid = [UserInfo loggedUserID];
    if (![userid isEqualToString:@""]) {
        url = [url stringByAppendingFormat:@"&shareId=%@",userid];
    }
    NSString * Message = [NSString stringWithFormat:@"英语四级%d年%d月真题Section%@第%d题",year/100,year%100,[ABCArray objectAtIndex:section - 1],number];
    NSString * WeiboContent = [NSString stringWithFormat:@"#四六级# %@%@ @爱语吧 ",Message,url];
    if (QCView) {
        
        [QCView willDisappear];
    }
    SVShareTool * shareTool = [SVShareTool DefaultShareTool];
    
    NSMutableDictionary *params = nil;
    NSString * titleid = [NSString stringWithFormat:@"%d%d%d",year,section,number];
    
    switch (buttonIndex) {
        case 0://新浪微博
            // 微博分享：
            [shareTool GetScreenshotAndShareOnWeibo:self WithContent:WeiboContent AndDelegate:self andTitleId:titleid];
            break;
        case 1:
            //人人分享：
            params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      url,@"url",
                      Message,@"name",
                      @"四级听力iPhone",@"action_name",
                      kMyWebLink,@"action_link",
                      @"原文,声音,答案,解析四位一体的全新听力练习模式",@"description",
                      @"来自爱语吧四级听力iPhone应用的分享",@"caption",
                      kMyRenRenImage,@"image",
                      @"大家一起都来听听，共同提高英语听力",@"message",
                      nil];
            [shareTool PublishFeedOnRenRen:self WithFeedParam:params andTitleID:titleid];
            break;
        default:
            break;
    }
      */
}
#pragma mark -
#pragma CETAdapterDelegate
- (void) Answer:(NSString *)answer ofNumberStored:(NSInteger)number{
    if (iPad) {
        [self.answerSheet setArray:adpter.myQuestionArray];
    }
}
- (IBAction)playQuestionSound:(UIButton *)sender {
    [adpter CurrentPageChanged:sender.tag - 36];
    [adpter PlayCurrentQuestionSound:nil];
}
#pragma mark - 
#pragma UITextFieldDelegate_ForIPAD
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [adpter CurrentPageChanged:textField.tag - 36];
    [adpter restoreCurrentAnswer:textField.text];
//    if (!ipadTextReturn) {
//        [self.AnswerCScrollview_iPad setContentOffset:CGPointMake(0, 0) animated:NO];
//    }
//    ipadTextReturn = NO;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.AnswerCScrollview_iPad setContentOffset:CGPointMake(0, textField.frame.origin.y - 180 > 0 ? textField.frame.origin.y - 180 : 0) animated:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    for (UITextField * nextfiled in self.AnswerCScrollview_iPad.subviews) {
        if (nextfiled.tag == textField.tag + 1) {
//            ipadTextReturn = YES;
            [nextfiled becomeFirstResponder];
            return YES;
        }
    }
    [textField resignFirstResponder];
    return YES;
}
#pragma mark SVSlideInViewDelegate
- (void)SVSlideInViewDidDisapper:(SVSlideInView *)slideInView{
    if (self.answerSheet) {
        [self.answerSheet setUserName:[UserInfo loggedUserName]];
    }
}
#pragma mark KeyboardNotificationsForiPad
- (void)keyboardWillHide:(NSNotification *)note{
    [self.AnswerCScrollview_iPad setContentOffset:CGPointMake(0, 0) animated:YES];
}
#pragma mark -
#pragma mark SVStoreKitDelegate
- (void)storeKit:(SVStoreKit *)storeKit FailedWithError:(NSError *)error{
    NSLog(@"storeKitFailed:%@",error);
    [HUD hide:YES];
    if (error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"Transaction error: %@", error.localizedDescription);
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"购买失败" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}
- (void) storeKit:(SVStoreKit *)_storeKit produtRequestDidFinished:(NSArray *)products{
    NSLog(@"%@",products);
    HUD.labelText = @"正在购买";
    //    for (SKProduct * product in products) {
    //        [_storeKit buyProduct:product];
    // ;   }
}
- (void) productPurchased:(SVStoreKit *)_storeKit{
    [HUD hide:YES];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"购买成功" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [self ensureIAPandDeleteAd:YES];
    //    storeKit = nil;
}
- (void) storeKitDidRestoredIdentifier:(NSString *)identifier{
    [HUD hide:YES];
    NSString * produtTitle = @"";
    if ([identifier isEqualToString:IAPIDText]) {
        produtTitle = @"四级原文";
    }
    else if ([identifier isEqualToString:IAPIDExplain]) {
        produtTitle = @"四级解析";
    }
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@恢复成功",produtTitle] message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    //    storeKit = nil;
    [self ensureIAPandDeleteAd:YES];
}
#pragma mark ViewWithoutAd
- (void) ensureIAPandDeleteAd:(BOOL)didAppear{
    if (!_adRemoved && [self ensureIAP]) {
        [self deleteAd:didAppear];
    }
}
- (BOOL)ensureIAP{
    return ([SVStoreKit productPurchased:IAPIDText] || [SVStoreKit productPurchased:IAPIDExplain]);
}
- (void) deleteAd:(BOOL)didAppear{
    NSLog(@"Ad deleting");
//    [youmiView removeFromSuperview];
    [adView removeFromSuperview];
    adView = nil;
    if (!iPad) {
        //        CGPoint oldCenter = titleView.center;
        //        oldCenter = CGPointMake(oldCenter.x, oldCenter.y - 17);
        //        titleView.center = oldCenter;
        CGRect oldFrame = scroll.frame;
        scroll.frame = CGRectMake(oldFrame.origin.x,oldFrame.origin.y + 10, 280, IS_IPHONE_5 ? 350 : 265);
        //        CGRect btnRect = ShowButton.frame;
        //        ShowButton.frame = CGRectMake(btnRect.origin.x, 0, btnRect.size.width, btnRect.size.height);
        adpter.Player.center = CGPointMake(adpter.Player.center.x, IS_IPHONE_5 ?self.view.frame.size.height - adpter.Player.frame.size.height :  self.view.frame.size.height - adpter.Player.frame.size.height / 2) ;
        CollectButton.center = CGPointMake(adpter.Player.center.x + adpter.Player.frame.size.width / 2 - 30, adpter.Player.center.y );
    }
    
    _adRemoved = YES;
}

@end
