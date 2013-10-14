//
//  FeedbackViewController.m
//  CET4Lite
//
//  Created by Seven Lee on 12-4-23.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "FeedbackViewController.h"
#import "AppDelegate.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController
@synthesize EmailField;
@synthesize ContentText;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id) init{
    if ([AppDelegate isPad] ) {
        return [self initWithNibName:@"FeedBackController_iPad" bundle:nil];
    }
    else {
        return [self initWithNibName:@"FeedbackViewController" bundle:nil];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"用户反馈";
    UIBarButtonItem * sendButton = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleBordered target:self action:@selector(sendFeedback)];
    self.navigationItem.rightBarButtonItem = sendButton;
    sendButton.enabled = NO;
    ContentText.delegate = self;
    NSString * isRetina = @"";
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] == YES && [[UIScreen mainScreen] scale] == 2.00) {
        // RETINA DISPLAY
        isRetina = @"Retina";
    }
    NSString * appInfo = [NSString stringWithFormat:@"\n----\n应用版本:%@ \n系统版本:%@ \n设备:%@ %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"],[[UIDevice currentDevice] systemVersion],[UIDevice currentDevice].model,isRetina];
    if (IS_IOS7) {
        self.navigationController.navigationBar.tintColor = IS_IPAD ?  [UIColor colorWithRed:0.682 green:0.329 blue:0.0 alpha:1.0] :[UIColor whiteColor];
//        self.navigationController.navigationBar.barTintColor = IS_IPAD ?  [UIColor colorWithRed:0.682 green:0.329 blue:0.0 alpha:1.0] :[UIColor whiteColor];
        
    }
    self.navigationController.navigationBar.translucent = NO;
    [ContentText setText:appInfo];
    ContentText.selectedRange = NSMakeRange(0, 0);
    [ContentText becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)sendFeedback{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LoggedUserID"] isEqualToString:@""]) {
        if ([self.EmailField.text isEqualToString:@""]) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"请输入您的Email" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            return;
        }else {
            if (![EmailField.text isMatchedByRegex:@"^([0-9a-zA-Z]([-.\\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\\w]*[0-9a-zA-Z]\\.)+[a-zA-Z]{2,9})$"]) {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"请输入有效的E-mail地址！" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
                [alert show];
                return;
            }
            NSString * decodedString = [[NSString alloc] initWithUTF8String:[ContentText.text UTF8String]];
            NSString * email = [[NSString alloc] initWithUTF8String:[EmailField.text UTF8String]];
//            NSString * url = [NSString stringWithFormat:@"http://api.iyuba.com/mobile/ios/voa/feedback.plain",
            ASIFormDataRequest * request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.iyuba.com/mobile/ios/cet4/feedback.plain"]];
            request.delegate = self;
            
            [request setPostValue:decodedString forKey:@"content"];
            [request setPostValue:email forKey:@"email"];
            [request startSynchronous];
            
        }
    }
    else {
        ASIFormDataRequest * request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.iyuba.com/mobile/ios/cet4/feedback.plain"]];
        request.delegate = self;
        NSString * decodedString = [[NSString alloc] initWithUTF8String:[ContentText.text UTF8String]];
        NSString * uid = [[NSString alloc] initWithUTF8String:[[[NSUserDefaults standardUserDefaults] objectForKey:@"LoggedUserID"] UTF8String]];
        [request setPostValue:decodedString forKey:@"content"];
        [request setPostValue:uid forKey:@"uid"];
        [request startAsynchronous];
    }
    
}
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders{
    if ([request responseStatusCode] >= 400) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"连接失败" message:@"连接失败，服务器暂不可用" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

- (void) requestFinished:(ASIHTTPRequest *)request{
    NSString * str = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSArray * array = [str componentsSeparatedByString:@","];
    if ([[array objectAtIndex:0] isEqualToString:@"OK"]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"发送成功" message:@"感谢您的意见和建议，我们会努力改进" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else
        if ([[array objectAtIndex:0] isEqualToString:@"NG"]) {
            NSString * err = [array objectAtIndex:1];
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"发送失败" message:err delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        else {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"发送失败" message:@"未知错误" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
}
- (void) requestFailed:(ASIHTTPRequest *)request{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"发送失败" message:@"网络貌似不太好哦" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}
- (void)textViewDidChange:(UITextView *)textView1{
    if ([textView1.text length] == 0) 
        self.navigationItem.rightBarButtonItem.enabled = NO;
    else
        self.navigationItem.rightBarButtonItem.enabled = YES;
}
@end
