//
//  SVSingleBlogViewController.m
//  iyuba
//
//  Created by Lee Seven on 12-12-21.
//  Copyright (c) 2012年 Lee Seven. All rights reserved.
//

#import "SVSingleBlogViewController.h"
//#import "SVBlogCommentViewController.h"
//#import "IyubaAPI.h"
//#import "SVErrorHandle.h"
//#import "CJSONDeserializer.h"
#import "AppDelegate.h"
@interface SVSingleBlogViewController ()

@end

@implementation SVSingleBlogViewController
@synthesize myBlog = _myBlog;
//@synthesize author = _author;

- (id)initWithBlog:(SVBlog *)blog
{
    self = [super init];
    if (self) {
        // Custom initialization
//        self.author = author;
        self.myBlog = blog;
        self.navigationItem.title = blog.subject;
        _firstAppear = YES;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
/*
- (id)initWithAuthor:(IyubaUser *)author andBlogID:(NSString *)blogid{
    self = [super init];
    if (self) {
        // Custom initialization
        self.author = author;
        self.myBlog = [SVBlog blogWithID:blogid];
        self.navigationItem.title = self.author.iyubaUserName ? [NSString stringWithFormat:@"%@的日志",self.author.iyubaUserName ] : @"日志";
        _firstAppear = YES;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    CGRect frame = self.view.bounds;
    _webView = [[UIWebView alloc] initWithFrame:frame];
    [self.view addSubview:_webView];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = [UIColor clearColor];
    _webView.backgroundColor = [UIColor clearColor];
	// Do any additional setup after loading the view.
    /*
    commentItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%d条评论",self.myBlog.replyNumber] style:UIBarButtonItemStyleBordered target:self action:@selector(viewComment)];
//    _blogView = [[DTAttributedTextContentView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:_blogView];
    self.navigationItem.rightBarButtonItem = commentItem;
     */
    /*
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"navigation_back"] forState:UIControlStateNormal];
    [backBtn sizeToFit];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.showsTouchWhenHighlighted = YES;
    UIBarButtonItem * back = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.leftBarButtonItem = back;
     */
    
}
- (void)viewDidUnload{
    _webView = nil;
    HUD = nil;
//    commentItem = nil;
//    blogRequest = nil;
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated{
    [WordExplainView RemoveView];
    _webView.delegate = nil;
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
//    if (blogRequest) {
//        [blogRequest clearDelegatesAndCancel];
//        blogRequest.delegate = nil;
//        blogRequest = nil;
//    }
}

- (void)viewWillAppear:(BOOL)animated{
//    _webView.frame = self.view.bounds;
}
- (void)viewDidAppear:(BOOL)animated{
    if (_firstAppear) {
        _firstAppear = NO;
        NSLog(@"content:%@",self.myBlog.message);
        [self loadBlogContent];
        /*
        if (self.myBlog.subject && self.myBlog.subject.length > 0) {
            [self loadBlogContent];
        }
        else{
            
            [self getBlogAndLoadContent];
        }
         */
        
    }
    
}
/*
- (void)getBlogAndLoadContent{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText = @"loading";
    [self.view addSubview:HUD];
    [HUD show:YES];
    NSString * sign = [IyubaAPI md5:[NSString stringWithFormat:@"%@%@iyubaV2",PROTOCOL_CODE_GETBLOGBYID,self.myBlog.blogId]];
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:sign,@"sign",self.myBlog.blogId,@"blogid", nil];
    NSString * url = [IyubaAPI protocolWithCode:PROTOCOL_CODE_GETBLOGBYID parameterDictionary:params];
    blogRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
    blogRequest.timeOutSeconds = 30;
    blogRequest.delegate = self;
    [blogRequest startAsynchronous];
}
 */
- (void)loadBlogContent{
    if (!HUD) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
    }
    
    HUD.labelText = @"loading";
    //        HUD.removeFromSuperViewOnHide = YES;
    [HUD show:YES];
    @try {
//        [HUD showAnimated:YES whileExecutingBlock:^{
            NSDateFormatter * format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString * time = [format stringFromDate:self.myBlog.dateLine];
            NSString * head = [NSString stringWithFormat:@"<head><style type=\"text/css\">img {height: auto;}</style></head><body><h3 align=\"center\"><strong>%@</strong></h3><h4 align=\"center\">发表于   %@</h4>",self.myBlog.subject,time];
            if (!self.myBlog.message) {
                self.myBlog.message = @"空日志";
            }
            NSString * html = [head stringByAppendingString:self.myBlog.message];
            //            html = [html stringByReplacingOccurrencesOfString:@"<img " withString:@"<img width:320px " options:NSCaseInsensitiveSearch range:NSMakeRange(0, [html length])];
            NSLog(@"html loaded:%@",html);
            _webView.delegate = self;
            [_webView loadHTMLString:html baseURL:nil];
            //        _webView.scalesPageToFit = YES;
            _webView.multipleTouchEnabled = YES;
//        }];
//        [commentItem setTitle:[NSString stringWithFormat:@"%d条评论",self.myBlog.replyNumber]];
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        UIMenuItem *getHighlightString = [[UIMenuItem alloc] initWithTitle: @"Get String" action: @selector(getHighlightedString:)];
        UIMenuItem *markHighlightedString = [[UIMenuItem alloc] initWithTitle: @"释义" action: @selector(markHighlightedString:)];
        [menuController setMenuItems: [NSArray arrayWithObjects:getHighlightString, markHighlightedString, nil]];
    }
    @catch (NSException *exception) {
        NSLog(@"exception:%@",exception);
    }
    [HUD hide:NO];
}
- (void)setMyBlog:(SVBlog *)myBlog{
    _myBlog = nil;
    _myBlog = myBlog;
    [self loadBlogContent];
}
- (void)back:(UIButton *)sender{
    [WordExplainView RemoveView];
//    if (blogRequest) {
//        [blogRequest clearDelegatesAndCancel];
//        blogRequest.delegate = nil;
//        blogRequest = nil;
//    }
    _webView.delegate = nil;
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}
- (BOOL) canPerformAction:(SEL)action withSender:(id)sender
{
    
    if (action == @selector(getHighlightString:)) {
        return YES;
    } else if (action == @selector(markHighlightedString:)) {
        return YES;
    }
    
    return NO;
}
- (IBAction)markHighlightedString:(id)sender {
    
    /*
    // The JS File
    NSString *filePath  = [[NSBundle mainBundle] pathForResource:@"HighlightedString" ofType:@"js" inDirectory:@""];
    NSData *fileData    = [NSData dataWithContentsOfFile:filePath];
    NSString *jsString  = [[NSMutableString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    [_webView stringByEvaluatingJavaScriptFromString:jsString];
    
    // The JS Function
    NSString *startSearch   = [NSString stringWithFormat:@"stylizeHighlightedString()"];
    [_webView stringByEvaluatingJavaScriptFromString:startSearch];
     */
    // The JS File
    NSString *filePath  = [[NSBundle mainBundle] pathForResource:@"HighlightedString" ofType:@"js" inDirectory:@""];
    NSData *fileData    = [NSData dataWithContentsOfFile:filePath];
    NSString *jsString  = [[NSMutableString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    [_webView stringByEvaluatingJavaScriptFromString:jsString];
    
    // The JS Function
    NSString *startSearch   = [NSString stringWithFormat:@"getHighlightedString()"];
    [_webView stringByEvaluatingJavaScriptFromString:startSearch];
    
    NSString *selectedText   = [NSString stringWithFormat:@"selectedText"];
    NSString * highlightedString = [_webView stringByEvaluatingJavaScriptFromString:selectedText];
    [self showWord:highlightedString];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Highlighted String"
//                                                    message:highlightedString
//                                                   delegate:nil
//                                          cancelButtonTitle:@"Oh Yeah"
//                                          otherButtonTitles:nil];
//    [alert show];
    
}
- (void)showWord:(NSString *)word{
    NSString * defi = @"词义未找到 (°_°)";
    NSString * pron = @"";
    NSString * audio = @"";
    Word * thisword = [[Word alloc] initWithWord:word Pron:pron Def:defi Audio:audio];
    thisword.delegate = self;
    if (_wordExplainView) {
        _wordExplainView = [WordExplainView ViewWithState:SVWordViewStateWaiting errMSG:nil word:thisword];
        //            [self.superview addSubview:WordView];
        [_wordExplainView show];
    }
    else {
        _wordExplainView = [WordExplainView ViewWithState:SVWordViewStateWaiting errMSG:nil word:thisword];
        //            [self.superview addSubview:WordView];
        if (IS_IPAD) {
            UIView * view = XAppDelegate.stackController.view;
            if (view) {
                [view addSubview:_wordExplainView];
                [_wordExplainView show];
            }
        }
        else{
            UIWindow * window = [[UIApplication sharedApplication] keyWindow];
            if (!window)
                window = [[[UIApplication sharedApplication] delegate] window];
            
            [window addSubview:_wordExplainView];
            [_wordExplainView show];
        }
        
    }
    [thisword FindWordOnInternet:word];
}
- (IBAction)getHighlightedString:(id)sender {
    
    // The JS File
    NSString *filePath  = [[NSBundle mainBundle] pathForResource:@"HighlightedString" ofType:@"js" inDirectory:@""];
    NSData *fileData    = [NSData dataWithContentsOfFile:filePath];
    NSString *jsString  = [[NSMutableString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    [_webView stringByEvaluatingJavaScriptFromString:jsString];
    
    // The JS Function
    NSString *startSearch   = [NSString stringWithFormat:@"getHighlightedString()"];
    [_webView stringByEvaluatingJavaScriptFromString:startSearch];
    
    NSString *selectedText   = [NSString stringWithFormat:@"selectedText"];
    NSString * highlightedString = [_webView stringByEvaluatingJavaScriptFromString:selectedText];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Highlighted String"
                                                    message:highlightedString
                                                   delegate:nil
                                          cancelButtonTitle:@"Oh Yeah"
                                          otherButtonTitles:nil];
    [alert show];
    //[alert release]; // not required anymore because of ARC
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)segmentedControlValueChanged:(UISegmentedControl *)segmentedControl{
    if (segmentedControl.selectedSegmentIndex == 0) {
        [self webViewBack:nil];
    }
    else{
        [self webViewForward:nil];
    }
    [segmentedControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
}
/*
- (void)viewComment{
    SVBlogCommentViewController * comment = [[SVBlogCommentViewController alloc] initWithBlogID:self.myBlog.blogId author:self.author];
    comment.blogTitle = self.myBlog.subject;
    [self presentModalViewController:comment animated:YES];
}
 */
- (void)webViewBack:(UIBarButtonItem *)item{
    [_webView goBack];
}
- (void)webViewForward:(UIBarButtonItem *)item{
    [_webView goForward];
}
#pragma mark WordDelegate
- (void)WordFindInternetExpSucceed:(Word*)thisWord {
    if (_wordExplainView) {
        _wordExplainView = [WordExplainView ViewWithState:SVWordViewStateDis errMSG:nil word:thisWord];
        //            [self.superview addSubview:WordView];
        [_wordExplainView show];
    }
    else {
        _wordExplainView = [WordExplainView ViewWithState:SVWordViewStateDis errMSG:nil word:thisWord];
        //            [self.superview addSubview:WordView];
        UIWindow * window = [[UIApplication sharedApplication] keyWindow];
        //        [[UIApplication sharedApplication].keyWindow addSubview:view];
        if (!window)
            window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        [[[window subviews] objectAtIndex:1] addSubview:_wordExplainView];
        [_wordExplainView show];
    }
}
- (void)WordFindInternetExpFailed:(Word *)thisWord witError:(NSError *)err{
    if (_wordExplainView) {
        _wordExplainView = [WordExplainView ViewWithState:SVWordViewStateDisFail errMSG:err.domain word:thisWord];
        //            [self.superview addSubview:WordView];
        [_wordExplainView show];
    }
    else {
        _wordExplainView = [WordExplainView ViewWithState:SVWordViewStateDisFail errMSG:err.domain word:thisWord];
        //            [self.superview addSubview:WordView];
        UIWindow * window = [[UIApplication sharedApplication] keyWindow];
        //        [[UIApplication sharedApplication].keyWindow addSubview:view];
        if (!window)
            window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        [[[window subviews] objectAtIndex:1] addSubview:_wordExplainView];
        [_wordExplainView show];
    }
}
#pragma mark - webViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [HUD show:NO];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [HUD hide:NO];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"url=%@", [request URL]);

    if ([[[request URL] description] isEqualToString:@"about:blank"]) {
        return YES;
    }
    else
        return NO;
}
/*
#pragma mark -
#pragma mark ASIHTTPRequestDelegate
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [HUD hide:YES];
    [[SVErrorHandle errorHandler] showError:@"网络连接失败" inView:self.view hideAfter:3];
    
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [HUD hide:YES];
    NSData * response = [request responseData];
    //    NSString * theString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    //    NSLog(@"theString:%@",theString);
    CJSONDeserializer *jsonDeserializer = [CJSONDeserializer deserializer];
    NSError *error = nil;
    NSDictionary *jsonDict = [jsonDeserializer deserializeAsDictionary:response error:&error];
    if (error) {
        NSLog(@"JSON error:%@",error);
        [[SVErrorHandle errorHandler] showError:@"服务器暂不可用" inView:self.view hideAfter:3];
        return;
    }

    NSInteger result = [[jsonDict objectForKey:@"result"] integerValue];
        if (result == 251) {
            self.myBlog.subject = [jsonDict objectForKey:@"subject"];
            self.myBlog.message = [jsonDict objectForKey:@"message"];
            self.myBlog.replyNumber = [[jsonDict objectForKey:@"replynum"] integerValue];
            self.myBlog.dateLine = [NSDate dateWithTimeIntervalSince1970:[[jsonDict objectForKey:@"dateline"] integerValue]];
            NSString * userid = [jsonDict objectForKey:@"uid"];
            NSString * username = [jsonDict objectForKey:@"username"];
            if (!self.author) {
                self.author = [[IyubaUser alloc] initWithUserID:userid userName:username email:nil];
                self.navigationItem.title = [NSString stringWithFormat:@"%@的日志",self.author.iyubaUserName ];
            }
            [self loadBlogContent];
        }
        else{
            NSString * message = [SVErrorHandle errorWithResultCode:result];
            [[SVErrorHandle errorHandler] showError:message inView:self.view hideAfter:3];
        }

    
}
*/
@end
