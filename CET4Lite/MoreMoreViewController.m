//
//  MoreMoreViewController.m
//  CET4Lite
//
//  Created by Seven Lee on 12-4-18.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "MoreMoreViewController.h"

@interface MoreMoreViewController ()

@end

@implementation MoreMoreViewController

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
    if (IS_IOS7 && !IS_IPAD) {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        
    }
    self.navigationController.navigationBar.translucent = NO;
    // Do any additional setup after loading the view from its nib.
    IASKAppSettingsViewController * settings = [[IASKAppSettingsViewController alloc] init];
    settings.delegate = self;
    [self.view addSubview:settings.view];
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
#pragma mark -
#pragma IASKDelegate
- (void)settingsViewControllerDidEnd:(IASKAppSettingsViewController*)sender{
    
}
@end
