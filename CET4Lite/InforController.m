//
//  InforController.m
//  VOA
//
//  Created by song zhao on 12-3-31.
//  Copyright (c) 2012年 buaa. All rights reserved.
//

#import "InforController.h"

@implementation InforController

#pragma mark * Setup

- (void)_loadInfoContent
{
//    NSString *  	infoFilePath;
    NSURLRequest *  request;
    
//    infoFilePath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"html"];
//    assert(infoFilePath != nil);
//    
//    request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:infoFilePath]];
//    assert(request != nil);
    
    request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://app.iyuba.com/ios/"]];
    assert(request != nil);
    
    [self.webView loadRequest:request];
}

#pragma mark - My Action
- (void)doSeg:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) {
        [_webView goBack];
    }else
    {
        [_webView reload];
    }
}

#pragma mark * View controller boilerplate

@synthesize webView = _webView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    assert(self.webView != nil);
    
    [self _loadInfoContent];
    UISegmentedControl *segmentedControl=[[UISegmentedControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 30.0f) ];
    [segmentedControl insertSegmentWithTitle:@"回退" atIndex:0 animated:YES];
    [segmentedControl insertSegmentWithTitle:@"重载" atIndex:1 animated:YES];
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentedControl.momentary = YES;
    segmentedControl.multipleTouchEnabled=NO;
    [segmentedControl addTarget:self action:@selector(doSeg:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *segButton = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
//    [segmentedControl release];
    self.navigationItem.rightBarButtonItem = segButton;
//    [segButton release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.webView = nil;
}

//- (void)dealloc
//{
//    [self->_webView release];
//    [super dealloc];
//}

@end
