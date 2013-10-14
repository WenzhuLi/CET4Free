//
//  WordDetailViewController.m
//  CET4Lite
//
//  Created by Seven Lee on 12-9-14.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "WordDetailViewController.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "Reachability.h"
@interface WordDetailViewController ()

@end

static AVPlayer * player;
@implementation WordDetailViewController
@synthesize wordNameLabel;
@synthesize wordDefLabel;
@synthesize pronounceLabel;
@synthesize navItem;
@synthesize word = _word;
- (id) initWithWord:(Word *) word
{
    self = [super initWithNibName:nil  bundle:nil];
    if (self) {
        // Custom initialization
        self.word = word;
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
    [self setWord:self.word];
}

- (void)viewDidUnload
{
    [self setWordNameLabel:nil];
    [self setWordDefLabel:nil];
    [self setPronounceLabel:nil];
    HUD = nil;
    [self setNavItem:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)playSound:(id)sender {
    NSString * pro = self.word.Audio;
//    NSLog(@"pro:%@",pro);
    if ([pro isEqualToString:@""]) {
//        NSLog(@"pro is null");
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-X.png"]];
        HUD.labelText = @"音频缺失";
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.removeFromSuperViewOnHide = YES;
        [self.view addSubview:HUD];
        [HUD show:YES];
        [HUD hide:YES afterDelay:1.5];
        return;
    }
    
    else {
        NetworkStatus ns = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
        if (ns == NotReachable ) {
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-X.png"]];
            HUD.labelText = @"网络连接失败";
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.removeFromSuperViewOnHide = YES;
            [self.view addSubview:HUD];
            [HUD show:YES];
            [HUD hide:YES afterDelay:1.5];
        }
        else {
            //            wordPlayer = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:pro]];
            //            [wordPlayer play];
            player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:pro]];
            [player play];
        }
    }
}
- (void)setWord:(Word *)word{
    if (_word) {
        [_word cancel];
        _word = nil;
    }
    _word = word;
    self.wordDefLabel.text = self.word.Definition;
    self.wordNameLabel.text = self.word.Name;
    self.pronounceLabel.text = [NSString stringWithFormat:@"[%@]",self.word.Pronunciation];
    self.navItem.title = self.word.Name;
}
- (IBAction)close:(id)sender {
    /*
    [XAppDelegate.stackController popViewControllerAnimated:YES];
     */
    self.view.hidden = YES;
}
@end
