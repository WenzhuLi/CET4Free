//
//  XDFCouponsViewController.m
//  CET4Free
//
//  Created by Lee Seven on 13-9-24.
//  Copyright (c) 2013年 iyuba. All rights reserved.
//

#import "XDFCouponsViewController.h"
#import "ASIHTTPRequest.h"
#import "DDXML.h"
#import "DDXMLElementAdditions.h"
#import "UserInfo.h"
#import "LoginViewController.h"
#import "MBProgressHUD.h"

@interface XDFCouponsViewController ()
@property (nonatomic, strong)ASIHTTPRequest * getCodeRequest;
@property (nonatomic, strong)MBProgressHUD * HUD;
@end

@implementation XDFCouponsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"新东方在线优惠券";
    self.code10Label.layer.borderWidth = 1;
    self.code10Label.layer.borderColor = [[UIColor blackColor] CGColor];
    self.code30Label.layer.borderWidth = 1;
    self.code30Label.layer.borderColor = [[UIColor blackColor] CGColor];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated{
    NSString * coupon10 = [UserInfo xdfCoupons10];
    NSString * coupon30 = [UserInfo xdfCoupons30];
    if (coupon10) {
        self.code10Label.text = coupon10;
        self.getCodeButton10.enabled = NO;
    }
    if (coupon30) {
        self.code30Label.text = coupon30;
        self.getCodeButton30.enabled = NO;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(IS_IPAD){
        return (interfaceOrientation == UIInterfaceOrientationIsLandscape(interfaceOrientation));
    }
    else
        return interfaceOrientation == UIInterfaceOrientationPortrait;
    
}
- (IBAction)getCode:(UIButton *)sender {
    if (![UserInfo userLoggedIn]) {
        LoginViewController * login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    NSString * username = [UserInfo loggedUserName];
    NSString * url = [[NSString stringWithFormat:@"http://cet.iyuba.com/xdfCode.jsp?userId=%@&area=%d&platform=ios",username,sender.tag] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (self.getCodeRequest) {
        [self.getCodeRequest clearDelegatesAndCancel];
        [self.getCodeRequest setCompletionBlock:nil];
        [self.getCodeRequest setFailedBlock:nil];
    }
    self.getCodeRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
    __weak XDFCouponsViewController * weakSelf = self;
    
    [self.getCodeRequest setFailedBlock:^{
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"获取失败" message:[weakSelf.getCodeRequest.error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
    }];
    [self.getCodeRequest setCompletionBlock:^{
        NSData *myData = [weakSelf.getCodeRequest responseData];
        DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:myData options:0 error:nil];
        NSError * err = nil;
        NSArray *items = [doc nodesForXPath:@"response" error:&err];
        if (err) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"获取失败" message:@"服务器异常" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            return;
        }
        for (DDXMLElement *obj in items) {
            NSString *result = [[obj elementForName:@"code"] stringValue];
            NSInteger area = [[[obj elementForName:@"area"] stringValue] integerValue];
            if (result) {
                if (area == 10) {
                    weakSelf.code10Label.text = result;
                    weakSelf.getCodeButton10.enabled = NO;
                    [UserInfo setXDFCoupons10:result];
                }
                else if (area == 30){
                    weakSelf.code30Label.text = result;
                    weakSelf.getCodeButton30.enabled = NO;
                    [UserInfo setXDFCoupons30:result];
                }
            }
        }
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
    }];
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.labelText = @"正在获取";
    [self.HUD show:YES];
    self.getCodeRequest.timeOutSeconds = 30;
    self.getCodeRequest.numberOfTimesToRetryOnTimeout = 2;
    [self.getCodeRequest startAsynchronous];
}
@end
