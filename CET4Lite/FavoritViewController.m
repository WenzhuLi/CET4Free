//
//  FavoritViewController.m
//  CET4Lite
//
//  Created by Seven Lee on 12-2-24.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "FavoritViewController.h"
#import "FavQuesViewController.h"
#import "CETAdapter.h"

@interface FavoritViewController ()

@end

@implementation FavoritViewController

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
    self.navigationItem.title = @"收藏夹";
    if (IS_IOS7 && !IS_IPAD) {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.translucent = NO;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any stronged subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(IBAction)SectionSelected:(UIButton *)sender{
//    CETAdapter * adapter = [[CETAdapter alloc] initWithUserCollectionSection:sender.tag scroll:nil];
    if ([CETAdapter numberOfCollectionsInSection:sender.tag] > 0) {
        FavQuesViewController * fqc = [[FavQuesViewController alloc] initWithSection:sender.tag];
        fqc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:fqc animated:YES];
    }
    else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"还没有收藏" message:@"这部分还没有收藏任何题目哦～" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alert show];
    }
}
@end
