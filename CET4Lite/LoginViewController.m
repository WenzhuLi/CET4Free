//
//  LoginViewController.m
//  CET4Lite
//
//  Created by Seven Lee on 12-4-16.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "LoginViewController.h"
#import "DDXML.h"
#import "DDXMLElementAdditions.h"
#import "SFHFKeychainUtils.h"
#import "RegisterViewController.h"
#import "Reachability.h"
#import "UserInfo.h"
#import "AppDelegate.h"
#import "NSString+MD5.h"
#import "UIImageView+WebCache.h"
#import "ASIFormDataRequest.h"
#import "SVLocationHandler.h"

@interface LoginViewController ()
@property (nonatomic, strong) ASIFormDataRequest * uploadRequest;
@end

@implementation LoginViewController
@synthesize PassWordTextField;
@synthesize UsrNameTextField;
@synthesize CurrentUsrLabel;
@synthesize LoginView;
@synthesize LogoutView;
@synthesize navBar;
@synthesize PresOrPush;
@synthesize RemPasswordBtn;
@synthesize YuBLabel;



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (IS_IPAD) {
        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight );
    }
    else{
        return interfaceOrientation == UIInterfaceOrientationPortrait;
    }

}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;

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


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSString * nibName = [AppDelegate isPad] ? @"LoginViewController_iPad" : @"LoginViewController";
    self = [super initWithNibName:nibName bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        LoggedIn = [UserInfo userLoggedIn];
        self.PresOrPush = NO; // default push
    }
    return self;
}
- (void)viewWillDisappear:(BOOL)animated{
    if (loginRequest) {
        [loginRequest clearDelegatesAndCancel];
        loginRequest = nil;
    }
    if (yubRequest) {
        [yubRequest clearDelegatesAndCancel];
        yubRequest = nil;
    }
    if (HUD) {
        [HUD removeFromSuperview];
        HUD.delegate = nil;
        HUD = nil;
    }
    if (self.uploadRequest) {
        [self.uploadRequest clearDelegatesAndCancel];
        [self.uploadRequest setFailedBlock:nil];
        [self.uploadRequest setCompletionBlock:nil];
        self.uploadRequest = nil;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IS_IOS7 && !IS_IPAD) {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        
    }
    self.navigationController.navigationBar.translucent = NO;
    // Do any additional setup after loading the view from its nib.
    //    self.navigationController.navigationBarHidden = YES;
    self.title = @"用户登录";
    self.avatarImg.layer.cornerRadius = 10;
    self.avatarImg.layer.masksToBounds = YES;
    self.CurrentUsrLabel.text = [UserInfo loggedUserName];
    UIImage * bg =[UIImage imageNamed:@"birdQuestionBG.png"];
    if ([bg respondsToSelector:@selector(resizableImageWithCapInsets:)]) {
        bg = [bg resizableImageWithCapInsets:UIEdgeInsetsMake(40, 20, 27, 40)];
    }
    else{
        bg = [bg stretchableImageWithLeftCapWidth:40 topCapHeight:30];
    }
    [self.editAvatarButton setBackgroundImage:bg forState:UIControlStateNormal];
//    [UserInfo setLoggedUserName:self.CurrentUsrLabel.text];
//    self.CurrentUsrLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:kLoggedUserKey];
    NSString * user = [UserInfo loggedUserName];
    //    NSString * user = [[NSUserDefaults standardUserDefaults] objectForKey:kLoggedUserKey];
    if ([user isEqualToString:@""]) {
        LoggedIn = NO;
        self.LogoutView.hidden = YES;
        self.LoginView.hidden = NO;
    }
    else {
        LoggedIn = YES;
        [self.avatarImg setImageWithURL:[NSURL URLWithString:[UserInfo loggedUserAvatarURL]] placeholderImage:[UIImage imageNamed:@"avatar_default_big"]];
        [[SDImageCache sharedImageCache] setMaxCacheAge:NSIntegerMax];
        [self LoginViewWillAppear:user];
        self.LoginView.hidden = YES;
        self.LogoutView.hidden = NO;
        self.CurrentUsrLabel.text = user;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    
    
    [super viewWillAppear:animated];
}
//- (void) viewDidAppear:(BOOL)animated{
//    if (!PresOrPush) {
//        //        self.navigationController.navigationBarHidden = YES;
//        [self.view setFrame:CGRectMake(0, -44, self.view.frame.size.width, self.view.frame.size.height)];
//        
//    }
//    [super viewDidAppear:animated];
//}
- (void)LoginViewWillAppear:(NSString *) user{
    self.CurrentUsrLabel.text = user;
    self.YuBLabel.text = @"正在获取...";
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reach currentReachabilityStatus];
    if (status == NotReachable) {
        self.YuBLabel.text = @"无网络连接";
    }
    else {
        NSString * userID = [UserInfo loggedUserID];
        [self.avatarImg setImageWithURL:[NSURL URLWithString:[UserInfo loggedUserAvatarURL]] placeholderImage:[UIImage imageNamed:@"avatar_default_big"]];
//        NSString * userID = [[NSUserDefaults standardUserDefaults] objectForKey:kLoggedUserID];
        NSString *url = [NSString stringWithFormat:@"http://app.iyuba.com/pay/checkApi.jsp?userId=%@",userID];
        yubRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
        yubRequest.delegate = self;
        [yubRequest setUsername:@"yub"];
        [yubRequest startAsynchronous];
    }
}
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}

- (IBAction)RemeberSNPressed:(UIButton *)sender{
    sender.selected = !sender.selected;
}
- (IBAction)Login:(UIButton *)sender{
    if (self.PassWordTextField.text.length > 0 && self.UsrNameTextField.text.length > 0) {
        NSString * username = self.UsrNameTextField.text;
        NSString * password = [self.PassWordTextField.text MD5String];
        NSString * sign = [[NSString stringWithFormat:@"11001%@%@iyubaV2",username,password] MD5String];
        NSString * urlStr = [NSString stringWithFormat:@"http://api.iyuba.com.cn/v2/api.iyuba?protocol=11001&username=%@&password=%@&sign=%@&format=xml&appid=%@&x=%f&y=%f&token=%@&appid=%@",username,password,sign,MY_IYUBA_APPID,[SVLocationHandler userLastLongitude],[SVLocationHandler userLastLatitude],[[NSUserDefaults standardUserDefaults] objectForKey:kMyPushTokenKey],MY_IYUBA_APPID];
//        NSString * urlstr = [NSString stringWithFormat:@"http://api.iyuba.com/mobile/ios/cet6/login.xml?username=%@&password=%@&md5status=0",self.UsrNameTextField.text,self.PassWordTextField.text];
        NSLog(@"url:%@",urlStr);
        if (HUD) {
            [HUD removeFromSuperview];
            HUD.delegate = nil;
            HUD = nil;
        }
        HUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:HUD];
        HUD.delegate = nil;
        HUD.dimBackground = YES;
        
        HUD.labelText = @"正在登录";
        [HUD show:YES];
        loginRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        loginRequest.delegate = self;
        loginRequest.timeOutSeconds = 20;
        [loginRequest setUsername:@"log"];
        [loginRequest startAsynchronous];
    }
    else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"信息为空" message:@"请输入您的用户名和密码！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}
- (IBAction)GoToRegister:(UIButton *)sender{
    self.CurrentUsrLabel.text = @"";
    [UserInfo logOut];
//    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kLoggedUserKey];
//    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kLoggedUserID];
    self.LogoutView.hidden = YES;
    self.LoginView.hidden = NO;
    RegisterViewController * regi = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    if (PresOrPush) {
        regi.navigationItem.hidesBackButton = YES;
    }
    
    if ([AppDelegate isPad]) {
        regi.view.bounds = CGRectMake(0, 0, 400, 480);
    }
    
//    [self presentModalViewController:regi animated:YES];
    [self.navigationController pushViewController:regi animated:YES];
    
}
- (IBAction)Logout:(UIButton *)sender{
    HUD = [[MBProgressHUD alloc] initWithView:self.view.window];
	[self.view.window addSubview:HUD];
	
    HUD.delegate = self;
    HUD.labelText = @"正在注销";
	
    //    [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
//    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kLoggedUserID];
//    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kLoggedUserKey];
    [UserInfo logOut];
    self.LogoutView.hidden = YES;
    self.LoginView.hidden = NO;
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
	HUD.mode = MBProgressHUDModeCustomView;
	HUD.labelText = @"注销成功";
	sleep(1);
    
}

- (IBAction)Cancel:(id)sender{
    [self popMyself];
}

- (IBAction)editAvatar:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"重新上传"]) {
        [self uploadAvatar:self.avatarImg.image];
    }
    else{
        UIActionSheet * avatarAction = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
        [avatarAction showInView:self.view];
    }
    
}

- (void) popMyself{
    if (PresOrPush) {
        [self dismissModalViewControllerAnimated:YES];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)uploadAvatar:(UIImage *)avatarImg{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"正在上传";
    [HUD show:YES];
    if (self.uploadRequest) {
        [self.uploadRequest clearDelegatesAndCancel];
        self.uploadRequest.delegate = nil;
        self.uploadRequest = nil;
    }
    NSData * imgData = UIImageJPEGRepresentation(avatarImg, 1.0);
    //        uploadRequest = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:@"http://172.16.94.220:8081/upload/UpLoadFileServlet"]];
    //        uploadRequest = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:PROTOCOLSUFFIX]];
    
    //        [uploadRequest setPostFormat:ASIMultipartFormDataPostFormat];
    //        [uploadRequest addPostValue:PROTOCOL_CODE_UPLOADAVATAR forKey:@"protocol"];
    self.uploadRequest = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.iyuba.com.cn/v2/avatar?uid=%@",[UserInfo loggedUserID]]]];
    NSLog(@"uid:%@,username:%@",[UserInfo loggedUserID],[UserInfo loggedUserName]);
    [self.uploadRequest setRequestMethod:@"POST"];
    [self.uploadRequest setPostValue:@"head" forKey:@"path"];
    [self.uploadRequest addData:imgData withFileName:@"user_avatar.jpg" andContentType:@"multipart/form-data" forKey:@"content"];
    self.uploadRequest.timeOutSeconds = 60;
    __weak LoginViewController * weakSelf = self;
    [self.uploadRequest setFailedBlock:^{
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"上传失败" message:[weakSelf.uploadRequest.error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [weakSelf.editAvatarButton setTitle:@"重新上传" forState:UIControlStateNormal];
        [weakSelf.avatarImg setImage:avatarImg];
    }];
    [self.uploadRequest setCompletionBlock:^{
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"修改成功" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [weakSelf.editAvatarButton setTitle:@"修改头像" forState:UIControlStateNormal];
        [[SDImageCache sharedImageCache] removeImageForKey:[UserInfo loggedUserAvatarURL] fromDisk:YES];
        [weakSelf.avatarImg setImageWithURL:[NSURL URLWithString:[UserInfo loggedUserAvatarURL]] placeholderImage:avatarImg];
    }];
    [self.uploadRequest startAsynchronous];
}
#pragma mark -
#pragma UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.tag == 0) //UsrName
        [PassWordTextField becomeFirstResponder];
    else 
        [textField resignFirstResponder];
    
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField.tag == 0) {
        //        KeychainItemWrapper * keychain = [[KeychainItemWrapper alloc] initWithIdentifier:textField.text accessGroup:nil];
        NSString * pass = [SFHFKeychainUtils getPasswordForUsername:textField.text andServiceName:kMyAppService error:nil];
        if (pass) {
            self.PassWordTextField.text = pass;
            self.RemPasswordBtn.selected = YES;
        }
        
    }
    return YES;
}
#pragma mark -
#pragma ASIHTTPRequestDelegate
- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (HUD) {
        [HUD hide:YES];
    }
    if ([request.username isEqualToString:@"log"]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"请检查您的网络设置" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    if ([request.username isEqualToString:@"yub"]) {
        self.YuBLabel.text = @"网络连接失败";
    }
    
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (HUD) {
        [HUD hide:YES];
    }
    NSData *myData = [request responseData];
    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:myData options:0 error:nil];
    if ([request.username isEqualToString:@"yub"]) {
        NSArray *items = [doc nodesForXPath:@"response" error:nil];
        if (items) {
            for (DDXMLElement *obj in items) {
                NSString *amount = [[obj elementForName:@"amount"] stringValue];
                self.YuBLabel.text = amount;
            }
        }
    }
    
    if ([request.username isEqualToString:@"log" ]) {
        NSArray *items = [doc nodesForXPath:@"response" error:nil];
        if (items) {
            for (DDXMLElement *obj in items) {
                NSString *result = [[obj elementForName:@"result"] stringValue];
                //                s(@"status:%@",status);
                if ([result isEqualToString:@"101"]) {
                    [UserInfo setLoggedUserName:self.UsrNameTextField.text];
//                    [[NSUserDefaults standardUserDefaults] setObject:self.UsrNameTextField.text forKey:kLoggedUserKey];
                    NSString * userID = [[obj elementForName:@"uid"] stringValue];
                    [UserInfo setLoggedUserID:userID];
                    NSString *isVIP = [[obj elementForName:@"vipStatus"] stringValue];
                    if ([isVIP isEqualToString:@"1"]) {
                        [UserInfo setIsVIP:YES];
                        [UserInfo setVIPExpireTime:[[[obj elementForName:@"expireTime"] stringValue] doubleValue]];
                    }
                    else{
                        [UserInfo setIsVIP:NO];
                        [UserInfo setVIPExpireTime:0.0];
                    }
//                    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:kLoggedUserID];
                    if (RemPasswordBtn.selected) {
                        //                        KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:self.UsrNameTextField.text accessGroup:nil];
                        //                        [keychain setObject:self.PassWordTextField.text forKey:kPasswordKey];
                        [SFHFKeychainUtils storeUsername:self.UsrNameTextField.text andPassword:self.PassWordTextField.text forServiceName:kMyAppService updateExisting:YES error:nil];
                    }
                    if (HUD) {
                        [HUD removeFromSuperview];
                        HUD = nil;
                    }
                    HUD = [[MBProgressHUD alloc] initWithView:self.view];
                    [self.view addSubview:HUD];
                    
                    // The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
                    // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
                    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                    
                    // Set custom view mode
                    HUD.mode = MBProgressHUDModeCustomView;
                    
                    HUD.delegate = self;
                    HUD.labelText = @"登录成功";
                    
                    [HUD show:YES];
                    [HUD hide:YES afterDelay:1];
//                    self.CurrentUsrLabel.text = self.UsrNameTextField.text;
                    [self LoginViewWillAppear:self.UsrNameTextField.text];
                    self.LoginView.hidden = YES;
                    self.LogoutView.hidden = NO;
                    
                }else if([result isEqualToString:@"103"] || [result isEqualToString:@"102"] || [result isEqualToString:@"105"])
                {
                    NSString *msg = @"用户名或密码错误" ;
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    
                    [alert show];
                }
                else{
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    
                    [alert show];
                }
            }
        }
    }
}

#pragma mark -
#pragma MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud{
    [self popMyself];
}
#pragma mark -
#pragma mark UIActionSheetDelegate
- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
        NSLog(buttonIndex == 0 ? @"拍照" : @"相册选择");
        if (buttonIndex == 0) {
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.delegate = self;
            picker.allowsEditing = YES;
            [self presentModalViewController:picker animated:YES];
        }
        else if (buttonIndex == 1){
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerCameraCaptureModePhoto;
            picker.delegate = self;
            picker.allowsEditing = YES;
            [self presentModalViewController:picker animated:YES];
        }
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissModalViewControllerAnimated:NO];

    UIImage * pickedImg = [info valueForKey:UIImagePickerControllerEditedImage];
    [self uploadAvatar:pickedImg];

}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissModalViewControllerAnimated:YES];
}
@end
