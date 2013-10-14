//
//  RegisterViewController.m
//  CET4Lite
//
//  Created by Seven Lee on 12-4-17.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegexKitLite.h"
#import "DDXML.h"
#import "DDXMLElementAdditions.h"
#import "AppDelegate.h"
#import "UserInfo.h"
#import "NSString+MD5.h"
#import "CET4Constents.h"
@interface RegisterViewController ()

@end

@implementation RegisterViewController
@synthesize scroll;
@synthesize Password1TextField;
@synthesize Password2TextField;
@synthesize UserNameTextField;
@synthesize EmailTextField;
@synthesize LabelAfterReg;
@synthesize RegistBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSString * nibName = [AppDelegate isPad] ? @"RegisterViewController_iPad" : @"RegisterViewController";
    self = [super initWithNibName:nibName bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        TextFieldArray = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"用户注册";
    // Do any additional setup after loading the view from its nib.
    self.scroll.contentSize = CGSizeMake(self.scroll.frame.size.width, self.scroll.frame.size.height + 90);
    TextFieldArray = [NSArray arrayWithObjects: self.UserNameTextField, self.Password1TextField, self.Password2TextField,self.EmailTextField, nil];
    TextFieldNameArray = [NSArray arrayWithObjects:@"用户名", @"密码", @"确认密码", @"E-mail地址", nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.scroll = nil;
    self.UserNameTextField = nil;
    self.Password1TextField = nil;
    self.Password2TextField = nil;
    self.EmailTextField = nil;
    self.RegistBtn = nil;
    self.LabelAfterReg = nil;
}
- (void)viewWillAppear:(BOOL)animated{
    self.LabelAfterReg.text = @"";
    self.scroll.hidden = NO;
    self.RegistBtn.hidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    if (regRequest) {
        [regRequest clearDelegatesAndCancel];
        regRequest = nil;
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (IBAction)dismissMyself:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}
- (IBAction)RegistGo:(UIButton *)sender{
    for (int i = 0; i < 4; i++) {//验证四个输入框是否为空
        UITextField * textField = [TextFieldArray objectAtIndex:i];
        if ([textField.text isEqualToString:@""]) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@不能为空！",[TextFieldNameArray objectAtIndex:i]] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil] ;
            [alert show];
            return;
        }
    }
    if (self.UserNameTextField.text.length > 15 || self.UserNameTextField.text.length < 4) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"用户名长度不符合要求，应在4-15个字符之间" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if ([Password1TextField.text compare:Password2TextField.text] != NSOrderedSame) {
        //验证两次输入的密码是否一致
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"两次输入的密码不一致，请检查" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (![EmailTextField.text isMatchedByRegex:@"^([0-9a-zA-Z]([-.\\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\\w]*[0-9a-zA-Z]\\.)+[a-zA-Z]{2,9})$"]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"请输入有效的E-mail地址！" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view.window];
    [self.view.window addSubview:HUD];
    
    HUD.dimBackground = YES;
    HUD.mode = MBProgressHUDModeDeterminate;
    HUD.labelText = @"正在注册";
    NSString * username = self.UserNameTextField.text;
    NSString * password = [self.Password1TextField.text MD5String];
    NSString * email = self.EmailTextField.text;
    NSString * sign = [[NSString stringWithFormat:@"11002%@%@%@iyubaV2",username,password,email] MD5String];
//    apis.iyuba.com/v2/api.iyuba?protocol=10002
    NSString *url = [NSString stringWithFormat:@"http://api.iyuba.com.cn/v2/api.iyuba?protocol=11002&email=%@&username=%@&password=%@&sign=%@&format=xml&platform=ios&app=cet4&appid=%@&token=%@&x=%f&y=%f",email,username,password,sign,MY_IYUBA_APPID,[[NSUserDefaults standardUserDefaults] objectForKey:kMyPushTokenKey],[SVLocationHandler userLastLongitude],[SVLocationHandler userLastLatitude]];
    regRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    regRequest.delegate = self;
    regRequest.timeOutSeconds = 20;
    [regRequest startAsynchronous];
}
#pragma mark -
#pragma UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //    
    //    if (textField.tag  < 3) //前面三个
    //        [[TextFieldArray objectAtIndex:textField.tag + 1] becomeFirstResponder];
    //    else        //Email
    [textField resignFirstResponder];
    [self.scroll setContentOffset:CGPointMake(0, 0) animated:YES];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    CGFloat pointY = textField.frame.origin.y > 90 ? 90 : 0;
    [self.scroll setContentOffset:CGPointMake(0, textField.origin.y) animated:YES];
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [self.scroll setContentOffset:CGPointMake(0, 0) animated:YES];
    return YES;
}
#pragma mark -
#pragma ASIHTTPRequestDelegate
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [HUD hide:YES];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"网络貌似不太好哦" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSData *myData = [request responseData];
    NSLog(@"response:%@",[request responseString]);
    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:myData options:0 error:nil];
    //    if ([request.username isEqualToString:@"regist" ]) {
    NSArray *items = [doc nodesForXPath:@"response" error:nil];
    if (items) {
        for (DDXMLElement *obj in items) {
            NSString *status = [[obj elementForName:@"result"] stringValue];
            if ([status isEqualToString:@"111"]) {
                //注册成功
                HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                HUD.mode = MBProgressHUDModeCustomView;
                HUD.labelText = @"注册成功";
                
                self.LabelAfterReg.text = [NSString stringWithFormat:@"用户：%@ 注册成功",self.UserNameTextField.text];
                self.LabelAfterReg.hidden = NO;
                self.RegistBtn.hidden = YES;
                self.scroll.hidden = YES;
                [UserInfo setLoggedUserID:[[obj elementForName:@"daga"] stringValue]];
                [UserInfo setLoggedUserName:self.UserNameTextField.text];
                [self performSelector:@selector(dismiss) withObject:nil afterDelay:1];
                
            }else
            {
                NSDictionary * errDic = [NSDictionary dictionaryWithObjectsAndKeys:@"用户名已存在",@"112",@"邮箱已被注册",@"113",@"用户名长度应在4-15个字符",@"114", nil];
                
                [HUD hide:YES];
                NSString *msg = [errDic objectForKey:status] ;
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"注册失败" message:msg delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
                [alert show];
            }
        }
    }
}
- (void)dismiss{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
