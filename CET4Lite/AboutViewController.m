//
//  AboutViewController.m
//  CET4Lite
//
//  Created by Seven Lee on 12-4-23.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "AboutViewController.h"
#import <ShareSDK/ShareSDK.h>
#define VOA_APPID   @"519013738"
#define JLPT3_APPID @"518555576"
#define CET6_APPID  @"529453528"
#define BBC_APPID   @"558115664"
#define MUSIC_APPID @"555917167"

@interface AboutViewController ()

@end

@implementation AboutViewController

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
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"关于爱语吧";
    self.versionLabel.text = [NSString stringWithFormat:@"版本  %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] ];
}
- (IBAction)OtherApps:(UIButton *)sender{
    NSString * urlString = nil;
    switch (sender.tag) {
        case 1:
            urlString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@",BBC_APPID];
            break;
        case 2:
            urlString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@",VOA_APPID];
            break;
        case 3:
            urlString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@",MUSIC_APPID];
            break;
            
        default:
            break;
    }
    @try {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
    @catch (NSException *exception) {
    }

}

- (IBAction)followWeibo:(UIButton *)sender {
    switch (sender.tag) {
        case 0://sina
        {
            //关注用户
            [ShareSDK followUserWithType:ShareTypeSinaWeibo
                                   field:@"爱语吧"
                               fieldType:SSUserFieldTypeName
                             authOptions:nil
                            viewDelegate:nil
                                  result:^(SSResponseState state, id<ISSUserInfo> userInfo,
                                           id<ICMErrorInfo> error) {
                                      if (state == SSResponseStateSuccess)
                                      {
                                          NSLog(@"关注成功");
                                          if (HUD) {
                                              [HUD removeFromSuperview];
                                              HUD = nil;
                                          }
                                          HUD = [[MBProgressHUD alloc] initWithView:self.view];
                                          HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                                          HUD.mode = MBProgressHUDModeCustomView;
                                          HUD.labelText = @"感谢您的关注";
                                          [self.view addSubview:HUD];
                                          [HUD show:YES];
                                          [HUD hide:YES afterDelay:2];
                                          
                                      }
                                      else if (state == SSResponseStateFail)
                                      {
                                          NSLog(@"%@", [NSString stringWithFormat:@"关注失败:%@", error.errorDescription]);
                                          if (HUD) {
                                              [HUD removeFromSuperview];
                                              HUD = nil;
                                          }
                                          HUD = [[MBProgressHUD alloc] initWithView:self.view];
                                          HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-X.png"]];
                                          HUD.mode = MBProgressHUDModeCustomView;
                                          HUD.labelText = error.errorDescription;
                                          [self.view addSubview:HUD];
                                          [HUD show:YES];
                                          [HUD hide:YES afterDelay:2];
                                                        }
                                                        }];
    }
            break;
        case 1://tencent
            //关注用户
        {
            [ShareSDK followUserWithType:ShareTypeTencentWeibo
                                   field:@"yulusoftware"
                               fieldType:SSUserFieldTypeName
                             authOptions:nil
                            viewDelegate:nil
                                  result:^(SSResponseState state, id<ISSUserInfo> userInfo,
                                           id<ICMErrorInfo> error) {
                                      if (state == SSResponseStateSuccess)
                                      {
                                          NSLog(@"关注成功");
                                          if (HUD) {
                                              [HUD removeFromSuperview];
                                              HUD = nil;
                                          }
                                          HUD = [[MBProgressHUD alloc] initWithView:self.view];
                                          HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                                          HUD.mode = MBProgressHUDModeCustomView;
                                          HUD.labelText = @"感谢您的关注";
                                          [self.view addSubview:HUD];
                                          [HUD show:YES];
                                          [HUD hide:YES afterDelay:2];
                                      }
                                      else if (state == SSResponseStateFail)
                                      {
                                          NSLog(@"%@", [NSString stringWithFormat:@"关注失败:%@", error.errorDescription]);
                                          if (HUD) {
                                              [HUD removeFromSuperview];
                                              HUD = nil;
                                          }
                                          HUD = [[MBProgressHUD alloc] initWithView:self.view];
                                          HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-X.png"]];
                                          HUD.mode = MBProgressHUDModeCustomView;
                                          HUD.labelText = error.errorDescription;
                                          [self.view addSubview:HUD];
                                          [HUD show:YES];
                                          [HUD hide:YES afterDelay:2];
                                      }
                                  }];
        }
            break;
            
        default:
            break;
    }
}
- (IBAction)goUrl:(id)sender
{
    if ([self isExistenceNetwork:1]) {
        InforController *myInfor = [[InforController alloc]init];
        [self.navigationController pushViewController:myInfor animated:YES];
    }
}
- (void)viewDidUnload
{
    [self setVersionLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(BOOL) isExistenceNetwork:(NSInteger)choose
{
	BOOL isExistenceNetwork;
	Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
			isExistenceNetwork=FALSE;
            break;
        case ReachableViaWWAN:
			isExistenceNetwork=TRUE;
            break;
        case ReachableViaWiFi:
			isExistenceNetwork=TRUE;     
            break;
    }
	if (!isExistenceNetwork) {
        UIAlertView *myalert = nil;
        switch (choose) {
            case 0:
                
                break;
            case 1:
                myalert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"联网后才可访问" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
                [myalert show];
                break;
            default:
                break;
        }
	}
	return isExistenceNetwork;
}

@end
