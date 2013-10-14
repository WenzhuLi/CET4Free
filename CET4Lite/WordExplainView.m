//
//  WordExplainView.m
//  CET4Lite
//
//  Created by Seven Lee on 12-3-16.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "WordExplainView.h"
#import "AppDelegate.h"


static WordExplainView * view;
static NSTimer * displayTimer;
static AVPlayer * SoundPlayer;

@implementation WordExplainView
@synthesize wordLabel;
@synthesize defLabel;
@synthesize myWord;
//@synthesize delegate;
@synthesize WaitingLabel;
@synthesize activeView;
@synthesize WrongLabel;
@synthesize AddWordButton;
@synthesize ProunceButton;
//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

+ (id) ViewWithState:(SVWordViewState)state errMSG:(NSString *)err word:(Word *)word{
    if (view) {
        [view updateState:state errMSG:err];
        if (word) {
            [view displayThisWord:word];
        }
    }
    else {
        view = [[WordExplainView alloc] initWithState:state errMSG:err word:word];
        [view updateState:state errMSG:err];
    }
    return view;
}
- (id) initWithState:(SVWordViewState)state errMSG:(NSString *)err word:(Word *)word{
    CGRect frame;
    
    NSString * nibName;
    if ([AppDelegate isPad]) {
        frame = CGRectMake(500, 768, 400, 125);
        nibName = @"WordExplainView_iPad";
    }
    else {
        frame = IS_IPHONE_5 ? CGRectMake(0, 568, 320, 85) : CGRectMake(0, 480, 320, 85);
        nibName = @"WordExplainView";
    }
    self = [super initWithFrame:frame];
    if (self) {
        NSArray * nibs = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
        [self addSubview:[nibs objectAtIndex:0]];
        [self updateState:state errMSG:err];
        [self displayThisWord:word];

    }
   
    return self;
}
- (void) displayThisWord:(Word*)word{
    if (self.myWord) {
        [self.myWord cancel];
    }
    self.myWord = word;
    self.wordLabel.text = [NSString stringWithFormat:@"%@  [%@]",word.Name,word.Pronunciation];
    self.defLabel.text = word.Definition;
}

- (IBAction)AddToWords:(id)sender{
//    [delegate WordExplainView:self addWord:myWord];
    if  (displayTimer)
    {
        [displayTimer invalidate];
        displayTimer = nil;
    }
    displayTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(hide:) userInfo:nil repeats:NO];
    PLSqliteDatabase * wordsdb = [database UserWordsDatabase];
    NSString* date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    date = [formatter stringFromDate:[NSDate date]];
    NSString * sql = [NSString stringWithFormat:@"INSERT INTO Words (Word,audio,pron,def,CreateDate) VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",myWord.Name,myWord.Audio,myWord.Pronunciation,myWord.Definition,date];
    NSError * err;
    if (![wordsdb executeUpdateAndReturnError:&err statement:sql]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"加入失败" message:@"单词已存在" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"加入成功" message:@"该单词已成功加入生词本，可在生词本中查看" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }
}
- (IBAction)PlayPronciation:(id)sender{
//    [delegate WordExplainView:self playWordSound:myWord];
    if  (displayTimer)
    {
        [displayTimer invalidate];
        displayTimer = nil;
    }
    displayTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(hide:) userInfo:nil repeats:NO];
    NetworkStatus ns = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    if (ns == NotReachable ) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"发音失败" message:@"当前未联网" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
    else {
        SoundPlayer = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:myWord.Audio]];
        [SoundPlayer play];
    }
}
//更新显示状态，state = 1为显示词义状态，state = 2 为等待状态， state = 3 为失败状态
- (void)updateState:(SVWordViewState)state errMSG:(NSString *)err{
    ShowState = state;
    switch (state) {
        case SVWordViewStateDis:
            self.WaitingLabel.hidden = YES;
            self.activeView.hidden = YES;
            self.WrongLabel.hidden = YES;
            [self.activeView stopAnimating];
            self.defLabel.hidden = NO;
            self.ProunceButton.hidden = NO;
            self.AddWordButton.hidden = NO;
            break;
        case SVWordViewStateWaiting:
            self.WaitingLabel.hidden = NO;
            self.activeView.hidden = NO;
            self.WrongLabel.hidden = YES;
            [self.activeView startAnimating];
            self.defLabel.hidden = YES;
            self.ProunceButton.hidden = YES;
            self.AddWordButton.hidden = YES;
            break;
        case SVWordViewStateDisFail:
            self.WrongLabel.text = err;
            self.WrongLabel.hidden = NO;
            self.WaitingLabel.hidden = YES;
            self.activeView.hidden = YES;
            [self.activeView startAnimating];
            self.defLabel.hidden = YES;
            self.ProunceButton.hidden = YES;
            self.AddWordButton.hidden = YES;
            break;
        default:
            break;
    }
}

- (void) show{
    BOOL ipad = [AppDelegate isPad];
    CGFloat windowHeight = ipad ? 768 : IS_IPHONE_5 ? 568 : 480;
    CGFloat pointX = ipad ? 500 : 0;
    CGFloat pointY = windowHeight - view.frame.size.height;

    
    if  (displayTimer)
    {
        [displayTimer invalidate];
        displayTimer = nil;
    }
    if (ShowState != SVWordViewStateWaiting) {
        displayTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(hide:) userInfo:nil repeats:NO];
    }

    if (!self || self.frame.origin.y == pointY) {
        
        return;
    }
    [UIView beginAnimations:@"ShowMyView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:0.5];
    self.frame = CGRectMake(pointX, windowHeight - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    NSLog(@"word explain view frame:%@",[NSValue valueWithCGRect:self.frame ]);
    [UIView commitAnimations];
}
- (void) hide:(NSTimer *)timer{

    BOOL ipad = [AppDelegate isPad];
    CGFloat windowHeight = ipad ? 768 : IS_IPHONE_5 ? 568 : 480;
    CGFloat pointX = ipad ? 500 : 0;
    if (self.frame.origin.y != windowHeight) {//不在底部，则将其放在底部。
        [UIView beginAnimations:@"HideMyView" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationDuration:0.5];
        self.frame = CGRectMake(pointX, windowHeight , self.frame.size.width, self.frame.size.height);
        [UIView commitAnimations];

        [SevenLabel RemoveBackground];
        return;
    }
    
}
+ (void) RemoveView{
    if (view) {
        [view removeFromSuperview];
        view = nil;
    }
}
@end
