//
//  HelpViewController.m
//  CET4Lite
//
//  Created by Seven Lee on 12-4-27.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController
@synthesize pageControl;
@synthesize scroll;
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
    self.navigationItem.title = @"使用帮助";
    self.pageControl.numberOfPages = 5;
    self.scroll.pagingEnabled = YES;
    self.scroll.delegate = self;
    self.scroll.showsVerticalScrollIndicator = NO;
    self.scroll.showsHorizontalScrollIndicator = NO;
    CGFloat pointX = 0;
    CGFloat pointY = 0;
    CGFloat width = self.scroll.frame.size.width;
    CGFloat height = self.scroll.frame.size.height;
    for (int i = 0; i < 5; i++) {
        NSString * name = [NSString stringWithFormat:@"Help%d.png",i+1];
        UIImageView * helpImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
        CGRect frame = CGRectMake(pointX, pointY, width, height);
        helpImg.frame = frame;
        [self.scroll addSubview:helpImg];
        pointX += width;
    }
    if (IS_IOS7 && !IS_IPAD) {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        
    }
    self.navigationController.navigationBar.translucent = NO;
    self.scroll.contentSize = CGSizeMake(pointX, height);
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
}


@end
