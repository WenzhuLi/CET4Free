//
//  RegisterViewController.h
//  CET4Lite
//
//  Created by Seven Lee on 12-4-17.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ASIHTTPRequest.h"

@interface RegisterViewController : UIViewController<UITextFieldDelegate,ASIHTTPRequestDelegate>{
    IBOutlet UIScrollView * scroll;
    IBOutlet UITextField * UserNameTextField;
    IBOutlet UITextField * Password1TextField;
    IBOutlet UITextField * Password2TextField;
    IBOutlet UITextField * EmailTextField;
    IBOutlet UILabel * LabelAfterReg;
    IBOutlet UIButton * RegistBtn;
    NSArray * TextFieldArray;
    NSArray * TextFieldNameArray;
    MBProgressHUD * HUD;
    ASIHTTPRequest * regRequest;
}
@property (nonatomic,strong) IBOutlet UIScrollView * scroll;
@property (nonatomic,strong) IBOutlet UITextField * UserNameTextField;
@property (nonatomic,strong) IBOutlet UITextField * Password1TextField;
@property (nonatomic,strong) IBOutlet UITextField * Password2TextField;
@property (nonatomic,strong) IBOutlet UITextField * EmailTextField;
@property (nonatomic,strong) IBOutlet UILabel * LabelAfterReg;
@property (nonatomic,strong) IBOutlet IBOutlet UIButton * RegistBtn;

- (IBAction)dismissMyself:(id)sender;
- (IBAction)RegistGo:(UIButton *)sender;
@end
