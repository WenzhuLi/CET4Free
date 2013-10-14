//
//  XDFCouponsViewController.h
//  CET4Free
//
//  Created by Lee Seven on 13-9-24.
//  Copyright (c) 2013年 iyuba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDFCouponsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *getCodeButton10;
@property (strong, nonatomic) IBOutlet UIButton *getCodeButton30;
@property (strong, nonatomic) IBOutlet UILabel *code10Label;
@property (strong, nonatomic) IBOutlet UILabel *code30Label;
- (IBAction)getCode:(UIButton *)sender;
@end
