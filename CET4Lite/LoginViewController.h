//
//  LoginViewController.h
//  CET4Lite
//
//  Created by Seven Lee on 12-4-16.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
#import "CET4Constents.h"


@interface LoginViewController : UIViewController<UITextFieldDelegate,ASIHTTPRequestDelegate,MBProgressHUDDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>{
    IBOutlet UITextField * UsrNameTextField;
    IBOutlet UITextField * PassWordTextField;
    IBOutlet UILabel * CurrentUsrLabel;
    IBOutlet UIView * LoginView;
    IBOutlet UIView * LogoutView;
    IBOutlet UINavigationBar * navBar;
    IBOutlet UIButton * RemPasswordBtn;
    IBOutlet UILabel * YuBLabel;
    BOOL PresOrPush;  //Present(Yes) Or Push(NO)
    BOOL LoggedIn;
    MBProgressHUD *HUD;
    ASIHTTPRequest * loginRequest;
    ASIHTTPRequest * yubRequest;
}
@property (nonatomic, strong) IBOutlet UITextField * UsrNameTextField;
@property (nonatomic, strong) IBOutlet UITextField * PassWordTextField;
@property (nonatomic, strong) IBOutlet UILabel * CurrentUsrLabel;
@property (nonatomic, strong) IBOutlet UILabel * YuBLabel;
@property (nonatomic, strong) IBOutlet UIView * LoginView;
@property (nonatomic, strong) IBOutlet UIView * LogoutView;
@property (nonatomic, strong) IBOutlet UINavigationBar * navBar;
@property (nonatomic, strong) IBOutlet UIButton * RemPasswordBtn;
@property (nonatomic, assign) BOOL PresOrPush;
@property (strong, nonatomic) IBOutlet UIButton *editAvatarButton;
@property (strong, nonatomic) IBOutlet UIImageView *avatarImg;

- (IBAction)RemeberSNPressed:(UIButton *)sender;
- (IBAction)Login:(UIButton *)sender;
- (IBAction)GoToRegister:(UIButton *)sender;
- (IBAction)Logout:(UIButton *)sender;
- (IBAction)Cancel:(id)sender;
- (IBAction)editAvatar:(UIButton *)sender;
@end
