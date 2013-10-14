//
//  FavQuesViewController.m
//  CET4Lite
//
//  Created by Seven Lee on 12-4-5.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "FavQuesViewController.h"
#import "database.h"
#import "SevenTabBar.h"
#import "AppDelegate.h"
#import "UserInfo.h"
#define kAdviewHideSeconds 60
@interface FavQuesViewController ()

@end

@implementation FavQuesViewController
@synthesize QNobtn;
@synthesize scroll;
@synthesize navTitle;
@synthesize NoLabel;
//@synthesize AnswerC;
@synthesize CollectButton;
@synthesize RoundBack;
@synthesize ExplainBtn;
@synthesize QuestionArray;
@synthesize adpter;
@synthesize LeftArrowImg;
@synthesize RightArrowImg;

- (id)initWithSection:(NSInteger)sec{
    if ([AppDelegate isPad]) {
        self = [super initWithNibName:@"FavQuesViewController_iPad" bundle:nil];
    }
    else {
        if (IS_IPHONE_5) {
            self = [super initWithNibName:@"FavQuesViewController_iPhone5" bundle:nil];
        }
        else
            self = [super initWithNibName:@"FavQuesViewController" bundle:nil];
    }
    
    if (self) {
        Section = sec;
        currentPage = 0;
        DisplayDic = [NSDictionary dictionaryWithObjectsAndKeys:
                      @"2006年6月",@"200606",@"2006年12月",@"200612",
                      @"2007年6月",@"200706",@"2007年12月",@"200712",
                      @"2008年6月",@"200806",@"2008年12月",@"200812",
                      @"2009年6月",@"200906",@"2009年12月",@"200912",
                      @"2010年6月",@"201006",@"2010年12月",@"201012",
                      @"2011年6月",@"201106",@"2011年12月",@"201112",
                      @"2012年6月",@"201206",@"2012年12月",@"201212",
                      @"2013年6月",@"201306",
                      @"A",@"1",@"B",@"2",@"C",@"3",
                      nil];
        navTitle = [DisplayDic objectForKey:[NSString stringWithFormat:@"%d",Section]];
        isPad = [AppDelegate isPad];
        _adRemoved = NO;
        firstAppear = YES;
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
    if (isPad) {
        /*
         youmiView = [[YouMiView alloc] initWithContentSizeIdentifier:YouMiBannerContentSizeIdentifier300x250 delegate:nil];
         youmiView.appID = YOUMI_ID;
         youmiView.appSecret = YOUMI_SEC;
         youmiView.appVersion = YOUMI_APP_VER;
         //        CGRect rect = youmiView.frame;
         youmiView.center = CGPointMake(self.scroll.origin.x + self.scroll.size.width + youmiView.size.width / 1.2, self.scroll.center.y);
         [youmiView start];
         [self.view insertSubview:youmiView atIndex:1];
         */
        if (Section != 3) {
            adView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeMediumRectangle];
            adView.adUnitID = MY_GAD_ID;
            adView.center = CGPointMake(self.scroll.origin.x + self.scroll.size.width + adView.size.width / 1.2, self.scroll.center.y);
            adView.rootViewController = self;
            adView.delegate = self;
            [self.view insertSubview:adView atIndex:1];
            [adView loadRequest:[GADRequest request]];
        }
        else{
            adView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeLeaderboard];
            adView.adUnitID = MY_GAD_ID;
            adView.center = CGPointMake(self.view.center.x,adView.height / 2);
            adView.rootViewController = self;
            adView.delegate = self;
            [self.view insertSubview:adView atIndex:1];
            [adView loadRequest:[GADRequest request]];
        }
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
        adView.adUnitID = MY_GAD_ID;
        CGRect rect = adView.frame;
        adView.center = CGPointMake(self.view.center.x,self.view.frame.size.height - rect.size.height / 2);
        adView.rootViewController = self;
        [self.view insertSubview:adView atIndex:1];
        adView.delegate = self;
        [adView loadRequest:[GADRequest request]];
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.navigationItem.hidesBackButton = YES;
    self.scroll.delegate = self;
    [self.navigationController.navigationBar setTintColor:(IS_IOS7 && !IS_IPAD) ? [UIColor whiteColor] : [UIColor colorWithRed:0.682 green:0.329 blue:0.0 alpha:1]];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.delegate = self;

//    UIButton * img = [UIButton buttonWithType:UIButtonTypeCustom];
//    [img setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
//    [img addTarget:self action:@selector(popController) forControlEvents:UIControlEventTouchUpInside];
//    img.frame = CGRectMake(0, 0, 52, 29);
//    UIBarButtonItem * backbutton = [[UIBarButtonItem alloc] initWithCustomView:img];
//    self.navigationItem.leftBarButtonItem = backbutton;
}
- (void)viewDidUnload{
     [super viewDidUnload];
    self.QNobtn = nil;
    self.NoLabel = nil;
    self.scroll = nil;
    self.ExplainBtn = nil;
    self.CollectButton = nil;
    self.RoundBack = nil;
    self.LeftArrowImg = nil;
    self.RightArrowImg = nil;
    iPadPop = nil;
//    youmiView = nil;
    adView = nil;
    titleView = nil;
}
- (void)viewWillDisappear:(BOOL)animated{
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    if (adViewTimer) {
        [adViewTimer invalidate];
        adViewTimer = nil;
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    if (!firstAppear) {
        return;
    }
    firstAppear = NO;
    self.navigationController.navigationBarHidden = NO;
    self.adpter = [[CETAdapter alloc] initWithUserCollectionSection:Section scroll:scroll];
//    scroll.contentSize = CGSizeMake(scroll.contentSize.width, scroll.frame.size.height);
    down = [[DownloaderView alloc] initWithFrame:self.view.bounds Array:[adpter myQuestionArray]];
    down.delegate = self;
    [self.view addSubview:down];
    [down startDownload];
    self.NoLabel.text = [NSString stringWithFormat:@"%d",[adpter QuestioinNumberofIndex:0]];
    NSString * key = [NSString stringWithFormat:@"%d",[[[adpter myQuestionArray] objectAtIndex:0] Year]];
//    NSString * key1 = [NSString stringWithFormat:@"%d",Section];
    self.navigationItem.title = isPad ? [NSString stringWithFormat:@"%@Section%@ 第%d题",[DisplayDic objectForKey:key],navTitle,[adpter QuestioinNumberofIndex:0]] : [NSString stringWithFormat:@"%@Section%@",[DisplayDic objectForKey:key],navTitle];
    self.LeftArrowImg.alpha = 0;
    if ([[adpter myQuestionArray] count] == 1) {
        self.RightArrowImg.alpha = 0;
    }
    if (Section == 3) {
        [self drawSectionCView];      
    }
    [self setAdViewDisplay:YES];
}
//- (void)viewDidAppear:(BOOL)animated{
//    NSLog(@"scrollSize:(%.1f,%.1f) did appear",self.scroll.frame.size.width,self.scroll.frame.size.height);
//    NSLog(@"scrollContentSize:(%.1f,%.1f) did appear",scroll.contentSize.width,scroll.contentSize.height);
//}
- (void) removeViews{
    [adpter StopPlayer];
    [WordExplainView RemoveView];
    if (down) {
        [down stopDownload];
        [down removeFromSuperview];
    }
}
- (void)drawSectionCView{
    [adpter.Player removeFromSuperview];
    [flowerBack removeFromSuperview];
    [self.LeftArrowImg removeFromSuperview];
    [self.RightArrowImg removeFromSuperview];
    [TextBTN removeFromSuperview];
    [self.NoLabel removeFromSuperview];
    [self.QNobtn removeFromSuperview];
    [self.ExplainBtn removeFromSuperview];
    [self.RoundBack removeFromSuperview];
    [self.CollectButton removeFromSuperview];
    if (isPad) {
//        self.scroll.pagingEnabled = YES;
        self.scroll.frame = CGRectMake(20, 90, 984, 500);
        CGFloat pointX = 0;
        CGFloat pointY = 0;
        CGFloat width = 300;
        CGFloat height = self.scroll.frame.size.height;
        int count = [[adpter myQuestionArray] count];
        AnswerViewArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < count; i++) {
            AnswerCSingleView * single = [[AnswerCSingleView alloc] initWithFrame:CGRectMake(pointX, pointY, width, height) Delegate:adpter Question:[[adpter myQuestionArray] objectAtIndex:i] Collection:YES];
//            pointX += (i % 3 == 2 ? width : width + 42);
            pointX += width + 42;
            single.inputField.delegate = self;
            single.inputField.returnKeyType = UIReturnKeyDone;
            single.tag = i;
            single.changeDelegate = self;
            [AnswerViewArray addObject:single];
            [scroll addSubview:single];
            
        }
        scroll.contentSize = CGSizeMake(pointX, height);
        scroll.showsHorizontalScrollIndicator = NO;
        [[[AnswerViewArray objectAtIndex:currentPage] inputField] becomeFirstResponder];
    }
    else{
        self.scroll.pagingEnabled = YES;
        self.scroll.frame = CGRectMake(scroll.frame.origin.x, scroll.frame.origin.y - 50, scroll.frame.size.width, 320);
        CGFloat pointX = 0;
        CGFloat pointY = 0;
        CGFloat width = scroll.frame.size.width;
        CGFloat height = scroll.frame.size.height;
        int count = [[adpter myQuestionArray] count];
        AnswerViewArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < count; i++) {
            AnswerCSingleView * single = [[AnswerCSingleView alloc] initWithFrame:CGRectMake(pointX, pointY, width, height) Delegate:adpter Question:[[adpter myQuestionArray] objectAtIndex:i] Collection:YES];
            pointX += width;
            single.inputField.delegate = self;
            single.inputField.returnKeyType = UIReturnKeyDone;
            single.changeDelegate = self;
            [AnswerViewArray addObject:single];
            [scroll addSubview:single];   
        }
        scroll.contentSize = CGSizeMake(pointX, height);
        scroll.showsHorizontalScrollIndicator = NO;
        [[[AnswerViewArray objectAtIndex:currentPage] inputField] becomeFirstResponder];
    }
    
}
- (void) popController{
    [adpter StopPlayer];
    if (down) {
        [down stopDownload];
        [down removeFromSuperview];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    if (isPad) {
//        return UIInterfaceOrientationIsLandscape(interfaceOrientation);
//    }
//    else {
//        return (interfaceOrientation == UIInterfaceOrientationPortrait);
//    }
//}

//点下原文时,从数据库中读取当前题目的原文
- (IBAction)SeeTheText:(UIButton *)sender{
//    if (QCView && sender.tag != 4) {
//        [QCView willDisappear];
//    }
    switch (sender.tag) {
        case 1://原文按钮按下时
        {
//            Question * q = [[adpter myQuestionArray] objectAtIndex:currentPage];

//            if ( [SVStoreKit productPurchased:IAPIDText] || q.Year <= 200612) {
                [self showText:sender.center];
//            }
//            else {
//                UIAlertView * textAlert = [[UIAlertView alloc] initWithTitle:@"购买" message:@"购买所有原文并移除广告。重复购买不会扣费。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"购买",@"恢复购买", nil];
//                textAlert.tag = IAPAlertTagText;
//                [textAlert show];
//            }
            break;
        }
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
                LeftArrowImg.alpha = alphaLeft;
                RightArrowImg.alpha = alphaRight;
                [UIView commitAnimations];
            }
            break;
        case 3://解析按下时，从数据库中读当前解析
//#if DEBUG
//            [self deleteAd:YES];
//#endif
            if ([SVStoreKit productPurchased:IAPIDExplain] || [UserInfo isVIPValid]) {
                [self showExplain:sender.center];
            }
            else {
                UIAlertView * textAlert = [[UIAlertView alloc] initWithTitle:@"购买" message:@"\n✓获得所有解析\n✓VIP高速下载通道\n✓移除广告\n\n(重复购买不会扣费)" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"购买",@"恢复购买", nil];
                textAlert.tag = IAPAlertTagExplain;
                [textAlert show];
            }
            
            break;
        default:
            break;
    }
    
}
- (void) showExplain:(CGPoint)center{
    if (expView) //如果textView存在，则将其删除
        [expView removeFromSuperview];
    
    //下面这个方法生成一个当前题目的textView
    expView = [adpter readExplains:[adpter QuestioinNumberofIndex:currentPage]];
    
    //先将其设为透明,为下面淡入淡出效果做准备
    expView.alpha = 0;
    //            [self.view insertSubview:expView belowSubview:answerSheet];
    [self.view addSubview:expView];
    
    //设置两个View切换时的淡入淡出效果
    [UIView beginAnimations:@"Switch" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:.5];
    //            QNobtn.frame = sender.frame;
    //            QNobtn.hidden = NO;
    [RoundBack setCenter:center];
    scroll.alpha = 0;
    expView.alpha = 1;
    if (textView) {
        textView.alpha = 0;
    }
    LeftArrowImg.alpha = 0;
    RightArrowImg.alpha = 0;
    [UIView commitAnimations];
}
- (void) showText:(CGPoint)center{
    if (textView) //如果textView存在，则将其删除
        [textView removeFromSuperview];
    
    //下面这个方法生成一个当前题目的textView
    textView = [adpter readTexts:[adpter QuestioinNumberofIndex:currentPage]];
    adpter.Player.SynchroID = textView;
    //先将其设为透明,为下面淡入淡出效果做准备
    textView.alpha = 0;
    [self.view addSubview:textView];
    
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
    LeftArrowImg.alpha = 0;
    RightArrowImg.alpha = 0;
    [UIView commitAnimations];
}
- (void)resetTitle:(NSInteger)index{
    NSString * num = [NSString stringWithFormat:@"%d",[adpter QuestioinNumberofIndex:index]];
    [adpter CurrentPageChanged:index];
    //        [QNobtn setTitle:num forState:UIControlStateNormal];
    //        NoLabel.text = num;
    //    }
    NSString * key = [NSString stringWithFormat:@"%d",[[[adpter myQuestionArray] objectAtIndex:currentPage] Year]];
    //    NSString * key1 = [NSString stringWithFormat:@"%d",Section];
    self.navigationItem.title = [NSString stringWithFormat:@"%@Section%@ 第%@题",[DisplayDic objectForKey:key],navTitle,num];
}
- (IBAction)DeleteCollection:(UIButton *)sender{
    if (isPad && Section == 3) {
        currentPage = sender.tag;
        [adpter CurrentPageChanged:sender.tag];
        [self resetTitle:sender.tag];
    }
    NSError * err = [adpter DeleteCollection];
    if (err) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"删除失败" message:err.domain delegate:nil cancelButtonTitle:@"好吧" otherButtonTitles: nil];
        [alert show];
    }
    else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"删除成功" message:@"该题目已成功从收藏夹中删除" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }
}
#pragma mark GADBannerViewDelegate
- (void)adViewDidReceiveAd:(GADBannerView *)view{
    [self addCloseButtonOnAd:view];
}
#pragma mark DownloaderViewDelegate
- (void) DowloaderViewDidFinishDownload:(DownloaderView *)downloaderView{
    //    PlayerView = [[AudioPlayerView alloc] initWithFrame:CGRectMake(0,340, 320, 65 )];
    //    
    //    adpter.Player = PlayerView;
    [self addAdvertisement];
    [self ensureIAPandDeleteAd:YES];
    [adpter initPlayer];
    [self.view insertSubview:adpter.Player belowSubview:CollectButton];
//    if (IS_IPHONE_5) {
        adpter.Player.center = CGPointMake(self.scroll.center.x, self.scroll.center.y + self.scroll.frame.size.height / 2 + adpter.Player.frame.size.height / 2) ;
//    }
    if (isPad) {
        adpter.Player.center = CGPointMake(self.scroll.center.x, self.scroll.center.y + self.scroll.frame.size.height / 2 + adpter.Player.frame.size.height / 2) ;
        CollectButton.center = CGPointMake(adpter.Player.center.x + adpter.Player.frame.size.width / 2 - 30, adpter.Player.center.y );
    }
}
- (void) DowloaderViewDidFailedDownload:(DownloaderView *)downloaderView{
    [self popController];
}
- (void) DowloaderViewCancelled:(DownloaderView *)downloaderView{
    [self popController];
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
//    if (Section < 3) {
        NSString * num = [NSString stringWithFormat:@"%d",[adpter QuestioinNumberofIndex:page]];
        [adpter CurrentPageChanged:currentPage];
        //        [QNobtn setTitle:num forState:UIControlStateNormal];
        NoLabel.text = num;
//    }
    NSString * key = [NSString stringWithFormat:@"%d",[[[adpter myQuestionArray] objectAtIndex:currentPage] Year]];
    //    NSString * key1 = [NSString stringWithFormat:@"%d",Section];
    self.navigationItem.title = isPad ? [NSString stringWithFormat:@"%@Section%@ 第%d题",[DisplayDic objectForKey:key],navTitle,[adpter QuestioinNumberofIndex:currentPage]] : [NSString stringWithFormat:@"%@Section%@",[DisplayDic objectForKey:key],navTitle];
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

#pragma mark QuestionCViewCollectDelegate
- (void) AddCurrentQuestionToFav:(NSInteger)index{
    [self DeleteCollection:nil];
}
#pragma mark AnswerCDelegate
- (void)QuestionNoChanged:(int)offset{
    [[AnswerViewArray objectAtIndex:currentPage] showRightOrWrong];
    currentPage += offset;
    if (currentPage < 0) {
        currentPage = 0;
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"第一题啦" message:@"前面没有题啦～" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
//        return;
    }
    else {
        if (currentPage == [[adpter myQuestionArray] count]) {
            currentPage --;
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"最后一题啦" message:@"已经是最后一题啦" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
            [alert show];
        }
        else {
//            [adpter CurrentPageChanged:currentPage];
            [scroll scrollRectToVisible:[[AnswerViewArray objectAtIndex:currentPage] frame] animated:YES];
            [[[AnswerViewArray objectAtIndex:currentPage] inputField] becomeFirstResponder];
        }
    }
}
- (IBAction)RollScroll:(UIButton *)sender{
    CGRect frame = scroll.frame;
    frame.origin.x = frame.size.width * (currentPage + sender.tag);
    frame.origin.y = 0;
    [scroll scrollRectToVisible:frame animated:YES];
}

- (IBAction)SeeTheTextPad:(UIButton *)sender {
    switch (sender.tag) {
        case 0: //原文
        {
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
            break;
        }
        case 1: //解析
        {
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
            else{
                UIAlertView * textAlert = [[UIAlertView alloc] initWithTitle:@"购买" message:@"\n✓获得所有解析\n✓VIP高速下载通道\n✓移除广告\n\n(重复购买不会扣费)" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"购买",@"恢复购买", nil];
                textAlert.tag = IAPAlertTagExplain;
                [textAlert show];
            }
            break;
        }
        default:
            break;
    }
}
- (void) AddToFavorite:(UIButton *)sender{
    [self DeleteCollection:sender];
}
#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (isPad) {
//        Question * q = [[adpter myQuestionArray] objectAtIndex:textField.tag];
        [self resetTitle:textField.tag];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (!isPad) {
        [[AnswerViewArray objectAtIndex:currentPage] showRightOrWrong];
    }
    else{
        [[AnswerViewArray objectAtIndex:textField.tag] showRightOrWrong];
    }
    
    return YES;
}
#pragma mark navigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([viewController isEqual:self]) {
        return;
    }
    [self removeViews];
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
                NSLog(@"购买");
                storeKit = [[SVStoreKit alloc] initWithDelegate:self];
                [storeKit buyIdentifier:IAPIDText];
                storeKit.tag = IAPAlertTagText;
                HUD = [[MBProgressHUD alloc] initWithView:self.view];
                HUD.labelText = @"购买中";
                [self.view addSubview:HUD];
                HUD.removeFromSuperViewOnHide = YES;
                [HUD show:YES];
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
//                [self deleteAd:YES];
                storeKit = [[SVStoreKit alloc] initWithDelegate:self];
                [storeKit buyIdentifier:IAPIDExplain];
                storeKit.tag = IAPAlertTagExplain;
                
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
    [adView removeFromSuperview];
    adView = nil;
//    CGPoint oldCenter = titleView.center;
//    oldCenter = CGPointMake(oldCenter.x, oldCenter.y - 17);
//    titleView.center = oldCenter;
    if (Section != 3 && !isPad) {
//        scroll.frame = CGRectMake(20,didAppear? 70 :oldCenter.y + 70, 280, IS_IPHONE_5 ? 317 : 252);
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
